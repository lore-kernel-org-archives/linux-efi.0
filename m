From: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH 05/13] Xen: ARM: Add support for mapping platform
 device mmio
Date: Wed, 18 Nov 2015 13:48:06 +0800
Message-ID: <564C1116.8000603@huawei.com>
References: <1447754231-7772-1-git-send-email-shannon.zhao@linaro.org> <1447754231-7772-6-git-send-email-shannon.zhao@linaro.org> <20151117143822.GH3003@char.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151117143822.GH3003-he5eyhs8q0BAdwtm4QZOy9BPR1lH4CV8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hangaohuai-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 2015/11/17 22:38, Konrad Rzeszutek Wilk wrote:
> On Tue, Nov 17, 2015 at 05:57:03PM +0800, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org wrote:
>> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>
>> Add a bus_notifier for platform bus device in order to map the device
>> mmio regions when DOM0 booting with ACPI.
>>
>> Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  drivers/xen/Makefile   |   1 +
>>  drivers/xen/platform.c | 104 +++++++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 105 insertions(+)
>>  create mode 100644 drivers/xen/platform.c
>>
>> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
>> index e293bc5..2f867e7 100644
>> --- a/drivers/xen/Makefile
>> +++ b/drivers/xen/Makefile
>> @@ -11,6 +11,7 @@ CFLAGS_features.o			:= $(nostackp)
>>  
>>  CFLAGS_efi.o				+= -fshort-wchar
>>  
>> +dom0-$(CONFIG_ARM64) += platform.o
>>  dom0-$(CONFIG_PCI) += pci.o
>>  dom0-$(CONFIG_USB_SUPPORT) += dbgp.o
>>  dom0-$(CONFIG_XEN_ACPI) += acpi.o $(xen-pad-y)
>> diff --git a/drivers/xen/platform.c b/drivers/xen/platform.c
>> new file mode 100644
>> index 0000000..0f95e7f
>> --- /dev/null
>> +++ b/drivers/xen/platform.c
>> @@ -0,0 +1,104 @@
>> +/*
>> + * Copyright (c) 2015, Linaro Limited.
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms and conditions of the GNU General Public License,
>> + * version 2, as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License along with
>> + * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
>> + * Place - Suite 330, Boston, MA 02111-1307 USA.
>> + *
>> + * Author: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> + */
>> +
>> +#include <linux/platform_device.h>
>> +#include <linux/acpi.h>
>> +#include <xen/xen.h>
>> +#include <xen/interface/memory.h>
>> +#include <asm/xen/hypervisor.h>
>> +#include <asm/xen/hypercall.h>
>> +
>> +static int xen_map_platform_device_mmio(struct platform_device *pdev)
>> +{
>> +	int i, rc = 0;
> 
> unsigned int i;
>> +
>> +	for (i = 0; i < pdev->num_resources; i++)
>> +	{
>> +		struct resource *r = &pdev->resource[i];
>> +
>> +		if (resource_type(r) == IORESOURCE_MEM)
> 
> Make this:
> 
> 	if (resource_type(r) != IORESOURCE_MEM)
> 		continue;
> 
>> +		{
> 
> And then you don't have to move all of this code to the right.
> 
>> +			int j;
> unsigned int
>> +			int nr = DIV_ROUND_UP(resource_size(r), PAGE_SIZE);
> 
> unsigned int
>> +			xen_pfn_t *gpfns = kmalloc(sizeof(xen_pfn_t) * nr,
>> +						   GFP_KERNEL);
>> +			xen_ulong_t *idxs = kmalloc(sizeof(xen_ulong_t) * nr,
>> +						    GFP_KERNEL);
>> +			int *errs = kmalloc(sizeof(int) * nr, GFP_KERNEL);
> 
> You can use kzalloc.
>> +			struct xen_add_to_physmap_range xatp;
> 
> This declaration of variables and then setting does not look like that
> pretty to my mind. (And it is a headache to debug if for example 'nr' ends up
> being zero for example). Or worst -1U since you had it as 'int'.
> 
Yes, a little. Maybe I can add a check for nr. Would that be fine?

Thanks,
-- 
Shannon

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
