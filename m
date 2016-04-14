From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] efi/arm*: use memremap() to create the persistent
 memmap mapping
Date: Thu, 14 Apr 2016 10:43:45 +0200
Message-ID: <CAKv+Gu9GNssCtBY85zMSpGh8bcwXD-3t3LCxmwmK7dO5qN0dzQ@mail.gmail.com>
References: <1460561873-27756-1-git-send-email-ard.biesheuvel@linaro.org>
	<1460561873-27756-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460561873-27756-2-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 13 April 2016 at 17:37, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> Instead of using ioremap_cache(), which is slightly inappropriate for
> mapping firmware tables, and is not even allowed on ARM for mapping
> regions that are covered by a struct page, use memremap(), which was
> invented for this purpose, and will also reuse the existing kernel
> direct mapping if the requested region is covered by it.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/arm-runtime.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
> index 98fe93a9813b..17ccf0a8787a 100644
> --- a/drivers/firmware/efi/arm-runtime.c
> +++ b/drivers/firmware/efi/arm-runtime.c
> @@ -111,8 +111,7 @@ static int __init arm_enable_runtime_services(void)
>
>         mapsize = efi.memmap.map_end - efi.memmap.map;
>
> -       efi.memmap.map = (__force void *)ioremap_cache(efi.memmap.phys_map,
> -                                                      mapsize);
> +       efi.memmap.map = memremap(efi.memmap.phys_map, mapsize, MEMREMAP_WB);
>         if (!efi.memmap.map) {
>                 pr_err("Failed to remap EFI memory map\n");
>                 return -ENOMEM;

Actually, this patch does not depend on the ARM memremap changes being
merged: before those changes, memremap() unconditionally falls back to
ioremap_cache() for 'System RAM' so this patch is essentially a nop in
that case. This is guaranteed to work due to the fact that we [still]
use MEMBLOCK_NOMAP for mapping the memory map on ARM.

The memory attributes table and GOP changes do depend on it, however,
since the configuration tables it accesses are likely to be covered by
a struct page, in which case ARM disallows the ioremap_cache() (and
thus the use of memremap() until it is updated to deal with this
situation explicitly)

The other change that depends on it is dropping the MEMBLOCK_NOMAP for
ARM as well (as we did in the arm64 patch that is currently queued up
for v4.6-rc)
