From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] efi/libstub/fdt: Standardize the names of EFI stub
 parameters
Date: Fri, 11 Sep 2015 17:25:59 +0100
Message-ID: <20150911162559.GA8726@leverpostej>
References: <20150910095208.GA29293@leverpostej>
 <alpine.DEB.2.02.1509101116580.2672@kaball.uk.xensource.com>
 <20150910112418.GC29293@leverpostej>
 <alpine.DEB.2.02.1509101223580.2672@kaball.uk.xensource.com>
 <20150910121514.GE29293@leverpostej>
 <alpine.DEB.2.02.1509101429480.2672@kaball.uk.xensource.com>
 <20150910144938.GI29293@leverpostej>
 <alpine.DEB.2.02.1509101655020.2672@kaball.uk.xensource.com>
 <20150910162302.GN29293@leverpostej>
 <20150911124643.GB4530@olila.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150911124643.GB4530-fJNZiO034lp9pOct4yEdx/3oZC3j2Omk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ian.Campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org" <Ian.Campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org" <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, "ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "freebsd-arm-h+KGxgPPiopAfugRpC6u6w@public.gmane.org" <freebsd-arm-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "jbeulich-IBi9RG/b67k@public.gmane.org" <jbeulich-IBi9RG/b67k@public.gmane.org>, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org" <julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, peter.huangpeng@huawei
List-Id: linux-efi@vger.kernel.org

On Fri, Sep 11, 2015 at 01:46:43PM +0100, Daniel Kiper wrote:
> On Thu, Sep 10, 2015 at 05:23:02PM +0100, Mark Rutland wrote:
> > > > C) When you could go:
> > > >
> > > >    DT -> Discover Xen -> Xen-specific stuff -> Xen-specific EFI/ACPI discovery
> > >
> > > I take you mean discovering Xen with the usual Xen hypervisor node on
> > > device tree. I think that C) is a good option actually. I like it. Not
> > > sure why we didn't think about this earlier. Is there anything EFI or
> > > ACPI which is needed before Xen support is discovered by
> > > arch/arm64/kernel/setup.c:setup_arch -> xen_early_init()?
> >
> > Currently lots (including the memory map). With the stuff to support
> > SPCR, the ACPI discovery would be moved before xen_early_init().
> >
> > > If not, we could just go for this. A lot of complexity would go away.
> >
> > I suspect this would still be fairly complex, but would at least prevent
> > the Xen-specific EFI handling from adversely affecting the native case.
> >
> > > > D) If you want to be generic:
> > > >    EFI -> EFI application -> EFI tables -> ACPI tables -> Xen-specific stuff
> > > >           \------------------------------------------/
> > > > 	   (virtualize these, provide shims to Dom0, but handle
> > > > 	    everything in Xen itself)
> > >
> > > I think that this is good in theory but could turn out to be a lot of
> > > work in practice. We could probably virtualize the RuntimeServices but
> > > the BootServices are troublesome.
> >
> > What's troublesome with the boot services?
> >
> > What can't be simulated?
> 
> How do you want to access bare metal EFI boot services from dom0 if they
> were shutdown long time ago before loading dom0 image?

I don't want to.

I asked "What can't be simulated?" because I assumed everything
necessary/mandatory could be simulated without needinng access to any
real EFI boot services.

As far as I can see all that's necessary is to provide a compatible
interface.

> What do you need from EFI boot services in dom0?

The ability to call ExitBootServices() and SetVirtualAddressMap() on a
_virtual_ address map for _virtual_ services provided by the hypervisor.
A console so that I can log things early on.

Mark.
