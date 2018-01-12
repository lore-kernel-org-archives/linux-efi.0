From: Daniel Kiper <daniel.kiper@oracle.com>
Subject: Re: [PATCH 0/4] x86/xen/efi: Initialize UEFI secure boot state
 during dom0 boot
Date: Fri, 12 Jan 2018 12:24:50 +0100
Message-ID: <20180112112450.GD21705@olila.local.net-space.pl>
References: <1515507745-17391-1-git-send-email-daniel.kiper@oracle.com>
 <CAKv+Gu-_SHXCkfX5d3R08nW6rc4giR1d4VhDjF8J5miaTfSDow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-_SHXCkfX5d3R08nW6rc4giR1d4VhDjF8J5miaTfSDow@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, xen-devel <xen-devel@lists.xenproject.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>, Juergen Gross <jgross@suse.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-efi@vger.kernel.org

Hi Ard,

On Thu, Jan 11, 2018 at 12:51:07PM +0000, Ard Biesheuvel wrote:
> On 9 January 2018 at 14:22, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> > Hi,
> >
> > Initialize UEFI secure boot state during dom0 boot. Otherwise the kernel
> > may not even know that it runs on secure boot enabled platform.
>
> Hi Daniel,
>
> I must say, I am not too thrilled with the approach you have chosen
> here. #including .c files in other .c files, and using #defines to
> override C functions or other stub functionality is rather fragile. In

TBH I do not like it too. Sadly I have not find a better solution for
that. I wish to avoid code duplication as much as possible because
otherwise it will fall out of sync sooner or later (usually sooner).
Similar thing happened in different part of Xen EFI code a few months ago.

> particular, it means we have to start caring about not breaking
> Xen/x86 code when making modifications to the EFI stub, and that code
> is already difficult enough to maintain, given that it is shared
> between ARM, arm64 and x86, and runs either from the decompressor or
> the kernel proper (arm64) but in the context of the UEFI firmware.

I understand that.

> None of the stub code currently runs in ordinary kernel context.

Yep.

> So please, could you try to find another way to do this?

I am happy to improve the situation, however, I am afraid that it is
difficult here. Stub and kernel proper are separate entities and simple
linking does not work. So, It seems to me that only play with includes
will allow us to not duplicate the code. However, if you have a better
idea I am happy to implement it.

Daniel
