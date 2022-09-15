#!/bin/bash

rm -f SuMech.zip

directory=${PWD##*/}
files=(LICENSE README.md SuMech.lua SuMech.txt SuMech.xml Dungeons.lua)
items=( "${files[@]/#/$directory/}" )

tar -caf SuMech.zip -C.. ${items[@]}
