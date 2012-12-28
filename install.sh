#!/bin/bash

gcc -Wall -framework AppKit -framework ScriptingBridge -o $(brew --prefix)/bin/itunes main.m