From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH V8 05/10] acpi: apei: handle SEA notification type for
 ARMv8
Date: Fri, 03 Feb 2017 16:00:55 +0000
Message-ID: <5894A937.5010603@arm.com>
References: <1485969413-23577-1-git-send-email-tbaicar@codeaurora.org>
 <1485969413-23577-6-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1485969413-23577-6-git-send-email-tbaicar@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Tyler Baicar <tbaicar@codeaurora.org>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawei.com
List-Id: linux-efi@vger.kernel.org

Hi Tyler,

On 01/02/17 17:16, Tyler Baicar wrote:
> ARM APEI extension proposal added SEA (Synchronous External Abort)
> notification type for ARMv8.
> Add a new GHES error source handling function for SEA. If an error
> source's notification type is SEA, then this function can be registered
> into the SEA exception handler. That way GHES will parse and report
> SEA exceptions when they occur.

It's worth adding details of the other things this patch changes, just to alert
busy reviewers, something like:
An SEA can interrupt code that had interrupts masked and is treated as an NMI.
To aid this the page of address space for mapping APEI buffers while in_nmi() is
always reserved, and ghes_ioremap_pfn_nmi() is changed to use the helper methods
to find the prot_t to map with in the same way as ghes_ioremap_pfn_irq().


> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 1117421..f92778d 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -53,6 +53,8 @@ config ARM64
>  	select HANDLE_DOMAIN_IRQ
>  	select HARDIRQS_SW_RESEND
>  	select HAVE_ACPI_APEI if (ACPI && EFI)
> +	select HAVE_ACPI_APEI_SEA if (ACPI && EFI)

> +	select HAVE_NMI if HAVE_ACPI_APEI_SEA

Nit: This section of the file is largely in alphabetical order, can we try to
keep it that way?!


>  	select HAVE_ALIGNED_STRUCT_PAGE if SLUB
>  	select HAVE_ARCH_AUDITSYSCALL
>  	select HAVE_ARCH_BITREVERSE
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 9ae7e65..5a5a096 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -30,6 +30,7 @@
>  #include <linux/highmem.h>
>  #include <linux/perf_event.h>
>  #include <linux/preempt.h>

> +#include <linux/hardirq.h>

This header is already included by this file further up.


>  
>  #include <asm/bug.h>
>  #include <asm/cpufeature.h>
> @@ -41,6 +42,8 @@
>  #include <asm/pgtable.h>
>  #include <asm/tlbflush.h>
>  
> +#include <acpi/ghes.h>
> +
>  static const char *fault_name(unsigned int esr);
>  
>  #ifdef CONFIG_KPROBES
> @@ -500,6 +503,14 @@ static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>  	pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
>  		 fault_name(esr), esr, addr);
>  

> +	/*
> +	 * synchronize_rcu() will wait for nmi_exit(), so no need to
> +	 * rcu_read_lock().
> +	 */

This comment should go against the use of RCU in ghes_notify_sea(), but there
should be something here to explain the surprise use of nmi. Something like:
Synchronous aborts may interrupt code which had interrupts masked. Before
calling out into the wider kernel tell the interested subsystems.


This should be wrapped in:
if (IS_ENABLED(HAVE_ACPI_APEI_SEA)) {

> +	nmi_enter();
> +	ghes_notify_sea();
> +	nmi_exit();

}

To avoid breaking systems that don't have SEA configured.


> +
>  	info.si_signo = SIGBUS;
>  	info.si_errno = 0;
>  	info.si_code  = 0;
> diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
> index b0140c8..3786ff1 100644
> --- a/drivers/acpi/apei/Kconfig
> +++ b/drivers/acpi/apei/Kconfig
> @@ -4,6 +4,20 @@ config HAVE_ACPI_APEI
>  config HAVE_ACPI_APEI_NMI
>  	bool
>  
> +config HAVE_ACPI_APEI_SEA
> +	bool "APEI Synchronous External Abort logging/recovering support"
> +	depends on ARM64

