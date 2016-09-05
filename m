From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Use kmalloc_array() in efi_call_phys_prolog()
Date: Mon, 5 Sep 2016 14:47:41 +0100
Message-ID: <20160905134741.GJ32579@codeblueprint.co.uk>
References: <f6dc4cd4-eb71-50e5-8f10-c38c8ec6f6c0@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f6dc4cd4-eb71-50e5-8f10-c38c8ec6f6c0-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 25 Aug, at 11:40:45AM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> Date: Thu, 25 Aug 2016 11:34:03 +0200
> 
> * A multiplication for the size determination of a memory allocation
>   indicated that an array data structure should be processed.
>   Thus reuse the corresponding function "kmalloc_array".
> 
>   This issue was detected by using the Coccinelle software.
> 
> * Replace the specification of a data type by a pointer dereference
>   to make the corresponding size determination a bit safer according to
>   the Linux coding style convention.
> 
> Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi_64.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index 677e29e..311022a 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -85,7 +85,7 @@ pgd_t * __init efi_call_phys_prolog(void)
>  	early_code_mapping_set_exec(1);
>  
>  	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
> -	save_pgd = kmalloc(n_pgds * sizeof(pgd_t), GFP_KERNEL);
> +	save_pgd = kmalloc_array(n_pgds, sizeof(*save_pgd), GFP_KERNEL);
>  
>  	for (pgd = 0; pgd < n_pgds; pgd++) {
>  		save_pgd[pgd] = *pgd_offset_k(pgd * PGDIR_SIZE);

Thanks, applied with Paolo's Reviewed-by.
