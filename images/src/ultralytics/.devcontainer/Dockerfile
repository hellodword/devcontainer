FROM mcr.microsoft.com/devcontainers/cpp:debian-12

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && DEBIAN_FRONTEND="noninteractive" apt-get -y install --no-install-recommends libgl1 && apt-get clean
