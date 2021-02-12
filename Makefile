CONTAINER_RUNTIME ?= $(shell command -v podman 2> /dev/null || shell command -v docker 2> /de/null)
CONTAINER_IMAGE := "ghcr.io/swiftwasm/swiftwasm-action:5.3"


containerized-build: clean
ifndef CONTAINER_RUNTIME
	@printf "Please install either docker or podman"
	exit 1
endif
	$(CONTAINER_RUNTIME) run --rm -v $(PWD):/code --entrypoint /bin/bash $(CONTAINER_IMAGE) -c "cd /code && swift build --triple wasm32-unknown-wasi"

containerized-test:
ifndef CONTAINER_RUNTIME
	@printf "Please install either docker or podman"
	exit 1
endif
	$(CONTAINER_RUNTIME) run --rm -v $(PWD):/code --entrypoint /bin/bash $(CONTAINER_IMAGE) -c "cd /code && carton test"

clean:
	rm -rf .build
	rm -f demo.wasm

.PHONY: release
release: demo.wasm

containerized-release: clean
ifndef CONTAINER_RUNTIME
	@printf "Please install either docker or podman"
	exit 1
endif
	$(CONTAINER_RUNTIME) run --rm -v $(PWD):/code --entrypoint /bin/bash $(CONTAINER_IMAGE) -c "cd /code && swift build -c release --triple wasm32-unknown-wasi"
	@printf "Strip Wasm binary\n"
	$(CONTAINER_RUNTIME) run --rm -v $(PWD):/code --entrypoint /bin/bash $(CONTAINER_IMAGE) -c "cd /code && wasm-strip .build/wasm32-unknown-wasi/release/demo.wasm"
	@printf "Optimize Wasm binary, hold on...\n"
	$(CONTAINER_RUNTIME) run --rm -v $(PWD):/code --entrypoint /bin/bash $(CONTAINER_IMAGE) -c "cd /code && wasm-opt -Os .build/wasm32-unknown-wasi/release/demo.wasm -o demo.wasm"
