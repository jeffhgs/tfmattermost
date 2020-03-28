
logerror() {
  msg="$1"
  echo "$msg" 1>&2
}

loginfo() {
  msg="$1"
  echo "$msg"
}

check_prereqs() {
  if [[ -z "$AWS_PROFILE" ]]
  then
    logerror "required environment variable: AWS_PROFILE"
    return 1
  fi
  if [[ -z "$AWS_DEFAULT_REGION" ]]
  then
    logerror "required environment variable: AWS_DEFAULT_REGION"
    return 1
  fi
  if [[ -z "$STAGE" ]]
  then
    logerror "required environment variable: STAGE"
    return 1
  fi
  return 0
}

if ! check_prereqs
then
  logerror "*** aborting ***"
else
  if [[ ! -d ".terraform" ]]
  then
    loginfo "about to init"
    terraform init
  fi

  export AWS_SDK_LOAD_CONFIG=1
  loginfo "about to destroy"
  terraform destroy -var-file="${STAGE}.tfvars" .
fi
