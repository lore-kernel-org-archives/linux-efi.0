From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 10/13] efi/capsule: Add support for Quark security header
Date: Mon, 5 Jun 2017 17:50:50 +0200
Message-ID: <20170605155050.fuhwcjkmmdqc67d2@gmail.com>
References: <20170602135207.21708-1-ard.biesheuvel@linaro.org>
 <20170602135207.21708-11-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170602135207.21708-11-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Jan Kiszka <jan.kiszka@siemens.com>, linux-kernel@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> From: Jan Kiszka <jan.kiszka@siemens.com>
> 
> The firmware for Quark X102x prepends a security header to the capsule
> which is needed to support the mandatory secure boot on this processor.
> The header can be detected by checking for the "_CSH" signature and -
> to avoid any GUID conflict - validating its size field to contain the
> expected value. Then we need to look for the EFI header right after the
> security header and pass the real header to __efi_capsule_setup_info.
> 
> To be minimal invasive and maximal safe, the quirk version of
> efi_capsule_identify_image is only effective on Quark processors.

So there's no efi_capsule_identify_image() function anywhere - this wants to be 
efi_capsule_setup_info(), right?

I have edited the changelog accordingly.

> +config EFI_CAPSULE_QUIRK_QUARK_CSH
> +	boolean "Add support for Quark capsules with non-standard headers"
> +	depends on X86 && !64BIT
> +	select EFI_CAPSULE_LOADER
> +	default y
> +	help
> +	  Add support for processing Quark X1000 EFI capsules, whose header
> +	  layout deviates from the layout mandated by the UEFI specification.

BTW., there's no need to further put this behind a Kconfig option: the quirk seems 
targeted enough, and the whole point of runtime quirks is so that can be applied 
safely within generic kernels. Turning them off via Kconfig seems wrong.

Thanks,

	Ingo
