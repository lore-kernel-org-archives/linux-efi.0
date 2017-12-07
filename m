From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC v3 PATCH 0/2] Introduce Security Version to EFI Stub
Date: Thu, 7 Dec 2017 07:09:27 +0100
Message-ID: <20171207060927.i4b4h6ahas3iiyrc@gmail.com>
References: <20171205100148.5757-1-glin@suse.com>
 <CA+5PVA4k9RN22i2d=4GCPnm9bwi5KUgp8PiV=9X1pBZxN1xPmg@mail.gmail.com>
 <20171206032437.pifxxcewgozlghfs@GaryWorkstation>
 <20171206183734.xmgecyrd5suiurm6@gmail.com>
 <20171207015903.jaos5siysggzz4nc@GaryWorkstation>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171207015903.jaos5siysggzz4nc@GaryWorkstation>
Sender: linux-kernel-owner@vger.kernel.org
To: Gary Lin <glin@suse.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, x86 <x86@kernel.org>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ingo Molnar <mingo@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Joey Lee <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org


* Gary Lin <glin@suse.com> wrote:

> On Wed, Dec 06, 2017 at 07:37:34PM +0100, Ingo Molnar wrote:
> > 
> > * Gary Lin <glin@suse.com> wrote:
> > 
> > > On Tue, Dec 05, 2017 at 04:14:26PM -0500, Josh Boyer wrote:
> > > > On Tue, Dec 5, 2017 at 5:01 AM, Gary Lin <glin@suse.com> wrote:
> > > > > The series of patches introduce Security Version to EFI stub.
> > > > >
> > > > > Security Version is a monotonically increasing number and designed to
> > > > > prevent the user from loading an insecure kernel accidentally. The
> > > > > bootloader maintains a list of security versions corresponding to
> > > > > different distributions. After fixing a critical vulnerability, the
> > > > > distribution kernel maintainer bumps the "version", and the bootloader
> > > > > updates the list automatically. When the user tries to load a kernel
> > > > > with a lower security version, the bootloader shows a warning prompt
> > > > > to notify the user the potential risk.
> > > > 
> > > > If a distribution releases a kernel with a higher security version and
> > > > that it automatically updated on boot, what happens if that kernel
> > > > contains a different bug that causes it to fail to boot or break
> > > > critical functionality?  At that point, the user's machine would be in
> > > > a state where the higher security version is enforced but the only
> > > > kernel that provides that is broken.  Wouldn't that make a bad
> > > > situation even worse by now requiring manual acceptance of the older
> > > > SV kernel boot physically at the machine?
> > > > 
> > > > I feel like I'm missing a detail here or something.
> > > > 
> > > If the new kernel fails to boot, then the user has to choose the kernel
> > > manually anyway, and there will be an option in the warning prompt to
> > > lower SV.
> > 
> > And what if the firmware does not support a lowering of the SV?
> > 
> The SV list is manipulated by the bootloader, and the firmware only
> provides the interface to the storage, i.e. non-volatile flash.

What about systems where the bootloader is part of the system and users only have 
the ability to provide kernel images, but no ability to change the boot loader?

Thanks,

	Ingo
