From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] x86/efi: Use kmalloc_array() in efi_call_phys_prolog()
Date: Thu, 25 Aug 2016 13:32:51 +0200
Message-ID: <d8006c17-d675-decb-6204-3dcf8652da7e@redhat.com>
References: <f6dc4cd4-eb71-50e5-8f10-c38c8ec6f6c0@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f6dc4cd4-eb71-50e5-8f10-c38c8ec6f6c0@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, linux-efi@vger.kernel.org, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-efi@vger.kernel.org



On 25/08/2016 11:40, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
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
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
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
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
