From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC v3 PATCH 0/2] Introduce Security Version to EFI Stub
Date: Wed, 6 Dec 2017 19:37:34 +0100
Message-ID: <20171206183734.xmgecyrd5suiurm6@gmail.com>
References: <20171205100148.5757-1-glin@suse.com>
 <CA+5PVA4k9RN22i2d=4GCPnm9bwi5KUgp8PiV=9X1pBZxN1xPmg@mail.gmail.com>
 <20171206032437.pifxxcewgozlghfs@GaryWorkstation>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171206032437.pifxxcewgozlghfs@GaryWorkstation>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gary Lin <glin-IBi9RG/b67k@public.gmane.org>
Cc: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, x86 <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Joey Lee <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Gary Lin <glin-IBi9RG/b67k@public.gmane.org> wrote:

> On Tue, Dec 05, 2017 at 04:14:26PM -0500, Josh Boyer wrote:
> > On Tue, Dec 5, 2017 at 5:01 AM, Gary Lin <glin-IBi9RG/b67k@public.gmane.org> wrote:
> > > The series of patches introduce Security Version to EFI stub.
> > >
> > > Security Version is a monotonically increasing number and designed to
> > > prevent the user from loading an insecure kernel accidentally. The
> > > bootloader maintains a list of security versions corresponding to
> > > different distributions. After fixing a critical vulnerability, the
> > > distribution kernel maintainer bumps the "version", and the bootloader
> > > updates the list automatically. When the user tries to load a kernel
> > > with a lower security version, the bootloader shows a warning prompt
> > > to notify the user the potential risk.
> > 
> > If a distribution releases a kernel with a higher security version and
> > that it automatically updated on boot, what happens if that kernel
> > contains a different bug that causes it to fail to boot or break
> > critical functionality?  At that point, the user's machine would be in
> > a state where the higher security version is enforced but the only
> > kernel that provides that is broken.  Wouldn't that make a bad
> > situation even worse by now requiring manual acceptance of the older
> > SV kernel boot physically at the machine?
> > 
> > I feel like I'm missing a detail here or something.
> > 
> If the new kernel fails to boot, then the user has to choose the kernel
> manually anyway, and there will be an option in the warning prompt to
> lower SV.

And what if the firmware does not support a lowering of the SV?

Thanks,

	Ingo
