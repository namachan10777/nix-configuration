NIX_SOURCES=$(shell find . -type f -name "*.nix")
PKGS=$(shell find pkgs -type f -name "*")
DOTFILES=$(shell find dotfiles -type f -name "*")
# MODULES=$(shell find modules -type f -name "*")
ifeq ($(shell uname), Darwin)
	HOME_MANAGER_HOME=$(HOME)/.nixpkgs
else
	HOME_MANAGER_HOME=$(HOME)/.config/home-manager
endif

.PHONY: home system fmt
fmt: $(NIX_SOURCES)
	nixpkgs-fmt $(NIX_SOURCES)

home: home.nix darwin-configuration.nix $(DOTFILES) $(PKGS)
	./install.sh dotfiles                 $(HOME_MANAGER_HOME)
	./install.sh pkgs                     $(HOME_MANAGER_HOME)
	./install.sh home.nix                 $(HOME_MANAGER_HOME)
	./install.sh darwin-configuration.nix $(HOME_MANAGER_HOME)
	which home-manager && home-manager switch || echo "Please update by nixos-rebuild switch"

system: configuration.nix $(PKGS) # $(MODULES)
	./install.sh pkgs              /etc/nixos
	./install.sh configuration.nix /etc/nixos
	nixos-rebuild test
