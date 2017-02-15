From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V8 05/10] acpi: apei: handle SEA notification type for
 ARMv8
Date: Wed, 15 Feb 2017 07:58:57 -0700
Message-ID: <f53fd8a5-cee1-c1e0-28f5-0e85ed6b5368@codeaurora.org>
References: <1485969413-23577-1-git-send-email-tbaicar@codeaurora.org>
 <1485969413-23577-6-git-send-email-tbaicar@codeaurora.org>
 <58A3F431.9040808@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <58A3F431.9040808@huawei.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Zhengqiang <zhengqiang10@huawei.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Hello Zhengqiang,


On 2/14/2017 11:24 PM, Zhengqiang wrote:
> Hi Tyler:
>
> On 2017/2/2 1:16, Tyler Baicar wrote:
>> ARM APEI extension proposal added SEA (Synchronous External Abort)
>> notification type for ARMv8.
>> Add a new GHES error source handling function for SEA. If an error
>> source's notification type is SEA, then this function can be registered
>> into the SEA exception handler. That way GHES will parse and report
>> SEA exceptions when they occur.
>>
>> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
>> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
>> Signed-off-by: Naveen Kaje <nkaje@codeaurora.org>
>> ---
>>   arch/arm64/Kconfig        |  2 ++
>>   arch/arm64/mm/fault.c     | 11 +++++++
>>   drivers/acpi/apei/Kconfig | 14 +++++++++
>>   drivers/acpi/apei/ghes.c  | 78 ++++++++++++++++++++++++++++++++++++++++++-----
>>   include/acpi/ghes.h       |  2 ++
>>   5 files changed, 100 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 1117421..f92778d 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -53,6 +53,8 @@ config ARM64
>>   	select HANDLE_DOMAIN_IRQ
>>   	select HARDIRQS_SW_RESEND
>>   	select HAVE_ACPI_APEI if (ACPI && EFI)
>> +	select HAVE_ACPI_APEI_SEA if (ACPI && EFI)
>> +	select HAVE_NMI if HAVE_ACPI_APEI_SEA
>>   	select HAVE_ALIGNED_STRUCT_PAGE if SLUB
>>   	select HAVE_ARCH_AUDITSYSCALL
>>   	select HAVE_ARCH_BITREVERSE
>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>> index 9ae7e65..5a5a096 100644
>> --- a/arch/arm64/mm/fault.c
>> +++ b/arch/arm64/mm/fault.c
>> @@ -30,6 +30,7 @@
>>   #include <linux/highmem.h>
>>   #include <linux/perf_event.h>
>>   #include <linux/preempt.h>
>> +#include <linux/hardirq.h>
>>   
>>   #include <asm/bug.h>
>>   #include <asm/cpufeature.h>
>> @@ -41,6 +42,8 @@
>>   #include <asm/pgtable.h>
>>   #include <asm/tlbflush.h>
>>   
>> +#include <acpi/ghes.h>
>> +
>>   static const char *fault_name(unsigned int esr);
>>   
>>   #ifdef CONFIG_KPROBES
>> @@ -500,6 +503,14 @@ static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>>   	pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
>>   		 fault_name(esr), esr, addr);
>>   
>> +	/*
>> +	 * synchronize_rcu() will wait for nmi_exit(), so no need to
>> +	 * rcu_read_lock().
>> +	 */
>> +	nmi_enter();
>> +	ghes_notify_sea();
>> +	nmi_exit();
>> +
> For fatal error:
> ghes_notify_sea() -> ghes_proc() -> __ghes_call_panic(),cause panic;
> do_sea() function also call arm64_notify_die(), will cause panic too;
> Does it can happen, panic will be called twice ?
Since the panic function never returns, it isn't possible to call it 
twice. ghes_proc will only
cause a panic if the severity of the error is GHES_SEV_PANIC, so it's 
possible that we call
panic from either the GHES code or from arm64_notify_die() depending on 
the error.

