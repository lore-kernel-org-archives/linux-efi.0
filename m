From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 2/8] efi: Decode IA32/X64 Processor Error Section
Date: Tue, 27 Feb 2018 12:22:34 +0100
Message-ID: <20180227112234.GE26382@pd.tnic>
References: <20180226193904.20532-1-Yazen.Ghannam@amd.com>
 <20180226193904.20532-3-Yazen.Ghannam@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180226193904.20532-3-Yazen.Ghannam@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yazen Ghannam <Yazen.Ghannam@amd.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, x86@kernel.org
List-Id: linux-efi@vger.kernel.org

On Mon, Feb 26, 2018 at 01:38:58PM -0600, Yazen Ghannam wrote:
> + * We don't need a "CPER_IA" prefix since these are all locally defined.
> + * This will save us a lot of line space.
> + */
> +#define VALID_LAPIC_ID			BIT_ULL(0)
> +#define VALID_CPUID_INFO		BIT_ULL(1)
> +
> +void cper_print_proc_ia(const char *pfx, const struct cper_sec_proc_ia *proc)
> +{
> +	printk("%sValidation Bits: 0x%016llx\n", pfx, proc->validation_bits);

Ok, so this...

> +
> +	if (proc->validation_bits & VALID_LAPIC_ID)
> +		printk("%sLocal APIC_ID: 0x%llx\n", pfx, proc->lapic_id);
> +
> +	if (proc->validation_bits & VALID_CPUID_INFO) {
> +		printk("%sCPUID Info:\n", pfx);
> +		print_hex_dump(pfx, "", DUMP_PREFIX_OFFSET, 16, 4, proc->cpuid,
> +			       sizeof(proc->cpuid), 0);

... and this are semi-decoded information bits which I'd have to go open
the spec and continue decoding.

Can we please change the whole approach of not simply dumping such
fields but decode them fully. We want that error information to be
helpful to the user and she should be able to immediately understand
what type of error it is.

Validation Bits and a CPUID hexdump simply makes you go look at the spec
again and such dumps are only useful as a debugging aid but nothing
more.

The APIC ID dump is how this should be done - properly and fully decoded
error info which can be used immediately for diagnosing the error.

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
