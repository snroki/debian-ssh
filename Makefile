run:
	docker build -t debian-ssh .
	docker run -d -p 2222:22 debian-ssh