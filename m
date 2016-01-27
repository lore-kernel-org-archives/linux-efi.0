From: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 12/17] ARM64: ACPI: Check if it runs on Xen to enable
 or disable ACPI
Date: Wed, 27 Jan 2016 16:57:19 +0800
Message-ID: <56A8866F.5060302@huawei.com>
References: <1453519184-11908-1-git-send-email-zhaoshenglong@huawei.com> <1453519184-11908-13-git-send-email-zhaoshenglong@huawei.com> <56A87F77.8070506@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56A87F77.8070506-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org
Cc: catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org



On 2016/1/27 16:27, Hanjun Guo wrote:
> Hi Shannon,
> 
> On 2016/1/23 11:19, Shannon Zhao wrote:
>> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>
>> When it's a Xen domain0 booting with ACPI, it will supply a /chosen and
>> a /hypervisor node in DT. So check if it needs to enable ACPI.
>>
>> Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>> CC: Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>   arch/arm64/kernel/acpi.c | 12 ++++++++----
>>   1 file changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
>> index d1ce8e2..4e92be0 100644
>> --- a/arch/arm64/kernel/acpi.c
>> +++ b/arch/arm64/kernel/acpi.c
>> @@ -67,10 +67,13 @@ static int __init dt_scan_depth1_nodes(unsigned
>> long node,
>>   {
>>       /*
>>        * Return 1 as soon as we encounter a node at depth 1 that is
>> -     * not the /chosen node.
>> +     * not the /chosen node, or /hypervisor node when running on Xen.
> 
> The comment is bit misleading, we need to specify two mode, running on
> Xen or not, if not on xen, then /chosen node is enough.
> 
Ok, will rephrase it.

>>        */
>> -    if (depth == 1 && (strcmp(uname, "chosen") != 0))
>> -        return 1;
>> +    if (depth == 1 && (strcmp(uname, "chosen") != 0)) {
>> +        if (!xen_initial_domain() || (strcmp(uname, "hypervisor") != 0))
>> +            return 1;
>> +    }
>> +
>>       return 0;
>>   }
>>
>> @@ -184,7 +187,8 @@ void __init acpi_boot_table_init(void)
>>       /*
>>        * Enable ACPI instead of device tree unless
>>        * - ACPI has been disabled explicitly (acpi=off), or
>> -     * - the device tree is not empty (it has more than just a
>> /chosen node)
>> +     * - the device tree is not empty (it has more than just a
>> /chosen node,
>> +     *   and a /hypervisor node when running on Xen)
> 
> and here too.
> 
> if that is addressed,
> 
> Acked-by: Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Thanks!

-- 
Shannon
