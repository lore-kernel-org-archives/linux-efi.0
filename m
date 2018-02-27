From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 3/8] efi: Decode IA32/X64 Processor Error Info
 Structure
Date: Tue, 27 Feb 2018 15:25:31 +0100
Message-ID: <20180227142531.GF26382@pd.tnic>
References: <20180226193904.20532-1-Yazen.Ghannam@amd.com>
 <20180226193904.20532-4-Yazen.Ghannam@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180226193904.20532-4-Yazen.Ghannam@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yazen Ghannam <Yazen.Ghannam@amd.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, x86@kernel.org
List-Id: linux-efi@vger.kernel.org

On Mon, Feb 26, 2018 at 01:38:59PM -0600, Yazen Ghannam wrote:
> From: Yazen Ghannam <yazen.ghannam@amd.com>
> 
> Print the fields in the IA32/X64 Processor Error Info Structure.
> 
> Based on UEFI 2.7 Table 256. IA32/X64 Processor Error Information
> Structure.
> 
> Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
> ---
> Link:
> https://lkml.kernel.org/r/20180223200333.6410-4-Yazen.Ghannam@amd.com
> 
> v1->v2:
> * Add parantheses around "bits" expression in macro.
> * Fix indentation on multi-line statements.
> 
>  drivers/firmware/efi/cper-x86.c | 53 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
> 
> diff --git a/drivers/firmware/efi/cper-x86.c b/drivers/firmware/efi/cper-x86.c
> index 9da0d981178f..417bd4e500a7 100644
> --- a/drivers/firmware/efi/cper-x86.c
> +++ b/drivers/firmware/efi/cper-x86.c
> @@ -3,15 +3,28 @@
>  
>  #include <linux/cper.h>
>  
> +#define INDENT_SP	" "

That's just silly.

> +
>  /*
>   * We don't need a "CPER_IA" prefix since these are all locally defined.
>   * This will save us a lot of line space.
>   */
>  #define VALID_LAPIC_ID			BIT_ULL(0)
>  #define VALID_CPUID_INFO		BIT_ULL(1)
> +#define VALID_PROC_ERR_INFO_NUM(bits)	(((bits) & GENMASK_ULL(7, 2)) >> 2)
> +
> +#define INFO_VALID_CHECK_INFO		BIT_ULL(0)
> +#define INFO_VALID_TARGET_ID		BIT_ULL(1)
> +#define INFO_VALID_REQUESTOR_ID		BIT_ULL(2)
> +#define INFO_VALID_RESPONDER_ID		BIT_ULL(3)
> +#define INFO_VALID_IP			BIT_ULL(4)
>  
>  void cper_print_proc_ia(const char *pfx, const struct cper_sec_proc_ia *proc)
>  {
> +	int i;
> +	struct cper_ia_err_info *err_info;
> +	char newpfx[64];
> +
>  	printk("%sValidation Bits: 0x%016llx\n", pfx, proc->validation_bits);
>  
>  	if (proc->validation_bits & VALID_LAPIC_ID)
> @@ -22,4 +35,44 @@ void cper_print_proc_ia(const char *pfx, const struct cper_sec_proc_ia *proc)
>  		print_hex_dump(pfx, "", DUMP_PREFIX_OFFSET, 16, 4, proc->cpuid,
>  			       sizeof(proc->cpuid), 0);
>  	}
> +
> +	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
> +
> +	err_info = (struct cper_ia_err_info *)(proc + 1);
> +	for (i = 0; i < VALID_PROC_ERR_INFO_NUM(proc->validation_bits); i++) {
> +		printk("%sError Information Structure %d:\n", pfx, i);
> +
> +		printk("%sError Structure Type: %pUl\n", newpfx,
> +		       &err_info->err_type);

That dumps a GUID - how do I find out what type that GUID refers to?

> +
> +		printk("%sValidation Bits: 0x%016llx\n",
> +		       newpfx, err_info->validation_bits);

As before, no need for those.

> +
> +		if (err_info->validation_bits & INFO_VALID_CHECK_INFO) {
> +			printk("%sCheck Information: 0x%016llx\n", newpfx,
> +			       err_info->check_info);
> +		}
> +
> +		if (err_info->validation_bits & INFO_VALID_TARGET_ID) {
> +			printk("%sTarget Identifier: 0x%016llx\n",
> +			       newpfx, err_info->target_id);
> +		}
> +
> +		if (err_info->validation_bits & INFO_VALID_REQUESTOR_ID) {
> +			printk("%sRequestor Identifier: 0x%016llx\n",
> +			       newpfx, err_info->requestor_id);
> +		}
> +
> +		if (err_info->validation_bits & INFO_VALID_RESPONDER_ID) {
> +			printk("%sResponder Identifier: 0x%016llx\n",
> +			       newpfx, err_info->responder_id);
> +		}

Those look like would need an additional decoding. Can we do that here
too?

> +
> +		if (err_info->validation_bits & INFO_VALID_IP) {
> +			printk("%sInstruction Pointer: 0x%016llx\n",
> +			       newpfx, err_info->ip);

The only thing that makes sense so far.

> +		}
> +
> +		err_info++;
> +	}

Also, it is worth checking how much duplication there is with
drivers/firmware/efi/cper-arm.c and unifying the common pieces into
functions in cper-common.c or so.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
