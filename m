From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] x86/EFI: check table header length in efi_bgrt_init()
Date: Tue, 13 Nov 2012 20:08:15 +0000
Message-ID: <1352837295.15747.72.camel@mfleming-mobl1.ger.corp.intel.com>
References: <509A9E6002000078000A7079@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <509A9E6002000078000A7079-ce6RLXgGx+vWGUEhTRrCg1aTQe2KTcn/@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Cc: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 2012-11-07 at 16:46 +0000, Jan Beulich wrote:
> Header length should be validated for all ACPI tables before accessing
> any non-header field.
> 
> Signed-off-by: Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>
> 
> ---
>  arch/x86/platform/efi/efi-bgrt.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- 3.7-rc4/arch/x86/platform/efi/efi-bgrt.c
> +++ 3.7-rc4-x86-EFI-BGRT-checks/arch/x86/platform/efi/efi-bgrt.c
> @@ -39,6 +39,8 @@ void efi_bgrt_init(void)
>  	if (ACPI_FAILURE(status))
>  		return;
>  
> +	if (bgrt_tab->header.length < sizeof(*bgrt_tab))
> +		return;
>  	if (bgrt_tab->version != 1)
>  		return;
>  	if (bgrt_tab->image_type != 0 || !bgrt_tab->image_address)

Guys, do you want me to take this into the efi tree? Jan, have you see
machines that actually trip up without this check? I'm trying to gauge
the urgency of this patch.

-- 
Matt Fleming, Intel Open Source Technology Center
