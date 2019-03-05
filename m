From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [GIT PULL] EFI changes for v5.1
Date: Tue, 5 Mar 2019 13:23:39 +0100
Message-ID: <CAKv+Gu_P-tmM-tFCDuxy+6mE-tGUUbcFoCUbJMAsitMk5Ahstw@mail.gmail.com>
References: <20190305122038.GA2472@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190305122038.GA2472@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org

Hi ingo,

On Tue, 5 Mar 2019 at 13:20, Ingo Molnar <mingo@kernel.org> wrote:
>
> Linus,
>
> Please pull the latest efi-core-for-linus git tree from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-core-for-linus
>
>    # HEAD: 5c418dc789a3898717ebf2caa5716ba91a7150b2 efi: Fix build error due to enum collision between efi.h and ima.h
>
> The main EFI changes in this cycle were:
>
>  - Move BGRT table handling to earlier in the boot so we don't overwrite it

This one actually got reverted because it broke x86. I haven't heard
back from the Intel engineers that reported the issue, so i will
revisit this at a later date.

>  - Use 32-bit alignment for efi_guid_t
>  - Allow the SetVirtualAddressMap() call to be omitted
>  - Implement earlycon=efifb based on existing earlyprintk code
>  - Various minor fixes and code cleanups from Sai, Ard and me
>
>  Thanks,
>
>         Ingo
>
> ------------------>
> Anders Roxell (1):
>       efi: Fix build error due to enum collision between efi.h and ima.h
>
> Ard Biesheuvel (6):
>       efi/memattr: Don't bail on zero VA if it equals the region's PA
>       efi: Use 32-bit alignment for efi_guid_t
>       efi: Replace GPL license boilerplate with SPDX headers
>       efi/arm/arm64: Allow SetVirtualAddressMap() to be omitted
>       x86: Make ARCH_USE_MEMREMAP_PROT a generic Kconfig symbol
>       efi/x86: Convert x86 EFI earlyprintk into generic earlycon implementation
>
> Ingo Molnar (1):
>       efi/fdt: Apply more cleanups
>
> Sai Praneeth Prakhya (1):
>       x86/efi: Mark can_free_region() as an __init function
>
>
>  Documentation/admin-guide/kernel-parameters.txt |   8 +-
>  arch/Kconfig                                    |   3 +
>  arch/x86/Kconfig                                |   5 +-
>  arch/x86/Kconfig.debug                          |  10 -
>  arch/x86/include/asm/efi.h                      |   1 -
>  arch/x86/kernel/early_printk.c                  |   4 -
>  arch/x86/mm/ioremap.c                           |   4 +-
>  arch/x86/platform/efi/Makefile                  |   1 -
>  arch/x86/platform/efi/early_printk.c            | 240 ------------------------
>  arch/x86/platform/efi/quirks.c                  |   6 +-
>  drivers/firmware/efi/Kconfig                    |   6 +
>  drivers/firmware/efi/Makefile                   |   1 +
>  drivers/firmware/efi/apple-properties.c         |  13 +-
>  drivers/firmware/efi/arm-init.c                 |   6 +-
>  drivers/firmware/efi/arm-runtime.c              |   6 +-
>  drivers/firmware/efi/capsule-loader.c           |   4 +-
>  drivers/firmware/efi/capsule.c                  |   4 +-
>  drivers/firmware/efi/cper-arm.c                 |  14 +-
>  drivers/firmware/efi/cper.c                     |  14 +-
>  drivers/firmware/efi/dev-path-parser.c          |   9 +-
>  drivers/firmware/efi/earlycon.c                 | 206 ++++++++++++++++++++
>  drivers/firmware/efi/efi-bgrt.c                 |   5 +-
>  drivers/firmware/efi/efi-pstore.c               |   2 +
>  drivers/firmware/efi/efibc.c                    |  10 +-
>  drivers/firmware/efi/efivars.c                  |  58 +-----
>  drivers/firmware/efi/esrt.c                     |   1 +
>  drivers/firmware/efi/fake_mem.c                 |  16 +-
>  drivers/firmware/efi/libstub/Makefile           |   4 +-
>  drivers/firmware/efi/libstub/arm-stub.c         |   5 +
>  drivers/firmware/efi/libstub/arm32-stub.c       |   6 +-
>  drivers/firmware/efi/libstub/arm64-stub.c       |   6 +-
>  drivers/firmware/efi/libstub/efi-stub-helper.c  |  15 +-
>  drivers/firmware/efi/libstub/efistub.h          |  12 ++
>  drivers/firmware/efi/libstub/fdt.c              | 115 ++++++------
>  drivers/firmware/efi/libstub/gop.c              |   4 +-
>  drivers/firmware/efi/libstub/random.c           |   6 +-
>  drivers/firmware/efi/libstub/secureboot.c       |   4 +-
>  drivers/firmware/efi/libstub/tpm.c              |   4 +-
>  drivers/firmware/efi/memattr.c                  |   7 +-
>  drivers/firmware/efi/runtime-map.c              |   3 +-
>  drivers/firmware/efi/runtime-wrappers.c         |  48 ++---
>  drivers/firmware/efi/test/efi_test.c            |   1 +
>  drivers/firmware/efi/test/efi_test.h            |   2 +-
>  drivers/firmware/efi/tpm.c                      |   5 +-
>  drivers/firmware/efi/vars.c                     |  15 +-
>  include/linux/efi.h                             |  41 ++--
>  46 files changed, 393 insertions(+), 567 deletions(-)
>  delete mode 100644 arch/x86/platform/efi/early_printk.c
>  create mode 100644 drivers/firmware/efi/earlycon.c
>
