From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC v3 PATCH 0/2] Introduce Security Version to EFI Stub
Date: Thu, 7 Dec 2017 11:35:52 +0100
Message-ID: <20171207103552.axrydmelueigdwyd@gmail.com>
References: <20171205100148.5757-1-glin@suse.com>
 <CA+5PVA4k9RN22i2d=4GCPnm9bwi5KUgp8PiV=9X1pBZxN1xPmg@mail.gmail.com>
 <20171206032437.pifxxcewgozlghfs@GaryWorkstation>
 <20171206183734.xmgecyrd5suiurm6@gmail.com>
 <20171207015903.jaos5siysggzz4nc@GaryWorkstation>
 <20171207060927.i4b4h6ahas3iiyrc@gmail.com>
 <20171207075203.gcxprq7ctv637fm7@GaryWorkstation>
 <20171207081816.jy2rw5y5iyxeqw6n@gmail.com>
 <20171207102749.cv7ybllv2vi7o7hw@GaryWorkstation>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171207102749.cv7ybllv2vi7o7hw@GaryWorkstation>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gary Lin <glin-IBi9RG/b67k@public.gmane.org>
Cc: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, x86 <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Joey Lee <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



* Gary Lin <glin-IBi9RG/b67k@public.gmane.org> wrote:

> On Thu, Dec 07, 2017 at 09:18:16AM +0100, Ingo Molnar wrote:
> > 
> > * Gary Lin <glin-IBi9RG/b67k@public.gmane.org> wrote:
> > 
> > > On Thu, Dec 07, 2017 at 07:09:27AM +0100, Ingo Molnar wrote:
> > > > 
> > > > * Gary Lin <glin-IBi9RG/b67k@public.gmane.org> wrote:
> > > > 
> > > > > On Wed, Dec 06, 2017 at 07:37:34PM +0100, Ingo Molnar wrote:
> > > > > > 
> > > > > > * Gary Lin <glin-IBi9RG/b67k@public.gmane.org> wrote:
> > > > > > 
> > > > > > > On Tue, Dec 05, 2017 at 04:14:26PM -0500, Josh Boyer wrote:
> > > > > > > > On Tue, Dec 5, 2017 at 5:01 AM, Gary Lin <glin-IBi9RG/b67k@public.gmane.org> wrote:
> > > > > > > > > The series of patches introduce Security Version to EFI stub.
> > > > > > > > >
> > > > > > > > > Security Version is a monotonically increasing number and designed to
> > > > > > > > > prevent the user from loading an insecure kernel accidentally. The
> > > > > > > > > bootloader maintains a list of security versions corresponding to
> > > > > > > > > different distributions. After fixing a critical vulnerability, the
> > > > > > > > > distribution kernel maintainer bumps the "version", and the bootloader
> > > > > > > > > updates the list automatically. When the user tries to load a kernel
> > > > > > > > > with a lower security version, the bootloader shows a warning prompt
> > > > > > > > > to notify the user the potential risk.
> > > > > > > > 
> > > > > > > > If a distribution releases a kernel with a higher security version and
> > > > > > > > that it automatically updated on boot, what happens if that kernel
> > > > > > > > contains a different bug that causes it to fail to boot or break
> > > > > > > > critical functionality?  At that point, the user's machine would be in
> > > > > > > > a state where the higher security version is enforced but the only
> > > > > > > > kernel that provides that is broken.  Wouldn't that make a bad
> > > > > > > > situation even worse by now requiring manual acceptance of the older
> > > > > > > > SV kernel boot physically at the machine?
> > > > > > > > 
> > > > > > > > I feel like I'm missing a detail here or something.
> > > > > > > > 
> > > > > > > If the new kernel fails to boot, then the user has to choose the kernel
> > > > > > > manually anyway, and there will be an option in the warning prompt to
> > > > > > > lower SV.
> > > > > > 
> > > > > > And what if the firmware does not support a lowering of the SV?
> > > > > > 
> > > > > The SV list is manipulated by the bootloader, and the firmware only
> > > > > provides the interface to the storage, i.e. non-volatile flash.
> > > > 
> > > > What about systems where the bootloader is part of the system and users only have 
> > > > the ability to provide kernel images, but no ability to change the boot loader?
> > > 
> > > It depends on how the bootloader works. If the system uses my
> > > implementation of shim loader, it surely has the ability to lower SV,
> > > but it requires physical access on purpose.
> > 
> > And that's my problem: if in practice the bootloader is 'part of the system', is 
> > signed and is updated like the firmware, then putting a "Security Version" into 
> > the kernel image and architecting a boot protocol for a monotonic method for the 
> > bootloader to restrict the loading of kernel images is an obviously bad idea.
> > 
> Even though the bootloader doesn't actually block the booting?

We don't know that for sure, in that scenario *how* the bootloader interprets the 
SV is not under the user's control...

Thanks,

	Ingo
