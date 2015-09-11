From: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Subject: Re: [PATCH] efi/libstub/fdt: Standardize the names of EFI stub
 parameters
Date: Fri, 11 Sep 2015 14:14:09 +0100
Message-ID: <alpine.DEB.2.02.1509111410180.2672@kaball.uk.xensource.com>
References: <1441874516-11364-1-git-send-email-zhaoshenglong@huawei.com>
 <20150910095208.GA29293@leverpostej>
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
Content-Type: text/plain; charset="US-ASCII"
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150911124643.GB4530-fJNZiO034lp9pOct4yEdx/3oZC3j2Omk@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ian.Campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org" <Ian.Campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org" <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, "julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org" <julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, "freebsd-arm-h+KGxgPPiopAfugRpC6u6w@public.gmane.org" <freebsd-arm-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <christoffer.dall@linaro.o>
List-Id: linux-efi@vger.kernel.org

On Fri, 11 Sep 2015, Daniel Kiper wrote:
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
> were shutdown long time ago before loading dom0 image? What do you need
> from EFI boot services in dom0?

That's right. Trying to emulate BootServices after the real
ExitBootServices has already been called seems like a very bad plan.

I think that whatever interface we come up with, would need to be past
ExitBootServices.
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
