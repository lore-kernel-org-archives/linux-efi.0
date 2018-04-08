From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 0/5] efi/firmware/platform-x86: Add EFI embedded fw support
Date: Sun,  8 Apr 2018 19:26:31 +0200
Message-ID: <20180408172636.13926-1-hdegoede@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Hans de Goede <hdegoede@redhat.com>, platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, dmitry.torokhov@gmail.com, mfuzzey@parkeon.com, keescook@chromium.org, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Linus Torvalds <torvalds@linux-foundation.org>, nbroeking@me.com, bjorn.andersson@linaro.org, Torsten Duwe <duwe@suse.de>, x86@kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Hi All,

Here is v2 of my patch-set to add support for EFI embedded fw to the kernel.

The 3 most prominent changes are:

1) Add documentation describing the EFI embedded firmware mechanism to:
   Documentation/driver-api/firmware/request_firmware.rst

2) Instead of having a single dmi_system_id array with its driver_data
   members pointing to efi_embedded_fw_desc structs, have the drivers which
   need EFI embedded-fw support export a dmi_system_id array and register
   that with the EFI embedded-fw code

   This series also includes the first driver to use this, in the form of
   the touchscreen_dmi code (formerly silead_dmi) from drivers/platfrom/x86

3) As discussed during the review of v1 we want to make the firmware_loader
   code fallback to EFI embedded-fw optional.  Rather the adding yet another
   firmware_request_foo variant for this, with the risk of later also needing
   firmware_request_foo_nowait, etc. variants I've decided to make the code
   check if the device has a "efi-embedded-fw" device-property bool set.

   This also seemed better because the same driver may want to use the
   fallback on some systems, but not on others since e.g. not all (x86)
   systems with a silead touchscreen have their touchscreen firmware embedded
   in their EFI.

   Note that (as discussed) when the EFI fallback path is requested, the
   usermodehelper fallback path is skipped.

Here is the full changelog of patch 2/5 which is where most of the changes are:

Changes in v2:
-Rebased on driver-core/driver-core-next
-Add documentation describing the EFI embedded firmware mechanism to:
 Documentation/driver-api/firmware/request_firmware.rst
-Add a new EFI_EMBEDDED_FIRMWARE Kconfig bool and only build the embedded
 fw support if this is set. This is an invisible option which should be
 selected by drivers which need this
-Remove the efi_embedded_fw_desc and dmi_system_id-s for known devices
 from the efi-embedded-fw code, instead drivers using this are expected to
 export a dmi_system_id array, with each entries' driver_data pointing to a
 efi_embedded_fw_desc struct and register this with the efi-embedded-fw code
-Use kmemdup to make a copy instead of efi_mem_reserve()-ing the firmware,
 this avoids us messing with the EFI memmap and avoids the need to make
 changes to efi_mem_desc_lookup()
-Make the firmware-loader code only fallback to efi_get_embedded_fw() if
 the passed in device has the "efi-embedded-fw" device-property bool set
-Skip usermodehelper fallback when "efi-embedded-firmware" device-property
 is set

Patches 3-5 are new and implement using the EFI embedded-fw mechanism for
Silead gslXXXX and Chipone icn8505 touchscreens on x86 devices.

Regards,

Hans
