#!/bin/bash

mkdir -p .build

pdflatex -output-directory="./.build" $1
mv ./.build/$1.pdf ./
