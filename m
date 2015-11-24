From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH 13/13] ARM: XEN: Move xen_early_init()
	before efi_init()
Date: Tue, 24 Nov 2015 11:50:32 +0800
Message-ID: <5653DE88.9070003@huawei.com>
References: <1447754231-7772-1-git-send-email-shannon.zhao@linaro.org>
	<1447754231-7772-14-git-send-email-shannon.zhao@linaro.org>
	<alpine.DEB.2.02.1511201720550.1107@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <alpine.DEB.2.02.1511201720550.1107@kaball.uk.xensource.com>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>, shannon.zhao@linaro.org
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org, hangaohuai@huawei.com, linux-efi@vger.kernel.org, ian.campbell@citrix.com, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, will.deacon@arm.com, peter.huangpeng@huawei.com, xen-devel@lists.xen.org, julien.grall@citrix.com, stefano.stabellini@citrix.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org



On 2015/11/21 1:30, Stefano Stabellini wrote:
>> +struct xen_node_info {
>> > +	const char *compat;
>> > +	const char *prefix;
>> > +	const char *version;
>> > +	bool found;
>> > +};
>> > +
>> > +static int __init fdt_find_xen_node(unsigned long node, const char *uname,
>> > +				    int depth, void *data)
>> > +{
>> > +	struct xen_node_info *info = data;
>> > +	const void *s = NULL;
>> > +	int len;
>> > +
>> > +	if (depth != 1 || strcmp(uname, "hypervisor") != 0)
>> > +		return 0;
>> > +
>> > +	if (of_flat_dt_is_compatible(node, info->compat))
>> > +		info->found = true;
>> > +
>> > +	s = of_get_flat_dt_prop(node, "compatible", &len);
>> > +	if (strlen(info->prefix) + 3  < len &&
>> > +                        !strncmp(info->prefix, s, strlen(info->prefix)))
>> > +                info->version = s + strlen(info->prefix);
>> > +	return 0;
>> > +}
>> > +
>> >  /*
>> >   * see Documentation/devicetree/bindings/arm/xen.txt for the
>> >   * documentation of the Xen Device Tree format.
>> > @@ -149,26 +176,25 @@ static irqreturn_t xen_arm_callback(int irq, void *arg)
>> >  #define GRANT_TABLE_PHYSADDR 0
>> >  void __init xen_early_init(void)
>> >  {
>> > -	int len;
>> > -	const char *s = NULL;
>> > -	const char *version = NULL;
>> > -	const char *xen_prefix = "xen,xen-";
>> > +	struct xen_node_info info;
>> > +
>> > +	info.compat = "xen,xen";
>> > +	info.prefix = "xen,xen-";
>> > +	info.version = NULL;
>> > +	info.found = false;
> Can you initialize the fields directly when you define xen_node_info and
> make it static?
Sure.

Thanks,
-- 
Shannon
