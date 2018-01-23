From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] x86/efi: Fix trailing semicolons
Date: Tue, 23 Jan 2018 18:49:41 +0000
Message-ID: <CAKv+Gu-63xkBbeGY-DfiuNJdYTrAZodzqgHhW9TK=vi=Pa7Cmg@mail.gmail.com>
References: <20180123132034.21744-1-luisbg@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180123132034.21744-1-luisbg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Luis de Bethencourt <luisbg@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 23 January 2018 at 13:20, Luis de Bethencourt <luisbg@kernel.org> wrote:
> The trailing semicolon is an empty statement that does no operation.
> Removing them since they don't do anything.
>
> Signed-off-by: Luis de Bethencourt <luisbg@kernel.org>
> ---
>
> Hi,
>
> After fixing the same thing in drivers/staging/rtl8723bs/, Joe Perches
> suggested I fix it treewide [0].
>
> Best regards
> Luis
>

Applied, thanks.


>
> [0] http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2018-January/115410.html
> [1] http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2018-January/115390.html
>
>  arch/x86/boot/compressed/eboot.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index 353e20c3f114..886a9115af62 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -439,7 +439,7 @@ setup_uga32(void **uga_handle, unsigned long size, u32 *width, u32 *height)
>         struct efi_uga_draw_protocol *uga = NULL, *first_uga;
>         efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
>         unsigned long nr_ugas;
> -       u32 *handles = (u32 *)uga_handle;;
> +       u32 *handles = (u32 *)uga_handle;
>         efi_status_t status = EFI_INVALID_PARAMETER;
>         int i;
>
> @@ -484,7 +484,7 @@ setup_uga64(void **uga_handle, unsigned long size, u32 *width, u32 *height)
>         struct efi_uga_draw_protocol *uga = NULL, *first_uga;
>         efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
>         unsigned long nr_ugas;
> -       u64 *handles = (u64 *)uga_handle;;
> +       u64 *handles = (u64 *)uga_handle;
>         efi_status_t status = EFI_INVALID_PARAMETER;
>         int i;
>
> --
> 2.15.1
>
