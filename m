From: Josh Boyer <jwboyer@fedoraproject.org>
Subject: Re: [PATCH 05/16] efi: Add EFI_SECURE_BOOT bit
Date: Fri, 18 Nov 2016 06:58:30 -0500
Message-ID: <CA+5PVA6F5qEnuL2UaXS9_fJ217J93cEZDDsz9Y2BPwHXcMdX-A@mail.gmail.com>
References: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
 <147933287290.19316.3360403691390019935.stgit@warthog.procyon.org.uk> <CAKv+Gu_8r3oM-jvvuSiXTzxp0YMEVgc5KkScJ2UhGTaXm28L6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu_8r3oM-jvvuSiXTzxp0YMEVgc5KkScJ2UhGTaXm28L6w@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 17, 2016 at 4:58 PM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> On 16 November 2016 at 21:47, David Howells <dhowells@redhat.com> wrote:
>> From: Josh Boyer <jwboyer@fedoraproject.org>
>>
>> UEFI machines can be booted in Secure Boot mode.  Add a EFI_SECURE_BOOT bit
>> for use with efi_enabled.
>>
>> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
>> Signed-off-by: David Howells <dhowells@redhat.com>
>> ---
>>
>>  arch/x86/kernel/setup.c |    1 +
>>  include/linux/efi.h     |    1 +
>>  2 files changed, 2 insertions(+)
>>
>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>> index 9521acce8378..539f29587712 100644
>> --- a/arch/x86/kernel/setup.c
>> +++ b/arch/x86/kernel/setup.c
>> @@ -1164,6 +1164,7 @@ void __init setup_arch(char **cmdline_p)
>>         if (boot_params.secure_boot &&
>>             IS_ENABLED(CONFIG_EFI_SECURE_BOOT_LOCK_DOWN)) {
>>                 lock_kernel_down();
>> +               set_bit(EFI_SECURE_BOOT, &efi.flags);
>
> Why is this x86 only? And why is this bit only set if

Because it was initially written like 3 years ago before ARM even had
UEFI.  Needs a refresh.

> CONFIG_EFI_SECURE_BOOT_LOCK_DOWN is enabled?

That part is new and something David added.  Probably not necessary.

josh
