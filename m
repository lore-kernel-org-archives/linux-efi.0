From: Stefano Stabellini <sstabellini@kernel.org>
Subject: Re: [PATCH v11 01/17] Xen: ACPI: Hide UART used by Xen
Date: Wed, 20 Apr 2016 10:39:47 +0100 (BST)
Message-ID: <alpine.DEB.2.10.1604201038490.25611@sstabellini-ThinkPad-X260>
References: <1460030614-16112-1-git-send-email-zhaoshenglong@huawei.com> <1460030614-16112-2-git-send-email-zhaoshenglong@huawei.com> <CAJZ5v0gN9S0AKX8SZbbVFOn6ydwCa_7GyxzzJHod8s0xyCXgvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJZ5v0gN9S0AKX8SZbbVFOn6ydwCa_7GyxzzJHod8s0xyCXgvA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Shannon Zhao <zhaoshenglong@huawei.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, sstabellini@kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, julien.grall@arm.com, david.vrabel@citrix.com, xen-devel@lists.xen.org, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Shannon Zhao <shannon.zhao@linaro.org>, peter.huangpeng@huawei.com, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, "open list:ACPI" <linux-acpi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 18 Apr 2016, Rafael J. Wysocki wrote:
> On Thu, Apr 7, 2016 at 2:03 PM, Shannon Zhao <zhaoshenglong@huawei.com> wrote:
> > From: Shannon Zhao <shannon.zhao@linaro.org>
> >
> > ACPI 6.0 introduces a new table STAO to list the devices which are used
> > by Xen and can't be used by Dom0. On Xen virtual platforms, the physical
> > UART is used by Xen. So here it hides UART from Dom0.
> >
> > CC: "Rafael J. Wysocki" <rjw@rjwysocki.net> (supporter:ACPI)
> > CC: Len Brown <lenb@kernel.org> (supporter:ACPI)
> > CC: linux-acpi@vger.kernel.org (open list:ACPI)
> > Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

I am going to commit it to the xentip tree, if you prefer to take it in
your tree please let me know.


> > ---
> >  drivers/acpi/scan.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 74 insertions(+)
> >
> > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > index 5f28cf7..cfc73fe 100644
> > --- a/drivers/acpi/scan.c
> > +++ b/drivers/acpi/scan.c
> > @@ -46,6 +46,13 @@ DEFINE_MUTEX(acpi_device_lock);
> >  LIST_HEAD(acpi_wakeup_device_list);
> >  static DEFINE_MUTEX(acpi_hp_context_lock);
> >
> > +/*
> > + * The UART device described by the SPCR table is the only object which needs
> > + * special-casing. Everything else is covered by ACPI namespace paths in STAO
> > + * table.
> > + */
> > +static u64 spcr_uart_addr;
> > +
> >  struct acpi_dep_data {
> >         struct list_head node;
> >         acpi_handle master;
> > @@ -1453,6 +1460,41 @@ static int acpi_add_single_object(struct acpi_device **child,
> >         return 0;
> >  }
> >
> > +static acpi_status acpi_get_resource_memory(struct acpi_resource *ares,
> > +                                           void *context)
> > +{
> > +       struct resource *res = context;
> > +
> > +       if (acpi_dev_resource_memory(ares, res))
> > +               return AE_CTRL_TERMINATE;
> > +
> > +       return AE_OK;
> > +}
> > +
> > +static bool acpi_device_should_be_hidden(acpi_handle handle)
> > +{
> > +       acpi_status status;
> > +       struct resource res;
> > +
> > +       /* Check if it should ignore the UART device */
> > +       if (!(spcr_uart_addr && acpi_has_method(handle, METHOD_NAME__CRS)))
> > +               return false;
> > +
> > +       /*
> > +        * The UART device described in SPCR table is assumed to have only one
> > +        * memory resource present. So we only look for the first one here.
> > +        */
> > +       status = acpi_walk_resources(handle, METHOD_NAME__CRS,
> > +                                    acpi_get_resource_memory, &res);
> > +       if (ACPI_FAILURE(status) || res.start != spcr_uart_addr)
> > +               return false;
> > +
> > +       acpi_handle_info(handle, "The UART device @%pa in SPCR table will be hidden\n",
> > +                        &res.start);
> > +
> > +       return true;
> > +}
> > +
> >  static int acpi_bus_type_and_status(acpi_handle handle, int *type,
> >                                     unsigned long long *sta)
> >  {
> > @@ -1466,6 +1508,9 @@ static int acpi_bus_type_and_status(acpi_handle handle, int *type,
> >         switch (acpi_type) {
> >         case ACPI_TYPE_ANY:             /* for ACPI_ROOT_OBJECT */
> >         case ACPI_TYPE_DEVICE:
> > +               if (acpi_device_should_be_hidden(handle))
> > +                       return -ENODEV;
> > +
> >                 *type = ACPI_BUS_TYPE_DEVICE;
> >                 status = acpi_bus_get_status_handle(handle, sta);
> >                 if (ACPI_FAILURE(status))
> > @@ -1916,9 +1961,24 @@ static int acpi_bus_scan_fixed(void)
> >         return result < 0 ? result : 0;
> >  }
> >
> > +static void __init acpi_get_spcr_uart_addr(void)
> > +{
> > +       acpi_status status;
> > +       struct acpi_table_spcr *spcr_ptr;
> > +
> > +       status = acpi_get_table(ACPI_SIG_SPCR, 0,
> > +                               (struct acpi_table_header **)&spcr_ptr);
> > +       if (ACPI_SUCCESS(status))
> > +               spcr_uart_addr = spcr_ptr->serial_port.address;
> > +       else
> > +               printk(KERN_WARNING PREFIX "STAO table present, but SPCR is missing\n");
> > +}
> > +
> >  int __init acpi_scan_init(void)
> >  {
> >         int result;
> > +       acpi_status status;
> > +       struct acpi_table_stao *stao_ptr;
> >
> >         acpi_pci_root_init();
> >         acpi_pci_link_init();
> > @@ -1934,6 +1994,20 @@ int __init acpi_scan_init(void)
> >
> >         acpi_scan_add_handler(&generic_device_handler);
> >
> > +       /*
> > +        * If there is STAO table, check whether it needs to ignore the UART
> > +        * device in SPCR table.
> > +        */
> > +       status = acpi_get_table(ACPI_SIG_STAO, 0,
> > +                               (struct acpi_table_header **)&stao_ptr);
> > +       if (ACPI_SUCCESS(status)) {
> > +               if (stao_ptr->header.length > sizeof(struct acpi_table_stao))
> > +                       printk(KERN_INFO PREFIX "STAO Name List not yet supported.");
> > +
> > +               if (stao_ptr->ignore_uart)
> > +                       acpi_get_spcr_uart_addr();
> > +       }
> > +
> >         mutex_lock(&acpi_scan_lock);
> >         /*
> >          * Enumerate devices in the ACPI namespace.
> > --
> > 2.0.4
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
