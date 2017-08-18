From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/3] firmware: dcdbas: constify attribute_group structures.
Date: Fri, 18 Aug 2017 15:36:27 +0100
Message-ID: <CAKv+Gu_S3bF0pBzGnMyGHxNp+BPZSjvL2U=08w3JtFo-nLTOkA@mail.gmail.com>
References: <1501767444-27873-1-git-send-email-arvind.yadav.cs@gmail.com> <1501767444-27873-2-git-send-email-arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501767444-27873-2-git-send-email-arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Douglas_Warzecha-8PEkshWhKlo@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 3 August 2017 at 14:37, Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> attribute_group are not supposed to change at runtime. All functions
> working with attribute_group provided by <linux/sysfs.h> work with
> const attribute_group. So mark the non-const structs as const.
>
> Signed-off-by: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/firmware/dcdbas.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
> index 2fe1a13..c16600f 100644
> --- a/drivers/firmware/dcdbas.c
> +++ b/drivers/firmware/dcdbas.c
> @@ -534,7 +534,7 @@ static int dcdbas_reboot_notify(struct notifier_block *nb, unsigned long code,
>         NULL
>  };
>
> -static struct attribute_group dcdbas_attr_group = {
> +static const struct attribute_group dcdbas_attr_group = {
>         .attrs = dcdbas_dev_attrs,
>         .bin_attrs = dcdbas_bin_attrs,
>  };

If Douglas doesn't mind, I will take this trough the EFI tree
