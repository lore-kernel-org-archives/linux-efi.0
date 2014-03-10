From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] x86/efi: use GFP_ATOMIC under spin_lock
Date: Mon, 10 Mar 2014 09:47:46 -0700
Message-ID: <531DECB2.3020405@zytor.com>
References: <20140307112055.GE2351@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20140307112055.GE2351@elgon.mountain>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Matt Fleming <matt.fleming@intel.com>, Nathan Zimmer <nzimmer@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-efi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 03/07/2014 03:20 AM, Dan Carpenter wrote:
> In phys_efi_get_time() we call efi_call_phys_prelog() with a spin_lock
> so this allocation should be atomic.
> 
> Fixes: b8f2c21db390 ('efi, x86: Pass a proper identity mapping in efi_call_phys_prelog')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index 0c2a234fef1e..f5adcadb381b 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -90,7 +90,7 @@ void __init efi_call_phys_prelog(void)
>  	local_irq_save(efi_flags);
>  
>  	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
> -	save_pgd = kmalloc(n_pgds * sizeof(pgd_t), GFP_KERNEL);
> +	save_pgd = kmalloc(n_pgds * sizeof(pgd_t), GFP_ATOMIC);
>  
>  	for (pgd = 0; pgd < n_pgds; pgd++) {
>  		save_pgd[pgd] = *pgd_offset_k(pgd * PGDIR_SIZE);
> 

And what happens if the allocation fails, as GFP_ATOMIC allocations are
wont to do?  I see an inbound NULL pointer reference from miles away here...

	-hpa

