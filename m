From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 3/4] x86, efi: Add an efi= kernel command line parameter
Date: Tue, 4 Jun 2013 14:18:52 +0200
Message-ID: <20130604121852.GE23640@pd.tnic>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-4-git-send-email-bp@alien8.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1370177770-26661-4-git-send-email-bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, X86-ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, Jun 02, 2013 at 02:56:09PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> 
> .. for passing miscellaneous options from the kernel command line.
> 
> Signed-off-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 82089d8b1954..aea4337f7023 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -88,6 +88,11 @@ static u64 active_size;
>  
>  unsigned long x86_efi_facility;
>  
> + /* 1:1 mapping of services regions */
> +#define EFI_CFG_MAP11	BIT(0)
> +
> +static unsigned long efi_config;
> +
>  /*
>   * Returns 1 if 'facility' is enabled, 0 otherwise.
>   */
> @@ -1167,3 +1172,14 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
>  	return EFI_SUCCESS;
>  }
>  EXPORT_SYMBOL_GPL(efi_query_variable_store);
> +
> +static int __init parse_efi_cmdline(char *str)

note to self:

#ifdef CONFIG_X86_64

> +{
> +	if (*str == '=')
> +		str++;
> +	if (!strncmp(str, "1:1_map", 7))
> +		efi_config |= EFI_CFG_MAP11;

#endif

to temporarily workaround the 64-bit only requirement.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
