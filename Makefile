rebuild:
	sudo nixos-rebuild switch

upgrade:
	sudo nixos-rebuild switch --upgrade

rekey-fallback:
	cd ./secrets && agenix -i ~/.ssh/agenix --rekey

rekey:
	cd ./secrets && agenix --rekey

keyscan:
	ssh-keyscan localhost
