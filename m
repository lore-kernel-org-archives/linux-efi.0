From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] efi/arm64: preserve FP/SIMD registers on UEFI
 runtime services calls
Date: Fri, 4 Jul 2014 17:51:31 +0200
Message-ID: <CAKv+Gu947rsPRbWEY=TDBkkvoNanu-P+6Eej7Z3_crysx96F=g@mail.gmail.com>
References: <1403777346-28629-1-git-send-email-ard.biesheuvel@linaro.org>
	<1403777346-28629-3-git-send-email-ard.biesheuvel@linaro.org>
	<20140704154522.GJ16404@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140704154522.GJ16404-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Olivier Martin <Olivier.Martin-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 4 July 2014 17:45, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org> wrote:
> On Thu, Jun 26, 2014 at 11:09:06AM +0100, Ard Biesheuvel wrote:
>> According to the UEFI spec section 2.3.6.4, the use of FP/SIMD instructions is
>> allowed, and should adhere to the AAPCS64 calling convention, which states that
>> 'only the bottom 64 bits of each value stored in registers v8-v15 need to be
>> preserved' (section 5.1.2).
>>
>> This applies equally to UEFI Runtime Services called by the kernel, so make sure
>> the FP/SIMD register file is preserved in this case.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> While the code looks fine, I think there is a mismatch between what the
> subject says and what the patch does (enabling EFI_RUNTIME_WRAPPERS).
>

Not entirely. In order to be able to insert calls to
kernel_neon_begin()/end() into the runtime services calls, we need
a) to supply definitions for efi_call_virt() and __efi_call_virt()
that contain those calls to kernel_neon_begin()/end()
b) to enable runtime wrappers (which is what uses those definitions)

Would you prefer those to be split in 2 patches?

--
Ard.
