From: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Subject: Re: [PATCH v2 12/16] ARM: Xen: Document UEFI support on Xen ARM
 virtual platforms
Date: Tue, 19 Jan 2016 14:11:39 +0000
Message-ID: <alpine.DEB.2.02.1601191408420.9400@kaball.uk.xensource.com>
References: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com>
 <1452840929-19612-13-git-send-email-zhaoshenglong@huawei.com>
 <20160118105115.GD21067@leverpostej>
 <alpine.DEB.2.02.1601181710270.9400@kaball.uk.xensource.com>
 <569E0F15.8090001@huawei.com> <20160119104747.GB25024@leverpostej>
 <alpine.DEB.2.02.1601191217190.9400@kaball.uk.xensource.com>
 <20160119131348.GJ25024@leverpostej> <569E3D9F.6050808@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <569E3D9F.6050808-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Jan Beulich <JBeulich-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>, Ian Campbell <Ian.Campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 19 Jan 2016, Shannon Zhao wrote:
> On 2016/1/19 21:13, Mark Rutland wrote:
> > On Tue, Jan 19, 2016 at 12:23:17PM +0000, Stefano Stabellini wrote:
> > > >On Tue, 19 Jan 2016, Mark Rutland wrote:
> > > > > >On Tue, Jan 19, 2016 at 06:25:25PM +0800, Shannon Zhao wrote:
> > > > > > > > > > >>We don't do this in Documentation/arm/uefi.txt, and I
> > > > > > > don't see why we
> > > > > > > > > > >>should do so here.
> > > > > > > > > > >>
> > > > > > > > > > >>Does Xen handle arbitrary size memory map descriptors? I'm
> > > > > > > not sure what
> > > > > > > > > > >>new information might be passed in future additions to the
> > > > > > > descriptor
> > > > > > > > > > >>format, and I'm not sure what should happen in the Dom0
> > > > > > > case.
> > > > > > > > > >
> > > > > > > > > >Xen passes to Dom0 the memory map in the same format as the
> > > > > > native
> > > > > > > > > >memory map.
> > > > > >
> > > > > >Does Xen parse or modify the EFI memory map in any way?
> > > >
> > > >Xen:
> > > >- calls EFI_BOOT_SERVICES.GetMemoryMap()
> > > >- takes note of the memory regions for its own usage
> > > >- create the fdt notes, including efi-mmap-start, with a pointer to it
> > > >
> > > >
> > > > > >Does it pass the raw values returned by
> > > > EFI_BOOT_SERVICES.GetMemoryMap()
> > > > > >through to the xen,uefi-* properties, or does is make any static
> > > > > >assumptions about what the values will be?
> > > >
> > > >It just passes the raw values.
> > I take it that means that any memory carved out for Xen itself is
> > described/discovered via a separate mechanism? How does that work
> 
> For Xen hypervisor booting on UEFI, it get the EFI memory map through the
> similar way like Linux, e.g. call EFI_BOOT_SERVICES.GetMemoryMap().
> For Dom0, Xen will create a new EFI memory map for Dom0.
> 
> See [PATCH v3 52/62] arm/acpi: Prepare EFI memory descriptor for Dom0
> http://lists.xen.org/archives/html/xen-devel/2015-11/msg01884.html

Ah! That patch is not upstream yet, that's why I thought that something
was off. Listen to Shannon, don't listen to me :-)
