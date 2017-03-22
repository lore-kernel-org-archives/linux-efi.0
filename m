From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH v3] efifb: avoid reconfiguration of BAR that covers the
 framebuffer
Date: Wed, 22 Mar 2017 15:49:21 -0400
Message-ID: <704b8b8c-e607-29b3-e101-bbecd90073bb@codeaurora.org>
References: <1490196629-28088-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170322193111.GA8190@wunner.de>
 <31da6db5-be22-9e84-5e76-67c519bc0b34@codeaurora.org>
 <CAKv+Gu8Uw-X3AR6aQYevPdRfcgPNnqL4O3sRoKxsZAiW29sbqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAKv+Gu8Uw-X3AR6aQYevPdRfcgPNnqL4O3sRoKxsZAiW29sbqg@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, linux-pci <linux-pci@vger.kernel.org>, Peter Jones <pjones@redhat.com>, Heyi Guo <heyi.guo@linaro.org>, Lukas Wunner <lukas@wunner.de>, Hanjun Guo <hanjun.guo@linaro.org>, Bjorn Helgaas <bhelgaas@google.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Yinghai Lu <yinghai@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 3/22/2017 3:41 PM, Ard Biesheuvel wrote:
>> As far as I know, kernel honors resource assignments done by the UEFI BIOS if
>> they are correct. Kernel will reassign the resources only if something is wrong.
>>
> No, the kernel always reassigns all BARs on arm64.

I think this is where the problem is.

I'm not seeing this happen on QDF2400 which supports ACPI + UEFI BIOS
combination only. 

I see that kernel honored the resources assigned by UEFI BIOS if I compare
the BAR addresses.

I see reassignment only when something is horribly broken. Then, there would
be a bridge configuration invalid message in the boot log to confirm this.

> 
>> Will this code break other platforms/architectures?
>>
> Which platforms/architectures are you referring to? EFIFB on a PCI
> device is currently broken on arm64. 

In general or on your particular platform?

> On x86, it works, given that BARs
> are usually not reassigned, and so the patch should be a no-op in that
> case (although I'd argue it is still an improvement to check whether
> the device that owns the BAR actually has memory decoding enabled
> before we attach the framebuffer driver to it)
> 

I'm fine as long as it doesn't break anything. That's why, I'm asking.

-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
