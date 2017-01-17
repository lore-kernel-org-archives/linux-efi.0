From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH V7 04/10] arm64: exception: handle Synchronous External
 Abort
Date: Tue, 17 Jan 2017 10:31:21 +0000
Message-ID: <587DF279.1010402@arm.com>
References: <1484244924-24786-1-git-send-email-tbaicar@codeaurora.org>
 <1484244924-24786-5-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1484244924-24786-5-git-send-email-tbaicar@codeaurora.org>
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

On 12/01/17 18:15, Tyler Baicar wrote:
> SEA exceptions are often caused by an uncorrected hardware
> error, and are handled when data abort and instruction abort
> exception classes have specific values for their Fault Status
> Code.
> When SEA occurs, before killing the process, go through
> the handlers registered in the notification list.
> Update fault_info[] with specific SEA faults so that the
> new SEA handler is used.

> @@ -480,6 +496,28 @@ static int do_bad(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>  	return 1;
>  }
>  
> +/*
> + * This abort handler deals with Synchronous External Abort.
> + * It calls notifiers, and then returns "fault".
> + */
> +static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
> +{
> +	struct siginfo info;
> +
> +	atomic_notifier_call_chain(&sea_handler_chain, 0, NULL);
> +
> +	pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
> +		 fault_name(esr), esr, addr);
> +
> +	info.si_signo = SIGBUS;
> +	info.si_errno = 0;
> +	info.si_code  = 0;

Half of the other do_*() functions in this file read the signo and code from the
fault_info table.


> +	info.si_addr  = (void __user *)addr;

addr here was read from FAR_EL1, but for some of the classes of exception you
have listed below this register isn't updated with the faulting address.

The ARM-ARM version 'k' in D1.10.5 "Summary of registers on faults taken to an
Exception level that is using Aarch64" has:
> The architecture permits that the FAR_ELx is UNKNOWN for Synchronous External
> Aborts other than Synchronous External Aborts on Translation Table Walks. In
> this case, the ISS.FnV bit returned in ESR_ELx  indicates whether FAR_ELx is
> valid.

This is a problem if we get 'synchronous external abort' or 'synchronous parity
error' while a user space process was running.


> +	arm64_notify_die("", regs, &info, esr);
> +
> +	return 0;
> +}
> +
>  static const struct fault_info {
>  	int	(*fn)(unsigned long addr, unsigned int esr, struct pt_regs *regs);
>  	int	sig;


Thanks,

James
