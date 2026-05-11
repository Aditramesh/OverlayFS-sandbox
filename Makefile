build:
	docker build -t docker-overlayfs:latest .

run:
	docker run -it --privileged --rm --name overlay-test docker-overlayfs:latest

build-and-run: build run
