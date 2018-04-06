From: Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH 2/2] efi: Add embedded peripheral firmware support
Date: Fri, 6 Apr 2018 10:16:44 -0400
Message-ID: <20180406141642.23xfaub52gv3zpio@redhat.com>
References: <78ae4d18-8964-5748-a69f-0017d0dca5f7@redhat.com>
 <20180404171835.xvllgcqirl3b5gd5@redhat.com>
 <20180405054349.GA25653@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180405054349.GA25653@wunner.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>
Cc: Hans de Goede <hdegoede@redhat.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, Dave Olsthoorn <dave@bewaar.me>, x86@kernel.org, linux-efi@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Matthew Garrett <mjg59@srcf.ucam.org>, One Thousand Gnomes <gnomes@l>
List-Id: linux-efi@vger.kernel.org

On Thu, Apr 05, 2018 at 07:43:49AM +0200, Lukas Wunner wrote:
> On Wed, Apr 04, 2018 at 01:18:36PM -0400, Peter Jones wrote:
> > > On Tue, Apr 03, 2018 at 08:07:11PM +0200, Lukas Wunner wrote:
> > > > * Add the EFI Firmware Volume Protocol to include/linux/efi.h:
> > > >   https://www.intel.com/content/dam/doc/reference-guide/efi-firmware-file-volume-specification.pdf
> > > > 
> > > > * Amend arch/x86/boot/compressed/eboot.c to read the files with the
> > > >   GUIDs you're interested in into memory and pass the files to the
> > > >   kernel as setup_data payloads.
> > 
> > To be honest, I'm a bit skeptical about the firmware volume approach.
> > Tools like UEFITool[0] and uefi-firmware-parser[1] have existed for
> > years, still don't seem to reliably parse firmware images I see in the
> > wild, and have a fairly regular need for fixes.  These are tools
> > maintained by smart people who are making a real effort, and it still
> > looks pretty hard to do a good job that applies across a lot of
> > platforms.
> > 
> > So I'd rather use Hans's existing patches, at least for now, and if
> > someone is interested in hacking on making an efi firmware volume parser
> > for the kernel, switch them to that when such a thing is ready.
> 
> Hello?  As I've written in the above-quoted e-mail the kernel should
> read the files using EFI_FIRMWARE_VOLUME_PROTOCOL.ReadFile().
> 
> *Not* by parsing the firmware volume!

Okay, that's a fair point that I'd missed reading your first mail.  It's
worth a shot.  That said, EFI_FIRMWARE_VOLUME_PROTOCOL is part of the
PI spec, not the UEFI spec.  It's not required in order to implement UEFI,
and some implementations don't use it.  Even when the implementation
does include PI, there's no guarantee PI protocols are exposed after the
"End of DXE" event (though edk2 will expose this, I think).

> Parsing the firmware volume is only necessary to find out the GUIDs
> of the files you're looking for.  You only do that *once*.
> 
> I habitually extract Apple's EFI Firmware Volumes and found the
> existing tools always did a sufficiently good job to get the
> information I need (such as UEFIExtract, which I've linked to,
> and which is part of the UEFITool suite, which you've linked to
> once more).

Yeah, it's probably worth implementing your way and using it when we
can.

> On Wed, Apr 04, 2018 at 10:25:05PM +0200, Hans de Goede wrote:
> > Lukas, thank you for your suggestions on this, but I doubt that these
> > devices use the Firmware Volume stuff.
> 
> If they're using EFI, they're using a Firmware Volume and you should
> be able to use the Firmware Volume Protocol to read files from it.

This is not actually the case.  There is more than one implementation of
UEFI, and they do not all implement PEI/DXE/etc from the PI spec.  For
two examples, there are still vendors that ship EDK-I implementations on
some platforms, and current u-boot can be built to export a UEFI API.
(It's a subset, but so is every other implementation.)

> If that protocol wasn't supported, the existing EFI drivers wouldn't
> be able to function as they couldn't load files from the volume.

This is not correct.  Not all UEFI implementations implement *any* of
PI.  Also, AFAIK, nothing we use in Linux so far directly depends on
anything in PI.

> > What you are describing sounds like significantly more work then
> > the vendor just embedding the firmware as a char firmware[] in their
> > EFI mouse driver.
> 
> In such cases, read the EFI mouse driver from the firmware volume and
> extract the firmware from the offset you've pre-determined.  That's
> never going to change since the devices never receive updates, as
> you're saying.  So basically you'll have a struct with GUID, offset,
> length, and the name under which the firmware is made available to
> Linux drivers.

No, he's saying that it's really easy to implement a driver with the
device firmware in a char [] in the code, so cheap ODMs who supply a
UEFI driver with their hardware part are very, very likely to have done
that instead of providing two things to go into the FV - a UEFI driver
*and* a separate image for the device firmware.  This also cuts out a
point of failure between the OEM and the ODM.

> > That combined with Peter's worries about difficulties parsing the
> > Firmware Volume stuff, makes me believe that it is best to just
> > stick with my current approach as Peter suggests.
> 
> I don't know why you insist on a hackish solution (your own words)
> even though a cleaner solution is suggested, but fortunately it's
> not for me to decide what goes in and what doesn't. ;-)

It already works...

-- 
  Peter
