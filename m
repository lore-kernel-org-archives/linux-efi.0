From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v6 2/5] efi: Add embedded peripheral firmware support
Date: Tue, 5 Jun 2018 23:07:53 +0200
Message-ID: <20180605210753.GC4511@wotan.suse.de>
References: <20180601125330.25054-1-hdegoede@redhat.com>
 <20180601125330.25054-3-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180601125330.25054-3-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, dmitry.torokhov@gmail.com, mfuzzey@parkeon.com, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Linus Torvalds <torvalds@linux-foundation.org>, nbroeking@me.com, bjorn.andersson@linaro.org
List-Id: linux-efi@vger.kernel.org

On Fri, Jun 01, 2018 at 02:53:27PM +0200, Hans de Goede wrote:
> Just like with PCI options ROMs, which we save in the setup_efi_pci*
> functions from arch/x86/boot/compressed/eboot.c, the EFI code / ROM itself
> sometimes may contain data which is useful/necessary for peripheral drivers
> to have access to.
> 
> Specifically the EFI code may contain an embedded copy of firmware which
> needs to be (re)loaded into the peripheral. Normally such firmware would be
> part of linux-firmware, but in some cases this is not feasible, for 2
> reasons:
> 
> 1) The firmware is customized for a specific use-case of the chipset / use
> with a specific hardware model, so we cannot have a single firmware file
> for the chipset. E.g. touchscreen controller firmwares are compiled
> specifically for the hardware model they are used with, as they are
> calibrated for a specific model digitizer.
> 
> 2) Despite repeated attempts we have failed to get permission to
> redistribute the firmware. This is especially a problem with customized
> firmwares, these get created by the chip vendor for a specific ODM and the
> copyright may partially belong with the ODM, so the chip vendor cannot
> give a blanket permission to distribute these.
> 
> This commit adds support for finding peripheral firmware embedded in the
> EFI code and making this available to peripheral drivers through the
> standard firmware loading mechanism.
> 
> Note we check the EFI_BOOT_SERVICES_CODE for embedded firmware near the end
> of start_kernel(), just before calling rest_init(), this is on purpose
> because the typical EFI_BOOT_SERVICES_CODE memory-segment is too large for
> early_memremap(), so the check must be done after mm_init(). This relies
> on EFI_BOOT_SERVICES_CODE not being free-ed until efi_free_boot_services()
> is called, which means that this will only work on x86 for now.
> 
> Reported-by: Dave Olsthoorn <dave@bewaar.me>
> Suggested-by: Peter Jones <pjones@redhat.com>
> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
> Changes in v6:
> -Rework code to remove casts from if (prefix == mem) comparison
> -Use SHA256 hashes instead of crc32 sums
> -Add new READING_FIRMWARE_EFI_EMBEDDED read_file_id and use it
> -Call security_kernel_read_file(NULL, READING_FIRMWARE_EFI_EMBEDDED)
>  to check if this is allowed before looking at EFI embedded fw
> -Document why we are not using the PI Firmware Volume protocol
> 
> Changes in v5:
> -Rename the EFI_BOOT_SERVICES flag to EFI_PRESERVE_BS_REGIONS
> 
> Changes in v4:
> -Drop note in docs about EFI_FIRMWARE_VOLUME_PROTOCOL, it is not part of
>  UEFI proper, so the EFI maintainers don't want us referring people to it
> -Use new EFI_BOOT_SERVICES flag
> -Put the new fw_get_efi_embedded_fw() function in its own fallback_efi.c
>  file which only gets built when EFI_EMBEDDED_FIRMWARE is selected
> -Define an empty stub for fw_get_efi_embedded_fw() in fallback.h hwen
>  EFI_EMBEDDED_FIRMWARE is not selected, to avoid the need for #ifdefs
>  in firmware_loader/main.c
> -Properly call security_kernel_post_read_file() on the firmware returned
>  by efi_get_embedded_fw() to make sure that we are allowed to use it
> 
> Changes in v3:
> -Fix the docs using "efi-embedded-fw" as property name instead of
>  "efi-embedded-firmware"
> 
> Changes in v2:
> -Rebased on driver-core/driver-core-next
> -Add documentation describing the EFI embedded firmware mechanism to:
>  Documentation/driver-api/firmware/request_firmware.rst
> -Add a new EFI_EMBEDDED_FIRMWARE Kconfig bool and only build the embedded
>  fw support if this is set. This is an invisible option which should be
>  selected by drivers which need this
> -Remove the efi_embedded_fw_desc and dmi_system_id-s for known devices
>  from the efi-embedded-fw code, instead drivers using this are expected to
>  export a dmi_system_id array, with each entries' driver_data pointing to a
>  efi_embedded_fw_desc struct and register this with the efi-embedded-fw code
> -Use kmemdup to make a copy instead of efi_mem_reserve()-ing the firmware,
>  this avoids us messing with the EFI memmap and avoids the need to make
>  changes to efi_mem_desc_lookup()
> -Make the firmware-loader code only fallback to efi_get_embedded_fw() if the
>  passed in device has the "efi-embedded-firmware" device-property bool set
> -Skip usermodehelper fallback when "efi-embedded-firmware" device-property
>  is set
> ---
>  .../driver-api/firmware/request_firmware.rst  |  76 +++++++++
>  drivers/base/firmware_loader/Makefile         |   1 +
>  drivers/base/firmware_loader/fallback.h       |  12 ++
>  drivers/base/firmware_loader/fallback_efi.c   |  56 +++++++
>  drivers/base/firmware_loader/main.c           |   2 +
>  drivers/firmware/efi/Kconfig                  |   3 +
>  drivers/firmware/efi/Makefile                 |   1 +
>  drivers/firmware/efi/embedded-firmware.c      | 148 ++++++++++++++++++
>  include/linux/efi.h                           |   6 +
>  include/linux/efi_embedded_fw.h               |  25 +++
>  include/linux/fs.h                            |   1 +
>  init/main.c                                   |   3 +
>  12 files changed, 334 insertions(+)
>  create mode 100644 drivers/base/firmware_loader/fallback_efi.c
>  create mode 100644 drivers/firmware/efi/embedded-firmware.c
>  create mode 100644 include/linux/efi_embedded_fw.h
> 
> diff --git a/Documentation/driver-api/firmware/request_firmware.rst b/Documentation/driver-api/firmware/request_firmware.rst
> index f62bdcbfed5b..66ab91f3357d 100644
> --- a/Documentation/driver-api/firmware/request_firmware.rst
> +++ b/Documentation/driver-api/firmware/request_firmware.rst
> @@ -73,3 +73,79 @@ If something went wrong request_firmware() returns non-zero and fw_entry
>  is set to NULL. Once your driver is done with processing the firmware it
>  can call call release_firmware(fw_entry) to release the firmware image
>  and any related resource.
> +
> +EFI embedded firmware support
> +=============================
> +
> +On some devices the system's EFI code / ROM may contain an embedded copy
> +of firmware for some of the system's integrated peripheral devices and
> +the peripheral's Linux device-driver needs to access this firmware.
> +
> +A device driver which needs this can describe the firmware it needs
> +using an efi_embedded_fw_desc struct:
> +
> +.. kernel-doc:: include/linux/efi_embedded_fw.h
> +   :functions: efi_embedded_fw_desc
> +
> +The EFI embedded-fw code works by scanning all EFI_BOOT_SERVICES_CODE memory
> +segments for an eight byte sequence matching prefix, if the prefix is found it
> +then does a crc32 

