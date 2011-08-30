var Fs = require('fs');

var serverjs = "vendor/etherpad-lite/node/server.js";

try
{
    var stats = Fs.lstatSync(serverjs);
    console.log(serverjs + " exists ");
    require(serverjs);
}
catch (e)
{
    console.log(serverjs + ": " + e);
}