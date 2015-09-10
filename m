From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] efi/libstub/fdt: Standardize the names of
 EFI stub parameters
Date: Thu, 10 Sep 2015 15:53:31 +0100
Message-ID: <20150910145331.GJ29293@leverpostej>
References: <1441874516-11364-1-git-send-email-zhaoshenglong@huawei.com>
	<20150910095208.GA29293@leverpostej>
	<alpine.DEB.2.02.1509101116580.2672@kaball.uk.xensource.com>
	<20150910112418.GC29293@leverpostej>
	<alpine.DEB.2.02.1509101223580.2672@kaball.uk.xensource.com>
	<55F199DD02000078000A1B1E@prv-mh.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
Content-Disposition: inline
In-Reply-To: <55F199DD02000078000A1B1E@prv-mh.provo.novell.com>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: Jan Beulich <JBeulich@suse.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "matt.fleming@intel.com" <matt.fleming@intel.com>, "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "daniel.kiper@oracle.com" <daniel.kiper@oracle.com>, Stefano Stabellini <stefano.stabellini@eu.citrix.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "peter.huangpeng@huawei.com" <peter.huangpeng@huawei.com>, "julien.grall@citrix.com" <julien.grall@citrix.com>, "freebsd-arm@freebsd.org" <freebsd-arm@freebsd.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "shannon.zhao@linaro.org" <shannon.zhao@linaro.org>, Shannon Zhao <zhaoshenglong@huawei.com>
List-Id: linux-efi@vger.kernel.org

On Thu, Sep 10, 2015 at 01:55:25PM +0100, Jan Beulich wrote:
> >>> On 10.09.15 at 13:37, <stefano.stabellini@eu.citrix.com> wrote:
> > On Thu, 10 Sep 2015, Mark Rutland wrote:
> >> Why can't Xen give a virtual EFI interface to Dom0 / guests? e.g.
> >> create pages of RuntimeServicesCode that are trivial assembly shims
> >> doing hypercalls, and plumb these into the virtual EFI memory map and
> >> tables?
> >> 
> >> That would keep things sane for any guest, allow for easy addition of
> >> EFI features, and you could even enter the usual EFI entry point,
> >> simulate ExitBootServices(), SetVirtualAddressMap(), and allow the guest
> >> to make things sane for itself...
> > 
> > That's the way it was done on x86 and now we have common code both in
> > Linux (drivers/xen/efi.c) and Xen (xen/common/efi) which implement this
> > scheme.  Switching to a different solution for ARM, would mean diverging
> > with x86, which is not nice, or reimplementing the x86 solution too,
> > which is expensive.
> > 
> > BTW I think that the idea you proposed was actually considered at the
> > time and deemed hard to implement, if I recall correctly.
> 
> Considering that the EFI support is just for Dom0, and Dom0 (at
> the time) had to be PV anyway, it was the more natural solution to
> expose the interface via hypercalls, the more that this allows better
> control over what is and primarily what is not being exposed to
> Dom0. With the wrapper approach we'd be back to the same
> problem (discussed elsewhere) of which EFI version to surface: The
> host one would impose potentially missing extensions, while the
> most recent hypervisor known one might imply hiding valuable
> information from Dom0. Plus there are incompatible changes like
> the altered meaning of EFI_MEMORY_WP in 2.5.

I'm not sure I follow how hypercalls solve any impedance mismatch here;
you're still expecting Dom0 to call up to Xen in order to perform calls,
and all I suggested was a different location for those hypercalls.

If Xen is happy to make such calls blindly, why does it matter if the
hypercall was in the kernel binary or an external shim?

Incompatible changes are a spec problem regardless of how this is
handled.

Thanks,
Mark.
