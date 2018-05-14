From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 17/17] efi/libstub/arm64: handle randomized TEXT_OFFSET
Date: Mon, 14 May 2018 08:47:01 +0200
Message-ID: <20180514064701.GC16596@gmail.com>
References: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
 <20180504060003.19618-18-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180504060003.19618-18-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Mark Rutland <mark.rutland@arm.com>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> From: Mark Rutland <mark.rutland@arm.com>
> 
> When CONFIG_RANDOMIZE_TEXT_OFFSET is selected, TEXT_OFFSET is an
> arbitrary multiple of PAGE_SIZE in the interval [0, 2MB).
> 
> The EFI stub does not account for the potential misalignment of
> TEXT_OFFSET relative to EFI_KIMG_ALIGN, and produces a randomized
> physical offset which is always a round multiple of EFI_KIMG_ALIGN.
> This may result in statically allocated objects whose alignment exceeds
> PAGE_SIZE to appear misaligned in memory. This has been observed to
> result in spurious stack overflow reports and failure to make use of
> the IRQ stacks, and theoretically could result in a number of other
> issues.
> 
> We can OR in the low bits of TEXT_OFFSET to ensure that we have the
> necessary offset (and hence preserve the misalignment of TEXT_OFFSET
> relative to EFI_KIMG_ALIGN), so let's do that.
> 
> Fixes: 6f26b3671184c36d ("arm64: kaslr: increase randomization granularity")
> Cc: <stable@vger.kernel.org> # v4.7+
> Reported-by: Kim Phillips <kim.phillips@arm.com>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Tested-by: Kim Phillips <kim.phillips@arm.com>
> [ardb: clarify commit log]
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/firmware/efi/libstub/arm64-stub.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
> index b9bd827caa22..541b82fdc8a2 100644
> --- a/drivers/firmware/efi/libstub/arm64-stub.c
> +++ b/drivers/firmware/efi/libstub/arm64-stub.c
> @@ -97,6 +97,13 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table_arg,
>  		u32 offset = !IS_ENABLED(CONFIG_DEBUG_ALIGN_RODATA) ?
>  			     (phys_seed >> 32) & mask : TEXT_OFFSET;
>  
> +		/*
> +		 * With CONFIG_RANDOMIZE_TEXT_OFFSET, TEXT_OFFSET may not be a
> +		 * multiple of EFI_KIMG_ALIGN, and we must ensure that we apply
> +		 * the offset below EFI_KIMG_ALIGN.
> +		 */

When referring to config variables in comments and changelogs I'd suggest a bit 
more verbosity:

  s/CONFIG_RANDOMIZE_TEXT_OFFSET
   /CONFIG_RANDOMIZE_TEXT_OFFSET=y

... because at first I thought (based on the name) that 
CONFIG_RANDOMIZE_TEXT_OFFSET is an actual integer offset value - while it's a 
bool. The =y makes the bool nature obvious.

( Similarly, when negated the canonical way to refer to it is 
  !CONFIG_RANDOMIZE_TEXT_OFFSET. )

> +		offset |= (TEXT_OFFSET % EFI_KIMG_ALIGN);

The parentheses are not needed here I think.

Thanks,

	Ingo
