From: Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Enable reset attack mitigation
Date: Sat, 5 Aug 2017 09:35:22 -0700
Message-ID: <CACdnJuvCjWLxGfXY-6tytyTr-v8s0TZb_48J5Pju9p5OUuREuQ@mail.gmail.com>
References: <20170804212010.15064-1-mjg59@google.com> <CAKv+Gu-fe-dw-UXZxen4909b=QOF=_RP-V6GHZ8A4u=iVaaqpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu-fe-dw-UXZxen4909b=QOF=_RP-V6GHZ8A4u=iVaaqpw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Aug 5, 2017 at 2:50 AM, Ard Biesheuvel
<ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On 4 August 2017 at 22:20, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> If a machine is reset while secrets are present in RAM, it may be
>> possible for code executed after the reboot to extract those secrets
>> from untouched memory. The Trusted Computing Group specified a mechanism
>> for requesting that the firmware clear all RAM on reset before booting
>> another OS. This is done by setting the MemoryOverwriteRequestControl
>> variable at startup. If userspace can ensure that all secrets are
>> removed as part of a controlled shutdown, it can reset this variable to
>> 0 before triggering a hardware reboot.
>>
>
> Shouldn't it be up to the kernel to decide whether this flag should be
> cleared after userspace has indicated to it that it thinks it has
> wiped all secrets from memory? The kernel itself may keep secrets as
> well, and we may still crash in the time window between userspace
> invoking shutdown and the kernel actually calling ResetSystem() in the
> firmware.

What's the threat model? If there's no way for userland to ask the
kernel to drop any secrets it still holds, that seems like a problem
in any case. If the concern is that someone may be able to clear the
flag and then reboot in order to deliberately attempt to obtain kernel
secrets then there's no hugely easy way around this without special
casing the variable and preventing userland from being able to modify
it. There's a MemoryOverwriteRequestLock spec from Microsoft that
provides a mechanism for this (the firmware and the OS configure a
shared secret that controls access to MemoryOverwriteRequestControl,
so we'd keep that in the kernel and clear it on reboot), but that's
not implemented everywhere and we'd still want to base on top of this.
