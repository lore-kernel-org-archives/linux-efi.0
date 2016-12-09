From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi/esrt: fix spelling mistake "doen't"
Date: Fri, 9 Dec 2016 16:03:26 +0000
Message-ID: <CAKv+Gu93PXbXu2hzSOLCPuztkGoBKs3QjiE7ETi80QxRrHnM5Q@mail.gmail.com>
References: <20161209151139.6118-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161209151139.6118-1-colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 9 December 2016 at 15:11, Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>
> Trivial fix to spelling mistake "doen't" to "doesn't" in pr_err message
>
> Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Applied, thanks.

> ---
>  drivers/firmware/efi/esrt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
> index 1491407..08b0268 100644
> --- a/drivers/firmware/efi/esrt.c
> +++ b/drivers/firmware/efi/esrt.c
> @@ -269,7 +269,7 @@ void __init efi_esrt_init(void)
>         max -= efi.esrt;
>
>         if (max < size) {
> -               pr_err("ESRT header doen't fit on single memory map entry. (size: %zu max: %zu)\n",
> +               pr_err("ESRT header doesn't fit on single memory map entry. (size: %zu max: %zu)\n",
>                        size, max);
>                 return;
>         }
> --
> 2.10.2
>
