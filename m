From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v7 07/36] x86/mm: Don't use phys_to_virt in ioremap() if
 SME is active
Date: Wed, 21 Jun 2017 09:37:39 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1706210934540.2328@nanos>
References: <20170616184947.18967.84890.stgit@tlendack-t1.amdoffice.net> <20170616185104.18967.7867.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170616185104.18967.7867.stgit-qCXWGYdRb2BnqfbPTmsdiZQ+2ll4COg0XqFh9Ls21Oc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, =?ISO-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave
List-Id: linux-efi@vger.kernel.org

On Fri, 16 Jun 2017, Tom Lendacky wrote:
> Currently there is a check if the address being mapped is in the ISA
> range (is_ISA_range()), and if it is then phys_to_virt() is used to
> perform the mapping.  When SME is active, however, this will result
> in the mapping having the encryption bit set when it is expected that
> an ioremap() should not have the encryption bit set. So only use the
> phys_to_virt() function if SME is not active
> 
> Reviewed-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
> ---
>  arch/x86/mm/ioremap.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> index 4c1b5fd..a382ba9 100644
> --- a/arch/x86/mm/ioremap.c
> +++ b/arch/x86/mm/ioremap.c
> @@ -13,6 +13,7 @@
>  #include <linux/slab.h>
>  #include <linux/vmalloc.h>
>  #include <linux/mmiotrace.h>
> +#include <linux/mem_encrypt.h>
>  
>  #include <asm/set_memory.h>
>  #include <asm/e820/api.h>
> @@ -106,9 +107,11 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
>  	}
>  
>  	/*
> -	 * Don't remap the low PCI/ISA area, it's always mapped..
> +	 * Don't remap the low PCI/ISA area, it's always mapped.
> +	 *   But if SME is active, skip this so that the encryption bit
> +	 *   doesn't get set.
>  	 */
> -	if (is_ISA_range(phys_addr, last_addr))
> +	if (is_ISA_range(phys_addr, last_addr) && !sme_active())
>  		return (__force void __iomem *)phys_to_virt(phys_addr);

More thoughts about that.

Making this conditional on !sme_active() is not the best idea. I'd rather
remove that whole thing and make it unconditional so the code pathes get
always exercised and any subtle wreckage is detected on a broader base and
not only on that hard to access and debug SME capable machine owned by Joe
User.

Thanks,

	tglx
