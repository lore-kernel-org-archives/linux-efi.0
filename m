From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 1/7] efi/capsule: Fix return code on failing kmap/vmap
Date: Fri, 24 Mar 2017 18:14:31 +0000
Message-ID: <CAKv+Gu_ebG0Pji4QHdNPOZQoLGb0BaS4e+R6mcjJihuJ=JRxaw@mail.gmail.com>
References: <cover.1490376860.git.jan.kiszka@siemens.com> <d031a1bf1416b40143ae84a9e0f5f9df26c8fc2a.1490376860.git.jan.kiszka@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d031a1bf1416b40143ae84a9e0f5f9df26c8fc2a.1490376860.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Shevchenko <andy.shevchenko@gmail.com>, Bryan O'Donoghue <pure.logic@nexus-software.ie>, Hock Leong Kweh <hock.leong.kweh@intel.com>, Borislav Petkov <bp@alien8.de>, Sascha Weisenberger <sascha.weisenberger@siemens.com>
List-Id: linux-efi@vger.kernel.org

On 24 March 2017 at 17:34, Jan Kiszka <jan.kiszka@siemens.com> wrote:
> If kmap or vmap fail, it means we ran out of memory. There are no
> user-provided addressed involved that would justify EFAULT.
>
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  drivers/firmware/efi/capsule-loader.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
> index 9ae6c11..91e91f7 100644
> --- a/drivers/firmware/efi/capsule-loader.c
> +++ b/drivers/firmware/efi/capsule-loader.c
> @@ -113,7 +113,7 @@ static ssize_t efi_capsule_submit_update(struct capsule_info *cap_info)
>                         VM_MAP, PAGE_KERNEL);
>         if (!cap_hdr_temp) {
>                 pr_debug("%s: vmap() failed\n", __func__);
> -               return -EFAULT;
> +               return -ENOMEM;
>         }
>
>         ret = efi_capsule_update(cap_hdr_temp, cap_info->pages);
> @@ -185,7 +185,7 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
>         kbuff = kmap(page);
>         if (!kbuff) {
>                 pr_debug("%s: kmap() failed\n", __func__);
> -               ret = -EFAULT;
> +               ret = -ENOMEM;
>                 goto failed;
>         }
>         kbuff += PAGE_SIZE - cap_info->page_bytes_remain;
> --
> 2.10.2
>
