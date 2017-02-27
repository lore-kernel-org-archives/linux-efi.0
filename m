From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] efi/esrt: Not having an ERST descriptor is not an error
Date: Mon, 27 Feb 2017 09:56:06 +0000
Message-ID: <CAKv+Gu-NH5cqLjfNGbN18ck8fdCLePeyL9Gb3jbrEVHNkWV8+g@mail.gmail.com>
References: <20170227095210.3619-1-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170227095210.3619-1-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 27 February 2017 at 09:52, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Stop printing an error on all machines without ERST descriptors.
>
> Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

We have similar changes already queued for v4.12 in our next branch,
with the only difference being that you are using pr_info() rather
than pr_warn() (and according to the contributor of the patch, that is
sufficient to prevent the warning from appearing on top of the
graphical splash on his distro)

Thanks,
Ard.


> ---
>  drivers/firmware/efi/esrt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
> index 1491407..0d902bb 100644
> --- a/drivers/firmware/efi/esrt.c
> +++ b/drivers/firmware/efi/esrt.c
> @@ -254,7 +254,7 @@ void __init efi_esrt_init(void)
>
>         rc = efi_mem_desc_lookup(efi.esrt, &md);
>         if (rc < 0) {
> -               pr_err("ESRT header is not in the memory map.\n");
> +               pr_info("ESRT header is not in the memory map.\n");
>                 return;
>         }
>
> --
> 2.9.3
>
