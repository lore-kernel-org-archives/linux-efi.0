From: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH 06/13] Xen: ARM: Add support for mapping amba
 device mmio
Date: Wed, 18 Nov 2015 14:03:54 +0800
Message-ID: <564C14CA.9080601@huawei.com>
References: <1447754231-7772-1-git-send-email-shannon.zhao@linaro.org> <1447754231-7772-7-git-send-email-shannon.zhao@linaro.org> <20151117144040.GI3003@char.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151117144040.GI3003-he5eyhs8q0BAdwtm4QZOy9BPR1lH4CV8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hangaohuai-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 2015/11/17 22:40, Konrad Rzeszutek Wilk wrote:
> On Tue, Nov 17, 2015 at 05:57:04PM +0800, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org wrote:
>> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>
>> Add a bus_notifier for AMBA bus device in order to map the device
>> mmio regions when DOM0 booting with ACPI.
>>
>> Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  drivers/xen/Makefile |  1 +
>>  drivers/xen/amba.c   | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 100 insertions(+)
>>  create mode 100644 drivers/xen/amba.c
>>
>> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
>> index 2f867e7..139bd0b 100644
>> --- a/drivers/xen/Makefile
>> +++ b/drivers/xen/Makefile
>> @@ -12,6 +12,7 @@ CFLAGS_features.o			:= $(nostackp)
>>  CFLAGS_efi.o				+= -fshort-wchar
>>  
>>  dom0-$(CONFIG_ARM64) += platform.o
>> +dom0-$(CONFIG_ARM_AMBA) += amba.o
>>  dom0-$(CONFIG_PCI) += pci.o
>>  dom0-$(CONFIG_USB_SUPPORT) += dbgp.o
>>  dom0-$(CONFIG_XEN_ACPI) += acpi.o $(xen-pad-y)
>> diff --git a/drivers/xen/amba.c b/drivers/xen/amba.c
>> new file mode 100644
>> index 0000000..e491c8e
>> --- /dev/null
>> +++ b/drivers/xen/amba.c
>> @@ -0,0 +1,99 @@
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
>> +#include <linux/amba/bus.h>
>> +#include <linux/acpi.h>
>> +#include <xen/xen.h>
>> +#include <xen/interface/memory.h>
>> +#include <asm/xen/hypervisor.h>
>> +#include <asm/xen/hypercall.h>
>> +
>> +static int xen_map_amba_device_mmio(struct amba_device *adev)
>> +{
>> +	int rc = 0;
>> +	struct resource *r = &adev->res;
>> +
>> +	if (resource_type(r) == IORESOURCE_MEM)
> 
> This is like the 'xen_map_platform_device_mmio' code. Why don't you call
> that? Or at least make the 'xen_map_platform_device_mmio' internal parts be
> visible to both of these functions.
> 
Ok, will do.

>> +	{
>> +		int j;
>> +		int nr = DIV_ROUND_UP(resource_size(r), PAGE_SIZE);
>> +		xen_pfn_t *gpfns = kmalloc(sizeof(xen_pfn_t) * nr, GFP_KERNEL);
>> +		xen_ulong_t *idxs = kmalloc(sizeof(xen_ulong_t) * nr,
>> +					    GFP_KERNEL);
>> +		int *errs = kmalloc(sizeof(int) * nr, GFP_KERNEL);
>> +		struct xen_add_to_physmap_range xatp;
>> +
>> +		for (j = 0; j < nr; j++) {
>> +			gpfns[j] = (r->start >> PAGE_SHIFT) + j;
>> +			idxs[j] = (r->start >> PAGE_SHIFT) + j;
>> +			errs[j] = 0;
>> +		}
>> +
>> +		xatp.domid = DOMID_SELF;
>> +		xatp.size = nr;
>> +		xatp.space = XENMAPSPACE_dev_mmio;
>> +
>> +		set_xen_guest_handle(xatp.gpfns, gpfns);
>> +		set_xen_guest_handle(xatp.idxs, idxs);
>> +		set_xen_guest_handle(xatp.errs, errs);
>> +
>> +		rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap_range, &xatp);
>> +
>> +		kfree(gpfns);
>> +		kfree(idxs);
>> +		kfree(errs);
>> +		if (rc != 0)
>> +			return rc;
>> +	}
>> +
>> +	return rc;
>> +}
>> +
>> +static int xen_amba_notifier(struct notifier_block *nb,
>> +			     unsigned long action, void *data)
>> +{
>> +	struct amba_device *adev = to_amba_device(data);
>> +	int r = 0;
>> +
>> +	if (!acpi_disabled && (action == BUS_NOTIFY_ADD_DEVICE))
>> +		r = xen_map_amba_device_mmio(adev);
>> +
> 
> What about the removal of a bus device? No need to handle that?
> 
I have thought about removal before. I think there is little(or no)
chance for AMBA and platform bus devices to be removed. It's not like
the PCI devices which will be hot-unplug.
Maybe I'm not right. If so, it's fine to add a case to handle the removal.

Thanks,
-- 
Shannon

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
