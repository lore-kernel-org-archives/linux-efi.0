From: Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/4] efi: provide a generic efi_config_init()
Date: Tue, 30 Jul 2013 10:53:10 -0700
Message-ID: <CA+8MBbK5S3z+VQhhuT5WT7=7zYy=5zyvZEWfnfTfc1NxXBa=Sg@mail.gmail.com>
References: <1375202858-28470-1-git-send-email-leif.lindholm@linaro.org>
	<1375202858-28470-2-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375202858-28470-2-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Jul 30, 2013 at 9:47 AM, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> +       /*
> +        * Let's see what config tables the firmware passed to us.
> +        */
> +       config_tables = early_mememap(efi.systab->tables,
> +                                      efi.systab->nr_tables * sz);

Breaks bisection on ia64 ... you use early_mememap() here, but don't
define it on ia64 until patch 3/4.  So I get:

drivers/firmware/efi/efi.c: In function 'efi_config_init':
drivers/firmware/efi/efi.c:200: error: implicit declaration of
function 'early_memremap'
drivers/firmware/efi/efi.c:201: warning: assignment makes pointer from
integer without a cast

-Tony
