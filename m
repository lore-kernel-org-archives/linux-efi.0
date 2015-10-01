From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 0/2] arm64: EFI stub isolation
Date: Thu,  1 Oct 2015 14:18:19 +0200
Message-ID: <1443701901-17625-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org
Cc: will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

We need to ensure that the EFI stub only uses parts of the kernel proper
that are safe to use when the kernel virtual mapping is not active yet.

So move all C code dependencies to the libstub, and do a verification pass
to ensure that no absolute relocations are used.

On the arm64 side, annotate all the stub's dependencies as safe for PI
(position independent

Changes since v1:
- add .size and .type directives to correctly annotate the __pi_xxx aliases
  as functions of the correct size
- add '#ifndef __HAVE_ARCH_STRSTR' around strstr() definition
- added linux-efi/Matt to cc

Ard Biesheuvel (2):
  arm64: use ENDPIPROC() to annotate position independent assembler
    routines
  arm64/efi: isolate EFI stub from the kernel proper

 arch/arm64/include/asm/assembler.h    | 11 ++++
 arch/arm64/kernel/Makefile            | 12 ++++-
 arch/arm64/kernel/efi-entry.S         | 10 ++--
 arch/arm64/kernel/head.S              | 14 ++---
 arch/arm64/kernel/image.h             | 27 ++++++++++
 arch/arm64/lib/memchr.S               |  2 +-
 arch/arm64/lib/memcmp.S               |  2 +-
 arch/arm64/lib/memcpy.S               |  2 +-
 arch/arm64/lib/memmove.S              |  2 +-
 arch/arm64/lib/memset.S               |  2 +-
 arch/arm64/lib/strlen.S               |  2 +-
 arch/arm64/lib/strncmp.S              |  2 +-
 arch/arm64/mm/cache.S                 | 10 ++--
 drivers/firmware/efi/libstub/Makefile | 31 +++++++++--
 drivers/firmware/efi/libstub/string.c | 57 ++++++++++++++++++++
 15 files changed, 157 insertions(+), 29 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/string.c

-- 
1.9.1
