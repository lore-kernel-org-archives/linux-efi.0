From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v8 01/17] Xen: ACPI: Hide UART used by Xen
Date: Tue, 29 Mar 2016 16:00:26 +0800
Message-ID: <56FA361A.6080104@huawei.com>
References: <1458830676-27075-2-git-send-email-shannon.zhao@linaro.org> <1458893149-17388-1-git-send-email-zhaoshenglong@huawei.com> <20160325171547.GB29822@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20160325171547.GB29822@localhost>
Sender: linux-acpi-owner@vger.kernel.org
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, stefano.stabellini@citrix.com, david.vrabel@citrix.com, catalin.marinas@arm.com, will.deacon@arm.com, xen-devel@lists.xen.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, ACPI <linux-acpi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org



On 2016/3/26 1:15, Bjorn Helgaas wrote:
> On Fri, Mar 25, 2016 at 04:05:49PM +0800, Shannon Zhao wrote:
>> > From: Shannon Zhao <shannon.zhao@linaro.org>
>> > 
>> > ACPI 6.0 introduces a new table STAO to list the devices which are used
>> > by Xen and can't be used by Dom0. On Xen virtual platforms, the physical
>> > UART is used by Xen. So here it hides UART from Dom0.
>> > 
>> > CC: "Rafael J. Wysocki" <rjw@rjwysocki.net> (supporter:ACPI)
>> > CC: Len Brown <lenb@kernel.org> (supporter:ACPI)
>> > CC: linux-acpi@vger.kernel.org (open list:ACPI)
>> > Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> > ---
>> >  drivers/acpi/scan.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>> >  1 file changed, 68 insertions(+)
>> > 
>> > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
>> > index 5f28cf7..5420cc5 100644
>> > --- a/drivers/acpi/scan.c
>> > +++ b/drivers/acpi/scan.c
>> > @@ -45,6 +45,7 @@ static LIST_HEAD(acpi_scan_handlers_list);
>> >  DEFINE_MUTEX(acpi_device_lock);
>> >  LIST_HEAD(acpi_wakeup_device_list);
>> >  static DEFINE_MUTEX(acpi_hp_context_lock);
>> > +static u64 spcr_uart_addr;
>> >  
>> >  struct acpi_dep_data {
>> >  	struct list_head node;
>> > @@ -1453,6 +1454,41 @@ static int acpi_add_single_object(struct acpi_device **child,
>> >  	return 0;
>> >  }
>> >  
>> > +static acpi_status acpi_get_resource_memory(struct acpi_resource *ares,
>> > +					    void *context)
>> > +{
>> > +	struct resource *res = context;
>> > +
>> > +	if (acpi_dev_resource_memory(ares, res))
>> > +		return AE_CTRL_TERMINATE;
>> > +
>> > +	return AE_OK;
>> > +}
>> > +
>> > +static bool acpi_device_should_be_hidden(acpi_handle handle)
>> > +{
>> > +	acpi_status status;
>> > +	struct resource res;
>> > +
>> > +	/* Check if it should ignore the UART device */
>> > +	if (spcr_uart_addr != 0) {
>> > +		if (!acpi_has_method(handle, METHOD_NAME__CRS))
>> > +			return false;
>> > +
>> > +		status = acpi_walk_resources(handle, METHOD_NAME__CRS,
>> > +					     acpi_get_resource_memory, &res);
>> > +		if (ACPI_FAILURE(status))
>> > +			return false;
>> > +
>> > +		if (res.start == spcr_uart_addr) {
>> > +			printk(KERN_INFO PREFIX "The UART device in SPCR table will be hidden\n");
> Can we at least print out the ACPI device path and address here for
> debugging purposes?  IMHO, kernel messages that contain only static
> text are always dubious.  There's almost always a useful address, IRQ,
> return value, etc., that could be included.
> 
Ok, I'll add the device address in the message and update this patch.

Thanks,
-- 
Shannon

