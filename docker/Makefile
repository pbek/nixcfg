build:
	docker compose build

build-no-cache:
	docker compose build --no-cache

bash:
	docker compose run vscode bash

root-bash:
	docker compose run --user root vscode bash

# https://github.com/mviereck/x11docker
# x11docker --xephyr --composite --desktop --wm nix-vscode /usr/bin/xeyes
# x11docker --xephyr --desktop --size 1200x1000 nix-vscode /usr/bin/code --no-sandbox -w -i
# x11docker --network --clipboard --gpu --share ~/Code nix-vscode
run-desktop:
	x11docker --xephyr --desktop --network --clipboard --gpu --share ~/Code nix-vscode

run-vscode:
	x11docker --network --clipboard --gpu --share ~/Code nix-vscode -- sh -c "\
		cd ~/Code/VPU/e2e-tests-ng && \
		npm run playwright:install && \
		code --install-extension ms-playwright.playwright && \
		code --no-sandbox --wait ."