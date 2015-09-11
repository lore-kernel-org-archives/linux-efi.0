From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] efi/libstub/fdt: Standardize the names of EFI stub
 parameters
Date: Fri, 11 Sep 2015 17:36:05 +0100
Message-ID: <20150911163605.GC8726@leverpostej>
References: <1441874516-11364-1-git-send-email-zhaoshenglong@huawei.com>
 <20150910095208.GA29293@leverpostej>
 <alpine.DEB.2.02.1509101116580.2672@kaball.uk.xensource.com>
 <20150910112418.GC29293@leverpostej>
 <alpine.DEB.2.02.1509101223580.2672@kaball.uk.xensource.com>
 <55F199DD02000078000A1B1E@prv-mh.provo.novell.com>
 <20150910145331.GJ29293@leverpostej>
 <55F1B89802000078000A1C9B@prv-mh.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55F1B89802000078000A1C9B-rw/UEucdPrvD8XXLLHKrIiOjQekVJEpY@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Cc: "Ian.Campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org" <Ian.Campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, "julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org" <julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>, "freebsd-arm-h+KGxgPPiopAfugRpC6u6w@public.gmane.org" <freebsd-arm-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, "peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org" <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, "daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TaqPxH82wqD4g@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> >> Considering that the EFI support is just for Dom0, and Dom0 (at
> >> the time) had to be PV anyway, it was the more natural solution to
> >> expose the interface via hypercalls, the more that this allows better
> >> control over what is and primarily what is not being exposed to
> >> Dom0. With the wrapper approach we'd be back to the same
> >> problem (discussed elsewhere) of which EFI version to surface: The
> >> host one would impose potentially missing extensions, while the
> >> most recent hypervisor known one might imply hiding valuable
> >> information from Dom0. Plus there are incompatible changes like
> >> the altered meaning of EFI_MEMORY_WP in 2.5.
> > 
> > I'm not sure I follow how hypercalls solve any impedance mismatch here;
> > you're still expecting Dom0 to call up to Xen in order to perform calls,
> > and all I suggested was a different location for those hypercalls.
> > 
> > If Xen is happy to make such calls blindly, why does it matter if the
> > hypercall was in the kernel binary or an external shim?
> 
> Because there could be new entries in SystemTable->RuntimeServices
> (expected and blindly but validly called by the kernel). Even worse
> (because likely harder to deal with) would be new fields in other
> structures.

Any of these could cause Xen to blow up, while Xen could always provide
a known-safe (but potentially sub-optimal) view to the kernel by
default.

> > Incompatible changes are a spec problem regardless of how this is
> > handled.
> 
> Not necessarily - we don't expose the memory map (we'd have to
> if we were to mimic EFI for Dom0), and hence the mentioned issue
> doesn't exist in our model.

We have to expose _some_ memory map, so I don't follow this point.

Mark.
