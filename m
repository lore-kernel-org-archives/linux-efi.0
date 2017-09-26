From: Florent Revest <revestflo@gmail.com>
Subject: Re: [RFC 00/11] KVM, EFI, arm64: EFI Runtime Services Sandboxing
Date: Tue, 26 Sep 2017 23:14:52 +0200
Message-ID: <1506460492.5507.58.camel@gmail.com>
References: <1503649901-5834-1-git-send-email-florent.revest@arm.com>
         <20170831092615.GB13572@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170831092615.GB13572@cbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, Florent Revest <florent.revest@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, christoffer.dall@linaro.org, catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, marc.zyngier@arm.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, leif.lindholm@arm.com
List-Id: linux-efi@vger.kernel.org

On Thu, 2017-08-31 at 11:26 +0200, Christoffer Dall wrote:
> I wonder if this should be split into two series; one that sets up
> anything you may need from KVM, and another one that uses that for
> UEFI.
> 
> There's a lot KVM and UEFI intertwined logic and assumptions in patch
> 10, which makes this series a bit hard to read.

The way hypercalls are currently handled in handle_hvc required this
mixed patch. Would some kind of HVC subscription mechanism be suitable
to have in KVM? (e.g: a function allowing to register a callback on a
certain HVC function ID) This would allow the 10/11 patch to keep the
kvm code intact.

> I'd like some documentation (in the series and in
> Documentation/virtual/kvm) of how this works, and which hidden
> assumptions there are. For example, how do you ensure you never
> attempt to return to userspace?

I don't think my code ensured this. I'd need to give it a second look.

>  How many VCPUs do you support?

You can create as many VCPUs as you would in a "normal VM". Also, each
VCPU can be ran in a kthread.

>  Do you support any form of virtual interrupts? How about timers?

No support for virtual interrupts or timers indeed. The EFI Runtime
Services sandboxing wouldn't require that.

> Can a VM access physical devices?

The very idea of Runtime Services sandboxing requires Internal VMs to
have access to some of the physical devices.

>  How do you debug and trace something like this? Can the VM be
> monitored from userspace?

There is nothing ready for that.

> These feel like fundamental questions to me that needs addressing
> before I can competently review the code.
> 
> I think a slightly more concrete motivation and outlining the example
> of the broken UEFI on Seattle would help paving the way for these
> patches.

As far as I can remember, EFI Runtime Services on this platform have
already been reported to sometimes disable or enable interrupts. Maybe
someone at ARM has more details about the problem ?

Thanks a lot for your review,
    Florent
