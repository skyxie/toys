
var path = require('path'),
    _ = require('underscore'),
    fs = require('fs'),
    im = require('imagemagick'),
    tmp = require('tmp'),
    async = require('async'),
    domain = require('domain'),
    aws = require('aws-sdk');

var s3 = new aws.S3({ apiVersion: '2006-03-01' });

console.info("LOADING FUNCTIONS");

function jsonify(obj) {
  return JSON.stringify(obj, undefined, 2);
}

function getS3ObjectStream(baton, cb) {
  console.info("calling getS3ObjectStream with baton: ", baton);

  var params = {
    Bucket: baton.bucket,
    Key: baton.key
  };

  console.log("Retrieving object from S3 with options:\n", jsonify(params));
  s3.getObject(params, function _getObjectCb(err, data) {
    console.log("Retrieved object from S3 of size:"+data.Body.length);
    baton.data = data;
    cb(err, baton);
  });
}

function createTmpFile(baton, cb) {
  console.info("calling createTmpFile with baton: ", baton);

  tmp.tmpName(function _tempFileName(err, tmpFileName) {
    baton.tmpFileName = tmpFileName;
    cb(err, baton);
  });
}

function resize(baton, cb) {
  console.info("calling resize with baton: ", baton);
  console.info("imagemagick resizing image to "+baton.width+"x"+baton.height);

  im.resize({
    srcData: baton.data.Body,
    dstPath: baton.tmpFileName,
    width : baton.width,
    height : baton.height
  }, function _imResizeCb(err, stdout, stderr) {
    cb(err, baton);
  });
}

function readTmpFile(baton, cb) {
  fs.readFile(baton.tmpFileName, function _readFileCb(err, data) {
    baton.tmpFileData = data;
    cb(err, baton);
  })
}

function uploadS3Object(baton, cb) {
  console.info("calling resize with baton: ", baton);

  var extname = path.extname(baton.key),
      name = path.basename(baton.key, path.extname(baton.key)),
      outputkey = path.join("variants", (name + "_" + baton.width + "x" + baton.height + extname)),
      params = {
        Bucket : baton.bucket,
        ACL : "public-read",
        Key : outputkey,
        ContentType : baton.data.ContentType
      };

  console.info("Uploading "+baton.tmpFileData.length+" bytes to S3 with options:\n", jsonify(params));
  params.Body = baton.tmpFileData;

  s3.putObject(params, cb);
}

function fanout(baton, cb) {
  console.info("calling fanout with baton: ", baton);

  async.parallel(
    _.map([64, 128, 2048], function _fan(size) {
      var fanoutbaton = _.extend({width : size, height: size}, baton);
      return function readResizeUpload(readResizeUploadCb) {
        async.waterfall([
          function _seed(cb) { cb(null, fanoutbaton); },
          createTmpFile,
          resize,
          readTmpFile,
          uploadS3Object
        ], readResizeUploadCb);
      };
    }),
    cb
  );
}

exports.handler = function(event, context) {
  console.info("Received event:\n", jsonify(event));

  var _handlerError = function(err) {
    console.error("FATAL ERROR: "+err.message, err.stack);
    context.fail(err);
  }

  var d = domain.create();

  d.on('error', _handlerError);

  d.run(function _handlerRun() {
    // Get the object from the event and show its content type
    var baton = {
      bucket : event.Records[0].s3.bucket.name,
      key : decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, ' '))
    }

    async.waterfall([
      function _seed(cb) { cb(null, baton); },
      getS3ObjectStream,
      fanout
    ], function _cb(err, results) {
      if (err) {
        _handlerError(err);
      } else {
        console.log("Received results: ", jsonify(results));
        context.succeed();
      }
    });
  });
}

