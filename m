From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH V15 11/11] arm/arm64: KVM: add guest SEA support
Date: Mon, 8 May 2017 19:40:58 +0200
Message-ID: <20170508174058.5hbujeblxq5z6iwa@pd.tnic>
References: <1492556723-9189-1-git-send-email-tbaicar@codeaurora.org>
 <1492556723-9189-12-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Content-Disposition: inline
In-Reply-To: <1492556723-9189-12-git-send-email-tbaicar@codeaurora.org>
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
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, rafael@kernel.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, gengdongjiu@huawei.com, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, tony.luck@intel.com, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, joe@perches.com, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 18, 2017 at 05:05:23PM -0600, Tyler Baicar wrote:
> Currently external aborts are unsupported by the guest abort
> handling. Add handling for SEAs so that the host kernel reports
> SEAs which occur in the guest kernel.
> 
> When an SEA occurs in the guest kernel, the guest exits and is
> routed to kvm_handle_guest_abort(). Prior to this patch, a print
> message of an unsupported FSC would be printed and nothing else
> would happen. With this patch, the code gets routed to the APEI
> handling of SEAs in the host kernel to report the SEA information.
> 
> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Acked-by: Christoffer Dall <cdall@linaro.org>

...

> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index 582a972..fd11855 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -29,6 +29,7 @@
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/virt.h>
> +#include <asm/system_misc.h>
>  
>  #include "trace.h"
>  
> @@ -1418,6 +1419,24 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>  		kvm_set_pfn_accessed(pfn);
>  }
>  
> +static bool is_abort_sea(unsigned long fault_status) {

ERROR: open brace '{' following function declarations go on the next line
#107: FILE: arch/arm/kvm/mmu.c:1422:
+static bool is_abort_sea(unsigned long fault_status) {

...

> @@ -611,6 +612,24 @@ static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>  };
>  
>  /*
> + * Handle Synchronous External Aborts that occur in a guest kernel.
> + *
> + * The return value will be zero if the SEA was successfully handled
> + * and non-zero if there was an error processing the error or there was
> + * no error to process.
> + */
> +int handle_guest_sea(phys_addr_t addr, unsigned int esr)
> +{
> +	int ret = -ENOENT;
> +
> +	if (IS_ENABLED(CONFIG_ACPI_APEI_SEA)) {
> +		ret = ghes_notify_sea();
> +	}

WARNING: braces {} are not necessary for single statement blocks
#239: FILE: arch/arm64/mm/fault.c:625:
+       if (IS_ENABLED(CONFIG_ACPI_APEI_SEA)) {
+               ret = ghes_notify_sea();
+       }


> +
> +	return ret;
> +}
> +
> +/*
>   * Dispatch a data abort to the relevant handler.
>   */
>  asmlinkage void __exception do_mem_abort(unsigned long addr, unsigned int esr,
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 612deb3..d286248 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -812,17 +812,18 @@ static int ghes_notify_sci(struct notifier_block *this,
>  #ifdef CONFIG_ACPI_APEI_SEA
>  static LIST_HEAD(ghes_sea);
>  
> -void ghes_notify_sea(void)
> +int ghes_notify_sea(void)
>  {
>  	struct ghes *ghes;
> +	int ret = -ENOENT;
>  
> -	/*
> -	 * synchronize_rcu() will wait for nmi_exit(), so no need to
> -	 * rcu_read_lock().
> -	 */
> +	rcu_read_lock();
>  	list_for_each_entry_rcu(ghes, &ghes_sea, list) {
> -		ghes_proc(ghes);
> +		if(!ghes_proc(ghes))
> +			ret = 0;

What is the idea here: the first time ghes_proc() returns 0, ret is set
to 0 and all errors after it will be practically ignored. Looks like it
needs more love.

Also:

ERROR: space required before the open parenthesis '('
#271: FILE: drivers/acpi/apei/ghes.c:822:
+               if(!ghes_proc(ghes))

Please integrate scripts/checkpatch.pl in your patch creation workflow.
Some of the warnings/errors *actually* make sense.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
