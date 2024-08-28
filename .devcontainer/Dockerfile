FROM mcr.microsoft.com/devcontainers/ruby:1-3.3-bullseye

# Install packages needed to build gems
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
RUN sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y packer
