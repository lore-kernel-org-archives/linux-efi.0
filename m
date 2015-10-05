From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v7 0/2] Enable capsule loader interface for efi firmware updating
Date: Tue,  6 Oct 2015 04:15:53 +0800
Message-ID: <1444076155-19295-1-git-send-email-hock.leong.kweh@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Ong Boon Leong <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Fleming Matt <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

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
NOTE:
If Matt agrees with this design, [PATCH v7 1/1] will be squash into his
[PATCH 2/2]: https://lkml.org/lkml/2014/10/7/391 for submitting

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


Kweh, Hock Leong (2):
  efi: export efi_capsule_supported() function symbol
  efi: a misc char interface for user to update efi firmware

 drivers/firmware/efi/Kconfig              |   10
 drivers/firmware/efi/Makefile             |    1
 drivers/firmware/efi/capsule.c            |    1
 drivers/firmware/efi/efi-capsule-loader.c |  336 +++++++++++++++++++++++++++++
 4 files changed, 348 insertions(+)
 create mode 100644 drivers/firmware/efi/efi-capsule-loader.c

--
1.7.9.5
