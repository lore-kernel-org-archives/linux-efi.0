From: Maksym Kokhan <maksym.kokhan@globallogic.com>
Subject: [PATCH 0/8] add generic builtin command line
Date: Thu, 27 Sep 2018 19:55:08 +0300
Message-ID: <1538067309-5711-1-git-send-email-maksym.kokhan@globallogic.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ralf Baechle <ralf@linux-mips.org>, Paul Burton <paul.burton@mips.com>, James Hogan <jhogan@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>
Cc: Daniel Walker <dwalker@fifo99.com>, Daniel Walker <danielwa@cisco.com>, Andrii Bordunov <aborduno@cisco.com>, Ruslan Bilovol <rbilovol@cisco.com>, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-efi@vger.kernel.org

There were series of patches [1] for 4.3.0-rc3, that allowed
architectures to use a generic builtin command line. I have rebased
these patches on kernel 4.19.0-rc4.

Things, modified in comparison with original patches:                            
* There was some bug for mips, in the case when CONFIG_CMDLINE_PREPEND
and CONFIG_CMDLINE_APPEND are empty and CMDLINE_OVERRIDE is not set,
command line from bootloader was ignored, so I fixed it, modifying
patch "add generic builtin command line".

* Implemented new patch to resolve conflict with new kernel, which
modify EFI stub code. Unfortunately, I don't have capability to test
this modification on real arm board with EFI.

* Removed new realisation of mips builtin command line, which was
created after 4.3.0-rc3.

* Kernel 4.3.0-rc3 with original patches could not be compiled for
powerpc due to prom_init.c checking by prom_init_check.sh. So I added
strlcat (which is used by cmdline_add_builtin macro) to
prom_init_check.sh whitelist.

Patches have been tested in QEMU for x86, arm (little-endian), arm64
(little-endian), mips (little-endian, 32-bit) and powerpc
(big-endian, 64-bit), everything works perfectly. Also it was tested
on linux-next (next-20180924 tag) for all listed above architectures.

[1] : https://lore.kernel.org/patchwork/patch/604992/

Daniel Walker (7):
  add generic builtin command line
  drivers: of: ifdef out cmdline section
  x86: convert to generic builtin command line
  arm: convert to generic builtin command line
  arm64: convert to generic builtin command line
  mips: convert to generic builtin command line
  powerpc: convert to generic builtin command line

Maksym Kokhan (1):
  efi: modify EFI stub code for arm/arm64

 arch/arm/Kconfig                        | 38 +-----------------
 arch/arm/kernel/atags_parse.c           | 14 ++-----
 arch/arm/kernel/devtree.c               |  2 +
 arch/arm64/Kconfig                      | 17 +-------
 arch/arm64/kernel/setup.c               |  3 ++
 arch/mips/Kconfig                       | 24 +----------
 arch/mips/Kconfig.debug                 | 47 ----------------------
 arch/mips/kernel/setup.c                | 41 ++-----------------
 arch/powerpc/Kconfig                    | 23 +----------
 arch/powerpc/kernel/prom.c              |  4 ++
 arch/powerpc/kernel/prom_init.c         |  8 ++--
 arch/powerpc/kernel/prom_init_check.sh  |  2 +-
 arch/x86/Kconfig                        | 44 +--------------------
 arch/x86/kernel/setup.c                 | 19 ++-------
 drivers/firmware/efi/libstub/arm-stub.c | 10 ++---
 drivers/of/fdt.c                        |  2 +-
 include/linux/cmdline.h                 | 70 +++++++++++++++++++++++++++++++++
 init/Kconfig                            | 68 ++++++++++++++++++++++++++++++++
 18 files changed, 173 insertions(+), 263 deletions(-)
 create mode 100644 include/linux/cmdline.h

-- 
2.7.4
