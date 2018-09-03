From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V2 4/6] x86/efi: Add efi page fault handler to fixup/recover
 from page faults caused by firmware
Date: Mon, 3 Sep 2018 10:58:33 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1809031053340.1349@nanos.tec.linutronix.de>
References: <1535881594-25469-1-git-send-email-sai.praneeth.prakhya@intel.com> <1535881594-25469-5-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1535881594-25469-5-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, ricardo.neri@intel.com, matt@codeblueprint.co.uk, Lee Chun-Yi <jlee@suse.com>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 2 Sep 2018, Sai Praneeth Prakhya wrote:
> Kernel panics/hangs because the memory region requested by the firmware
> isn't mapped, which causes a page fault in ring 0 and the kernel fails
> to handle it, leading to die(). To save kernel from hanging, add an efi
> specific page fault handler which detects illegal accesses by the
> firmware and
> 1. If the illegally accessed region is EFI_BOOT_SERVICES_<CODE/DATA>,
>    the efi page fault handler fixes it up by mapping the requested
>    region.
> 2. If any other region (Eg: EFI_CONVENTIONAL_MEMORY or
>    EFI_LOADER_<CODE/DATA>), then the efi page fault handler freezes
>    efi_rts_wq and schedules a new process.
> 3. If the access is to any other efi region like above but if the efi
>    runtime service is efi_reset_system(), then the efi page fault
>    handler will reboot the machine through BIOS.
> 
> Illegal accesses to EFI_BOOT_SERVICES_<CODE/DATA> and to other regions
> are dealt differently in efi page fault handler because, *generally*
> EFI_BOOT_SERVICES_<CODE/DATA> regions are smaller in size relative to
> other efi regions and hence could be reserved and can be dynamically
> mapped. But other EFI regions like EFI_CONVENTIONAL_MEMORY and
> EFI_LOADER_<CODE/DATA> cannot be reserved as they are very huge in size
> and reserving them will make the kernel un-bootable.
> 
> The efi specific page fault handler offers us two advantages:
> 1. Avoid panics/hangs caused by buggy firmware.
> 2. Shout loud that the firmware is buggy and hence is not a kernel bug.
> 
> Finally, this new mapping will not impact a reboot from kexec, as kexec
> is only concerned about runtime memory regions.

No. This is just a horrible hack to make completely bogus firmware work and
never fixed.

The proper thing to do is to have a minimal page fault handler which does:

 1) Yell loudly if that ever happens

 2) Handles the reboot request gracefully

 3) Freeze and disable the EFI mess for all other cases

That does not require any hackery to make these mappings work from atomic
context and keeps the mess confined to the EFI code where it belongs.

Ideally we just blacklist the offending system and be done with it.

Thanks,

	tglx
