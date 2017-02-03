From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/7] efi: Print the secure boot status in x86 setup_arch()
 [ver #7]
Date: Fri, 3 Feb 2017 17:00:44 +0000
Message-ID: <CAKv+Gu88XuQAb7aSmJ=b+u5LDfkE=dgWMwnKUd0U=qKSQXxdrQ@mail.gmail.com>
References: <CAKv+Gu-=-piH7FQF92T6Yn4KUHLQ-C4CtexWe8D27Tuc3h8KdA@mail.gmail.com>
 <148587558696.4026.16034622623568539004.stgit@warthog.procyon.org.uk>
 <148587565838.4026.2835771993519594392.stgit@warthog.procyon.org.uk>
 <CAKv+Gu8otPYWcKw72zP2q+34JAzZ-QRy8xGFmbStO6WseeANdw@mail.gmail.com>
 <13280.1486138918@warthog.procyon.org.uk> <13531.1486139256@warthog.procyon.org.uk>
 <13569.1486139355@warthog.procyon.org.uk> <CAKv+Gu-O+nWmu2s8bCrANJs0JNE4QgaM=ZkSa+bu60C=-6T-Lg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu-O+nWmu2s8bCrANJs0JNE4QgaM=ZkSa+bu60C=-6T-Lg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 3 February 2017 at 16:29, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On 3 February 2017 at 16:29, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>
>>> Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>>>
>>> > Yes, but only if you are booting via UEFI, no?
>>>
>>> Why limit it so?  Even if you don't boot via UEFI, the bootloader/kexec can
>>> always set the secure-boot state on.
>>>
>>> > So perhaps use efi_enabled(EFI_BOOT) instead?
>>>
>>> I've no objection to that, given it incorporates a test of CONFIG_EFI.
>>
>> Feel free to just go ahead and change it in the patch.  We can always take the
>> check out later.
>>
>
> Sure

OK, I have queued these patches (minus the DeployedMode one) in the
next branch on efi.git. Please double check, I will send out a pull
request to tip shortly (once the autobuilder gives me the green light)

Thanks,
Ard.
