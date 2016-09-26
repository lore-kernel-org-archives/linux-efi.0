From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] efi: MMC proxy support for the UEFI varstore
Date: Mon, 26 Sep 2016 16:53:53 +0100
Message-ID: <20160926155352.GA16830@remoulade>
References: <1474543806-19210-1-git-send-email-ard.biesheuvel@linaro.org>
 <20160922125854.GC26596@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160922125854.GC26596@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, glikely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org, haojian.zhuang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, andrew-h+KGxgPPiopAfugRpC6u6w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Sep 22, 2016 at 01:58:54PM +0100, Mark Rutland wrote:
> On Thu, Sep 22, 2016 at 12:30:03PM +0100, Ard Biesheuvel wrote:

> > This series proposes an approach to work around this. It implements the UEFI
> > MMC host protocol in the kernel, in a way that makes it possible to expose it
> > to the firmware. At the same time, the firmware needs be set up for this, i.e.,
> > it needs to expose its MMC host protocol pointer via a UEFI configuration table,
> > so that the kernel can override it if it decides to expose this functionality
> > to the firmware.
> 
> At a high level, and assuming a number of details from previous
> discussions, I think the general approach of having the kernel mediate
> access to the MMC makes sense.

> I have a few other general concerns:

Another few thoughts I had:

* The UEFI spec mandates that a certain amount of stack space is available to
  runtime services which we call. If UEFI can call back into the kernel, it's
  not clear how much of the stack is available to either UEFI or the kernel.

  This is a rather fragile area -- kernel stack usage can vary wildly depending
  on configuration options.

* CPU state management. Runtime services can temporarily mask interrupts, and
  may require interrupts to remain masked over calls back into the kernel. That
  and other concerns mean that deadlock is going to be very difficult to avoid.

* It gets in the way of (though doesn't strictly prevent) sandboxing. One thing
  I'd like to do is run UEFI services in a more restricted environment (e.g. a
  VM if we have EL2 available), to aid robustness and debugging. Having a single
  entry/exit point, and not having to proxy calls would make this far simpler.

Overall, I'd far prefer that we have a strict one-way call policy (as is the
case today with UEFI), even if that means we have to make a number of calls to
achieve some functionality. In addition to the above, that also sidesteps the
lifetime issues I mentioned previously (modulo some FW-side state retained
across kexec and so on).

Thanks,
Mark.
