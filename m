From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 4/6] x86/efi: Hoist page table switching code into
 efi_call_virt()
Date: Thu, 12 Nov 2015 20:01:08 +0000
Message-ID: <20151112200108.GF2681@codeblueprint.co.uk>
References: <1447342823-3612-1-git-send-email-matt@codeblueprint.co.uk>
 <1447342823-3612-5-git-send-email-matt@codeblueprint.co.uk>
 <20151112184432.GG3838@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151112184432.GG3838@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Jones <davej@codemonkey.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
List-Id: linux-efi@vger.kernel.org

On Thu, 12 Nov, at 07:44:32PM, Borislav Petkov wrote:
> 
> So this one is called in phys_efi_set_virtual_address_map() like this:
> 
> ----
>         save_pgd = efi_call_phys_prolog();
> 
>         /* Disable interrupts around EFI calls: */
>         local_irq_save(flags);
> 
> 	<--- MARKER
> 
>         status = efi_call_phys(efi_phys.set_virtual_address_map,
>                                memory_map_size, descriptor_size,
>                                descriptor_version, virtual_map);
>         local_irq_restore(flags);
> 
>         efi_call_phys_epilog(save_pgd);
> ---
> 
> 
> Now, if you look at MARKER, the asm looks like this here:
> 
>         .loc 1 91 0
>         call    efi_call_phys_prolog    #
>         movq    %rax, %r15      #, save_pgd
> 
>         .file 6 "./arch/x86/include/asm/irqflags.h"
>         .loc 6 20 0
> #APP
> # 20 "./arch/x86/include/asm/irqflags.h" 1
>         # __raw_save_flags
>         pushf ; pop %r14        # flags
> 
> 
> That PUSHF implicitly pushes on the stack pointed by %rsp. But(!) we
> have switched the pagetable (i.e., %cr3 has efi_scratch.efi_pgt) and
> we're pushing to the VA where the stack *was* but is not anymore.
 
All the kernel mappings will still exist in the page table we switch
to, so pushing to the stack should be fine.

The mappings have to exist so that the firmware can dereference
pointer arguments, e.g. when writing variable data to a kernel buffer.

Or have I misunderstood your point?

> Or maybe it is because you're copying all the PUDs. It is still not 100%
> clean, IMHO.
> 
> Can you do the prolog/epilog calls inside the IRQs-off section?

Not really because in the efi_enabled(EFI_OLD_MEMMAP) case we perform
kmalloc(), see commit 23a0d4e8fa6d ("efi: Disable interrupts around
EFI calls, not in the epilog/prolog calls").
