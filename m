From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH 12/13] arm/xen: Get event-channel irq
 through HVM_PARAM when booting with ACPI
Date: Tue, 24 Nov 2015 11:49:37 +0800
Message-ID: <5653DE51.9030104@huawei.com>
References: <1447754231-7772-1-git-send-email-shannon.zhao@linaro.org>
	<1447754231-7772-13-git-send-email-shannon.zhao@linaro.org>
	<alpine.DEB.2.02.1511201708120.1107@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <alpine.DEB.2.02.1511201708120.1107@kaball.uk.xensource.com>
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



On 2015/11/21 1:11, Stefano Stabellini wrote:
> On Tue, 17 Nov 2015, shannon.zhao@linaro.org wrote:
>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>
>> When booting with ACPI, it could get the event-channel irq through
>> HVM_PARAM_CALLBACK_IRQ.
>>
>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> ---
>>  arch/arm/xen/enlighten.c | 23 +++++++++++++++++++----
>>  1 file changed, 19 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
>> index 1373d6d..b8e9db8 100644
>> --- a/arch/arm/xen/enlighten.c
>> +++ b/arch/arm/xen/enlighten.c
>> @@ -25,6 +25,7 @@
>>  #include <linux/cpufreq.h>
>>  #include <linux/cpu.h>
>>  #include <linux/console.h>
>> +#include <linux/acpi.h>
>>  
>>  #include <linux/mm.h>
>>  
>> @@ -190,10 +191,24 @@ static int __init xen_guest_init(void)
>>  	if (!xen_domain())
>>  		return 0;
>>  
>> -	xen_events_irq = irq_of_parse_and_map(xen_node, 0);
>> -	if (!xen_events_irq) {
>> -		pr_err("Xen event channel interrupt not found\n");
>> -		return -ENODEV;
>> +	if (!acpi_disabled) {
>> +		struct xen_hvm_param a;
>> +
>> +		a.domid = DOMID_SELF;
>> +		a.index = HVM_PARAM_CALLBACK_IRQ;
>> +		if (HYPERVISOR_hvm_op(HVMOP_get_param, &a)) {
> 
> If HYPERVISOR_hvm_op returns an error (ret != 0), I wouldn't bother
> checking for the returned value and simply return error.
> 
> On the other hand, if HYPERVISOR_hvm_op is successful (ret == 0), then
> it might make sense to check for (a.value >> 56) == 3.
> 
Ok.
> 
>> +			if ((a.value >> 56) != 3) {
>> +				pr_err("Can't get Xen event-channel irq\n");
>> +				return -ENODEV;
>> +			}
>> +		}
>> +		xen_events_irq = a.value & 0xff;
>> +	} else {
>> +		xen_events_irq = irq_of_parse_and_map(xen_node, 0);
>> +		if (!xen_events_irq) {
>> +			pr_err("Xen event channel interrupt not found\n");
>> +			return -ENODEV;
> 
> Please make the error message common and move it out of the if/else.
> 
Sure. Thanks.
> 
>> +		}
>>  	}
>>  
>>  	shared_info_page = (struct shared_info *)get_zeroed_page(GFP_KERNEL);
>> -- 
>> 2.1.0
>>
> 
> .
> 

-- 
Shannon
