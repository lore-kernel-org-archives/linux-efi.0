From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH v9 01/17] Xen: ACPI: Hide UART used by Xen
Date: Thu, 31 Mar 2016 14:02:47 +0200
Message-ID: <CAJZ5v0iSDk1u47jhed9TyEef1D=nERMfBw8AzcquTgH9g=Yqpg@mail.gmail.com>
References: <1459423425-1220-1-git-send-email-zhaoshenglong@huawei.com>
	<1459423425-1220-2-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1459423425-1220-2-git-send-email-zhaoshenglong@huawei.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, stefano.stabellini@citrix.com, david.vrabel@citrix.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, sstabellini@kernel.org, julien.grall@arm.com, xen-devel@lists.xen.org, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Shannon Zhao <shannon.zhao@linaro.org>, peter.huangpeng@huawei.com, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, "open list:ACPI" <linux-acpi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Mar 31, 2016 at 1:23 PM, Shannon Zhao <zhaoshenglong@huawei.com> wrote:
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
>  drivers/acpi/scan.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 69 insertions(+)
>
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 5f28cf7..29f26fc 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -45,6 +45,7 @@ static LIST_HEAD(acpi_scan_handlers_list);
>  DEFINE_MUTEX(acpi_device_lock);
>  LIST_HEAD(acpi_wakeup_device_list);
>  static DEFINE_MUTEX(acpi_hp_context_lock);
> +static u64 spcr_uart_addr;
>
>  struct acpi_dep_data {
>         struct list_head node;
> @@ -1453,6 +1454,42 @@ static int acpi_add_single_object(struct acpi_device **child,
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
> +       if (spcr_uart_addr != 0) {

Why not to write this as

      if (spcr_uart_addr) {

Or even

      if (!spcr_uart_addr)
            return false;

and then the indentation level of the rest will be reduced.

> +               if (!acpi_has_method(handle, METHOD_NAME__CRS))
> +                       return false;
> +

I'd like to see a comment here that the devices in question are
assumed to have only one memory resource present which is why we only
look for the first one.

> +               status = acpi_walk_resources(handle, METHOD_NAME__CRS,
> +                                            acpi_get_resource_memory, &res);
> +               if (ACPI_FAILURE(status))
> +                       return false;
> +
> +               if (res.start == spcr_uart_addr) {
> +                       printk(KERN_INFO PREFIX "The UART device @%pa in SPCR table will be hidden\n",
> +                              &res.start);
> +                       return true;
> +               }
> +       }
> +
> +       return false;
> +}
> +

Thanks,
Rafael
