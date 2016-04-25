From: Stefano Stabellini <sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v11 12/17] ARM64: ACPI: Check if it runs on Xen to enable
 or disable ACPI
Date: Mon, 25 Apr 2016 11:15:29 +0100 (BST)
Message-ID: <alpine.DEB.2.10.1604251111290.4855@sstabellini-ThinkPad-X260>
References: <1460030614-16112-1-git-send-email-zhaoshenglong@huawei.com> <1460030614-16112-13-git-send-email-zhaoshenglong@huawei.com> <alpine.DEB.2.10.1604201033140.25611@sstabellini-ThinkPad-X260> <20160422103250.GC10606@leverpostej>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160422103250.GC10606@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Stefano Stabellini <sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, julien.grall-5wv7dgnIgG8@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 22 Apr 2016, Mark Rutland wrote:
> On Wed, Apr 20, 2016 at 10:34:41AM +0100, Stefano Stabellini wrote:
> > Hello Mark,
> > 
> > do you think that this patch addresses your previous comments
> > (http://marc.info/?l=devicetree&m=145926913008544&w=2) appropriately?
> > 
> > Thanks,
> > 
> > Stefano
> > 
> > On Thu, 7 Apr 2016, Shannon Zhao wrote:
> > > From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > > 
> > > When it's a Xen domain0 booting with ACPI, it will supply a /chosen and
> > > a /hypervisor node in DT. So check if it needs to enable ACPI.
> > > 
> > > Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > > Reviewed-by: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
> > > Acked-by: Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > > ---
> > >  arch/arm64/kernel/acpi.c | 14 ++++++++++----
> > >  1 file changed, 10 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
> > > index d1ce8e2..57ee317 100644
> > > --- a/arch/arm64/kernel/acpi.c
> > > +++ b/arch/arm64/kernel/acpi.c
> > > @@ -67,10 +67,15 @@ static int __init dt_scan_depth1_nodes(unsigned long node,
> > >  {
> > >  	/*
> > >  	 * Return 1 as soon as we encounter a node at depth 1 that is
> > > -	 * not the /chosen node.
> > > +	 * not the /chosen node, or /hypervisor node with compatible
> > > +	 * string "xen,xen".
> > >  	 */
> > > -	if (depth == 1 && (strcmp(uname, "chosen") != 0))
> > > -		return 1;
> > > +	if (depth == 1 && (strcmp(uname, "chosen") != 0)) {
> > > +		if (strcmp(uname, "hypervisor") != 0 ||
> > > +		    !of_flat_dt_is_compatible(node, "xen,xen"))
> > > +			return 1;
> > > +	}
> > > +
> > >  	return 0;
> > >  }
> 
> Is the duplicate node checking logic I mentioned in that review gone?
> i.e. do we not need an is_xen_node() helper?

Given the simplicity of just calling of_flat_dt_is_compatible(node,
"xen,xen"), I think we can do without the helper. Also the function in
the previous patch also checks for the Xen version which is not needed
here.


> Additionally, IMO, this would be easier to follow without the nested
> conditionals, e.g.
> 
> static int __init dt_scan_depth1_nodes(unsigned long node,
> 				       const char *uname, int depth,
> 				       void *data)
> {
> 	/*
> 	 * Ignore anything not directly under the root node; we'll
> 	 * catch its parent instead.
> 	 */
> 	if (depth != 1)
> 		return 0;
> 
> 	if (strcmp(uname, "chosen") == 0)
> 		return 0;
> 
> 	if (strcmp(uname, "hypervisor") == 0 &&
> 	    of_flat_dt_is_compatible(node, "xen,xen"))
> 		return 0;
> 
> 	/*
> 	 * This node at depth 1 is neither a chosen node nor a xen node,
> 	 * which we do not expect.
> 	 */
> 	return 1;
> }
> 
> Otherwise, this looks fine to me. FWIW, either way:
> 
> Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>

That is easier to read. For simplicity, I'll submit a patch with you as
author, on top of the existing, to make this change. I'll use your
Signed-off-by, if that's OK.
