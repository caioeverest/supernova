.DEFAULT_GOAL := install

git_name       := $(or $(git_name),${USER})
distro         := $(shell cat /etc/*release | grep '^ID=' | sed 's/ID=//' | tr A-Z a-z)
golang_version := "1.17.6"
k9s_version    := "0.24.2"
kernel         := "linux"
arch           := "amd64"

.PHONY: check-params
check-params:
	@$(if $(git_email), echo "You set the email $(git_email)",  echo "you must set a email"; exit 1 )
	@echo "You set the git name as $(git_name)"
	@echo "Your current distro is $(distro)"

#Set package manager
.PHONY: prerun
prerun:
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ifeq ($(distro),$(filter $(distro),ubuntu pop))
	sudo apt update -y
	sudo apt install software-properties-common -y
	sudo apt-add-repository --yes --update ppa:ansible/ansible
	sudo apt install -y ansible
endif
ifeq ($(distro),fedora)
	sudo dnf update -y
	#sudo dnf install software-properties-common -y
	sudo dnf install -y ansible
endif
ifeq ($(distro),macos)
	kernel := "darwin"
	arch   := "arm64"
	xcode-select --install
	brew install ansible
endif

.PHONY: install
install: check-params prerun
	@ansible-playbook \
		-e var_home_folder=${HOME} \
		-e var_user=${USER} \
		-e var_git_name=$(git_name) \
		-e var_git_email=$(git_email) \
		-e var_go_version=$(golang_version) \
		-e var_k9s_version=$(k9s_version) \
		-e var_kernel=$(kernel) \
		-e var_arch=$(arch) \
		-k -b --ask-become-pass playbooks/main.yml
