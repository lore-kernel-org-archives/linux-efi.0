From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [Linaro-uefi] [PATCH] firmware: efi: remove unneeded guid unparse
Date: Tue, 20 Jan 2015 16:20:10 +0000
Message-ID: <CAKv+Gu87L6xhEbTiWSdcY6RCk3yc3nhf2bN7rMOji3znx=7uuQ@mail.gmail.com>
References: <1421770352-5059-1-git-send-email-ivan.khoronzhuk@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421770352-5059-1-git-send-email-ivan.khoronzhuk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ivan Khoronzhuk <ivan.khoronzhuk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linaro Kernel Mailman List <linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org>, Linaro UEFI Mailman List <linaro-uefi-cunTk1MwBs8s++Sfvej+rw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 20 January 2015 at 16:12, Ivan Khoronzhuk <ivan.khoronzhuk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> There is no reason to translate guid number to string here.
> So remove it in order to not do unneeded work.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/efi.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 9035c1b..f6be017 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -272,15 +272,10 @@ static __init int match_config_table(efi_guid_t *guid,
>                                      unsigned long table,
>                                      efi_config_table_type_t *table_types)
>  {
> -       u8 str[EFI_VARIABLE_GUID_LEN + 1];
>         int i;
>
>         if (table_types) {
> -               efi_guid_unparse(guid, str);
> -
>                 for (i = 0; efi_guidcmp(table_types[i].guid, NULL_GUID); i++) {
> -                       efi_guid_unparse(&table_types[i].guid, str);
> -
>                         if (!efi_guidcmp(*guid, table_types[i].guid)) {
>                                 *(table_types[i].ptr) = table;
>                                 pr_cont(" %s=0x%lx ",

Acked-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
