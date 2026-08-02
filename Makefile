.PHONY: lint test install-hook

lint:
	shellcheck --source-path=SCRIPTDIR install.sh src/*.sh tests/run.sh tests/helpers.bash

test:
	bash tests/run.sh

install-hook:
	cp tests/pre-push .git/hooks/pre-push
	chmod +x .git/hooks/pre-push
	@echo "pre-push hook installed"
