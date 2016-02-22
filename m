From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] arm*: efi: drop permanent mapping of the UEFI System
 table
Date: Mon, 22 Feb 2016 16:09:11 +0000
Message-ID: <20160222160910.GK3435@leverpostej>
References: <1456153179-27214-1-git-send-email-ard.biesheuvel@linaro.org>
 <20160222154314.GJ3435@leverpostej>
 <CAKv+Gu_pnjL557dE1xez_y2tESOjZj9_2XEbNtm_b4yAA-WdYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_pnjL557dE1xez_y2tESOjZj9_2XEbNtm_b4yAA-WdYg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Feb 22, 2016 at 04:56:57PM +0100, Ard Biesheuvel wrote:
> On 22 February 2016 at 16:43, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> > On Mon, Feb 22, 2016 at 03:59:39PM +0100, Ard Biesheuvel wrote:
> >> The permanent, writable mapping of the UEFI System table is only
> >> referenced during invocations of UEFI Runtime Services, at which time
> >> the UEFI virtual mapping is available, which also covers the system
> >> table (since the runtime services themselves need access to it)
> >
> > I'm not sure it's strictly true that the runtime services themselves
> > need access to the system table. Why would that be necessary? Are
> > runtime services mandated to indirect calls via the system table?
> >
> 
> They don't need access per se, but they are allowed to reference it,
> and so the memory remapping layer must make it accessible after
> SetVirtualAddressMap(). The spec lists explicitly which fields are
> still valid after ExitBootServices()

I was language-lawyering ;)

I appreciate that they _can_, I just didn't think it was true that they
_must_ (i.e. that they always "need to access it"). Per the below that's
likely moot.

> SetVirtualAddressMap() is a runtime service, and one of the things it
> does is update the pointers in the system table, hence it must be
> located in RuntimeService memory, because anything else may be gone by
> this time.

Good point. That does imply that it must be in EfiRuntimeServices*
memory.

> > From the spec, I couldn't find a mandate that the system table (nor the
> > runtime services table) were in a region of EfiRuntimeServicesData
> > memory. I suspect I'm looking in the wrong place...
> 
> We should clarify it if it is not clear (or if I turn out to be wrong)

I'm hoping that I've simply missed something. Perhaps the implication
above was intentional, albeit rather opaque.

Otherwise, I certainly agree a clarification would be a good thing!

Mark.
