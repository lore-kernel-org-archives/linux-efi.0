From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi/libstub/fdt: Standardize the names of EFI stub
 parameters
Date: Thu, 10 Sep 2015 15:13:46 +0100
Message-ID: <20150910141346.GV10728@bivouac.eciton.net>
References: <1441874516-11364-1-git-send-email-zhaoshenglong@huawei.com>
 <20150910095208.GA29293@leverpostej>
 <alpine.DEB.2.02.1509101116580.2672@kaball.uk.xensource.com>
 <20150910112418.GC29293@leverpostej>
 <alpine.DEB.2.02.1509101223580.2672@kaball.uk.xensource.com>
 <20150910121514.GE29293@leverpostej>
 <alpine.DEB.2.02.1509101429480.2672@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1509101429480.2672-7Z66fg9igcxYtxbxJUhB2Dgeux46jI+i@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ian.Campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org" <Ian.Campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org" <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, "julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org" <julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, "freebsd-arm-h+KGxgPPiopAfugRpC6u6w@public.gmane.org" <freebsd-arm-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "jbeulich-IBi9RG/b67k@public.gmane.org" <jbeulich-IBi9RG/b67k@public.gmane.org>, "peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, sha
List-Id: linux-efi@vger.kernel.org

On Thu, Sep 10, 2015 at 02:52:25PM +0100, Stefano Stabellini wrote:
> > > In any case this should be separate from the shim ABI discussion.
> > 
> > I disagree; I think this is very much relevant to the ABI discussion.
> > That's not to say that I insist on a particular approach, but I think
> > that they need to be considered together.
> 
> Let's suppose Xen didn't expose any RuntimeServices at all, would that
> make it easier to discuss about the EFI stub parameters?

Possibly :)

> In the grant
> scheme of things, they are not that important, as Ian wrote what is
> important is how to pass the RSDP.

So, we have discussed in the past having the ability to get at
configuration tables when UEFI is not available. Say, for example,
that we wanted SMBIOS support on a platform with U-Boot firmware.

Since all that is needed then is a UEFI System Table with a pointer to
a configuration table array, this should be fairly straightforward to
implement statically. The other parameters would not be necessary.

It would however require minor changes to the arm64 kernel UEFI support.

/
    Leif
