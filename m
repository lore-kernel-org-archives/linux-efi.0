From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] efi/libstub: arm/arm64: don't use TASK_SIZE when
 randomising the RT space
Date: Mon, 10 Apr 2017 15:42:11 +0100
Message-ID: <20170410144210.GA30647@e104818-lin.cambridge.arm.com>
References: <20170410103038.20117-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170410103038.20117-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Apr 10, 2017 at 11:30:38AM +0100, Ard Biesheuvel wrote:
> As reported by James, Catalin and Mark, commit e69176d68d26
> ("ef/libstub/arm/arm64: Randomize the base of the UEFI rt services
> region") results in a crash in the firmware regardless of whether KASLR
> is in effect or not, and whether the firmware implements EFI_RNG_PROTOCOL
> or not.
> 
> Mark has identified the root cause to be the inappropriate use of
> TASK_SIZE in the stub, which arm64 defines as
> 
>   #define TASK_SIZE             (test_thread_flag(TIF_32BIT) ? \
>                                 TASK_SIZE_32 : TASK_SIZE_64)
> 
> and testing thread flags at this point results in the dereference of
> pointers in uninitialized structures.
> 
> So instead, introduce a preprocessor symbol EFI_RT_VIRTUAL_LIMIT and
> define it to TASK_SIZE_64 on arm64 and TASK_SIZE on ARM, both of which
> are compile time constants. Also, change the 'headroom' variable to
> static const to force an error if this changes in the future.
> 
> Cc: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
> Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

It works for me as well:

Tested-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>

Thanks Ard and Mark.

-- 
Catalin
