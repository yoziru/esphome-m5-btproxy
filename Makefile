.DEFAULT_GOAL := help
BOARD := m5stack-atoms3
PROJECT := esphome-m5-btproxy
TARGET := $(PROJECT)-$(BOARD).yml
HOST_SUFFIX := ""

compile: .esphome/build/$(PROJECT)/.pioenvs/$(PROJECT)/firmware.bin .esphome/build/$(PROJECT)/$(TARGET).touchfile  ## Read the configuration and compile the binary.

.esphome/build/$(PROJECT)/$(TARGET).touchfile: .venv/touchfile $(TARGET) packages/*.yml boards/$(BOARD).yml  ## Validate the configuration and create a binary.
	. .venv/bin/activate; esphome compile $(TARGET)
	touch .esphome/build/$(TARGET).touchfile

.esphome/build/$(PROJECT)/.pioenvs/$(PROJECT)/firmware.bin: .esphome/build/$(PROJECT)/$(TARGET).touchfile ## Create the binary.

upload: .esphome/build/$(PROJECT)/.pioenvs/$(PROJECT)/firmware.bin ## Validate the configuration, create a binary, upload it, and start logs.
	if [ "$(HOST_SUFFIX)" = "" ]; then \
		. .venv/bin/activate; esphome upload $(TARGET); esphome logs $(TARGET); \
	else \
		. .venv/bin/activate; esphome upload $(TARGET) --device $(PROJECT)$(HOST_SUFFIX); esphome logs $(TARGET) --device $(PROJECT)$(HOST_SUFFIX); \
	fi

logs:
	if [ "$(HOST_SUFFIX)" = "" ]; then \
		. .venv/bin/activate; esphome logs $(TARGET); \
	else \
		. .venv/bin/activate; esphome logs $(TARGET) --device $(PROJECT)$(HOST_SUFFIX); \
	fi

deps: .venv/touchfile ## Create the virtual environment and install the requirements.

.venv/touchfile: requirements.txt
	test -d .venv || python -m venv .venv
	. .venv/bin/activate && pip install -Ur requirements.txt
	touch .venv/touchfile

.PHONY: clean
clean: ## Remove the virtual environment and the esphome build directory
	rm -rf .venv
	rm -rf .esphome

.PHONY: help
help: ## Show help messages for make targets
	@grep -E '^[a-zA-\/Z_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'
