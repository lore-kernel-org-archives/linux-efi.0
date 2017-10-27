From: Daniel Drake <drake-6IF/jdPJHihWk0Htik3J/w@public.gmane.org>
Subject: Re: Multiple Acer laptops hang on ACPI poweroff
Date: Fri, 27 Oct 2017 14:35:56 +0800
Message-ID: <CAD8Lp44G_1R4gP9AFpEm34Y+DBmnWGgpBZbuTjimhi9uCQEKdg@mail.gmail.com>
References: <20170303201524.8150-1-drake@endlessm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170303201524.8150-1-drake-6IF/jdPJHihWk0Htik3J/w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ACPI Devel Maling List <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wysocki, Rafael J" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux PM <linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Linux Upstreaming Team <linux-6IF/jdPJHihWk0Htik3J/w@public.gmane.org>, Chris Chiu <chiu-6IF/jdPJHihWk0Htik3J/w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Mar 4, 2017 at 4:15 AM, Daniel Drake <drake-6IF/jdPJHihWk0Htik3J/w@public.gmane.org> wrote:
> Some particular Acer/Packard Bell machines hang during shutdown.
> The system completely hangs while doing bit operations for turning on SLP_EN
> bit in ACPI PM1A control address and Sleep Control Register. Thus the
> normal acpi_power_off path can never complete the shutdown process.
>
> We have found a workaround to force these systems to use EFI for poweroff,
> included below, but I wonder if anything better can be done. It is especially
> not ideal because the system hangs the same way when going into suspend and
> we don't have a workaround for that.

Testing shutdown on Acer Aspire ES1-732 (Intel Apollo Lake N4200) on
Linux 4.14-rc6, this issue is still present.

The FADT has:

[0ACh 0172  12]           PM1A Control Block : [Generic Address Structure]
[0ACh 0172   1]                     Space ID : 01 [SystemIO]
[0ADh 0173   1]                    Bit Width : 10
[0AEh 0174   1]                   Bit Offset : 00
[0AFh 0175   1]         Encoded Access Width : 02 [Word Access:16]
[0B0h 0176   8]                      Address : 0000000000000404

Full ACPI tables dump:
https://gist.github.com/dsd/ed80d9fdd32f99e310002b2492cd6e1b

We have tested that writing bit 13 of port 0404 under Windows 10
(using an app called RW everything) results in an immediate and
successful power down. However, writing the same bit under Linux just
makes the system hang.

I am not really familiar with the guts of x86 systems. When the OS
writes to this port, which component of the system receives that
request and acts accordingly? Is it handled by the BIOS? Or an EC, or
...? With more background here we may be able to approach the relevant
component vendor and ask for help.

Searching the web for "pm1a control 0000000000000404" I can see at
least a handful of systems with the exact same address here; could
just be a coincidence, or is there some kind of standardization?

Any other debugging suggestions would be very welcome.

Thanks
Daniel


> ---
>  drivers/firmware/efi/reboot.c | 42 +++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 41 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/reboot.c b/drivers/firmware/efi/reboot.c
> index 62ead9b..6d1496d 100644
> --- a/drivers/firmware/efi/reboot.c
> +++ b/drivers/firmware/efi/reboot.c
> @@ -4,6 +4,7 @@
>   */
>  #include <linux/efi.h>
>  #include <linux/reboot.h>
> +#include <linux/dmi.h>
>
>  int efi_reboot_quirk_mode = -1;
>
> @@ -43,6 +44,45 @@ void efi_reboot(enum reboot_mode reboot_mode, const char *__unused)
>         efi.reset_system(efi_mode, EFI_SUCCESS, 0, NULL);
>  }
>
> +static const struct dmi_system_id force_efi_poweroff[] = {
> +        {
> +                .ident = "Packard Bell Easynote ENLG81AP",
> +                .matches = {
> +                        DMI_MATCH(DMI_SYS_VENDOR, "Packard Bell"),
> +                        DMI_MATCH(DMI_PRODUCT_NAME, "Easynote ENLG81AP"),
> +                },
> +        },
> +        {
> +                .ident = "Packard Bell Easynote ENTE69AP",
> +                .matches = {
> +                        DMI_MATCH(DMI_SYS_VENDOR, "Packard Bell"),
> +                        DMI_MATCH(DMI_PRODUCT_NAME, "Easynote ENTE69AP"),
> +                },
> +        },
> +        {
> +                .ident = "Acer Aspire ES1-533",
> +                .matches = {
> +                        DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
> +                        DMI_MATCH(DMI_PRODUCT_NAME, "Aspire ES1-533"),
> +                },
> +        },
> +        {
> +                .ident = "Acer Aspire ES1-732",
> +                .matches = {
> +                        DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
> +                        DMI_MATCH(DMI_PRODUCT_NAME, "Aspire ES1-732"),
> +                },
> +        },
> +        {}
> +};
> +
> +bool efi_poweroff_forced(void)
> +{
> +       if (dmi_check_system(force_efi_poweroff))
> +               return true;
> +       return false;
> +}
> +
>  bool __weak efi_poweroff_required(void)
>  {
>         return false;
> @@ -58,7 +98,7 @@ static int __init efi_shutdown_init(void)
>         if (!efi_enabled(EFI_RUNTIME_SERVICES))
>                 return -ENODEV;
>
> -       if (efi_poweroff_required())
> +       if (efi_poweroff_required() || efi_poweroff_forced())
>                 pm_power_off = efi_power_off;
>
>         return 0;
> --
> 2.9.3
>
