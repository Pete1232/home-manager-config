# Work prompt - heavily inspired by the aws plugin
function work_prompt_info() {
  local _work_to_show

  if [[ -n "$DEPLOYMENT_ENV" ]];then
    _work_to_show+="<deploymentEnv:${DEPLOYMENT_ENV}>"
  fi

  echo "$_work_to_show"
}

if [[ "$SHOW_WORK_PROMPT" != false && "$RPROMPT" != *'$(work_prompt_info)'* ]]; then
  RPROMPT='$(work_prompt_info) '"$RPROMPT"
fi
