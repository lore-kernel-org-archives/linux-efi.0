From: Xiongfeng Wang <wangxiongfeng2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V15 06/11] acpi: apei: handle SEA notification type for
 ARMv8
Date: Mon, 14 Aug 2017 15:55:12 +0800
Message-ID: <6a5ef607-ac92-a616-8e60-06c4e51bba04__25147.2487849698$1502697563$gmane$org@huawei.com>
References: <1492556723-9189-1-git-send-email-tbaicar@codeaurora.org>
 <1492556723-9189-7-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492556723-9189-7-git-send-email-tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, james.morse-5wv7dgnIgG8@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, eun.taik.lee-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, sandeepa.s.prabhu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, shijie.huang-5wv7dgnIgG8@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, tn-nYOzD4b6Jr9Wk0Htik3J/w@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm@vg
List-Id: linux-efi@vger.kernel.org

Hi Tyler,

On 2017/4/19 7:05, Tyler Baicar wrote:
> ARM APEI extension proposal added SEA (Synchronous External Abort)
> notification type for ARMv8.
> Add a new GHES error source handling function for SEA. If an error
> source's notification type is SEA, then this function can be registered
> into the SEA exception handler. That way GHES will parse and report
> SEA exceptions when they occur.
> An SEA can interrupt code that had interrupts masked and is treated as
> an NMI. To aid this the page of address space for mapping APEI buffers
> while in_nmi() is always reserved, and ghes_ioremap_pfn_nmi() is
> changed to use the helper methods to find the prot_t to map with in
> the same way as ghes_ioremap_pfn_irq().
> 
> Signed-off-by: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> CC: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Reviewed-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
> Acked-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
> ---

> @@ -518,6 +520,17 @@ static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>  	pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
>  		inf->name, esr, addr);
>  
> +	/*
> +	 * Synchronous aborts may interrupt code which had interrupts masked.
> +	 * Before calling out into the wider kernel tell the interested
> +	 * subsystems.
> +	 */
> +	if (IS_ENABLED(CONFIG_ACPI_APEI_SEA)) {
> +		nmi_enter();
> +		ghes_notify_sea();
> +		nmi_exit();
> +	}
> +
>  	info.si_signo = SIGBUS;
>  	info.si_errno = 0;
>  	info.si_code  = 0;
For instruction abort, if there exists memory section in ghes, we will call memory_failure() in ghes_notify_sea()
and reread the instruction from the disk. In this case, we don't have to send SIGBUS to the application.
But memory_failure() is scheduled in a work queue, we don't what the result of memory_failure will be when ghes_notify_sea() returned.
Do you have any idea about how to fix this, so we don't have to kill the application in the instruction abort case.

Thanks,
Wang Xiongfeng


> diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
> index b0140c8..de14d49 100644
> --- a/drivers/acpi/apei/Kconfig
> +++ b/drivers/acpi/apei/Kconfig
> @@ -39,6 +39,21 @@ config ACPI_APEI_PCIEAER
>  	  PCIe AER errors may be reported via APEI firmware first mode.
>  	  Turn on this option to enable the corresponding support.
>  
> +config ACPI_APEI_SEA
> +	bool "APEI Synchronous External Abort logging/recovering support"
> +	depends on ARM64 && ACPI_APEI_GHES
> +	default y
> +	help
> +	  This option should be enabled if the system supports
> +	  firmware first handling of SEA (Synchronous External Abort).
> +	  SEA happens with certain faults of data abort or instruction
> +	  abort synchronous exceptions on ARMv8 systems. If a system
> +	  supports firmware first handling of SEA, the platform analyzes
> +	  and handles hardware error notifications from SEA, and it may then
> +	  form a HW error record for the OS to parse and handle. This
> +	  option allows the OS to look for such hardware error record, and
> +	  take appropriate action.
> +
>  config ACPI_APEI_MEMORY_FAILURE
>  	bool "APEI memory error recovering support"
>  	depends on ACPI_APEI && MEMORY_FAILURE
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index dfb7dd2..2d387f8 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -115,11 +115,7 @@
>   * Two virtual pages are used, one for IRQ/PROCESS context, the other for
>   * NMI context (optionally).
>   */
> -#ifdef CONFIG_HAVE_ACPI_APEI_NMI
>  #define GHES_IOREMAP_PAGES           2
> -#else
> -#define GHES_IOREMAP_PAGES           1
> -#endif
>  #define GHES_IOREMAP_IRQ_PAGE(base)	(base)
>  #define GHES_IOREMAP_NMI_PAGE(base)	((base) + PAGE_SIZE)
>  
> @@ -158,10 +154,14 @@ static void ghes_ioremap_exit(void)
>  static void __iomem *ghes_ioremap_pfn_nmi(u64 pfn)
>  {
>  	unsigned long vaddr;
> +	phys_addr_t paddr;
> +	pgprot_t prot;
>  
>  	vaddr = (unsigned long)GHES_IOREMAP_NMI_PAGE(ghes_ioremap_area->addr);
> -	ioremap_page_range(vaddr, vaddr + PAGE_SIZE,
> -			   pfn << PAGE_SHIFT, PAGE_KERNEL);
> +
> +	paddr = pfn << PAGE_SHIFT;
> +	prot = arch_apei_get_mem_attribute(paddr);
> +	ioremap_page_range(vaddr, vaddr + PAGE_SIZE, paddr, prot);
>  
>  	return (void __iomem *)vaddr;
>  }
> @@ -771,6 +771,50 @@ static int ghes_notify_sci(struct notifier_block *this,
>  	.notifier_call = ghes_notify_sci,
>  };
>  
> +#ifdef CONFIG_ACPI_APEI_SEA
> +static LIST_HEAD(ghes_sea);
> +
> +void ghes_notify_sea(void)
> +{
> +	struct ghes *ghes;
> +
> +	/*
> +	 * synchronize_rcu() will wait for nmi_exit(), so no need to
> +	 * rcu_read_lock().
> +	 */
> +	list_for_each_entry_rcu(ghes, &ghes_sea, list) {
> +		ghes_proc(ghes);
> +	}
> +}
> +
> +static void ghes_sea_add(struct ghes *ghes)
> +{
> +	mutex_lock(&ghes_list_mutex);
> +	list_add_rcu(&ghes->list, &ghes_sea);
> +	mutex_unlock(&ghes_list_mutex);
> +}
> +
> +static void ghes_sea_remove(struct ghes *ghes)
> +{
> +	mutex_lock(&ghes_list_mutex);
> +	list_del_rcu(&ghes->list);
> +	mutex_unlock(&ghes_list_mutex);
> +	synchronize_rcu();
> +}
> +#else /* CONFIG_ACPI_APEI_SEA */
> +static inline void ghes_sea_add(struct ghes *ghes)
> +{
> +	pr_err(GHES_PFX "ID: %d, trying to add SEA notification which is not supported\n",
> +	       ghes->generic->header.source_id);
> +}
> +
> +static inline void ghes_sea_remove(struct ghes *ghes)
> +{
> +	pr_err(GHES_PFX "ID: %d, trying to remove SEA notification which is not supported\n",
> +	       ghes->generic->header.source_id);
> +}
> +#endif /* CONFIG_ACPI_APEI_SEA */
> +
>  #ifdef CONFIG_HAVE_ACPI_APEI_NMI
>  /*
>   * printk is not safe in NMI context.  So in NMI handler, we allocate
> @@ -1016,6 +1060,14 @@ static int ghes_probe(struct platform_device *ghes_dev)
>  	case ACPI_HEST_NOTIFY_EXTERNAL:
>  	case ACPI_HEST_NOTIFY_SCI:
>  		break;
> +	case ACPI_HEST_NOTIFY_SEA:
> +		if (!IS_ENABLED(CONFIG_ACPI_APEI_SEA)) {
> +			pr_warn(GHES_PFX "Generic hardware error source: %d notified via SEA is not supported\n",
> +				generic->header.source_id);
> +			rc = -ENOTSUPP;
> +			goto err;
> +		}
> +		break;
>  	case ACPI_HEST_NOTIFY_NMI:
>  		if (!IS_ENABLED(CONFIG_HAVE_ACPI_APEI_NMI)) {
>  			pr_warn(GHES_PFX "Generic hardware error source: %d notified via NMI interrupt is not supported!\n",
> @@ -1081,6 +1133,9 @@ static int ghes_probe(struct platform_device *ghes_dev)
>  		list_add_rcu(&ghes->list, &ghes_sci);
>  		mutex_unlock(&ghes_list_mutex);
>  		break;
> +	case ACPI_HEST_NOTIFY_SEA:
> +		ghes_sea_add(ghes);
> +		break;
>  	case ACPI_HEST_NOTIFY_NMI:
>  		ghes_nmi_add(ghes);
>  		break;
> @@ -1124,6 +1179,9 @@ static int ghes_remove(struct platform_device *ghes_dev)
>  		mutex_unlock(&ghes_list_mutex);
>  		synchronize_rcu();
>  		break;
> +	case ACPI_HEST_NOTIFY_SEA:
> +		ghes_sea_remove(ghes);
> +		break;
>  	case ACPI_HEST_NOTIFY_NMI:
>  		ghes_nmi_remove(ghes);
>  		break;
> diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
> index b89361a..ef0040893 100644
> --- a/include/acpi/ghes.h
> +++ b/include/acpi/ghes.h
> @@ -1,3 +1,6 @@
> +#ifndef GHES_H
> +#define GHES_H
> +
>  #include <acpi/apei.h>
>  #include <acpi/hed.h>
>  
> @@ -95,3 +98,7 @@ static inline void *acpi_hest_get_payload(struct acpi_hest_generic_data *gdata)
>  
>  	return gdata + 1;
>  }
> +
> +void ghes_notify_sea(void);
> +
> +#endif /* GHES_H */
> 
