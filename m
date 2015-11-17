From: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH 05/13] Xen: ARM: Add support for mapping platform
 device mmio
Date: Tue, 17 Nov 2015 16:32:50 +0000
Message-ID: <564B56B2.4030901@citrix.com>
References: <1447754231-7772-1-git-send-email-shannon.zhao@linaro.org>
 <1447754231-7772-6-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447754231-7772-6-git-send-email-shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hangaohuai-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 17/11/15 09:57, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org wrote:
> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> Add a bus_notifier for platform bus device in order to map the device
> mmio regions when DOM0 booting with ACPI.
[...]
> --- /dev/null
> +++ b/drivers/xen/platform.c
> @@ -0,0 +1,104 @@
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

"You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>."

> + *
> + * Author: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Omit this since it just becomes stale and git will know the correct
authorship.

> +static int xen_platform_notifier(struct notifier_block *nb,
> +				 unsigned long action, void *data)
> +{
> +	struct platform_device *pdev = to_platform_device(data);
> +	int r = 0;
> +
> +	if (!acpi_disabled && (action == BUS_NOTIFY_ADD_DEVICE))
> +		r = xen_map_platform_device_mmio(pdev);

Why even register the notifier if acpi_disabled?

> +
> +	if (r)
> +	{
> +		dev_err(&pdev->dev, "Failed to add_to_physmap device (%s) mmio!\n",
> +			pdev->name);
> +		return NOTIFY_OK;

Return NOTIFY_BAD here?  The device will be unusable.

> +	}
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block platform_device_nb = {
> +	.notifier_call = xen_platform_notifier,
> +};
> +
> +static int __init register_xen_platform_notifier(void)
> +{
> +	if (!xen_initial_domain())
> +		return 0;
> +
> +	return bus_register_notifier(&platform_bus_type, &platform_device_nb);

Why only platform busses?  What about PCI devices?  Where will they get
added to dom0's physmap?

David
