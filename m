From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v11 12/17] ARM64: ACPI: Check if it runs on Xen to enable
 or disable ACPI
Date: Fri, 22 Apr 2016 11:32:50 +0100
Message-ID: <20160422103250.GC10606@leverpostej>
References: <1460030614-16112-1-git-send-email-zhaoshenglong@huawei.com>
 <1460030614-16112-13-git-send-email-zhaoshenglong@huawei.com>
 <alpine.DEB.2.10.1604201033140.25611@sstabellini-ThinkPad-X260>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1604201033140.25611@sstabellini-ThinkPad-X260>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefano Stabellini <sstabellini@kernel.org>, catalin.marinas@arm.com, will.deacon@arm.com
Cc: linux-arm-kernel@lists.infradead.org, julien.grall@arm.com, david.vrabel@citrix.com, xen-devel@lists.xen.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 20, 2016 at 10:34:41AM +0100, Stefano Stabellini wrote:
> Hello Mark,
> 
> do you think that this patch addresses your previous comments
> (http://marc.info/?l=devicetree&m=145926913008544&w=2) appropriately?
> 
> Thanks,
> 
> Stefano
> 
> On Thu, 7 Apr 2016, Shannon Zhao wrote:
> > From: Shannon Zhao <shannon.zhao@linaro.org>
> > 
> > When it's a Xen domain0 booting with ACPI, it will supply a /chosen and
> > a /hypervisor node in DT. So check if it needs to enable ACPI.
> > 
> > Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> > Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Acked-by: Hanjun Guo <hanjun.guo@linaro.org>
> > ---
> >  arch/arm64/kernel/acpi.c | 14 ++++++++++----
> >  1 file changed, 10 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
> > index d1ce8e2..57ee317 100644
> > --- a/arch/arm64/kernel/acpi.c
> > +++ b/arch/arm64/kernel/acpi.c
> > @@ -67,10 +67,15 @@ static int __init dt_scan_depth1_nodes(unsigned long node,
> >  {
> >  	/*
> >  	 * Return 1 as soon as we encounter a node at depth 1 that is
> > -	 * not the /chosen node.
> > +	 * not the /chosen node, or /hypervisor node with compatible
> > +	 * string "xen,xen".
> >  	 */
> > -	if (depth == 1 && (strcmp(uname, "chosen") != 0))
> > -		return 1;
> > +	if (depth == 1 && (strcmp(uname, "chosen") != 0)) {
> > +		if (strcmp(uname, "hypervisor") != 0 ||
> > +		    !of_flat_dt_is_compatible(node, "xen,xen"))
> > +			return 1;
> > +	}
> > +
> >  	return 0;
> >  }

Is the duplicate node checking logic I mentioned in that review gone?
i.e. do we not need an is_xen_node() helper?

Additionally, IMO, this would be easier to follow without the nested
conditionals, e.g.

static int __init dt_scan_depth1_nodes(unsigned long node,
				       const char *uname, int depth,
				       void *data)
{
	/*
	 * Ignore anything not directly under the root node; we'll
	 * catch its parent instead.
	 */
	if (depth != 1)
		return 0;

	if (strcmp(uname, "chosen") == 0)
		return 0;

	if (strcmp(uname, "hypervisor") == 0 &&
	    of_flat_dt_is_compatible(node, "xen,xen"))
		return 0;

	/*
	 * This node at depth 1 is neither a chosen node nor a xen node,
	 * which we do not expect.
	 */
	return 1;
}

Otherwise, this looks fine to me. FWIW, either way:

Acked-by: Mark Rutland <mark.rutland@arm.com>

As this is core arm64 code, I believe you'll need acks from Catalin
and/or Will (and likewise for patch 15), unless I've missed those.

Thanks,
Mark.

> >  
> > @@ -184,7 +189,8 @@ void __init acpi_boot_table_init(void)
> >  	/*
> >  	 * Enable ACPI instead of device tree unless
> >  	 * - ACPI has been disabled explicitly (acpi=off), or
> > -	 * - the device tree is not empty (it has more than just a /chosen node)
> > +	 * - the device tree is not empty (it has more than just a /chosen node,
> > +	 *   and a /hypervisor node when running on Xen)
> >  	 *   and ACPI has not been force enabled (acpi=force)
> >  	 */
> >  	if (param_acpi_off ||
> > -- 
> > 2.0.4
> > 
> > 
> 
