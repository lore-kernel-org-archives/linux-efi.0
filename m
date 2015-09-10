From: Ian Campbell <ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH] efi/libstub/fdt: Standardize the names of
 EFI stub parameters
Date: Thu, 10 Sep 2015 13:58:25 +0100
Message-ID: <1441889905.24450.382.camel@citrix.com>
References: <1441874516-11364-1-git-send-email-zhaoshenglong@huawei.com>
	 <20150910095208.GA29293@leverpostej>
	 <alpine.DEB.2.02.1509101116580.2672@kaball.uk.xensource.com>
	 <20150910112418.GC29293@leverpostej>
	 <alpine.DEB.2.02.1509101223580.2672@kaball.uk.xensource.com>
	 <20150910121514.GE29293@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150910121514.GE29293@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Cc: "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org" <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, "julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org" <julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, "freebsd-arm-h+KGxgPPiopAfugRpC6u6w@public.gmane.org" <freebsd-arm-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "jbeulich-IBi9RG/b67k@public.gmane.org" <jbeulich-IBi9RG/b67k@public.gmane.org>, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWMP3drIcvDWNA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2015-09-10 at 13:15 +0100, Mark Rutland wrote:

> > In any case this should be separate from the shim ABI discussion.
> 
> I disagree; I think this is very much relevant to the ABI discussion.
> That's not to say that I insist on a particular approach, but I think
> that they need to be considered together.

Taking a step back, the reason for using the EFI stub parameters is only
(AFAIK) in order to be able to locate the ACPI RDSP (the root table
pointer), which as it happens is normally passed via one of the EFI
firmware tables.

If there was a way to achieve that goal (i.e. another way to find the RSDP)
without opening the can of UEFI worms then we could consider that opiton
too.

a way != the legacy x86 thing of scanning low memory of the signature, of
course.

Ian.
