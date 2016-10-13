From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [patch] efi: fix an error code
Date: Thu, 13 Oct 2016 11:59:11 +0100
Message-ID: <CAKv+Gu9Bi36rAn1wFjitiQ4yrxDOvH3JmapBX63VFMUvmXEe5g@mail.gmail.com>
References: <20161013085137.GD16198@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20161013085137.GD16198@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Matt Fleming <matt@codeblueprint.co.uk>
Cc: Octavian Purdila <octavian.purdila@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 13 October 2016 at 09:51, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> We should return -ENOMEM here, instead of success.
>
> Fixes: 475fb4e8b2f4 ('efi / ACPI: load SSTDs from EFI variables')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 1ac199c..a4944e2 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -259,8 +259,10 @@ static __init int efivar_ssdt_load(void)
>                 }
>
>                 data = kmalloc(size, GFP_KERNEL);
> -               if (!data)
> +               if (!data) {
> +                       ret = -ENOMEM;
>                         goto free_entry;
> +               }
>
>                 ret = efivar_entry_get(entry, NULL, &size, data);
>                 if (ret) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Applied, thanks.
