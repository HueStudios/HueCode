.PHONY: all debug clean build-dir run

targets := $(wildcard src/*.fnl)

clean:
	rm -rf ./build
	rm -rf ./release

all: clean build-dir $(targets)

build-dir:
	mkdir -p build
	cp -a depends/ build/

src/*.fnl: build-dir
	fennel --compile src/$(@F) | tee build/$(basename $(@F)).lua

run: deploy
	love release/release.love

package: all
	cd build; zip -r release *
	mkdir -p release
	cd release; mv ../build/release.zip release.love

debug: all
	love build/
#
deploy: all package
