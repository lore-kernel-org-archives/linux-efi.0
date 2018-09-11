From: Joerg Roedel <jroedel@suse.de>
Subject: Re: Random crashes with i386 and efi boots
Date: Tue, 11 Sep 2018 19:41:58 +0200
Message-ID: <20180911174158.7qu6f4vfnfzqqrcf@suse.de>
References: <20180910215659.GA17966@roeck-us.net>
 <D213F8BC-5C8E-44A2-810F-918B915F0804@amacapital.net>
 <877118e5-beee-4551-28d3-79e7aa52f74e@roeck-us.net>
 <90A7FF2E-F186-49CF-A028-CDE317BE13E1@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <90A7FF2E-F186-49CF-A028-CDE317BE13E1@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Michal Hocko <mhocko@suse.com>, Andi Kleen <ak@linux.intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Hansen <dave.hansen@intel.com>, Pavel Machek <pavel@ucw.cz>, linux-efi@vger.kernel.org, x86@kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, Sep 11, 2018 at 09:36:51AM -0700, Andy Lutomirski wrote:
> >    save_pgd = efi_call_phys_prolog();
> >    local_irq_save(flags);
> >    status = efi_call_phys(...);
> >        local_irq_restore(flags);
> > 
> >        efi_call_phys_epilog(save_pgd);
> > 
> > So, yes, interrupts are very much enabled.
> 
> Does fixing that solve the problem?  It seems more robust.

The problem is still that in efi_call_phys_prolog() we load the gdt with
its physical address, and when we reload the %cr3 in _epilog from
initial_page_table to swapper_pg_dir again the gdt is no longer mapped.
Blocking interrupts is more robust, but we can't block NMIs that way
that would also trigger the issue, no?

So I am in favor of changing the order in efi_call_phys_epilog() too.

Regards,

	Joerg
