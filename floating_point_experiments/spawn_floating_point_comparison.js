var path = require('path');
var spawn = require('child_process').spawn;

var process = spawn(path.resolve(__dirname, "floating_point_comparison.py"), ["1000"]);

var data = "";

// process.stdout.on("data", function(chunk) { data += chunk; });
process.on("error", function(error) { console.log("Failed to spawn process: "+error.message); });
process.on("exit", function(code, signal) { console.log(data+"CODE="+code+" SIGNAL="+signal); });
