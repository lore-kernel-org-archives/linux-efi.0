From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 09/13] efi/arm64: Check for h/w support before booting a
 >4 KB granule kernel
Date: Sun, 6 Mar 2016 04:35:32 +0100
Message-ID: <CAKv+Gu-ZHz9Z6YyusLZdKJA4QPJ8fkxVWaA=EQvTM5iSLM7c1Q@mail.gmail.com>
References: <1455712566-16727-1-git-send-email-matt@codeblueprint.co.uk>
	<1455712566-16727-10-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455712566-16727-10-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 17 February 2016 at 13:36, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> A kernel built with support for a page size that is not supported by the
> hardware it runs on cannot boot to a state where it can inform the user
> about it.
>
> If we happen to be booting via UEFI, we can fail gracefully so check
> if the currently configured page size is supported by the hardware before
> entering the kernel proper. Note that UEFI mandates support for 4 KB pages,
> so in that case, no check is needed.
>
> Reviewed-by: Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>
> Tested-by: Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>

Hi Matt,

This patch turned up in -next with 'granule' replaced with 'granular',
both in the commit log and in the patch itself. The term 'granule' is
part of the idiom used by the ARM Architecture Reference Manual, and
so changing it silently to 'granular' is not entirely appropriate here
(although harmless in practice, obviously). In general, I would
appreciate it if in the future, such changes were not made silently
somewhere in the merge pipeline.

Thanks,
Ard.


> ---
>  drivers/firmware/efi/libstub/arm64-stub.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
> index 9e0342745e4f..aef04ad60e0d 100644
> --- a/drivers/firmware/efi/libstub/arm64-stub.c
> +++ b/drivers/firmware/efi/libstub/arm64-stub.c
> @@ -12,6 +12,26 @@
>  #include <linux/efi.h>
>  #include <asm/efi.h>
>  #include <asm/sections.h>
> +#include <asm/sysreg.h>
> +
> +efi_status_t check_platform_features(efi_system_table_t *sys_table_arg)
> +{
> +       u64 tg;
> +
> +       /* UEFI mandates support for 4 KB granule, no need to check */
> +       if (IS_ENABLED(CONFIG_ARM64_4K_PAGES))
> +               return EFI_SUCCESS;
> +
> +       tg = (read_cpuid(ID_AA64MMFR0_EL1) >> ID_AA64MMFR0_TGRAN_SHIFT) & 0xf;
> +       if (tg != ID_AA64MMFR0_TGRAN_SUPPORTED) {
> +               if (IS_ENABLED(CONFIG_ARM64_64K_PAGES))
> +                       pr_efi_err(sys_table_arg, "This 64 KB granule kernel is not supported by your CPU\n");
> +               else
> +                       pr_efi_err(sys_table_arg, "This 16 KB granule kernel is not supported by your CPU\n");
> +               return EFI_UNSUPPORTED;
> +       }
> +       return EFI_SUCCESS;
> +}
>
>  efi_status_t handle_kernel_image(efi_system_table_t *sys_table_arg,
>                                  unsigned long *image_addr,
> --
> 2.6.2
>
