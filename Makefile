rebuild: flake-rebuild-current

rebuild-push: rebuild push

upgrade: flake-update

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

flake-rebuild-current:
	sudo nixos-rebuild switch --flake .#$(shell hostname)

flake-update:
	nix flake update

#upgrade:
#	sudo nixos-rebuild switch --upgrade
#
#rebuild:
#	sudo nixos-rebuild switch
