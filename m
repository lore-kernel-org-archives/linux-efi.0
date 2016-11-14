From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 5/9] efi/arm*: libstub: Invoke EFI_RNG_PROTOCOL to seed
 the UEFI RNG table
Date: Mon, 14 Nov 2016 14:01:58 +0000
Message-ID: <20161114140158.GD2373@codeblueprint.co.uk>
References: <20161112213237.8804-1-matt@codeblueprint.co.uk>
 <20161112213237.8804-6-matt@codeblueprint.co.uk>
 <20161113071939.GA31483@gmail.com>
 <20161114132334.GB2373@codeblueprint.co.uk>
 <20161114135521.GA10151@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161114135521.GA10151@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 14 Nov, at 02:55:22PM, Ingo Molnar wrote:
> 
> The problem is not that Ard applied the patches, but that you subsequently rebased 
> the tree. For example:
> 
>  commit bf5d1f98c1d8be04a40eabb9dd6913347b1b3fc4
>  Author:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
>  AuthorDate: Thu Oct 20 12:21:26 2016 +0100
>  Commit:     Matt Fleming <matt@codeblueprint.co.uk>
>  CommitDate: Sat Nov 12 21:14:41 2016 +0000
> 
>     efi/arm*: libstub: Invoke EFI_RNG_PROTOCOL to seed the UEFI RNG table
>     
>     Invoke the EFI_RNG_PROTOCOL protocol in the context of the stub and
>     install the Linux-specific RNG seed UEFI config table. This will be
>     picked up by the EFI routines in the core kernel to seed the kernel
>     entropy pool.
>     
>     Cc: Matt Fleming <matt@codeblueprint.co.uk>
>     Reviewed-by: Kees Cook <keescook@chromium.org>
>     Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
 
Ah yes, this is exactly what happened.

> if you rebase it (with your co-maintainer's permission) then you need to add your 
> SoB tag.

OK, will do so in future. Thanks Ingo.
