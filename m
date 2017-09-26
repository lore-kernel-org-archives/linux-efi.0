From: Florent Revest <revestflo@gmail.com>
Subject: Re: [RFC 00/11] KVM, EFI, arm64: EFI Runtime Services Sandboxing
Date: Tue, 26 Sep 2017 23:14:58 +0200
Message-ID: <1506460498.5507.59.camel@gmail.com>
References: <1503649901-5834-1-git-send-email-florent.revest@arm.com>
         <CAKv+Gu-d89kPavCNJmHe3q0t-WUzyZpUn=B30b=Z5a=mqzSGkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-d89kPavCNJmHe3q0t-WUzyZpUn=B30b=Z5a=mqzSGkQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Matt Fleming <matt@codeblueprint.co.uk>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, KVM devel mailing list <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Leif Lindholm <leif.lindholm@arm.com>
List-Id: linux-efi@vger.kernel.org

On Fri, 2017-09-22 at 14:44 -0700, Ard Biesheuvel wrote:
> From the EFI side, there are some minor concerns on my part regarding
> the calling convention, and the fact that we can no longer invoke
> runtime services from a kernel running at EL1, but those all seem
> fixable. I will respond to the patches in question in greater detail
> at a later time.

Indeed, this RFC currently breaks EFI Runtime Services at EL1. This
would need to be fixed in a new patchset.

The patch 10/11 also underlines that the current argument passing
method does not respect alignment. The way arguments are currently
pushed and pulled makes it quite hard to fix the issue. Any suggestion
would be welcome.

> In the mean time, Christoffer has raised a number for valid concerns,
> and those need to be addressed first before it makes sense to talk
> about EFI specifics. I hope you will find more time to invest in
> this: I would really love to have this feature upstream.

Unfortunately, I'm no longer working at ARM and my other projects keep
me very busy. I would also love to invest more time in this patchset to
have it upstream but I'm really unsure when I will be able to find the
time for this.

Best,
    Florent
