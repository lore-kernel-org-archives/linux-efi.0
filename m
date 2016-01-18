From: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Subject: Re: [PATCH v2 11/16] ARM64: ACPI: Check if it runs on Xen to enable
 or disable ACPI
Date: Mon, 18 Jan 2016 15:07:58 +0000
Message-ID: <alpine.DEB.2.02.1601181505200.16178@kaball.uk.xensource.com>
References: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com>
 <1452840929-19612-12-git-send-email-zhaoshenglong@huawei.com>
 <20160118104142.GC21067@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160118104142.GC21067@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Ian Campbell <Ian.Campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 18 Jan 2016, Mark Rutland wrote:
> On Fri, Jan 15, 2016 at 02:55:24PM +0800, Shannon Zhao wrote:
> > From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > 
> > When it's a Xen domain0 booting with ACPI, it will supply a /chosen and
> > a /hypervisor node in DT. So check if it needs to enable ACPI.
> > 
> > Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > ---
> >  arch/arm64/kernel/acpi.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
> > index d1ce8e2..4e92be0 100644
> > --- a/arch/arm64/kernel/acpi.c
> > +++ b/arch/arm64/kernel/acpi.c
> > @@ -67,10 +67,13 @@ static int __init dt_scan_depth1_nodes(unsigned long node,
> >  {
> >  	/*
> >  	 * Return 1 as soon as we encounter a node at depth 1 that is
> > -	 * not the /chosen node.
> > +	 * not the /chosen node, or /hypervisor node when running on Xen.
> >  	 */
> > -	if (depth == 1 && (strcmp(uname, "chosen") != 0))
> > -		return 1;
> > +	if (depth == 1 && (strcmp(uname, "chosen") != 0)) {
> > +		if (!xen_initial_domain() || (strcmp(uname, "hypervisor") != 0))
> > +			return 1;
> > +	}
> > +
> >  	return 0;
> >  }
> 
> As this is changing the semantic of an "empty" DT, we should consider
> now if there's anything else that might also need to exist in an "empty"
> DT. We don't want to change this again in future if we don't have to,
> given the compatiblity nightmare that's sure to result.
> 
> We should also consider if the "hypervisor" node name is sufficient (I
> think it is, but let's not assume anything).

>From Xen point of view I think it is enough: real hardware is described
in ACPI anyway and anything hypervisor related can be done via
hypercalls once Xen support is discovered, for which the hypervisor node
is sufficient.
