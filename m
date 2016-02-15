From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 0/2] efi: ARM/arm64: wire up ESRT table
Date: Mon, 15 Feb 2016 12:32:31 +0100
Message-ID: <1455535953-5056-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

As reported by Tyler, the ESRT support was not wired up yet for ARM or
arm64, hence this series.

Patch #1 replaces ioremap with memremap in the generic ESRT support, since
what we are mapping is not I/O, and this does make a difference on ARM/arm64

Patch #2 adds the missing efi_esrt_init() call, and tweaks some memmap fields
that efi_mem_desc_lookup() expects.

Ard Biesheuvel (2):
  efi: esrt: use memremap not ioremap to access ESRT table in memory
  arm64/efi: esrt: add missing call to efi_esrt_init()

 drivers/firmware/efi/arm-init.c |  3 +++
 drivers/firmware/efi/esrt.c     | 16 ++++++++--------
 2 files changed, 11 insertions(+), 8 deletions(-)

-- 
2.5.0
