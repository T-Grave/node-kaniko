FROM gcr.io/kaniko-project/executor:v1.8.1-debug AS kaniko

FROM node:18 AS nx
RUN npm install -g nx

FROM node:18-alpine

COPY --from=kaniko /kaniko/.docker /kaniko/.docker
COPY --from=kaniko /kaniko/executor /kaniko/executor
COPY --from=kaniko /kaniko/ssl /kaniko/ssl
COPY --from=kaniko /kaniko/warmer /kaniko/warmer


COPY --from=nx /usr/local/lib /usr/local/lib
RUN ln -s /usr/local/lib/node_modules/nx/bin/nx.js /usr/local/bin/nx

ENV HOME /root
ENV USER /root
ENV PATH $PATH:/kaniko:/usr/local/lib/node_modules/nx/bin
ENV SSL_CERT_DIR /kaniko/ssl/certs
ENV DOCKER_CONFIG /kaniko/.docker/