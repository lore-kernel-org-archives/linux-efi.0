From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3] efifb: avoid reconfiguration of BAR that covers the framebuffer
Date: Wed, 22 Mar 2017 19:32:43 +0000
Message-ID: <CAKv+Gu_X-SEnz7h9J8boqqjOQGHQawwdSAq4haH-OGu8zdfNfA@mail.gmail.com>
References: <1490196629-28088-1-git-send-email-ard.biesheuvel@linaro.org> <20170322193111.GA8190@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20170322193111.GA8190@wunner.de>
Sender: linux-pci-owner@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Jones <pjones@redhat.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Bjorn Helgaas <bhelgaas@google.com>, Hanjun Guo <hanjun.guo@linaro.org>, Heyi Guo <heyi.guo@linaro.org>, linux-pci <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

On 22 March 2017 at 19:31, Lukas Wunner <lukas@wunner.de> wrote:
> On Wed, Mar 22, 2017 at 03:30:29PM +0000, Ard Biesheuvel wrote:
>> On UEFI systems, the PCI subsystem is enumerated by the firmware,
>> and if a graphical framebuffer is exposed by a PCI device, its base
>> address and size are exposed to the OS via the Graphics Output
>> Protocol (GOP).
>>
>> On arm64 PCI systems, the entire PCI hierarchy is reconfigured from
>> scratch at boot. This may result in the GOP framebuffer address to
>> become stale, if the BAR covering the framebuffer is modified. This
>> will cause the framebuffer to become unresponsive, and may in some
>> cases result in unpredictable behavior if the range is reassigned to
>> another device.
>
> Hm, commit message seems to indicate the issue is restricted to arm64,
> yet there's no IS_ENABLED(ARM64) to constrain the added code to that arch?
>

True. I am eager to get some x86 coverage for this, since I would
expect this not to do any harm. But I'm fine with making it ARM/arm64
specific in the final version.

>
>> +DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, efifb_fixup_resources);
>
> Maybe this can be constrained to PCI_BASE_CLASS_DISPLAY?
>

How does one do that with DECLARE_PCI_FIXUP_HEADER?
