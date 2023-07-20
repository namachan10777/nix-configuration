NIX_SOURCES=$(shell find . -type f -name "*.nix")
FISH=$(shell find fish -type f -name "*")
NEOVIM=$(shell find neovim -type f -name "*")
PKGS=$(shell find pkgs -type f -name "*")
MODULES=$(shell find modules -type f -name "*")
HOME_MANAGER_HOME=$(HOME)/.config/home-manager

.PHONY: home system fmt
fmt: $(NIX_SOURCES)
	nixpkgs-fmt $(NIX_SOURCES)

home: home.nix darwin-configuration.nix $(FISH) $(NEOVIM) $(PKGS)
	install -m 644 -D fish/*                $(HOME_MANAGER_HOME)/fish
	install -m 644 -D neovim/config/*       $(HOME_MANAGER_HOME)/neovim/config
	install -m 644 -D pkgs/*                $(HOME_MANAGER_HOME)/pkgs
	install -m 644 home.nix                 $(HOME_MANAGER_HOME)/home.nix
	install -m 644 darwin-configuration.nix $(HOME_MANAGER_HOME)/darwin-configuration.nix
	home-manager switch

system: configuration.nix $(PKGS) $(MODULES)
	install -m 644 -D pkgs/* /etc/nixos/pkgs
	install -m 644 configuration.nix /etc/nixos/configuration.nix
	nixos-rebuild test