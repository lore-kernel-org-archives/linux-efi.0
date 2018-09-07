From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH V4 2/3] x86/efi: Add efi page fault handler to recover
 from page faults caused by the firmware
Date: Fri, 7 Sep 2018 18:29:07 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F485BA5D7@ORSMSX114.amr.corp.intel.com>
References: <1536276468-28499-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1536276468-28499-3-git-send-email-sai.praneeth.prakhya@intel.com>
 <20180907112147.GR24106@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180907112147.GR24106@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Neri, Ricardo" <ricardo.neri@intel.com>, "matt@codeblueprint.co.uk" <matt@codeblueprint.co.uk>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

> > +	if (efi_rts_work.efi_rts_id == RESET_SYSTEM) {
> > +		pr_info("efi_reset_system() buggy! Reboot through BIOS\n");
> > +		machine_real_restart(MRR_BIOS);
> > +		return 0;
> > +	}
> > +
> > +	/* Firmware has caused page fault, hence, freeze efi_rts_wq. */
> > +	set_current_state(TASK_UNINTERRUPTIBLE);
> 
> This doesn't freeze it, as such, it just sets the state.

True! Thanks for pointing it out. I will update the comment.

> > +
> > +	/*
> > +	 * Before calling EFI Runtime Service, the kernel has switched the
> > +	 * calling process to efi_mm. Hence, switch back to task_mm.
> > +	 */
> > +	arch_efi_call_virt_teardown();
> > +
> > +	/* Signal error status to the efi caller process */
> > +	efi_rts_work.status = EFI_ABORTED;
> > +	complete(&efi_rts_work.efi_rts_comp);
> > +
> > +	clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
> > +	pr_info("Froze efi_rts_wq and disabled EFI Runtime Services\n");
> 
> > +	schedule();
> 
> So what happens when we get a spurious wakeup and return from this?
> 
> Quite possibly you want something like:
> 
> 	for (;;) {
> 		set_current_state(TASK_IDLE);
> 		schedule();
> 	}
> 
> here. The TASK_UNINTERRUPTIBLE thing will cause the load-avg to spike; is that
> what you want?

Yes, makes sense. TASK_IDLE seems more appropriate. I will change it.

Regards,
Sai
