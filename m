From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT PULL 00/14] EFI changes for v4.14
Date: Mon, 21 Aug 2017 11:34:58 +0200
Message-ID: <20170821093458.7mkypxmes4ww4nyg@gmail.com>
References: <20170818194947.19347-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170818194947.19347-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Arvind Yadav <arvind.yadav.cs@gmail.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>, Douglas_Warzecha <douglas_warzecha@dell.com>, Hans de Goede <hdegoede@redhat.com>, Len Brown <lenb@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Mark Salter <msalter@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, Matthias Kaehlcke <mka@chromium.org>, Peter Jones <pjones@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Russell King <linux@armlinux.org.uk>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> Hi all,
> 
> These are the changes we have queued up in the EFI tree for v4.14. Please
> pull.
> 
> Russell has been cc'ed twice on the patches that touch the linker script
> of the ARM decompressor, and has elected not to respond, so I assume he
> has no objections.
> 
> The following changes since commit 5771a8c08880cdca3bfb4a3fc6d309d6bba20877:
> 
>   Linux v4.13-rc1 (2017-07-15 15:22:10 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next
> 
> for you to fetch changes up to f6a3116a8881cff8543e1cf028dea6955831ec30:
> 
>   firmware: efi: esrt: constify attribute_group structures. (2017-08-18 19:55:50 +0100)
> 
> ----------------------------------------------------------------
> EFI changes for v4.14:
> - don't mark ACPI reclaim regions as NOMAP on ARM
> - update the compiler flags for the arm64 version of the EFI stub so that
>   we can be confident that no absolute relocations are emitted, even when
>   using clang
> - update the EFI framebuffer address if points to a BAR that gets moved
>   by the PCI resource allocation code
> - fallback to other poweroff method if EFI poweroff fails (and returns)
> - use separate PE/COFF section headers for the RX and RW parts of the ARM
>   stub loader so that the firmware can use strict mapping permissions
> - constify some struct attribute_group instances
> 
> ----------------------------------------------------------------
> Ard Biesheuvel (10):
>       efi: arm: Don't mark ACPI reclaim memory as MEMBLOCK_NOMAP
>       efi/libstub: arm64: use hidden attribute for struct screen_info reference
>       efi/libstub: arm64: force 'hidden' visibility for section markers
>       efi/libstub: arm64: set -fpie when building the EFI stub
>       efi: arm/arm64: Add missing assignment of efi.config_table
>       drivers/fbdev: efifb: allow BAR to be moved instead of claiming it
>       arm: efi: remove forbidden values from the PE/COFF header
>       arm: efi: remove pointless dummy .reloc section
>       arm: efi: replace open coded constants with symbolic ones
>       arm: efi: split zImage code and data into separate PE/COFF sections
> 
> Arvind Yadav (3):
>       firmware: dcdbas: constify attribute_group structures.
>       firmware: efi: constify attribute_group structures.
>       firmware: efi: esrt: constify attribute_group structures.
> 
> Hans de Goede (1):
>       efi/reboot: Fall back to original power-off method if EFI_RESET_SHUTDOWN returns
> 
>  arch/arm/boot/compressed/efi-header.S     | 160 +++++++++++++++---------------
>  arch/arm/boot/compressed/vmlinux.lds.S    |  30 ++++--
>  arch/arm64/include/asm/efi.h              |   3 +
>  drivers/firmware/dcdbas.c                 |   2 +-
>  drivers/firmware/efi/arm-init.c           |   8 ++
>  drivers/firmware/efi/efi.c                |   2 +-
>  drivers/firmware/efi/esrt.c               |   2 +-
>  drivers/firmware/efi/libstub/Makefile     |   2 +-
>  drivers/firmware/efi/libstub/arm64-stub.c |  10 +-
>  drivers/firmware/efi/reboot.c             |  12 ++-
>  drivers/video/fbdev/efifb.c               |  31 +++---
>  11 files changed, 158 insertions(+), 104 deletions(-)

Applied, thanks Ard. I picked them up from email to fix a few minor changelog 
formatting details.

Thanks,

	Ingo
