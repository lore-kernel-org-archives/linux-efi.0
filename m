From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/8] efi/x86: Use non-blocking SetVariable() for
 efi_delete_dummy_variable()
Date: Mon, 16 Jul 2018 00:38:08 +0200
Message-ID: <20180715223808.GB16209@gmail.com>
References: <20180711094040.12506-1-ard.biesheuvel@linaro.org>
 <20180711094040.12506-3-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180711094040.12506-3-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Sai Praneeth <sai.praneeth.prakhya@intel.com>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> From: Sai Praneeth <sai.praneeth.prakhya@intel.com>
> 
> Presently, efi_delete_dummy_variable() uses set_variable() which might
> block and hence kernel prints stack trace with a warning "bad:
> scheduling from the idle thread!". So, make efi_delete_dummy_variable()
> use set_variable_nonblocking(), which, as the name suggests doesn't
> block.
> 
> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/x86/platform/efi/quirks.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index 36c1f8b9f7e0..6af39dc40325 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -105,12 +105,11 @@ early_param("efi_no_storage_paranoia", setup_storage_paranoia);
>  */
>  void efi_delete_dummy_variable(void)
>  {
> -	efi.set_variable((efi_char16_t *)efi_dummy_name,
> -			 &EFI_DUMMY_GUID,
> -			 EFI_VARIABLE_NON_VOLATILE |
> -			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
> -			 EFI_VARIABLE_RUNTIME_ACCESS,
> -			 0, NULL);
> +	efi.set_variable_nonblocking((efi_char16_t *)efi_dummy_name,
> +				     &EFI_DUMMY_GUID,
> +				     EFI_VARIABLE_NON_VOLATILE |
> +				     EFI_VARIABLE_BOOTSERVICE_ACCESS |
> +				     EFI_VARIABLE_RUNTIME_ACCESS, 0, NULL);
>  }

Just wondering, what is the full stack trace of the splat? It sounds a bit 
surprising to me that such type of EFI code is used from the idle thread.

Thanks,

	Ingo
