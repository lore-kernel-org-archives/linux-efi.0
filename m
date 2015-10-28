From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: [PATCH v9 0/1] Enable capsule loader interface for efi firmware updating
Date: Thu, 29 Oct 2015 01:58:56 +0800
Message-ID: <1446055138-26047-1-git-send-email-hock.leong.kweh@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ong Boon Leong <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Fleming Matt <matt.fleming@intel.com>, h.peter.anvin@intel.com
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
file operation write() function call.

Tested the code with Intel Quark Galileo GEN1 platform.

Thanks.

---
changelog v9:
* squash 2 patches to become 1 patch
* change function param to pass in cap_info instead of file structure
* perform both alloc inside efi_capsule_setup_info()
* change to use multiple exit labels instead of one function call
* further code clean up base on Matt's comments

changelog v8:
* further clean up on kunmap() & efi_free_all_buff_pages()
* design enhanced to support 1st few writes are less than efi header size
* removed support to padding capsule and flag error once the upload size
  bigger than header defined size

changelog v7:
* add successful message printed in dmesg
* shorten the code in efi_capsule_write() by splitting out
  efi_capsule_setup_info() & efi_capsule_submit_update() functions
* design added capability to support multiple file open action
* re-write those comments by following standard format
* design added the "uncomplete" error return through flush() file operation

changelog v6:
* clean up on error handling for better code flow and review
* clean up on pr_err() for critical error only
* design taking care writing block that below PAGE_SIZE
* once error has occurred, design will return -EIO until file close
* document design expectations/scenarios in the code
* change the dynamic allocation cap_info struct to statically allocated

changelog v5:
* changed to new design without leveraging firmware_class API
* use misc_char device interface instead of sysfs
* error return through file Write() function call


Kweh, Hock Leong (1):
  efi: a misc char interface for user to update efi firmware

 drivers/firmware/efi/Kconfig              |   10
 drivers/firmware/efi/Makefile             |    1
 drivers/firmware/efi/capsule.c            |    1
 drivers/firmware/efi/efi-capsule-loader.c |  356 +++++++++++++++++++++++++++++
 4 files changed, 368 insertions(+)
 create mode 100644 drivers/firmware/efi/efi-capsule-loader.c

-- 
1.7.9.5
