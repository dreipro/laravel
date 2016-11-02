#!/bin/bash

export USER_HOME="/app"

export USER_ID=$(stat --format=%u ${USER_HOME})
export USER_NAME="${USER:-app}"

export GROUP_ID=$(stat --format=%g ${USER_HOME})
export GROUP_NAME="${USER_NAME}"


echo USER:       $USER
echo USER_NAME:  $USER_NAME
echo USER_ID:    $USER_ID
echo USER_HOME:  $USER_HOME
echo GROUP_NAME: $GROUP_NAME
echo GROUP_ID:   $GROUP_ID

echo dollar-at:  $@



if ! id "${USER_ID}" >/dev/null 2>&1; then
    echo "user does not exist - creating it..."

    groupadd -g ${GROUP_ID} ${GROUP_NAME}
    adduser --shell /bin/bash --uid ${USER_ID} --gid ${GROUP_ID} --no-create-home --disabled-password --gecos '' --home ${USER_HOME} ${USER_NAME}
fi


if [ $USER_ID -eq 0 ]; then

  if [ "$1" == "" ]; then
    exec bash
  else
    exec $@
  fi

else

  if [ "$1" == "" ]; then
    gosu ${USER_NAME} bash
  else
    gosu ${USER_NAME} $@
  fi

fi





