rebuild:
	sudo nixos-rebuild switch

upgrade:
	sudo nixos-rebuild switch --upgrade

rekey-age:
	cd ./secrets && agenix -i ~/.ssh/agenix --rekey

rekey-all:
	cd ./secrets && agenix --rekey

keyscan:
	ssh-keyscan localhost
