From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/3] efi/efi_test: fix the uninitialized value datasize
Date: Mon, 3 Oct 2016 21:23:56 +0100
Message-ID: <20161003202356.GM16071@codeblueprint.co.uk>
References: <1474859691-8574-1-git-send-email-ivan.hu@canonical.com>
 <1474859691-8574-3-git-send-email-ivan.hu@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1474859691-8574-3-git-send-email-ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 26 Sep, at 11:14:50AM, Ivan Hu wrote:
> Fix the minor issue found by CoverityScan
> CID 1358931 (#1 of 1): Uninitialized scalar variable (UNINIT)9.
> uninit_use: Using uninitialized value datasize.
> 199        prev_datasize = datasize;
> 200        status = efi.get_variable(name, vd, at, dz, data);
> 
> Signed-off-by: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
>  drivers/firmware/efi/test/efi_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/test/efi_test.c b/drivers/firmware/efi/test/efi_test.c
> index 5602c46..87394f0 100644
> --- a/drivers/firmware/efi/test/efi_test.c
> +++ b/drivers/firmware/efi/test/efi_test.c
> @@ -156,7 +156,7 @@ static long efi_runtime_get_variable(unsigned long arg)
>  {
>  	struct efi_getvariable __user *getvariable_user;
>  	struct efi_getvariable getvariable;
> -	unsigned long datasize, prev_datasize, *dz;
> +	unsigned long datasize = 0, prev_datasize, *dz;
>  	efi_guid_t vendor_guid, *vd = NULL;
>  	efi_status_t status;
>  	efi_char16_t *name = NULL;

Thanks, applied to 'next'.