You still refer to crc32 here. This needs to be updated.

> over length bytes and if that matches makes a copy of length
> +bytes and adds that to its list with found firmwares.
> +
> +To avoid doing this somewhat expensive scan on all systems, dmi matching is
> +used. Drivers are expected to export a dmi_system_id array, with each entries'
> +driver_data pointing to an efi_embedded_fw_desc.
> +
> +To register this array with the efi-embedded-fw code, a driver needs to:
> +
> +1. Always be builtin to the kernel or store the dmi_system_id array in a
> +   separate object file which always gets builtin.
> +
> +2. Add an extern declaration for the dmi_system_id array to
> +   include/linux/efi_embedded_fw.h.
> +
> +3. Add the dmi_system_id array to the embedded_fw_table in
> +   drivers/firmware/efi/embedded-firmware.c wrapped in a #ifdef testing that
> +   the driver is being builtin.
> +
> +4. Add "select EFI_EMBEDDED_FIRMWARE if EFI_STUB" to its Kconfig entry.
> +
> +The request_firmware() function will always first try to load firmware with
> +the specified name directly from the disk, so the EFI embedded-fw can always
> +be overridden by placing a file under /lib/firmare.
> +
> +To make request_firmware() fallback to trying EFI embedded firmwares after this,
> +the driver must set a boolean "efi-embedded-firmware" device-property on the
> +device before passing it to request_firmware().

No, as I have requested before I don't want this, it is silly to have such
functionality always be considered as a fallback if we only have 2 drivers
which need this. Please add a call which only if used would then *evaluate*
such fallback prospect.

So NACK for now.

  Luis
