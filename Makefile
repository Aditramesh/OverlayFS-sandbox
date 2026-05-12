build:
	docker build -t docker-overlayfs:latest .

run:
	docker run -it --cap-add SYS_ADMIN --security-opt apparmor=unconfined  docker-overlayfs:latest sh

build-and-run: build run
