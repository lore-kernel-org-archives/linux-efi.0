From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 05/16] efi: Add EFI_SECURE_BOOT bit
Date: Thu, 17 Nov 2016 21:58:07 +0000
Message-ID: <CAKv+Gu_8r3oM-jvvuSiXTzxp0YMEVgc5KkScJ2UhGTaXm28L6w@mail.gmail.com>
References: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
 <147933287290.19316.3360403691390019935.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <147933287290.19316.3360403691390019935.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org, matthew.garrett@nebula.com, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, Josh Boyer <jwboyer@fedoraproject.org>
List-Id: linux-efi@vger.kernel.org

On 16 November 2016 at 21:47, David Howells <dhowells@redhat.com> wrote:
> From: Josh Boyer <jwboyer@fedoraproject.org>
>
> UEFI machines can be booted in Secure Boot mode.  Add a EFI_SECURE_BOOT bit
> for use with efi_enabled.
>
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
>  arch/x86/kernel/setup.c |    1 +
>  include/linux/efi.h     |    1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 9521acce8378..539f29587712 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -1164,6 +1164,7 @@ void __init setup_arch(char **cmdline_p)
>         if (boot_params.secure_boot &&
>             IS_ENABLED(CONFIG_EFI_SECURE_BOOT_LOCK_DOWN)) {
>                 lock_kernel_down();
> +               set_bit(EFI_SECURE_BOOT, &efi.flags);

Why is this x86 only? And why is this bit only set if
CONFIG_EFI_SECURE_BOOT_LOCK_DOWN is enabled?

>                 pr_info("Secure boot enabled\n");
>         }
>
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 11372fb8784c..5d7fb3e3400b 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1079,6 +1079,7 @@ extern int __init efi_setup_pcdp_console(char *);
>  #define EFI_ARCH_1             7       /* First arch-specific bit */
>  #define EFI_DBG                        8       /* Print additional debug info at runtime */
>  #define EFI_NX_PE_DATA         9       /* Can runtime data regions be mapped non-executable? */
> +#define EFI_SECURE_BOOT                10      /* Are we in Secure Boot mode? */
>
>  #ifdef CONFIG_EFI
>  /*
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
