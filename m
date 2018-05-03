From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2] efi/capsule-loader: Don't output reset log when reset
 flags are not set
Date: Thu, 3 May 2018 13:58:25 +0200
Message-ID: <CAKv+Gu8d0HiW2JpkBrbLVRrLAUjs6_2WJfFTiNSiUuT5-mUhRw@mail.gmail.com>
References: <1525326309-14627-1-git-send-email-shunyong.yang@hxt-semitech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525326309-14627-1-git-send-email-shunyong.yang@hxt-semitech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shunyong Yang <shunyong.yang@hxt-semitech.com>
Cc: linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Joey Zheng <yu.zheng@hxt-semitech.com>
List-Id: linux-efi@vger.kernel.org

On 3 May 2018 at 07:45, Shunyong Yang <shunyong.yang@hxt-semitech.com> wrote:
> It means firmware attempts to immediately process or launch the capsule
> when reset flags in capsule header are not set. Moreover, reset is not
> needed in this case. The current code will output log to indicate reset.
>
> This patch adds a branch to avoid reset log output when the flags are not
> set.
>
> Cc: Joey Zheng <yu.zheng@hxt-semitech.com>
> Signed-off-by: Shunyong Yang <shunyong.yang@hxt-semitech.com>

Queued in efi/next

Thanks.

> ---
>
> Changes in v2:
>   *Add EFI_CAPSULE_PERSIST_ACROSS_RESET check according to Ard's
>    suggestion.
>
> ---
>  drivers/firmware/efi/capsule-loader.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
> index e456f4602df1..344785ef8539 100644
> --- a/drivers/firmware/efi/capsule-loader.c
> +++ b/drivers/firmware/efi/capsule-loader.c
> @@ -134,10 +134,15 @@ static ssize_t efi_capsule_submit_update(struct capsule_info *cap_info)
>
>         /* Indicate capsule binary uploading is done */
>         cap_info->index = NO_FURTHER_WRITE_ACTION;
> -       pr_info("Successfully upload capsule file with reboot type '%s'\n",
> -               !cap_info->reset_type ? "RESET_COLD" :
> -               cap_info->reset_type == 1 ? "RESET_WARM" :
> -               "RESET_SHUTDOWN");
> +
> +       if (cap_info->header.flags & EFI_CAPSULE_PERSIST_ACROSS_RESET)
> +               pr_info("Successfully upload capsule file with reboot type '%s'\n",
> +                       !cap_info->reset_type ? "RESET_COLD" :
> +                       cap_info->reset_type == 1 ? "RESET_WARM" :
> +                       "RESET_SHUTDOWN");
> +       else
> +               pr_info("Successfully upload, process and launch capsule file\n");
> +
>         return 0;
>  }
>
> --
> 1.8.3.1
>
