From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 5/9] efi: Add SHIM and image security database GUID definitions
Date: Mon, 21 Nov 2016 16:07:04 +0000
Message-ID: <CAKv+Gu_d+ZO3V9cE-Q2qCNqiGsaOo6_naatxkQzybFQdF2H9vQ@mail.gmail.com>
References: <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
 <147931988070.16460.13959373928802133298.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <147931988070.16460.13959373928802133298.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Josh Boyer <jwboyer@fedoraproject.org>
List-Id: linux-efi@vger.kernel.org

On 16 November 2016 at 18:11, David Howells <dhowells@redhat.com> wrote:
> Add the definitions for shim and image security database, both of which
> are used widely in various Linux distros.
>
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> Signed-off-by: David Howells <dhowells@redhat.com>

This patch

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

but I do have a concern that I will explain in reply to the patch that
uses these definitions.

> ---
>
>  include/linux/efi.h |    3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 2d089487d2da..acfdea8381de 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -592,6 +592,9 @@ void efi_native_runtime_setup(void);
>  #define EFI_MEMORY_ATTRIBUTES_TABLE_GUID       EFI_GUID(0xdcfa911d, 0x26eb, 0x469f,  0xa2, 0x20, 0x38, 0xb7, 0xdc, 0x46, 0x12, 0x20)
>  #define EFI_CONSOLE_OUT_DEVICE_GUID            EFI_GUID(0xd3b36f2c, 0xd551, 0x11d4,  0x9a, 0x46, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
>
> +#define EFI_IMAGE_SECURITY_DATABASE_GUID       EFI_GUID(0xd719b2cb, 0x3d3a, 0x4596, 0xa3, 0xbc, 0xda, 0xd0, 0x0e, 0x67, 0x65, 0x6f)
> +#define EFI_SHIM_LOCK_GUID                     EFI_GUID(0x605dab50, 0xe046, 0x4300, 0xab, 0xb6, 0x3d, 0xd8, 0x10, 0xdd, 0x8b, 0x23)
> +
>  /*
>   * This GUID is used to pass to the kernel proper the struct screen_info
>   * structure that was populated by the stub based on the GOP protocol instance
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
