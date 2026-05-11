.PHONY: install lint yaml syntax check

install:
	ansible-galaxy collection install \
		-r collections/requirements.yml \
		-p collections

lint:
	ansible-lint \
		playbooks \
		roles

yaml:
	yamllint \
		playbooks \
		roles

syntax:
	@for playbook in playbooks/*.yml; do \
		ansible-playbook $$playbook --syntax-check; \
	done

check: yaml lint syntax
