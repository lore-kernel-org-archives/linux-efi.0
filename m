From: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH 07/13] ARM: Xen: Document UEFI support on
 Xen ARM virtual platforms
Date: Fri, 20 Nov 2015 16:42:11 +0000
Message-ID: <alpine.DEB.2.02.1511201640550.1107@kaball.uk.xensource.com>
References: <1447754231-7772-1-git-send-email-shannon.zhao@linaro.org>
 <1447754231-7772-8-git-send-email-shannon.zhao@linaro.org>
 <564B59F3.2060801@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <564B59F3.2060801-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Cc: shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hangaohuai-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 17 Nov 2015, David Vrabel wrote:
> On 17/11/15 09:57, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org wrote:
> > From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > 
> > Add a "uefi" node under /hypervisor node in FDT, then Linux kernel could
> > scan this to get the UEFI information.
> [...]
> > --- a/Documentation/devicetree/bindings/arm/xen.txt
> > +++ b/Documentation/devicetree/bindings/arm/xen.txt
> > @@ -15,6 +15,24 @@ the following properties:
> >  - interrupts: the interrupt used by Xen to inject event notifications.
> >    A GIC node is also required.
> >  
> > +To support UEFI on Xen ARM virtual platforms, Xen pupulates the FDT "uefi" node
> > +under /hypervisor with following parameters:
> 
> It's not really clear why this is under /hypervisor and why xen needs to
> define its own nodes.

There was a very long discussion about this, see http://marc.info/?l=xen-devel&m=144321258920213


> The handling of the existing linux standard nodes can be made
> Xen-specific by the presence of the /hypervisor/compatible == "xen" node
> (or similar), right?
> 
> > +________________________________________________________________________________
> > +Name                      | Size   | Description
> > +================================================================================
> > +xen,uefi-system-table     | 64-bit | Physical address of the UEFI System Table.
> > +--------------------------------------------------------------------------------
> > +xen,uefi-mmap-start       | 64-bit | Physical address of the UEFI memory map.
> > +--------------------------------------------------------------------------------
> 
> I would probably say "Guest physical address..." just to be clear.
> 
> > +xen,uefi-mmap-size        | 32-bit | Size in bytes of the UEFI memory map
> > +                          |        | pointed to in previous entry.
> > +--------------------------------------------------------------------------------
> > +xen,uefi-mmap-desc-size   | 32-bit | Size in bytes of each entry in the UEFI
> > +                          |        | memory map.
> > +--------------------------------------------------------------------------------
> > +xen,uefi-mmap-desc-ver    | 32-bit | Version of the mmap descriptor format.
> > +--------------------------------------------------------------------------------
> 
> Need a reference to the mmap descriptor format here.
> 
> David
> 
