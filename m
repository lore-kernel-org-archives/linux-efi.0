From: "Jan Beulich" <JBeulich-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] efi/libstub/fdt: Standardize the names of EFI stub
 parameters
Date: Thu, 10 Sep 2015 09:06:32 -0600
Message-ID: <55F1B89802000078000A1C9B@prv-mh.provo.novell.com>
References: <1441874516-11364-1-git-send-email-zhaoshenglong@huawei.com>
 <20150910095208.GA29293@leverpostej>
 <alpine.DEB.2.02.1509101116580.2672@kaball.uk.xensource.com>
 <20150910112418.GC29293@leverpostej>
 <alpine.DEB.2.02.1509101223580.2672@kaball.uk.xensource.com>
 <55F199DD02000078000A1B1E@prv-mh.provo.novell.com>
 <20150910145331.GJ29293@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150910145331.GJ29293@leverpostej>
Content-Disposition: inline
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "Ian.Campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org" <Ian.Campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, "julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org" <julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>, "freebsd-arm-h+KGxgPPiopAfugRpC6u6w@public.gmane.org" <freebsd-arm-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, "peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org" <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, "daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

>>> On 10.09.15 at 16:53, <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> On Thu, Sep 10, 2015 at 01:55:25PM +0100, Jan Beulich wrote:
>> >>> On 10.09.15 at 13:37, <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org> wrote:
>> > On Thu, 10 Sep 2015, Mark Rutland wrote:
>> >> Why can't Xen give a virtual EFI interface to Dom0 / guests? e.g.
>> >> create pages of RuntimeServicesCode that are trivial assembly shims
>> >> doing hypercalls, and plumb these into the virtual EFI memory map and
>> >> tables?
>> >> 
>> >> That would keep things sane for any guest, allow for easy addition of
>> >> EFI features, and you could even enter the usual EFI entry point,
>> >> simulate ExitBootServices(), SetVirtualAddressMap(), and allow the guest
>> >> to make things sane for itself...
>> > 
>> > That's the way it was done on x86 and now we have common code both in
>> > Linux (drivers/xen/efi.c) and Xen (xen/common/efi) which implement this
>> > scheme.  Switching to a different solution for ARM, would mean diverging
>> > with x86, which is not nice, or reimplementing the x86 solution too,
>> > which is expensive.
>> > 
>> > BTW I think that the idea you proposed was actually considered at the
>> > time and deemed hard to implement, if I recall correctly.
>> 
>> Considering that the EFI support is just for Dom0, and Dom0 (at
>> the time) had to be PV anyway, it was the more natural solution to
>> expose the interface via hypercalls, the more that this allows better
>> control over what is and primarily what is not being exposed to
>> Dom0. With the wrapper approach we'd be back to the same
>> problem (discussed elsewhere) of which EFI version to surface: The
>> host one would impose potentially missing extensions, while the
>> most recent hypervisor known one might imply hiding valuable
>> information from Dom0. Plus there are incompatible changes like
>> the altered meaning of EFI_MEMORY_WP in 2.5.
> 
> I'm not sure I follow how hypercalls solve any impedance mismatch here;
> you're still expecting Dom0 to call up to Xen in order to perform calls,
> and all I suggested was a different location for those hypercalls.
> 
> If Xen is happy to make such calls blindly, why does it matter if the
> hypercall was in the kernel binary or an external shim?

Because there could be new entries in SystemTable->RuntimeServices
(expected and blindly but validly called by the kernel). Even worse
(because likely harder to deal with) would be new fields in other
structures.

> Incompatible changes are a spec problem regardless of how this is
> handled.

Not necessarily - we don't expose the memory map (we'd have to
if we were to mimic EFI for Dom0), and hence the mentioned issue
doesn't exist in our model.

Jan

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
