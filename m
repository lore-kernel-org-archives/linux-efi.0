From: Stefano Stabellini <sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] EFI ARM Xen support
Date: Tue, 17 May 2016 11:12:40 +0100 (BST)
Message-ID: <alpine.DEB.2.10.1605171109170.2494@sstabellini-ThinkPad-X260>
References: <20160514190410.GA2283@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160514190410.GA2283-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
Cc: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Stefano Stabellini <sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, 14 May 2016, Matt Fleming wrote:
> Folks,
> 
> Please pull the following branch which contains support for Xen on ARM
> EFI platforms.
> 
> This merge includes a merge of Stefano's xen/linux-next branch to pull
> in the prerequisites required for Shannon's commit:
> 
>   11ee5491e5ff ("Xen: EFI: Parse DT parameters for Xen specific UEFI")
> 
> as it needs both the latest changes in the EFI 'next' branch (now
> tip/efi/core) and xen/linux-next.
> 
> I have intentionally not included the individual patches as I would
> normally do in a pull request, so that commit history created by my
> merging of Stefano's branch is preserved, and so that there's no way
> to accidentally apply the patches individually.
> 
> The following changes since commit 6c5450ef66816216e574885cf8d3ddb31ef77428:
> 
>   efivarfs: Make efivarfs_file_ioctl() static (2016-05-07 07:06:13 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git efi/arm-xen
> 
> for you to fetch changes up to 11ee5491e5ff519e0d3a7018eb21351cb6955a98:
> 
>   Xen: EFI: Parse DT parameters for Xen specific UEFI (2016-05-14 19:31:01 +0100)

Is this arrangement working for everybody, in particular the tip
maintainers?

I am asking because I didn't receive any replies to this or to
http://marc.info/?l=linux-kernel&m=146317737928595&w=2.



> David Vrabel (1):
>       xen/gntdev: reduce copy batch size to 16
> 
> Matt Fleming (1):
>       Merge branch 'xen/linux-next' into efi/arm-xen
> 
> Shannon Zhao (16):
>       Xen: ACPI: Hide UART used by Xen
>       xen/grant-table: Move xlated_setup_gnttab_pages to common place
>       Xen: xlate: Use page_to_xen_pfn instead of page_to_pfn
>       arm/xen: Use xen_xlate_map_ballooned_pages to setup grant table
>       xen: memory : Add new XENMAPSPACE type XENMAPSPACE_dev_mmio
>       Xen: ARM: Add support for mapping platform device mmio
>       Xen: ARM: Add support for mapping AMBA device mmio
>       Xen: public/hvm: sync changes of HVM_PARAM_CALLBACK_VIA ABI from Xen
>       xen/hvm/params: Add a new delivery type for event-channel in HVM_PARAM_CALLBACK_IRQ
>       arm/xen: Get event-channel irq through HVM_PARAM when booting with ACPI
>       ARM: XEN: Move xen_early_init() before efi_init()
>       ARM: Xen: Document UEFI support on Xen ARM virtual platforms
>       XEN: EFI: Move x86 specific codes to architecture directory
>       ARM64: XEN: Add a function to initialize Xen specific UEFI runtime services
>       FDT: Add a helper to get the subnode by given name
>       Xen: EFI: Parse DT parameters for Xen specific UEFI
> 
> Stefano Stabellini (1):
>       xen/x86: don't lose event interrupts
> 
>  Documentation/devicetree/bindings/arm/xen.txt |  35 +++++
>  arch/arm/include/asm/xen/xen-ops.h            |   6 +
>  arch/arm/kernel/setup.c                       |   2 +-
>  arch/arm/xen/Makefile                         |   1 +
>  arch/arm/xen/efi.c                            |  40 ++++++
>  arch/arm/xen/enlighten.c                      | 125 ++++++++++++----
>  arch/arm64/include/asm/xen/xen-ops.h          |   6 +
>  arch/arm64/kernel/setup.c                     |   2 +-
>  arch/arm64/xen/Makefile                       |   1 +
>  arch/x86/xen/efi.c                            | 111 +++++++++++++++
>  arch/x86/xen/grant-table.c                    |  57 +-------
>  arch/x86/xen/time.c                           |   6 +-
>  drivers/acpi/scan.c                           |  74 ++++++++++
>  drivers/firmware/efi/arm-runtime.c            |   5 +
>  drivers/firmware/efi/efi.c                    |  81 ++++++++---
>  drivers/of/fdt.c                              |  13 ++
>  drivers/xen/Kconfig                           |   2 +-
>  drivers/xen/Makefile                          |   1 +
>  drivers/xen/arm-device.c                      | 196 ++++++++++++++++++++++++++
>  drivers/xen/efi.c                             | 173 +++++------------------
>  drivers/xen/gntdev.c                          |   2 +-
>  drivers/xen/xlate_mmu.c                       |  77 ++++++++++
>  include/linux/of_fdt.h                        |   2 +
>  include/xen/interface/hvm/params.h            |  40 +++++-
>  include/xen/interface/memory.h                |   1 +
>  include/xen/xen-ops.h                         |  32 +++--
>  26 files changed, 840 insertions(+), 251 deletions(-)
>  create mode 100644 arch/arm/include/asm/xen/xen-ops.h
>  create mode 100644 arch/arm/xen/efi.c
>  create mode 100644 arch/arm64/include/asm/xen/xen-ops.h
>  create mode 100644 drivers/xen/arm-device.c
> 
