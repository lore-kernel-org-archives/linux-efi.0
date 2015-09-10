From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH] efi/libstub/fdt: Standardize the names of EFI stub
 parameters
Date: Thu, 10 Sep 2015 17:10:33 +0100
Message-ID: <alpine.DEB.2.02.1509101655020.2672@kaball.uk.xensource.com>
References: <1441874516-11364-1-git-send-email-zhaoshenglong@huawei.com>
 <20150910095208.GA29293@leverpostej>
 <alpine.DEB.2.02.1509101116580.2672@kaball.uk.xensource.com>
 <20150910112418.GC29293@leverpostej>
 <alpine.DEB.2.02.1509101223580.2672@kaball.uk.xensource.com>
 <20150910121514.GE29293@leverpostej>
 <alpine.DEB.2.02.1509101429480.2672@kaball.uk.xensource.com>
 <20150910144938.GI29293@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150910144938.GI29293@leverpostej>
Sender: linux-doc-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>, Shannon Zhao <zhaoshenglong@huawei.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>, "julien.grall@citrix.com" <julien.grall@citrix.com>, "freebsd-arm@freebsd.org" <freebsd-arm@freebsd.org>, "matt.fleming@intel.com" <matt.fleming@intel.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "jbeulich@suse.com" <jbeulich@su>
List-Id: linux-efi@vger.kernel.org

On Thu, 10 Sep 2015, Mark Rutland wrote:
> On Thu, Sep 10, 2015 at 02:52:25PM +0100, Stefano Stabellini wrote:
> > On Thu, 10 Sep 2015, Mark Rutland wrote:
> > > On Thu, Sep 10, 2015 at 12:37:57PM +0100, Stefano Stabellini wrote:
> > > > On Thu, 10 Sep 2015, Mark Rutland wrote:
> > > > > > > Does Xen not talk to EFI itself and/or give the kernel a virtual EFI
> > > > > > > interface?
> > > > > > 
> > > > > > Xen talks to EFI itself but the interface provided to dom0 is somewhat
> > > > > > different: there are no BootServices (Xen calls ExitBootServices before
> > > > > > running the kernel), and the RuntimeServices go via hypercalls (see
> > > > > > drivers/xen/efi.c).
> > > > > 
> > > > > That's somewhat hideous; a non Xen-aware OS wouild presumably die if
> > > > > trying to use any runtime services the normal way? I'm not keen on
> > > > > describing things that the OS cannot use.
> > > >  
> > > > I agree that is somewhat hideous, but a non-Xen aware OS traditionally
> > > > has never been able to even boot as Dom0. On ARM it can, but it still
> > > > wouldn't be very useful (one couldn't use it to start other guests).
> > > 
> > > Sure, but it feels odd to provide the usual information in this manner
> > > if it cannot be used. If you require Xen-specific code to make things
> > > work, I would imagine this information could be dciscovered in a
> > > Xen-specific manner.
> > 
> > We need ACPI (or Device Tree) to find that Xen is available on the
> > platform, so we cannot use Xen-specific code to get the ACPI tables.
> 
> I don't understand. The proposition already involves passing a custom DT
> to the OS, implying that Xen knows how to boot that OS, and how to pass
> it a DTB.
> 
> Consider:
> 
> A) In the DT-only case, we go:
> 
>    DT -> Discover Xen -> Xen-specific stuff
> 
> 
> B) The proposition is that un the ACPI case we go:
> 
>    DT -> EFI tables -> ACPI tables -> Discover Xen -> Xen-specific stuff -> override EFI/ACPI stuff
>          \-----------------------/
>           (be really cautious here)

Well, yes. To be pedantic "override" here would just be the different
delivery method for RuntimeServices. I guess it still counts.


> C) When you could go:
> 
>    DT -> Discover Xen -> Xen-specific stuff -> Xen-specific EFI/ACPI discovery

I take you mean discovering Xen with the usual Xen hypervisor node on
device tree. I think that C) is a good option actually. I like it. Not
sure why we didn't think about this earlier. Is there anything EFI or
ACPI which is needed before Xen support is discovered by
arch/arm64/kernel/setup.c:setup_arch -> xen_early_init()?

If not, we could just go for this. A lot of complexity would go away.


> D) If you want to be generic:
>    EFI -> EFI application -> EFI tables -> ACPI tables -> Xen-specific stuff
>           \------------------------------------------/
> 	   (virtualize these, provide shims to Dom0, but handle
> 	    everything in Xen itself)

I think that this is good in theory but could turn out to be a lot of
work in practice. We could probably virtualize the RuntimeServices but
the BootServices are troublesome.


> 
> E) Partially-generic option:
>    EFI -> EFI application -> Xen detected by registered GUID -> Xen-specific EFI bootloader stuff -> OS in Xen-specific configuration
> 
> 
> > > > In any case this should be separate from the shim ABI discussion.
> > > 
> > > I disagree; I think this is very much relevant to the ABI discussion.
> > > That's not to say that I insist on a particular approach, but I think
> > > that they need to be considered together.
> > 
> > Let's suppose Xen didn't expose any RuntimeServices at all, would that
> > make it easier to discuss about the EFI stub parameters?
> 
> It would simply the protocol specific to Xen, certainly.
> 
> > In the grant scheme of things, they are not that important, as Ian
> > wrote what is important is how to pass the RSDP.
> 
> Unfortunately we're still going to have to care about this eventually,
> even if for something like kexec. So we still need to spec out the state
> of things if this is going to be truly generic.
 
Fair enough. My position is that if we restrict this to RuntimeServices,
it might be possible, but I still prefer C).
