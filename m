From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3] efifb: avoid reconfiguration of BAR that covers the framebuffer
Date: Tue, 28 Mar 2017 22:39:48 +0100
Message-ID: <CAKv+Gu9LbwpnJNi1OL25MWvYPxEOfKRHcs2jA2121BPaQWPzow@mail.gmail.com>
References: <1490196629-28088-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170322193111.GA8190@wunner.de> <CAKv+Gu_X-SEnz7h9J8boqqjOQGHQawwdSAq4haH-OGu8zdfNfA@mail.gmail.com>
 <20170323084819.GA23281@h08.hostsharing.net> <CAKv+Gu93eJ-js3g7M6Jdm6XGMaWMswFmzBG2qNT4rn+3=1+EyA@mail.gmail.com>
 <20170323105727.GA2441@red-moon> <466dcd2b-a781-2fe7-6ef0-5a3767c793e0@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <466dcd2b-a781-2fe7-6ef0-5a3767c793e0@codeaurora.org>
Sender: linux-pci-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Lukas Wunner <lukas@wunner.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Jones <pjones@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Hanjun Guo <hanjun.guo@linaro.org>, Heyi Guo <heyi.guo@linaro.org>, linux-pci <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

On 28 March 2017 at 22:27, Sinan Kaya <okaya@codeaurora.org> wrote:
> Hi Lorenzo,
>
> On 3/23/2017 6:57 AM, Lorenzo Pieralisi wrote:
>>> Correct. But on x86 (or rather, on a PC), you can be sure that UEFI
>>> (or the legacy PCI bios) performed the resource assignment already.
>>> One could argue that this is equally the case when running arm64 in
>>> ACPI mode, but in general, you cannot assume the presence of firmware
>>> on ARM/arm64 that has already taken care of this, and so the state of
>>> the BARs has to be presumed invalid.
>> The story is a bit more convoluted than that owing to x86 (and other
>> arches) legacy.
>>
>> x86 tries to claim all PCI resources (in two passes - first enabled
>> devices, second disabled devices) and that predates ACPI/UEFI.
>>
>> Mind, x86 reassign resources that can't be claimed too, the only
>> difference with ARM64 is that, for the better or the worse, we
>> have decided not to claim the FW PCI set-up on ARM64 even if it
>> is sane, we do not even try, it was a deliberate choice.
>>
>> This patch should be harmless on x86 since if the FB PCI BAR is set
>> up sanely, claiming it again should be a nop (to be checked).
>>
>> For all the talk about PCI being arch agnostic as I said manifold
>> times before, that's just theory. In practice different arches
>> treat PCI FW set-up differently, it would be ideal to make them
>> uniform but legacy is huge and there is a massive risk of triggering
>> regressions, it is no mean feat (if achievable at all).
>
> Can we explore having a uniform behavior across ALL ACPI bases systems
> by trying to reuse the resources assigned by firmware first and reassign
> them only if something is wrong?
>
> There are protocols like hotplug reservation in UEFI. It looks like Linux
> is not honoring any of these protocols by being too smart.
>

Could you be more specific? Which protocol do you mean exactly, and
how does not reusing resources interfere with it?
