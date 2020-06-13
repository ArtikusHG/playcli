DEBUG = 0
FINALPACKAGE = 1

ARCHS = armv7 arm64 arm64e

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Play
Play_FILES = Tweak.x
Play_FRAMEWORKS = AVFoundation
Play_PRIVATE_FRAMEWORKS = AppSupport
Play_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += playcli
include $(THEOS_MAKE_PATH)/aggregate.mk
