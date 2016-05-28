#!/bin/sh

cp src/index.html src/pomodoro.css elm.js dist/
mkdir -p dist/css
cp node_modules/font-awesome/css/font-awesome.min.css dist/css
mkdir -p dist/fonts
cp -pr node_modules/font-awesome/fonts/ dist/fonts
