From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: efi/esrt: use memunmap rather kfree to free the remapping
Date: Tue, 5 Dec 2017 18:08:27 +0000
Message-ID: <CAKv+Gu_eSBvMh+hbU0iFwOuwKZw4AMnfss7pTu-Ya-QE5Xzn1Q@mail.gmail.com>
References: <1509288662-7880-1-git-send-email-bianpan2016@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509288662-7880-1-git-send-email-bianpan2016-9Onoh4P/yGk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 29 October 2017 at 14:51, Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org> wrote:
> The remapping result of memremap should be freed with memunmap, not
> kfree.
>
> Signed-off-by: Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>
> ---
>  drivers/firmware/efi/esrt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
> index bd7ed3c..3ef7001 100644
> --- a/drivers/firmware/efi/esrt.c
> +++ b/drivers/firmware/efi/esrt.c
> @@ -431,7 +431,7 @@ static int __init esrt_sysfs_init(void)
>  err_remove_esrt:
>         kobject_put(esrt_kobj);
>  err:
> -       kfree(esrt);
> +       memunmap(esrt);
>         esrt = NULL;
>         return error;
>  }
> --
> 1.9.1
>

Queued in efi/urgent. Thanks.
