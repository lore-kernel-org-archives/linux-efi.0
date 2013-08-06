From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [edk2] Corrupted EFI region
Date: Tue, 6 Aug 2013 16:10:36 +0200
Message-ID: <20130806141036.GD14891@pd.tnic>
References: <51FFAB13.4090603@redhat.com>
 <20130805140306.GD31845@pd.tnic>
 <51FFB660.4060400@redhat.com>
 <20130805144010.GE31845@pd.tnic>
 <51FFC19A.1020204@redhat.com>
 <20130805161247.GF31845@pd.tnic>
 <51FFD5B0.9080000@redhat.com>
 <20130805164731.GG31845@pd.tnic>
 <52001896.1030509@redhat.com>
 <20130805220808.GC14067@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130805220808.GC14067-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: edk2-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Aug 06, 2013 at 12:08:08AM +0200, Borislav Petkov wrote:
> Ok, thanks again for finding it, I'll go and try to figure out the whole
> mess tomorrow.

Ok, some more observations:

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] memblock_reserve: [0x0000000009f000-0x00000000100000] reserve_ebda_region+0x56/0x58
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc4+ (boris@nazgul) (gcc version 4.7.3 (Debian 4.7.3-4) ) #4 SMP PREEMPT Tue Aug 6 15:15:07 CEST 2013
[    0.000000] memblock_reserve: [0x00000002000000-0x000000036c0000] setup_arch+0x47/0xa63
[    0.000000] Command line: root=/dev/sda1 debug ignore_loglevel log_buf_len=10M earlyprintk=ttyS0,115200 console=ttyS0,115200 console=tty0 memblock=debug
[    0.000000] efi: efi_memblock_x86_reserve_range: pmap: 0x7e0ad018
[    0.000000] memblock_reserve: [0x0000007e0ad018-0x0000007e0ad588] efi_memblock_x86_reserve_range+0x70/0x75

And this is it:

efi_memblock_x86_reserve_range() reserves the region which overlaps with
the following region:

[    0.000000] efi: mem11: type=4, attr=0xf, range=[0x000000007e0ad000-0x000000007e0cc000) (0MB)

Now, this address 0x7e0ad018 is boot_params.efi_info.efi_memmap which,
AFAICT, we write to in exit_boot() after calling GetMemoryMap(). IOW,
this the EFI memory map descriptor which we mark as reserved.

So, hmm, I'm not sure what we want to do here.

Off the top of my head, I'm thinking this: efi_reserve_boot_services()
which truncates this region to 0 should actually check that this special
region is reserved, and *enlarge* it instead of making it of size 0, no?

Right?

Or does anyone have a better idea?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
