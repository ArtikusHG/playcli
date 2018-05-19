ARCHS = armv7 armv7s arm64
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Play
Play_FILES = Tweak.xm
Play_FRAMEWORKS = AVFoundation
Play_PRIVATE_FRAMEWORKS = AppSupport

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += playcli
include $(THEOS_MAKE_PATH)/aggregate.mk
