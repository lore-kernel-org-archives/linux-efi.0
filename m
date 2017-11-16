From: AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: arm64 crashkernel fails to boot on acpi-only machines due to
 ACPI regions being no longer mapped as NOMAP
Date: Thu, 16 Nov 2017 16:00:08 +0900
Message-ID: <20171116070005.GI29552@linaro.org>
References: <CACi5LpM_95ebYFguPTyjWk+qHT5rDJVXiYDkNWbszo6Zw41zRA@mail.gmail.com>
 <CACi5LpNV_E9pvhTwLcy6vtEj9qbL1ZEHe-5sv=iiW0k9JxPD1Q@mail.gmail.com>
 <20171113092730.GA29552@linaro.org>
 <CAKv+Gu_eQ-s0J22tKeHKJme4qXcvxvDkS7vKrNW+o_XtMTkMhQ@mail.gmail.com>
 <3df4c6c5-0abe-01ee-730d-2edaa5f497d2@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3df4c6c5-0abe-01ee-730d-2edaa5f497d2-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Bhupesh SHARMA <bhupesh.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Bhupesh,

On Wed, Nov 15, 2017 at 04:28:55PM +0530, Bhupesh Sharma wrote:
> 
  (snip)

> # dmesg | grep -B 2 -i "ACPI reclaim"
> [    0.000000] efi:   0x000039670000-0x0000396bffff [Runtime Code |RUN|  |
> |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x0000396c0000-0x00003970ffff [Boot Code |   |  |  |
> |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x000039710000-0x00003975ffff [ACPI Reclaim Memory|
> |  |  |  |  |  |  |   |WB|WT|WC|UC]
> 
> 2. Now, I am not sure which kernel layer does the following changes (I am
> still trying to dig it out more), but I see that the 'Boot Code' and ACPI
> DSDT table regions are somehow merged into one memblock_region and appear as
> range '396c0000-3975ffff' in the '/proc/iomem' interface:
> 
> # cat /proc/iomem | grep -A 2 -B 2 39
> 00000000-3961ffff : System RAM
>   00080000-00b6ffff : Kernel code
>   00cb0000-0167ffff : Kernel data
>   0e800000-2e7fffff : Crash kernel
> 39620000-396bffff : reserved
> 396c0000-3975ffff : System RAM
> 39760000-3976ffff : reserved
> 39770000-397affff : reserved
> 397b0000-3989ffff : reserved
> 398a0000-398bffff : reserved
> 398c0000-39d3ffff : reserved
> 39d40000-3ed2ffff : System RAM
> 
  (snip)
> 
> So, I am looking at what could be causing the 'Boot Code' and 'ACPI DSDT
> table' ranges to be merged into a single region at
> '0x0000396c0000-0x00003970ffff' which cannot be marked as RESERVED using
> 'memblock_is_reserved'.

Simple:) The short answer is that memblock_add() does.

The long answer:
First, please note that memblock maintains two type of regions list,
"memory" and "reserved".

efi_init()
    reserve_regions()
        early_init_dt_add_memory_arch()
            memblock_add()
                memblock_add_range(memblock.memory)

The memory regions described in efi.memmap are added to "memory" list
with all the neighboring regions being merged into ones,
in this case, "Runtime Code", "Boot Code", "ACPI Reclaim Memory" and others.

The secret here is that "Runtime Code" is also marked with "NOMAP" flag in
reserve_regions(), which creates an isolated region since it now has
a different attribute.
Consequently only "Boot Code" and "ACPI Reclaim Memory" are
unified.

Look at request_standard_resources(). It handles only "memory" list,
and doesn't care about whether any arbitrary part of memory is in
"reserved" list or not.

Thanks,
-Takahiro AKASHI

> 
> Any pointers?
> 
> Regards,
> Bhupesh
> 
