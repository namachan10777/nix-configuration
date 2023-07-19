NIX_SOURCES=$(shell find . -type f -name "*.nix")
FISH=$(shell find fish -type f -name "*")
NEOVIM=$(shell find neovim -type f -name "*")
PKGS=$(shell find pkgs -type f -name "*")
MODULES=$(shell find modules -type f -name "*")

.PHONY: home system fmt
fmt: $(NIX_SOURCES)
	nixpkgs-fmt $(NIX_SOURCES)

home: home.nix $(FISH) $(NEOVIM) $(PKGS)
	install -m 755 -D fish/* $(HOME)/.config/home-manager/fish
	install -m 755 -D neovim/config/* $(HOME)/.config/home-manager/neovim/config
	install -m 755 -D pkgs/* $(HOME)/.config/home-manager/pkgs
	install -m 755 home.nix $(HOME)/.config/home-manager/home.nix
	home-manager switch

system: configuration.nix $(PKGS) $(MODULES)
	install -m 755 -D pkgs/* /etc/nixos/pkgs
	install -m 755 -D modules/* /etc/nixos/modules
	install -m 755 configuration.nix /etc/nixos/configuration.nix
	nixos-rebuild test