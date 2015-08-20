From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH v2 05/16] x86/efi: Get entropy through EFI random number
 generator protocol
Date: Thu, 20 Aug 2015 15:47:06 +0100
Message-ID: <20150820144706.GD2567@codeblueprint.co.uk>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
 <1439273796-25359-6-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1439273796-25359-6-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

On Tue, 11 Aug, at 02:16:25PM, Lee, Chun-Yi wrote:
> To grab random numbers through EFI protocol as one of the entropies
> source of swsusp key, this patch adds the logic for accessing EFI RNG
> (random number generator) protocol that's introduced since UEFI 2.4.
> 
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  arch/x86/boot/compressed/efi_random.c | 209 ++++++++++++++++++++++++++++++++++
>  include/linux/efi.h                   |  13 +++
>  2 files changed, 222 insertions(+)

[...]

Most of this looks good.

> +static unsigned long efi_get_rng(efi_system_table_t *sys_table)
> +{
> +	const struct efi_config *efi_early = __efi_early();
> +	unsigned long random = 0;
> +	efi_status_t status;
> +	void **rng_handle = NULL;
> +
> +	status = efi_locate_rng(sys_table, &rng_handle);
> +	if (status != EFI_SUCCESS)
> +		return 0;
> +
> +	if (efi_early->is64)
> +		random = efi_get_rng64(sys_table, rng_handle);
> +	else
> +		random = efi_get_rng32(sys_table, rng_handle);
> +
> +	efi_call_early(free_pool, rng_handle);
> +
> +	return random;
> +}
  
I think this function is named particularly poorly in the UEFI spec
(GetRNG), can we maybe make this efi_get_rng_number(),
efi_get_rng_value() or efi_get_rng_long() to match the existing
naming?

> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 85ef051..8914d60 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -427,6 +427,16 @@ typedef struct {
>  #define EFI_PCI_IO_ATTRIBUTE_VGA_PALETTE_IO_16 0x20000
>  #define EFI_PCI_IO_ATTRIBUTE_VGA_IO_16 0x40000
>  
> +typedef struct {
> +	u32 get_info;
> +	u32 get_rng;
> +} efi_rng_protocol_32;
> +
> +typedef struct {
> +	u64 get_info;
> +	u64 get_rng;
> +} efi_rng_protocol_64;
> +

We've been kinda slack with the naming conventions in efi.h but these
should really both be 'efi_rng_protocol_*_t'.

-- 
Matt Fleming, Intel Open Source Technology Center
