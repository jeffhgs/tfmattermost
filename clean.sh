
check_prereqs() {
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
  # superclean: rm -rf .terraform
  rm -f "${STAGE}.plan"
fi
