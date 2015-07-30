From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 04/16] x86/efi: Generating random number in EFI stub
Date: Thu, 30 Jul 2015 16:37:42 +0100
Message-ID: <1438270662.11322.6.camel@intel.com>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
	 <1437056730-15247-5-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437056730-15247-5-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2015-07-16 at 22:25 +0800, Lee, Chun-Yi wrote:
> This patch adds the codes for generating random number array as the
> HMAC key that will used by later EFI stub codes.
> 
> The original codes in efi_random copied from aslr and add the codes
> to accept input entropy and EFI debugging. In later patch will add
> the codes to get random number by EFI protocol. The separate codes
> can avoid impacting aslr function.
> 
> Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> ---
>  arch/x86/boot/compressed/Makefile     |  1 +
>  arch/x86/boot/compressed/efi_random.c | 88 +++++++++++++++++++++++++++++++++++
>  arch/x86/boot/compressed/misc.c       |  4 +-
>  arch/x86/boot/compressed/misc.h       |  2 +-
>  4 files changed, 92 insertions(+), 3 deletions(-)
>  create mode 100644 arch/x86/boot/compressed/efi_random.c

[...]

> +static unsigned long get_random_long(unsigned long entropy,
> +				     struct boot_params *boot_params,
> +				     efi_system_table_t *sys_table)
> +{
> +#ifdef CONFIG_X86_64
> +	const unsigned long mix_const = 0x5d6008cbf3848dd3UL;
> +#else
> +	const unsigned long mix_const = 0x3f39e593UL;
> +#endif
> +	unsigned long raw, random;
> +	bool use_i8254 = true;
> +
> +	efi_printk(sys_table, " EFI random");

Probably want to remove these efi_printk()s from the final version ;-)

> +	if (entropy)
> +		random = entropy;
> +	else
> +		random = get_random_boot(boot_params);
> +
> +	if (rdrand_feature()) {
> +		efi_printk(sys_table, " RDRAND");
> +		if (rdrand_long(&raw)) {
> +			random ^= raw;
> +			use_i8254 = false;
> +		}
> +	}
> +
> +	if (rdtsc_feature()) {
> +		efi_printk(sys_table, " RDTSC");
> +		rdtscll(raw);
> +
> +		random ^= raw;
> +		use_i8254 = false;
> +	}
> +
> +	if (use_i8254) {
> +		efi_printk(sys_table, " i8254");
> +		random ^= i8254();
> +	}
> +
> +	/* Circular multiply for better bit diffusion */
> +	asm("mul %3"
> +	    : "=a" (random), "=d" (raw)
> +	    : "a" (random), "rm" (mix_const));
> +	random += raw;
> +
> +	efi_printk(sys_table, "...\n");
> +
> +	return random;
> +}
> +
> +void efi_get_random_key(efi_system_table_t *sys_table,
> +			struct boot_params *params, u8 key[], int size)
> +{

I would think that the size of the key array should be unsigned.
