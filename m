From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v7 12/17] ARM64: ACPI: Check if it runs on Xen to enable
 or disable ACPI
Date: Tue, 29 Mar 2016 17:31:47 +0100
Message-ID: <20160329163147.GB27223@leverpostej>
References: <1458830676-27075-1-git-send-email-shannon.zhao@linaro.org>
 <1458830676-27075-13-git-send-email-shannon.zhao@linaro.org>
 <20160329161837.GH6745@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160329161837.GH6745-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, julien.grall-5wv7dgnIgG8@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 29, 2016 at 05:18:38PM +0100, Will Deacon wrote:
> On Thu, Mar 24, 2016 at 10:44:31PM +0800, Shannon Zhao wrote:
> > When it's a Xen domain0 booting with ACPI, it will supply a /chosen and
> > a /hypervisor node in DT. So check if it needs to enable ACPI.
> > 
> > Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > Reviewed-by: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
> > Acked-by: Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
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
> 
> Hmm, but xen_initial_domain() is false when xen isn't being used at all,
> so it feels to me like this is a bit too far-reaching and is basically
> claiming the "/hypervisor" namespace for Xen. Couldn't it be renamed to
> "xen,hypervisor" or something?
> 
> Mark, got any thoughts on this?

The node has a compatible string, "xen,xen" per [1], which would tell us
absolutely that xen is present. I'd be happy checking for that
explicitly.

In patch 11 fdt_find_hyper_node checks the compatible string. We could
factor that out into a helper like is_xen_node(node) and use it here
too.

If in future we want to do the same for other hypervisors we can add
explicit checks for their compatible strings and/or wrap that in a more
generic helper to cater for any hypervisor-specific details.

Thanks,
Mark.

[1] Documentation/devicetree/bindings/arm/xen.txt
