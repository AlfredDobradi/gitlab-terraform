#!/bin/sh
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt-get install -y gitlab-runner docker-compose
sudo gitlab-runner register -u '${gitlab_url}' -r '${gitlab_token}' --tag-list 'aws,docker' --executor docker --docker-image 'golang:1.14-buster' --locked false --run-untagged -n
sudo gitlab-runner start