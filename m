From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] efi/libstub/fdt: Standardize the names of EFI stub
 parameters
Date: Thu, 10 Sep 2015 15:49:38 +0100
Message-ID: <20150910144938.GI29293@leverpostej>
References: <1441874516-11364-1-git-send-email-zhaoshenglong@huawei.com>
 <20150910095208.GA29293@leverpostej>
 <alpine.DEB.2.02.1509101116580.2672@kaball.uk.xensource.com>
 <20150910112418.GC29293@leverpostej>
 <alpine.DEB.2.02.1509101223580.2672@kaball.uk.xensource.com>
 <20150910121514.GE29293@leverpostej>
 <alpine.DEB.2.02.1509101429480.2672@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1509101429480.2672-7Z66fg9igcxYtxbxJUhB2Dgeux46jI+i@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Cc: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ian.Campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org" <Ian.Campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org" <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, "julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org" <julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, "freebsd-arm-h+KGxgPPiopAfugRpC6u6w@public.gmane.org" <freebsd-arm-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "jbeulich-IBi9RG/b67k@public.gmane.org" <jbeulich-IBi9RG/b67k@public.gmane.org>, "peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <peter.huangpeng@>
List-Id: linux-efi@vger.kernel.org

On Thu, Sep 10, 2015 at 02:52:25PM +0100, Stefano Stabellini wrote:
> On Thu, 10 Sep 2015, Mark Rutland wrote:
> > On Thu, Sep 10, 2015 at 12:37:57PM +0100, Stefano Stabellini wrote:
> > > On Thu, 10 Sep 2015, Mark Rutland wrote:
> > > > > > Does Xen not talk to EFI itself and/or give the kernel a virtual EFI
> > > > > > interface?
> > > > > 
> > > > > Xen talks to EFI itself but the interface provided to dom0 is somewhat
> > > > > different: there are no BootServices (Xen calls ExitBootServices before
> > > > > running the kernel), and the RuntimeServices go via hypercalls (see
> > > > > drivers/xen/efi.c).
> > > > 
> > > > That's somewhat hideous; a non Xen-aware OS wouild presumably die if
> > > > trying to use any runtime services the normal way? I'm not keen on
> > > > describing things that the OS cannot use.
> > >  
> > > I agree that is somewhat hideous, but a non-Xen aware OS traditionally
> > > has never been able to even boot as Dom0. On ARM it can, but it still
> > > wouldn't be very useful (one couldn't use it to start other guests).
> > 
> > Sure, but it feels odd to provide the usual information in this manner
> > if it cannot be used. If you require Xen-specific code to make things
> > work, I would imagine this information could be dciscovered in a
> > Xen-specific manner.
> 
> We need ACPI (or Device Tree) to find that Xen is available on the
> platform, so we cannot use Xen-specific code to get the ACPI tables.

I don't understand. The proposition already involves passing a custom DT
to the OS, implying that Xen knows how to boot that OS, and how to pass
it a DTB.

Consider:

A) In the DT-only case, we go:

   DT -> Discover Xen -> Xen-specific stuff


B) The proposition is that un the ACPI case we go:

   DT -> EFI tables -> ACPI tables -> Discover Xen -> Xen-specific stuff -> override EFI/ACPI stuff
         \-----------------------/
          (be really cautious here)


C) When you could go:

   DT -> Discover Xen -> Xen-specific stuff -> Xen-specific EFI/ACPI discovery


D) If you want to be generic:
   EFI -> EFI application -> EFI tables -> ACPI tables -> Xen-specific stuff
          \------------------------------------------/
	   (virtualize these, provide shims to Dom0, but handle
	    everything in Xen itself)


E) Partially-generic option:
   EFI -> EFI application -> Xen detected by registered GUID -> Xen-specific EFI bootloader stuff -> OS in Xen-specific configuration


> > > In any case this should be separate from the shim ABI discussion.
> > 
> > I disagree; I think this is very much relevant to the ABI discussion.
> > That's not to say that I insist on a particular approach, but I think
> > that they need to be considered together.
> 
> Let's suppose Xen didn't expose any RuntimeServices at all, would that
> make it easier to discuss about the EFI stub parameters?

It would simply the protocol specific to Xen, certainly.

> In the grant scheme of things, they are not that important, as Ian
> wrote what is important is how to pass the RSDP.

Unfortunately we're still going to have to care about this eventually,
even if for something like kexec. So we still need to spec out the state
of things if this is going to be truly generic.

Thanks,
Mark.
