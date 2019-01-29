From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 2/2] efi: x86: convert x86 EFI earlyprintk into generic
 earlycon implementation
Date: Tue, 29 Jan 2019 14:41:51 +0100
Message-ID: <CAKv+Gu8S-EFdVtuKHEtV=3Mi7tKWjxEbjovAdspaKTzmUwAfjQ@mail.gmail.com>
References: <20190129092150.15184-1-ard.biesheuvel@linaro.org>
 <20190129092150.15184-3-ard.biesheuvel@linaro.org>
 <0ea153fd-1c2b-c4e6-54d9-e31189f1b90c@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <0ea153fd-1c2b-c4e6-54d9-e31189f1b90c@suse.de>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Alexander Graf <agraf@suse.de>
Cc: linux-efi <linux-efi@vger.kernel.org>, Graeme Gregory <graeme.gregory@linaro.org>, Jonathan Corbet <corbet@lwn.net>, Peter Jones <pjones@redhat.com>, Linux Doc Mailing List <linux-doc@vger.kernel.org>, Leif Lindholm <leif.lindholm@linaro.org>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

Hi Alex,

On Tue, 29 Jan 2019 at 14:37, Alexander Graf <agraf@suse.de> wrote:
>
> On 01/29/2019 10:21 AM, Ard Biesheuvel wrote:
> > Move the x86 EFI earlyprintk implementation to a shared location under
> > drivers/firmware and tweak it slightly so we can expose it as an earlycon
> > implementation (which is generic) rather than earlyprintk (which is only
> > implemented for a few architectures)
> >
> > This also involves switching to write-combine mappings by default (which
> > is required on ARM since device mappings lack memory semantics, and so
> > memcpy/memset may not be used on them), and adding support for shared
> > memory framebuffers on cache coherent non-x86 systems (which do not
> > tolerate mismatched attributes)
> >
> > Note that 32-bit ARM does not populate its struct screen_info early
> > enough for earlycon=efifb to work, so it is disabled there.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >   Documentation/admin-guide/kernel-parameters.txt |   8 +-
> >   arch/x86/Kconfig.debug                          |  10 -
> >   arch/x86/include/asm/efi.h                      |   1 -
> >   arch/x86/kernel/early_printk.c                  |   4 -
> >   arch/x86/platform/efi/Makefile                  |   1 -
> >   arch/x86/platform/efi/early_printk.c            | 240 --------------------
> >   drivers/firmware/efi/Kconfig                    |   6 +
> >   drivers/firmware/efi/Makefile                   |   1 +
> >   drivers/firmware/efi/earlycon.c                 | 208 +++++++++++++++++
> >   9 files changed, 222 insertions(+), 257 deletions(-)
> >
>
> [...]
>
> > +static int __init efi_earlycon_setup(struct earlycon_device *device,
> > +                                  const char *opt)
> > +{
> > +     struct screen_info *si;
> > +     u16 xres, yres;
> > +     u32 i;
> > +
> > +     if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
> > +             return -ENODEV;
> > +
> > +     fb_base = screen_info.lfb_base;
> > +     if (screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
> > +             fb_base |= (u64)screen_info.ext_lfb_base << 32;
> > +
> > +     if (opt && !strcmp(opt, "ram"))
> > +             fb_prot = PAGE_KERNEL;
> > +     else
> > +             fb_prot = pgprot_writecombine(PAGE_KERNEL);
>
> Can you determine the default from the UEFI memory map?
>

No. This is being called way before we parse the system table and the
memory map. Given that this is debug code, duplicating a significant
chunk of that work here (and run the risk of crashing here due to
unexpected contents in those tables) is not a great idea imo.

> Also, doesn't the current logic map it as WC on x86 too? Is that
> intentional?
>

Yes. As mentioned in the cover letter, this aligns it with efifb which
also uses WC by default (although there, it can be overridden for
performance reasons, but due to the debug nature of earlycon, this
doesn't matter, since higher performance only makes it more difficult
to capture the log on your phone camera)


> > +
> > +     si = &screen_info;
> > +     xres = si->lfb_width;
> > +     yres = si->lfb_height;
> > +
> > +     /*
> > +      * efi_earlycon_write_char() implicitly assumes a framebuffer with
> > +      * 32-bits per pixel.
> > +      */
> > +     if (si->lfb_depth != 32)
> > +             return -ENODEV;
> > +
> > +     font = get_default_font(xres, yres, -1, -1);
> > +     if (!font)
> > +             return -ENODEV;
> > +
> > +     efi_y = rounddown(yres, font->height) - font->height;
> > +     for (i = 0; i < (yres - efi_y) / font->height; i++)
> > +             efi_earlycon_scroll_up();
> > +
> > +     device->con->write = efi_earlycon_write;
> > +     return 0;
> > +}
> > +EARLYCON_DECLARE(efifb, efi_earlycon_setup);
>
>
