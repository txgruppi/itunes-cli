build:
	clang -Wall -framework AppKit -framework ScriptingBridge -o itunes main.m

clean:
	rm itunes

install: build
	mv ./itunes ~/bin/itunes

doc:
	docco -o doc main.m

.PHONY: clean doc

.SILENT: build clean install doc