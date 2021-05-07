#!/bin/bash

echo "fix gitlab_server unicorn error"
docker exec -it gitlab_server rm /home/git/gitlab/tmp/pids/unicorn.pid && docker restart gitlab_server
