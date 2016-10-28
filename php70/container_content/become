#!/bin/bash -xe

#export USER_NAME="phon"
#export USER_ID="1000"

export USER_NAME=$1
export USER_ID=$2
export GROUP_ID=$3

export GROUP_NAME=${USER_NAME}
export USER_HOME="/app"


env

exit


# USER_NAME=$(stat --format=%U /app)
# USER_ID=$(stat --format=%u /app)
# USER=$(ls -ld /app | awk '{print $3}')
#
# OS - OSX: "Darwin", Linux: "Linux"
# OS=$(uname -s)


if ! id "${USER_NAME}" >/dev/null 2>&1; then
    echo "user does not exist - creating it..."

    groupadd -g ${GROUP_ID} ${GROUP_NAME}
    adduser --shell /bin/bash --uid ${USER_ID} --gid ${GROUP_ID} --no-create-home --disabled-password --home ${USER_HOME} ${USER_NAME}
fi

gosu ${USER} bash

