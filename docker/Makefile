image_name := node-vscode
code_dir := $(shell dirname $(CURDIR))

build:
	docker build vscode -t ${image_name}

build-no-cache:
	docker build vscode -t ${image_name} --no-cache

# https://github.com/mviereck/x11docker
# x11docker --xephyr --composite --desktop --wm nix-vscode /usr/bin/xeyes
# x11docker --xephyr --desktop --size 1200x1000 nix-vscode /usr/bin/code --no-sandbox -w -i
# x11docker --network --clipboard --gpu --share ~/Code nix-vscode
run-desktop:
	x11docker --xephyr --desktop --network --clipboard --gpu --share "${code_dir}" ${image_name}

run-vscode:
	x11docker --network --clipboard --gpu --share "${code_dir}" ${image_name} -- sh -c "\
		cd "${code_dir}" && \
		npm run playwright:install && \
		code --install-extension ms-playwright.playwright && \
		code --no-sandbox --wait ."
