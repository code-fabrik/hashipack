packer {
  required_plugins {
    docker = {
      source  = "github.com/hashicorp/docker"
      version = "~> 1"
    }
  }
}

source "docker" "example" {
  image = "ubuntu:latest"
  commit = true
}

build {
  sources = ["source.docker.example"]
}
