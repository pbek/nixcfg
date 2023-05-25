# Docker development environment

This is a docker setup to run Visual Studio Code with Playwright in a docker container.

```bash
# Allow installation of dependencies via direnv
direnv allow

# Build docker image
make build

# Install Playwright extension and Visual Studio Code
make run-vscode
```
