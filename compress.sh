#!/bin/bash

# Compress all files in the current directory and subdirectories to a single .zip file.

cd 

find ~ \( -type d -name 'node_modules' -prune \) -o \( -type f -name 'package.json' -exec dirname {} \; \) | uniq




#24121935048