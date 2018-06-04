#!/bin/sh

cwd="$PWD"
cd edge/app
clojure -m mach.pack.alpha.one-jar "$cwd/output.jar"
cd $cwd
