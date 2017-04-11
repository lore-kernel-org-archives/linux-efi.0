From: Jon Masters <jcm@jonmasters.org>
Subject: Re: [PATCH 11/12] efi/libstub: arm/arm64: Disable debug prints on
 'quiet' cmdline arg
Date: Tue, 11 Apr 2017 00:08:39 -0400
Message-ID: <a9363868-c4a4-e504-25e1-3813190a3db0@jonmasters.org>
References: <20170404160245.27812-1-ard.biesheuvel@linaro.org>
 <20170404160910.28115-1-ard.biesheuvel@linaro.org>
 <20170404160910.28115-2-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170404160910.28115-2-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: matt@codeblueprint.co.uk, mark.rutland@arm.com, roy.franz@cavium.com, rruigrok@codeaurora.org, leif.lindholm@linaro.org, jhugo@codeaurora.org, evgeny.kalugin@intel.com, eugene@hp.com, bp@alien8.de, bhsharma@redhat.com, bhe@redhat.com, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 04/04/2017 12:09 PM, Ard Biesheuvel wrote:
> The EFI stub currently prints a number of diagnostic messages that do
> not carry a lot of information. Since these prints are not controlled
> by 'loglevel' or other command line parameters, and since they appear on
> the EFI framebuffer as well (if enabled), it would be nice if we could
> turn them off.
> 
> So let's add support for the 'quiet' command line parameter in the stub,
> and disable the non-error prints if it is passed.

> +extern int __pure is_quiet(void);
> +
> +#define pr_efi(sys_table, msg)		do {				\
> +	if (!is_quiet()) efi_printk(sys_table, "EFI stub: "msg);	\
> +} while (0)
> +
> +#define pr_efi_err(sys_table, msg) efi_printk(sys_table, "EFI stub: ERROR: "msg)

Thanks for this one :)

Jon.
