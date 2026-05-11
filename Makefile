build:
	docker build -t docker-overlayfs:latest .

run:
	docker run -it --privileged docker-overlayfs:latest

build-and-run: build run
