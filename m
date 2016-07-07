From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH v5 7/8] acpi: add support for configfs
Date: Thu, 7 Jul 2016 12:39:35 +0300
Message-ID: <20160707093935.GP23527@lahna.fi.intel.com>
References: <1467404352-27101-1-git-send-email-octavian.purdila@intel.com>
 <1467404352-27101-8-git-send-email-octavian.purdila@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1467404352-27101-8-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, leonard.crestez@intel.com
List-Id: linux-efi@vger.kernel.org

On Fri, Jul 01, 2016 at 11:19:11PM +0300, Octavian Purdila wrote:
> Register the ACPI subsystem with configfs.
> 
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>

Couple of nitpicks below but regardless of those,

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

> ---
>  Documentation/ABI/testing/configfs-acpi |  7 +++++
>  MAINTAINERS                             |  1 +
>  drivers/acpi/Kconfig                    |  9 ++++++
>  drivers/acpi/Makefile                   |  1 +
>  drivers/acpi/configfs.c                 | 53 +++++++++++++++++++++++++++++++++
>  5 files changed, 71 insertions(+)
>  create mode 100644 Documentation/ABI/testing/configfs-acpi
>  create mode 100644 drivers/acpi/configfs.c
> 
> diff --git a/Documentation/ABI/testing/configfs-acpi b/Documentation/ABI/testing/configfs-acpi
> new file mode 100644
> index 0000000..17b19dc
> --- /dev/null
> +++ b/Documentation/ABI/testing/configfs-acpi
> @@ -0,0 +1,7 @@
> +What:		/config/acpi
> +Date:		July 2016
> +KernelVersion:	4.8
> +Contact:	linux-acpi@vger.kernel.org
> +Description:
> +		This represents the ACPI subsystem entry point directory. It
> +		contains sub-groups corresponding to ACPI configurable options.
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 16700e4..9c5365f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -288,6 +288,7 @@ F:	include/linux/acpi.h
>  F:	include/acpi/
>  F:	Documentation/acpi/
>  F:	Documentation/ABI/testing/sysfs-bus-acpi
> +F:	Documentation/ABI/testing/configfs-acpi
>  F:	drivers/pci/*acpi*
>  F:	drivers/pci/*/*acpi*
>  F:	drivers/pci/*/*/*acpi*
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index b7e2e77..a039433 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -521,4 +521,13 @@ config XPOWER_PMIC_OPREGION
>  
>  endif
>  
> +config ACPI_CONFIGFS
> +	tristate "ACPI configfs support"
> +	select CONFIGFS_FS
> +	default n

We default to n so this is not needed.

> +	help
> +	  Select this option to enable support for ACPI configuration from
> +	  userspace. The configurable ACPI groups will be visible under
> +	  /config/acpi, assuming configfs is mounted under /config.
> +
>  endif	# ACPI
> diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> index 251ce85..1dc2173 100644
> --- a/drivers/acpi/Makefile
> +++ b/drivers/acpi/Makefile
> @@ -99,5 +99,6 @@ obj-$(CONFIG_ACPI_EXTLOG)	+= acpi_extlog.o
>  obj-$(CONFIG_PMIC_OPREGION)	+= pmic/intel_pmic.o
>  obj-$(CONFIG_CRC_PMIC_OPREGION) += pmic/intel_pmic_crc.o
>  obj-$(CONFIG_XPOWER_PMIC_OPREGION) += pmic/intel_pmic_xpower.o
> +obj-$(CONFIG_ACPI_CONFIGFS)	+= configfs.o
>  
>  video-objs			+= acpi_video.o video_detect.o
> diff --git a/drivers/acpi/configfs.c b/drivers/acpi/configfs.c
> new file mode 100644
> index 0000000..44a72ff
> --- /dev/null
> +++ b/drivers/acpi/configfs.c
> @@ -0,0 +1,53 @@
> +/*
> + * ACPI configfs support
> + *
> + * Copyright (c) 2015 Intel Corporation

It is 2016 now.
