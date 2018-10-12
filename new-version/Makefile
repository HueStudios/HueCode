.PHONY: all debug clean build-dir run

targets := $(wildcard src/*.fnl)

all: build-dir $(targets)

clean:
	rm -rf ./build
	rm -rf ./release

build-dir:
	mkdir -p build
	cp -a depends/ build/

#FIXME
src/*.fnl: build-dir
	fennel --compile src/$(@F) | tee build/$(basename $(@F)).lua

run: clean all
	love build/

package:
	cd build; zip -r release *
	mkdir -p release
	cd release; mv ../build/release.zip release.love

#patch:
#	echo 'local args = {...}' | cat - build/test.lua > temp && mv temp build/test.lua

#debug: all patch
#	REDACTED
#
deploy: clean all package
