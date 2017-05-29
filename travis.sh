#!/bin/bash
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
    # This runs when a pull request is submitted.
    apt-get install docker-ce
    apt-get update
    docker build -t vapor-example .
    docker run -d -p 8080:8080 vapor-example
    docker ps -a
    exit $?
fi

if [[ "$TRAVIS_BRANCH" == "develop" ]]; then
    # This runs on a merge into develop.
    sh ./upload_development_container.sh
    exit $?
fi

if [[ "$TRAVIS_BRANCH" == "master" ]]; then
    # This runs on a merge into master.
    exit $?
fi
