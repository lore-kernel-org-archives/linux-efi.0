From: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Subject: Re: [PATCH v2 01/16] Xen: ACPI: Hide UART used by Xen
Date: Fri, 15 Jan 2016 15:39:54 +0000
Message-ID: <alpine.DEB.2.02.1601151522460.16178@kaball.uk.xensource.com>
References: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com>
 <1452840929-19612-2-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452840929-19612-2-git-send-email-zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "open list:ACPI" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 15 Jan 2016, Shannon Zhao wrote:
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
>  drivers/acpi/bus.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> index a212cef..d7a559f 100644
> --- a/drivers/acpi/bus.c
> +++ b/drivers/acpi/bus.c
> @@ -46,6 +46,7 @@ ACPI_MODULE_NAME("bus");
>  struct acpi_device *acpi_root;
>  struct proc_dir_entry *acpi_root_dir;
>  EXPORT_SYMBOL(acpi_root_dir);
> +static u64 spcr_uart_addr;
>  
>  #ifdef CONFIG_X86
>  #ifdef CONFIG_ACPI_CUSTOM_DSDT
> @@ -93,6 +94,17 @@ acpi_status acpi_bus_get_status_handle(acpi_handle handle,
>  {
>  	acpi_status status;
>  
> +	if (spcr_uart_addr != 0xffffffffffffffff) {

Please #define something like EFI_INVALID_TABLE_ADDR and use it here
instead of 0xffffffffffffffff for readability. Also spcr_uart_addr could
be initialized where it is defined.

Maybe it could be better to move this check into a separate function and
only call acpi_set_device_status if spcr_uart_addr != addr?


> +		u64 addr;
> +
> +		status = acpi_evaluate_integer(handle, METHOD_NAME__ADR, NULL,
> +					       &addr);
> +		if (ACPI_SUCCESS(status) && (addr == spcr_uart_addr)) {
> +			*sta = 0;
> +			return AE_OK;
> +		}
> +	}
> +
>  	status = acpi_evaluate_integer(handle, "_STA", NULL, sta);
>  	if (ACPI_SUCCESS(status))
>  		return AE_OK;
> @@ -1069,6 +1081,8 @@ EXPORT_SYMBOL_GPL(acpi_kobj);
>  static int __init acpi_init(void)
>  {
>  	int result;
> +	acpi_status status;
> +	struct acpi_table_stao *stao_ptr;
>  
>  	if (acpi_disabled) {
>  		printk(KERN_INFO PREFIX "Interpreter disabled.\n");
> @@ -1081,6 +1095,22 @@ static int __init acpi_init(void)
>  		acpi_kobj = NULL;
>  	}
>  
> +	/* If there is STAO table, check whether it needs to ignore the UART
> +	 * device in SPCR table.
> +	 */
> +	spcr_uart_addr = 0xffffffffffffffff;
> +	status = acpi_get_table(ACPI_SIG_STAO, 0,
> +				(struct acpi_table_header **)&stao_ptr);
> +	if (ACPI_SUCCESS(status)) {
> +		if (stao_ptr->ignore_uart) {

if (ACPI_SUCCESS(status) && stao_ptr->ignore_uart) {


> +			struct acpi_table_spcr *spcr_ptr;
> +
> +			acpi_get_table(ACPI_SIG_SPCR, 0,
> +				       (struct acpi_table_header **)&spcr_ptr);

Maybe we should check that acpi_get_table succeeded, even though it
should at this point.


> +			spcr_uart_addr = spcr_ptr->serial_port.address;
> +		}
> +	}
> +
>  	init_acpi_device_notify();
>  	result = acpi_bus_init();
>  	if (result) {
