From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH v5 3/8] acpi: add support for ACPI reconfiguration
 notifiers
Date: Thu, 7 Jul 2016 12:34:26 +0300
Message-ID: <20160707093426.GO23527@lahna.fi.intel.com>
References: <1467404352-27101-1-git-send-email-octavian.purdila@intel.com>
 <1467404352-27101-4-git-send-email-octavian.purdila@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1467404352-27101-4-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, leonard.crestez@intel.com
List-Id: linux-efi@vger.kernel.org

On Fri, Jul 01, 2016 at 11:19:07PM +0300, Octavian Purdila wrote:
> Add support for ACPI reconfiguration notifiers to allow subsystems to
> react to changes in the ACPI tables that happen after the initial
> enumeration. This is similar with the way dynamic device tree
> notifications work.
> 
> The reconfigure notifications supported for now are device add and
> device remove.
> 
> Since ACPICA allows only one table notification handler, this patch
> makes the table notifier function generic and moves it out of the
> sysfs specific code.
> 
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>

One minor nitpick below but regardless of that,

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

> ---
>  drivers/acpi/bus.c      |  9 +++++++
>  drivers/acpi/internal.h |  3 +++
>  drivers/acpi/scan.c     | 68 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/acpi/sysfs.c    |  6 ++---
>  include/linux/acpi.h    | 18 +++++++++++++
>  5 files changed, 99 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> index 262ca31..97e270e 100644
> --- a/drivers/acpi/bus.c
> +++ b/drivers/acpi/bus.c
> @@ -990,6 +990,13 @@ void __init acpi_subsystem_init(void)
>  	}
>  }
>  
> +static acpi_status acpi_bus_table_handler(u32 event, void *table, void *context)
> +{
> +	acpi_scan_table_handler(event, table, context);
> +
> +	return acpi_sysfs_table_handler(event, table, context);
> +}
> +
>  static int __init acpi_bus_init(void)
>  {
>  	int result;
> @@ -1043,6 +1050,8 @@ static int __init acpi_bus_init(void)
>  	 * _PDC control method may load dynamic SSDT tables,
>  	 * and we need to install the table handler before that.
>  	 */
> +	status = acpi_install_table_handler(acpi_bus_table_handler, NULL);
> +
>  	acpi_sysfs_init();
>  
>  	acpi_early_processor_set_pdc();
> diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
> index 27cc7fe..940218f 100644
> --- a/drivers/acpi/internal.h
> +++ b/drivers/acpi/internal.h
> @@ -87,6 +87,9 @@ bool acpi_queue_hotplug_work(struct work_struct *work);
>  void acpi_device_hotplug(struct acpi_device *adev, u32 src);
>  bool acpi_scan_is_offline(struct acpi_device *adev, bool uevent);
>  
> +acpi_status acpi_sysfs_table_handler(u32 event, void *table, void *context);
> +void acpi_scan_table_handler(u32 event, void *table, void *context);
> +
>  /* --------------------------------------------------------------------------
>                       Device Node Initialization / Removal
>     -------------------------------------------------------------------------- */
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index f80f8a7..6a9b5cb 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -494,6 +494,8 @@ static void acpi_device_del(struct acpi_device *device)
>  	device_del(&device->dev);
>  }
>  
> +static BLOCKING_NOTIFIER_HEAD(acpi_reconfig_chain);
> +
>  static LIST_HEAD(acpi_device_del_list);
>  static DEFINE_MUTEX(acpi_device_del_lock);
>  
> @@ -514,6 +516,9 @@ static void acpi_device_del_work_fn(struct work_struct *work_not_used)
>  
>  		mutex_unlock(&acpi_device_del_lock);
>  
> +		blocking_notifier_call_chain(&acpi_reconfig_chain,
> +					     ACPI_RECONFIG_DEVICE_REMOVE, adev);
> +
>  		acpi_device_del(adev);
>  		/*
>  		 * Drop references to all power resources that might have been
> @@ -1676,7 +1681,7 @@ static void acpi_default_enumeration(struct acpi_device *device)
>  	bool is_spi_i2c_slave = false;
>  
>  	/*
> -	 * Do not enemerate SPI/I2C slaves as they will be enuerated by their
> +	 * Do not enemerate SPI/I2C slaves as they will be enumerated by their

You could fix the other typo here while you are there

	enemerate -> enumerate
