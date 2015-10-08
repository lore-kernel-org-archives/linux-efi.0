From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v4 0/3] arm64: EFI stub isolation
Date: Thu,  8 Oct 2015 20:02:01 +0100
Message-ID: <1444330924-17830-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

We need to ensure that the EFI stub only uses parts of the kernel proper
that are safe to use when the kernel virtual mapping is not active yet.

So move all C code dependencies to the libstub, which is built with all
instrumentation (gcov, kasan) disabled, and do a verification pass to
ensure that no absolute relocations are used.

On the arm64 side, annotate all the stub's dependencies as safe for PI
(position independent

@Matt: if you are OK with these, may we please have your ack on patches #1 and
#2 so that Catalin can pick up the series? Thanks.

Changes since v3:
- expose strcmp() which we will need for EFI stub patches that may enter
  mainline via another subsystem tree
- rebase onto arm64/for-next/core

Changes since v2:
- fold patch that removes the linux_banner from the /chosen node UEFI specific
  properties; if we are all in agreement that we can get rid of it (which I
  think we are), it makes sense to do it straight away, and not export
  linux_banner into the stub now only to remove it later
- tweaked libstub Makefile rules for easier ARM reuse
- rebase onto v4.3-rc4

Changes since v1:
- add .size and .type directives to correctly annotate the __pi_xxx aliases
  as functions of the correct size
- add '#ifndef __HAVE_ARCH_STRSTR' around strstr() definition
- added linux-efi/Matt to cc

Ard Biesheuvel (3):
  arm64/efi: remove /chosen/linux,uefi-stub-kern-ver DT property
  arm64: use ENDPIPROC() to annotate position independent assembler
    routines
  arm64/efi: isolate EFI stub from the kernel proper

 Documentation/arm/uefi.txt            |  2 -
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
 arch/arm64/lib/strcmp.S               |  2 +-
 arch/arm64/lib/strlen.S               |  2 +-
 arch/arm64/lib/strncmp.S              |  2 +-
 arch/arm64/mm/cache.S                 | 10 ++--
 drivers/firmware/efi/libstub/Makefile | 39 +++++++++++---
 drivers/firmware/efi/libstub/fdt.c    |  9 ----
 drivers/firmware/efi/libstub/string.c | 57 ++++++++++++++++++++
 18 files changed, 163 insertions(+), 44 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/string.c

-- 
1.9.1
