From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] efi/libstub/fdt: Standardize the names of EFI stub
 parameters
Date: Fri, 11 Sep 2015 17:33:32 +0100
Message-ID: <20150911163332.GB8726@leverpostej>
References: <20150910112418.GC29293@leverpostej>
 <alpine.DEB.2.02.1509101223580.2672@kaball.uk.xensource.com>
 <20150910121514.GE29293@leverpostej>
 <alpine.DEB.2.02.1509101429480.2672@kaball.uk.xensource.com>
 <20150910144938.GI29293@leverpostej>
 <alpine.DEB.2.02.1509101655020.2672@kaball.uk.xensource.com>
 <20150910162302.GN29293@leverpostej>
 <20150911124643.GB4530@olila.local.net-space.pl>
 <alpine.DEB.2.02.1509111410180.2672@kaball.uk.xensource.com>
 <CAKv+Gu9rN7_mxk0huX+34HSCC_aTWVTkUZKQMB1+9U56fRnwsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9rN7_mxk0huX+34HSCC_aTWVTkUZKQMB1+9U56fRnwsA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>, Daniel Kiper <daniel.kiper@oracle.com>, Shannon Zhao <zhaoshenglong@huawei.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>, "julien.grall@citrix.com" <julien.grall@citrix.com>, "freebsd-arm@freebsd.org" <freebsd-arm@freebsd.org>, "matt.fleming@intel.com" <matt.fleming@intel.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "jbeulich@suse.com" <jbeulich@suse.com>, peter.
List-Id: linux-efi@vger.kernel.org

> It feels like this discussion is going in circles.
> 
> When we discussed this six months ago, we already concluded that,
> since UEFI is the only specified way that the presence of ACPI is
> advertised on an ARM system, we need to emulate UEFI to some extent.

My understanding from the last time I was present at such a discussion
was that the emulation was complete from the kernel's PoV (i.e. no
special case handling was required). 

Evidently I misunderstood.

One of the main points of rationale for requiring EFI was that we'd have
a well-defined system state as per the EFI (and ACPI) standards. We'd
know we had the EFI memory map, services, etc (with the memory map and
configuration tables being the most important elements). We didn't want
to have to try to reconcile a DT memory map and ACPI, for instance.

That is somewhat (though admitedly not entirely) broken if we require a
set of rules to be applied beyond what the standards mandate.  That is
broken if we require a non-standard set of rules to be applied, and
limits what we can do in the !Xen case.

> So we need the EFI system table to expose the UEFI configuration table
> that carries the ACPI root pointer.
> 
> Since ACPI support also relies on the UEFI memory map (I think?), we
> need that as well.
> 
> These two items are exactly what we pass via the UEFI DT properties,
> so we should indeed promote the current de-facto binding to a proper
> binding, and renaming the properties makes sense in that context.

I agree that we need to sort these out.

> I agree that this should also include a description of the expected
> state of the firmware, i.e., that ExitBootServices() has been called,
> and that the memory map has been populated with virtual address, which
> have been installed using SetVirtualAddressMap() if they differ from
> the physical addresses. (The current implementation on the kernel side
> is perfectly capable of dealing with a 1:1 mapping).
> 
> Beyond that, there is no point in pretending to be a full UEFI
> implementation, imo. Boot services are not required, nor are runtime
> services (only the current EFI init code on arm needs to be modified
> to deal with a NULL runtime services pointer)

I'm not keen on this because it involves applying Xen-specific caveats
atop of what the UEFI spec says (e.g. as runtime services might be NULL
under Xen). As the spec and Xen evolve, those caveats shift, and that's
going to be fragile for all users regardleses of Xen.

If Xen needs special-casing, then I'd rather that Xen were detected
first and provided us with what it knows is safe for us to use, rather
than we tip-toe around until we're sure Xen isn't present and/or doesn't
need additional constraints met.

Thanks,
Mark.
