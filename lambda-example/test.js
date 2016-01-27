var aws = require('aws-sdk');

var f = require('./index');

var c = {
      fail : function _fail(message) {
        console.log("FAILURE: "+message);
      },
      succeed : function _succeed() {
        console.log("SUCCESS");
      }
    },
    e = {
      "Records": [{
        "s3": {
          "bucket": {
            "name": "tian-lambda"
          },
          "object": {
            "key": "original.jpg",
          }
        }
      }]
    };

f.handler(e, c);
