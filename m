From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH] x86/EFI: check table header length in efi_bgrt_init()
Date: Wed, 7 Nov 2012 10:46:22 -0800
Message-ID: <20121107184622.GA6566@jtriplet-mobl1>
References: <509A9E6002000078000A7079@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <509A9E6002000078000A7079-ce6RLXgGx+vWGUEhTRrCg1aTQe2KTcn/@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Cc: mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 07, 2012 at 04:46:08PM +0000, Jan Beulich wrote:
> Header length should be validated for all ACPI tables before accessing
> any non-header field.
> 
> Signed-off-by: Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>

Reviewed-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>

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
> 
> 
> 
