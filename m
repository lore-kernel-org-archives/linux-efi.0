From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 5/9] efi/arm*: libstub: Invoke EFI_RNG_PROTOCOL to seed
 the UEFI RNG table
Date: Sun, 13 Nov 2016 08:19:39 +0100
Message-ID: <20161113071939.GA31483@gmail.com>
References: <20161112213237.8804-1-matt@codeblueprint.co.uk>
 <20161112213237.8804-6-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161112213237.8804-6-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt@codeblueprint.co.uk> wrote:

> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> Invoke the EFI_RNG_PROTOCOL protocol in the context of the stub and
> install the Linux-specific RNG seed UEFI config table. This will be
> picked up by the EFI routines in the core kernel to seed the kernel
> entropy pool.
> 
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

This commit (and the commits after this one) doesn't have a proper signoff chain, 
probably due to rebasing?

I'll apply the patches from email and add your SOB.

Thanks,

	Ingo
