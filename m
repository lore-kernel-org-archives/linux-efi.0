From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v7 12/17] ARM64: ACPI: Check if it runs on Xen to enable
 or disable ACPI
Date: Wed, 30 Mar 2016 15:19:28 +0800
Message-ID: <56FB7E00.7030400@huawei.com>
References: <1458830676-27075-1-git-send-email-shannon.zhao@linaro.org> <1458830676-27075-13-git-send-email-shannon.zhao@linaro.org> <20160329161837.GH6745@arm.com> <20160329163147.GB27223@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160329163147.GB27223@leverpostej>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: Shannon Zhao <shannon.zhao@linaro.org>, linux-arm-kernel@lists.infradead.org, stefano.stabellini@citrix.com, david.vrabel@citrix.com, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, catalin.marinas@arm.com, julien.grall@arm.com, peter.huangpeng@huawei.com, xen-devel@lists.xen.org
List-Id: linux-efi@vger.kernel.org

Hi Will, Mark,

On 2016/3/30 0:31, Mark Rutland wrote:
> On Tue, Mar 29, 2016 at 05:18:38PM +0100, Will Deacon wrote:
>> > On Thu, Mar 24, 2016 at 10:44:31PM +0800, Shannon Zhao wrote:
>>> > > When it's a Xen domain0 booting with ACPI, it will supply a /chosen and
>>> > > a /hypervisor node in DT. So check if it needs to enable ACPI.
>>> > > 
>>> > > Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>>> > > Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>>> > > Acked-by: Hanjun Guo <hanjun.guo@linaro.org>
>>> > > ---
>>> > >  arch/arm64/kernel/acpi.c | 12 ++++++++----
>>> > >  1 file changed, 8 insertions(+), 4 deletions(-)
>>> > > 
>>> > > diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
>>> > > index d1ce8e2..4e92be0 100644
>>> > > --- a/arch/arm64/kernel/acpi.c
>>> > > +++ b/arch/arm64/kernel/acpi.c
>>> > > @@ -67,10 +67,13 @@ static int __init dt_scan_depth1_nodes(unsigned long node,
>>> > >  {
>>> > >  	/*
>>> > >  	 * Return 1 as soon as we encounter a node at depth 1 that is
>>> > > -	 * not the /chosen node.
>>> > > +	 * not the /chosen node, or /hypervisor node when running on Xen.
>>> > >  	 */
>>> > > -	if (depth == 1 && (strcmp(uname, "chosen") != 0))
>>> > > -		return 1;
>>> > > +	if (depth == 1 && (strcmp(uname, "chosen") != 0)) {
>>> > > +		if (!xen_initial_domain() || (strcmp(uname, "hypervisor") != 0))
>>> > > +			return 1;
>>> > > +	}
>> > 
>> > Hmm, but xen_initial_domain() is false when xen isn't being used at all,
>> > so it feels to me like this is a bit too far-reaching and is basically
>> > claiming the "/hypervisor" namespace for Xen. Couldn't it be renamed to
>> > "xen,hypervisor" or something?
>> > 
>> > Mark, got any thoughts on this?
> The node has a compatible string, "xen,xen" per [1], which would tell us
> absolutely that xen is present. I'd be happy checking for that
> explicitly.
> 
I think actually the xen_initial_domain is the result of the
fdt_find_hyper_node. If the compatible string "xen,xen" doesn't exist,
the xen_initial_domain() will return false and whatever the current node
is the above check will return 1 since the device tree is not empty.

> In patch 11 fdt_find_hyper_node checks the compatible string. We could
> factor that out into a helper like is_xen_node(node) and use it here
> too.
> 
I don't think so because we already check the compatible string before
and we could get the result simply via xen_initial_domain().

Thanks,
-- 
Shannon
