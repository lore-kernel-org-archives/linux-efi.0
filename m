From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] efi/libstub: arm/arm64: don't use TASK_SIZE when randomising
 the RT space
Date: Mon, 10 Apr 2017 12:34:42 +0100
Message-ID: <58EB6DD2.1010102@arm.com>
References: <20170410103038.20117-1-ard.biesheuvel@linaro.org> <20170410104403.GC13899@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170410104403.GC13899@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Ard, Mark

On 10/04/17 11:44, Mark Rutland wrote:
> On Mon, Apr 10, 2017 at 11:30:38AM +0100, Ard Biesheuvel wrote:
>> As reported by James, Catalin and Mark, commit e69176d68d26
>> ("ef/libstub/arm/arm64: Randomize the base of the UEFI rt services
>> region") results in a crash in the firmware regardless of whether KASLR
>> is in effect or not, and whether the firmware implements EFI_RNG_PROTOCOL
>> or not.
>>
>> Mark has identified the root cause to be the inappropriate use of
>> TASK_SIZE in the stub, which arm64 defines as
>>
>>   #define TASK_SIZE             (test_thread_flag(TIF_32BIT) ? \
>>                                 TASK_SIZE_32 : TASK_SIZE_64)
>>
>> and testing thread flags at this point results in the dereference of
>> pointers in uninitialized structures.
>>
>> So instead, introduce a preprocessor symbol EFI_RT_VIRTUAL_LIMIT and
>> define it to TASK_SIZE_64 on arm64 and TASK_SIZE on ARM, both of which
>> are compile time constants. Also, change the 'headroom' variable to
>> static const to force an error if this changes in the future.
>>
>> Cc: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
>> Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
>> Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
>> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
>> Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> With this patch applied atop of next-20170410, a defconfig arm64 kernel
> built with the Linaro 15.08 toolchain boots happily for me on Juno R1.

Likewise, this fixes the problem I was seeing on Seattle. If it's useful:
Tested-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>

Thanks for debugging that so quickly Mark!


James
