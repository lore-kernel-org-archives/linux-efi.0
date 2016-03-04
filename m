From: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Subject: Re: [PATCH v5 01/17] Xen: ACPI: Hide UART used by Xen
Date: Fri, 4 Mar 2016 12:24:21 +0000
Message-ID: <alpine.DEB.2.02.1603041213400.17938@kaball.uk.xensource.com>
References: <1457073455-11516-1-git-send-email-zhaoshenglong@huawei.com>
 <1457073455-11516-2-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457073455-11516-2-git-send-email-zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, hangaohuai-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "open list:ACPI" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 4 Mar 2016, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> ACPI 6.0 introduces a new table STAO to list the devices which are used
> by Xen and can't be used by Dom0. On Xen virtual platforms, the physical
> UART is used by Xen. So here it hides UART from Dom0.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
> CC: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org> (supporter:ACPI)
> CC: Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> (supporter:ACPI)
> CC: linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list:ACPI)
> ---
>  drivers/acpi/scan.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 68 insertions(+)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 407a376..31d794c 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -45,6 +45,7 @@ static LIST_HEAD(acpi_scan_handlers_list);
>  DEFINE_MUTEX(acpi_device_lock);
>  LIST_HEAD(acpi_wakeup_device_list);
>  static DEFINE_MUTEX(acpi_hp_context_lock);
> +static u64 spcr_uart_addr;
>  
>  struct acpi_dep_data {
>  	struct list_head node;
> @@ -1453,6 +1454,47 @@ static int acpi_add_single_object(struct acpi_device **child,
>  	return 0;
>  }
>  
> +static acpi_status acpi_get_resource_fixed_memory32(struct acpi_resource *res,
> +						    void *context)
> +{
> +	struct acpi_resource_fixed_memory32 *fixed_memory32;
> +
> +	if (res->type != ACPI_RESOURCE_TYPE_FIXED_MEMORY32)
> +		return AE_OK;
> +
> +	fixed_memory32 = &res->data.fixed_memory32;

Should we call acpi_resource_to_address64 instead?
Aside from this the rest looks good.


> +	if (!fixed_memory32)
> +		return AE_OK;
> +
> +	*((u32 *)context) = fixed_memory32->address;
> +	return AE_CTRL_TERMINATE;
> +}
> +
> +static bool acpi_device_should_be_hidden(acpi_handle handle)
> +{
> +	acpi_status status;
> +	u32 addr = 0;
> +
> +	/* Check if it should ignore the UART device */
> +	if (spcr_uart_addr != 0) {
> +		if (!acpi_has_method(handle, METHOD_NAME__CRS))
> +			return false;
> +
> +		status = acpi_walk_resources(handle, METHOD_NAME__CRS,
> +					     acpi_get_resource_fixed_memory32,
> +					     &addr);
> +		if (ACPI_FAILURE(status))
> +			return false;
> +
> +		if (addr == spcr_uart_addr) {
> +			printk(KERN_INFO PREFIX "The UART device in SPCR table will be hidden\n");
> +			return true;
> +		}
> +	}
> +
> +	return false;
> +}
> +
>  static int acpi_bus_type_and_status(acpi_handle handle, int *type,
>  				    unsigned long long *sta)
>  {
> @@ -1466,6 +1508,9 @@ static int acpi_bus_type_and_status(acpi_handle handle, int *type,
>  	switch (acpi_type) {
>  	case ACPI_TYPE_ANY:		/* for ACPI_ROOT_OBJECT */
>  	case ACPI_TYPE_DEVICE:
> +		if (acpi_device_should_be_hidden(handle))
> +			return -ENODEV;
> +
>  		*type = ACPI_BUS_TYPE_DEVICE;
>  		status = acpi_bus_get_status_handle(handle, sta);
>  		if (ACPI_FAILURE(status))
> @@ -1919,6 +1964,8 @@ static int acpi_bus_scan_fixed(void)
>  int __init acpi_scan_init(void)
>  {
>  	int result;
> +	acpi_status status;
> +	struct acpi_table_stao *stao_ptr;
>  
>  	acpi_pci_root_init();
>  	acpi_pci_link_init();
> @@ -1933,6 +1980,27 @@ int __init acpi_scan_init(void)
>  
>  	acpi_scan_add_handler(&generic_device_handler);
>  
> +	/* If there is STAO table, check whether it needs to ignore the UART
> +	 * device in SPCR table.
> +	 */
> +	status = acpi_get_table(ACPI_SIG_STAO, 0,
> +				(struct acpi_table_header **)&stao_ptr);
> +	if (ACPI_SUCCESS(status)) {
> +		if (stao_ptr->header.length > sizeof(struct acpi_table_stao))
> +			printk(KERN_INFO PREFIX "STAO Name List not yet supported.");
> +
> +		if (stao_ptr->ignore_uart) {
> +			struct acpi_table_spcr *spcr_ptr;
> +
> +			status = acpi_get_table(ACPI_SIG_SPCR, 0,
> +					(struct acpi_table_header **)&spcr_ptr);
> +			if (ACPI_SUCCESS(status))
> +				spcr_uart_addr = spcr_ptr->serial_port.address;
> +			else
> +				printk(KERN_WARNING PREFIX "STAO table present, but SPCR is missing\n");
> +		}
> +	}
> +
>  	mutex_lock(&acpi_scan_lock);
>  	/*
>  	 * Enumerate devices in the ACPI namespace.
> -- 
> 2.0.4
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
