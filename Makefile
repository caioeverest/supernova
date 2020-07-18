.DEFAULT_GOAL := install

git_name := $(or $(git_name),${USER})
distro := $(shell cat /etc/*release | grep '^ID=' | sed 's/ID=//' | tr A-Z a-z)

.PHONY: check-params
check-params:
	@$(if $(git_email), echo "You set the email $(git_email)",  echo "you must set a email"; exit 1 )
	@echo "You set the git name as $(git_name)"
	@echo "Your current distro is $(distro)"

.PHONY: prerun
prerun:
ifeq ($(distro), "ubuntu")
	sudo apt update
	sudo apt install ansible
ifeq($(distro), "fedora")
	sudo dnf install ansible
endif
	ansible-galaxy install comcast.sdkman

.PHONY: install
install: check-params prerun
	@ansible-playbook -e var_home_folder=${HOME} -e var_user=${USER} -e var_git_name=$(git_name) -e var_git_email=$(git_email) -k -b --ask-become-pass playbooks/main.yml


