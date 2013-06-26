From: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>
Subject: Re: [PATCH 4/4] init: efi: arm: enable (U)EFI runtime services on arm
Date: Wed, 26 Jun 2013 14:24:11 +0100
Message-ID: <CACxGe6tRBQdxN=5SrO7ES0N3R+nPeVpJDkBx5WHtKQSxPHb01Q@mail.gmail.com>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org> <1372183863-11333-5-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372183863-11333-5-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Jun 25, 2013 at 7:11 PM, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> Since the efi_set_virtual_address_map call has strict init ordering
> requirements, add an explicit hook in the required place.
>
> Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  init/main.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/init/main.c b/init/main.c
> index 9484f4b..c61706e 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -872,6 +872,12 @@ static noinline void __init kernel_init_freeable(void)
>         smp_prepare_cpus(setup_max_cpus);
>
>         do_pre_smp_initcalls();
> +
> +#ifdef CONFIG_ARM
> +       if (efi_enabled(EFI_RUNTIME_SERVICES))
> +               efi_enter_virtual_mode();
> +#endif

Nitpick:  Alternately you could use:

        if (IS_ENABLED(CONFIG_ARM) && efi_enabled(EFI_RUNTIME_SERVICES))
                efi_enter_virtual_mode();

That would get away from the #ifdef

g.
