From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT PULL 0/1] EFI mixed mode fix for v4.18
Date: Wed, 11 Jul 2018 17:37:37 +0200
Message-ID: <20180711153736.GA4500@gmail.com>
References: <20180711090235.9327-1-ard.biesheuvel@linaro.org>
 <20180711101303.GA8574@gmail.com>
 <CAKv+Gu8m4UgL0GyYDuu5z+dzEF=N--H4PkqoO_xqwyW2_A+RMA@mail.gmail.com>
 <20180711111427.GA27216@gmail.com>
 <CAKv+Gu_LJEu11NV5CVTPV9ieZ=XKkgW2qdkFJ+1iWk+F2jNPww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_LJEu11NV5CVTPV9ieZ=XKkgW2qdkFJ+1iWk+F2jNPww@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi <linux-efi@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Hans de Goede <hdegoede@redhat.com>, Wilfried Klaebe <linux-kernel@lebenslange-mailadresse.de>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> On 11 July 2018 at 13:14, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >
> >> On 11 July 2018 at 12:13, Ingo Molnar <mingo@kernel.org> wrote:
> >> >
> >> > * Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >> >
> >> >> The following changes since commit 1e4b044d22517cae7047c99038abb444423243ca:
> >> >>
> >> >>   Linux 4.18-rc4 (2018-07-08 16:34:02 -0700)
> >> >>
> >> >> are available in the Git repository at:
> >> >>
> >> >>   git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent
> >> >>
> >> >> for you to fetch changes up to d7f2e972e702d329fe11d6956df99dfc31211c25:
> >> >>
> >> >>   efi/x86: remove pointless call to PciIo->Attributes() (2018-07-11 10:52:46 +0200)
> >> >>
> >> >> ----------------------------------------------------------------
> >> >> A single fix for the x86 PCI I/O protocol handling code that got
> >> >> broken for mixed mode (64-bit Linux/x86 on 32-bit UEFI) after a
> >> >> fix was applied in -rc2 to fix it for ordinary 64-bit Linux/x86.
> >> >
> >> > Just curious, because it's unclear from the changelog, what was the symptom, a
> >> > boot hang, instant reboot, or some other misbehavior?
> >>
> >> Hans reported that his mixed mode tablet would not boot at all any
> >> more, but enter a reboot loop without any logs printed by the kernel.
> >>
> >> > Also, what's the scope of
> >> > the fix: were all 64-bit on 32-bit UEFI mixed-mode bootups affected, or only a
> >> > certain subset?
> >> >
> >>
> >> Any mixed mode system with PCI is likely to be affected. I have added
> >> a QEMU mixed mode config to my boot test environment to catch errors
> >> like this one.
> >
> > Ok, I've added this information to the commit - will be useful to backporters,
> > to judge the severity of the bug fixed.
> >
> 
> Perhaps it wasn't clear from the commit log that only v4.18-rc2 and
> later is affected by the mixed mode issue, since that is when a fix
> for ordinary 64-bit x86 was applied that affected v4.18-rc1.

Ah, ok. Still, if for whatever reason the commit that introduced the problem is 
backported, this one will be too. The chain of sha1's seemed rather long, so 
there's a chance for that.

> However, the EFI stub code is not expected to expand that much, and so for the 
> time being, I'm fine with a combination of review and rigorous testing

Fair enough!

Thanks,

	Ingo
