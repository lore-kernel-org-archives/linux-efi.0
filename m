From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 1/8] efi: Fix IA32/X64 Processor Error Record
 definition
Date: Tue, 27 Feb 2018 11:47:08 +0100
Message-ID: <20180227104708.GC26382@pd.tnic>
References: <20180226193904.20532-1-Yazen.Ghannam@amd.com>
 <20180226193904.20532-2-Yazen.Ghannam@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180226193904.20532-2-Yazen.Ghannam@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yazen Ghannam <Yazen.Ghannam@amd.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, x86@kernel.org
List-Id: linux-efi@vger.kernel.org

On Mon, Feb 26, 2018 at 01:38:57PM -0600, Yazen Ghannam wrote:
> From: Yazen Ghannam <yazen.ghannam@amd.com>
> 
> Based on UEFI 2.7 Table 255. Processor Error Record, the "Local APIC_ID"

My pdf says this is table 252.

> field is 8 bytes but Linux defines this field as 1 byte.
> 
> Fix this in the struct cper_sec_proc_ia definition.
> 
> Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
> ---
> Link:
> https://lkml.kernel.org/r/20180223200333.6410-2-Yazen.Ghannam@amd.com
> 
> v1->v2:
> * No changes.
> 
>  include/linux/cper.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/cper.h b/include/linux/cper.h
> index d14ef4e77c8a..4b5f8459b403 100644
> --- a/include/linux/cper.h
> +++ b/include/linux/cper.h
> @@ -381,7 +381,7 @@ struct cper_sec_proc_generic {
>  /* IA32/X64 Processor Error Section */
>  struct cper_sec_proc_ia {
>  	__u64	validation_bits;
> -	__u8	lapic_id;
> +	__u64	lapic_id;
>  	__u8	cpuid[48];

Ok, that processor error record has a variable length structure at byte
offset 64 and we don't have it in this struct.

I guess I'll see it in the following patches but right now it looks
like that "Processor Error Info" thing is simply situated after that
Processor Error Record so we are supposed to simply find the info at
offset 64...

/me continues reading...

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
