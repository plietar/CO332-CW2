#!/usr/bin/env bash
set -eu

function finish {
    git checkout master
}
trap finish EXIT

git log --pretty='%H %s' | while read line
do
    commit=$(echo $line | cut -d' ' -f1)
    name=$(echo $line |  cut -d' ' -f2- | cut -d':' -f1)
    message=$(echo $line |  cut -d' ' -f2- | cut -d':' -f2-)

    if [[ $name == '[skip]' ]]; then
        continue
    fi

    echo "> $message"
    git checkout $commit
    ./run.sh "results/$name" -c -i tourtre-simple/sampledata/CThead.256x256x113.uint16
done
