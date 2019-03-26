From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi: Downgrade "EFI_MEMMAP is not enabled" message
Date: Tue, 26 Mar 2019 17:04:30 +0100
Message-ID: <CAKv+Gu-C08VWKD8HrGfFMgQ+LxxXKtPEjGyJpwQoSu63zT_ZOQ@mail.gmail.com>
References: <20190301134033.2100-1-tiwai@suse.de> <CAKv+Gu_d7fZuFmu6e5v4WFta11qVRkaKZWdt4X33JRLe3BwHZw@mail.gmail.com>
 <s5ha7ieels3.wl-tiwai@suse.de> <CAKv+Gu91QeeFHXfp4ShM2z1hbypwnoRKzZQQ3Sktk1sASXvR6Q@mail.gmail.com>
 <s5h5zt2el6d.wl-tiwai@suse.de> <CAKv+Gu-gp+Hvd-ZcZC-ZRQOHpinj_mXx-L6fTUkKWSXd0UwC+g@mail.gmail.com>
 <s5hpnrad38j.wl-tiwai@suse.de> <s5himw564l0.wl-tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <s5himw564l0.wl-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Takashi Iwai <tiwai@suse.de>
Cc: "Lee, Chun-Yi" <jlee@suse.com>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 26 Mar 2019 at 16:25, Takashi Iwai <tiwai@suse.de> wrote:
>
> On Fri, 01 Mar 2019 16:27:24 +0100,
> Takashi Iwai wrote:
> >
> > On Fri, 01 Mar 2019 15:57:03 +0100,
> > Ard Biesheuvel wrote:
> > >
> > > On Fri, 1 Mar 2019 at 15:14, Takashi Iwai <tiwai@suse.de> wrote:
> > > >
> > > > On Fri, 01 Mar 2019 15:02:23 +0100,
> > > > Ard Biesheuvel wrote:
> > > > >
> > > > > On Fri, 1 Mar 2019 at 15:01, Takashi Iwai <tiwai@suse.de> wrote:
> > > > > >
> > > > > > On Fri, 01 Mar 2019 14:53:39 +0100,
> > > > > > Ard Biesheuvel wrote:
> > > > > > >
> > > > > > > On Fri, 1 Mar 2019 at 14:40, Takashi Iwai <tiwai@suse.de> wrote:
> > > > > > > >
> > > > > > > > Since 38ac0287b7f4 ("fbdev/efifb: Honour UEFI memory map attributes
> > > > > > > > when mapping the FB"), efifb_probe() checks its memory range via
> > > > > > > > efi_mem_desc_lookup(), and this leads to a spurious error message
> > > > > > > > "EFI_MEMMAP is not enabled" at every boot on KVM.  This is quite
> > > > > > > > annoying since the error message appears even if you set "quiet" boot
> > > > > > > > option.
> > > > > > > >
> > > > > > > > Actually there are only a few places that call efi_mem_desc_lookup()
> > > > > > > > function, and the other callers do give the explicit error messages
> > > > > > > > when the function returns an error in anyway.  That is, the error
> > > > > > > > message in the function is more or less moot.
> > > > > > > >
> > > > > > > > So let's downgrade the error message for stop annoying users.
> > > > > > > >
> > > > > > > > Fixes: 38ac0287b7f4 ("fbdev/efifb: Honour UEFI memory map attributes when mapping the FB")
> > > > > > > > Bugzilla: https://bugzilla.suse.com/show_bug.cgi?id=1127339
> > > > > > > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > > > > > > > ---
> > > > > > > >  drivers/firmware/efi/efi.c | 2 +-
> > > > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > > > >
> > > > > > > > diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> > > > > > > > index 55b77c576c42..50ac33097458 100644
> > > > > > > > --- a/drivers/firmware/efi/efi.c
> > > > > > > > +++ b/drivers/firmware/efi/efi.c
> > > > > > > > @@ -409,7 +409,7 @@ int efi_mem_desc_lookup(u64 phys_addr, efi_memory_desc_t *out_md)
> > > > > > > >         efi_memory_desc_t *md;
> > > > > > > >
> > > > > > > >         if (!efi_enabled(EFI_MEMMAP)) {
> > > > > > > > -               pr_err_once("EFI_MEMMAP is not enabled.\n");
> > > > > > > > +               pr_debug("EFI_MEMMAP is not enabled.\n");
> > > > > > > >                 return -EINVAL;
> > > > > > > >         }
> > > > > > > >
> > > > > > >
> > > > > > > efifb_probe() only calls efi_mem_desc_lookup() if
> > > > > > > screen_info.orig_video_isVGA == VIDEO_TYPE_EFI, which only gets
> > > > > > > assigned on a EFI boot.
> > > > > > >
> > > > > > > So even though I don't object to the patch as is, I would like to
> > > > > > > understand where this error message is coming from, given that it
> > > > > > > means that you are running on a UEFI system without the EFI memory
> > > > > > > map.
> > > > > > >
> > > > > > > Is this system booting via GRUB in EFI mode?
> > > > > >
> > > > > > No, it's booted in legacy boot mode.  But the primary fb is efifb, and
> > > > > > that's why the message appears.
> > > > > >
> > > > >
> > > > > So how are we ending up with
> > > > >
> > > > > screen_info.orig_video_isVGA == VIDEO_TYPE_EFI
> > > > >
> > > > > ??
> > > >
> > > > Ah, sorry, my description was too ambiguous.
> > > >
> > > > Actually our GRUB2 default setup boots the Linux kernel with linuxefi.
> > > > What I meant was that I invoked qemu-kvm without any -bios option, so
> > > > it's no EFI BIOS.
> > > >
> > >
> > > Some from the link here
> > >
> > > https://openqa.opensuse.org/tests/864184/file/journal_check-full_journal.log
> > >
> > > I got
> > >
> > > Feb 27 13:13:41 linux-e2c3 kernel: efifb: probing for efifb
> > > Feb 27 13:13:41 linux-e2c3 kernel: efi: EFI_MEMMAP is not enabled.
> > > Feb 27 13:13:41 linux-e2c3 kernel: fbcon: Taking over console
> > > Feb 27 13:13:41 linux-e2c3 kernel: efifb: No BGRT, not showing boot graphics
> > > Feb 27 13:13:41 linux-e2c3 kernel: efifb: framebuffer at 0xfc000000,
> > > using 1408k, total 1408k
> > > Feb 27 13:13:41 linux-e2c3 kernel: efifb: mode is 800x600x24,
> > > linelength=2400, pages=1
> > > Feb 27 13:13:41 linux-e2c3 kernel: efifb: scrolling: redraw
> > > Feb 27 13:13:41 linux-e2c3 kernel: efifb: Truecolor: size=0:8:8:8,
> > > shift=0:16:8:0
> > > Feb 27 13:13:41 linux-e2c3 kernel: Console: switching to colour frame
> > > buffer device 100x37
> > > Feb 27 13:13:41 linux-e2c3 kernel: fb0: EFI VGA frame buffer device
> > >
> > > So if we are doing legacy, there is something else that is taking,
> > > GRUB perhaps, that is taking the framebuffer parameters and putting
> > > them in screen_info and marking them as VIDEO_TYPE_EFI.
> > >
> > > If this is a reasonable thing to do, it implies that the efifb driver
> > > may run on otherwise non-EFI systems, and if this is the case, I'd
> > > rather fix it like this:
> > >
> > > diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
> > > index ba906876cc45..9e529cc2b4ff 100644
> > > --- a/drivers/video/fbdev/efifb.c
> > > +++ b/drivers/video/fbdev/efifb.c
> > > @@ -464,7 +464,8 @@ static int efifb_probe(struct platform_device *dev)
> > >         info->apertures->ranges[0].base = efifb_fix.smem_start;
> > >         info->apertures->ranges[0].size = size_remap;
> > >
> > > -       if (!efi_mem_desc_lookup(efifb_fix.smem_start, &md)) {
> > > +       if (efi_enabled(EFI_BOOT) &&
> > > +           !efi_mem_desc_lookup(efifb_fix.smem_start, &md)) {
> > >                 if ((efifb_fix.smem_start + efifb_fix.smem_len) >
> > >                     (md.phys_addr + (md.num_pages << EFI_PAGE_SHIFT))) {
> > >                         pr_err("efifb: video memory @ 0x%lx spans
> > > multiple EFI memory regions\n",
> > >
> > > Could you please confirm whether this works around the issue as well?
> >
> > Yeah, that makes sense, and I confirmed that your patch worked.
> > Both EFI_BOOT and EFI_MEMMAP are 0 on the default boot.
> >
> > Reported-and-tested-by: Takashi Iwai <tiwai@suse.de>
>
> Ard, what is the status of this fix?
>

I will get it queued for v5.2
