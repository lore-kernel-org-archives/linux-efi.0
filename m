From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v6 2/5] efi: Add embedded peripheral firmware support
Date: Fri, 1 Jun 2018 16:40:26 -0700
Message-ID: <9ed05117-0566-52a2-5a09-c71dfd1fe632@infradead.org>
References: <20180601125330.25054-1-hdegoede@redhat.com>
 <20180601125330.25054-3-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180601125330.25054-3-hdegoede@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, dmitry.torokhov@gmail.com, mfuzzey@parkeon.com, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Linus Torvalds <torvalds@linux-foundation.org>, nbroeking@me.com, bjorn.andersson@linaro.org, Torsten Duwe <duwe@suse.de>, Kees Cook <keescook@chromium.org>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 06/01/2018 05:53 AM, Hans de Goede wrote:
> 
> Reported-by: Dave Olsthoorn <dave@bewaar.me>
> Suggested-by: Peter Jones <pjones@redhat.com>
> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
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

                                                prefix; if

> +then does a crc32 over length bytes and if that matches makes a copy of length
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

                                         /lib/firmware.

> +
> +To make request_firmware() fallback to trying EFI embedded firmwares after this,
> +the driver must set a boolean "efi-embedded-firmware" device-property on the
> +device before passing it to request_firmware(). Note that this disables the
> +usual usermodehelper fallback, so you may want to only set this on systems
> +which match your dmi_system_id array.
> +
> +Once the device-property is set, the driver can use the regular
> +request_firmware() function to get the firmware, using the name filled in
> +in the efi_embedded_fw_desc.
> +
> +Note that:
> +
> +1. The code scanning for EFI embbedded-firmware runs near the end
> +   of start_kernel(), just before calling rest_init(). For normal drivers and
> +   subsystems using subsys_initcall() to register themselves this does not
> +   matter. This means that code running earlier cannot use EFI
> +   embbedded-firmware.
> +
> +2. ATM the EFI embedded-fw code assumes that firmwares always start at an offset

s/ATM/At the moment/

> +   which is a multiple of 8 bytes, if this is not true for your case send in

                               bytes; if

> +   a patch to fix this.
> +
> +3. ATM the EFI embedded-fw code only works on x86 because other archs free

At the moment

> +   EFI_BOOT_SERVICES_CODE before the EFI embedded-fw code gets a chance to
> +   scan it.
> +
> +4. The current brute-force scanning of EFI_BOOT_SERVICES_CODE is an ad-hoc
> +   brute-force solution. There has been discussion to use the PI spec's
> +   Firmware Volume protocol. This has been rejected because the FV Protocol
> +   relies on *internal* interfaces of PI spec, and:
> +   1. The The PI spec does not define firmware at all
> +   2. The internal interfaces of PI Spec does not guarantee any backward
> +      compatibility. Any implementation details in FV may be subject to change,
> +      and may vary system to system. Supporting the FV Protocol would be
> +      difficult as it is purposely ambiguous.

What/where is this PI spec?

thanks,
-- 
~Randy
