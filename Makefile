rebuild:
	sudo nixos-rebuild switch

upgrade:
	sudo nixos-rebuild switch --upgrade

rekey:
	cd ./secrets && agenix -i ~/.ssh/agenix --rekey
