From: Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH 2/2] efi: Add embedded peripheral firmware support
Date: Wed, 4 Apr 2018 13:18:36 -0400
Message-ID: <20180404171835.xvllgcqirl3b5gd5@redhat.com>
References: <20180331121944.8618-1-hdegoede@redhat.com>
 <20180331121944.8618-2-hdegoede@redhat.com>
 <20180402232333.GU30543@wotan.suse.de>
 <17fb3c28-78ff-2e1f-2ada-d33320567761@redhat.com>
 <20180403180711.GA7957@wunner.de>
 <20180403185848.GD30543@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180403185848.GD30543@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Lukas Wunner <lukas@wunner.de>, Hans de Goede <hdegoede@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, Dave Olsthoorn <dave@bewaar.me>, x86@kernel.org, linux-efi@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Matthew Garrett <mjg59@srcf.ucam.org>, One Thousand Gnomes <gnomes@lxorguk.uk>
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 03, 2018 at 06:58:48PM +0000, Luis R. Rodriguez wrote:
> On Tue, Apr 03, 2018 at 08:07:11PM +0200, Lukas Wunner wrote:
> > On Tue, Apr 03, 2018 at 10:33:25AM +0200, Hans de Goede wrote:
> > > I asked Peter Jones for suggestions how to extract this during boot and
> > > he suggested seeing if there was a copy of the firmware in the
> > > EFI_BOOT_SERVICES_CODE memory segment, which it turns out there is.
> > > 
> > > My patch to add support for this contains a table of device-model (dmi
> > > strings), firmware header (first 64 bits), length and crc32 and then if
> > > we boot on a device-model which is in the table the code scans the
> > > EFI_BOOT_SERVICES_CODE for the prefix, if found checks the crc and
> > > caches the firmware for later use by request-firmware.
> > > 
> > > So I just do a brute-force search for the firmware, this really is hack,
> > > nothing standard about it I'm afraid. But it works on 4 different x86
> > > tablets I have and makes the touchscreen work OOTB on them, so I believe
> > > it is a worthwhile hack to have.
> > 
> > The EFI Firmware Volume contains a kind of filesystem with files
> > identified by GUIDs.  Those files include EFI drivers, ACPI tables,
> > DMI data and so on.  It is actually quite common for vendors to
> > also include device firmware on the Firmware Volume.  Apple is doing
> > this to ship firmware updates e.g. for the GMUX controller found on
> > dual GPU MacBook Pros.  If they want to update the controller's
> > firmware, they include it in a BIOS update, and an EFI driver checks
> > on boot if the firmware update for the controller is necessary and
> > if so, flashes it.
> > 
> > The firmware files you're looking for are almost certainly included
> > on the Firmware Volume as individual files.
> 
> What Hans implemented seems to have been for a specific x86 hack, best if we
> confirm if indeed they are present on the Firmware Volume.

To be honest, I'm a bit skeptical about the firmware volume approach.
Tools like UEFITool[0] and uefi-firmware-parser[1] have existed for
years, still don't seem to reliably parse firmware images I see in the
wild, and have a fairly regular need for fixes.  These are tools
maintained by smart people who are making a real effort, and it still
looks pretty hard to do a good job that applies across a lot of
platforms.

So I'd rather use Hans's existing patches, at least for now, and if
someone is interested in hacking on making an efi firmware volume parser
for the kernel, switch them to that when such a thing is ready.

[0] git@github.com:LongSoft/UEFITool.git
[1] git@github.com:theopolis/uefi-firmware-parser.git

> > Rather than scraping
> > the EFI memory for firmware, I think it would be cleaner and more
> > elegant if you just retrieve the files you're interested in from
> > the Firmware Volume.
> > 
> > We're doing something similar with Apple EFI properties, see
> > 58c5475aba67 and c9cc3aaa0281.
> > 
> > Basically what you need to do to implement this approach is:
> > 
> > * Determine the GUIDs used by vendors for the files you're interested
> >   in.  Either dump the Firmware Volume or take an EFI update as
> >   shipped by the vendor, then feed it to UEFIExtract:
> >   https://github.com/LongSoft/UEFITool
> >   
> > * Add the EFI Firmware Volume Protocol to include/linux/efi.h:
> >   https://www.intel.com/content/dam/doc/reference-guide/efi-firmware-file-volume-specification.pdf
> > 
> > * Amend arch/x86/boot/compressed/eboot.c to read the files with the
> >   GUIDs you're interested in into memory and pass the files to the
> >   kernel as setup_data payloads.
> > 
> > * Once the kernel has booted, make the files you've retrieved
> >   available to device drivers as firmware blobs.
> 
> Happen to know if devices using Firmware Volumes also sign their firmware
> and if hw checks the firmware at load time?

It varies on a per-device basis, of course.  Most new Intel machines as
of Haswell *should* be verifying their system firmware via Boot Guard,
which both checks an RSA signature and measures the firmware into the
TPM, but as with everything of this nature, there are certainly vendors
that screw it up. (I think AMD has something similar, but I'm really not
sure.)

-- 
  Peter
