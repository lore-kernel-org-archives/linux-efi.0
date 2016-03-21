From: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 3/9] efi/x86: efifb: move DMI based quirks handling out
 of generic code
Date: Mon, 21 Mar 2016 14:54:10 +0100
Message-ID: <CANq1E4SGfZeLdFPab-cA7zz=AHS59z9pfWt3defqhDqroY2WaQ@mail.gmail.com>
References: <1458319661-19762-1-git-send-email-ard.biesheuvel@linaro.org>
	<1458319661-19762-4-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1458319661-19762-4-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, the arch/x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi

On Fri, Mar 18, 2016 at 5:47 PM, Ard Biesheuvel
<ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> The efifb quirks handling based on DMI identification of the platform is
> specific to x86, so move it to x86 arch code.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Fine with me:

Acked-by: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Thanks
David

> ---
>  arch/x86/include/asm/efi.h  |  2 ++
>  arch/x86/kernel/sysfb_efi.c | 15 +++++++++++++++
>  drivers/video/fbdev/efifb.c | 15 ++++-----------
>  3 files changed, 21 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index 7d5187b66108..790adbc3a64a 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -154,6 +154,8 @@ static inline bool efi_runtime_supported(void)
>  extern struct console early_efi_console;
>  extern void parse_efi_setup(u64 phys_addr, u32 data_len);
>
> +extern void efifb_setup_from_dmi(struct screen_info *si, const char *opt);
> +
>  #ifdef CONFIG_EFI_MIXED
>  extern void efi_thunk_runtime_setup(void);
>  extern efi_status_t efi_thunk_set_virtual_address_map(
> diff --git a/arch/x86/kernel/sysfb_efi.c b/arch/x86/kernel/sysfb_efi.c
> index b285d4e8c68e..e21a8a7ddcff 100644
> --- a/arch/x86/kernel/sysfb_efi.c
> +++ b/arch/x86/kernel/sysfb_efi.c
> @@ -68,6 +68,21 @@ struct efifb_dmi_info efifb_dmi_list[] = {
>         [M_UNKNOWN] = { NULL, 0, 0, 0, 0, OVERRIDE_NONE }
>  };
>
> +void efifb_setup_from_dmi(struct screen_info *si, const char *opt)
> +{
> +       int i;
> +
> +       for (i = 0; i < M_UNKNOWN; i++) {
> +               if (efifb_dmi_list[i].base != 0 &&
> +                   !strcmp(opt, efifb_dmi_list[i].optname)) {
> +                       si->lfb_base = efifb_dmi_list[i].base;
> +                       si->lfb_linelength = efifb_dmi_list[i].stride;
> +                       si->lfb_width = efifb_dmi_list[i].width;
> +                       si->lfb_height = efifb_dmi_list[i].height;
> +               }
> +       }
> +}
> +
>  #define choose_value(dmivalue, fwvalue, field, flags) ({       \
>                 typeof(fwvalue) _ret_ = fwvalue;                \
>                 if ((flags) & (field))                          \
> diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
> index 95d293b7445a..dd594369b8a6 100644
> --- a/drivers/video/fbdev/efifb.c
> +++ b/drivers/video/fbdev/efifb.c
> @@ -8,6 +8,7 @@
>
>  #include <linux/module.h>
>  #include <linux/kernel.h>
> +#include <linux/efi.h>
>  #include <linux/errno.h>
>  #include <linux/fb.h>
>  #include <linux/platform_device.h>
> @@ -15,7 +16,7 @@
>  #include <linux/dmi.h>
>  #include <linux/pci.h>
>  #include <video/vga.h>
> -#include <asm/sysfb.h>
> +#include <asm/efi.h>
>
>  static bool request_mem_succeeded = false;
>
> @@ -85,21 +86,13 @@ static struct fb_ops efifb_ops = {
>  static int efifb_setup(char *options)
>  {
>         char *this_opt;
> -       int i;
>
>         if (options && *options) {
>                 while ((this_opt = strsep(&options, ",")) != NULL) {
>                         if (!*this_opt) continue;
>
> -                       for (i = 0; i < M_UNKNOWN; i++) {
> -                               if (efifb_dmi_list[i].base != 0 &&
> -                                   !strcmp(this_opt, efifb_dmi_list[i].optname)) {
> -                                       screen_info.lfb_base = efifb_dmi_list[i].base;
> -                                       screen_info.lfb_linelength = efifb_dmi_list[i].stride;
> -                                       screen_info.lfb_width = efifb_dmi_list[i].width;
> -                                       screen_info.lfb_height = efifb_dmi_list[i].height;
> -                               }
> -                       }
> +                       efifb_setup_from_dmi(&screen_info, this_opt);
> +
>                         if (!strncmp(this_opt, "base:", 5))
>                                 screen_info.lfb_base = simple_strtoul(this_opt+5, NULL, 0);
>                         else if (!strncmp(this_opt, "stride:", 7))
> --
> 2.5.0
>
