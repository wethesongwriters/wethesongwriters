FROM debian:bookworm


RUN apt-get update && apt-get install -y -q --no-install-recommends \
        apt-transport-https \
        build-essential \
        ca-certificates \
        curl \
        git \
        libssl-dev \
        wget

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Create a script file sourced by both interactive and non-interactive bash shells
# ENV BASH_ENV /home/user/.bash_env
# RUN touch "${BASH_ENV}"
# RUN echo '. "${BASH_ENV}"' >> ~/.bashrc

# update the repository sources list
# and install dependencies
RUN apt-get update \
    && apt-get install -y curl \
    && apt-get -y autoclean

ENV BASH_ENV $HOME/.bash_env
RUN touch "${BASH_ENV}"
RUN echo '. "${BASH_ENV}"' >> ~/.bashrc

# install nvm
# https://github.com/creationix/nvm#install-script
RUN curl --silent -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | PROFILE="${BASH_ENV}" bash

RUN echo node > .nvmrc
RUN nvm install 22 \
  && nvm use 22

# confirm installation
RUN node -v
RUN npm -v

WORKDIR /app
COPY . /app
RUN npm i -g npm@11.1.0 \
  && npm i -g sass \
  && npm i -g esbuild \
  && npm i -g esbuild-sass-plugin

RUN npm install
RUN npm run build

