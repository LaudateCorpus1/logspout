FROM bountylabs/docker-alpine
MAINTAINER Jeff Lindsay <progrium@gmail.com>

ADD ./logspout /bin/logspout

ENV DOCKER_HOST unix:///tmp/docker.sock
ENV ROUTESPATH /mnt/routes
VOLUME /mnt/routes

EXPOSE 8000

ENTRYPOINT ["/bin/logspout"]
CMD []
