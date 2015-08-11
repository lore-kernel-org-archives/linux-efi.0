From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH v2 00/16] Signature verification of hibernate snapshot
Date: Tue, 11 Aug 2015 14:16:20 +0800
Message-ID: <1439273796-25359-1-git-send-email-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

Hi experts,

This patchset is the implementation of signature verification of hibernate
snapshot image. The origin idea is from Jiri Kosina: Let EFI bootloader
generate key-pair in UEFI secure boot environment, then forward it to kernel
for sign/verify hibernate image.

The first patchset for this function was sent in Sep. 2013, the implementation
is base on PKI. This new patchset is base on HMAC-SHA1.

The hibernate function provided by kernel was used to snapshot memory
to be a image for keeping in storage, then restored in appropriate time.
There have potential threat from hacking the memory snapshot image.
Cracker may triggers hibernating process through ioctl to grab snapshot
image, then restoring modified image back to memory. Another situation
is booting to other hacked OS to modify the snapshot image in swap
partition or file, then user may runs malware after image restored to
memory. In addition, the above weakness cause kernel is not fully trusted
in EFI secure boot environment.

So, kernel hibernate function needs a mechanism to verify integrity of
hibernate snapshot image.

For signing hibernate image, kernel need a key for generating signature of
image. The origin idea is using PKI, the EFI bootloader, shim generates key
pair and forward to boot kernel for signing/verifying image. In Linux Plumbers
Conference 2013, we got response from community experts for just using
symmetric key algorithm to generate signature, that's simpler and no EFI
bootloader's involving.

Current solution is using HMAC-SHA1 algorithm, it generating HMAC key in EFI
stub, the HMAC key stored in efi boot service variable, When hibernate
recovering, kernel will verify the image signature before switch whole system
to image kernel and image memory space. When verifying failed, kernel is
tainted or stop recovering and discarding image.

Set HIBERNATE_VERIFICATION compile option to true for enabling hibernate
verification. The default behavior of verifying failed is accept restoring
image but tainting kernel with H taint flag. Using HIBERNATE_VERIFICATION_FORCE
kernel compile option or "sigenforce" kernel parameter to force hibernate
recovery process stop when verification failed. It allows user to trigger the
key re-generating process in EFI stub through SNAPSHOT_REGENERATE_KEY ioctl.

v2:
 - Replaced all SWSUSP naming with HIBERNATION.
 - Moved swsusp_info structure definition only for CONFIG_HIBERNATION.
 - Fixed typo in patch subject and description.
 - Changed name of i8254() to read_i8254()
 - Removed all efi_printk log in efi_random.c
 - Changed the size of key array to be unsigned in efi_random.c
 - Avoid calling cpuid many times.
 - Add line breaks to error log in efi_random.c
 - Removed free_handle label in efi_random.c
 - Moved efi_status_to_str() to efi_random.c, and reduce code duplication.
 - Set rng_handle = NULL in efi_locate_rng()
 - Changed u32 random to bool in efi_rng_supported()
 - Using EFI status codes explicitly.
 - Modified Copyright declaration.
 - Moved set_hibernation_key_regen_flag to user.c


Lee, Chun-Yi (16):
  PM / hibernate: define HMAC algorithm and digest size of hibernation
  x86/efi: Add get and set variable to EFI services pointer table
  x86/boot: Public getting random boot function
  x86/efi: Generating random number in EFI stub
  x86/efi: Get entropy through EFI random number generator protocol
  x86/efi: Generating random HMAC key for siging hibernate image
  efi: Make efi_status_to_err() public
  x86/efi: Carrying hibernation key by setup data
  PM / hibernate: Reserve hibernation key and erase footprints
  PM / hibernate: Generate and verify signature of hibernate snapshot
  PM / hibernate: Avoid including hibernation key to hibernate image
  PM / hibernate: Forward signature verifying result and key to image
    kernel
  PM / hibernate: Add configuration to enforce signature verification
  PM / hibernate: Allow user trigger hibernation key re-generating
  PM / hibernate: Bypass verification logic on legacy BIOS
  PM / hibernate: Document signature verification of hibernate snapshot

 Documentation/kernel-parameters.txt             |   5 +
 Documentation/power/swsusp-signature-verify.txt |  86 +++++++
 arch/x86/boot/compressed/Makefile               |   1 +
 arch/x86/boot/compressed/aslr.c                 |  57 +----
 arch/x86/boot/compressed/eboot.c                |  97 ++++++++
 arch/x86/boot/compressed/efi_random.c           | 289 +++++++++++++++++++++++
 arch/x86/boot/compressed/head_32.S              |   6 +-
 arch/x86/boot/compressed/head_64.S              |   8 +-
 arch/x86/boot/compressed/misc.c                 |  55 +++++
 arch/x86/boot/compressed/misc.h                 |   4 +
 arch/x86/include/asm/efi.h                      |   2 +
 arch/x86/include/asm/suspend.h                  |  13 ++
 arch/x86/include/uapi/asm/bootparam.h           |   1 +
 arch/x86/kernel/setup.c                         |  21 +-
 arch/x86/power/Makefile                         |   1 +
 arch/x86/power/hibernate_keys.c                 | 173 ++++++++++++++
 drivers/firmware/Makefile                       |   1 +
 drivers/firmware/efi/Kconfig                    |   4 +
 drivers/firmware/efi/Makefile                   |   1 +
 drivers/firmware/efi/efi-hibernate_keys.c       |  42 ++++
 drivers/firmware/efi/vars.c                     |  33 ---
 include/linux/efi.h                             |  46 ++++
 include/linux/kernel.h                          |   1 +
 include/linux/suspend.h                         |  27 +++
 include/uapi/linux/suspend_ioctls.h             |   3 +-
 kernel/panic.c                                  |   2 +
 kernel/power/Kconfig                            |  23 ++
 kernel/power/hibernate.c                        |  10 +
 kernel/power/power.h                            |  22 +-
 kernel/power/snapshot.c                         | 293 ++++++++++++++++++++++--
 kernel/power/swap.c                             |   4 +
 kernel/power/user.c                             |  19 ++
 kernel/reboot.c                                 |   3 +
 33 files changed, 1240 insertions(+), 113 deletions(-)
 create mode 100644 Documentation/power/swsusp-signature-verify.txt
 create mode 100644 arch/x86/boot/compressed/efi_random.c
 create mode 100644 arch/x86/power/hibernate_keys.c
 create mode 100644 drivers/firmware/efi/efi-hibernate_keys.c

-- 
2.1.4
