From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 4/6] x86/efi: Hoist page table switching code into
 efi_call_virt()
Date: Fri, 13 Nov 2015 16:19:13 +0000
Message-ID: <20151113161913.GF2716@codeblueprint.co.uk>
References: <1447342823-3612-1-git-send-email-matt@codeblueprint.co.uk>
 <1447342823-3612-5-git-send-email-matt@codeblueprint.co.uk>
 <20151112184432.GG3838@pd.tnic>
 <20151112200108.GF2681@codeblueprint.co.uk>
 <20151113075943.GB23605@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151113075943.GB23605-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 13 Nov, at 08:59:43AM, Borislav Petkov wrote:
> On Thu, Nov 12, 2015 at 08:01:08PM +0000, Matt Fleming wrote:
> > > That PUSHF implicitly pushes on the stack pointed by %rsp. But(!) we
> > > have switched the pagetable (i.e., %cr3 has efi_scratch.efi_pgt) and
> > > we're pushing to the VA where the stack *was* but is not anymore.
> >  
> > All the kernel mappings will still exist in the page table we switch
> > to, so pushing to the stack should be fine.
> > 
> > The mappings have to exist so that the firmware can dereference
> > pointer arguments, e.g. when writing variable data to a kernel buffer.
> > 
> > Or have I misunderstood your point?
> > 
> > > Or maybe it is because you're copying all the PUDs. It is still not 100%
> > > clean, IMHO.
> ^^^^^^^^^^^^^^^^^
> 
> I think we're on the same page - you're copying the PUDs in
> efi_sync_low_kernel_mappings() so the stack should be there.

Correct.

> > > Can you do the prolog/epilog calls inside the IRQs-off section?
> > 
> > Not really because in the efi_enabled(EFI_OLD_MEMMAP) case we perform
> > kmalloc(), see commit 23a0d4e8fa6d ("efi: Disable interrupts around
> > EFI calls, not in the epilog/prolog calls").
> 
>         n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
>         save_pgd = kmalloc(n_pgds * sizeof(pgd_t), GFP_KERNEL);
> 
> This?
> 
> That n_pgds thing is of static size so you can pre-alloc it maybe even
> once during boot and reuse it all the time when EFI_OLD_MEMMAP is
> enabled.

Well, this code is only executed once during boot anyway, for
phys_efi_set_virtual_address_map().

FYI, I'm still planning on ripping out all the EFI_OLD_MEMMAP code, as
it's getting particularly crufty.
