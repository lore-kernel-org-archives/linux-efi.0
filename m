From: Daniel Kiper <daniel.kiper@oracle.com>
Subject: Re: [PATCH] efi/libstub/fdt: Standardize the names of EFI stub
 parameters
Date: Sat, 12 Sep 2015 13:36:55 +0200
Message-ID: <20150912113655.GG4530@olila.local.net-space.pl>
References: <alpine.DEB.2.02.1509101116580.2672@kaball.uk.xensource.com>
 <20150910112418.GC29293@leverpostej>
 <alpine.DEB.2.02.1509101223580.2672@kaball.uk.xensource.com>
 <20150910121514.GE29293@leverpostej>
 <alpine.DEB.2.02.1509101429480.2672@kaball.uk.xensource.com>
 <20150910144938.GI29293@leverpostej>
 <alpine.DEB.2.02.1509101655020.2672@kaball.uk.xensource.com>
 <20150910162302.GN29293@leverpostej>
 <20150911124643.GB4530@olila.local.net-space.pl>
 <20150911162559.GA8726@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150911162559.GA8726@leverpostej>
Sender: linux-doc-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Stefano Stabellini <stefano.stabellini@eu.citrix.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "freebsd-arm@freebsd.org" <freebsd-arm@freebsd.org>, "matt.fleming@intel.com" <matt.fleming@intel.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "jbeulich@suse.com" <jbeulich@suse.com>, Shannon Zhao <zhaoshenglong@huawei.com>, "julien.grall@citrix.com" <julien.grall@citrix.com>, peter.huangpeng@huawei
List-Id: linux-efi@vger.kernel.org

On Fri, Sep 11, 2015 at 05:25:59PM +0100, Mark Rutland wrote:
> On Fri, Sep 11, 2015 at 01:46:43PM +0100, Daniel Kiper wrote:
> > On Thu, Sep 10, 2015 at 05:23:02PM +0100, Mark Rutland wrote:

[...]

> > > What's troublesome with the boot services?
> > >
> > > What can't be simulated?
> >
> > How do you want to access bare metal EFI boot services from dom0 if they
> > were shutdown long time ago before loading dom0 image?
>
> I don't want to.
>
> I asked "What can't be simulated?" because I assumed everything
> necessary/mandatory could be simulated without needinng access to any
> real EFI boot services.
>
> As far as I can see all that's necessary is to provide a compatible
> interface.

Could you be more precise what do you need? Please enumerate. UEFI spec has
more than 2500 pages and I do not think that we need all stuff in dom0.

> > What do you need from EFI boot services in dom0?
>
> The ability to call ExitBootServices() and SetVirtualAddressMap() on a
> _virtual_ address map for _virtual_ services provided by the hypervisor.

I am confused. Why do you need that? Please remember, EFI is owned and
operated by Xen hypervisor. dom0 does not have direct access to EFI.
All stuff required in dom0 is provided via hypercalls. If you need an
extra data form EFI in dom0 please extend currently exiting API. Do
not emulate whole EFI if you need one or a few things from spec.

> A console so that I can log things early on.

IIUC, log from dom0. Please use machinery provided by Xen hypervisor.

Daniel
