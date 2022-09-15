#!/bin/bash

directory=${PWD##*/}
files=(LICENSE README.md SuMech.lua SuMech.txt SuMech.xml Dungeons.lua)
items=( "${files[@]/#/$directory/}" )

echo ${files[@]}
echo ${directory}
echo ${items[@]}
tar -caf SuMech.zip -C.. ${items[@]}
