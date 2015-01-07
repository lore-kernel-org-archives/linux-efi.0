From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 6/8] arm64/efi: move SetVirtualAddressMap() to UEFI stub
Date: Wed, 7 Jan 2015 12:30:27 +0000
Message-ID: <CAKv+Gu-aRkoRj5zVXrsBc0APCehZ9W926J6fxH380K9EURXe_Q@mail.gmail.com>
References: <1419245944-2424-1-git-send-email-ard.biesheuvel@linaro.org>
	<1419245944-2424-7-git-send-email-ard.biesheuvel@linaro.org>
	<20150107120608.GJ3827@bivouac.eciton.net>
	<CAKv+Gu_k0_anqvm24P8J4WaMrFLMxOhQETAfUb6xmzaJ+Z2vBQ@mail.gmail.com>
	<20150107122515.GK3827@bivouac.eciton.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150107122515.GK3827-t77nlHhSwNqAroYi2ySoxKxOck334EZe@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Geoff Levand <geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 7 January 2015 at 12:25, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On Wed, Jan 07, 2015 at 12:16:02PM +0000, Ard Biesheuvel wrote:
>> >> diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
>> >> index 71291253114f..6cc668a378c5 100644
>> >> --- a/arch/arm64/include/asm/efi.h
>> >> +++ b/arch/arm64/include/asm/efi.h
>> >> @@ -7,28 +7,36 @@
>> >>  #ifdef CONFIG_EFI
>> >>  extern void efi_init(void);
>> >>  extern void efi_idmap_init(void);
>> >> +extern void efi_virtmap_init(void);
>> >>  #else
>> >>  #define efi_init()
>> >>  #define efi_idmap_init()
>> >> +#define efi_virtmap_init
>> >>  #endif
>> >>
>> >>  #define efi_call_virt(f, ...)                                                \
>> >>  ({                                                                   \
>> >> -     efi_##f##_t *__f = efi.systab->runtime->f;                      \
>> >> +     efi_##f##_t *__f;                                               \
>> >>       efi_status_t __s;                                               \
>> >>                                                                       \
>> >> -     kernel_neon_begin();                                            \
>> >> +     kernel_neon_begin();    /* disables preemption */               \
>> >
>> > Nitpick: adding comment to otherwise untouched source line.
>> >
>> >> +     efi_virtmap_load();                                             \
>> >> +     __f = efi.systab->runtime->f;                                   \
>> >>       __s = __f(__VA_ARGS__);                                         \
>> >> +     efi_virtmap_unload();                                           \
>> >>       kernel_neon_end();                                              \
>> >>       __s;                                                            \
>> >>  })
>> >>
>> >>  #define __efi_call_virt(f, ...)                                              \
>> >>  ({                                                                   \
>> >> -     efi_##f##_t *__f = efi.systab->runtime->f;                      \
>> >> +     efi_##f##_t *__f;                                               \
>> >>                                                                       \
>> >> -     kernel_neon_begin();                                            \
>> >> +     kernel_neon_begin();    /* disables preemption */               \
>> >
>> > Same nitpick.
>> >
>>
>> Is there anything wrong with that?
>
> I said nitpick.
>
> My (very minor) objection is that a (very reasonable) comment is added
> to existing functionality by a patch that adds new functionality. It
> makes the git blame/praise output less clear.
>
>> Would you prefer the comment to be on a separate line?
>
> I would _prefer_ the comments to be a separate patch.
> But again, a nitpick.
>

Well, adding the comment is relevant to this patch, as we need to
disable preemption now before switching to the new address space. In
fact, it might be better even to drop the comment, and add an explicit
(if redundant) preempt_disable/preempt_enable pair.


>> >> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
>> >> index b80991166754..d8390f507da0 100644
>> >> --- a/arch/arm64/kernel/setup.c
>> >> +++ b/arch/arm64/kernel/setup.c
>> >> @@ -402,6 +402,7 @@ void __init setup_arch(char **cmdline_p)
>> >>       request_standard_resources();
>> >>
>> >>       efi_idmap_init();
>> >> +     efi_virtmap_init();
>> >
>> > Could these two be merged together into one function?
>> > Say efi_memmap_init()?
>> >
>>
>> Well, I decided to do it like this because efi_idmap_init() gets
>> removed in its entirety (including this invocation) in a subsequent
>> patch.
>
> Ah yeah. I knew that yesterday. Ignore me. More coffee.
>
> /
>     Leif
