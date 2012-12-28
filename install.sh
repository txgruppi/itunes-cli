#!/bin/bash

mkdir -p $1/bin
gcc -Wall -framework AppKit -framework ScriptingBridge -o $1/bin/itunes main.m