#!/usr/bin/env node

var fs = require('fs');
var spawn = require('child_process').spawn

var src = "./src/";
var dest = "../bytecode/";

function filter(path) {
	var extendName = path.substring(path.lastIndexOf('.')+1, path.length);
	extendName = extendName.toLowerCase();
	if (extendName == "lua") {
		return true;
	}
	return false;
}

(function build(src, dest) {
	var lists = fs.readdirSync(src);
	var tempDirs = [];
	if (!fs.existsSync(dest)) {
		fs.mkdirSync(dest);
	}
	lists.forEach(function(path) {
		var fullSrcPath = src + path;
		var fullDestPath = dest + path;
		var stats = fs.lstatSync(fullSrcPath);
		if (stats.isFile()) {
			if (filter(fullSrcPath)) {
				console.log("luajit -b " + fullSrcPath + " " + fullDestPath);
				var ps = spawn("luajit", ["-b", fullSrcPath, fullDestPath]);
				ps.on('error', function (data) {
					console.log('stderr: ' + data);
				});
			}
		} else if(stats.isDirectory()) {
			tempDirs.push(path);
		}
	});
	tempDirs.forEach(function(path) {
		build(src + path + "/", dest + path + "/");
	});
})(src, dest);
