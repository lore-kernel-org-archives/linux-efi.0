From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v5 6/8] efi: load SSTDs from EFI variables
Date: Sat, 2 Jul 2016 10:18:30 +0200
Message-ID: <CAMuHMdXG2=1RBaVipW_piizZSWduiUyFLGM+45AnqRttr80S5A@mail.gmail.com>
References: <1467404352-27101-1-git-send-email-octavian.purdila@intel.com> <1467404352-27101-7-git-send-email-octavian.purdila@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-i2c-owner@vger.kernel.org>
In-Reply-To: <1467404352-27101-7-git-send-email-octavian.purdila@intel.com>
Sender: linux-i2c-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, linux-efi@vger.kernel.org, Linux I2C <linux-i2c@vger.kernel.org>, linux-spi <linux-spi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, irina.tirdea@intel.com, Crestez Dan Leonard <leonard.crestez@intel.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Jul 1, 2016 at 10:19 PM, Octavian Purdila
<octavian.purdila@intel.com> wrote:
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c

> @@ -195,6 +198,85 @@ static void generic_ops_unregister(void)
>         efivars_unregister(&generic_efivars);
>  }
>
> +#if IS_ENABLED(CONFIG_ACPI)
> +#define EFIVAR_SSDT_NAME_MAX   16
> +static char efivar_ssdt[EFIVAR_SSDT_NAME_MAX];

I think efivar_ssdt[] is used from __init functions only, so it can be
__initdata.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
