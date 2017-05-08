From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH V15 06/11] acpi: apei: handle SEA notification type for
 ARMv8
Date: Mon, 08 May 2017 18:28:24 +0100
Message-ID: <5910AAB8.8070703@arm.com>
References: <1492556723-9189-1-git-send-email-tbaicar@codeaurora.org>
 <1492556723-9189-7-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1492556723-9189-7-git-send-email-tbaicar@codeaurora.org>
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
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, rafael@kernel.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, gengdongjiu@huawei.com, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, bp@alien8.de, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, tony.luck@intel.com, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, joe@perches.com, pbonzini@redhat.com, akpm@linux-foundation.org, bris
List-Id: linux-efi@vger.kernel.org

Hi Tyler,

On 19/04/17 00:05, Tyler Baicar wrote:
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

> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index b74d8b7..10013ff 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
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


I was tidying up the masking/unmasking in entry.S, something I wasn't aware of
that leads to a bug:
entry.S will unmask interrupts for instruction/data aborts that came from a
context with interrupts enabled. This makes sense for get_user() and friends...
For do_sea() we pull nmi_enter() as this can interrupt interrupts-masked code,
such as APEI, but if we end up in here with interrupts unmasked we can take an
IRQ from this 'NMI' context, which will inherit the in_nmi() and could lead to
the deadlock we were originally trying to avoid.

Teaching entry.S to spot external aborts is messy. I think the two choices are
to either mask interrupts when calling nmi_enter() (as these things should be
mutually exclusive), or to conditionally call nmi_enter() based on
interrupts_enabled(regs). I prefer the second one as it matches the notify_sea()
while interruptible that happens when KVM takes one of these.



Thanks,

James
