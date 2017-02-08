From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi/esrt: cleanup bad memory map log messages
Date: Wed, 8 Feb 2017 10:11:24 +0000
Message-ID: <CAKv+Gu-CkSrpHudOPn4d14A-PWXc-HiWMWy6R1RsFc-FYhwyNA@mail.gmail.com>
References: <20170207190823.10223-1-drake@endlessm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170207190823.10223-1-drake-6IF/jdPJHihWk0Htik3J/w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Drake <drake-6IF/jdPJHihWk0Htik3J/w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-6IF/jdPJHihWk0Htik3J/w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 7 February 2017 at 19:08, Daniel Drake <drake-6IF/jdPJHihWk0Htik3J/w@public.gmane.org> wrote:
> The Intel Compute Stick STCK1A8LFC and Weibu F3C platforms both
> log 2 error messages during boot:
>
>    efi: requested map not found.
>    esrt: ESRT header is not in the memory map.
>
> Searching the web, this seems to affect many other platforms too.
> Since these messages are logged as errors, they appear on-screen during
> the boot process even when using the "quiet" boot parameter used by
> distros.
>
> Demote the ESRT error to a warning so that it does not appear on-screen,
> and delete the error logging from efi_mem_desc_lookup; both callsites
> of that function log more specific messages upon failure.
>
> Out of curiosity I looked closer at the Weibu F3C. There is no entry in
> the UEFI-provided memory map which corresponds to the ESRT pointer, but
> hacking the code to map it anyway, the ESRT does appear to be valid with
> 2 entries.
>
> Signed-off-by: Daniel Drake <drake-6IF/jdPJHihWk0Htik3J/w@public.gmane.org>

Acked-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

> ---
>  drivers/firmware/efi/efi.c  | 1 -
>  drivers/firmware/efi/esrt.c | 2 +-
>  2 files changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 9291480..8c3ebcb 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -389,7 +389,6 @@ int __init efi_mem_desc_lookup(u64 phys_addr, efi_memory_desc_t *out_md)
>                         return 0;
>                 }
>         }
> -       pr_err_once("requested map not found.\n");
>         return -ENOENT;
>  }
>
> diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
> index 1491407..d81560f 100644
> --- a/drivers/firmware/efi/esrt.c
> +++ b/drivers/firmware/efi/esrt.c
> @@ -254,7 +254,7 @@ void __init efi_esrt_init(void)
>
>         rc = efi_mem_desc_lookup(efi.esrt, &md);
>         if (rc < 0) {
> -               pr_err("ESRT header is not in the memory map.\n");
> +               pr_warn("ESRT header is not in the memory map.\n");
>                 return;
>         }
>
> --
> 2.9.3
>
