#!/bin/sh
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
    # This runs when a pull request is submitted.
    ./run_tests.sh
fi

if [[ "$TRAVIS_BRANCH" == "develop" ]]; then
    # This runs on a merge into develop.
    ./upload_development_container.sh
fi

if [[ "$TRAVIS_BRANCH" == "master" ]]; then
    # This runs on a merge into master.
fi
