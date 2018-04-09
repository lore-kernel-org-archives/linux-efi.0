From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v3 5/5] platform/x86: touchscreen_dmi: Add info for the
 Chuwi Vi8 Plus tablet
Date: Mon, 9 Apr 2018 11:10:16 +0300
Message-ID: <CAHp75VdM2Z+GeHE6154h7jJ5q2rWCEbVqVZRvo49fvZuaQcGjQ@mail.gmail.com>
References: <20180408174014.21908-1-hdegoede@redhat.com> <20180408174014.21908-6-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180408174014.21908-6-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Platform Driver <platform-driver-x86@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Dmitry Torokhov <dmitry.torokhov@>
List-Id: linux-efi@vger.kernel.org

On Sun, Apr 8, 2018 at 8:40 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> Add touchscreen info for the Chuwi Vi8 Plus tablet. This tablet uses a
> Chipone ICN8505 touchscreen controller, with the firmware used by the
> touchscreen embedded in the EFI firmware.
>

Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/platform/x86/touchscreen_dmi.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>
> diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
> index 6488cd50ba79..5fdb6fe878f4 100644
> --- a/drivers/platform/x86/touchscreen_dmi.c
> +++ b/drivers/platform/x86/touchscreen_dmi.c
> @@ -301,6 +301,22 @@ static const struct ts_dmi_data teclast_x3_plus_data = {
>         .properties     = teclast_x3_plus_props,
>  };
>
> +static const struct property_entry efi_embedded_fw_props[] = {
> +       PROPERTY_ENTRY_BOOL("efi-embedded-firmware"),
> +       { }
> +};
> +
> +static const struct ts_dmi_data chuwi_vi8_plus_data = {
> +       .embedded_fw = {
> +               .name   = "chipone/icn8505-HAMP0002.fw",
> +               .prefix = { 0xb0, 0x07, 0x00, 0x00, 0xe4, 0x07, 0x00, 0x00 },
> +               .length = 35012,
> +               .crc    = 0x74dfd3fc,
> +       },
> +       .acpi_name      = "CHPN0001:00",
> +       .properties     = efi_embedded_fw_props,
> +};
> +
>  const struct dmi_system_id touchscreen_dmi_table[] = {
>         {
>                 /* CUBE iwork8 Air */
> @@ -487,6 +503,15 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
>                         DMI_MATCH(DMI_PRODUCT_NAME, "Y8W81"),
>                 },
>         },
> +       {
> +               /* Chuwi Vi8 Plus (CWI506) */
> +               .driver_data = (void *)&chuwi_vi8_plus_data,
> +               .matches = {
> +                       DMI_MATCH(DMI_SYS_VENDOR, "Hampoo"),
> +                       DMI_MATCH(DMI_PRODUCT_NAME, "D2D3_Vi8A1"),
> +                       DMI_MATCH(DMI_BOARD_NAME, "Cherry Trail CR"),
> +               },
> +       },
>         { },
>  };
>
> --
> 2.17.0
>



-- 
With Best Regards,
Andy Shevchenko
