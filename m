From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT PULL 00/29] EFI changes for v4.9
Date: Tue, 13 Sep 2016 20:32:09 +0200
Message-ID: <20160913183209.GA28714@gmail.com>
References: <20160909151851.27577-1-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160909151851.27577-1-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Alex Thorlton <athorlton@sgi.com>, Andy Lutomirski <luto@amacapital.net>, Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>, Colin Ian King <colin.king@canonical.com>, Dave Young <dyoung@redhat.com>, Dimitri Sivanich <sivanich@sgi.com>, Greg KH <gregkh@linuxfoundation.org>, Ivan Hu <ivan.hu@canonical.com>, James Morse <james.morse@arm.com>, joeyli <jlee@suse.com>, Josh Boyer <jwboyer@fedoraproject.org>, Josh Triplett <josh@joshtriplett.org>, Julia Lawall <julia.lawall@lip6.fr>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Leif Lindholm <leif.lindholm@linaro.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt@codeblueprint.co.uk> wrote:

> Folks, please queue up the following patches for v4.9. There's more
> work on refactoring EFI code to be architecture independent and the
> largest number of patches is spent cleaning up the EFI memory map code
> and allowing drivers on x86 to reserve EFI boot services for all of
> runtime.
> 
> The architecture independent quest is going pretty well and it was
> only a couple of lines to get the esrt driver working on arm64.
> 
> Other than that there's some cleanups and fixes, and a merge of the
> out of tree EFI runtime driver from the FWTS project.
> 
> The following changes since commit c6935931c1894ff857616ff8549b61236a19148f:
> 
>   Linux 4.8-rc5 (2016-09-04 14:31:46 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next
> 
> for you to fetch changes up to 0a637ee61247bd4bed9b2a07568ef7a1cfc76187:
> 
>   x86/efi: Allow invocation of arbitrary boot services (2016-09-09 16:08:57 +0100)
> 
> ----------------------------------------------------------------
>  * Refactor the EFI memory map code into architecture neutral files
>    and allow drivers to permanently reserve EFI boot services regions
>    on x86, as well as ARM/arm64 - Matt Fleming
> 
>  * Add ARM support for the EFI esrt driver - Ard Biesheuvel
> 
>  * Make the EFI runtime services and efivar API interruptible by
>    swapping spinlocks for semaphores - Sylvain Chouleur
> 
>  * Provide the EFI identity mapping for kexec which allows kexec to
>    work on SGI/UV platforms with requiring the "noefi" kernel command
>    line parameter - Alex Thorlton
> 
>  * Add debugfs node to dump EFI page tables on arm64 - Ard Biesheuvel
> 
>  * Merge the EFI test driver being carried out of tree until now in
>    the FWTS project - Ivan Hu
> 
>  * Expand the list of flags for classifying EFI regions as "RAM" on
>    arm64 so we align with the UEFI spec - Ard Biesheuvel
> 
>  * Optimise out the EFI mixed mode if it's unsupported (CONFIG_X86_32)
>    or disabled (CONFIG_EFI_MIXED=n) and switch the early EFI boot
>    services function table for direct calls, alleviating us from
>    having to maintain the custom function table - Lukas Wunner
> 
>  * Miscellaneous cleanups and fixes
> 
> ----------------------------------------------------------------
> Alex Thorlton (1):
>       x86/efi: Map in physical addresses in efi_map_region_fixed
> 
> Ard Biesheuvel (5):
>       efi/esrt: Use memremap not ioremap to access ESRT table in memory
>       efi/arm*: esrt: Add missing call to efi_esrt_init()
>       efi: Replace runtime services spinlock with semaphore
>       efi/arm64: Add debugfs node to dump UEFI runtime page tables
>       efi/arm64: Treat regions with WT/WC set but WB cleared as memory
> 
> Colin Ian King (1):
>       x86/efi: Initialize status to ensure garbage is not returned on small size
> 
> Ivan Hu (1):
>       efi: Add efi_test driver for exporting UEFI runtime service interfaces
> 
> Lukas Wunner (4):
>       lib/ucs2_string: Speed up ucs2_utf8size()
>       x86/efi: Remove unused find_bits() function
>       x86/efi: Optimize away setup_gop32/64 if unused
>       x86/efi: Allow invocation of arbitrary boot services
> 
> Markus Elfring (2):
>       firmware-gsmi: Delete an unnecessary check before the function call "dma_pool_destroy"
>       x86/efi: Use kmalloc_array() in efi_call_phys_prolog()
> 
> Matt Fleming (12):
>       x86/efi: Test for EFI_MEMMAP functionality when iterating EFI memmap
>       x86/efi: Consolidate region mapping logic
>       efi: Refactor efi_memmap_init_early() into arch-neutral code
>       efi: Add efi_memmap_init_late() for permanent EFI memmap
>       efi/fake_mem: Refactor main two code chunks into functions
>       efi: Split out EFI memory map functions into new file
>       efi: Add efi_memmap_install() for installing new EFI memory maps
>       efi: Allow drivers to reserve boot services forever
>       efi/runtime-map: Use efi.memmap directly instead of a copy
>       efi/esrt: Use efi_mem_reserve() and avoid a kmalloc()
>       x86/efi-bgrt: Use efi_mem_reserve() to avoid copying image data
>       fs/efivarfs: Fix double kfree() in error path
> 
> Ricardo Neri (1):
>       x86/efi: Defer efi_esrt_init until after memblock_x86_fill
> 
> Sylvain Chouleur (2):
>       efi: Use a file local lock for efivars
>       efi: Don't use spinlocks for efi vars
> 
>  MAINTAINERS                             |   7 +
>  arch/x86/boot/compressed/eboot.c        |  40 +-
>  arch/x86/boot/compressed/head_32.S      |   6 +-
>  arch/x86/boot/compressed/head_64.S      |   8 +-
>  arch/x86/include/asm/efi.h              |  29 +-
>  arch/x86/kernel/setup.c                 |  18 +-
>  arch/x86/platform/efi/efi-bgrt.c        |  13 +-
>  arch/x86/platform/efi/efi.c             | 198 ++++-----
>  arch/x86/platform/efi/efi_64.c          |  23 +-
>  arch/x86/platform/efi/quirks.c          | 123 +++++-
>  drivers/firmware/efi/Kconfig            |  17 +
>  drivers/firmware/efi/Makefile           |   3 +-
>  drivers/firmware/efi/arm-init.c         |  50 ++-
>  drivers/firmware/efi/arm-runtime.c      |  26 +-
>  drivers/firmware/efi/efi-pstore.c       |  36 +-
>  drivers/firmware/efi/efi.c              |  67 +--
>  drivers/firmware/efi/efivars.c          |  22 +-
>  drivers/firmware/efi/esrt.c             |  23 +-
>  drivers/firmware/efi/fake_mem.c         | 125 +-----
>  drivers/firmware/efi/memmap.c           | 292 +++++++++++++
>  drivers/firmware/efi/runtime-map.c      |  35 +-
>  drivers/firmware/efi/runtime-wrappers.c |  81 ++--
>  drivers/firmware/efi/test/Makefile      |   1 +
>  drivers/firmware/efi/test/efi_test.c    | 749 ++++++++++++++++++++++++++++++++
>  drivers/firmware/efi/test/efi_test.h    | 110 +++++
>  drivers/firmware/efi/vars.c             | 142 +++---
>  drivers/firmware/google/gsmi.c          |   3 +-
>  fs/efivarfs/inode.c                     |   5 +-
>  fs/efivarfs/super.c                     |  13 +-
>  include/linux/efi.h                     |  47 +-
>  lib/ucs2_string.c                       |   2 +-
>  31 files changed, 1767 insertions(+), 547 deletions(-)
>  create mode 100644 drivers/firmware/efi/memmap.c
>  create mode 100644 drivers/firmware/efi/test/Makefile
>  create mode 100644 drivers/firmware/efi/test/efi_test.c
>  create mode 100644 drivers/firmware/efi/test/efi_test.h

Pulled into tip:efi/core, thanks a lot Matt!

	Ingo
