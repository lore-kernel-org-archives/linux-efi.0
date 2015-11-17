From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 06/13] Xen: ARM: Add support for mapping
 amba device mmio
Date: Tue, 17 Nov 2015 09:40:40 -0500
Message-ID: <20151117144040.GI3003@char.us.oracle.com>
References: <1447754231-7772-1-git-send-email-shannon.zhao@linaro.org>
	<1447754231-7772-7-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
Content-Disposition: inline
In-Reply-To: <1447754231-7772-7-git-send-email-shannon.zhao@linaro.org>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: shannon.zhao@linaro.org
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org, hangaohuai@huawei.com, linux-efi@vger.kernel.org, ian.campbell@citrix.com, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, will.deacon@arm.com, peter.huangpeng@huawei.com, xen-devel@lists.xen.org, julien.grall@citrix.com, stefano.stabellini@citrix.com, christoffer.dall@linaro.org, zhaoshenglong@huawei.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 17, 2015 at 05:57:04PM +0800, shannon.zhao@linaro.org wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Add a bus_notifier for AMBA bus device in order to map the device
> mmio regions when DOM0 booting with ACPI.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  drivers/xen/Makefile |  1 +
>  drivers/xen/amba.c   | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 100 insertions(+)
>  create mode 100644 drivers/xen/amba.c
> 
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index 2f867e7..139bd0b 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -12,6 +12,7 @@ CFLAGS_features.o			:= $(nostackp)
>  CFLAGS_efi.o				+= -fshort-wchar
>  
>  dom0-$(CONFIG_ARM64) += platform.o
> +dom0-$(CONFIG_ARM_AMBA) += amba.o
>  dom0-$(CONFIG_PCI) += pci.o
>  dom0-$(CONFIG_USB_SUPPORT) += dbgp.o
>  dom0-$(CONFIG_XEN_ACPI) += acpi.o $(xen-pad-y)
> diff --git a/drivers/xen/amba.c b/drivers/xen/amba.c
> new file mode 100644
> index 0000000..e491c8e
> --- /dev/null
> +++ b/drivers/xen/amba.c
> @@ -0,0 +1,99 @@
> +/*
> + * Copyright (c) 2015, Linaro Limited.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
> + * Place - Suite 330, Boston, MA 02111-1307 USA.
> + *
> + * Author: Shannon Zhao <shannon.zhao@linaro.org>
> + */
> +
> +#include <linux/amba/bus.h>
> +#include <linux/acpi.h>
> +#include <xen/xen.h>
> +#include <xen/interface/memory.h>
> +#include <asm/xen/hypervisor.h>
> +#include <asm/xen/hypercall.h>
> +
> +static int xen_map_amba_device_mmio(struct amba_device *adev)
> +{
> +	int rc = 0;
> +	struct resource *r = &adev->res;
> +
> +	if (resource_type(r) == IORESOURCE_MEM)

This is like the 'xen_map_platform_device_mmio' code. Why don't you call
that? Or at least make the 'xen_map_platform_device_mmio' internal parts be
visible to both of these functions.

> +	{
> +		int j;
> +		int nr = DIV_ROUND_UP(resource_size(r), PAGE_SIZE);
> +		xen_pfn_t *gpfns = kmalloc(sizeof(xen_pfn_t) * nr, GFP_KERNEL);
> +		xen_ulong_t *idxs = kmalloc(sizeof(xen_ulong_t) * nr,
> +					    GFP_KERNEL);
> +		int *errs = kmalloc(sizeof(int) * nr, GFP_KERNEL);
> +		struct xen_add_to_physmap_range xatp;
> +
> +		for (j = 0; j < nr; j++) {
> +			gpfns[j] = (r->start >> PAGE_SHIFT) + j;
> +			idxs[j] = (r->start >> PAGE_SHIFT) + j;
> +			errs[j] = 0;
> +		}
> +
> +		xatp.domid = DOMID_SELF;
> +		xatp.size = nr;
> +		xatp.space = XENMAPSPACE_dev_mmio;
> +
> +		set_xen_guest_handle(xatp.gpfns, gpfns);
> +		set_xen_guest_handle(xatp.idxs, idxs);
> +		set_xen_guest_handle(xatp.errs, errs);
> +
> +		rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap_range, &xatp);
> +
> +		kfree(gpfns);
> +		kfree(idxs);
> +		kfree(errs);
> +		if (rc != 0)
> +			return rc;
> +	}
> +
> +	return rc;
> +}
> +
> +static int xen_amba_notifier(struct notifier_block *nb,
> +			     unsigned long action, void *data)
> +{
> +	struct amba_device *adev = to_amba_device(data);
> +	int r = 0;
> +
> +	if (!acpi_disabled && (action == BUS_NOTIFY_ADD_DEVICE))
> +		r = xen_map_amba_device_mmio(adev);
> +

What about the removal of a bus device? No need to handle that?

> +	if (r)
> +	{
> +		dev_err(&adev->dev, "Failed to add_to_physmap device (%s) mmio!\n",
> +			adev->dev.init_name);
> +		return NOTIFY_OK;
> +	}
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block amba_device_nb = {
> +	.notifier_call = xen_amba_notifier,
> +};
> +
> +static int __init register_xen_amba_notifier(void)
> +{
> +	if (!xen_initial_domain())
> +		return 0;
> +
> +	return bus_register_notifier(&amba_bustype, &amba_device_nb);
> +}
> +
> +arch_initcall(register_xen_amba_notifier);
> -- 
> 2.1.0
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
