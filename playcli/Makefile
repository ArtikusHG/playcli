DEBUG = 0
FINALPACKAGE = 1

ARCHS = armv7 arm64 arm64e
include $(THEOS)/makefiles/common.mk

TOOL_NAME = playcli
playcli_FILES = main.m
playcli_PRIVATE_FRAMEWORKS = AppSupport
playcli_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tool.mk
