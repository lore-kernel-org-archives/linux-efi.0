From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC 00/11] KVM, EFI, arm64: EFI Runtime Services Sandboxing
Date: Fri, 22 Sep 2017 14:44:51 -0700
Message-ID: <CAKv+Gu-d89kPavCNJmHe3q0t-WUzyZpUn=B30b=Z5a=mqzSGkQ@mail.gmail.com>
References: <1503649901-5834-1-git-send-email-florent.revest@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503649901-5834-1-git-send-email-florent.revest@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florent Revest <florent.revest@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Matt Fleming <matt@codeblueprint.co.uk>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, KVM devel mailing list <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Leif Lindholm <leif.lindholm@arm.com>, revestflo@gmail.com
List-Id: linux-efi@vger.kernel.org

On 25 August 2017 at 01:31, Florent Revest <florent.revest@arm.com> wrote:
> Hi,
>
> This series implements a mechanism to sandbox EFI Runtime Services on arm64.
> It can be enabled with CONFIG_EFI_SANDBOX. At boot it spawns an internal KVM
> virtual machine that is ran everytime an EFI Runtime Service is called. This
> limits the possible security and stability impact of EFI runtime on the kernel.
>
> The patch set is split as follow:
>  - Patches 1 and 2: Give more control over HVC handling to KVM
>  - Patches 3 to 6: Introduce the concept of KVM "internal VMs"
>  - Patches 7 to 9: Reorder KVM and EFI initialization on ARM
>  - Patch 10: Introduces the EFI sandboxing VM and wrappers
>  - Patch 11: Workarounds some EFI Runtime Services relying on EL3
>
> The sandboxing has been tested to work reliably (rtc and efivars) on a
> SoftIron OverDrive 1000 box and on a ARMv8.3 model with VHE enabled. Normal
> userspace KVM instance have also been tested to still work correctly.
>
> Those patches apply cleanly on the Linus' v4.13-rc6 tag and have no other
> dependencies.
>
> Florent Revest (11):
>   arm64: Add an SMCCC function IDs header
>   KVM: arm64: Return an Unknown ID on unhandled HVC
>   KVM: Allow VM lifecycle management without userspace
>   KVM, arm, arm64: Offer PAs to IPAs idmapping to internal VMs
>   KVM: Expose VM/VCPU creation functions
>   KVM, arm64: Expose a VCPU initialization function
>   KVM: Allow initialization before the module target
>   KVM, arm, arm64: Initialize KVM's core earlier
>   EFI, arm, arm64: Enable EFI Runtime Services later
>   efi, arm64: Sandbox Runtime Services in a VM
>   KVM, arm64: Don't trap internal VMs SMC calls
>

Hello Florent,

This is really nice work. Thanks for contributing it.

>From the EFI side, there are some minor concerns on my part regarding
the calling convention, and the fact that we can no longer invoke
runtime services from a kernel running at EL1, but those all seem
fixable. I will respond to the patches in question in greater detail
at a later time.

In the mean time, Christoffer has raised a number for valid concerns,
and those need to be addressed first before it makes sense to talk
about EFI specifics. I hope you will find more time to invest in this:
I would really love to have this feature upstream.

Regards,
Ard.
