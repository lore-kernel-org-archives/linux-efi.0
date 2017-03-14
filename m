From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] pstore: return error code (if any) from efi_pstore_write
Date: Tue, 14 Mar 2017 08:24:15 +0000
Message-ID: <CAKv+Gu92Lq62aJF4Ki2DU577xs09JWPLaOfRENRo=+VSyEBhVQ@mail.gmail.com>
References: <1489416765.32205.14.camel@evgeny-pc.tm.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489416765.32205.14.camel-HiM4UUiQNY10sU3rIFUpn1DQ4js95KgL@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kalugin, Evgeny" <evgeny.kalugin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org" <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org" <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 13 March 2017 at 12:46, Kalugin, Evgeny <evgeny.kalugin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> From 655a261d71af9de62e0e23ae0eb6f75037ae5e3e Mon Sep 17 00:00:00 2001
> From: Evgeny Kalugin <evgeny.kalugin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Date: Tue, 7 Mar 2017 14:22:25 +0000
> Subject: [PATCH] pstore: return error code (if any) from efi_pstore_write
>
> For some reason return value from actual variable setting was ignored.
> With this change error code get transferred upwards through call stack.
>
> Signed-off-by: Evgeny Kalugin <evgeny.kalugin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks for the patch.

Could you give a bit more detail on how this broke things for you?

> ---
>  drivers/firmware/efi/efi-pstore.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
> index f402ba2..2ea808e 100644
> --- a/drivers/firmware/efi/efi-pstore.c
> +++ b/drivers/firmware/efi/efi-pstore.c
> @@ -274,7 +274,7 @@ static int efi_pstore_write(enum pstore_type_id type,
>         for (i = 0; i < DUMP_NAME_LEN; i++)
>                 efi_name[i] = name[i];
>
> -       efivar_entry_set_safe(efi_name, vendor, PSTORE_EFI_ATTRIBUTES,
> +       ret = efivar_entry_set_safe(efi_name, vendor, PSTORE_EFI_ATTRIBUTES,
>                               !pstore_cannot_block_path(reason),
>                               size, psi->buf);
>
> --
> 1.9.1
>
> ---------------------------------------------------------------------
> Intel Finland Oy
> Registered Address: PL 281, 00181 Helsinki
> Business Identity Code: 0357606 - 4
> Domiciled in Helsinki
>
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.
