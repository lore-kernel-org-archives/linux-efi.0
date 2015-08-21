From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: [PATCH v5 0/2] Enable capsule loader interface for efi firmware
Date: Fri, 21 Aug 2015 19:34:46 +0800
Message-ID: <1440156888-25796-1-git-send-email-hock.leong.kweh@intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ong Boon Leong <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Fleming Matt <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>

Dear maintainers & communities,

This patchset is created on top of Matt's patchset:
1.)https://lkml.org/lkml/2014/10/7/390
"[PATCH 1/2] efi: Move efi_status_to_err() to efi.h"
2.)https://lkml.org/lkml/2014/10/7/391
"[PATCH 2/2] efi: Capsule update support"

It expose a misc char interface for user to upload the capsule binary and
calling efi_capsule_update() API to pass the binary to EFI firmware.

The steps to update efi firmware are:
1.) cat firmware.cap > /dev/efi_capsule_loader
2.) reboot

Any failed upload error message will be returned while doing "cat" through
Write() function call.

Tested the code with Intel Quark Galileo platform.

Thanks.

---
changelog v5:
* changed to new design without leveraging firmware_class API
* use misc_char device interface instead of sysfs
* error return through file Write() function call


Kweh, Hock Leong (2):
  efi: export efi_capsule_supported() function symbol
  efi: a misc char interface for user to update efi firmware

 drivers/firmware/efi/Kconfig              |   10 ++
 drivers/firmware/efi/Makefile             |    1
 drivers/firmware/efi/capsule.c            |    1
 drivers/firmware/efi/efi-capsule-loader.c |  218 +++++++++++++++++++++++++++++
 4 files changed, 230 insertions(+)
 create mode 100644 drivers/firmware/efi/efi-capsule-loader.c

-- 
1.7.9.5

