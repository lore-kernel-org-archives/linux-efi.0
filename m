From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] efi/libstub/fdt: Standardize the names of EFI stub
 parameters
Date: Mon, 14 Sep 2015 10:25:19 +0100
Message-ID: <20150914092518.GA10307@leverpostej>
References: <20150910112418.GC29293@leverpostej>
 <alpine.DEB.2.02.1509101223580.2672@kaball.uk.xensource.com>
 <20150910121514.GE29293@leverpostej>
 <alpine.DEB.2.02.1509101429480.2672@kaball.uk.xensource.com>
 <20150910144938.GI29293@leverpostej>
 <alpine.DEB.2.02.1509101655020.2672@kaball.uk.xensource.com>
 <20150910162302.GN29293@leverpostej>
 <20150911124643.GB4530@olila.local.net-space.pl>
 <20150911162559.GA8726@leverpostej>
 <20150912113655.GG4530@olila.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150912113655.GG4530@olila.local.net-space.pl>
Sender: linux-doc-owner@vger.kernel.org
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Stefano Stabellini <stefano.stabellini@eu.citrix.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "freebsd-arm@freebsd.org" <freebsd-arm@freebsd.org>, "matt.fleming@intel.com" <matt.fleming@intel.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "jbeulich@suse.com" <jbeulich@suse.com>, Shannon Zhao <zhaoshenglong@huawei.com>, "julien.grall@citrix.com" <julien.grall@citrix.com>, peter.huangpeng@huawei
List-Id: linux-efi@vger.kernel.org

On Sat, Sep 12, 2015 at 12:36:55PM +0100, Daniel Kiper wrote:
> On Fri, Sep 11, 2015 at 05:25:59PM +0100, Mark Rutland wrote:
> > On Fri, Sep 11, 2015 at 01:46:43PM +0100, Daniel Kiper wrote:
> > > On Thu, Sep 10, 2015 at 05:23:02PM +0100, Mark Rutland wrote:
> 
> [...]
> 
> > > > What's troublesome with the boot services?
> > > >
> > > > What can't be simulated?
> > >
> > > How do you want to access bare metal EFI boot services from dom0 if they
> > > were shutdown long time ago before loading dom0 image?
> >
> > I don't want to.
> >
> > I asked "What can't be simulated?" because I assumed everything
> > necessary/mandatory could be simulated without needinng access to any
> > real EFI boot services.
> >
> > As far as I can see all that's necessary is to provide a compatible
> > interface.
> 
> Could you be more precise what do you need? Please enumerate. UEFI spec has
> more than 2500 pages and I do not think that we need all stuff in dom0.
> 
> > > What do you need from EFI boot services in dom0?
> >
> > The ability to call ExitBootServices() and SetVirtualAddressMap() on a
> > _virtual_ address map for _virtual_ services provided by the hypervisor.
> 
> I am confused. Why do you need that? Please remember, EFI is owned and
> operated by Xen hypervisor. dom0 does not have direct access to EFI.

Let's take a step back.

My objection here is to passing the Dom0 kernel properties as if it were
booted with direct access to a full UEFI, then later fixing that up
(when Xen is detected and we apply its hypercall EFI implementation).

If the kernel cannot use EFI natively, why pretend to the kernel that it
can? The hypercall implementation is _not_ EFI (though it provides
access to some services).

The two ways I can see providing Dom0 with EFI services are:

* Have Xen create shims for any services, in which any hypercalls live,
  and pass these to the kernel with a virtual system table. This keeps
  the interface to the kernel the same regardless of Xen.

* Have the kernel detect Xen EFI capability via Xen, without passing the
  usual native EFI parameters. This can then be installed into the
  kernel in a Xen-specific manner, and we know from the outset that
  Xen-specific caveats apply.

As per my original email, I'm not against the renaming of the stub
parameters if we standardise the rest of the details, but I believe
that's orthogonal to the Xen Dom0 case.

Thanks,
Mark.
