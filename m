From: Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 0/3] Enable user helper interface for efi capsule update
Date: Fri, 24 Oct 2014 14:18:19 +0800
Message-ID: <1414131502-13886-1-git-send-email-hock.leong.kweh@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ong Boon Leong <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hi Guys,

This patchset is created on top of "efi: Capsule update support" patch:
http://permalink.gmane.org/gmane.linux.kernel.efi/4837

It leverages the request_firmware_nowait() to expose the user helper
interface for user to upload the capsule binary and calling the
efi_capsule_update() API to pass the binary to EFI firmware.

Besides build in kernel, the design also cater for build as kernel driver
module. This patchset introduce a new API (request_firmware_abort()) at
firmware_class so that the driver module could be unloaded by calling
the API to properly stop user helper interface and release the device.

Thanks.


Kweh, Hock Leong (3):
  firmware loader: Introduce new API - request_firmware_abort()
  firmware loader: fix hung task warning dump
  efi: Capsule update with user helper interface

 drivers/base/firmware_class.c                  |   34 +++-
 drivers/firmware/efi/Kconfig                   |   13 ++
 drivers/firmware/efi/Makefile                  |    1 +
 drivers/firmware/efi/efi-capsule-user-helper.c |  246 ++++++++++++++++++++++++
 include/linux/firmware.h                       |    4 +
 5 files changed, 296 insertions(+), 2 deletions(-)
 create mode 100644 drivers/firmware/efi/efi-capsule-user-helper.c

-- 
1.7.9.5
