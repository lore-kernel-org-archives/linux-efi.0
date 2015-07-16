From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 00/16] Signature verification of hibernate snapshot
Date: Thu, 16 Jul 2015 22:25:14 +0800
Message-ID: <1437056730-15247-1-git-send-email-jlee@suse.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
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


Lee, Chun-Yi (16):
  PM / hibernate: define HMAC algorithm and digest size of swsusp
  x86/efi: Add get and set variable to EFI services pointer table
  x86/boot: Public getting random boot function
  x86/efi: Generating random number in EFI stub
  x86/efi: Get entropy through EFI random number generator protocol
  x86/efi: Generating random HMAC key for siging hibernate image
  efi: Public the function of transferring EFI status to kernel error
  x86/efi: Carrying swsusp key by setup data
  PM / hibernate: Reserve swsusp key and earse footprints
  PM / hibernate: Generate and verify signature of hibernate snapshot
  PM / hibernate: Avoid including swsusp key to hibernate image
  PM / hibernate: Forward signature verifying result and key to image
    kernel
  PM / hibernate: Add configuration to enforce signature verification
  PM / hibernate: Allow user trigger swsusp key re-generating
  PM / hibernate: Bypass verification logic on legacy BIOS
  PM / hibernate: Document signature verification of hibernate snapshot

 Documentation/kernel-parameters.txt             |   5 +
 Documentation/power/swsusp-signature-verify.txt |  86 +++++++
 arch/x86/boot/compressed/Makefile               |   1 +
 arch/x86/boot/compressed/aslr.c                 |  55 +----
 arch/x86/boot/compressed/eboot.c                |  94 ++++++++
 arch/x86/boot/compressed/efi_random.c           | 281 +++++++++++++++++++++++
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
 drivers/firmware/efi/efi-hibernate_keys.c       |  46 ++++
 drivers/firmware/efi/vars.c                     |  33 ---
 include/linux/efi.h                             |  79 +++++++
 include/linux/kernel.h                          |   1 +
 include/linux/suspend.h                         |  26 +++
 include/uapi/linux/suspend_ioctls.h             |   3 +-
 kernel/panic.c                                  |   2 +
 kernel/power/Kconfig                            |  23 ++
 kernel/power/hibernate.c                        |  10 +
 kernel/power/power.h                            |  20 ++
 kernel/power/snapshot.c                         | 293 ++++++++++++++++++++++--
 kernel/power/swap.c                             |   4 +
 kernel/power/user.c                             |  16 ++
 kernel/reboot.c                                 |   3 +
 33 files changed, 1260 insertions(+), 111 deletions(-)
 create mode 100644 Documentation/power/swsusp-signature-verify.txt
 create mode 100644 arch/x86/boot/compressed/efi_random.c
 create mode 100644 arch/x86/power/hibernate_keys.c
 create mode 100644 drivers/firmware/efi/efi-hibernate_keys.c

-- 
1.8.4.5
