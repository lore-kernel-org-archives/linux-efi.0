From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 0/2] efi/arm*: wire up ESRT table
Date: Mon, 11 Jul 2016 21:00:44 +0200
Message-ID: <1468263646-28184-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This v2 is a followup to the series I sent out on Feb 15. These now
apply onto Matt's memmap refactoring work which is intended for inclusion
in v4.9, and the diffstat below reveals that enabling ESRT is now absolutely
trivial. The only things needed are replacing ioremap() with memremap(),
and adding the missing efi_esrt_init() invocation.

I dropped the Tested-by tags, simply because the underlying code is completely
different now. I kept Peter's ack on #1, though.

Ard Biesheuvel (2):
  efi: esrt: use memremap not ioremap to access ESRT table in memory
  efi/arm*: esrt: add missing call to efi_esrt_init()

 drivers/firmware/efi/arm-init.c | 1 +
 drivers/firmware/efi/esrt.c     | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

-- 
1.9.1
