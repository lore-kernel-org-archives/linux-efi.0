From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi: arm64: treat regions with WT/WC set but WB cleared
 as memory
Date: Wed, 24 Aug 2016 17:25:35 +0200
Message-ID: <CAKv+Gu_+oAZ9-a12h=HhE=MreK3KEg_2aO2vQTzHjPSndm2ONA@mail.gmail.com>
References: <1472052256-26365-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472052256-26365-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Takahiro Akashi <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 24 August 2016 at 17:24, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> Currently, memory regions are only recorded in the memblock memory table
> if they have the EFI_MEMORY_WB memory type attribute set. In case the
> region is of a reserved type, it is also marked as MEMBLOCK_NOMAP, which
> will leave it out of the linear mapping.
>
> However, memory regions may legally have the EFI_MEMORY_WT or EFI_MEMORY_WC
> attributes set, and the EFI_MEMORY_WB cleared, in which case the region in
> question is obviously backed by normal memory, but is not recorded in the
> memblock memory table at all. Since it would be useful to be able to
> identify any UEFI reported memory region using memblock_is_memory(), it
> makes sense to add all memory to the memblock memory table, and simply mark
> it as MEMBLOCK_NOMAP if it lacks the EFI_MEMORY_WB attribute.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>
> Note that this will also result in regions with EFI_MEMORY_WB cleared to
> be listed in /proc/iomem as 'System RAM', which may be incorrect. However,
> we already display this incorrect behavior for runtime services code/data
> regions, so this should be fixed in a separate patch, of which an example
> has been proposed here:
> https://www.spinics.net/lists/arm-kernel/msg525369.html
>
>  drivers/firmware/efi/arm-init.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
> index c49d50e68aee..678672d332f8 100644
> --- a/drivers/firmware/efi/arm-init.c
> +++ b/drivers/firmware/efi/arm-init.c
> @@ -28,7 +28,7 @@ u64 efi_system_table;
>
>  static int __init is_normal_ram(efi_memory_desc_t *md)
>  {
> -       if (md->attribute & EFI_MEMORY_WB)
> +       if (md->attribute & (EFI_MEMORY_WB|EFI_MEMORY_WT|EFI_MEMORY_WC))
>                 return 1;
>         return 0;
>  }
> @@ -163,7 +163,13 @@ static __init int is_reserve_region(efi_memory_desc_t *md)
>         case EFI_BOOT_SERVICES_DATA:
>         case EFI_CONVENTIONAL_MEMORY:
>         case EFI_PERSISTENT_MEMORY:
> -               return 0;
> +               /*
> +                * According to the spec, these regions are no longer reserved
> +                * after calling ExitBootServices(). However, we can only use
> +                * them as System RAM if they can be mapped writeback cacheable.
> +                * Otherwise, treat them as reserved.
> +                */
> +               return (md->type & EFI_MEMORY_WB) == 0;

Oops, failed to commit --amend the above line: this should be
md->attribute not md->type
