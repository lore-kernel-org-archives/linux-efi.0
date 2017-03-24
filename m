From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 4/7] efi/capsule: Adjust return type of efi_capsule_setup_info
Date: Fri, 24 Mar 2017 18:42:49 +0000
Message-ID: <CAKv+Gu9_4gd31tEWqmUR9N2pfbxpOW9eHNJSiEAzdRq05qFfWQ@mail.gmail.com>
References: <cover.1490376860.git.jan.kiszka@siemens.com> <dba2c6aba6aa905a63b91f5dd51b572ba5268a1f.1490376860.git.jan.kiszka@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <dba2c6aba6aa905a63b91f5dd51b572ba5268a1f.1490376860.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Hock Leong Kweh <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sascha Weisenberger <sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 24 March 2017 at 17:34, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org> wrote:
> We actually expect int at the caller and never return any size
> information.
>
> Signed-off-by: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

> ---
>  drivers/firmware/efi/capsule-loader.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
> index 3fb91e1..37d3f6e 100644
> --- a/drivers/firmware/efi/capsule-loader.c
> +++ b/drivers/firmware/efi/capsule-loader.c
> @@ -53,8 +53,8 @@ static void efi_free_all_buff_pages(struct capsule_info *cap_info)
>   * @kbuff: a mapped first page buffer pointer
>   * @hdr_bytes: the total received number of bytes for efi header
>   **/
> -static ssize_t efi_capsule_setup_info(struct capsule_info *cap_info,
> -                                     void *kbuff, size_t hdr_bytes)
> +static int efi_capsule_setup_info(struct capsule_info *cap_info,
> +                                 void *kbuff, size_t hdr_bytes)
>  {
>         efi_capsule_header_t *cap_hdr;
>         size_t pages_needed;
> --
> 2.10.2
>
