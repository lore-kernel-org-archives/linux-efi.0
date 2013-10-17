From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v2 2/3] arm: Add [U]EFI runtime services support
Date: Thu, 17 Oct 2013 15:07:39 +0100
Message-ID: <20131017140739.GI10834@console-pimps.org>
References: <1380799481-5470-1-git-send-email-leif.lindholm@linaro.org>
 <1380799481-5470-3-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1380799481-5470-3-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 03 Oct, at 12:24:40PM, Leif Lindholm wrote:
> +/*
> + * If you need to (temporarily) support buggy firmware.
> + */
> +#define KEEP_BOOT_SERVICES_REGIONS

Have you seen firmware that requires this? I'm just curious more than
anything else.

> +/*
> + * Returns 1 if 'facility' is enabled, 0 otherwise.
> + */
> +int efi_enabled(int facility)
> +{
> +	return test_bit(facility, &arm_efi_facility) != 0;
> +}
> +EXPORT_SYMBOL(efi_enabled);

This should move to drivers/firmware/efi/efi.c. Let me write a patch
that moves the x86 stuff out of arch/x86 and means you can get rid of
this hunk.

> +/*
> + * Called explicitly from init/mm.c
> + */

That's init/main.c.

> +void __init efi_enter_virtual_mode(void)
> +{
> +	efi_status_t status;
> +
> +	if (!efi_enabled(EFI_BOOT)) {
> +		pr_info("EFI services will not be available.\n");
> +		return;

This is dead code as PATCH 3 does,

diff --git a/init/main.c b/init/main.c
index af310af..ec6d76e 100644
--- a/init/main.c
+++ b/init/main.c
@@ -875,6 +875,10 @@ static noinline void __init
kernel_init_freeable(void)
	smp_prepare_cpus(setup_max_cpus);

	do_pre_smp_initcalls();
+
+	if (IS_ENABLED(CONFIG_ARM) && efi_enabled(EFI_BOOT))
+		efi_enter_virtual_mode();
+


-- 
Matt Fleming, Intel Open Source Technology Center
