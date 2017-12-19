From: AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: arm64 crashkernel fails to boot on acpi-only machines due to
 ACPI regions being no longer mapped as NOMAP
Date: Tue, 19 Dec 2017 14:01:15 +0900
Message-ID: <20171219050113.GF28046@linaro.org>
References: <20171213102624.GC28046@linaro.org>
 <CAKv+Gu_BmFN9Zg861SCS+R=V4khFykjuOzkmfEknsL=NvWW3Eg@mail.gmail.com>
 <20171213121605.GE28046@linaro.org>
 <CAKv+Gu_G8kBEAdAznVauZVAdJOFkr1vmu0Gf6tOwJfH2CgdufA@mail.gmail.com>
 <20171215085924.sqlcwm4copzba5ag@fireball>
 <CAKv+Gu-W5VpVrgA=FVZCCevksaRGOVvPdE+B8WkpZc6AE1jOPw@mail.gmail.com>
 <CACi5LpPDL0j4o3MuOZ3jRv3UOqM48yTgKtdm-hY+OWL8h-ETzQ@mail.gmail.com>
 <20171218051657.GA5998@dhcp-128-65.nay.redhat.com>
 <20171218055356.mq4coiibh3frii54@fireball>
 <CAFTCetQ55zUKe25jSku0DHp8uVZA4hB32d5W6MSCNsTVpxu7Gw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFTCetQ55zUKe25jSku0DHp8uVZA4hB32d5W6MSCNsTVpxu7Gw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bhupesh SHARMA <bhupesh.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Dec 18, 2017 at 02:29:05PM +0530, Bhupesh SHARMA wrote:
> 
> [snip..]
> 
> [    0.000000] linux,usable-memory-range base e800000, size 20000000
> [    0.000000]  - e800000 ,  20000000
> [    0.000000] linux,usable-memory-range base 396c0000, size a0000
> [    0.000000]  - 396c0000 ,  a0000
> [    0.000000] linux,usable-memory-range base 39770000, size 40000
> [    0.000000]  - 39770000 ,  40000
> [    0.000000] linux,usable-memory-range base 398a0000, size 20000
> [    0.000000]  - 398a0000 ,  20000
> [    0.000000] initrd not fully accessible via the linear mapping --
> please check your bootloader ...

