From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCHv2 0/6] efi: detect erroneous firmware IRQ manipulation
Date: Mon, 25 Apr 2016 11:40:09 +0100
Message-ID: <20160425104009.GD25087@leverpostej>
References: <1461333083-15529-1-git-send-email-mark.rutland@arm.com>
 <CAKv+Gu8FGpZK4yDito2jKTbjuyE2jojj5tZhCa2qUwKdWL9+ng@mail.gmail.com>
 <20160424212241.GO2829@codeblueprint.co.uk>
 <20160425101527.GP2829@codeblueprint.co.uk>
 <CAKv+Gu8OfqdJp-VhC3o-tie4mRZXsF5ESKkZbsjnBHDY4xbXvQ@mail.gmail.com>
 <20160425102821.GQ2829@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160425102821.GQ2829-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Apr 25, 2016 at 11:28:21AM +0100, Matt Fleming wrote:
> On Mon, 25 Apr, at 12:21:18PM, Ard Biesheuvel wrote:
> > (+ Laszlo)
> > 
> > On 25 April 2016 at 12:15, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> > > On Sun, 24 Apr, at 10:22:41PM, Matt Fleming wrote:
> > >>
> > >> I like this series a lot (well, ignoring the fact that the firmware is
> > >> trying to eat itself). The runtime call code is much cleaner now, and
> > >> this is a great precedent for any future multi-architecture quirks we
> > >> may need.
> > >>
> > >> Queued for v4.7, thanks everyone!
> > >
> > > Hmm... Booting this series with Qemu and OVMF results in lots of
> > > warnings,
> > >
> > > [ 0.102173] ------------[ cut here ]------------
> > > [ 0.103000] WARNING: CPU: 0 PID: 0 at /dev/shm/mfleming/git/efi/drivers/firmware/efi/runtime-wrappers.c:30 efi_call_virt_check_flags+0x69/0x90
> > > [ 0.103505] Modules linked in:
> > > [ 0.104519] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.6.0-rc4+ #1
> > > [    0.105000]  0000000000000000 ffffffff81e03e30 ffffffff8132206f 0000000000000000
> > > [    0.105000]  0000000000000000 ffffffff81e03e70 ffffffff8105a47c 0000001e0000000a
> > > [    0.105000]  0000000000000246 0000000000000286 ffffffff81bed975 ffffffff81e03f10
> > > [    0.105000] Call Trace:
> > > [    0.105000]  [<ffffffff8132206f>] dump_stack+0x4d/0x6e
> > > [    0.105000]  [<ffffffff8105a47c>] __warn+0xcc/0xf0
> > > [    0.105000]  [<ffffffff8105a558>] warn_slowpath_null+0x18/0x20
> > > [    0.105000]  [<ffffffff8164e5a9>] efi_call_virt_check_flags+0x69/0x90
> > > [    0.105000]  [<ffffffff8164f9d2>] virt_efi_set_variable+0x82/0x190
> > > [    0.105000]  [<ffffffff81054555>] efi_delete_dummy_variable+0x75/0x80
> > > [    0.105000]  [<ffffffff81f599f6>] efi_enter_virtual_mode+0x463/0x472
> > > [    0.105000]  [<ffffffff81f41f82>] start_kernel+0x38f/0x415
> > > [    0.105000]  [<ffffffff81f419e1>] ? set_init_arg+0x55/0x55
> > > [    0.105000]  [<ffffffff81f415ee>] x86_64_start_reservations+0x2a/0x2c
> > > [    0.105000]  [<ffffffff81f416da>] x86_64_start_kernel+0xea/0xed
> > > [    0.107181] ---[ end trace 0081cc453369d969 ]---
> > > [    0.107499] Disabling lock debugging due to kernel taint
> > > [    0.108226] [Firmware Bug]: IRQ flags corrupted (0x00000246=>0x00000286) by EFI set_variable
> > >
> > > Has anyone tested this series on x86 to ensure that this is a rare
> > > case? I'll go and test some physical x86 machines now.
> > 
> > I suppose that it is quite likely that this issue occurs in the wild
> > if it is present in OVMF. Could anyone check which flag is actually
> > clobbered here?
> 
> X86_EFLAGS_ZF (zero flag) gets turned off and X86_EFLAGS_SF (signed
> flag) gets turned on. Which is totally legitimate and isn't grounds
> for a warning... 
> 
> I think the function we want to use instead of local_save_flags() is
> irqs_disabled_flags().

It looks like irqs_disabled_flags() will do what you expect, and ignore
everything but the interrupt flag.

However, for ARM that will ignore the other exceptions we've seen FW
erroneously unmask (e.g. FIQ), which is unfortunate, as fiddling with
those is just as disastrous.

Would you be happy with an arch_efi_call_check_flags(before, after),
instead? That way we can make the flags we check arch-specific.

Thanks,
Mark.
