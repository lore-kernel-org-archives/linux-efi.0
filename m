From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 01/24] efi: Add EFI_SECURE_BOOT bit
Date: Thu, 6 Apr 2017 09:26:55 +0100
Message-ID: <CAKv+Gu-3fegAE+oZ+YLXfSf1dwyxO9eYrgJbXOHn9A7eC3gzsw@mail.gmail.com>
References: <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
 <149142327748.5101.9712540392655343615.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <149142327748.5101.9712540392655343615.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matthew Garrett <matthew.garrett@nebula.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, linux-security-module <linux-security-module@vger.kernel.org>, keyrings@vger.kernel.org, Josh Boyer <jwboyer@fedoraproject.org>
List-Id: linux-efi@vger.kernel.org

On 5 April 2017 at 21:14, David Howells <dhowells@redhat.com> wrote:
> From: Josh Boyer <jwboyer@fedoraproject.org>
>
> UEFI machines can be booted in Secure Boot mode.  Add a EFI_SECURE_BOOT bit
> that can be passed to efi_enabled() to find out whether secure boot is
> enabled.
>
> This will be used by the SysRq+x handler, registered by the x86 arch, to find
> out whether secure boot mode is enabled so that it can be disabled.
>
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: linux-efi@vger.kernel.org
> ---
>
>  arch/x86/kernel/setup.c |    1 +
>  include/linux/efi.h     |    1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 4bf0c8926a1c..396285bddb93 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -1184,6 +1184,7 @@ void __init setup_arch(char **cmdline_p)
>                         pr_info("Secure boot disabled\n");
>                         break;
>                 case efi_secureboot_mode_enabled:
> +                       set_bit(EFI_SECURE_BOOT, &efi.flags);
>                         pr_info("Secure boot enabled\n");
>                         break;
>                 default:

Like I asked when this patch was sent round the last time: is there
any reason for this not to live in generic code?


> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 94d34e0be24f..6049600e5475 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1069,6 +1069,7 @@ extern int __init efi_setup_pcdp_console(char *);
>  #define EFI_DBG                        8       /* Print additional debug info at runtime */
>  #define EFI_NX_PE_DATA         9       /* Can runtime data regions be mapped non-executable? */
>  #define EFI_MEM_ATTR           10      /* Did firmware publish an EFI_MEMORY_ATTRIBUTES table? */
> +#define EFI_SECURE_BOOT                11      /* Are we in Secure Boot mode? */
>
>  #ifdef CONFIG_EFI
>  /*
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
