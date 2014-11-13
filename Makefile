build:
	docker build -t cbayle/docker-tuleap-base .

run:
	docker run --rm=true -t -i cbayle/docker-tuleap-base /bin/bash
