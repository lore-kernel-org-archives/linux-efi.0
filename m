From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH V6 03/10] efi: parse ARM processor error
Date: Thu, 15 Dec 2016 14:08:10 +0000
Message-ID: <5852A3CA.807@arm.com>
References: <1481147303-7979-1-git-send-email-tbaicar@codeaurora.org>
 <1481147303-7979-4-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1481147303-7979-4-git-send-email-tbaicar@codeaurora.org>
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

On 07/12/16 21:48, Tyler Baicar wrote:
> Add support for ARM Common Platform Error Record (CPER).
> UEFI 2.6 specification adds support for ARM specific
> processor error information to be reported as part of the
> CPER records. This provides more detail on for processor error logs.

Looks good to me, a few minor comments below.

Reviewed-by: James Morse <james.morse@arm.com>


> diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
> index 8fa4e23..1ac2572 100644
> --- a/drivers/firmware/efi/cper.c
> +++ b/drivers/firmware/efi/cper.c
> @@ -184,6 +199,110 @@ static void cper_print_proc_generic(const char *pfx,
>  		printk("%s""IP: 0x%016llx\n", pfx, proc->ip);
>  }
>  
> +static void cper_print_proc_arm(const char *pfx,
> +				const struct cper_sec_proc_arm *proc)
> +{
> +	int i, len, max_ctx_type;
> +	struct cper_arm_err_info *err_info;
> +	struct cper_arm_ctx_info *ctx_info;
> +	char newpfx[64];
> +
> +	printk("%ssection length: %d\n", pfx, proc->section_length);

Compared to the rest of the file, this:
>	printk("%s""section length: %d\n", pfx, proc->section_length);

would be more in keeping. I guess its done this way to avoid some spurious
warning about %ssection not being recognised by printk().


> +	printk("%sMIDR: 0x%016llx\n", pfx, proc->midr);
> +
> +	len = proc->section_length - (sizeof(*proc) +
> +		proc->err_info_num * (sizeof(*err_info)));
> +	if (len < 0) {
> +		printk("%ssection length is too small\n", pfx);

This calculation is all based on values in the 'struct cper_sec_proc_arm', is it
worth making more noise about how the firmware-generated record is incorrectly
formatted? If we see this message its not the kernel's fault!


> +		printk("%sERR_INFO_NUM is %d\n", pfx, proc->err_info_num);
> +		return;
> +	}
> +
> +	if (proc->validation_bits & CPER_ARM_VALID_MPIDR)
> +		printk("%sMPIDR: 0x%016llx\n", pfx, proc->mpidr);
> +	if (proc->validation_bits & CPER_ARM_VALID_AFFINITY_LEVEL)
> +		printk("%serror affinity level: %d\n", pfx,
> +			proc->affinity_level);
> +	if (proc->validation_bits & CPER_ARM_VALID_RUNNING_STATE) {

> +		printk("%srunning state: %d\n", pfx, proc->running_state);

This field is described as a bit field in table 260, can we print it as 0x%lx in
case additional bits are set?


> +		printk("%sPSCI state: %d\n", pfx, proc->psci_state);
> +	}
> +
> +	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
> +
> +	err_info = (struct cper_arm_err_info *)(proc + 1);
> +	for (i = 0; i < proc->err_info_num; i++) {
> +		printk("%sError info structure %d:\n", pfx, i);
> +		printk("%sversion:%d\n", newpfx, err_info->version);
> +		printk("%slength:%d\n", newpfx, err_info->length);
> +		if (err_info->validation_bits &
> +		    CPER_ARM_INFO_VALID_MULTI_ERR) {
> +			if (err_info->multiple_error == 0)
> +				printk("%ssingle error\n", newpfx);
> +			else if (err_info->multiple_error == 1)
> +				printk("%smultiple errors\n", newpfx);
> +			else

> +				printk("%smultiple errors count:%d\n",
> +				newpfx, err_info->multiple_error);

This is described as unsigned in table 261.


> +		}
> +		if (err_info->validation_bits & CPER_ARM_INFO_VALID_FLAGS) {
> +			if (err_info->flags & CPER_ARM_INFO_FLAGS_FIRST)
> +				printk("%sfirst error captured\n", newpfx);
> +			if (err_info->flags & CPER_ARM_INFO_FLAGS_LAST)
> +				printk("%slast error captured\n", newpfx);
> +			if (err_info->flags & CPER_ARM_INFO_FLAGS_PROPAGATED)
> +				printk("%spropagated error captured\n",
> +				       newpfx);

Table 261 also has an 'overflow' bit in flags. It may be worth printing a
warning if this is set:
> Note: Overflow bit indicates that firmware/hardware error
> buffers had experience an overflow, and it is possible that
> some error information has been lost.


> +		}
> +		printk("%serror_type: %d, %s\n", newpfx, err_info->type,
> +			err_info->type < ARRAY_SIZE(proc_error_type_strs) ?
> +			proc_error_type_strs[err_info->type] : "unknown");
> +		if (err_info->validation_bits & CPER_ARM_INFO_VALID_ERR_INFO)
> +			printk("%serror_info: 0x%016llx\n", newpfx,
> +			       err_info->error_info);
> +		if (err_info->validation_bits & CPER_ARM_INFO_VALID_VIRT_ADDR)
> +			printk("%svirtual fault address: 0x%016llx\n",
> +				newpfx, err_info->virt_fault_addr);
> +		if (err_info->validation_bits &
> +		    CPER_ARM_INFO_VALID_PHYSICAL_ADDR)
> +			printk("%sphysical fault address: 0x%016llx\n",
> +				newpfx, err_info->physical_fault_addr);
> +		err_info += 1;
> +	}
> +	ctx_info = (struct cper_arm_ctx_info *)err_info;

> +	max_ctx_type = (sizeof(arm_reg_ctx_strs) /
> +			sizeof(arm_reg_ctx_strs[0]) - 1);

ARRAY_SIZE() - 1?


> +	for (i = 0; i < proc->context_info_num; i++) {
> +		int size = sizeof(*ctx_info) + ctx_info->size;
> +
> +		printk("%sContext info structure %d:\n", pfx, i);
> +		if (len < size) {
> +			printk("%ssection length is too small\n", newpfx);
> +			return;
> +		}
> +		if (ctx_info->type > max_ctx_type) {
> +			printk("%sInvalid context type: %d\n",	newpfx,
> +						ctx_info->type);
> +			printk("%sMax context type: %d\n", newpfx,
> +						max_ctx_type);
> +			return;
> +		}
> +		printk("%sregister context type %d: %s\n", newpfx,
> +			ctx_info->type, arm_reg_ctx_strs[ctx_info->type]);
> +		print_hex_dump(newpfx, "", DUMP_PREFIX_OFFSET, 16, 4,
> +				(ctx_info + 1), ctx_info->size, 0);
> +		len -= size;
> +		ctx_info = (struct cper_arm_ctx_info *)((long)ctx_info + size);
> +	}
> +
> +	if (len > 0) {
> +		printk("%sVendor specific error info has %d bytes:\n", pfx,
> +		       len);

%u - just in case it is surprisingly large!


> +		print_hex_dump(newpfx, "", DUMP_PREFIX_OFFSET, 16, 4, ctx_info,
> +				len, 0);
> +	}
> +}
> +
>  static const char * const mem_err_type_strs[] = {
>  	"unknown",
>  	"no error",
> @@ -458,6 +577,15 @@ static void cper_estatus_print_section(
>  			cper_print_pcie(newpfx, pcie, gdata);
>  		else
>  			goto err_section_too_small;
> +	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PROC_ARM)) {
> +		struct cper_sec_proc_arm *arm_err;
> +
> +		arm_err = acpi_hest_generic_data_payload(gdata);
> +		printk("%ssection_type: ARM processor error\n", newpfx);
> +		if (gdata->error_data_length >= sizeof(*arm_err))
> +			cper_print_proc_arm(newpfx, arm_err);
> +		else
> +			goto err_section_too_small;
>  	} else
>  		printk("%s""section type: unknown, %pUl\n", newpfx, sec_type);
>  

This is the only processor-specific entry in this function,
CPER_SEC_PROC_{IA,IPF} don't appear anywhere else in the tree.

Is it worth adding an (IS_ENABLED(CONFIG_ARM64) || IS_ENABLED(CONFIG_ARM)) in
the if()? This would let the compiler remove cper_print_proc_arm(() on x86/ia64
systems which won't ever see a record of this type.


Thanks!

James
