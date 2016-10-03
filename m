From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH -next] efi: Remove unused including <linux/version.h>
Date: Mon, 3 Oct 2016 20:41:45 +0100
Message-ID: <20161003194145.GJ16071@codeblueprint.co.uk>
References: <1473990620-18809-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473990620-18809-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 16 Sep, at 01:50:20AM, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Remove including <linux/version.h> that don't need it.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/firmware/efi/test/efi_test.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/test/efi_test.c b/drivers/firmware/efi/test/efi_test.c
> index f61bb52..ae51268 100644
> --- a/drivers/firmware/efi/test/efi_test.c
> +++ b/drivers/firmware/efi/test/efi_test.c
> @@ -8,7 +8,6 @@
>   *
>   */
>  
> -#include <linux/version.h>
>  #include <linux/miscdevice.h>
>  #include <linux/module.h>
>  #include <linux/init.h>

Thanks, applied to 'next'.