This is an odd message coming from:
|void __init arm64_memblock_init(void)
|...
|
|                if (WARN(base < memblock_start_of_DRAM() ||
|                         base + size > memblock_start_of_DRAM() +
|                                       linear_region_size,
|                        "initrd not fully accessible via the linear mapping -- please check your bootloader ...\n")) {

Can you confirm how the condition breaks here?
I suppose
    base: 0xfe70000
    size: 0x13c0000
    memblock_start_of_DRAM(): 0xe800000
according to the information you gave me.

Thanks,
-Takahiro AKASHI


> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: CPU: 0 PID: 0 at arch/arm64/mm/init.c:597
> arm64_memblock_init+0x210/0x484
> [    0.000000] Modules linked in:
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 4.14.0+ #7
> [    0.000000] task: ffff000008d05580 task.stack: ffff000008cc0000
> [    0.000000] PC is at arm64_memblock_init+0x210/0x484
> [    0.000000] LR is at arm64_memblock_init+0x210/0x484
> [    0.000000] pc : [<ffff000008b76984>] lr : [<ffff000008b76984>]
> pstate: 600000c5
> [    0.000000] sp : ffff000008ccfe80
> [    0.000000] x29: ffff000008ccfe80 x28: 000000000f370018
> [    0.000000] x27: 0000000011230000 x26: 00000000013b0000
> [    0.000000] x25: 000000000fe80000 x24: ffff000008cf3000
> [    0.000000] x23: ffff000008ec0000 x22: ffff000009680000
> [    0.000000] x21: ffff000008afa000 x20: ffff000008080000
> [    0.000000] x19: ffff000008afa000 x18: 000000000c283806
> [    0.000000] x17: 0000000000000000 x16: ffff000008d05580
> [    0.000000] x15: 000000002be00842 x14: 79206b6365686320
> [    0.000000] x13: 657361656c70202d x12: 2d20676e69707061
> [    0.000000] x11: 6d207261656e696c x10: 2065687420616976
> [    0.000000] x9 : 00000000000000f4 x8 : ffff000008517414
> [    0.000000] x7 : 746f6f622072756f x6 : 000000000000000d
> [    0.000000] x5 : ffff000008c96360 x4 : 0000000000000001
> [    0.000000] x3 : 0000000000000000 x2 : 0000000000000000
> [    0.000000] x1 : 0000000000000000 x0 : 0000000000000056
> [    0.000000] Call trace:
> [    0.000000] Exception stack(0xffff000008ccfd40 to 0xffff000008ccfe80)
> [    0.000000] fd40: 0000000000000056 0000000000000000
> 0000000000000000 0000000000000000
> [    0.000000] fd60: 0000000000000001 ffff000008c96360
> 000000000000000d 746f6f622072756f
> [    0.000000] fd80: ffff000008517414 00000000000000f4
> 2065687420616976 6d207261656e696c
> [    0.000000] fda0: 2d20676e69707061 657361656c70202d
> 79206b6365686320 000000002be00842
> [    0.000000] fdc0: ffff000008d05580 0000000000000000
> 000000000c283806 ffff000008afa000
> [    0.000000] fde0: ffff000008080000 ffff000008afa000
> ffff000009680000 ffff000008ec0000
> [    0.000000] fe00: ffff000008cf3000 000000000fe80000
> 00000000013b0000 0000000011230000
> [    0.000000] fe20: 000000000f370018 ffff000008ccfe80
> ffff000008b76984 ffff000008ccfe80
> [    0.000000] fe40: ffff000008b76984 00000000600000c5
> ffff00000959b7a8 ffff000008ec0000
> [    0.000000] fe60: ffffffffffffffff 0000000000000005
> ffff000008ccfe80 ffff000008b76984
> [    0.000000] [<ffff000008b76984>] arm64_memblock_init+0x210/0x484
> [    0.000000] [<ffff000008b7398c>] setup_arch+0x1b8/0x5f4
> [    0.000000] [<ffff000008b70a10>] start_kernel+0x74/0x43c
> [    0.000000] random: get_random_bytes called from
> print_oops_end_marker+0x50/0x6c with crng_init=0
> [    0.000000] ---[ end trace 0000000000000000 ]---
> [    0.000000] Reserving 4KB of memory at 0x2e7f0000 for elfcorehdr
> [    0.000000] cma: Failed to reserve 512 MiB
> [    0.000000] Kernel panic - not syncing: ERROR: Failed to allocate
> 0x0000000000010000 bytes below 0x0000000000000000.
> [    0.000000]
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Tainted: G        W
> ------------   4.14.0+ #7
> [    0.000000] Call trace:
> [    0.000000] [<ffff000008088da8>] dump_backtrace+0x0/0x23c
> [    0.000000] [<ffff000008089008>] show_stack+0x24/0x2c
> [    0.000000] [<ffff0000087f647c>] dump_stack+0x84/0xa8
> [    0.000000] [<ffff0000080cfd44>] panic+0x138/0x2a0
> [    0.000000] [<ffff000008b95c88>] memblock_alloc_base+0x44/0x4c
> [    0.000000] [<ffff000008b95cbc>] memblock_alloc+0x2c/0x38
> [    0.000000] [<ffff000008b772dc>] early_pgtable_alloc+0x20/0x74
> [    0.000000] [<ffff000008b7755c>] paging_init+0x28/0x544
> [    0.000000] [<ffff000008b73990>] setup_arch+0x1bc/0x5f4
> [    0.000000] [<ffff000008b70a10>] start_kernel+0x74/0x43c
> [    0.000000] ---[ end Kernel panic - not syncing: ERROR: Failed to
> allocate 0x0000000000010000 bytes below 0x0000000000000000.
> [    0.000000]
> 
> I guess it is because of the 1G alignment requirement between the
> kernel image and the initrd and how we populate the holes between the
> kernel image, segments (including dtb) and the initrd from the
> kexec-tools.
> 
> Akashi, any pointers on this will be helpful as well.
> 
> Regards,
> Bhupesh
> 
> 
> >> >
> >> > Regards,
> >> > Bhupesh
> >> >
> >> > >> Just FYI, on x86, ACPI tables seems to be exposed to crash dump kernel
> >> > >> via a kernel command line parameter, "memmap=".
> >> > >>
> >> > _______________________________________________
> >> > kexec mailing list -- kexec-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org
> >> > To unsubscribe send an email to kexec-leave-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org
