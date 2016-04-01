From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH v10 01/17] Xen: ACPI: Hide UART used by Xen
Date: Fri, 1 Apr 2016 21:21:52 +0200
Message-ID: <CAJZ5v0i_h2Y+upRE1LgMiuj2srJ8Z0BJMBk4mrTppMd7V1LXbQ@mail.gmail.com>
References: <1459525755-36968-1-git-send-email-shannon.zhao@linaro.org>
	<1459525755-36968-2-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1459525755-36968-2-git-send-email-shannon.zhao@linaro.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Shannon Zhao <shannon.zhao@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, stefano.stabellini@citrix.com, david.vrabel@citrix.com, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, julien.grall@arm.com, peter.huangpeng@huawei.com, xen-devel@lists.xen.org, Shannon Zhao <zhaoshenglong@huawei.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, "open list:ACPI" <linux-acpi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Apr 1, 2016 at 5:48 PM, Shannon Zhao <shannon.zhao@linaro.org> wrote:
> ACPI 6.0 introduces a new table STAO to list the devices which are used
> by Xen and can't be used by Dom0. On Xen virtual platforms, the physical
> UART is used by Xen. So here it hides UART from Dom0.
>
> CC: "Rafael J. Wysocki" <rjw@rjwysocki.net> (supporter:ACPI)
> CC: Len Brown <lenb@kernel.org> (supporter:ACPI)
> CC: linux-acpi@vger.kernel.org (open list:ACPI)
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  drivers/acpi/scan.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 71 insertions(+)
>
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 5f28cf7..4d2d9eb 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -45,6 +45,7 @@ static LIST_HEAD(acpi_scan_handlers_list);
>  DEFINE_MUTEX(acpi_device_lock);
>  LIST_HEAD(acpi_wakeup_device_list);
>  static DEFINE_MUTEX(acpi_hp_context_lock);

A comment here would be useful explaining that the below is an
exceptional thing an nothing like it is expected to be needed if
foreseeable future.

> +static u64 spcr_uart_addr;
>
>  struct acpi_dep_data {
>         struct list_head node;
> @@ -1453,6 +1454,44 @@ static int acpi_add_single_object(struct acpi_device **child,
>         return 0;
>  }
>
> +static acpi_status acpi_get_resource_memory(struct acpi_resource *ares,
> +                                           void *context)
> +{
> +       struct resource *res = context;
> +
> +       if (acpi_dev_resource_memory(ares, res))
> +               return AE_CTRL_TERMINATE;
> +
> +       return AE_OK;
> +}
> +
> +static bool acpi_device_should_be_hidden(acpi_handle handle)
> +{
> +       acpi_status status;
> +       struct resource res;
> +
> +       /* Check if it should ignore the UART device */
> +       if (!(spcr_uart_addr && acpi_has_method(handle, METHOD_NAME__CRS)))
> +               return false;
> +
> +       /*
> +        * The UART device described in SPCR table is assumed to have only one
> +        * memory resource present. So we only look for the first one here.
> +        */
> +       status = acpi_walk_resources(handle, METHOD_NAME__CRS,
> +                                    acpi_get_resource_memory, &res);
> +       if (ACPI_FAILURE(status))
> +               return false;
> +
> +       if (res.start == spcr_uart_addr) {

What about restructuring that a bit.

      if (ACPI_FAILURE(status) || res.start != spcr_uart_addr)
            return false;

> +               printk(KERN_INFO PREFIX "The UART device @%pa in SPCR table will be hidden\n",
> +                      &res.start);

And maybe use acpi_handle_info() for this message?

Thanks,
Rafael
