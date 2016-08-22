From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 4/6] efi/libstub: Use efi_exit_boot_services() in FDT
Date: Mon, 22 Aug 2016 18:43:33 +0200
Message-ID: <20160822164332.GC11327@gmail.com>
References: <1471638904-3494-1-git-send-email-matt@codeblueprint.co.uk>
 <1471638904-3494-5-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1471638904-3494-5-git-send-email-matt@codeblueprint.co.uk>
Sender: stable-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Jeffrey Hugo <jhugo@codeaurora.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, Mark Rutland <mark.rutland@arm.com>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt@codeblueprint.co.uk> wrote:

> From: Jeffrey Hugo <jhugo@codeaurora.org>
> 
> The FDT code directly calls ExitBootServices.  This is inadvisable as the
> UEFI spec details a complex set of errors, race conditions, and API
> interactions that the caller of ExitBootServices must get correct.  The
> FDT code does not handle EFI_INVALID_PARAMETER as required by the spec,
> which causes intermittent boot failures on the Qualcomm Technologies
> QDF2432.  The efi_exit_boot_services() helper handles the
> EFI_INVALID_PARAMETER scenario.

So I had to look twice to understand what this commit tries to do.

Had it ended with this sentence:

> Call the efi_exit_boot_services() helper intead, which handles the 
> EFI_INVALID_PARAMETER scenario properly.

I wouldn't have looked twice! ;-)

> +	/*
> +	 * Update the memory map with virtual addresses. The function will also
> +	 * populate @runtime_map with copies of just the EFI_MEMORY_RUNTIME
> +	 * entries so that we can pass it straight into SetVirtualAddressMap()

s/straight to

?

Thanks,

	Ingo
