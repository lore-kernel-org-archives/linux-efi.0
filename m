From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] x86/efi: Optimize away setup_gop32/64 if unused
Date: Tue, 6 Sep 2016 09:03:26 +0100
Message-ID: <CAKv+Gu8Jw_fOdHJwogwoOt6k2WcNXG-4_cRPTO0U9UKdEa6AqA@mail.gmail.com>
References: <188ea850c957034d482576dfdcf8c8a2536460cf.1471823100.git.lukas@wunner.de>
 <f80213780594fdb86b3c1f7256b459856ee953be.1473140971.git.lukas@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f80213780594fdb86b3c1f7256b459856ee953be.1473140971.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 6 September 2016 at 07:05, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
> Commit 2c23b73c2d02 ("x86/efi: Prepare GOP handling code for reuse
> as generic code") introduced an efi_is_64bit() macro to x86 which
> previously only existed for arm arches.  The macro is used to
> choose between the 64 bit or 32 bit code path in gop.c at runtime.
>

Not that it matters, but this is not entirely accurate. The whole
point of introducing efi_is_64bit() also on ARM was to allow the GOP
code to be shared.

> However the code path that's going to be taken is known at compile
> time when compiling for x86_32 or for x86_64 with mixed mode disabled.
> Amend the macro to eliminate the unused code path in those cases.
>
> Size of gop.o text section:
> CONFIG_X86_32:                         1758 before, 1299 after
> CONFIG_X86_64 && !CONFIG_EFI_MIXED:    2201 before, 1406 after
> CONFIG_X86_64 &&  CONFIG_EFI_MIXED:    2201 before and after
>
> Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/x86/include/asm/efi.h | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index d0bb76d..520c4b7 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -207,14 +207,23 @@ struct efi_config {
>
>  __pure const struct efi_config *__efi_early(void);
>
> +static inline bool efi_is_64bit(void)
> +{
> +       if (!IS_ENABLED(CONFIG_X86_64))
> +               return false;
> +
> +       if (!IS_ENABLED(CONFIG_EFI_MIXED))
> +               return true;
> +
> +       return __efi_early()->is64;
> +}
> +

This looks fine to me. We had trouble in the past with accessing data
symbols between objects, due to problems with the GOT fixup code, but
since you are still calling __efi_early() as a function, this change
should not cause any problems in that area.

Reviewed-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>


>  #define efi_call_early(f, ...)                                         \
>         __efi_early()->call(__efi_early()->f, __VA_ARGS__);
>
>  #define __efi_call_early(f, ...)                                       \
>         __efi_early()->call((unsigned long)f, __VA_ARGS__);
>
> -#define efi_is_64bit()         __efi_early()->is64
> -
>  extern bool efi_reboot_required(void);
>
>  #else
> --
> 2.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
