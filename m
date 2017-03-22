From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3] efifb: avoid reconfiguration of BAR that covers the
 framebuffer
Date: Wed, 22 Mar 2017 19:52:24 +0000
Message-ID: <CAKv+Gu-3wAXLyogLxg3N=6vf6Ryz2cLXw01tZUR_E48ddVU22A@mail.gmail.com>
References: <1490196629-28088-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170322193111.GA8190@wunner.de>
 <31da6db5-be22-9e84-5e76-67c519bc0b34@codeaurora.org>
 <CAKv+Gu8Uw-X3AR6aQYevPdRfcgPNnqL4O3sRoKxsZAiW29sbqg@mail.gmail.com>
 <704b8b8c-e607-29b3-e101-bbecd90073bb@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <704b8b8c-e607-29b3-e101-bbecd90073bb@codeaurora.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Sinan Kaya <okaya@codeaurora.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, linux-pci <linux-pci@vger.kernel.org>, Peter Jones <pjones@redhat.com>, Heyi Guo <heyi.guo@linaro.org>, Lukas Wunner <lukas@wunner.de>, Hanjun Guo <hanjun.guo@linaro.org>, Bjorn Helgaas <bhelgaas@google.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Yinghai Lu <yinghai@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 22 March 2017 at 19:49, Sinan Kaya <okaya@codeaurora.org> wrote:
> On 3/22/2017 3:41 PM, Ard Biesheuvel wrote:
>>> As far as I know, kernel honors resource assignments done by the UEFI BIOS if
>>> they are correct. Kernel will reassign the resources only if something is wrong.
>>>
>> No, the kernel always reassigns all BARs on arm64.
>
> I think this is where the problem is.
>
> I'm not seeing this happen on QDF2400 which supports ACPI + UEFI BIOS
> combination only.
>
> I see that kernel honored the resources assigned by UEFI BIOS if I compare
> the BAR addresses.
>

Well, if you are using the standard MdeModulePkg PciHostBridgeDxe
driver in UEFI, the logic is quite similar, and so you usually end up
with the same resource assignments. But the kernel does recompute them
from scratch, and ignores the existing configuration that is present
in the BARs

> I see reassignment only when something is horribly broken. Then, there would
> be a bridge configuration invalid message in the boot log to confirm this.
>
>>
>>> Will this code break other platforms/architectures?
>>>
>> Which platforms/architectures are you referring to? EFIFB on a PCI
>> device is currently broken on arm64.
>
> In general or on your particular platform?
>
>> On x86, it works, given that BARs
>> are usually not reassigned, and so the patch should be a no-op in that
>> case (although I'd argue it is still an improvement to check whether
>> the device that owns the BAR actually has memory decoding enabled
>> before we attach the framebuffer driver to it)
>>
>
> I'm fine as long as it doesn't break anything. That's why, I'm asking.
>

If you have working EFIFB on your platform, it works by accident. This
patch is needed to ensure that the BAR associated with the EFI
framebuffer is left untouched.
