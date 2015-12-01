From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 0/7] efi: run UEFI services with interrupts enabled
Date: Tue,  1 Dec 2015 11:50:13 +0100
Message-ID: <1448967020-20190-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The UEFI spec does not require interrupts to be disabled when invoking
runtime services. The reason we have been doing so is because EFI pstore
may call SetVariable() from interrupt context, which may result in deadlock
if another runtime services call was in progress on the same cpu.

The EFI pstore has already been updated to use a non-blocking path and fail
gracefully rather than spin forever, so we can updated the ordinary blocking
wrappers to run with interrupts enabled instead. This aims to prevent excessive
interrupt latencies on uniprocessor platforms with slow variable stores.

Changes since v2:
- added nonblocking QueryVariableInfo() wrapper variant, and updated
  efi_query_variable_store() to use it when called in nonblocking context
- add patch to drop the rtc_lock spinlock
- add patch to drop redundant efi_set_variable_nonblocking_t typedef
- drop BUG_ONs in patch #7

Ard Biesheuvel (7):
  efi: expose non-blocking set_variable() wrapper to efivars
  efi: remove redundant efi_set_variable_nonblocking prototype
  efi: runtime-wrappers: add a nonblocking version of QueryVariableInfo
  efi: add nonblocking option to efi_query_variable_store()
  efi: runtime-wrappers: remove out of date comment regarding in_nmi()
  efi: runtime-wrapper: get rid of the rtc_lock spinlock
  efi: runtime-wrappers: run UEFI Runtime Services with interrupts
    enabled

 arch/x86/platform/efi/quirks.c          |  37 +++++--
 drivers/firmware/efi/efi.c              |   1 +
 drivers/firmware/efi/runtime-wrappers.c | 115 +++++++-------------
 drivers/firmware/efi/vars.c             |  16 ++-
 include/linux/efi.h                     |  21 ++--
 5 files changed, 94 insertions(+), 96 deletions(-)

-- 
1.9.1
