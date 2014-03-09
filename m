From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [patch] x86/efi: use GFP_ATOMIC under spin_lock
Date: Sun, 9 Mar 2014 07:48:19 +0100
Message-ID: <20140309064819.GB22561@gmail.com>
References: <20140307112055.GE2351@elgon.mountain>
 <20140307121022.GA32575@gmail.com>
 <20140307122103.GM4774@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140307122103.GM4774@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Matt Fleming <matt.fleming@intel.com>, Nathan Zimmer <nzimmer@sgi.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-efi@vger.kernel.org


* Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Fri, Mar 07, 2014 at 01:10:22PM +0100, Ingo Molnar wrote:
> > 
> > * Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > 
> > > In phys_efi_get_time() we call efi_call_phys_prelog() with a spin_lock
> > > so this allocation should be atomic.
> > > 
> > > Fixes: b8f2c21db390 ('efi, x86: Pass a proper identity mapping in efi_call_phys_prelog')
> > > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > 
> > > diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> > > index 0c2a234fef1e..f5adcadb381b 100644
> > > --- a/arch/x86/platform/efi/efi_64.c
> > > +++ b/arch/x86/platform/efi/efi_64.c
> > > @@ -90,7 +90,7 @@ void __init efi_call_phys_prelog(void)
> > >  	local_irq_save(efi_flags);
> > >  
> > >  	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
> > > -	save_pgd = kmalloc(n_pgds * sizeof(pgd_t), GFP_KERNEL);
> > > +	save_pgd = kmalloc(n_pgds * sizeof(pgd_t), GFP_ATOMIC);
> > >  
> > >  	for (pgd = 0; pgd < n_pgds; pgd++) {
> > >  		save_pgd[pgd] = *pgd_offset_k(pgd * PGDIR_SIZE);
> > 
> > The allocation there, if it happens within a spinlocked path, is 
> > probably a layering violation - and GFP_ATOMIC is at best a 
> > workaround.
> > 
> 
> You're on your own for fixing the complicated stuff like layering 
> violations. I just do static checker stuff and sed fixes.  ;)

It's a generic pattern: GFP_KERNEL -> GFP_ATOMIC fixes are almost 
always wrong.

Thanks,

	Ingo
