From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: arm64: abort boot on pending SError
Date: Fri, 1 Jul 2016 16:46:12 +0100
Message-ID: <20160701154612.GC17071@leverpostej>
References: <1467385291-9880-1-git-send-email-ard.biesheuvel@linaro.org>
 <20160701152252.GA17071@leverpostej>
 <CAKv+Gu9Pk6xbUUMisAMhd4rpoYHA+wjzrZGkyEUXPdx_TaniVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9Pk6xbUUMisAMhd4rpoYHA+wjzrZGkyEUXPdx_TaniVQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Jul 01, 2016 at 05:31:33PM +0200, Ard Biesheuvel wrote:
> On 1 July 2016 at 17:22, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> > On Fri, Jul 01, 2016 at 05:01:30PM +0200, Ard Biesheuvel wrote:
> >> It is the firmware's job to clear any pending SErrors before entering
> >> the kernel. On UEFI, we can fail gracefully rather than panic during
> >> early boot, so check for this condition in the stub.
> >>
> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> >
> > An SError could be triggered either asynchronously by FW, or as a result
> > of our actions at any point after this, e.g. due to the filesystem
> > accesses made to load an initrd.
> >
> > So in practice, is checking here useful? Have we seen FW with masked but
> > pending SError at the point we enter the stub rather than that SError
> > being triggered later,?
> 
> Yes. EDK2 keeps SError masked throughout its execution by default, and
> so any condition that triggered an SError up till this point is likely
> to still be pending, and blow up the kernel as soon as it unmasks it.

Ok.

> > I'm also not sure what this means for CPER, which may use SError to
> > signal to the OS. It's possible that the UEFI implementation polls
> > ISR_EL1 itself, and handles SError appropriately internally, or that the
> > OS can later deal with the SError based on CPER and friends.
> 
> Currently, the kernel panics on an SError, and so what the kernel
> should do once we start dealing with them in a more sophisticated way
> is hypothetical at the moment. Once that code arrives, it may revert
> this change, but for now, being dropped back into the UEFI shell does
> sound more appealing than panic early imo.

Logging something while the UART is available is certainly appealing.

As you say, we can change this later if/when we have more advanced
SError handling. So modulo my prior comments, I guess this is fine for
now.

Thanks,
Mark.
