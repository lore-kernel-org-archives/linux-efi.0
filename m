From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 3/3] arm64/efi: efistub: don't abort if base of DRAM
 is occupied
Date: Wed, 20 Aug 2014 18:35:28 +0100
Message-ID: <20140820173528.GH21734@leverpostej>
References: <1406717944-24725-1-git-send-email-ard.biesheuvel@linaro.org>
 <1406717944-24725-4-git-send-email-ard.biesheuvel@linaro.org>
 <20140814113204.GE24018@leverpostej>
 <20140820171057.GG29733@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140820171057.GG29733-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Aug 20, 2014 at 06:10:57PM +0100, Matt Fleming wrote:
> On Thu, 14 Aug, at 12:32:05PM, Mark Rutland wrote:
> > On Wed, Jul 30, 2014 at 11:59:04AM +0100, Ard Biesheuvel wrote:
> > > If we cannot relocate the kernel Image to its preferred offset of base of DRAM
> > > plus TEXT_OFFSET, instead relocate it to the lowest available 2 MB boundary plus
> > > TEXT_OFFSET. We may lose a bit of memory at the low end, but we can still
> > > proceed normally otherwise.
> > > 
> > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > > Acked-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > 
> > Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> 
> Ard, who's picking this up?

Will's already taken this into arm64/devel [1,2] with the intention of
waiting for v3.18 [3]. Per Leif's comment [4] that might have to be
bumped.

Will?

Mark.

[1] https://git.kernel.org/cgit/linux/kernel/git/arm64/linux.git/commit/?h=devel
[2] https://git.kernel.org/cgit/linux/kernel/git/arm64/linux.git/commit/?h=devel&id=12f002aa8d96b90e6e37cc2b0d9a6a3cacdf8ef5
[3] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-August/279655.html
[4] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-August/279771.html
