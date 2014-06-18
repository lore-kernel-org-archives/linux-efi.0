From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi/arm64: efistub: remove local copy of linux_banner
Date: Wed, 18 Jun 2014 11:12:28 +0200
Message-ID: <CAKv+Gu8auFu=rxtDpZy4tkfPiZK7ERUeRDvymzQYi9AhVUxW+Q@mail.gmail.com>
References: <1402657911-7779-1-git-send-email-ard.biesheuvel@linaro.org>
	<20140618085059.GB24049@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140618085059.GB24049-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 18 June 2014 10:50, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Fri, 13 Jun, at 01:11:51PM, Ard Biesheuvel wrote:
>> The shared efistub code for ARM and arm64 contains a local copy of linux_banner,
>> allowing it to be referenced from separate executables such as the ARM
>> decompressor. However, this introduces a dependency on generated header files,
>> causing unnecessary rebuilds of the stub itself and, in case of arm64, vmlinux
>> which contains it.
>>
>> On arm64, the copy is not actually needed since we can reference the original
>> symbol directly, and as it turns out, there may be better ways to deal with this
>> for ARM as well, so let's remove it from the shared code. If it still needs to
>> be reintroduced for ARM later, it should live under arch/arm anyway and not in
>> shared code.
>
> I remember making some similar arguments when this patch was first
> introduced. From looking at my notes, the patch rationale was based on
> some DT binding discussion where people wanted an explicit way to
> identify the kernel they were booting and everyone agreed upon this
> string - I don't know which discussion, I don't have that data.
>
> I'm more than happy to delete this from the shared code, I never wanted
> it to go in in the first place. But could someone please give me some
> details as to why this change is safe and isn't going to break
> ARM/ARM64? How does this affect DT bindings?
>

This just removes the duplicate definition of linux_banner, *not* the
reference to it a couple of lines down. IOW, the DT bindings and
everything behind it are not affected at all by this patch.
The reason it works fine for arm64 is that its stub is part of the
kernel proper, so the reference will bind to the global definition
instead.

What will be affected is 32-bit ARM, as its stub is not part of the
kernel proper. In this case, we will propose an alternative [and
better] way of allowing the stub to reference linux_banner, i.e.,
without having to redefine it at the C level. We will take this into
account when we propose the next round of efistub patches for ARM.

Regards,
Ard.
