.PHONY: test switch switch-push update upgrade upgrade-push push push-all rekey-fallback rekey keyscan build-iso boot-iso build-vm boot-vm boot-vm-no-kvm flake-rebuild-current flake-update upgrade rebuild cleanup repair-store

HOSTNAME = $(shell hostname)
USER = $(shell whoami)

test:
	sudo nixos-rebuild test --flake .#${HOSTNAME} -L

nix-switch:
	sudo nixos-rebuild switch --flake .#${HOSTNAME} -L

switch:
	nix-shell --run "nh os switch -H ${HOSTNAME} ."

nix-build:
	sudo nixos-rebuild build --flake .#${HOSTNAME}

build:
	nix-shell --run "nh os build -H ${HOSTNAME} ."

build-on-caliban:
	nixos-rebuild --build-host omega@caliban.netbird.cloud --flake .#${HOSTNAME} build

# TODO: "--build-host" not found
nh-build-on-caliban:
	nix-shell --run "nh os build -H ${HOSTNAME} . -- --build-host omega@caliban.netbird.cloud"

build-on-home01:
	nixos-rebuild --build-host omega@home01.lan --flake .#${HOSTNAME} build

# TODO: "--build-host" not found
nh-build-on-home01:
	nix-shell --run "nh os build -H ${HOSTNAME} . -- --build-host omega@home01.lan"

switch-push:
	make switch; make push

switch-push-all:
	make switch && make push-all; make push

update:
	NIX_CONFIG="access-tokens = github.com=`cat ~/.secrets/github-token`" nix flake update

upgrade:
	make update && make switch

upgrade-push:
	make upgrade; make push

upgrade-push-all:
	make upgrade && make push-all; make push

push:
	attic push main `which espanso` && \
#	attic push main `which gittyup` && \
#	attic push main `which go-passbolt-cli` && \
#	attic push main `which wowup-cf` && \
#	attic push main `which smartgithg` && \
	attic push qownnotes `which qownnotes` && \
#	attic push qownnotes `which loganalyzer` && \
	attic push qownnotes `which qc`

# Far too slow
push-all:
	./scripts/push-all-to-attic.sh

# Too slow
push-local:
	attic push --ignore-upstream-cache-filter cicinas2:nix-store `which phpstorm` && \
	attic push --ignore-upstream-cache-filter cicinas2:nix-store `which clion` && \
	attic push --ignore-upstream-cache-filter cicinas2:nix-store `which goland`

rekey-fallback:
	cd ./secrets && agenix -i ~/.ssh/agenix --rekey

rekey:
	cd ./secrets && agenix --rekey

keyscan:
	ssh-keyscan localhost

build-iso:
	nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix

boot-iso:
	# -enable-kvm
	nix-shell -p qemu --run "qemu-system-x86_64 -m 256 -cdrom result/iso/nixos-*.iso"

boot-vm:
	QEMU_OPTS="-m 4096 -smp 4 -enable-kvm" QEMU_NET_OPTS="hostfwd=tcp::2222-:22" ./result/bin/run-*-vm

boot-vm-no-kvm:
	QEMU_OPTS="-m 4096 -smp 4" QEMU_NET_OPTS="hostfwd=tcp::2222-:22" ./result/bin/run-*-vm

# Runs a built VM with a console
# Quit with Ctrl-A X
# If there is an issue with the VM, try to do a "reset-vm" first.
boot-vm-console:
	QEMU_OPTS="-nographic -serial mon:stdio" QEMU_KERNEL_PARAMS=console=ttyS0 QEMU_NET_OPTS="hostfwd=tcp::2222-:22" ./result/bin/run-*-vm

# Runs a built server VM with a console
# Quit with Ctrl-A X
# If there is an issue with the VM, try to do a "reset-vm" first.
# Connect to the server with: ssh -p 2222 omega@localhost -t "tmux new-session -A -s pbek"
boot-vm-server-console:
	QEMU_OPTS="-nographic -serial mon:stdio" QEMU_KERNEL_PARAMS=console=ttyS0 QEMU_NET_OPTS="hostfwd=tcp::2222-:2222" ./result/bin/run-*-vm

# Connect to a running server VM with ssh
ssh-vm-server:
	ssh -p 2222 omega@localhost -t "tmux new-session -A -s pbek"

reset-vm:
	rm *.qcow2

ssh-vm:
	ssh -p 2222 omega@localhost -t "tmux new-session -A -s pbek"

build-vm-desktop:
	nixos-rebuild --flake .#vm-desktop build-vm

build-vm-server:
	nixos-rebuild --flake .#vm-server build-vm

# Build a VM for the server netcup02
build-vm-netcup02:
	nixos-rebuild --flake .#vm-netcup02 build-vm

flake-rebuild-current:
	sudo nixos-rebuild switch --flake .#$(shell hostname)

flake-update:
	nix flake update

#upgrade:
#	sudo nixos-rebuild switch --upgrade
#
#rebuild:
#	sudo nixos-rebuild switch

cleanup:
	duf; \
	sudo journalctl --vacuum-time=3d; \
	docker system prune -f; \
	rm -rf ~/.local/share/Trash/*; \
	sudo nix-collect-garbage -d; \
	nix-collect-garbage -d; \
	duf

repair-store:
	sudo nix-store --verify --check-contents --repair

list-generations:
	nix profile history --profile /nix/var/nix/profiles/system

optimize-store:
	duf; \
	nix store optimise; \
	duf

fwup:
	fwupdmgr refresh; fwupdmgr update

term:
	zellij --layout term.kdl attach nixcfg -c

term-kill:
	zellij delete-session nixcfg -f

# Replace current shell with new instance of fish
fish-replace:
	exec fish

linter-check:
	statix check

linter-fix:
	statix fix

update-channels:
	sudo nix-channel --update

fix-command-not-found-error:
	make update-channels

# Can be used the warm up the cache at home
nix-build-venus:
	nixos-rebuild --flake .#venus build

# Can be used the warm up the cache at home
build-venus:
	nix-shell --run "nh os build -H venus ."

home-manager-logs:
	sudo journalctl --since today | grep "hm-activate-" | bat

home-manager-status:
	systemctl status home-manager-$(shell whoami).service

home01-restart-nix-serve:
	systemctl restart nix-serve

edit-qownnotes-build:
	kate ./apps/qownnotes/default.nix -l 23 -c 19

shell:
	nix-shell --run fish

qownnotes-hash:
	@version=$$(gum input --placeholder "QOwnNotes version number") && \
		url="https://github.com/pbek/QOwnNotes/releases/download/v$${version}/qownnotes-$${version}.tar.xz" && \
		nix-prefetch-url "$$url" | xargs nix hash to-sri --type sha256
