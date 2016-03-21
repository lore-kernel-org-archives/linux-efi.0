From: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 8/9] efi/arm*: wire up struct screen_info to
 efi-framebuffer platform device
Date: Mon, 21 Mar 2016 14:53:11 +0100
Message-ID: <CANq1E4RUWKe=fF=9+9qq46ZeU1cgfXU+WmraXKnGLM5zyTVCoQ@mail.gmail.com>
References: <1458319661-19762-1-git-send-email-ard.biesheuvel@linaro.org>
	<1458319661-19762-9-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1458319661-19762-9-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, the arch/x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi

On Fri, Mar 18, 2016 at 5:47 PM, Ard Biesheuvel
<ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> This adds code to the ARM and arm64 EFI init routines to expose a platform
> device of type 'efi-framebuffer' if struct screen_info has been populated
> appropriately from the GOP protocol by the stub. Since the framebuffer may
> potentially be located in system RAM, make sure that the region is reserved
> and marked MEMBLOCK_NOMAP.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/arm-init.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
> index acd44de30504..f5f13b871d42 100644
> --- a/drivers/firmware/efi/arm-init.c
> +++ b/drivers/firmware/efi/arm-init.c
> @@ -19,6 +19,7 @@
>  #include <linux/mm_types.h>
>  #include <linux/of.h>
>  #include <linux/of_fdt.h>
> +#include <linux/platform_device.h>
>  #include <linux/screen_info.h>
>
>  #include <asm/efi.h>
> @@ -76,6 +77,10 @@ static void __init init_screen_info(void)
>                 screen_info = *si;
>                 early_memunmap(si, sizeof(*si));
>         }
> +
> +       if (screen_info.orig_video_isVGA == VIDEO_TYPE_EFI &&
> +           memblock_is_map_memory(screen_info.lfb_base))
> +               memblock_mark_nomap(screen_info.lfb_base, screen_info.lfb_size);
>  }
>
>  static int __init uefi_init(void)
> @@ -235,3 +240,16 @@ void __init efi_init(void)
>
>         init_screen_info();
>  }
> +
> +static int __init register_gop_device(void)
> +{
> +       void *pd;
> +
> +       if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
> +               return 0;
> +
> +       /* the efifb driver accesses screen_info directly, no need to pass it */
> +       pd = platform_device_register_simple("efi-framebuffer", 0, NULL, 0);

I'd really appreciate if you pass "screen_info" as data, just like x86
does. Sure, we still use the global screen_info variable from efifb,
but we should try to reduce the number of global variables and rather
make drivers use the platform-data of the platform device.

Thanks
David
