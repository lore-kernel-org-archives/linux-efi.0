From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86/efi: fix potential NULL pointer dereference
Date: Fri, 24 Apr 2015 13:42:27 +0300
Message-ID: <20150424104227.GM14154@mwanda>
References: <1429855639-14706-1-git-send-email-firogm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1429855639-14706-1-git-send-email-firogm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Firo Yang <firogm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Apr 24, 2015 at 02:07:19PM +0800, Firo Yang wrote:
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index a0ac0f9..62326c4 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -90,6 +90,8 @@ pgd_t * __init efi_call_phys_prolog(void)
>  
>  	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
>  	save_pgd = kmalloc(n_pgds * sizeof(pgd_t), GFP_KERNEL);
> +	if (unlikely(!save_pgd))
> +		return NULL;

A bunch of init code doesn't check for NULL because it won't happen in
real life.  It makes my life a little bit harder because it introduces
meaningless static checker warnings...  Oh well.

Don't add unlikely() here because it won't help with benchmarks
and it makes the code harder to read.

regards,
dan carpenter
