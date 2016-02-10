From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH V1 6/6] acpi: apei: handle SEA notification type for ARMv8
Date: Wed, 10 Feb 2016 18:03:33 +0000
Message-ID: <20160210180332.GU1052@arm.com>
References: <1454699608-22760-1-git-send-email-tbaicar@codeaurora.org>
 <1454699608-22760-7-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454699608-22760-7-git-send-email-tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, harba-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, ahs3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Robert Moore <robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lv Zheng <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-E0kO6a4B6psdnm+yROfE0A@public.gmane.org, Naveen Kaje <nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Feb 05, 2016 at 12:13:28PM -0700, Tyler Baicar wrote:
> ARM APEI extension proposal added SEA (Synchrounous External
> Abort) notification type for ARMv8.
> 
> Add a new GHES error source handling function for SEA. If an error
> source's notification type is SEA, then this function can be registered
> into the SEA exception handler. That way GHES will parse and report
> SEA exceptions when they occur.
> 
> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Signed-off-by: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Signed-off-by: Naveen Kaje <nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> ---
>  arch/arm64/Kconfig        |  1 +
>  drivers/acpi/apei/Kconfig | 13 ++++++++
>  drivers/acpi/apei/ghes.c  | 83 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/acpi/actbl1.h     |  6 +++-
>  4 files changed, 102 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 6e4a4f4..236f398 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -6,6 +6,7 @@ config ARM64
>  	select ACPI_REDUCED_HARDWARE_ONLY if ACPI
>  	select ARCH_HAS_DEVMEM_IS_ALLOWED
>  	select HAVE_ACPI_APEI if ACPI
> +	select HAVE_ACPI_APEI_SEA if ACPI
>  	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
>  	select ARCH_HAS_ELF_RANDOMIZE
>  	select ARCH_HAS_GCOV_PROFILE_ALL
> diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
> index a60bb00..bfcbb9e 100644
> --- a/drivers/acpi/apei/Kconfig
> +++ b/drivers/acpi/apei/Kconfig
> @@ -7,6 +7,19 @@ config HAVE_ACPI_APEI_NMI
>  config HAVE_ACPI_APEI_HEST_IA32
>  	bool
>  
> +config HAVE_ACPI_APEI_SEA
> +	bool "APEI Synchronous External Abort logging/recovering support"
> +	help
> +	  This option should be enabled if the system supports
> +	  firmware first handling of SEA (Synchronous External Abort).
> +	  SEA happens with certain faults of data abort or instruction
> +	  abort synchronous exceptions on ARMv8 systems. If a system
> +	  supports firmware first handling of SEA, the platform analyzes
> +	  and handles hardware error notifications with SEA, and it may then
> +	  form a HW error record for the OS to parse and handle. This
> +	  option allows the OS to look for such HW error record, and
> +	  take appropriate action.
> +
>  config ACPI_APEI
>  	bool "ACPI Platform Error Interface (APEI)"
>  	select MISC_FILESYSTEMS
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 6c68100..ed64b97 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -50,6 +50,10 @@
>  #include <acpi/apei.h>
>  #include <asm/tlbflush.h>
>  
> +#ifdef CONFIG_HAVE_ACPI_APEI_SEA
> +#include <asm/system_misc.h>
> +#endif
> +
>  #include "apei-internal.h"
>  
>  #define GHES_PFX	"GHES: "
> @@ -784,6 +788,62 @@ static struct notifier_block ghes_notifier_sci = {
>  	.notifier_call = ghes_notify_sci,
>  };
>  
> +#ifdef CONFIG_HAVE_ACPI_APEI_SEA
> +static LIST_HEAD(ghes_sea);
> +
> +static int ghes_notify_sea(struct notifier_block *this,
> +				  unsigned long event, void *data)
> +{
> +	struct ghes *ghes;
> +	int ret = NOTIFY_DONE;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(ghes, &ghes_sea, list) {
> +		if (!ghes_proc(ghes))
> +			ret = NOTIFY_OK;
> +	}
> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> +
> +static struct notifier_block ghes_notifier_sea = {
> +	.notifier_call = ghes_notify_sea,
> +};
> +
> +static int ghes_sea_add(struct ghes *ghes)
> +{
> +	mutex_lock(&ghes_list_mutex);

Can you just use spin_lock, to be consistent with our other excception
hooks?

> +	if (list_empty(&ghes_sea))
> +		sea_register_handler_chain(&ghes_notifier_sea);
> +	list_add_rcu(&ghes->list, &ghes_sea);
> +	mutex_unlock(&ghes_list_mutex);
> +	return 0;
> +}
> +
> +static void ghes_sea_remove(struct ghes *ghes)
> +{
> +	mutex_lock(&ghes_list_mutex);
> +	list_del_rcu(&ghes->list);
> +	if (list_empty(&ghes_sea))
> +		sea_unregister_handler_chain(&ghes_notifier_sea);
> +	mutex_unlock(&ghes_list_mutex);
> +}
> +#else /* CONFIG_HAVE_ACPI_APEI_SEA */
> +static inline int ghes_sea_add(struct ghes *ghes)
> +{
> +	pr_err(GHES_PFX "ID: %d, trying to add SEA notification which is not supported\n",
> +	       ghes->generic->header.source_id);
> +	return -ENOTSUPP;
> +}
> +
> +static inline void ghes_sea_remove(struct ghes *ghes)
> +{
> +	pr_err(GHES_PFX "ID: %d, trying to remove SEA notification which is not supported\n",
> +	       ghes->generic->header.source_id);
> +}

Why are these getting called if !CONFIG_HAVE_ACPI_APEI_SEA?

Will
