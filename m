From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 08/14] arm64: efi: split Image code and data into
 separate PE/COFF sections
Date: Fri, 10 Feb 2017 10:49:43 +0000
Message-ID: <20170210104942.GF28753@leverpostej>
References: <1486554947-3964-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486554947-3964-9-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1486554947-3964-9-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, labbott-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 08, 2017 at 11:55:41AM +0000, Ard Biesheuvel wrote:
> To prevent unintended modifications to the kernel text (malicious or
> otherwise) while running the EFI stub, describe the kernel image as
> two separate sections: a .text section with read-execute permissions,
> covering .text, .rodata and .init.text, and a .data section with
> read-write permissions, covering .init.data, .data and .bss.
> 
> This relies on the firmware to actually take the section permission
> flags into account, but this is something that is currently being
> implemented in EDK2, which means we will likely start seeing it in
> the wild between one and two years from now.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> index b8deffa9e1bf..a93cc2b6f50b 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -149,6 +149,9 @@ SECTIONS
>  		ARM_EXIT_KEEP(EXIT_TEXT)
>  	}
>  
> +	. = ALIGN(SZ_4K);
> +	__pecoff_data_start = .;
> +

I understand that the stub needs to split the init text/data since
unlike the kernel it'll map those with separate permissions, but it
feels odd to do this specifically for the EFI stub.

Yould it perhaps make more sense to always use separate segments for
init/exit text/data, and also apply the permission split in the kernel?

With that, I don't think we'd need additional stub-specific linker
script changes.

Thanks,
Mark.

>  	.init.data : {
>  		INIT_DATA
>  		INIT_SETUP(16)
> @@ -206,6 +209,7 @@ SECTIONS
>  	}
>  
>  	PECOFF_EDATA_PADDING
> +	__pecoff_data_rawsize = ABSOLUTE(. - __pecoff_data_start);
>  	_edata = .;
>  
>  	BSS_SECTION(0, 0, 0)
> @@ -221,6 +225,7 @@ SECTIONS
>  	. += RESERVED_TTBR0_SIZE;
>  #endif
>  
> +	__pecoff_data_size = ABSOLUTE(. - __pecoff_data_start);
>  	_end = .;
>  
>  	STABS_DEBUG
> -- 
> 2.7.4
> 
