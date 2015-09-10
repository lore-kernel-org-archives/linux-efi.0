From: "Jan Beulich" <JBeulich@suse.com>
Subject: Re: [PATCH] efi/libstub/fdt: Standardize the names of EFI stub
 parameters
Date: Thu, 10 Sep 2015 06:55:25 -0600
Message-ID: <55F199DD02000078000A1B1E@prv-mh.provo.novell.com>
References: <1441874516-11364-1-git-send-email-zhaoshenglong@huawei.com>
 <20150910095208.GA29293@leverpostej>
 <alpine.DEB.2.02.1509101116580.2672@kaball.uk.xensource.com>
 <20150910112418.GC29293@leverpostej>
 <alpine.DEB.2.02.1509101223580.2672@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1509101223580.2672@kaball.uk.xensource.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>, Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>, "julien.grall@citrix.com" <julien.grall@citrix.com>, "freebsd-arm@freebsd.org" <freebsd-arm@freebsd.org>, "peter.huangpeng@huawei.com" <peter.huangpeng@huawei.com>, Shannon Zhao <zhaoshenglong@huawei.com>, "matt.fleming@intel.com" <matt.fleming@intel.com>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "shannon.zhao@linaro.org" <shannon.zhao@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>, daniel.kiper@oracle.com, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, linux-efi@vger
List-Id: linux-efi@vger.kernel.org

>>> On 10.09.15 at 13:37, <stefano.stabellini@eu.citrix.com> wrote:
> On Thu, 10 Sep 2015, Mark Rutland wrote:
>> Why can't Xen give a virtual EFI interface to Dom0 / guests? e.g.
>> create pages of RuntimeServicesCode that are trivial assembly shims
>> doing hypercalls, and plumb these into the virtual EFI memory map and
>> tables?
>> 
>> That would keep things sane for any guest, allow for easy addition of
>> EFI features, and you could even enter the usual EFI entry point,
>> simulate ExitBootServices(), SetVirtualAddressMap(), and allow the guest
>> to make things sane for itself...
> 
> That's the way it was done on x86 and now we have common code both in
> Linux (drivers/xen/efi.c) and Xen (xen/common/efi) which implement this
> scheme.  Switching to a different solution for ARM, would mean diverging
> with x86, which is not nice, or reimplementing the x86 solution too,
> which is expensive.
> 
> BTW I think that the idea you proposed was actually considered at the
> time and deemed hard to implement, if I recall correctly.

Considering that the EFI support is just for Dom0, and Dom0 (at
the time) had to be PV anyway, it was the more natural solution to
expose the interface via hypercalls, the more that this allows better
control over what is and primarily what is not being exposed to
Dom0. With the wrapper approach we'd be back to the same
problem (discussed elsewhere) of which EFI version to surface: The
host one would impose potentially missing extensions, while the
most recent hypervisor known one might imply hiding valuable
information from Dom0. Plus there are incompatible changes like
the altered meaning of EFI_MEMORY_WP in 2.5.

Jan
