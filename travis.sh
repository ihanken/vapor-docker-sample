#!/bin/bash
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
    # This runs when a pull request is submitted.
    ls -al
    sudo docker build -t vapor-example .
    sudo docker run -d -p 8080:8080 vapor-example
    sudo docker ps -a
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
