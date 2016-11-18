From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 05/16] efi: Add EFI_SECURE_BOOT bit
Date: Fri, 18 Nov 2016 12:10:32 +0000
Message-ID: <CAKv+Gu8tx8OgFG6xhZE7UB5pQ0Wy-LPcat0Tj3ZOUbHME-ECYg@mail.gmail.com>
References: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
 <147933287290.19316.3360403691390019935.stgit@warthog.procyon.org.uk>
 <CAKv+Gu_8r3oM-jvvuSiXTzxp0YMEVgc5KkScJ2UhGTaXm28L6w@mail.gmail.com> <CA+5PVA6F5qEnuL2UaXS9_fJ217J93cEZDDsz9Y2BPwHXcMdX-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+5PVA6F5qEnuL2UaXS9_fJ217J93cEZDDsz9Y2BPwHXcMdX-A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 18 November 2016 at 11:58, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org> wrote:
> On Thu, Nov 17, 2016 at 4:58 PM, Ard Biesheuvel
> <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> On 16 November 2016 at 21:47, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> From: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
>>>
>>> UEFI machines can be booted in Secure Boot mode.  Add a EFI_SECURE_BOOT bit
>>> for use with efi_enabled.
>>>
>>> Signed-off-by: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
>>> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> ---
>>>
>>>  arch/x86/kernel/setup.c |    1 +
>>>  include/linux/efi.h     |    1 +
>>>  2 files changed, 2 insertions(+)
>>>
>>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>>> index 9521acce8378..539f29587712 100644
>>> --- a/arch/x86/kernel/setup.c
>>> +++ b/arch/x86/kernel/setup.c
>>> @@ -1164,6 +1164,7 @@ void __init setup_arch(char **cmdline_p)
>>>         if (boot_params.secure_boot &&
>>>             IS_ENABLED(CONFIG_EFI_SECURE_BOOT_LOCK_DOWN)) {
>>>                 lock_kernel_down();
>>> +               set_bit(EFI_SECURE_BOOT, &efi.flags);
>>
>> Why is this x86 only? And why is this bit only set if
>
> Because it was initially written like 3 years ago before ARM even had
> UEFI.  Needs a refresh.
>

Ah ok. I missed that part.

In any case, we have been working very hard over the past couple of
years to move all the UEFI stuff out of arch/x86, except for the
pieces that *really* belong there. For this series, that means that a
fair share of the changes will need to be reworked and moved under
drivers/firmware/efi. Note that that also means you cannot use L""
string literals anymore, since arm64's UEFI stub is linked into the
kernel proper, and the wide character formats are incompatible between
UEFI and the wide char handling that occurs under fs/. Please check
the existing secureboot_enabled() function Lukas referred to as an
example how to emit wide string literals instead.

>> CONFIG_EFI_SECURE_BOOT_LOCK_DOWN is enabled?
>
> That part is new and something David added.  Probably not necessary.
>

Regardless of anything else,  think is is useful to have a EFI_xx flag
that is always set when secure boot is enabled.
