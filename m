From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/4] efi: run UEFI services with interrupts enabled
Date: Thu, 19 Nov 2015 14:36:27 +0100
Message-ID: <1447940191-30705-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The UEFI spec does not require interrupts to be disabled when invoking
runtime services. The reason we have been doing so is because EFI pstore
may call SetVariable() from interrupt context, which may result in deadlock
if another runtime services call was in progress on the same cpu.

The EFI pstore has already been updated to use a non-blocking path and fail
gracefully rather than spin forever, so we can updated the ordinary blocking
wrappers to run with interrupts enabled instead.

The first 3 patches fix a couple of bugs and remove a stale comment. Patch #4
actually implements the above.

Ard Biesheuvel (4):
  efi: expose non-blocking set_variable() wrapper to efivars
  efi: efivars: don't rely on blocking operations in non-blocking
    set_var()
  efi: runtime-wrappers: remove out of date comment regarding in_nmi()
  efi: runtime-wrappers: run UEFI Runtime Services with interrupts
    enabled

 drivers/firmware/efi/efi.c              |   1 +
 drivers/firmware/efi/runtime-wrappers.c | 114 +++++++++-----------
 drivers/firmware/efi/vars.c             |  12 +--
 3 files changed, 53 insertions(+), 74 deletions(-)

-- 
1.9.1
