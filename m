From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 8/8] efi/capsule: Add support for Quark security header
Date: Tue, 18 Apr 2017 13:48:53 +0100
Message-ID: <20170418124853.GH24360@codeblueprint.co.uk>
References: <20170405092317.27921-1-ard.biesheuvel@linaro.org>
 <20170405092317.27921-9-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170405092317.27921-9-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org, hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org, jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 05 Apr, at 10:23:17AM, Ard Biesheuvel wrote:
> From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
> 
> The firmware for Quark X102x prepends a security header to the capsule
> which is needed to support the mandatory secure boot on this processor.
> The header can be detected by checking for the "_CSH" signature and -
> to avoid any GUID conflict - validating its size field to contain the
> expected value. Then we need to look for the EFI header right after the
> security header and pass the real header to __efi_capsule_setup_info.
> 
> To be minimally invasive and maximally safe, the quirk version of
> efi_capsule_identify_image is only effective on Quark processors.
> 
> Signed-off-by: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> [ardb: refactor using an override of efi_capsule_setup_info()]
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/x86/platform/efi/quirks.c | 112 ++++++++++++++++++++
>  drivers/firmware/efi/Kconfig   |   9 ++
>  2 files changed, 121 insertions(+)

[...]

> @@ -495,3 +549,61 @@ bool efi_poweroff_required(void)
>  {
>  	return acpi_gbl_reduced_hardware || acpi_no_s5;
>  }
> +
> +#ifdef CONFIG_EFI_CAPSULE_QUIRK_QUARK_CSH
> +
> +static const struct x86_cpu_id quark_ids[] = {
> +	{ X86_VENDOR_INTEL, 5, 9 },	/* Intel Quark X1000 */
> +	{ }
> +};
> +
> +int efi_capsule_setup_info(struct capsule_info *cap_info, void *kbuff,
> +			   size_t hdr_bytes)
> +{
> +	struct quark_security_header *csh = kbuff;
> +
> +	cap_info->total_size = 0;
> +
> +	if (!x86_match_cpu(quark_ids))
> +		goto fallback;
> +

I'd prefer to see the quark quirk pulled out into its own function and
referenced from the __weak efi_capsule_setup_info() function, which
makes it easier to people to read the EFI capsule code flow if they're
not interested in the Quark quick.

Something like this,

int efi_capsule_setup_info(...)
{
	...

	if (x86_match_cpu(quark_ids))
		return efi_capsule_quark_setup_quirk(cap_info, kbuff, hdr_bytes);

> +	if (hdr_bytes < sizeof(efi_capsule_header_t))
> +		return 0;
> +
> +	memcpy(&cap_info->header, kbuff, sizeof(cap_info->header));
> +
> +	cap_info->total_size += cap_info->header.imagesize;
> +
> +	return __efi_capsule_setup_info(cap_info);
> +}

Or something.

Otherwise this looks fine to me.
