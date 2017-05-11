From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi: remove duplicate 'const' specifiers
Date: Thu, 11 May 2017 14:41:23 +0100
Message-ID: <CAKv+Gu8H92q7N3w8gVvZ8iXivOxP8EH7zQB9KkmaTeq5+S608Q@mail.gmail.com>
References: <20170511114337.2803599-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170511114337.2803599-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ingo Molnar <mingo@kernel.org>, David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@fedoraproject.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 11 May 2017 at 12:43, Arnd Bergmann <arnd@arndb.de> wrote:
> gcc-7 shows a harmless warning:
>
> drivers/firmware/efi/libstub/secureboot.c:19:27: error: duplicate 'const' declaration specifier [-Werror=duplicate-decl-specifier]
>  static const efi_char16_t const efi_SecureBoot_name[] = {
> drivers/firmware/efi/libstub/secureboot.c:22:27: error: duplicate 'const' declaration specifier [-Werror=duplicate-decl-specifier]
>
> Removing one of the specifiers gives us the expected behavior.
>
> Fixes: de8cb458625c ("efi: Get and store the secure boot status")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  drivers/firmware/efi/libstub/secureboot.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
> index 8c34d50a4d80..959777ec8a77 100644
> --- a/drivers/firmware/efi/libstub/secureboot.c
> +++ b/drivers/firmware/efi/libstub/secureboot.c
> @@ -16,10 +16,10 @@
>
>  /* BIOS variables */
>  static const efi_guid_t efi_variable_guid = EFI_GLOBAL_VARIABLE_GUID;
> -static const efi_char16_t const efi_SecureBoot_name[] = {
> +static const efi_char16_t efi_SecureBoot_name[] = {
>         'S', 'e', 'c', 'u', 'r', 'e', 'B', 'o', 'o', 't', 0
>  };
> -static const efi_char16_t const efi_SetupMode_name[] = {
> +static const efi_char16_t efi_SetupMode_name[] = {
>         'S', 'e', 't', 'u', 'p', 'M', 'o', 'd', 'e', 0
>  };
>
> --
> 2.9.0
>
