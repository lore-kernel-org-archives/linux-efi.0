From: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Subject: Re: [PATCH] efi/libstub/fdt: Standardize the names of EFI stub
 parameters
Date: Thu, 10 Sep 2015 14:52:25 +0100
Message-ID: <alpine.DEB.2.02.1509101429480.2672@kaball.uk.xensource.com>
References: <1441874516-11364-1-git-send-email-zhaoshenglong@huawei.com>
 <20150910095208.GA29293@leverpostej>
 <alpine.DEB.2.02.1509101116580.2672@kaball.uk.xensource.com>
 <20150910112418.GC29293@leverpostej>
 <alpine.DEB.2.02.1509101223580.2672@kaball.uk.xensource.com>
 <20150910121514.GE29293@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150910121514.GE29293@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ian.Campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org" <Ian.Campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org" <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, "julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org" <julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, "freebsd-arm-h+KGxgPPiopAfugRpC6u6w@public.gmane.org" <freebsd-arm-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "jbeulich-IBi9RG/b67k@public.gmane.org" <jbeulich@su>
List-Id: linux-efi@vger.kernel.org

On Thu, 10 Sep 2015, Mark Rutland wrote:
> On Thu, Sep 10, 2015 at 12:37:57PM +0100, Stefano Stabellini wrote:
> > On Thu, 10 Sep 2015, Mark Rutland wrote:
> > > > > Does Xen not talk to EFI itself and/or give the kernel a virtual EFI
> > > > > interface?
> > > > 
> > > > Xen talks to EFI itself but the interface provided to dom0 is somewhat
> > > > different: there are no BootServices (Xen calls ExitBootServices before
> > > > running the kernel), and the RuntimeServices go via hypercalls (see
> > > > drivers/xen/efi.c).
> > > 
> > > That's somewhat hideous; a non Xen-aware OS wouild presumably die if
> > > trying to use any runtime services the normal way? I'm not keen on
> > > describing things that the OS cannot use.
> >  
> > I agree that is somewhat hideous, but a non-Xen aware OS traditionally
> > has never been able to even boot as Dom0. On ARM it can, but it still
> > wouldn't be very useful (one couldn't use it to start other guests).
> 
> Sure, but it feels odd to provide the usual information in this manner
> if it cannot be used. If you require Xen-specific code to make things
> work, I would imagine this information could be dciscovered in a
> Xen-specific manner.

We need ACPI (or Device Tree) to find that Xen is available on the
platform, so we cannot use Xen-specific code to get the ACPI tables.


> > > Why can't Xen give a virtual EFI interface to Dom0 / guests? e.g.
> > > create pages of RuntimeServicesCode that are trivial assembly shims
> > > doing hypercalls, and plumb these into the virtual EFI memory map and
> > > tables?
> > > 
> > > That would keep things sane for any guest, allow for easy addition of
> > > EFI features, and you could even enter the usual EFI entry point,
> > > simulate ExitBootServices(), SetVirtualAddressMap(), and allow the guest
> > > to make things sane for itself...
> > 
> > That's the way it was done on x86 and now we have common code both in
> > Linux (drivers/xen/efi.c) and Xen (xen/common/efi) which implement this
> > scheme.
> 
> This code is not currently used on arm. It might live in a location
> where it may be shared, but that doesn't mean that it's common code yet.

Yeah, but that was clearly the intention.


> > Switching to a different solution for ARM, would mean diverging
> > with x86, which is not nice, or reimplementing the x86 solution too,
> > which is expensive.
> > 
> > BTW I think that the idea you proposed was actually considered at the
> > time and deemed hard to implement, if I recall correctly.
> 
> I appreciate that divergence is painful. We already diverge in other
> respects (e.g. lack of PV page tables) because things that used to be
> the case on x86 never applied to ARM.
> 
> It would be interesting to see why that was the case for x86, and
> whether that applies to ARM.

I have been a big advocate of doing things differently, and more
cleanly, on ARM, but in this case the code is already non-arch specific.
We are not talking about pagetables, which of course cannot be reused
as-is even if we wanted to.

For once, I think we should follow the x86 way, for convenience and for
the reasons brought up by Jan.


> > In any case this should be separate from the shim ABI discussion.
> 
> I disagree; I think this is very much relevant to the ABI discussion.
> That's not to say that I insist on a particular approach, but I think
> that they need to be considered together.

Let's suppose Xen didn't expose any RuntimeServices at all, would that
make it easier to discuss about the EFI stub parameters?  In the grant
scheme of things, they are not that important, as Ian wrote what is
important is how to pass the RSDP.
