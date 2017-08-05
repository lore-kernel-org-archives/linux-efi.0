From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH] Enable reset attack mitigation
Date: Sat, 5 Aug 2017 19:34:10 +0200
Message-ID: <20170805173410.GB8872@wunner.de>
References: <20170804212010.15064-1-mjg59@google.com>
 <CAKv+Gu-fe-dw-UXZxen4909b=QOF=_RP-V6GHZ8A4u=iVaaqpw@mail.gmail.com>
 <CACdnJuvCjWLxGfXY-6tytyTr-v8s0TZb_48J5Pju9p5OUuREuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACdnJuvCjWLxGfXY-6tytyTr-v8s0TZb_48J5Pju9p5OUuREuQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

On Sat, Aug 05, 2017 at 09:35:22AM -0700, Matthew Garrett wrote:
> On Sat, Aug 5, 2017 at 2:50 AM, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > On 4 August 2017 at 22:20, Matthew Garrett <mjg59@google.com> wrote:
> > > If a machine is reset while secrets are present in RAM, it may be
> > > possible for code executed after the reboot to extract those secrets
> > > from untouched memory. The Trusted Computing Group specified a mechanism
> > > for requesting that the firmware clear all RAM on reset before booting
> > > another OS. This is done by setting the MemoryOverwriteRequestControl
> > > variable at startup. If userspace can ensure that all secrets are
> > > removed as part of a controlled shutdown, it can reset this variable to
> > > 0 before triggering a hardware reboot.
> >
> > Shouldn't it be up to the kernel to decide whether this flag should be
> > cleared after userspace has indicated to it that it thinks it has
> > wiped all secrets from memory? The kernel itself may keep secrets as
> > well, and we may still crash in the time window between userspace
> > invoking shutdown and the kernel actually calling ResetSystem() in the
> > firmware.
> 
> What's the threat model? If there's no way for userland to ask the
> kernel to drop any secrets it still holds, that seems like a problem
> in any case. If the concern is that someone may be able to clear the
> flag and then reboot in order to deliberately attempt to obtain kernel
> secrets then there's no hugely easy way around this without special
> casing the variable and preventing userland from being able to modify
> it. There's a MemoryOverwriteRequestLock spec from Microsoft that
> provides a mechanism for this (the firmware and the OS configure a
> shared secret that controls access to MemoryOverwriteRequestControl,
> so we'd keep that in the kernel and clear it on reboot), but that's
> not implemented everywhere and we'd still want to base on top of this.

Just an innocent question from a bystander, what's the downside of
unconditionally requesting that memory be overwritten?  Does it
prolong reboot noticeably?

I've also wondered why you've chosen to put this in a separate file
rather than the existing secureboot.c, my naive understanding is that
TPM and SecureBoot is related but I'm not an expert on this.  It would
allow you to reuse the existing get_efi_var() macro.

Thanks,

Lukas (aka the "abusive community" (?)
https://mobile.twitter.com/mjg59/status/893543164371283969 )
