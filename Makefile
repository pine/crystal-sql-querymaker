.PHONY: default all install test clean

default: all
all: install test

install:
	shards

test:
	crystal spec -v

clean:
	rm -rf .crystal
	rm -rf .shards
