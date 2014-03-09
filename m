From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] x86/efi: use GFP_ATOMIC under spin_lock
Date: Sun, 9 Mar 2014 10:36:57 +0300
Message-ID: <20140309073656.GK29018@mwanda>
References: <20140307112055.GE2351@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140307112055.GE2351-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Nathan Zimmer <nzimmer-sJ/iWh9BUns@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Mar 07, 2014 at 02:20:56PM +0300, Dan Carpenter wrote:
> In phys_efi_get_time() we call efi_call_phys_prelog() with a spin_lock
> so this allocation should be atomic.
> 
> Fixes: b8f2c21db390 ('efi, x86: Pass a proper identity mapping in efi_call_phys_prelog')
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
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

"save_pgd" is a file scope variable.  It wouldn't be that hard to move
the allocation to a different function.  Meanwhile I am on the way to
the airport for vacation.

See you guys in couple weeks.

regards,
dan carpenter
