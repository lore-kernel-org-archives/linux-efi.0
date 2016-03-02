From: "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH][RFC] ACPI / PM: Fix poweroff issue on HW-full platforms
 without _S5
Date: Thu, 3 Mar 2016 00:45:08 +0100
Message-ID: <CAJZ5v0h75Ly4-R7jOCt=o+QtcLOZycC7kzKxkdP6Xy-teCiJ7w@mail.gmail.com>
References: <1456925357-2899-1-git-send-email-yu.c.chen@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456925357-2899-1-git-send-email-yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chen Yu <yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: ACPI Devel Maling List <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Zhang, Rui" <rui.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lv <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Mar 2, 2016 at 2:29 PM, Chen Yu <yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> The problem is Linux registers pm_power_off = efi_power_off
> only if we are in hardware reduced mode. Actually, what we also
> want is to do this when ACPI S5 is simply not supported.
> That should handle both the HW reduced mode, and the HW-full
> mode where the DSDT fails to supply an _S5 object.
>
> This patch fixes this issue by introducing a new flag acpi_no_s5 which
> indicates the non-existence of _S5. The initial state of acpi_no_s5 is
> false and probed in acpi_sleep_init, then we'll later see the updated
> value in efi_poweroff_required, according to which we can set pm_power_off
> to efi_power_off in efi_shutdown_init.
>
> Suggested-by: Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Chen Yu <yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/platform/efi/quirks.c | 3 ++-
>  drivers/acpi/sleep.c           | 2 ++
>  include/acpi/acpixf.h          | 6 ++++++
>  3 files changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index 2d66db8..8ec43bc 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -295,5 +295,6 @@ bool efi_reboot_required(void)
>
>  bool efi_poweroff_required(void)
>  {
> -       return !!acpi_gbl_reduced_hardware;
> +       return (!!acpi_gbl_reduced_hardware)
> +               || (!!acpi_no_s5);

This can be written as:

    return acpi_gbl_reduced_hardware || acpi_no_s5;

>  }
> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> index 9cb9752..6f75e54 100644
> --- a/drivers/acpi/sleep.c
> +++ b/drivers/acpi/sleep.c
> @@ -846,6 +846,8 @@ int __init acpi_sleep_init(void)
>                 sleep_states[ACPI_STATE_S5] = 1;
>                 pm_power_off_prepare = acpi_power_off_prepare;
>                 pm_power_off = acpi_power_off;
> +       } else {
> +               acpi_no_s5 = TRUE;
>         }
>
>         supported[0] = 0;
> diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
> index c96621e..2b4d7f7 100644
> --- a/include/acpi/acpixf.h
> +++ b/include/acpi/acpixf.h
> @@ -252,6 +252,12 @@ ACPI_INIT_GLOBAL(u8, acpi_gbl_osi_data, 0);
>  ACPI_INIT_GLOBAL(u8, acpi_gbl_reduced_hardware, FALSE);
>
>  /*
> + * Some HW-full platforms do not have S5, so they may need
> + * to leverage efi power off for a shutdown.
> + */
> +ACPI_INIT_GLOBAL(u8, acpi_no_s5, FALSE);

Do you have to add it here?

Can't you simply define it as a global bool variable in sleep.c and
add a declaration to include/linux/acpi.h?

> +
> +/*
>   * This mechanism is used to trace a specified AML method. The method is
>   * traced each time it is executed.
>   */
> --

Thanks,
Rafael
