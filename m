From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH] efi: Fix the size not consistent issue when unmapping
 memory map
Date: Mon, 16 Apr 2018 10:57:34 +0800
Message-ID: <20180416025734.GA26685@dhcp-128-65.nay.redhat.com>
References: <20180413062716.8040-1-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180413062716.8040-1-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, Randy Wright <rwright@hpe.com>, "Lee, Chun-Yi" <jlee@suse.com>, Ingo Molnar <mingo@redhat.com>, akpm@linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>
List-Id: linux-efi@vger.kernel.org

On 04/13/18 at 02:27pm, Lee, Chun-Yi wrote:
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
> 	map.map = early_memremap(phys_map, data->size);
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
> This patch changes the logic in the unmapping function. Using the
> end address of map to calcuate original size.
> 
> Thank Randy Wright for his report and testing. And also thank
> Takashi Iwai for his help to trace issue.

Good catch.  The kexec code need to be fixed to use a separate buffer so
avoid the alignment like what kexec-tools did.  I can submit a fix for
that.

But this issue could be a potential issue even if kexec get fixed so it
looks worth a fix in efi code as well.  How about mapping only nr_maps
*desc_size in __efi_memmap_init?  It looks easier to understand.

> 
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Randy Wright <rwright@hpe.com>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Ingo Molnar <mingo@redhat.com>
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
>  	if (!efi.memmap.late) {
>  		unsigned long size;
>  
> -		size = efi.memmap.desc_size * efi.memmap.nr_map;
> +		size = efi.memmap.map_end - efi.memmap.map;
>  		early_memunmap(efi.memmap.map, size);
>  	} else {
>  		memunmap(efi.memmap.map);
> -- 
> 2.10.2
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec

Thanks
Dave
