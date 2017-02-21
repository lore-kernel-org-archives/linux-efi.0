From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V10 05/10] acpi: apei: handle SEA notification type for
 ARMv8
Date: Tue, 21 Feb 2017 09:52:54 -0700
Message-ID: <8c6130c4-7ccd-1f8a-7c7b-7d097f9b298a@codeaurora.org>
References: <1487188282-2568-1-git-send-email-tbaicar@codeaurora.org>
 <1487188282-2568-6-git-send-email-tbaicar@codeaurora.org>
 <CAKv+Gu_+w4UW4ds-2hLe+c36Ch+H4Zx-pMzrkTkqDYbzTHrxnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu_+w4UW4ds-2hLe+c36Ch+H4Zx-pMzrkTkqDYbzTHrxnA@mail.gmail.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Robert Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>, nkaje@codeaurora.org, "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Andrew Morton <akpm@linux-foundation.org>, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, Laura Abbott <labbott@redhat.com>, shijie.huang@arm.comRichard Ruigrok <r>
List-Id: linux-efi@vger.kernel.org

Hello Ard,


On 2/16/2017 11:32 AM, Ard Biesheuvel wrote:
> On 15 February 2017 at 19:51, Tyler Baicar <tbaicar@codeaurora.org> wrote:
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
>>
>> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
>> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
>> Signed-off-by: Naveen Kaje <nkaje@codeaurora.org>
>> ---
>>   arch/arm64/Kconfig        |  2 ++
>>   arch/arm64/mm/fault.c     | 13 ++++++++
>>   drivers/acpi/apei/Kconfig | 14 +++++++++
>>   drivers/acpi/apei/ghes.c  | 77 +++++++++++++++++++++++++++++++++++++++++++----
>>   include/acpi/ghes.h       |  7 +++++
>>   5 files changed, 107 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 1117421..8557556 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>>
>> @@ -498,6 +500,17 @@ static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>>          pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
>>                   fault_name(esr), esr, addr);
>>
>> +       /*
>> +        * Synchronous aborts may interrupt code which had interrupts masked.
>> +        * Before calling out into the wider kernel tell the interested
>> +        * subsystems.
>> +        */
>> +       if(IS_ENABLED(HAVE_ACPI_APEI_SEA)) {
> Missing space after 'if'
I'll add that in.
>> +               nmi_enter();
>> +               ghes_notify_sea();
>> +               nmi_exit();
>> +       }
>> +
>>          info.si_signo = SIGBUS;
>>          info.si_errno = 0;
>>          info.si_code  = 0;
>> diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
>> index b0140c8..ef7f7bd 100644
>> --- a/drivers/acpi/apei/Kconfig
>> +++ b/drivers/acpi/apei/Kconfig
>> @@ -4,6 +4,20 @@ config HAVE_ACPI_APEI
>>   config HAVE_ACPI_APEI_NMI
>>          bool
>>
>> +config HAVE_ACPI_APEI_SEA
> HAVE_xxx Kconfig options are typically non user selectable, so I
> suggest to drop the HAVE_ prefix here. Also, you should probably make
> it 'default y' rather than select it elsewhere; this will still honour
> the dependency on ARM64 && ACPI_APEI_GHES
>
Okay, I will drop the HAVE_ and add in the default y

Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.

