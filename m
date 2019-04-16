From: Ingo Molnar <mingo@kernel.org>
Subject: EFI reboot vs. ACPI reboot (was: Re: [tip:x86/urgent] x86/reboot,
 efi: Use EFI reboot for Acer TravelMate X514-51T)
Date: Tue, 16 Apr 2019 10:20:42 +0200
Message-ID: <20190416082042.GA69717@gmail.com>
References: <20190412080152.3718-1-jian-hong@endlessm.com>
 <tip-0082517fa4bce073e7cf542633439f26538a14cc@git.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <tip-0082517fa4bce073e7cf542633439f26538a14cc@git.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: peterz@infradead.org, bp@alien8.de, drake@endlessm.com, tglx@linutronix.de, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, jian-hong@endlessm.com, matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org, hpa@zytor.com, linux-efi@vger.kernel.org, Len Brown <len.brown@intel.com>
Cc: linux-tip-commits@vger.kernel.org
List-Id: linux-efi@vger.kernel.org


(Cc:-ed EFI and ACPI folks.)

* tip-bot for Jian-Hong Pan <tipbot@zytor.com> wrote:

> Commit-ID:  0082517fa4bce073e7cf542633439f26538a14cc
> Gitweb:     https://git.kernel.org/tip/0082517fa4bce073e7cf542633439f26538a14cc
> Author:     Jian-Hong Pan <jian-hong@endlessm.com>
> AuthorDate: Fri, 12 Apr 2019 16:01:53 +0800
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Tue, 16 Apr 2019 10:01:24 +0200
> 
> x86/reboot, efi: Use EFI reboot for Acer TravelMate X514-51T
> 
> Upon reboot, the Acer TravelMate X514-51T laptop appears to complete the
> shutdown process, but then it hangs in BIOS POST with a black screen.
> 
> The problem is intermittent - at some points it has appeared related to
> Secure Boot settings or different kernel builds, but ultimately we have
> not been able to identify the exact conditions that trigger the issue to
> come and go.
> 
> Besides, the EFI mode cannot be disabled in the BIOS of this model.
> 
> However, after extensive testing, we observe that using the EFI reboot
> method reliably avoids the issue in all cases.
> 
> So add a boot time quirk to use EFI reboot on such systems.
> 
> Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=203119
> Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> Signed-off-by: Daniel Drake <drake@endlessm.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-efi@vger.kernel.org
> Cc: linux@endlessm.com
> Link: http://lkml.kernel.org/r/20190412080152.3718-1-jian-hong@endlessm.com
> [ Fix !CONFIG_EFI build failure, clarify the code and the changelog a bit. ]
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/kernel/reboot.c | 21 +++++++++++++++++++++
>  include/linux/efi.h      |  7 ++++++-
>  2 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index 725624b6c0c0..8fd3cedd9acc 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -81,6 +81,19 @@ static int __init set_bios_reboot(const struct dmi_system_id *d)
>  	return 0;
>  }
>  
> +/*
> + * Some machines don't handle the default ACPI reboot method and
> + * require the EFI reboot method:
> + */
> +static int __init set_efi_reboot(const struct dmi_system_id *d)
> +{
> +	if (reboot_type != BOOT_EFI && !efi_runtime_disabled()) {
> +		reboot_type = BOOT_EFI;
> +		pr_info("%s series board detected. Selecting EFI-method for reboot.\n", d->ident);
> +	}
> +	return 0;
> +}
> +
>  void __noreturn machine_real_restart(unsigned int type)
>  {
>  	local_irq_disable();
> @@ -166,6 +179,14 @@ static const struct dmi_system_id reboot_dmi_table[] __initconst = {
>  			DMI_MATCH(DMI_PRODUCT_NAME, "AOA110"),
>  		},
>  	},
> +	{	/* Handle reboot issue on Acer TravelMate X514-51T */
> +		.callback = set_efi_reboot,
> +		.ident = "Acer TravelMate X514-51T",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate X514-51T"),
> +		},
> +	},
>  
>  	/* Apple */
>  	{	/* Handle problems with rebooting on Apple MacBook5 */
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 54357a258b35..6ebc2098cfe1 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1611,7 +1611,12 @@ efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
>  			   struct screen_info *si, efi_guid_t *proto,
>  			   unsigned long size);
>  
> -bool efi_runtime_disabled(void);
> +#ifdef CONFIG_EFI
> +extern bool efi_runtime_disabled(void);
> +#else
> +static inline bool efi_runtime_disabled(void) { return true; }
> +#endif
> +

1)

Small build fix:

I added the efi.h bit to make it build on !CONFIG_EFI. Turns out 
efi_runtime_disabled() was already used in !CONFIG_EFI code, but its 
usage was masked by efi_reboot_required():

        if (!rv && efi_reboot_required() && !efi_runtime_disabled())


2)

I wanted to get a second opinion from the EFI folks for this whole 
concept. On x86 we default to ACPI reboot on modern systems, and we 
default to EFI reboot on modern EFI systems, via the 
efi_reboot_required() method which keys off on acpi_gbl_reduced_hardware 
to create a barrier for older ACPI systems.

It appears that Acer TravelMate X514-51T systems get marked as 
'acpi_gbl_reduced_hardware' which enables ACPI-reboot, but they require 
EFI-reboot.

Should we perhaps re-think the boundary between EFI-reboot and 
ACPI-reboot systems? I.e. if the EFI runtime is enabled, shouldn't we 
just use the EFI reboot method?

What does Windows do (which is really the standard test desktop PC makers 
use) - do they use the EFI reboot method unconditionally, or do they have 
more complex quirks as well?

Anyway, I applied the patch because it solves a spurious reboot hang bug 
on these systems, but wanted to raise this whole EFI reboot vs. ACPI 
reboot issue, as quirks are generally not overly precise in identifying 
the true scope of problems.

Thanks,

	Ingo
