PWD  := $(shell pwd)

build:
	docker run --rm \
      -v "$(PWD):/workspace" \
      -w /workspace \
      --platform linux/amd64 \
      swift:5.7-bionic  \
      /bin/bash -cl ' \
         swift build --static-swift-stdlib && \
         rm -rf .build/install && mkdir -p .build/install && \
         cp -P .build/debug/docgen .build/install/'
