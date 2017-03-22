From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH v3] efifb: avoid reconfiguration of BAR that covers the
 framebuffer
Date: Wed, 22 Mar 2017 15:57:56 -0400
Message-ID: <4ccb4d92-3830-3980-38c3-7085a3d97734@codeaurora.org>
References: <1490196629-28088-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170322193111.GA8190@wunner.de>
 <31da6db5-be22-9e84-5e76-67c519bc0b34@codeaurora.org>
 <CAKv+Gu8Uw-X3AR6aQYevPdRfcgPNnqL4O3sRoKxsZAiW29sbqg@mail.gmail.com>
 <704b8b8c-e607-29b3-e101-bbecd90073bb@codeaurora.org>
 <CAKv+Gu-3wAXLyogLxg3N=6vf6Ryz2cLXw01tZUR_E48ddVU22A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-3wAXLyogLxg3N=6vf6Ryz2cLXw01tZUR_E48ddVU22A@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Lukas Wunner <lukas@wunner.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Jones <pjones@redhat.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Bjorn Helgaas <bhelgaas@google.com>, Hanjun Guo <hanjun.guo@linaro.org>, Heyi Guo <heyi.guo@linaro.org>, linux-pci <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

On 3/22/2017 3:52 PM, Ard Biesheuvel wrote:
> On 22 March 2017 at 19:49, Sinan Kaya <okaya@codeaurora.org> wrote:
>> On 3/22/2017 3:41 PM, Ard Biesheuvel wrote:
>>>> As far as I know, kernel honors resource assignments done by the UEFI BIOS if
>>>> they are correct. Kernel will reassign the resources only if something is wrong.
>>>>
>>> No, the kernel always reassigns all BARs on arm64.
>>
>> I think this is where the problem is.
>>
>> I'm not seeing this happen on QDF2400 which supports ACPI + UEFI BIOS
>> combination only.
>>
>> I see that kernel honored the resources assigned by UEFI BIOS if I compare
>> the BAR addresses.
>>
> 
> Well, if you are using the standard MdeModulePkg PciHostBridgeDxe
> driver in UEFI, the logic is quite similar, and so you usually end up
> with the same resource assignments. But the kernel does recompute them
> from scratch, and ignores the existing configuration that is present
> in the BARs

Yes, standard stuff in UEFI. OK. That may explain what I'm seeing.

> 
>> I see reassignment only when something is horribly broken. Then, there would
>> be a bridge configuration invalid message in the boot log to confirm this.
>>
>>>
>>>> Will this code break other platforms/architectures?
>>>>
>>> Which platforms/architectures are you referring to? EFIFB on a PCI
>>> device is currently broken on arm64.
>>
>> In general or on your particular platform?
>>
>>> On x86, it works, given that BARs
>>> are usually not reassigned, and so the patch should be a no-op in that
>>> case (although I'd argue it is still an improvement to check whether
>>> the device that owns the BAR actually has memory decoding enabled
>>> before we attach the framebuffer driver to it)
>>>
>>
>> I'm fine as long as it doesn't break anything. That's why, I'm asking.
>>
> 
> If you have working EFIFB on your platform, it works by accident. This
> patch is needed to ensure that the BAR associated with the EFI
> framebuffer is left untouched.
> 

I never claimed that. I was just double checking your assumptions.
I really don't like ARM64 specific PCI code in general. PCI doesn't care
about CPU type. I hope to see this patch become part of common code.

-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
