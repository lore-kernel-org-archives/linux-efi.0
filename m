From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 3/3] arm64/efi: efistub: don't abort if base of DRAM
 is occupied
Date: Wed, 10 Sep 2014 09:39:44 +0100
Message-ID: <20140910083944.GA28488@arm.com>
References: <1406717944-24725-1-git-send-email-ard.biesheuvel@linaro.org>
 <1406717944-24725-4-git-send-email-ard.biesheuvel@linaro.org>
 <20140814113204.GE24018@leverpostej>
 <20140820171057.GG29733@console-pimps.org>
 <20140820173528.GH21734@leverpostej>
 <540F577A.4040709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <540F577A.4040709-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Sep 09, 2014 at 08:39:38PM +0100, Jon Masters wrote:
> On 08/20/2014 01:35 PM, Mark Rutland wrote:
> > On Wed, Aug 20, 2014 at 06:10:57PM +0100, Matt Fleming wrote:
> >> On Thu, 14 Aug, at 12:32:05PM, Mark Rutland wrote:
> >>> On Wed, Jul 30, 2014 at 11:59:04AM +0100, Ard Biesheuvel wrote:
> >>>> If we cannot relocate the kernel Image to its preferred offset of base of DRAM
> >>>> plus TEXT_OFFSET, instead relocate it to the lowest available 2 MB boundary plus
> >>>> TEXT_OFFSET. We may lose a bit of memory at the low end, but we can still
> >>>> proceed normally otherwise.
> >>>>
> >>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A-XMD5yJDbdMReXY1tMh2IBg@public.gmane.org>
> >>>> Acked-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA-XMD5yJDbdMReXY1tMh2IBg@public.gmane.org>
> >>>
> >>> Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8-XMD5yJDbdMReXY1tMh2IBg@public.gmane.org>
> >>
> >> Ard, who's picking this up?
> > 
> > Will's already taken this into arm64/devel [1,2] with the intention of
> > waiting for v3.18 [3]. Per Leif's comment [4] that might have to be
> > bumped.
> 
> So what's the plan with this series? Waiting for 3.18? The problem is
> that this patch series needs to be pulled for any platform with an EFI
> firmware located at DRAM base (e.g. AMD Seattle) as was noted before.

Yes, it's queued for 3.18 and should be in linux-next too. This isn't a
regression, so you'll just have to sit tight.

Will
