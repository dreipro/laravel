#!/bin/bash

export COMMAND="${@:-bash}"
export WORKDIR="/app"

export USER_ID=$(stat --format=%u ${WORKDIR})

if [[ $USER_ID -eq 0 ]]; then
  export USER_NAME="root"
else
  export USER_NAME="${USER:-app}"
fi

export USER_HOME="/home/${USER_NAME}"

export GROUP_ID=$(stat --format=%g ${WORKDIR})
export GROUP_NAME="${USER_NAME}"



echo "Executing command '${COMMAND}' as '${USER_NAME}' (uid:${USER_ID}/gid:${GROUP_ID})"

if ! id "${USER_ID}" >/dev/null 2>&1; then
    echo "User id '${USER_ID}' does not exist - creating it..."

    groupadd -g ${GROUP_ID} ${GROUP_NAME}
    adduser --shell /bin/bash --uid ${USER_ID} --gid ${GROUP_ID} --disabled-password --gecos '' --home ${USER_HOME} ${USER_NAME}
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





