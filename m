From: Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 3/3] arm64/efi: isolate EFI stub from the kernel proper
Date: Fri, 9 Oct 2015 11:12:24 +0300
Message-ID: <CAPAsAGz7Tp6Z87tPq_NNh_mcwPF_DOaXzu0po5f6AQxPAcsALQ@mail.gmail.com>
References: <1444330924-17830-1-git-send-email-ard.biesheuvel@linaro.org>
	<1444330924-17830-4-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444330924-17830-4-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

2015-10-08 22:02 GMT+03:00 Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>:
> --- a/arch/arm64/kernel/image.h
> +++ b/arch/arm64/kernel/image.h
> @@ -59,4 +59,31 @@
>         _kernel_offset_le       = DATA_LE64(TEXT_OFFSET);       \
>         _kernel_flags_le        = DATA_LE64(__HEAD_FLAGS);
>
> +#ifdef CONFIG_EFI
> +
> +/*
> + * The EFI stub has its own symbol namespace prefixed by __efistub_, to
> + * isolate it from the kernel proper. The following symbols are legally
> + * accessed by the stub, so provide some aliases to make them accessible.
> + * Only include data symbols here, or text symbols of functions that are
> + * guaranteed to be safe when executed at another offset than they were
> + * linked at. The routines below are all implemented in assembler in a
> + * position independent manner
> + */
> +__efistub_memcmp               = __pi_memcmp;
> +__efistub_memchr               = __pi_memchr;
> +__efistub_memcpy               = __pi_memcpy;
> +__efistub_memmove              = __pi_memmove;
> +__efistub_memset               = __pi_memset;
> +__efistub_strlen               = __pi_strlen;
> +__efistub_strcmp               = __pi_strcmp;
> +__efistub_strncmp              = __pi_strncmp;
> +__efistub___flush_dcache_area  = __pi___flush_dcache_area;

So why we need these __pi_* aliases?
We could just do __efistub_memcmp = memcmp; Right?


> +
> +__efistub__text                        = _text;
> +__efistub__end                 = _end;
> +__efistub__edata               = _edata;
> +
> +#endif
