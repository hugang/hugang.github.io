#!/bin/env bash

docker run -it --name innox-youtrack  \
    -v /home/hg/proj/docker/youtrack/data:/opt/youtrack/data \
    -v /home/hg/proj/docker/youtrack/conf:/opt/youtrack/conf  \
    -v /home/hg/proj/docker/youtrack/logs:/opt/youtrack/logs  \
    -v /home/hg/proj/docker/youtrack/backups:/opt/youtrack/backups  \
    -p 8080:8080 \
    jetbrains/youtrack:2020.3.9516
