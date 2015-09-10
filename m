From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] efi/libstub/fdt: Standardize the names of EFI stub
 parameters
Date: Thu, 10 Sep 2015 17:23:02 +0100
Message-ID: <20150910162302.GN29293@leverpostej>
References: <1441874516-11364-1-git-send-email-zhaoshenglong@huawei.com>
 <20150910095208.GA29293@leverpostej>
 <alpine.DEB.2.02.1509101116580.2672@kaball.uk.xensource.com>
 <20150910112418.GC29293@leverpostej>
 <alpine.DEB.2.02.1509101223580.2672@kaball.uk.xensource.com>
 <20150910121514.GE29293@leverpostej>
 <alpine.DEB.2.02.1509101429480.2672@kaball.uk.xensource.com>
 <20150910144938.GI29293@leverpostej>
 <alpine.DEB.2.02.1509101655020.2672@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1509101655020.2672@kaball.uk.xensource.com>
Sender: linux-doc-owner@vger.kernel.org
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Shannon Zhao <zhaoshenglong@huawei.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>, "julien.grall@citrix.com" <julien.grall@citrix.com>, "freebsd-arm@freebsd.org" <freebsd-arm@freebsd.org>, "matt.fleming@intel.com" <matt.fleming@intel.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "jbeulich@suse.com" <jbeulich@suse.com>, "peter.huangpeng@huawei.com" <peter.huangpeng@>
List-Id: linux-efi@vger.kernel.org

> > C) When you could go:
> > 
> >    DT -> Discover Xen -> Xen-specific stuff -> Xen-specific EFI/ACPI discovery
> 
> I take you mean discovering Xen with the usual Xen hypervisor node on
> device tree. I think that C) is a good option actually. I like it. Not
> sure why we didn't think about this earlier. Is there anything EFI or
> ACPI which is needed before Xen support is discovered by
> arch/arm64/kernel/setup.c:setup_arch -> xen_early_init()?

Currently lots (including the memory map). With the stuff to support
SPCR, the ACPI discovery would be moved before xen_early_init().

> If not, we could just go for this. A lot of complexity would go away.

I suspect this would still be fairly complex, but would at least prevent
the Xen-specific EFI handling from adversely affecting the native case.

> > D) If you want to be generic:
> >    EFI -> EFI application -> EFI tables -> ACPI tables -> Xen-specific stuff
> >           \------------------------------------------/
> > 	   (virtualize these, provide shims to Dom0, but handle
> > 	    everything in Xen itself)
> 
> I think that this is good in theory but could turn out to be a lot of
> work in practice. We could probably virtualize the RuntimeServices but
> the BootServices are troublesome.

What's troublesome with the boot services?

What can't be simulated?

> > E) Partially-generic option:
> >    EFI -> EFI application -> Xen detected by registered GUID -> Xen-specific EFI bootloader stuff -> OS in Xen-specific configuration
> > 
> > 
> > > > > In any case this should be separate from the shim ABI discussion.
> > > > 
> > > > I disagree; I think this is very much relevant to the ABI discussion.
> > > > That's not to say that I insist on a particular approach, but I think
> > > > that they need to be considered together.
> > > 
> > > Let's suppose Xen didn't expose any RuntimeServices at all, would that
> > > make it easier to discuss about the EFI stub parameters?
> > 
> > It would simply the protocol specific to Xen, certainly.
> > 
> > > In the grant scheme of things, they are not that important, as Ian
> > > wrote what is important is how to pass the RSDP.
> > 
> > Unfortunately we're still going to have to care about this eventually,
> > even if for something like kexec. So we still need to spec out the state
> > of things if this is going to be truly generic.
>  
> Fair enough. My position is that if we restrict this to RuntimeServices,
> it might be possible, but I still prefer C).

Regardless of what we do we still need a well-defined state here, which
brings us back to the initial problem eventually.

Thanks,
Mark.
