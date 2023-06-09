.PHONY: test switch switch-push update upgrade upgrade-push push push-all rekey-fallback rekey keyscan build-iso boot-iso build-vm boot-vm boot-vm-no-kvm flake-rebuild-current flake-update upgrade rebuild cleanup repair-store

HOSTNAME = $(shell hostname)

test:
	sudo nixos-rebuild test --flake .#${HOSTNAME} -L

switch:
	sudo nixos-rebuild switch --flake .#${HOSTNAME} -L

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
	attic push main `which attic` && \
	attic push main `which noseyparker` && \
	attic push qownnotes `which qownnotes` && \
	attic push qownnotes `which loganalyzer` && \
	attic push qownnotes `which qc`

push-all:
	./scripts/push-all-to-attic.sh

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

# Quit with Ctrl-A X
# If there is an issue with the VM, try to do a "reset-vm" first.
boot-vm-console:
	QEMU_OPTS="-nographic -serial mon:stdio" QEMU_KERNEL_PARAMS=console=ttyS0 QEMU_NET_OPTS="hostfwd=tcp::2222-:22" ./result/bin/run-*-vm

reset-vm:
	rm nixos.qcow2

ssh-vm:
	ssh -p 2222 omega@localhost -t "tmux new-session -A -s pbek"

build-vm-desktop:
	nixos-rebuild --flake .#vm-desktop build-vm

build-vm-server:
	nixos-rebuild --flake .#vm-server build-vm

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
	df -h; \
    sudo journalctl --vacuum-time=3d; \
    docker system prune -f; \
    rm -rf .local/share/Trash/*; \
	sudo nix-collect-garbage -d; \
	nix-collect-garbage -d; \
	df -h

repair-store:
	nix-store --verify --check-contents --repair

list-generations:
	nix profile history --profile /nix/var/nix/profiles/system
