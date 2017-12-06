From: Gary Lin <glin-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC v3 PATCH 0/2] Introduce Security Version to EFI Stub
Date: Wed, 6 Dec 2017 11:24:37 +0800
Message-ID: <20171206032437.pifxxcewgozlghfs@GaryWorkstation>
References: <20171205100148.5757-1-glin@suse.com>
 <CA+5PVA4k9RN22i2d=4GCPnm9bwi5KUgp8PiV=9X1pBZxN1xPmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+5PVA4k9RN22i2d=4GCPnm9bwi5KUgp8PiV=9X1pBZxN1xPmg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Cc: x86 <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Joey Lee <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Dec 05, 2017 at 04:14:26PM -0500, Josh Boyer wrote:
> On Tue, Dec 5, 2017 at 5:01 AM, Gary Lin <glin-IBi9RG/b67k@public.gmane.org> wrote:
> > The series of patches introduce Security Version to EFI stub.
> >
> > Security Version is a monotonically increasing number and designed to
> > prevent the user from loading an insecure kernel accidentally. The
> > bootloader maintains a list of security versions corresponding to
> > different distributions. After fixing a critical vulnerability, the
> > distribution kernel maintainer bumps the "version", and the bootloader
> > updates the list automatically. When the user tries to load a kernel
> > with a lower security version, the bootloader shows a warning prompt
> > to notify the user the potential risk.
> 
> If a distribution releases a kernel with a higher security version and
> that it automatically updated on boot, what happens if that kernel
> contains a different bug that causes it to fail to boot or break
> critical functionality?  At that point, the user's machine would be in
> a state where the higher security version is enforced but the only
> kernel that provides that is broken.  Wouldn't that make a bad
> situation even worse by now requiring manual acceptance of the older
> SV kernel boot physically at the machine?
> 
> I feel like I'm missing a detail here or something.
> 
If the new kernel fails to boot, then the user has to choose the kernel
manually anyway, and there will be an option in the warning prompt to
lower SV.

Since Security Version is meant to be a warning, not a hard block, we
can introduce a timeout to the warning prompt if necessary. The system
still boots, but with a longer boot time.

Gary Lin

> josh
> 
> > For more details: https://github.com/lcp/shim/wiki/Security-Version
> >
> > The original idea is to add a new PE/COFF section to store the data.
> > However, there are some restrictions.
> >
> > 1. For x86, the size limit of the EFI header is 0x200, and a section entry
> >    in the section table takes 40 bytes. Currently, the EFI header already
> >    occupies the first 0x1da bytes, so there is no room for a new section
> >    entry.
> >
> > 2. The MemoryAttributes table sets the attributes of memory pages according
> >    to the section flags. For ARM64, the minimal granularity is 4KB, but
> >    Security Version only needs a few bytes, and it's pointless to allocate
> >    4KB for it.
> >
> > Fortunately, there is a special section defined in PE/COFF: resource
> > section. The only known user of the resource section in UEFI is the HII
> > protocol which fetches data from "HII" directory. For Security Version, a
> > new directory called "LinuxSV" is created and it contains the file offset
> > to the struct of Security Version. The bootloader just follows the
> > resource table to fetch the "version" from the image file.
> >
> > v3:
> >     - Move everything to the resource section to be compatible with both
> >       x86 and ARM64
> > v2:
> >     - Decrease the size of secdata_offset to 2 bytes since the setup header
> >       is limited to around 32KB.
> >     - Restructure the secdata section. The signer is now a null-terminated
> >       string. The type of distro_version changes to u32 in case the distro
> >       uses a long version.
> >     - Modify the Kconfig names and add help.
> >     - Remove the signer name hack in build.c.
> >
> > Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> > Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> > Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> > Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
> > Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
> > Cc: Joey Lee <jlee-IBi9RG/b67k@public.gmane.org>
> > Signed-off-by: Gary Lin <glin-IBi9RG/b67k@public.gmane.org>
> >
> > Gary Lin (2):
> >   x86/efi: Introduce Security Version to x86
> >   arm64/efi: Introduce Security Version to ARM64
> >
> >  arch/arm64/kernel/efi-header.S | 57 ++++++++++++++++++++++++++++++++++++++++++
> >  arch/x86/boot/header.S         | 55 ++++++++++++++++++++++++++++++++++++++++
> >  drivers/firmware/efi/Kconfig   | 40 +++++++++++++++++++++++++++++
> >  3 files changed, 152 insertions(+)
> >
> > --
> > 2.15.0
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
