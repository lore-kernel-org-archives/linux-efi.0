From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 12/16] ARM: Xen: Document UEFI support on Xen ARM
 virtual platforms
Date: Tue, 19 Jan 2016 13:13:49 +0000
Message-ID: <20160119131348.GJ25024@leverpostej>
References: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com>
 <1452840929-19612-13-git-send-email-zhaoshenglong@huawei.com>
 <20160118105115.GD21067@leverpostej>
 <alpine.DEB.2.02.1601181710270.9400@kaball.uk.xensource.com>
 <569E0F15.8090001@huawei.com>
 <20160119104747.GB25024@leverpostej>
 <alpine.DEB.2.02.1601191217190.9400@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1601191217190.9400@kaball.uk.xensource.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>, ard.biesheuvel@linaro.org, leif.lindholm@linaro.org
Cc: Shannon Zhao <zhaoshenglong@huawei.com>, linux-arm-kernel@lists.infradead.org, stefano.stabellini@citrix.com, david.vrabel@citrix.com, catalin.marinas@arm.com, will.deacon@arm.com, julien.grall@citrix.com, xen-devel@lists.xen.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, Jan Beulich <JBeulich@novell.com>, Ian Campbell <Ian.Campbell@citrix.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Jan 19, 2016 at 12:23:17PM +0000, Stefano Stabellini wrote:
> On Tue, 19 Jan 2016, Mark Rutland wrote:
> > On Tue, Jan 19, 2016 at 06:25:25PM +0800, Shannon Zhao wrote:
> > > >> We don't do this in Documentation/arm/uefi.txt, and I don't see why we
> > > >> should do so here.
> > > >>
> > > >> Does Xen handle arbitrary size memory map descriptors? I'm not sure what
> > > >> new information might be passed in future additions to the descriptor
> > > >> format, and I'm not sure what should happen in the Dom0 case.
> > > > 
> > > > Xen passes to Dom0 the memory map in the same format as the native
> > > > memory map.
> > 
> > Does Xen parse or modify the EFI memory map in any way?
> 
> Xen:
> - calls EFI_BOOT_SERVICES.GetMemoryMap()
> - takes note of the memory regions for its own usage
> - create the fdt notes, including efi-mmap-start, with a pointer to it
> 
> 
> > Does it pass the raw values returned by EFI_BOOT_SERVICES.GetMemoryMap()
> > through to the xen,uefi-* properties, or does is make any static
> > assumptions about what the values will be?
> 
> It just passes the raw values.

I take it that means that any memory carved out for Xen itself is
described/discovered via a separate mechanism? How does that work?

> > I'm trying to get a feeling for what the behaviour will be if/when a
> > version of the EFI spec expands the memory map format.
> 
> Linux is likely to get the memory map in the same format as it's
> provided on native.

Ok.

The only fragility I forsee there would be if some extended memory
descriptor format defined things the kernel understood but Xen did not.

Given that would require an update to the kernel, at that point code is
added for that we can figure out how to determine whether Xen handled
any of said information, and whether any further negotiation with Xen is
necessary. I assume Xen exposes some feature probing mechanism to guests
that can cater for that if necessary.

Ard, Leif, I trust you two can keep an eye out for anything of that
sort on the UEFI side. :)

Thanks,
Mark.
