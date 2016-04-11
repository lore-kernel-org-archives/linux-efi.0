From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 0/2] efi: Delete global 'memmap' variable
Date: Mon, 11 Apr 2016 14:03:27 +0100
Message-ID: <1460379809-18490-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Ard's recent EFI memory attributes table patches caused ia64 build
failures due to the use of the global 'memmap' EFI memory map object,
which doesn't exist on ia64.

That failure prompted me to dig out these two patches that delete
'memmap' once and for all and replace all occurrences with
'efi.memmap'.

And because all call sites are now using 'efi.memmap'
for_each_efi_memory_desc() can implicitly use that object instead of
requiring it to be passed as an argument.

Matt Fleming (2):
  efi: Iterate over efi->memmap in for_each_efi_memory_desc
  efi: Remove global 'memmap'

 arch/x86/platform/efi/efi.c                    | 125 ++++++++++++-------------
 arch/x86/platform/efi/efi_64.c                 |  10 +-
 arch/x86/platform/efi/quirks.c                 |  10 +-
 drivers/firmware/efi/arm-init.c                |  20 ++--
 drivers/firmware/efi/arm-runtime.c             |  15 +--
 drivers/firmware/efi/efi.c                     |   8 +-
 drivers/firmware/efi/fake_mem.c                |  43 +++++----
 drivers/firmware/efi/libstub/efi-stub-helper.c |   6 +-
 include/linux/efi.h                            |  14 ++-
 9 files changed, 121 insertions(+), 130 deletions(-)

-- 
2.7.3
