#
# Copyright (C) 2026 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#

# Release name
PRODUCT_RELEASE_NAME := flare

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)
$(call inherit-product, vendor/twrp/config/common.mk)

## Device identifier
PRODUCT_DEVICE := flare
PRODUCT_NAME := twrp_flare
PRODUCT_BRAND := Redmi
PRODUCT_MODEL := Redmi Pad SE 8.7 WiFi
PRODUCT_MANUFACTURER := Xiaomi

# Inherit some common TWRP stuff
TARGET_BOOT_ANIMATION_RES := 0
