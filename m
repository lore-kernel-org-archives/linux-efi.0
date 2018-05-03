From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi: Fix the size not consistent issue when unmapping
 memory map
Date: Thu, 3 May 2018 14:05:51 +0200
Message-ID: <CAKv+Gu_1vNmNy6vYEdSRW6r97DSxj_t=1LmWFE-nsv7oA=1ApQ@mail.gmail.com>
References: <20180502061724.25833-1-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180502061724.25833-1-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Lee, Chun-Yi" <jlee@suse.com>, Takashi Iwai <tiwai@suse.de>, Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-efi@vger.kernel.org

On 2 May 2018 at 08:17, Lee, Chun-Yi <joeyli.kernel@gmail.com> wrote:
> When using kdump, SOMETIMES the "size not consistent" warning message
> shows up when the crash kernel boots with early_ioremap_debug parameter:
>
> WARNING: CPU: 0 PID: 0 at ../mm/early_ioremap.c:182 early_iounmap+0x4f/0x12c()
> early_iounmap(ffffffffff200180, 00000118) [0] size not consistent 00000120
>
> The root cause is that the unmapping size of memory map doesn't
> match with the original size when mapping:
>
> in __efi_memmap_init()
>         map.map = early_memremap(phys_map, data->size);
>
> in efi_memmap_unmap()
>         size = efi.memmap.desc_size * efi.memmap.nr_map;
>         early_memunmap(efi.memmap.map, size);
>
> But the efi.memmap.nr_map is from __efi_memmap_init(). The remainder
> of size was discarded when calculating the nr_map:
>         map.nr_map = data->size / data->desc_size;
>
> When the original size of memory map region does not equal to the
> result of multiplication. The "size not consistent" warning
> will be triggered.
>
> This issue sometimes was hit by kdump because kexec set the efi map
> size to align with 16 when loading crash kernel image:
>
> in bzImage64_load()
>         efi_map_sz = efi_get_runtime_map_size();
>         efi_map_sz = ALIGN(efi_map_sz, 16);
>
> Dave Young's a841aa83d patch fixed kexec issue. On UEFI side, this
> patch changes the logic in the unmapping function. Using the end
> address of map to calcuate original size.
>

Why do we still need this patch? I.e., in which circumstances will
efi_memory_map_data::size assume a value that is rounded up or
otherwise incorrect?

> Thank Randy Wright for his report and testing. And also thank
> Takashi Iwai for his help to trace issue.
>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Tested-by: Randy Wright <rwright@hpe.com>
> Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
> ---
>  drivers/firmware/efi/memmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/memmap.c b/drivers/firmware/efi/memmap.c
> index 5fc7052..1f592d8 100644
> --- a/drivers/firmware/efi/memmap.c
> +++ b/drivers/firmware/efi/memmap.c
> @@ -121,7 +121,7 @@ void __init efi_memmap_unmap(void)
>         if (!efi.memmap.late) {
>                 unsigned long size;
>
> -               size = efi.memmap.desc_size * efi.memmap.nr_map;
> +               size = efi.memmap.map_end - efi.memmap.map;
>                 early_memunmap(efi.memmap.map, size);
>         } else {
>                 memunmap(efi.memmap.map);
> --
> 2.10.2
>
