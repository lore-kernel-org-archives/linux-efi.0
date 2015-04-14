From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 0/2] Enable capsule loader interface for efi firmware updating
Date: Tue, 14 Apr 2015 17:44:54 +0800
Message-ID: <1429004697-28320-1-git-send-email-hock.leong.kweh@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Ong Boon Leong <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Dear maintainers & communities,

This patchset is created on top of "efi: Capsule update support" patch:
http://permalink.gmane.org/gmane.linux.kernel.efi/4837

It expose a sysfs loader interface for user to upload the capsule binary
and calling efi_capsule_update() API to pass the binary to EFI firmware.

Thanks.

---
changelog v4:
* rebase the firmware_class to gregkh/driver-core.git#driver-core-next
  branch and drop the v3 2nd patch as Zahari already fix that in that
  branch


changelog v3:
* changes base on the design discussion in the mailing list:
  https://lkml.org/lkml/2015/2/24/307
* 1st patch introduce a new API request_firmware_direct_full_path() in
  firmware_class for developer to pass in full path to the firmware file
* 2nd patch fix a bug for commit "firmware_loader: handle timeout via
  wait_for_completion_interruptible_timeout()"
* 3rd patch introduce the capsule loader interface kernel module


Kweh, Hock Leong (2):
  firmware_loader: introduce new API -
    request_firmware_direct_full_path()
  efi: an sysfs interface for user to update efi firmware

 drivers/base/firmware_class.c             |   46 +++++++-
 drivers/firmware/efi/Kconfig              |   12 ++
 drivers/firmware/efi/Makefile             |    1
 drivers/firmware/efi/efi-capsule-loader.c |  169 +++++++++++++++++++++++++++++
 include/linux/firmware.h                  |    9 ++
 5 files changed, 232 insertions(+), 5 deletions(-)
 create mode 100644 drivers/firmware/efi/efi-capsule-loader.c

-- 
1.7.9.5
