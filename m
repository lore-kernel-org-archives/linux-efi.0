From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V12 05/10] acpi: apei: handle SEA notification type for
 ARMv8
Date: Tue, 7 Mar 2017 09:40:34 -0700
Message-ID: <be39bb5b-4f00-21fd-49d1-b79431313c7b@codeaurora.org>
References: <1488833103-21082-1-git-send-email-tbaicar@codeaurora.org>
 <1488833103-21082-6-git-send-email-tbaicar@codeaurora.org>
 <58BE9B7E.4070904@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <58BE9B7E.4070904@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, joe@perches.com, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawei.com
List-Id: linux-efi@vger.kernel.org

Hello James,


On 3/7/2017 4:37 AM, James Morse wrote:
> On 06/03/17 20:44, Tyler Baicar wrote:
>> ARM APEI extension proposal added SEA (Synchronous External Abort)
>> notification type for ARMv8.
>> Add a new GHES error source handling function for SEA. If an error
>> source's notification type is SEA, then this function can be registered
>> into the SEA exception handler. That way GHES will parse and report
>> SEA exceptions when they occur.
>> An SEA can interrupt code that had interrupts masked and is treated as
>> an NMI. To aid this the page of address space for mapping APEI buffers
>> while in_nmi() is always reserved, and ghes_ioremap_pfn_nmi() is
>> changed to use the helper methods to find the prot_t to map with in
>> the same way as ghes_ioremap_pfn_irq().
>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>> index d178dc0..b2d57fc 100644
>> --- a/arch/arm64/mm/fault.c
>> +++ b/arch/arm64/mm/fault.c
>> @@ -41,6 +41,8 @@
>>   #include <asm/pgtable.h>
>>   #include <asm/tlbflush.h>
>>   
>> +#include <acpi/ghes.h>
>> +
>>   static const char *fault_name(unsigned int esr);
>>   
>>   #ifdef CONFIG_KPROBES
>> @@ -498,6 +500,17 @@ static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>>   	pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
>>   		 fault_name(esr), esr, addr);
>>   
>> +	/*
>> +	 * Synchronous aborts may interrupt code which had interrupts masked.
>> +	 * Before calling out into the wider kernel tell the interested
>> +	 * subsystems.
>> +	 */
>> +	if (IS_ENABLED(ACPI_APEI_SEA)) {
> IS_ENABLED() needs the CONFIG_ version of the symbols, otherwise this doesn't
> get built.
>
> (I guess the testing from the previous always-enabled version is still valid)
Okay, I will use CONFIG_ACPI_APEI_SEA in the next patch set.
>
>> +		nmi_enter();
>> +		ghes_notify_sea();
>> +		nmi_exit();
>> +	}
>> +
>>   	info.si_signo = SIGBUS;
>>   	info.si_errno = 0;
>>   	info.si_code  = 0;
>> diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
>> index b0140c8..c545dd1 100644
>> --- a/drivers/acpi/apei/Kconfig
>> +++ b/drivers/acpi/apei/Kconfig
>> @@ -39,6 +39,21 @@ config ACPI_APEI_PCIEAER
>>   	  PCIe AER errors may be reported via APEI firmware first mode.
>>   	  Turn on this option to enable the corresponding support.
>>   
>> +config ACPI_APEI_SEA
>> +	bool "APEI Synchronous External Abort logging/recovering support"
>> +	depends on ARM64 && ACPI_APEI && ACPI_APEI_GHES
> Nit: ACPI_APEI_GHES already depends on ACPI_APEI
I can remove ACPI_APEI here then.
>> +	default y
>> +	help
>> +	  This option should be enabled if the system supports
>> +	  firmware first handling of SEA (Synchronous External Abort).
>> +	  SEA happens with certain faults of data abort or instruction
>> +	  abort synchronous exceptions on ARMv8 systems. If a system
>> +	  supports firmware first handling of SEA, the platform analyzes
>> +	  and handles hardware error notifications from SEA, and it may then
>> +	  form a HW error record for the OS to parse and handle. This
>> +	  option allows the OS to look for such hardware error record, and
>> +	  take appropriate action.
>> +
>>   config ACPI_APEI_MEMORY_FAILURE
>>   	bool "APEI memory error recovering support"
>>   	depends on ACPI_APEI && MEMORY_FAILURE
>
> Reviewed-by: James Morse <james.morse@arm.com>
>
Thanks!
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
