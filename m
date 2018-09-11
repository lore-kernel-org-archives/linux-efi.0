From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: Random crashes with i386 and efi boots
Date: Tue, 11 Sep 2018 11:22:16 -0700
Message-ID: <20180911182216.GA21160@roeck-us.net>
References: <20180910215659.GA17966@roeck-us.net>
 <D213F8BC-5C8E-44A2-810F-918B915F0804@amacapital.net>
 <877118e5-beee-4551-28d3-79e7aa52f74e@roeck-us.net>
 <90A7FF2E-F186-49CF-A028-CDE317BE13E1@amacapital.net>
 <20180911174158.7qu6f4vfnfzqqrcf@suse.de>
 <51FDF5AF-2FE8-4817-9A5C-8CE4A8BC23AB@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51FDF5AF-2FE8-4817-9A5C-8CE4A8BC23AB@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Michal Hocko <mhocko@suse.com>, Andi Kleen <ak@linux.intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Hansen <dave.hansen@intel.com>, Pavel Machek <pavel@ucw.cz>, linux-efi@vger.kernel.org, x86@kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, Sep 11, 2018 at 11:05:25AM -0700, Andy Lutomirski wrote:
> 
> 
> > On Sep 11, 2018, at 10:41 AM, Joerg Roedel <jroedel@suse.de> wrote:
> > 
> > On Tue, Sep 11, 2018 at 09:36:51AM -0700, Andy Lutomirski wrote:
> >>>   save_pgd = efi_call_phys_prolog();
> >>>   local_irq_save(flags);
> >>>   status = efi_call_phys(...);
> >>>       local_irq_restore(flags);
> >>> 
> >>>       efi_call_phys_epilog(save_pgd);
> >>> 
> >>> So, yes, interrupts are very much enabled.
> >> 
> >> Does fixing that solve the problem?  It seems more robust.
> > 
> > The problem is still that in efi_call_phys_prolog() we load the gdt with
> > its physical address, and when we reload the %cr3 in _epilog from
> > initial_page_table to swapper_pg_dir again the gdt is no longer mapped.
> > Blocking interrupts is more robust, but we can't block NMIs that way
> > that would also trigger the issue, no?
> > 
> > So I am in favor of changing the order in efi_call_phys_epilog() too.
> > 
> 
> I’m rather confused here.  We’re loading CR3 with page tables that don’t have the fixmap mapped?  With interrupts on?  And we expect it to work?  This is *nuts*.
> 
> There are IMO only three sane fixes here:
> 
> 1. Load the fixmap, cpu_entry_area, etc into the EFI page table.  Drop the GDT reload entirely.
> 
> 2. Do this whole virtual map dance earlier so we don’t have IRQs and NMIs and such. Maybe while we’re still using the initial page table?
> 
> 3. Just identity map all the EFI regions. Make EFI page tables that literally map them at their physical addresses *and* map the entire kernel, just like we do for normal user mms.
> 
> Sure, as a stopgap, turning off IRQs and applying Guenter’s patch seems okay, but this code is not okay.

I submitted a patch with the diff I suggested above; it seems to be the
least invasive solution and addresses the immediate problem.

I am way out of league regarding the other suggested changes. I'll be happy
to test the code if someone is willing to rearrange the code accordingly,
but I don't think it would make sense to even try doing it myself.

Thanks,
Guenter
