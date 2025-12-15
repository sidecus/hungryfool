NAME := hungryfool

.PHONY: run create

create:
	./create-post.sh

run:
	hugo server -D  
