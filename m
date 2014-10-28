From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 00/10] arm64 EFI patches for 3.19
Date: Tue, 28 Oct 2014 12:38:33 +0000
Message-ID: <20141028123832.GD12136@arm.com>
References: <1413987713-30528-1-git-send-email-ard.biesheuvel@linaro.org>
 <20141027115055.GM8768@arm.com>
 <CAKv+Gu_0uobUr2Ytzg7p8W4akK-c=qnFxhzuy4mbgfxnKjBG2Q@mail.gmail.com>
 <1414431927.7122.471.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1414431927.7122.471.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Oct 27, 2014 at 05:45:27PM +0000, Matt Fleming wrote:
> On Mon, 2014-10-27 at 13:03 +0100, Ard Biesheuvel wrote:
> > 
> > Yeah, I was struggling a bit with that. I think the agreement was that
> > everything EFI related goes through Matt's tree, but I don't think
> > that necessarily makes sense for patches that only touch arch/arm64,
> > unless there are interdependencies with the generic code.
> > 
> > From this series, only patches #7 and #8 need to go through Matt's
> > tree, and even if #9 and #10 are also related to SMBIOS, they are in
> > fact orthogonal to #7 and #8, so those can still go through the arm64
> > tree without any merge order issues later on.
> > 
> > @Matt: any thoughts?
> 
> In this case, if it makes things easier for you folks in terms of
> dependencies to take this *all* through the arm64 tree, that seems
> sensible to me.

Thanks, Matt. I won't merge anything that touches files outside of
arch/arm64 without your ack, but then I'll be happy to take this lot via
the arm64 tree.

Will
