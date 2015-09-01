From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] efifb: Add support for 64-bit frame buffer addresses
Date: Tue, 1 Sep 2015 09:54:26 +0100
Message-ID: <20150901085426.GC2823@codeblueprint.co.uk>
References: <1440763939-17027-1-git-send-email-matt@codeblueprint.co.uk>
 <CAMuHMdU146p_vs9bfgV9n_tTkH_545hRb1qsEza=dLO=C-y69A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMuHMdU146p_vs9bfgV9n_tTkH_545hRb1qsEza=dLO=C-y69A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Peter Jones <pjones@redhat.com>, linux-efi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux Fbdev development list <linux-fbdev@vger.kernel.org>, Matt Fleming <matt.fleming@intel.com>, Pete Hawkins <pete.hawkins@znyx.com>, Matthew Garrett <mjg59@srcf.ucam.org>, Chad Page <chad.page@znyx.com>
List-Id: linux-efi@vger.kernel.org

On Mon, 31 Aug, at 10:24:31PM, Geert Uytterhoeven wrote:
> On Fri, Aug 28, 2015 at 2:12 PM, Matt Fleming <matt@codeblueprint.co.uk> wrote:
> > --- a/arch/x86/boot/compressed/eboot.c
> > +++ b/arch/x86/boot/compressed/eboot.c
> > @@ -624,7 +624,7 @@ setup_pixel_info(struct screen_info *si, u32 pixels_per_scan_line,
> >  static efi_status_t
> >  __gop_query32(struct efi_graphics_output_protocol_32 *gop32,
> >               struct efi_graphics_output_mode_info **info,
> > -             unsigned long *size, u32 *fb_base)
> > +             unsigned long *size, u64 *fb_base)
> 
> phys_addr_t instead of u64?

I can see why you might think that, but no, phys_addr_t isn't the
correct data type because your kernel config dictates whether that's
u32 or u64.

We're interacting with the firmware here and the frame buffer address
is always u64, for both 32-bit and 64-bit firmware. It's defined that
way in the UEFI spec.

It's better to be explicit about these kinds of things, and use u64.

-- 
Matt Fleming, Intel Open Source Technology Center
