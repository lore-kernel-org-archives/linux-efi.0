From: Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/6] arm64/efi: move SetVirtualAddressMap() to UEFI stub
Date: Fri, 24 Oct 2014 14:39:23 +0100
Message-ID: <CACxGe6uDQ5t1mQf2L2wPQ3qLN0RxR_VyUF1hEEKnOgC__Qb4Gw@mail.gmail.com>
References: <1414154384-15385-1-git-send-email-ard.biesheuvel@linaro.org> <1414154384-15385-5-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414154384-15385-5-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "Fleming, Matt (matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org)" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Oct 24, 2014 at 1:39 PM, Ard Biesheuvel
<ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> In order to support kexec, the kernel needs to be able to deal with the
> state of the UEFI firmware after SetVirtualAddressMap() has been called.
> To avoid having separate code paths for non-kexec and kexec, let's move
> the call to SetVirtualAddressMap() to the stub: this will guarantee us
> that it will only be called once (since the stub is not executed during
> kexec), and ensures that the UEFI state is identical between kexec and
> normal boot.
>
> This implies that the layout of the virtual mapping needs to be created
> by the stub as well. All regions are rounded up to a naturally aligned
> multiple of 64 KB (for compatibility with 64k pages kernels) and recorded
> in the UEFI memory map. The kernel proper reads those values and installs
> the mappings in a dedicated set of page tables that are swapped in during
> UEFI Runtime Services calls.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

A questions grounded in my ignorance below...

> ---
>  arch/arm64/include/asm/efi.h       |  19 +++-
>  arch/arm64/kernel/efi.c            | 205 +++++++++++++++++++------------------
>  drivers/firmware/efi/libstub/fdt.c | 104 ++++++++++++++++++-
>  3 files changed, 224 insertions(+), 104 deletions(-)
>
> @@ -69,9 +74,36 @@ static void __init efi_setup_idmap(void)
>         }
>  }
>
> +/*
> + * Translate a EFI virtual address into a physical address: this is necessary,
> + * as some data members of the EFI system table are virtually remapped after
> + * SetVirtualAddressMap() has been called.
> + */
> +static phys_addr_t __init efi_to_phys(unsigned long addr)
> +{
> +       efi_memory_desc_t *md;
> +
> +       for_each_efi_memory_desc(&memmap, md) {
> +               if (!(md->attribute & EFI_MEMORY_RUNTIME))
> +                       continue;
> +               if (md->virt_addr == 0)
> +                       /* no virtual mapping has been installed by the stub */
> +                       break;
> +               if (md->virt_addr < addr &&
> +                   (addr - md->virt_addr) < (md->num_pages << EFI_PAGE_SHIFT))
> +                       return md->phys_addr + addr - md->virt_addr;
> +       }
> +
> +       WARN_ONCE(1, "UEFI virtual mapping incomplete or missing -- no entry found for 0x%lx\n",
> +                 addr);
> +       return addr;
> +}
> +

Is function applicable to all EFI implementations? Should it be in the
common EFI code?

How much of this patch series is (theoretically) applicable to aarch32?

g.
