.DEFAULT_GOAL := install

git_name := $(or $(git_name),${USER})

.PHONY: check-params
check-params:
	@$(if $(git_email), echo "You set the email $(git_email)",  echo "you must set a email"; exit 1 )
	@echo "You set the git name as $(git_name)"

.PHONY: prerun
prerun:
	sudo apt update
	sudo apt install ansible
	ansible-galaxy install comcast.sdkman

.PHONY: install
install: check-params prerun
	@ansible-playbook -e var_home_folder=${HOME} -e var_user=${USER} -e var_git_name=$(git_name) -e var_git_email=$(git_email) -k -b --ask-become-pass playbooks/main.yml


