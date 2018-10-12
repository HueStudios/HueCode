.PHONY: all debug clean build-dir run

targets := $(wildcard src/*.fnl)

all: build-dir $(targets)

clean:
	rm -rf ./build

build-dir:
	mkdir -p build

#FIXME
src/*.fnl: build-dir
	fennel --compile src/$(@F) | tee build/$(basename $(@F)).lua

#patch:
#	echo 'local args = {...}' | cat - build/test.lua > temp && mv temp build/test.lua

#debug: all patch
#	REDACTED
#
#deploy: all patch
#	REDACTED
