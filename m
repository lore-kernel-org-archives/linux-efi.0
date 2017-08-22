From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH][next] efi/reboot: make function pointer orig_pm_power_off static
Date: Tue, 22 Aug 2017 17:32:40 +0100
Message-ID: <CAKv+Gu98+6mJhn9KxHvtQ5LQdgmtc2Yd4LBJjK=ds91AGX4o9Q@mail.gmail.com>
References: <20170822155040.32058-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170822155040.32058-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, kernel-janitors@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 22 August 2017 at 16:50, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> The function pointer orig_pm_power_off is local to the source and does
> not need to be in global scope, so make it static.
>
> Cleans up sparse warning:
> symbol 'orig_pm_power_off' was not declared. Should it be static?
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Queued, thanks.

> ---
>  drivers/firmware/efi/reboot.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/reboot.c b/drivers/firmware/efi/reboot.c
> index 7117e2d0c7f9..22874544d301 100644
> --- a/drivers/firmware/efi/reboot.c
> +++ b/drivers/firmware/efi/reboot.c
> @@ -5,7 +5,7 @@
>  #include <linux/efi.h>
>  #include <linux/reboot.h>
>
> -void (*orig_pm_power_off)(void);
> +static void (*orig_pm_power_off)(void);
>
>  int efi_reboot_quirk_mode = -1;
>
> --
> 2.14.1
>
