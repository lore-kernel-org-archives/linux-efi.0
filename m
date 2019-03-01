From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi: Downgrade "EFI_MEMMAP is not enabled" message
Date: Fri, 1 Mar 2019 15:02:23 +0100
Message-ID: <CAKv+Gu91QeeFHXfp4ShM2z1hbypwnoRKzZQQ3Sktk1sASXvR6Q@mail.gmail.com>
References: <20190301134033.2100-1-tiwai@suse.de> <CAKv+Gu_d7fZuFmu6e5v4WFta11qVRkaKZWdt4X33JRLe3BwHZw@mail.gmail.com>
 <s5ha7ieels3.wl-tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <s5ha7ieels3.wl-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Takashi Iwai <tiwai@suse.de>
Cc: "Lee, Chun-Yi" <jlee@suse.com>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 1 Mar 2019 at 15:01, Takashi Iwai <tiwai@suse.de> wrote:
>
> On Fri, 01 Mar 2019 14:53:39 +0100,
> Ard Biesheuvel wrote:
> >
> > On Fri, 1 Mar 2019 at 14:40, Takashi Iwai <tiwai@suse.de> wrote:
> > >
> > > Since 38ac0287b7f4 ("fbdev/efifb: Honour UEFI memory map attributes
> > > when mapping the FB"), efifb_probe() checks its memory range via
> > > efi_mem_desc_lookup(), and this leads to a spurious error message
> > > "EFI_MEMMAP is not enabled" at every boot on KVM.  This is quite
> > > annoying since the error message appears even if you set "quiet" boot
> > > option.
> > >
> > > Actually there are only a few places that call efi_mem_desc_lookup()
> > > function, and the other callers do give the explicit error messages
> > > when the function returns an error in anyway.  That is, the error
> > > message in the function is more or less moot.
> > >
> > > So let's downgrade the error message for stop annoying users.
> > >
> > > Fixes: 38ac0287b7f4 ("fbdev/efifb: Honour UEFI memory map attributes when mapping the FB")
> > > Bugzilla: https://bugzilla.suse.com/show_bug.cgi?id=1127339
> > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > > ---
> > >  drivers/firmware/efi/efi.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> > > index 55b77c576c42..50ac33097458 100644
> > > --- a/drivers/firmware/efi/efi.c
> > > +++ b/drivers/firmware/efi/efi.c
> > > @@ -409,7 +409,7 @@ int efi_mem_desc_lookup(u64 phys_addr, efi_memory_desc_t *out_md)
> > >         efi_memory_desc_t *md;
> > >
> > >         if (!efi_enabled(EFI_MEMMAP)) {
> > > -               pr_err_once("EFI_MEMMAP is not enabled.\n");
> > > +               pr_debug("EFI_MEMMAP is not enabled.\n");
> > >                 return -EINVAL;
> > >         }
> > >
> >
> > efifb_probe() only calls efi_mem_desc_lookup() if
> > screen_info.orig_video_isVGA == VIDEO_TYPE_EFI, which only gets
> > assigned on a EFI boot.
> >
> > So even though I don't object to the patch as is, I would like to
> > understand where this error message is coming from, given that it
> > means that you are running on a UEFI system without the EFI memory
> > map.
> >
> > Is this system booting via GRUB in EFI mode?
>
> No, it's booted in legacy boot mode.  But the primary fb is efifb, and
> that's why the message appears.
>

So how are we ending up with

screen_info.orig_video_isVGA == VIDEO_TYPE_EFI

??
