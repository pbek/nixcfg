local_image_name := node-vscode
remote_image_name := ghcr.io/pbek/nixcfg-node-vscode:latest
code_dir := $(shell dirname $(CURDIR))

build:
	docker build vscode -t ${local_image_name}

build-no-cache:
	docker build vscode -t ${local_image_name} --no-cache

pull:
	docker pull ${remote_image_name}

# https://github.com/mviereck/x11docker
run-desktop:
	x11docker --xephyr --desktop --network --clipboard --gpu --share "${code_dir}" ${remote_image_name}

run-vscode:
	x11docker --network --clipboard --gpu --share "${code_dir}" ${remote_image_name} -- sh -c "\
		cd "${code_dir}" && \
		npm run playwright:install && \
		code --install-extension ms-playwright.playwright && \
		code --no-sandbox --wait ."
