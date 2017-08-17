run:
	docker build -t debian-ssh .
	docker run --cap-add=NET_ADMIN -d -p 2222:22 debian-ssh