From: Stefano Stabellini <sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH v7 12/17] ARM64: ACPI: Check if it runs on
 Xen to enable or disable ACPI
Date: Thu, 31 Mar 2016 16:21:45 +0100 (BST)
Message-ID: <alpine.DEB.2.10.1603311620260.31571@sstabellini-ThinkPad-X230>
References: <20160331144418.GR27408@perard.uk.xensource.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160331144418.GR27408-8qNLNerzPuZYtxbxJUhB2Dgeux46jI+i@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mark.rutland-5wv7dgnIgG8@public.gmane.org
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, julien.grall-5wv7dgnIgG8@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 31 Mar 2016, Mark Rutland wrote:
> On Thu, Mar 31, 2016 at 01:44:08PM +0200, Ard Biesheuvel wrote:
> > The heuristic is there to decide whether some DTB image contains a
> > complete description of the platform, or only some data handed over by
> > the bootloader. Arguably, a DT containing both /chosen and /hypervisor
> > but nothing else can still not describe an actual platform, and
> > whether we execute under Xen or not is completely irrelevant.
> 
> I disagree somewhat.
> 
> In general, a /hypervisor node may not be a Xen node, and could
> potentially imply some platform description. As /hypervisor is a generic
> name up for grabs by any hypervisor, we simply cannot make assumptions
> about it.
> 
> As /chosen is a special reserved path that implies a particular binding
> and has no compatible string, so checking its path alone is correct.
> 
> While we do check that the /hypervisor node is "xen,xen" compatible
> elsewhere, the canonical mechanism of checking for a Xen node (as
> opposed to any hypervisor's node) is to check the compatible string.
> 
> If we are going to handle nodes for other hypervisors while treating the
> DTB as empty, we need code and discussion regarding said hypervisor.
> 
> Hence, for checking for a Xen /hypervisor node, I would prefer we
> checked the compatible string rather than the path.
> 
> An is_xen_node() helper (which could also check that the path is
> "/hypervisor") would avoid having redundant, subtly distinct ways of
> checking, and would explicitly document precisely what we are checking
> for.

That's also OK for me.
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
