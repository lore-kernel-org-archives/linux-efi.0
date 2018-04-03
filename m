From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH 2/2] efi: Add embedded peripheral firmware support
Date: Tue, 3 Apr 2018 20:07:11 +0200
Message-ID: <20180403180711.GA7957@wunner.de>
References: <20180331121944.8618-1-hdegoede@redhat.com>
 <20180331121944.8618-2-hdegoede@redhat.com>
 <20180402232333.GU30543@wotan.suse.de>
 <17fb3c28-78ff-2e1f-2ada-d33320567761@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17fb3c28-78ff-2e1f-2ada-d33320567761@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, x86@kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 03, 2018 at 10:33:25AM +0200, Hans de Goede wrote:
> I asked Peter Jones for suggestions how to extract this during boot and
> he suggested seeing if there was a copy of the firmware in the
> EFI_BOOT_SERVICES_CODE memory segment, which it turns out there is.
> 
> My patch to add support for this contains a table of device-model (dmi
> strings), firmware header (first 64 bits), length and crc32 and then if
> we boot on a device-model which is in the table the code scans the
> EFI_BOOT_SERVICES_CODE for the prefix, if found checks the crc and
> caches the firmware for later use by request-firmware.
> 
> So I just do a brute-force search for the firmware, this really is hack,
> nothing standard about it I'm afraid. But it works on 4 different x86
> tablets I have and makes the touchscreen work OOTB on them, so I believe
> it is a worthwhile hack to have.

The EFI Firmware Volume contains a kind of filesystem with files
identified by GUIDs.  Those files include EFI drivers, ACPI tables,
DMI data and so on.  It is actually quite common for vendors to
also include device firmware on the Firmware Volume.  Apple is doing
this to ship firmware updates e.g. for the GMUX controller found on
dual GPU MacBook Pros.  If they want to update the controller's
firmware, they include it in a BIOS update, and an EFI driver checks
on boot if the firmware update for the controller is necessary and
if so, flashes it.

The firmware files you're looking for are almost certainly included
on the Firmware Volume as individual files.  Rather than scraping
the EFI memory for firmware, I think it would be cleaner and more
elegant if you just retrieve the files you're interested in from
the Firmware Volume.

We're doing something similar with Apple EFI properties, see
58c5475aba67 and c9cc3aaa0281.

Basically what you need to do to implement this approach is:

* Determine the GUIDs used by vendors for the files you're interested
  in.  Either dump the Firmware Volume or take an EFI update as
  shipped by the vendor, then feed it to UEFIExtract:
  https://github.com/LongSoft/UEFITool
  
* Add the EFI Firmware Volume Protocol to include/linux/efi.h:
  https://www.intel.com/content/dam/doc/reference-guide/efi-firmware-file-volume-specification.pdf

* Amend arch/x86/boot/compressed/eboot.c to read the files with the
  GUIDs you're interested in into memory and pass the files to the
  kernel as setup_data payloads.

* Once the kernel has booted, make the files you've retrieved
  available to device drivers as firmware blobs.

The end result is mostly the same as what you're doing here,
and you'll also have a similar array of structs, but instead
of hardcoding 8-byte signatures of firmware files, you'll be
using GUIDs.  I envision lots of interesting use cases for
a generic Firmware Volume file retrieval mechanism.  What you
need to keep in mind though is that this approach only works
if the kernel is booted via the EFI stub.

Thanks,

Lukas
