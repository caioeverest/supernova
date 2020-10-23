.DEFAULT_GOAL := install

git_name := $(or $(git_name),${USER})
distro := $(shell cat /etc/*release | grep '^ID=' | sed 's/ID=//' | tr A-Z a-z)
golang_version := "1.15"

#Set package manager
ifeq ($(distro),ubuntu)
	pkgmanager = apt
endif
ifeq ($(distro),elementary)
	pkgmanager = apt
endif
ifeq ($(distro),fedora)
	pkgmanager = dnf
endif
ifeq ($(distro),pop)
	pkgmanager = apt
endif

.PHONY: check-params
check-params:
	@$(if $(git_email), echo "You set the email $(git_email)",  echo "you must set a email"; exit 1 )
	@echo "You set the git name as $(git_name)"
	@echo "Your current distro is $(distro)"

.PHONY: prerun
prerun:
	sudo $(pkgmanager) update -y
	sudo $(pkgmanager) install software-properties-common -y
	#@if [ "$(pkgmanager)" = "apt" ]; then sudo apt-add-repository --yes --update ppa:ansible/ansible; fi
	sudo $(pkgmanager) install -y ansible
	ansible-galaxy install comcast.sdkman

.PHONY: install
install: check-params prerun
	@ansible-playbook \
		-e var_home_folder=${HOME} \
		-e var_user=${USER} \
		-e var_git_name=$(git_name) \
		-e var_git_email=$(git_email) \
		-e var_go_version=$(golang_version) \
		-k -b --ask-become-pass playbooks/main.yml


