From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH V4 2/3] x86/efi: Add efi page fault handler to recover
 from page faults caused by the firmware
Date: Fri, 7 Sep 2018 13:21:48 +0200
Message-ID: <20180907112147.GR24106@hirez.programming.kicks-ass.net>
References: <1536276468-28499-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1536276468-28499-3-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1536276468-28499-3-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, ricardo.neri@intel.com, matt@codeblueprint.co.uk, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Sep 06, 2018 at 04:27:47PM -0700, Sai Praneeth Prakhya wrote:
> @@ -790,6 +792,13 @@ no_context(struct pt_regs *regs, unsigned long error_code,
>  		return;
>  
>  	/*
> +	 * Buggy firmware could access regions which might page fault, try to
> +	 * recover from such faults.
> +	 */
> +	if (efi_recover_from_page_fault(address))
> +		return;
> +
> +	/*
>  	 * Oops. The kernel tried to access some bad page. We'll have to
>  	 * terminate things with extreme prejudice:
>  	 */

> +int efi_recover_from_page_fault(unsigned long phys_addr)
> +{
> +	/* Recover from page faults caused *only* by the firmware */
> +	if (current->active_mm != &efi_mm)
> +		return 0;
> +
> +	/*
> +	 * Address range 0x0000 - 0x0fff is always mapped in the efi_pgd, so
> +	 * page faulting on these addresses isn't expected.
> +	 */
> +	if (phys_addr >= 0x0000 && phys_addr <= 0x0fff)
> +		return 0;
> +
> +	/*
> +	 * Print stack trace as it might be useful to know which EFI Runtime
> +	 * Service is buggy.
> +	 */
> +	WARN(1, FW_BUG "Page fault caused by firmware at PA: 0x%lx\n",
> +	     phys_addr);
> +
> +	/*
> +	 * Buggy efi_reset_system() is handled differently from other EFI
> +	 * Runtime Services as it doesn't use efi_rts_wq. Although,
> +	 * native_machine_emergency_restart() says that machine_real_restart()
> +	 * could fail, it's better not to compilcate this fault handler
> +	 * because this case occurs *very* rarely and hence could be improved
> +	 * on a need by basis.
> +	 */
> +	if (efi_rts_work.efi_rts_id == RESET_SYSTEM) {
> +		pr_info("efi_reset_system() buggy! Reboot through BIOS\n");
> +		machine_real_restart(MRR_BIOS);
> +		return 0;
> +	}
> +
> +	/* Firmware has caused page fault, hence, freeze efi_rts_wq. */
> +	set_current_state(TASK_UNINTERRUPTIBLE);

This doesn't freeze it, as such, it just sets the state.

> +
> +	/*
> +	 * Before calling EFI Runtime Service, the kernel has switched the
> +	 * calling process to efi_mm. Hence, switch back to task_mm.
> +	 */
> +	arch_efi_call_virt_teardown();
> +
> +	/* Signal error status to the efi caller process */
> +	efi_rts_work.status = EFI_ABORTED;
> +	complete(&efi_rts_work.efi_rts_comp);
> +
> +	clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
> +	pr_info("Froze efi_rts_wq and disabled EFI Runtime Services\n");

> +	schedule();

So what happens when we get a spurious wakeup and return from this?

Quite possibly you want something like:

	for (;;) {
		set_current_state(TASK_IDLE);
		schedule();
	}

here. The TASK_UNINTERRUPTIBLE thing will cause the load-avg to spike;
is that what you want?

> +
> +	return 0;
> +}