depends on CONFIG_ACPI_APEI_GHES
?

(I think this is what the kbuild robot has managed to miss out!)


> +	help
> +	  This option should be enabled if the system supports
> +	  firmware first handling of SEA (Synchronous External Abort).
> +	  SEA happens with certain faults of data abort or instruction
> +	  abort synchronous exceptions on ARMv8 systems. If a system
> +	  supports firmware first handling of SEA, the platform analyzes
> +	  and handles hardware error notifications with SEA, and it may then

Nit: notifications from SEA,


> +	  form a HW error record for the OS to parse and handle. This
> +	  option allows the OS to look for such HW error record, and

Nit: 'HW'->hardware. This is spelled out for the other seven uses in the file.


> +	  take appropriate action.
> +
>  config ACPI_APEI
>  	bool "ACPI Platform Error Interface (APEI)"
>  	select MISC_FILESYSTEMS
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index b25e7cf..8756172 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -114,11 +114,7 @@
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
> @@ -156,11 +152,14 @@ static void ghes_ioremap_exit(void)
>  
>  static void __iomem *ghes_ioremap_pfn_nmi(u64 pfn)
>  {
> -	unsigned long vaddr;
> +	unsigned long vaddr, paddr;
> +	pgprot_t prot;
>  
>  	vaddr = (unsigned long)GHES_IOREMAP_NMI_PAGE(ghes_ioremap_area->addr);
> -	ioremap_page_range(vaddr, vaddr + PAGE_SIZE,
> -			   pfn << PAGE_SHIFT, PAGE_KERNEL);
> +

> +	paddr = pfn << PAGE_SHIFT;

Physical addresses might not always fit in 'unsigned long'. phys_addr_t exists
to hide this nasty detail!

>From arch/x86/Kconfig:
> config ARCH_PHYS_ADDR_T_64BIT
> 	def_bool y
> 	depends on X86_64 || X86_PAE

32bit x86 kernels configured with PAE define phys_addr_t to be u64.


> +	prot = arch_apei_get_mem_attribute(paddr);
> +	ioremap_page_range(vaddr, vaddr + PAGE_SIZE, paddr, prot);
>  
>  	return (void __iomem *)vaddr;
>  }
> @@ -767,6 +766,48 @@ static int ghes_notify_sci(struct notifier_block *this,
>  	.notifier_call = ghes_notify_sci,
>  };
>  
> +#ifdef CONFIG_HAVE_ACPI_APEI_SEA
> +static LIST_HEAD(ghes_sea);
> +
> +void ghes_notify_sea(void)
> +{
> +	struct ghes *ghes;
> +

	/*
	 * synchronize_rcu() will wait for nmi_exit(), so no need to
	 * rcu_read_lock().
	 */

> +	list_for_each_entry_rcu(ghes, &ghes_sea, list) {
> +		ghes_proc(ghes);
> +	}
> +}
> +
> +static int ghes_sea_add(struct ghes *ghes)
> +{
> +	mutex_lock(&ghes_list_mutex);
> +	list_add_rcu(&ghes->list, &ghes_sea);
> +	mutex_unlock(&ghes_list_mutex);

> +	return 0;

This function returns 0 or -ENOTSUPP, depending on CONFIG_HAVE_ACPI_APEI_SEA,
but ...


> +}
> +
> +static void ghes_sea_remove(struct ghes *ghes)
> +{
> +	mutex_lock(&ghes_list_mutex);
> +	list_del_rcu(&ghes->list);
> +	mutex_unlock(&ghes_list_mutex);
> +	synchronize_rcu();
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
> +#endif /* CONFIG_HAVE_ACPI_APEI_SEA */
> +
>  #ifdef CONFIG_HAVE_ACPI_APEI_NMI
>  /*
>   * printk is not safe in NMI context.  So in NMI handler, we allocate
> @@ -1012,6 +1053,14 @@ static int ghes_probe(struct platform_device *ghes_dev)
>  	case ACPI_HEST_NOTIFY_EXTERNAL:
>  	case ACPI_HEST_NOTIFY_SCI:
>  		break;
> +	case ACPI_HEST_NOTIFY_SEA:
> +		if (!IS_ENABLED(CONFIG_HAVE_ACPI_APEI_SEA)) {
> +			pr_warn(GHES_PFX "Generic hardware error source: %d notified via SEA is not supported\n",
> +				generic->header.source_id);
> +			rc = -ENOTSUPP;
> +			goto err;

... here we jump out of ghes_probe() if NOTIFY_SEA is used but the kernel wasn't
built with CONFIG_HAVE_ACPI_APEI_SEA....


> +		}
> +		break;
>  	case ACPI_HEST_NOTIFY_NMI:
>  		if (!IS_ENABLED(CONFIG_HAVE_ACPI_APEI_NMI)) {
>  			pr_warn(GHES_PFX "Generic hardware error source: %d notified via NMI interrupt is not supported!\n",
> @@ -1023,6 +1072,13 @@ static int ghes_probe(struct platform_device *ghes_dev)
>  		pr_warning(GHES_PFX "Generic hardware error source: %d notified via local interrupt is not supported!\n",
>  			   generic->header.source_id);
>  		goto err;
> +	case ACPI_HEST_NOTIFY_GPIO:
> +	case ACPI_HEST_NOTIFY_SEI:
> +	case ACPI_HEST_NOTIFY_GSIV:
> +		pr_warn(GHES_PFX "Generic hardware error source: %d notified via notification type %u is not supported\n",
> +			generic->header.source_id, generic->header.source_id);
> +		rc = -ENOTSUPP;
> +		goto err;
>  	default:
>  		pr_warning(FW_WARN GHES_PFX "Unknown notification type: %u for generic hardware error source: %d\n",
>  			   generic->notify.type, generic->header.source_id);
> @@ -1077,6 +1133,11 @@ static int ghes_probe(struct platform_device *ghes_dev)
>  		list_add_rcu(&ghes->list, &ghes_sci);
>  		mutex_unlock(&ghes_list_mutex);
>  		break;
> +	case ACPI_HEST_NOTIFY_SEA:
> +		rc = ghes_sea_add(ghes);

... so this error handling will never be needed.
ghes_nmi_add() returns void.

I guess the not-configured versions of the symbols need to exist for older
compilers that can't work out that this can never be called.


> +		if (rc)
> +			goto err_edac_unreg;
> +		break;
>  	case ACPI_HEST_NOTIFY_NMI:
>  		ghes_nmi_add(ghes);
>  		break;
> @@ -1119,6 +1180,9 @@ static int ghes_remove(struct platform_device *ghes_dev)
>  			unregister_acpi_hed_notifier(&ghes_notifier_sci);
>  		mutex_unlock(&ghes_list_mutex);
>  		break;
> +	case ACPI_HEST_NOTIFY_SEA:
> +		ghes_sea_remove(ghes);
> +		break;
>  	case ACPI_HEST_NOTIFY_NMI:
>  		ghes_nmi_remove(ghes);
>  		break;

> diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
> index 6ae318b..adf5455 100644
> --- a/include/acpi/ghes.h
> +++ b/include/acpi/ghes.h
> @@ -95,3 +95,5 @@ static inline void *acpi_hest_generic_data_payload(struct acpi_hest_generic_data
>  		(void *)(((struct acpi_hest_generic_data_v300 *)(gdata)) + 1) :
>  		gdata + 1;
>  }
> +
> +void ghes_notify_sea(void);
> 

This header file ought to have an include guard, could you add one?

I think the kbuild-robot has managed to configure SEA on, but GHES off so ghes.c
isn't included in the kernel. I will dig some more into this on Monday.



Thanks,

James
