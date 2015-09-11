From: Ian Campbell <ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] efi/libstub/fdt: Standardize the names of EFI stub
 parameters
Date: Fri, 11 Sep 2015 12:00:00 +0100
Message-ID: <1441969200.3549.23.camel@citrix.com>
References: <1441874516-11364-1-git-send-email-zhaoshenglong@huawei.com>
	 <20150910095208.GA29293@leverpostej>
	 <alpine.DEB.2.02.1509101116580.2672@kaball.uk.xensource.com>
	 <20150910112418.GC29293@leverpostej>
	 <alpine.DEB.2.02.1509101223580.2672@kaball.uk.xensource.com>
	 <20150910121514.GE29293@leverpostej>
	 <alpine.DEB.2.02.1509101429480.2672@kaball.uk.xensource.com>
	 <20150910144938.GI29293@leverpostej>
	 <alpine.DEB.2.02.1509101655020.2672@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1509101655020.2672-7Z66fg9igcxYtxbxJUhB2Dgeux46jI+i@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org" <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, "julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org" <julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, "freebsd-arm-h+KGxgPPiopAfugRpC6u6w@public.gmane.org" <freebsd-arm-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "jbeulich-IBi9RG/b67k@public.gmane.org" <jbeulich-IBi9RG/b67k@public.gmane.org>, "peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <shannon.zhao@>
List-Id: linux-efi@vger.kernel.org

On Thu, 2015-09-10 at 17:10 +0100, Stefano Stabellini wrote:

> > C) When you could go:
> > 
> >    DT -> Discover Xen -> Xen-specific stuff -> Xen-specific EFI/ACPI
> > discovery
> 
> I take you mean discovering Xen with the usual Xen hypervisor node on
> device tree.

There may be other options, such as ARM defining an architectural mechanism
to do early detection of hypervisors e.g. by defining some bit in some
hypervisor controllable register (MPIDR?) to say "a hypervisor is present"
and defining an hvc or smc call which can be used to ask which one it is.

Ian.
