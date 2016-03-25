From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v8 01/17] Xen: ACPI: Hide UART used by Xen
Date: Fri, 25 Mar 2016 12:15:47 -0500
Message-ID: <20160325171547.GB29822@localhost>
References: <1458830676-27075-2-git-send-email-shannon.zhao@linaro.org>
 <1458893149-17388-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458893149-17388-1-git-send-email-zhaoshenglong@huawei.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, stefano.stabellini@citrix.com, david.vrabel@citrix.com, catalin.marinas@arm.com, will.deacon@arm.com, xen-devel@lists.xen.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, "open list:ACPI" <linux-acpi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Mar 25, 2016 at 04:05:49PM +0800, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> ACPI 6.0 introduces a new table STAO to list the devices which are used
> by Xen and can't be used by Dom0. On Xen virtual platforms, the physical
> UART is used by Xen. So here it hides UART from Dom0.
> 
> CC: "Rafael J. Wysocki" <rjw@rjwysocki.net> (supporter:ACPI)
> CC: Len Brown <lenb@kernel.org> (supporter:ACPI)
> CC: linux-acpi@vger.kernel.org (open list:ACPI)
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  drivers/acpi/scan.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 68 insertions(+)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 5f28cf7..5420cc5 100644
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
> @@ -1453,6 +1454,41 @@ static int acpi_add_single_object(struct acpi_device **child,
>  	return 0;
>  }
>  
> +static acpi_status acpi_get_resource_memory(struct acpi_resource *ares,
> +					    void *context)
> +{
> +	struct resource *res = context;
> +
> +	if (acpi_dev_resource_memory(ares, res))
> +		return AE_CTRL_TERMINATE;
> +
> +	return AE_OK;
> +}
> +
> +static bool acpi_device_should_be_hidden(acpi_handle handle)
> +{
> +	acpi_status status;
> +	struct resource res;
> +
> +	/* Check if it should ignore the UART device */
> +	if (spcr_uart_addr != 0) {
> +		if (!acpi_has_method(handle, METHOD_NAME__CRS))
> +			return false;
> +
> +		status = acpi_walk_resources(handle, METHOD_NAME__CRS,
> +					     acpi_get_resource_memory, &res);
> +		if (ACPI_FAILURE(status))
> +			return false;
> +
> +		if (res.start == spcr_uart_addr) {
> +			printk(KERN_INFO PREFIX "The UART device in SPCR table will be hidden\n");

Can we at least print out the ACPI device path and address here for
debugging purposes?  IMHO, kernel messages that contain only static
text are always dubious.  There's almost always a useful address, IRQ,
return value, etc., that could be included.

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
> @@ -1466,6 +1502,9 @@ static int acpi_bus_type_and_status(acpi_handle handle, int *type,
>  	switch (acpi_type) {
>  	case ACPI_TYPE_ANY:		/* for ACPI_ROOT_OBJECT */
>  	case ACPI_TYPE_DEVICE:
> +		if (acpi_device_should_be_hidden(handle))
> +			return -ENODEV;
> +
>  		*type = ACPI_BUS_TYPE_DEVICE;
>  		status = acpi_bus_get_status_handle(handle, sta);
>  		if (ACPI_FAILURE(status))
> @@ -1916,9 +1955,24 @@ static int acpi_bus_scan_fixed(void)
>  	return result < 0 ? result : 0;
>  }
>  
> +static void __init acpi_get_spcr_uart_addr(void)
> +{
> +	acpi_status status;
> +	struct acpi_table_spcr *spcr_ptr;
> +
> +	status = acpi_get_table(ACPI_SIG_SPCR, 0,
> +				(struct acpi_table_header **)&spcr_ptr);
> +	if (ACPI_SUCCESS(status))
> +		spcr_uart_addr = spcr_ptr->serial_port.address;
> +	else
> +		printk(KERN_WARNING PREFIX "STAO table present, but SPCR is missing\n");
> +}
> +
>  int __init acpi_scan_init(void)
>  {
>  	int result;
> +	acpi_status status;
> +	struct acpi_table_stao *stao_ptr;
>  
>  	acpi_pci_root_init();
>  	acpi_pci_link_init();
> @@ -1934,6 +1988,20 @@ int __init acpi_scan_init(void)
>  
>  	acpi_scan_add_handler(&generic_device_handler);
>  
> +	/*
> +	 * If there is STAO table, check whether it needs to ignore the UART
> +	 * device in SPCR table.
> +	 */
> +	status = acpi_get_table(ACPI_SIG_STAO, 0,
> +				(struct acpi_table_header **)&stao_ptr);
> +	if (ACPI_SUCCESS(status)) {
> +		if (stao_ptr->header.length > sizeof(struct acpi_table_stao))
> +			printk(KERN_INFO PREFIX "STAO Name List not yet supported.");
> +
> +		if (stao_ptr->ignore_uart)
> +			acpi_get_spcr_uart_addr();
> +	}

This all seems sort of ad hoc.  Are UARTs the only things that can be
listed in STAO?  If STAO can contain things other than UARTs, are we
going to see more patches adding special-case code like this?

>  	mutex_lock(&acpi_scan_lock);
>  	/*
>  	 * Enumerate devices in the ACPI namespace.
> -- 
> 2.0.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
