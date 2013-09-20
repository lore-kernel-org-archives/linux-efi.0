From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/11] EFI runtime services virtual mapping
Date: Fri, 20 Sep 2013 15:29:04 +0800
Message-ID: <20130920072904.GA21922@dhcp-16-126.nay.redhat.com>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1379602494-26684-1-git-send-email-bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 09/19/13 at 04:54pm, Borislav Petkov wrote:
> From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> 
> Hi all,
> 
> here's finally a new version of the runtime services VA mapping patchset
> which hopefully implements hpa's idea of statically mapping EFI runtime
> regions in a top-down manner starting at -4Gb virtual.
> 
> We're also using a different pagetable so as not to pollute kernel
> address space. For that, we switch to that table before doing an EFI
> call, and afterwards we switch back to the previous one.
> 
> To the patches:
> 
> 1-2 are simple cleanups which Matt probably can take now
> 
> 3-10 add the machinery to map regions into an arbitrary PGD. Those I've
> split deliberately into very small bites so that they can be reviewed
> more thoroughly and easily for my pagetable skills are pretty basic.
> 
> 11 is the actual patch which implements that mapping so that we can use
> runtime services in kexec (which is the whole reason for this fuss :))
> 
> So please take a long hard look at those, hammer on them on your
> boxes and let me know. They boot fine on my Dell UEFI box and in OVMF
> (obviously :)).

Thanks for your update!

Just tested this series, for 1st kernel It boots ok in qemu+ovmf. But it immediately
reboot on my Thinkpad T420. Unfortunately there's no way to debug this
very early problem because there's no serial port also earlyprintk does
not work for efi boot. No usb debug as well on this machine. I will test
it when I go back to work after the china holiday.

OTOH, for 2nd kernel testing because kexec tools does not fill efi_info[]
in bootparam so kernel will disable efi, also it pass acpi_rsdp pointer
automaticlly to make 2nd kernel boot ok.

I tested with a user space patch which copy efi_info from 1st kernel to
bootparams, as I said previously this is not enough because several fields
in systab, fw_vendor, runtime and tables are converted to virtual address
but in kernel efi init function they are assumed physical addresses. Thus
we need save these physical address. I have a patch to save them and pass
them to 2nd kernel in bootparams.
Since the mapping are same, I wonder if we can calculate the physical
address from virtual address.  Idea?

Another concern is that is it safe for i386 efi boot?

> 
> Thanks.
> 
> Borislav Petkov (11):
>   efi: Simplify EFI_DEBUG
>   efi: Remove EFI_PAGE_SHIFT and EFI_PAGE_SIZE
>   x86, pageattr: Lookup address in an arbitrary PGD
>   x86, pageattr: Add a PGD pagetable populating function
>   x86, pageattr: Add a PUD pagetable populating function
>   x86, pageattr: Add a PMD pagetable populating function
>   x86, pageattr: Add a PTE pagetable populating function
>   x86, pageattr: Add a PUD error unwinding path
>   x86, pageattr: Add last levels of error path
>   x86, cpa: Map in an arbitrary pgd
>   EFI: Runtime services virtual mapping
> 
>  arch/x86/boot/compressed/eboot.c     |  12 +-
>  arch/x86/boot/compressed/eboot.h     |   1 -
>  arch/x86/include/asm/efi.h           |  58 +++--
>  arch/x86/include/asm/pgtable_types.h |   3 +-
>  arch/x86/mm/pageattr.c               | 461 +++++++++++++++++++++++++++++++++--
>  arch/x86/platform/efi/efi.c          | 126 +++++-----
>  arch/x86/platform/efi/efi_64.c       |  56 +----
>  arch/x86/platform/efi/efi_stub_64.S  |  47 ++++
>  include/linux/efi.h                  |   6 +-
>  9 files changed, 615 insertions(+), 155 deletions(-)
> 
> -- 
> 1.8.4
> 
