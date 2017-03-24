From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/7] efi/capsule: Clean up pr_err/info messages
Date: Fri, 24 Mar 2017 18:17:00 +0000
Message-ID: <CAKv+Gu9cbZF4rrKYVc8NVHDN0ZzwWVqQqxfSoTv_V49+Y5Z60A@mail.gmail.com>
References: <cover.1490376860.git.jan.kiszka@siemens.com> <234958c0126c99ef7a2c908033374838ec34885f.1490376860.git.jan.kiszka@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <234958c0126c99ef7a2c908033374838ec34885f.1490376860.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Hock Leong Kweh <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sascha Weisenberger <sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 24 March 2017 at 17:34, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org> wrote:
> Avoid __func__, improve the information provided by some of the
> messages.
>
> Signed-off-by: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

> ---
>  drivers/firmware/efi/capsule-loader.c | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
> index 7b57dda..3fb91e1 100644
> --- a/drivers/firmware/efi/capsule-loader.c
> +++ b/drivers/firmware/efi/capsule-loader.c
> @@ -70,7 +70,7 @@ static ssize_t efi_capsule_setup_info(struct capsule_info *cap_info,
>         pages_needed = ALIGN(cap_hdr->imagesize, PAGE_SIZE) >> PAGE_SHIFT;
>
>         if (pages_needed == 0) {
> -               pr_err("%s: pages count invalid\n", __func__);
> +               pr_err("invalid capsule size");
>                 return -EINVAL;
>         }
>
> @@ -79,8 +79,7 @@ static ssize_t efi_capsule_setup_info(struct capsule_info *cap_info,
>                                     cap_hdr->imagesize,
>                                     &cap_info->reset_type);
>         if (ret) {
> -               pr_err("%s: efi_capsule_supported() failed\n",
> -                      __func__);
> +               pr_err("capsule not supported\n");
>                 return ret;
>         }
>
> @@ -115,14 +114,14 @@ static ssize_t efi_capsule_submit_update(struct capsule_info *cap_info)
>         ret = efi_capsule_update(cap_hdr_temp, cap_info->pages);
>         vunmap(cap_hdr_temp);
>         if (ret) {
> -               pr_err("%s: efi_capsule_update() failed\n", __func__);
> +               pr_err("capsule update failed\n");
>                 return ret;
>         }
>
>         /* Indicate capsule binary uploading is done */
>         cap_info->index = NO_FURTHER_WRITE_ACTION;
> -       pr_info("%s: Successfully upload capsule file with reboot type '%s'\n",
> -               __func__, !cap_info->reset_type ? "RESET_COLD" :
> +       pr_info("Successfully upload capsule file with reboot type '%s'\n",
> +               !cap_info->reset_type ? "RESET_COLD" :
>                 cap_info->reset_type == 1 ? "RESET_WARM" :
>                 "RESET_SHUTDOWN");
>         return 0;
> @@ -207,8 +206,7 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
>         if (cap_info->header_obtained &&
>             cap_info->count >= cap_info->total_size) {
>                 if (cap_info->count > cap_info->total_size) {
> -                       pr_err("%s: upload size exceeded header defined size\n",
> -                              __func__);
> +                       pr_err("capsule upload size exceeded header defined size\n");
>                         ret = -EINVAL;
>                         goto failed;
>                 }
> @@ -242,7 +240,7 @@ static int efi_capsule_flush(struct file *file, fl_owner_t id)
>         struct capsule_info *cap_info = file->private_data;
>
>         if (cap_info->index > 0) {
> -               pr_err("%s: capsule upload not complete\n", __func__);
> +               pr_err("capsule upload not complete\n");
>                 efi_free_all_buff_pages(cap_info);
>                 ret = -ECANCELED;
>         }
> @@ -321,8 +319,7 @@ static int __init efi_capsule_loader_init(void)
>
>         ret = misc_register(&efi_capsule_misc);
>         if (ret)
> -               pr_err("%s: Failed to register misc char file note\n",
> -                      __func__);
> +               pr_err("Unable to register capsule loader device\n");
>
>         return ret;
>  }
> --
> 2.10.2
>
