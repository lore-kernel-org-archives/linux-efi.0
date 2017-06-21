From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: efi/reboot: Fall back to original power-off method if
 EFI_RESET_SHUTDOWN returns
Date: Wed, 21 Jun 2017 15:15:09 +0200
Message-ID: <430d6ff2-264a-80f8-24e0-0d9af4377844@redhat.com>
References: <20170423123655.13015-1-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20170423123655.13015-1-hdegoede@redhat.com>
Content-Language: en-US
Sender: linux-acpi-owner@vger.kernel.org
To: Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-acpi@vger.kernel.org, Peter Jones <pjones@redhat.com>, linux-efi@vger.kernel.org, Mark Salter <msalter@redhat.com>
List-Id: linux-efi@vger.kernel.org

HI,

On 23-04-17 14:36, Hans de Goede wrote:
> Commit 44be28e9dd98 ("x86/reboot: Add EFI reboot quirk for ACPI Hardware
> Reduced flag") sets pm_power_off to efi_power_off() when the
> acpi_gbl_reduced_hardware flag is set.
> 
> According to its commit message this is necessary because: "BayTrail-T
> class of hardware requires EFI in order to powerdown and reboot and no
> other reliable method exists"
> 
> But I have a Bay Trail CR tablet where the EFI_RESET_SHUTDOWN call does
> not work, it simply returns without doing anything (AFAICT).
> 
> So it seems that some Bay Trail devices must use EFI for power-off, while
> for others only ACPI works.
> 
> Note that efi_power_off() only gets used if the platform code defines
> efi_poweroff_required() and that returns true, this currently only ever
> happens on x86.
> 
> Since on the devices which need ACPI for power-off the EFI_RESET_SHUTDOWN
> call simply returns, this patch makes the efi-reboot code remember the
> old pm_power_off handler and if EFI_RESET_SHUTDOWN returns it falls back
> to calling that.
> 
> This seems preferable to dmi-quirking our way out of this, since there
> are likely quite a few devices suffering from this.
> 
> Cc: Mark Salter <msalter@redhat.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

What is the status of this patch ? It has had 2 somewhat favorable
reviews and then things went silent ?

Regards,

Hans



> ---
>   drivers/firmware/efi/reboot.c | 12 +++++++++++-
>   1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/reboot.c b/drivers/firmware/efi/reboot.c
> index 62ead9b..7117e2d 100644
> --- a/drivers/firmware/efi/reboot.c
> +++ b/drivers/firmware/efi/reboot.c
> @@ -5,6 +5,8 @@
>   #include <linux/efi.h>
>   #include <linux/reboot.h>
>   
> +void (*orig_pm_power_off)(void);
> +
>   int efi_reboot_quirk_mode = -1;
>   
>   void efi_reboot(enum reboot_mode reboot_mode, const char *__unused)
> @@ -51,6 +53,12 @@ bool __weak efi_poweroff_required(void)
>   static void efi_power_off(void)
>   {
>   	efi.reset_system(EFI_RESET_SHUTDOWN, EFI_SUCCESS, 0, NULL);
> +	/*
> +	 * The above call should not return, if it does fall back to
> +	 * the original power off method (typically ACPI poweroff).
> +	 */
> +	if (orig_pm_power_off)
> +		orig_pm_power_off();
>   }
>   
>   static int __init efi_shutdown_init(void)
> @@ -58,8 +66,10 @@ static int __init efi_shutdown_init(void)
>   	if (!efi_enabled(EFI_RUNTIME_SERVICES))
>   		return -ENODEV;
>   
> -	if (efi_poweroff_required())
> +	if (efi_poweroff_required()) {
> +		orig_pm_power_off = pm_power_off;
>   		pm_power_off = efi_power_off;
> +	}
>   
>   	return 0;
>   }
> 
