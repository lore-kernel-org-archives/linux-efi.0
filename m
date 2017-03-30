From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] efifb: avoid reconfiguration of BAR that covers the framebuffer
Date: Thu, 30 Mar 2017 09:46:39 +0100
Message-ID: <CAKv+Gu-qRg8-YRCairppKrEfeLcW+OwVF8qZHp7vxXJA_AwPOw@mail.gmail.com>
References: <1490196629-28088-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170322193111.GA8190@wunner.de> <CAKv+Gu_X-SEnz7h9J8boqqjOQGHQawwdSAq4haH-OGu8zdfNfA@mail.gmail.com>
 <20170323084819.GA23281@h08.hostsharing.net> <CAKv+Gu93eJ-js3g7M6Jdm6XGMaWMswFmzBG2qNT4rn+3=1+EyA@mail.gmail.com>
 <20170323105727.GA2441@red-moon> <466dcd2b-a781-2fe7-6ef0-5a3767c793e0@codeaurora.org>
 <CAKv+Gu9LbwpnJNi1OL25MWvYPxEOfKRHcs2jA2121BPaQWPzow@mail.gmail.com> <27f50de3-721e-e8ec-00c8-b7a9d3cff0d6@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <27f50de3-721e-e8ec-00c8-b7a9d3cff0d6-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sinan Kaya <okaya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Heyi Guo <heyi.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-pci <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 28 March 2017 at 22:49, Sinan Kaya <okaya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
> On 3/28/2017 5:39 PM, Ard Biesheuvel wrote:
>> On 28 March 2017 at 22:27, Sinan Kaya <okaya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
>>> Hi Lorenzo,
>>>
>>> On 3/23/2017 6:57 AM, Lorenzo Pieralisi wrote:
>>>>> Correct. But on x86 (or rather, on a PC), you can be sure that UEFI
>>>>> (or the legacy PCI bios) performed the resource assignment already.
>>>>> One could argue that this is equally the case when running arm64 in
>>>>> ACPI mode, but in general, you cannot assume the presence of firmware
>>>>> on ARM/arm64 that has already taken care of this, and so the state of
>>>>> the BARs has to be presumed invalid.
>>>> The story is a bit more convoluted than that owing to x86 (and other
>>>> arches) legacy.
>>>>
>>>> x86 tries to claim all PCI resources (in two passes - first enabled
>>>> devices, second disabled devices) and that predates ACPI/UEFI.
>>>>
>>>> Mind, x86 reassign resources that can't be claimed too, the only
>>>> difference with ARM64 is that, for the better or the worse, we
>>>> have decided not to claim the FW PCI set-up on ARM64 even if it
>>>> is sane, we do not even try, it was a deliberate choice.
>>>>
>>>> This patch should be harmless on x86 since if the FB PCI BAR is set
>>>> up sanely, claiming it again should be a nop (to be checked).
>>>>
>>>> For all the talk about PCI being arch agnostic as I said manifold
>>>> times before, that's just theory. In practice different arches
>>>> treat PCI FW set-up differently, it would be ideal to make them
>>>> uniform but legacy is huge and there is a massive risk of triggering
>>>> regressions, it is no mean feat (if achievable at all).
>>>
>>> Can we explore having a uniform behavior across ALL ACPI bases systems
>>> by trying to reuse the resources assigned by firmware first and reassign
>>> them only if something is wrong?
>>>
>>> There are protocols like hotplug reservation in UEFI. It looks like Linux
>>> is not honoring any of these protocols by being too smart.
>>>
>>
>> Could you be more specific? Which protocol do you mean exactly, and
>> how does not reusing resources interfere with it?
>>
>
> Let's assume for the moment that if ARM64 adaptation of PCIE reused the firmware
> assigned BAR addresses, would you still have this problem that you are trying to
> fix by a quirk?
>

Probably not. Although I should point out that the same issue exists
on DT systems, and so we will need this patch regardless.

> The protocol that I was looking at specifically is called hotplug reservation
> protocol.
>
> http://www.intel.com/content/www/us/en/architecture-and-technology/unified-extensible-firmware-interface/efi-hot-plug-pci-initialization-protocol-specification.html
>
> The idea is to pad the PCIe bridge window by some amount in UEFI. You boot the
> system without any cards present. when you do to hotplug, OS uses the range
> reserved by the BIOS for inserting the new card.
>
> what I see is that the bridge windows get overridden by the OS.
>
> I'm asking why we don't fix the actual problem in PCIe ARM64 adaptation instead
> of working around it by quirks.
>
> I don't see any reason why ACPI ARM64 should carry the burden of legacy systems.
>
> Legacy only applies to DT based systems.
>

I fully agree with this point: ACPI implies firmware, and so we should
be able to rely on firmware to have initialized the PCIe subsystem by
the time the kernel gets to access it.

> If there is still a legacy problem in ACPI ARM64, generic Linux code deals with
> this using some DMI/SMBIOS and setting a time bomb like products after this date
> shall follow the new behavior.
>
> We are not in a very hardened position when it comes to changes for ACPI based
> systems.
>
> Sinan
>
> --
> Sinan Kaya
> Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
> Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
