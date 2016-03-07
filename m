From: "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH][RFC v3] ACPI / PM: Fix poweroff issue on HW-full
 platforms without _S5
Date: Mon, 7 Mar 2016 14:19:13 +0100
Message-ID: <CAJZ5v0iWjW_XJEsVBM1yyimxUQMDaWapQ_OrN45TeFXFySd0rw@mail.gmail.com>
References: <1457319045-25434-1-git-send-email-yu.c.chen@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457319045-25434-1-git-send-email-yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chen Yu <yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: ACPI Devel Maling List <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Zhang Rui <rui.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Mar 7, 2016 at 3:50 AM, Chen Yu <yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> The problem is Linux registers pm_power_off = efi_power_off
> only if we are in hardware reduced mode. Actually, what we also
> want is to do this when ACPI S5 is simply not supported on
> non-legacy platforms. That should handle both the HW reduced mode,
> and the HW-full mode where the DSDT fails to supply an _S5 object.
>
> This patch fixes this issue by introducing a new flag acpi_no_s5 which
> indicates the non-existence of _S5. The initial state of acpi_no_s5 is
> false and probed in acpi_sleep_init, then we'll later see the updated
> value in efi_poweroff_required, according to which we can set pm_power_off
> to efi_power_off in efi_shutdown_init, if no other pm_power_off available.
>
> Suggested-by: Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Chen Yu <yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
> v3:
>  - Only assign pm_power_off to efi_power_off when there are no
>    other pm_power_off registered at that time, in case other
>    commponents would like to customize their own implementation.
> ---
> v2:
>  - Convert the acpi_no_s5 to a global bool variable in sleep.c and
>    add a declaration to include/linux/acpi.h.
> ---
>  arch/x86/platform/efi/quirks.c | 2 +-
>  drivers/acpi/sleep.c           | 8 ++++++++
>  include/linux/acpi.h           | 1 +
>  3 files changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index 2d66db8..0d4186b 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -295,5 +295,5 @@ bool efi_reboot_required(void)
>
>  bool efi_poweroff_required(void)
>  {
> -       return !!acpi_gbl_reduced_hardware;
> +       return acpi_gbl_reduced_hardware || (acpi_no_s5 && !pm_power_off);

What if CONFIG_ACPI is not set here?

>  }

Thanks,
Rafael
