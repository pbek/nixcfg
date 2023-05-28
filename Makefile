HOSTNAME = $(shell hostname)

test:
	sudo nixos-rebuild test --flake .#${HOSTNAME} -L

switch:
	sudo nixos-rebuild switch --flake .#${HOSTNAME} -L

switch-push: switch push

update:
	nix flake update

upgrade:
	make update && make switch

upgrade-push: upgrade push

push:
	attic push main `which attic` && \
	attic push main `which noseyparker` && \
	attic push qownnotes `which attic` && \
	attic push qownnotes `which qownnotes` && \
	attic push qownnotes `which loganalyzer` && \
	attic push qownnotes `which qc`

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

build-vm:
	nixos-rebuild --flake /etc/nixos#vm build-vm

boot-vm:
	QEMU_OPTS="-m 4096 -smp 4 -enable-kvm" ./result/bin/run-*-vm

boot-vm-no-kvm:
	QEMU_OPTS="-m 4096 -smp 4" ./result/bin/run-*-vm

flake-rebuild-current:
	sudo nixos-rebuild switch --flake .#$(shell hostname)

flake-update:
	nix flake update

#upgrade:
#	sudo nixos-rebuild switch --upgrade
#
#rebuild:
#	sudo nixos-rebuild switch
