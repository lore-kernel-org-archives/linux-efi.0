From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 10/13] efi/capsule: Add support for Quark security header
Date: Mon, 5 Jun 2017 16:00:33 +0000
Message-ID: <CAKv+Gu8ByPXuWGNXGhbVrzyBd98r7ib8trGySEsC1FxrqY=38A@mail.gmail.com>
References: <20170602135207.21708-1-ard.biesheuvel@linaro.org>
 <20170602135207.21708-11-ard.biesheuvel@linaro.org> <20170605155050.fuhwcjkmmdqc67d2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170605155050.fuhwcjkmmdqc67d2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 5 June 2017 at 15:50, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> * Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
>> From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
>>
>> The firmware for Quark X102x prepends a security header to the capsule
>> which is needed to support the mandatory secure boot on this processor.
>> The header can be detected by checking for the "_CSH" signature and -
>> to avoid any GUID conflict - validating its size field to contain the
>> expected value. Then we need to look for the EFI header right after the
>> security header and pass the real header to __efi_capsule_setup_info.
>>
>> To be minimal invasive and maximal safe, the quirk version of
>> efi_capsule_identify_image is only effective on Quark processors.
>
> So there's no efi_capsule_identify_image() function anywhere - this wants to be
> efi_capsule_setup_info(), right?
>
> I have edited the changelog accordingly.
>

Thanks

>> +config EFI_CAPSULE_QUIRK_QUARK_CSH
>> +     boolean "Add support for Quark capsules with non-standard headers"
>> +     depends on X86 && !64BIT
>> +     select EFI_CAPSULE_LOADER
>> +     default y
>> +     help
>> +       Add support for processing Quark X1000 EFI capsules, whose header
>> +       layout deviates from the layout mandated by the UEFI specification.
>
> BTW., there's no need to further put this behind a Kconfig option: the quirk seems
> targeted enough, and the whole point of runtime quirks is so that can be applied
> safely within generic kernels. Turning them off via Kconfig seems wrong.
>

Not entirely: enabling this quirk will remove the ability to select
EFI_CAPSULE_LOADER as a module. So making it unconditional makes
EFI_CAPSULE_LOADER builtin-only for 32-bit x86. This is necessary for
the override of __weak symbols in the generic capsule code to work as
expected.

This was a compromise between allowing no capsule loader quirks at
all, and having an elaborate framework with hooks in various places
(which invariably ends up parameterizing the wrong things if you have
only one real world quirk to design your framework around).
