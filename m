From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT PULL 0/1] EFI mixed mode fix for v4.18
Date: Wed, 11 Jul 2018 12:13:03 +0200
Message-ID: <20180711101303.GA8574@gmail.com>
References: <20180711090235.9327-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180711090235.9327-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, Wilfried Klaebe <linux-kernel@lebenslange-mailadresse.de>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> The following changes since commit 1e4b044d22517cae7047c99038abb444423243ca:
> 
>   Linux 4.18-rc4 (2018-07-08 16:34:02 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent
> 
> for you to fetch changes up to d7f2e972e702d329fe11d6956df99dfc31211c25:
> 
>   efi/x86: remove pointless call to PciIo->Attributes() (2018-07-11 10:52:46 +0200)
> 
> ----------------------------------------------------------------
> A single fix for the x86 PCI I/O protocol handling code that got
> broken for mixed mode (64-bit Linux/x86 on 32-bit UEFI) after a
> fix was applied in -rc2 to fix it for ordinary 64-bit Linux/x86.

Just curious, because it's unclear from the changelog, what was the symptom, a 
boot hang, instant reboot, or some other misbehavior? Also, what's the scope of 
the fix: were all 64-bit on 32-bit UEFI mixed-mode bootups affected, or only a 
certain subset?

Thanks,

	Ingo
