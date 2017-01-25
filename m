From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 0/2] efi/arm64: add vmlinux link to PE/COFF debug table
Date: Wed, 25 Jan 2017 10:39:17 +0000
Message-ID: <1485340759-28975-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Much like GNU debug links, PE/COFF binaries can carry the path on the build
host to the binary containing the debugging symbols. Since the kernel binary
is loaded by UEFI at an a priori unknown offset in the 1:1 mapping of physical
memory, having this information is useful for the debugger automation to find
the file and the offset, and load the symbols automatically.

So if we have debugging symbols to begin with (CONFIG_DEBUG_INFO=y), add the
absolute path to vmlinux to the PE/COFF debug table.

v2: rebase onto v4.10-rc
    use strip rather than objcopy for first pass (#1)
    move debug table inside #ifdef CONFIG_EFI region in head.S (#2)

Ard Biesheuvel (2):
  efi: libstub: Preserve .debug sections after absolute relocation check
  arm64: efi: add vmlinux debug link to the Image binary

 arch/arm64/kernel/Makefile            |  4 +++
 arch/arm64/kernel/head.S              | 34 +++++++++++++++++++-
 arch/arm64/kernel/image.h             |  3 ++
 drivers/firmware/efi/libstub/Makefile | 24 +++++++++-----
 4 files changed, 56 insertions(+), 9 deletions(-)

-- 
2.7.4
