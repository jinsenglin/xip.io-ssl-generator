#!/bin/bash

fly -t myci login --concourse-url $concourse_url
ip=$my_https_server_ip fly -t myci e -c task.yml -i local=.
