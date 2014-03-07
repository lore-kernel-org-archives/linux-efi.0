From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] x86/efi: use GFP_ATOMIC under spin_lock
Date: Fri, 7 Mar 2014 15:25:37 +0300
Message-ID: <20140307122103.GM4774@mwanda>
References: <20140307112055.GE2351@elgon.mountain>
 <20140307121022.GA32575@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140307121022.GA32575-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Nathan Zimmer <nzimmer-sJ/iWh9BUns@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Mar 07, 2014 at 01:10:22PM +0100, Ingo Molnar wrote:
> 
> * Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > In phys_efi_get_time() we call efi_call_phys_prelog() with a spin_lock
> > so this allocation should be atomic.
> > 
> > Fixes: b8f2c21db390 ('efi, x86: Pass a proper identity mapping in efi_call_phys_prelog')
> > Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > 
> > diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> > index 0c2a234fef1e..f5adcadb381b 100644
> > --- a/arch/x86/platform/efi/efi_64.c
> > +++ b/arch/x86/platform/efi/efi_64.c
> > @@ -90,7 +90,7 @@ void __init efi_call_phys_prelog(void)
> >  	local_irq_save(efi_flags);
> >  
> >  	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
> > -	save_pgd = kmalloc(n_pgds * sizeof(pgd_t), GFP_KERNEL);
> > +	save_pgd = kmalloc(n_pgds * sizeof(pgd_t), GFP_ATOMIC);
> >  
> >  	for (pgd = 0; pgd < n_pgds; pgd++) {
> >  		save_pgd[pgd] = *pgd_offset_k(pgd * PGDIR_SIZE);
> 
> The allocation there, if it happens within a spinlocked path, is 
> probably a layering violation - and GFP_ATOMIC is at best a 
> workaround.
> 

You're on your own for fixing the complicated stuff like layering
violations. I just do static checker stuff and sed fixes.  ;)

regards,
dan carpenter
