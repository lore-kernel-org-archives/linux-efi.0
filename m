From: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
Subject: Re: EFI tree kernel panic in phys_efi_set_virtual_address_map()
Date: Wed, 11 Dec 2013 18:08:04 -0700
Message-ID: <1386810484.1791.306.camel@misato.fc.hp.com>
References: <1386806463.1791.295.camel@misato.fc.hp.com>
	 <20131212002946.GF8863@pd.tnic>
	 <1386808323.1791.299.camel@misato.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1386808323.1791.299.camel-RbGIw1UOYPVo/CpIj0byZw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 2013-12-11 at 17:32 -0700, Toshi Kani wrote:
> On Thu, 2013-12-12 at 01:29 +0100, Borislav Petkov wrote:
> > On Wed, Dec 11, 2013 at 05:01:03PM -0700, Toshi Kani wrote:
> > > Hi Boris,
> > > 
> > > An EFI tree kernel panic'd during boot on one of my systems.  It boots
> > > fine when efi=old_map option is specified.  So, I think it is caused by
> > > your EFI virtual mapping changes.
> > > 
> > > The panic message is as follows.  I added some printk's to log the
> > > arguments of phys_efi_set_virtual_address_map().  The fault address is
> > > __pa(new_memmap) + 0x20 (too high for the map?).
> > > 
> > > Thanks,
> > > -Toshi
> > > 
> > > 
> > > 
> > > efi: >> Call phys_efi_set_virtual_address_map()
> > > efi:    count 29
> > > efi:    desc_size 0x30
> > > efi:    new_memmap 0xffff8a03fec16800
> > > efi:    __pa(new_memmap) 0x203fec16800
> > > 
> > > BUG: unable to handle kernel paging request at 00000203fec16820
> > > IP: [<0000000072dcda76>] 0x72dcda75
> > > PGD 0 
> > 
> > It looks like the page hierarchy which contains __pa(new_memmap) is not
> > mapped in the EFI page table. Nice.
> > 
> > > Oops: 0000 [#1] SMP 
> > > Modules linked in:
> > > CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.0+ #52
> > > Hardware name: HP CB920s x1, BIOS Bundle: 005.028.018 SFW: 012.124.000
> > > 10/28/2013
> > > task: ffffffff81a10480 ti: ffffffff81a00000 task.ti: ffffffff81a00000
> > > RIP: 0010:[<0000000072dcda76>]  [<0000000072dcda76>] 0x72dcda75
> > > RSP: 0000:ffffffff81a01e08  EFLAGS: 00010206
> > > RAX: 00000000725fee18 RBX: 00000000725feda0 RCX: 00000203fec16800
> > > RDX: 0000000072dfe070 RSI: 0000000060000202 RDI: 0000000072dcdac8
> > > RBP: 0000000072dd0560 R08: 0000000000000000 R09: 000000000000001d
> > > R10: 0000000000000030 R11: 8000000000000000 R12: ffff8a03fec16800
> > > R13: 0000000000000001 R14: 000000000000001d R15: 000000000009c000
> > > FS:  0000000000000000(0000) GS:ffff88087fa00000(0000)
> > > knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 00000203fec16820 CR3: 000000000009c000 CR4: 00000000000406b0
> > > Stack:
> > >  0000000072dfb88f 0000000000000001 0000000000000d08 0000000000000000
> > >  ffffffff81d79a98 0000000072dcdac8 0000000072dcdb93 0000000000000001
> > >  ffffffff81a01f80 0000000000000570 0000000000000000 0000000000000000
> > > Call Trace:
> > >  [<ffffffff81045cec>] ? efi_call4+0x6c/0xf0
> > >  [<ffffffff81b02f65>] ? efi_enter_virtual_mode+0x229/0x3f1
> > >  [<ffffffff81aebdf2>] ? start_kernel+0x36c/0x407
> > >  [<ffffffff81aeb88f>] ? repair_env_string+0x5c/0x5c
> > >  [<ffffffff81aeb5a3>] ? x86_64_start_reservations+0x2a/0x2c
> > >  [<ffffffff81aeb696>] ? x86_64_start_kernel+0xf1/0xf4
> > > Code:  Bad RIP value.
> > > RIP  [<0000000072dcda76>] 0x72dcda75
> > >  RSP <ffffffff81a01e08>
> > > CR2: 00000203fec16820
> > > ---[ end trace e50b25032c120443 ]---
> > 
> > Ok, it is late here and I'm almost blocked but you could try the dirty
> > patch below - more fiddling tomorrow.
> 
> Wow, that was quick.  Yes, I will test it and let you know how it goes.

Unfortunately, it did not work.  Hit the same panic again.

Thanks!
-Toshi
