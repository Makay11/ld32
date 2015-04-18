var spawn = require("child_process").spawn;

spawn("node_modules/coffee-script/bin/coffee", "--output server/dist --compile --bare server/src/index.coffee".split(" "), {stdio: "inherit"}).on("close", function () {
  spawn("node", "server/dist/index.js true".split(" "), {stdio: "inherit"});
});
