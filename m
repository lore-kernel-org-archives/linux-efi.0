From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v24 5/9] arm64: kdump: add kdump support
Date: Wed, 24 Aug 2016 11:25:29 +0100
Message-ID: <57BD7619.1040406@arm.com>
References: <20160809015615.28527-1-takahiro.akashi@linaro.org> <20160809015615.28527-3-takahiro.akashi@linaro.org> <57AB586D.3080900@arm.com> <20160818071547.GC20080@linaro.org> <20160819012651.GE20080@linaro.org> <20160819112217.GB22221@localhost.localdomain> <20160822012919.GI20080@linaro.org> <57BB0272.1000008@arm.com> <20160823003815.GL20080@linaro.org> <20160823112343.GC13501@localhost.localdomain> <20160824080443.GA12902@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160824080443.GA12902-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, bauerman-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Dave,

On 24/08/16 09:04, Dave Young wrote:
> Looking the arm-init.c, I suspect it missed the some efi ranges as
> reserved ranges like runtime code and runtime data etc. But I might be
> wrong.

This had me confused for too... I think I get it, my understanding is:


> static __init int is_reserve_region(efi_memory_desc_t *md)
> {
>         switch (md->type) {
>         case EFI_LOADER_CODE:
>         case EFI_LOADER_DATA:
>         case EFI_BOOT_SERVICES_CODE:
>         case EFI_BOOT_SERVICES_DATA:
>         case EFI_CONVENTIONAL_MEMORY:
>         case EFI_PERSISTENT_MEMORY:
>                 return 0;

return false - this is the list of region-types to never reserve, regardless of
memory attributes.


>         default:
>                 break;
>         }
>         return is_normal_ram(md);

If its not in the 'never reserve' list above, then we check if the region is
'normal' ram. If it is then it will end up in memblock.memory so we return true,
causing it to be marked nomap too.

reserve_regions() in that same file calls is_normal_ram() directly before adding
all regions with the WB attribute to memblock.memory via
early_init_dt_add_memory_arch().

A runtime region with the WB attribute will be caught by is_reserve_region(),
and is_normal_ram(), so it ends up in memblock.memory and memblock.nomap.


> }
> 
> Let's see the x86 do_add_efi_mem_map, the default case set all other
> types as reserved. Shouldn't this be same in all arches though there's
> no e820 in arm(64)?

> static void __init do_add_efi_memmap(void)
> {
> 
> [snip]
>                 switch (md->type) {
>                 case EFI_LOADER_CODE:
>                 case EFI_LOADER_DATA:
>                 case EFI_BOOT_SERVICES_CODE:
>                 case EFI_BOOT_SERVICES_DATA:
>                 case EFI_CONVENTIONAL_MEMORY:
>                         if (md->attribute & EFI_MEMORY_WB)
>                                 e820_type = E820_RAM;

In this case reserve_regions() will add the memory to memblock.memory because it
has the WB attribute, and not reserve it.


>                         else
>                                 e820_type = E820_RESERVED;

Without the WB attribute, these regions are in neither memblock.memory nor
memblock.nomap.


>                         break;
> [snip]
>                 default:
>                         /*
>                          * EFI_RESERVED_TYPE EFI_RUNTIME_SERVICES_CODE
>                          * EFI_RUNTIME_SERVICES_DATA
>                          * EFI_MEMORY_MAPPED_IO
>                          * EFI_MEMORY_MAPPED_IO_PORT_SPACE EFI_PAL_CODE
>                          */
>                         e820_type = E820_RESERVED;
>                         break;

If any other regions has the WB attribute, it will be added to memblock.memory
and memblock.nomap. If it doesn't, it will appear in neither.


>                 }
> [snip]
> }

Does this help at all?


Thanks,

James
