.PHONY: install set-link setup scripts-perms

scripts-perms:
	chmod +x scripts/*.sh

install: scripts-perms
	./scripts/install.sh

set-link: scripts-perms
	./scripts/set-link.sh

setup: install set-link
