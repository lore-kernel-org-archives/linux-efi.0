From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: move arm64 specific stub C code to libstub
Date: Fri, 30 Oct 2015 12:57:48 +0100
Message-ID: <CAKv+Gu80ztGR88-FK5rBUgDJ9vk+c3Kz+L8wp7aUpx2FPE9-cw@mail.gmail.com>
References: <1445611694-31838-1-git-send-email-ard.biesheuvel@linaro.org>
	<20151029183933.GU8899@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151029183933.GU8899-M2fw3Uu6cmfZROr8t4l/smS4ubULX0JqMm0uRHvK7Nw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "Suzuki K. Poulose" <Suzuki.Poulose-5wv7dgnIgG8@public.gmane.org>, Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 29 October 2015 at 19:39, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org> wrote:
> On Fri, Oct 23, 2015 at 04:48:14PM +0200, Ard Biesheuvel wrote:
>> Now that we added special handling to the C files in libstub, move
>> the one remaining arm64 specific EFI stub C file to libstub as
>> well, so that it gets the same treatment. This should prevent future
>> changes from resulting in binaries that may execute incorrectly in
>> UEFI context.
>>
>> With efi-entry.S the only remaining EFI stub source file under
>> arch/arm64, we can also simplify the Makefile logic somewhat.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>
>> I would like to suggest that this be taken on top of the stuff that is
>> queued for 4.4 at the moment (if it is not too late already).
>
> Applied. Thanks.
>

Please note (before you push it out), that Will just pulled a 4.3-rc
fix that changes arch/arm64/kernel/efi-stub.c
