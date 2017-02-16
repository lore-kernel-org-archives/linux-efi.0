From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH V10 05/10] acpi: apei: handle SEA notification type for
 ARMv8
Date: Thu, 16 Feb 2017 18:32:22 +0000
Message-ID: <CAKv+Gu_+w4UW4ds-2hLe+c36Ch+H4Zx-pMzrkTkqDYbzTHrxnA@mail.gmail.com>
References: <1487188282-2568-1-git-send-email-tbaicar@codeaurora.org>
 <1487188282-2568-6-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1487188282-2568-6-git-send-email-tbaicar@codeaurora.org>
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
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, KVM devel mailing list <kvm@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Robert Moore <robert.moore@intel.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Lv Zheng <lv.zheng@intel.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Fu Wei <fu.wei@linaro.org>, "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>, Russell King <linux@armlinux.org.uk>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, eun.taik.lee@samsung.com, shijie.huang@arm.com, Laura Abbott <labbott@redhat.com>, Len Brown <lenb@kernel.org>, harba@codeaurora.org, john.garry@huawei.com, Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Steven Rostedt <rostedt@goodmis.org>, nkaje@codeaurora.org, sand
List-Id: linux-efi@vger.kernel.org

On 15 February 2017 at 19:51, Tyler Baicar <tbaicar@codeaurora.org> wrote:
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
> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
> Signed-off-by: Naveen Kaje <nkaje@codeaurora.org>
> ---
>  arch/arm64/Kconfig        |  2 ++
>  arch/arm64/mm/fault.c     | 13 ++++++++
>  drivers/acpi/apei/Kconfig | 14 +++++++++
>  drivers/acpi/apei/ghes.c  | 77 +++++++++++++++++++++++++++++++++++++++++++----
>  include/acpi/ghes.h       |  7 +++++
>  5 files changed, 107 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 1117421..8557556 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -53,6 +53,7 @@ config ARM64
>         select HANDLE_DOMAIN_IRQ
>         select HARDIRQS_SW_RESEND
>         select HAVE_ACPI_APEI if (ACPI && EFI)
> +       select HAVE_ACPI_APEI_SEA if (ACPI && EFI)
>         select HAVE_ALIGNED_STRUCT_PAGE if SLUB
>         select HAVE_ARCH_AUDITSYSCALL
>         select HAVE_ARCH_BITREVERSE
> @@ -88,6 +89,7 @@ config ARM64
>         select HAVE_IRQ_TIME_ACCOUNTING
>         select HAVE_MEMBLOCK
>         select HAVE_MEMBLOCK_NODE_MAP if NUMA
> +       select HAVE_NMI if HAVE_ACPI_APEI_SEA
>         select HAVE_PATA_PLATFORM
>         select HAVE_PERF_EVENTS
>         select HAVE_PERF_REGS
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index d178dc0..4e35c72 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -41,6 +41,8 @@
>  #include <asm/pgtable.h>
>  #include <asm/tlbflush.h>
>
> +#include <acpi/ghes.h>
> +
>  static const char *fault_name(unsigned int esr);
>
>  #ifdef CONFIG_KPROBES
> @@ -498,6 +500,17 @@ static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>         pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
>                  fault_name(esr), esr, addr);
>
> +       /*
> +        * Synchronous aborts may interrupt code which had interrupts masked.
> +        * Before calling out into the wider kernel tell the interested
> +        * subsystems.
> +        */
> +       if(IS_ENABLED(HAVE_ACPI_APEI_SEA)) {

Missing space after 'if'

> +               nmi_enter();
> +               ghes_notify_sea();
> +               nmi_exit();
> +       }
> +
>         info.si_signo = SIGBUS;
>         info.si_errno = 0;
>         info.si_code  = 0;
> diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
> index b0140c8..ef7f7bd 100644
> --- a/drivers/acpi/apei/Kconfig
> +++ b/drivers/acpi/apei/Kconfig
> @@ -4,6 +4,20 @@ config HAVE_ACPI_APEI
>  config HAVE_ACPI_APEI_NMI
>         bool
>
> +config HAVE_ACPI_APEI_SEA

