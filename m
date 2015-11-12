From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 4/6] x86/efi: Hoist page table switching code into
 efi_call_virt()
Date: Thu, 12 Nov 2015 20:15:42 +0000
Message-ID: <20151112201542.GG2681@codeblueprint.co.uk>
References: <1447342823-3612-1-git-send-email-matt@codeblueprint.co.uk>
 <1447342823-3612-5-git-send-email-matt@codeblueprint.co.uk>
 <20151112184714.GH3838@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151112184714.GH3838@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Jones <davej@codemonkey.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
List-Id: linux-efi@vger.kernel.org

On Thu, 12 Nov, at 07:47:14PM, Borislav Petkov wrote:
> 
> checkpatch is bitching here - not that I agree with it:
> 
> WARNING: please, no space before tabs
> #87: FILE: arch/x86/include/asm/efi.h:88:
> +^I^Iefi_scratch.prev_cr3 = read_cr3(); ^I^I^I\$
> 
> WARNING: please, no space before tabs
> #89: FILE: arch/x86/include/asm/efi.h:90:
> +^I^I__flush_tlb_all(); ^I^I^I^I^I\$
> 
> WARNING: please, no space before tabs
> #94: FILE: arch/x86/include/asm/efi.h:95:
> +^Iif (efi_scratch.use_pgd) { ^I^I^I^I^I\$
> 
> WARNING: please, no space before tabs
> #96: FILE: arch/x86/include/asm/efi.h:97:
> +^I^I__flush_tlb_all(); ^I^I^I^I^I\$
> 
> WARNING: please, no space before tabs
> #97: FILE: arch/x86/include/asm/efi.h:98:
> +^I} ^I^I^I^I^I^I^I^I\$
 
Crap. These look legit, I'll fix this up in v2.

> > diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> > index 634536034e32..ab5f14a886cc 100644
> > --- a/arch/x86/platform/efi/efi_64.c
> > +++ b/arch/x86/platform/efi/efi_64.c
> > @@ -47,16 +47,7 @@
> >   */
> >  static u64 efi_va = EFI_VA_START;
> >  
> > -/*
> > - * Scratch space used for switching the pagetable in the EFI stub
> > - */
> > -struct efi_scratch {
> > -	u64 r15;
> > -	u64 prev_cr3;
> > -	pgd_t *efi_pgt;
> > -	bool use_pgd;
> > -	u64 phys_stack;
> > -} __packed;
> > +struct efi_scratch efi_scratch;
> >  
> >  static void __init early_code_mapping_set_exec(int executable)
> >  {
> > @@ -83,8 +74,11 @@ pgd_t * __init efi_call_phys_prolog(void)
> >  	int pgd;
> >  	int n_pgds;
> >  
> > -	if (!efi_enabled(EFI_OLD_MEMMAP))
> > -		return NULL;
> > +	if (!efi_enabled(EFI_OLD_MEMMAP)) {
> > +		save_pgd = (pgd_t *)read_cr3();
> > +		write_cr3((unsigned long)efi_scratch.efi_pgt);
> > +		goto out;
> > +	}
> >  
> >  	early_code_mapping_set_exec(1);
> >  
> > @@ -96,6 +90,7 @@ pgd_t * __init efi_call_phys_prolog(void)
> >  		vaddress = (unsigned long)__va(pgd * PGDIR_SIZE);
> >  		set_pgd(pgd_offset_k(pgd * PGDIR_SIZE), *pgd_offset_k(vaddress));
> >  	}
> > +out:
> >  	__flush_tlb_all();
> >  
> >  	return save_pgd;
> > @@ -109,8 +104,11 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
> 
> There's a comment here:
> 
>         /*
>          * After the lock is released, the original page table is restored.
>          */
> 
> Which lock are we talking about?

No idea, we don't take any locks. Looks like a stale comment.
