From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v11 0/1] Enable capsule loader interface for efi firmware updating
Date: Fri, 29 Jan 2016 12:39:53 +0800
Message-ID: <1454042394-21507-1-git-send-email-hock.leong.kweh@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ong Boon Leong <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Anvin H Peter <h.peter.anvin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
file operation write() function call.

Tested the code with Intel Quark Galileo GEN1 platform.

Thanks.

---

changelog v11:
* rebase to v4.5-rc1
* correct vocabulary base on Bryan's comments
* Optimise ->pages & ->index code flow base on Matt's comments

changelog v10:
* rebase to v4.4
* added efi runtime services check at efi_capsule_loader_init()
* fixed checkpatch issues
* code clean up base on Borislav's comments

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

 drivers/firmware/efi/Kconfig          |    9 +
 drivers/firmware/efi/Makefile         |    1 +
 drivers/firmware/efi/capsule-loader.c |  334 +++++++++++++++++++++++++++++++++
 drivers/firmware/efi/capsule.c        |    1 +
 4 files changed, 345 insertions(+)
 create mode 100644 drivers/firmware/efi/capsule-loader.c

-- 
1.7.9.5