HAVE_xxx Kconfig options are typically non user selectable, so I
suggest to drop the HAVE_ prefix here. Also, you should probably make
it 'default y' rather than select it elsewhere; this will still honour
the dependency on ARM64 && ACPI_APEI_GHES



> +       bool "APEI Synchronous External Abort logging/recovering support"
> +       depends on ARM64 && ACPI_APEI_GHES
> +       help
> +         This option should be enabled if the system supports
> +         firmware first handling of SEA (Synchronous External Abort).
> +         SEA happens with certain faults of data abort or instruction
> +         abort synchronous exceptions on ARMv8 systems. If a system
> +         supports firmware first handling of SEA, the platform analyzes
> +         and handles hardware error notifications from SEA, and it may then
> +         form a HW error record for the OS to parse and handle. This
> +         option allows the OS to look for such hardware error record, and
> +         take appropriate action.
> +
>  config ACPI_APEI
>         bool "ACPI Platform Error Interface (APEI)"
>         select MISC_FILESYSTEMS
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index b25e7cf..87045dc 100644
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
>  #define GHES_IOREMAP_IRQ_PAGE(base)    (base)
>  #define GHES_IOREMAP_NMI_PAGE(base)    ((base) + PAGE_SIZE)
>
> @@ -157,10 +153,14 @@ static void ghes_ioremap_exit(void)
>  static void __iomem *ghes_ioremap_pfn_nmi(u64 pfn)
>  {
>         unsigned long vaddr;
> +       phys_addr_t paddr;
> +       pgprot_t prot;
>
>         vaddr = (unsigned long)GHES_IOREMAP_NMI_PAGE(ghes_ioremap_area->addr);
> -       ioremap_page_range(vaddr, vaddr + PAGE_SIZE,
> -                          pfn << PAGE_SHIFT, PAGE_KERNEL);
> +
> +       paddr = pfn << PAGE_SHIFT;
> +       prot = arch_apei_get_mem_attribute(paddr);
> +       ioremap_page_range(vaddr, vaddr + PAGE_SIZE, paddr, prot);
>
>         return (void __iomem *)vaddr;
>  }
> @@ -767,6 +767,50 @@ static int ghes_notify_sci(struct notifier_block *this,
>         .notifier_call = ghes_notify_sci,
>  };
>
> +#ifdef CONFIG_HAVE_ACPI_APEI_SEA
> +static LIST_HEAD(ghes_sea);
> +
> +void ghes_notify_sea(void)
> +{
> +       struct ghes *ghes;
> +
> +       /*
> +        * synchronize_rcu() will wait for nmi_exit(), so no need to
> +        * rcu_read_lock().
> +        */
> +       list_for_each_entry_rcu(ghes, &ghes_sea, list) {
> +               ghes_proc(ghes);
> +       }
> +}
> +
> +static void ghes_sea_add(struct ghes *ghes)
> +{
> +       mutex_lock(&ghes_list_mutex);
> +       list_add_rcu(&ghes->list, &ghes_sea);
> +       mutex_unlock(&ghes_list_mutex);
> +}
> +
> +static void ghes_sea_remove(struct ghes *ghes)
> +{
> +       mutex_lock(&ghes_list_mutex);
> +       list_del_rcu(&ghes->list);
> +       mutex_unlock(&ghes_list_mutex);
> +       synchronize_rcu();
> +}
> +#else /* CONFIG_HAVE_ACPI_APEI_SEA */
> +static inline void ghes_sea_add(struct ghes *ghes)
> +{
> +       pr_err(GHES_PFX "ID: %d, trying to add SEA notification which is not supported\n",
> +              ghes->generic->header.source_id);
> +}
> +
> +static inline void ghes_sea_remove(struct ghes *ghes)
> +{
> +       pr_err(GHES_PFX "ID: %d, trying to remove SEA notification which is not supported\n",
> +              ghes->generic->header.source_id);
> +}
> +#endif /* CONFIG_HAVE_ACPI_APEI_SEA */
> +
>  #ifdef CONFIG_HAVE_ACPI_APEI_NMI
>  /*
>   * printk is not safe in NMI context.  So in NMI handler, we allocate
> @@ -1012,6 +1056,14 @@ static int ghes_probe(struct platform_device *ghes_dev)
>         case ACPI_HEST_NOTIFY_EXTERNAL:
>         case ACPI_HEST_NOTIFY_SCI:
>                 break;
> +       case ACPI_HEST_NOTIFY_SEA:
> +               if (!IS_ENABLED(CONFIG_HAVE_ACPI_APEI_SEA)) {
> +                       pr_warn(GHES_PFX "Generic hardware error source: %d notified via SEA is not supported\n",
> +                               generic->header.source_id);
> +                       rc = -ENOTSUPP;
> +                       goto err;
> +               }
> +               break;
>         case ACPI_HEST_NOTIFY_NMI:
>                 if (!IS_ENABLED(CONFIG_HAVE_ACPI_APEI_NMI)) {
>                         pr_warn(GHES_PFX "Generic hardware error source: %d notified via NMI interrupt is not supported!\n",
> @@ -1023,6 +1075,13 @@ static int ghes_probe(struct platform_device *ghes_dev)
>                 pr_warning(GHES_PFX "Generic hardware error source: %d notified via local interrupt is not supported!\n",
>                            generic->header.source_id);
>                 goto err;
> +       case ACPI_HEST_NOTIFY_GPIO:
> +       case ACPI_HEST_NOTIFY_SEI:
> +       case ACPI_HEST_NOTIFY_GSIV:
> +               pr_warn(GHES_PFX "Generic hardware error source: %d notified via notification type %u is not supported\n",
> +                       generic->header.source_id, generic->header.source_id);
> +               rc = -ENOTSUPP;
> +               goto err;
>         default:
>                 pr_warning(FW_WARN GHES_PFX "Unknown notification type: %u for generic hardware error source: %d\n",
>                            generic->notify.type, generic->header.source_id);
> @@ -1077,6 +1136,9 @@ static int ghes_probe(struct platform_device *ghes_dev)
>                 list_add_rcu(&ghes->list, &ghes_sci);
>                 mutex_unlock(&ghes_list_mutex);
>                 break;
> +       case ACPI_HEST_NOTIFY_SEA:
> +               ghes_sea_add(ghes);
> +               break;
>         case ACPI_HEST_NOTIFY_NMI:
>                 ghes_nmi_add(ghes);
>                 break;
> @@ -1119,6 +1181,9 @@ static int ghes_remove(struct platform_device *ghes_dev)
>                         unregister_acpi_hed_notifier(&ghes_notifier_sci);
>                 mutex_unlock(&ghes_list_mutex);
>                 break;
> +       case ACPI_HEST_NOTIFY_SEA:
> +               ghes_sea_remove(ghes);
> +               break;
>         case ACPI_HEST_NOTIFY_NMI:
>                 ghes_nmi_remove(ghes);
>                 break;
> diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
> index 6ae318b..18bc935 100644
> --- a/include/acpi/ghes.h
> +++ b/include/acpi/ghes.h
> @@ -1,3 +1,6 @@
> +#ifndef GHES_H
> +#define GHES_H
> +
>  #include <acpi/apei.h>
>  #include <acpi/hed.h>
>
> @@ -95,3 +98,7 @@ static inline void *acpi_hest_generic_data_payload(struct acpi_hest_generic_data
>                 (void *)(((struct acpi_hest_generic_data_v300 *)(gdata)) + 1) :
>                 gdata + 1;
>  }
> +
> +void ghes_notify_sea(void);
> +
> +#endif /* GHES_H */
> --
> Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
> Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
