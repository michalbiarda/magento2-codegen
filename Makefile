.PHONY: up
SHELL=/bin/bash -O extglob -O dotglob -c
SUDO=sudo
PROJECT_TEMP_DIR=project_tmp
TEMP_DIR=module_tmp
MKDIR=mkdir
MV=mv
RM=rm
CP=cp
GIT=git
COMPOSER=composer
PROJECT_FRAMEWORK_REPO=git@bitbucket.org:orbainternalprojects/skeleton.git
EDITION=community
VERSION=2.3.4-p2
up:
	$(MKDIR) $(TEMP_DIR)
	$(MV) -t $(TEMP_DIR)/ !($(TEMP_DIR))
	$(GIT) clone $(PROJECT_FRAMEWORK_REPO) $(PROJECT_TEMP_DIR)
	$(RM) -rf ./$(PROJECT_TEMP_DIR)/.git
	$(MV) -t . ./$(PROJECT_TEMP_DIR)/*
	$(RM) -d $(PROJECT_TEMP_DIR)
	$(MAKE) new project=orba version=$(VERSION) edition=$(EDITION) ca=0
	$(CP) -r ./$(TEMP_DIR)/make/.idea ./.idea
	$(CP) -r ./$(TEMP_DIR)/make/source/magento ./source
	$(MKDIR) -p source/magento/lib/internal/codegen
	$(MV) ./module_tmp/* ./source/magento/lib/internal/codegen
	$(RM) -d module_tmp
	$(COMPOSER) install -d ./source/magento/lib/internal/codegen
	$(SUDO) $(MAKE) hosts
	$(MAKE) up