Thanks,
Tyler
>>   	info.si_signo = SIGBUS;
>>   	info.si_errno = 0;
>>   	info.si_code  = 0;
>> diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
>> index b0140c8..3786ff1 100644
>> --- a/drivers/acpi/apei/Kconfig
>> +++ b/drivers/acpi/apei/Kconfig
>> @@ -4,6 +4,20 @@ config HAVE_ACPI_APEI
>>   config HAVE_ACPI_APEI_NMI
>>   	bool
>>   
>> +config HAVE_ACPI_APEI_SEA
>> +	bool "APEI Synchronous External Abort logging/recovering support"
>> +	depends on ARM64
>> +	help
>> +	  This option should be enabled if the system supports
>> +	  firmware first handling of SEA (Synchronous External Abort).
>> +	  SEA happens with certain faults of data abort or instruction
>> +	  abort synchronous exceptions on ARMv8 systems. If a system
>> +	  supports firmware first handling of SEA, the platform analyzes
>> +	  and handles hardware error notifications with SEA, and it may then
>> +	  form a HW error record for the OS to parse and handle. This
>> +	  option allows the OS to look for such HW error record, and
>> +	  take appropriate action.
>> +
>>   config ACPI_APEI
>>   	bool "ACPI Platform Error Interface (APEI)"
>>   	select MISC_FILESYSTEMS
>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
>> index b25e7cf..8756172 100644
>> --- a/drivers/acpi/apei/ghes.c
>> +++ b/drivers/acpi/apei/ghes.c
>> @@ -114,11 +114,7 @@
>>    * Two virtual pages are used, one for IRQ/PROCESS context, the other for
>>    * NMI context (optionally).
>>    */
>> -#ifdef CONFIG_HAVE_ACPI_APEI_NMI
>>   #define GHES_IOREMAP_PAGES           2
>> -#else
>> -#define GHES_IOREMAP_PAGES           1
>> -#endif
>>   #define GHES_IOREMAP_IRQ_PAGE(base)	(base)
>>   #define GHES_IOREMAP_NMI_PAGE(base)	((base) + PAGE_SIZE)
>>   
>> @@ -156,11 +152,14 @@ static void ghes_ioremap_exit(void)
>>   
>>   static void __iomem *ghes_ioremap_pfn_nmi(u64 pfn)
>>   {
>> -	unsigned long vaddr;
>> +	unsigned long vaddr, paddr;
>> +	pgprot_t prot;
>>   
>>   	vaddr = (unsigned long)GHES_IOREMAP_NMI_PAGE(ghes_ioremap_area->addr);
>> -	ioremap_page_range(vaddr, vaddr + PAGE_SIZE,
>> -			   pfn << PAGE_SHIFT, PAGE_KERNEL);
>> +
>> +	paddr = pfn << PAGE_SHIFT;
>> +	prot = arch_apei_get_mem_attribute(paddr);
>> +	ioremap_page_range(vaddr, vaddr + PAGE_SIZE, paddr, prot);
>>   
>>   	return (void __iomem *)vaddr;
>>   }
>> @@ -767,6 +766,48 @@ static int ghes_notify_sci(struct notifier_block *this,
>>   	.notifier_call = ghes_notify_sci,
>>   };
>>   
>> +#ifdef CONFIG_HAVE_ACPI_APEI_SEA
>> +static LIST_HEAD(ghes_sea);
>> +
>> +void ghes_notify_sea(void)
>> +{
>> +	struct ghes *ghes;
>> +
>> +	list_for_each_entry_rcu(ghes, &ghes_sea, list) {
>> +		ghes_proc(ghes);
>> +	}
>> +}
>> +
>> +static int ghes_sea_add(struct ghes *ghes)
>> +{
>> +	mutex_lock(&ghes_list_mutex);
>> +	list_add_rcu(&ghes->list, &ghes_sea);
>> +	mutex_unlock(&ghes_list_mutex);
>> +	return 0;
>> +}
>> +
>> +static void ghes_sea_remove(struct ghes *ghes)
>> +{
>> +	mutex_lock(&ghes_list_mutex);
>> +	list_del_rcu(&ghes->list);
>> +	mutex_unlock(&ghes_list_mutex);
>> +	synchronize_rcu();
>> +}
>> +#else /* CONFIG_HAVE_ACPI_APEI_SEA */
>> +static inline int ghes_sea_add(struct ghes *ghes)
>> +{
>> +	pr_err(GHES_PFX "ID: %d, trying to add SEA notification which is not supported\n",
>> +	       ghes->generic->header.source_id);
>> +	return -ENOTSUPP;
>> +}
>> +
>> +static inline void ghes_sea_remove(struct ghes *ghes)
>> +{
>> +	pr_err(GHES_PFX "ID: %d, trying to remove SEA notification which is not supported\n",
>> +	       ghes->generic->header.source_id);
>> +}
>> +#endif /* CONFIG_HAVE_ACPI_APEI_SEA */
>> +
>>   #ifdef CONFIG_HAVE_ACPI_APEI_NMI
>>   /*
>>    * printk is not safe in NMI context.  So in NMI handler, we allocate
>> @@ -1012,6 +1053,14 @@ static int ghes_probe(struct platform_device *ghes_dev)
>>   	case ACPI_HEST_NOTIFY_EXTERNAL:
>>   	case ACPI_HEST_NOTIFY_SCI:
>>   		break;
>> +	case ACPI_HEST_NOTIFY_SEA:
>> +		if (!IS_ENABLED(CONFIG_HAVE_ACPI_APEI_SEA)) {
>> +			pr_warn(GHES_PFX "Generic hardware error source: %d notified via SEA is not supported\n",
>> +				generic->header.source_id);
>> +			rc = -ENOTSUPP;
>> +			goto err;
>> +		}
>> +		break;
>>   	case ACPI_HEST_NOTIFY_NMI:
>>   		if (!IS_ENABLED(CONFIG_HAVE_ACPI_APEI_NMI)) {
>>   			pr_warn(GHES_PFX "Generic hardware error source: %d notified via NMI interrupt is not supported!\n",
>> @@ -1023,6 +1072,13 @@ static int ghes_probe(struct platform_device *ghes_dev)
>>   		pr_warning(GHES_PFX "Generic hardware error source: %d notified via local interrupt is not supported!\n",
>>   			   generic->header.source_id);
>>   		goto err;
>> +	case ACPI_HEST_NOTIFY_GPIO:
>> +	case ACPI_HEST_NOTIFY_SEI:
>> +	case ACPI_HEST_NOTIFY_GSIV:
>> +		pr_warn(GHES_PFX "Generic hardware error source: %d notified via notification type %u is not supported\n",
>> +			generic->header.source_id, generic->header.source_id);
>> +		rc = -ENOTSUPP;
>> +		goto err;
>>   	default:
>>   		pr_warning(FW_WARN GHES_PFX "Unknown notification type: %u for generic hardware error source: %d\n",
>>   			   generic->notify.type, generic->header.source_id);
>> @@ -1077,6 +1133,11 @@ static int ghes_probe(struct platform_device *ghes_dev)
>>   		list_add_rcu(&ghes->list, &ghes_sci);
>>   		mutex_unlock(&ghes_list_mutex);
>>   		break;
>> +	case ACPI_HEST_NOTIFY_SEA:
>> +		rc = ghes_sea_add(ghes);
>> +		if (rc)
>> +			goto err_edac_unreg;
>> +		break;
>>   	case ACPI_HEST_NOTIFY_NMI:
>>   		ghes_nmi_add(ghes);
>>   		break;
>> @@ -1119,6 +1180,9 @@ static int ghes_remove(struct platform_device *ghes_dev)
>>   			unregister_acpi_hed_notifier(&ghes_notifier_sci);
>>   		mutex_unlock(&ghes_list_mutex);
>>   		break;
>> +	case ACPI_HEST_NOTIFY_SEA:
>> +		ghes_sea_remove(ghes);
>> +		break;
>>   	case ACPI_HEST_NOTIFY_NMI:
>>   		ghes_nmi_remove(ghes);
>>   		break;
>> diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
>> index 6ae318b..adf5455 100644
>> --- a/include/acpi/ghes.h
>> +++ b/include/acpi/ghes.h
>> @@ -95,3 +95,5 @@ static inline void *acpi_hest_generic_data_payload(struct acpi_hest_generic_data
>>   		(void *)(((struct acpi_hest_generic_data_v300 *)(gdata)) + 1) :
>>   		gdata + 1;
>>   }
>> +
>> +void ghes_notify_sea(void);
>>
> Thanks,
>
> Zhengqiang
>

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.

