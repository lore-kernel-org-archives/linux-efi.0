From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/7] efi/capsule: Remove pr_debug on ENOMEM or EFAULT
Date: Fri, 24 Mar 2017 18:15:12 +0000
Message-ID: <CAKv+Gu-6AEpHubmcx6GnYf+KcSFYs4s_ZaJmm-NBjW7TNGb-Og@mail.gmail.com>
References: <cover.1490376860.git.jan.kiszka@siemens.com> <aec270760c516cae2fd15e165e8cefa53be0f806.1490376860.git.jan.kiszka@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <aec270760c516cae2fd15e165e8cefa53be0f806.1490376860.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Hock Leong Kweh <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sascha Weisenberger <sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 24 March 2017 at 17:34, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org> wrote:
> Both cases are not worth a debug log message - the error code is telling
> enough.
>
> Signed-off-by: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

> ---
>  drivers/firmware/efi/capsule-loader.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
> index 91e91f7..7b57dda 100644
> --- a/drivers/firmware/efi/capsule-loader.c
> +++ b/drivers/firmware/efi/capsule-loader.c
> @@ -88,10 +88,8 @@ static ssize_t efi_capsule_setup_info(struct capsule_info *cap_info,
>         temp_page = krealloc(cap_info->pages,
>                              pages_needed * sizeof(void *),
>                              GFP_KERNEL | __GFP_ZERO);
> -       if (!temp_page) {
> -               pr_debug("%s: krealloc() failed\n", __func__);
> +       if (!temp_page)
>                 return -ENOMEM;
> -       }
>
>         cap_info->pages = temp_page;
>         cap_info->header_obtained = true;
> @@ -111,10 +109,8 @@ static ssize_t efi_capsule_submit_update(struct capsule_info *cap_info)
>
>         cap_hdr_temp = vmap(cap_info->pages, cap_info->index,
>                         VM_MAP, PAGE_KERNEL);
> -       if (!cap_hdr_temp) {
> -               pr_debug("%s: vmap() failed\n", __func__);
> +       if (!cap_hdr_temp)
>                 return -ENOMEM;
> -       }
>
>         ret = efi_capsule_update(cap_hdr_temp, cap_info->pages);
>         vunmap(cap_hdr_temp);
> @@ -171,7 +167,6 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
>         if (!cap_info->page_bytes_remain) {
>                 page = alloc_page(GFP_KERNEL);
>                 if (!page) {
> -                       pr_debug("%s: alloc_page() failed\n", __func__);
>                         ret = -ENOMEM;
>                         goto failed;
>                 }
> @@ -184,7 +179,6 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
>
>         kbuff = kmap(page);
>         if (!kbuff) {
> -               pr_debug("%s: kmap() failed\n", __func__);
>                 ret = -ENOMEM;
>                 goto failed;
>         }
> @@ -193,7 +187,6 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
>         /* Copy capsule binary data from user space to kernel space buffer */
>         write_byte = min_t(size_t, count, cap_info->page_bytes_remain);
>         if (copy_from_user(kbuff, buff, write_byte)) {
> -               pr_debug("%s: copy_from_user() failed\n", __func__);
>                 ret = -EFAULT;
>                 goto fail_unmap;
>         }
> --
> 2.10.2
>
