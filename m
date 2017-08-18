From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH] Enable reset attack mitigation
Date: Fri, 18 Aug 2017 12:08:34 -0700
Message-ID: <CACdnJuty5W0EPLQvBsM=1ySRwCz5Kh4Ht_brZ5pn9ueyF9fT5A@mail.gmail.com>
References: <20170804212010.15064-1-mjg59@google.com> <CAKv+Gu89bW5CrddxFan095NK_ZmcCpeG_vzx1BuxJ+z-yj3VGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu89bW5CrddxFan095NK_ZmcCpeG_vzx1BuxJ+z-yj3VGQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

On Fri, Aug 18, 2017 at 11:52 AM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> On 4 August 2017 at 22:20, Matthew Garrett <mjg59@google.com> wrote:
>> + * Enable reboot attack mitigation. This requests that the firmware clear the
>> + * RAM on next reboot before proceeding with boot, ensuring that any secrets
>> + * are cleared. If userland has ensured that all secrets have bene removed
>
> s/bene/been/

Thanks.

>> +       set_efi_var(efi_MemoryOverWriteRequest_name, &var_guid,
>> +                   EFI_VARIABLE_NON_VOLATILE |
>> +                   EFI_VARIABLE_BOOTSERVICE_ACCESS |
>> +                   EFI_VARIABLE_RUNTIME_ACCESS, sizeof(val), val);
>
> Shouldn't this be &val?

Ooh, good catch - not sure how that got eaten.

>> What's the threat model? If there's no way for userland to ask the
>> kernel to drop any secrets it still holds, that seems like a problem
>> in any case. If the concern is that someone may be able to clear the
>> flag and then reboot in order to deliberately attempt to obtain kernel
>> secrets then there's no hugely easy way around this without special
>> casing the variable and preventing userland from being able to modify
>> it. There's a MemoryOverwriteRequestLock spec from Microsoft that
>> provides a mechanism for this (the firmware and the OS configure a
>> shared secret that controls access to MemoryOverwriteRequestControl,
>> so we'd keep that in the kernel and clear it on reboot), but that's
>> not implemented everywhere and we'd still want to base on top of this.
>
> So how would that work with, e.g., the keys for your encrypted file
> system? Surely, you can't expect the kernel to drop that secret when
> userland asks it to, so there will always be a window where userland
> has set the variable but the kernel is not ready to drop its secrets
> yet.

If the kernel doesn't synchronously zero the key when dm-crypt is torn
down, that feels like a bug?
