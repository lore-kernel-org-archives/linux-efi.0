From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] doc: arm64: add description of EFI stub support
Date: Fri, 29 Nov 2013 17:05:11 -0500
Message-ID: <1385762712-17043-3-git-send-email-msalter@redhat.com>
References: <1385762712-17043-1-git-send-email-msalter@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385762712-17043-1-git-send-email-msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Signed-off-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
CC: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
CC: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
CC: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
CC: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org> 
CC: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
CC: roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
---
 Documentation/arm64/booting.txt |  4 ++++
 Documentation/efi-stub.txt      | 10 ++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/Documentation/arm64/booting.txt b/Documentation/arm64/booting.txt
index a9691cc..aa95d38c 100644
--- a/Documentation/arm64/booting.txt
+++ b/Documentation/arm64/booting.txt
@@ -85,6 +85,10 @@ The decompressed kernel image contains a 64-byte header as follows:
 Header notes:
 
 - code0/code1 are responsible for branching to stext.
+- when booting through EFI, code0/code1 are initially skipped.
+  res5 is an offset to the PE header and the PE header has the EFI
+  entry point (efi_stub_entry). When the stub has done its work, it
+  jumps to code0 to resume the normal boot process.
 
 The image must be placed at the specified offset (currently 0x80000)
 from the start of the system RAM and called there. The start of the
diff --git a/Documentation/efi-stub.txt b/Documentation/efi-stub.txt
index 19e897c..c2a4b11 100644
--- a/Documentation/efi-stub.txt
+++ b/Documentation/efi-stub.txt
@@ -12,6 +12,11 @@ arch/arm/boot/compressed/efi-header.S and
 arch/arm/boot/compressed/efi-stub.c.  EFI stub code that is shared
 between architectures is in drivers/firmware/efi/efi-stub-helper.c.
 
+For arm64, there is no compressed kernel support, so the Image itself
+masquerades as a PE/COFF image and the EFI stub is linked into the
+kernel. The arm64 EFI stub lives in arch/arm64/kernel/efi-entry.S
+and arch/arm64/kernel/efi-stub.c.
+
 By using the EFI boot stub it's possible to boot a Linux kernel
 without the use of a conventional EFI boot loader, such as grub or
 elilo. Since the EFI boot stub performs the jobs of a boot loader, in
@@ -28,7 +33,8 @@ the extension the EFI firmware loader will refuse to execute it. It's
 not possible to execute bzImage.efi from the usual Linux file systems
 because EFI firmware doesn't have support for them.  For ARM the
 arch/arm/boot/zImage should be copied to the system partition, and it
-may not need to be renamed.
+may not need to be renamed. Similarly for arm64, arch/arm64/boot/Image
+should be copied but not necessarily renamed.
 
 
 **** Passing kernel parameters from the EFI shell
@@ -72,7 +78,7 @@ is passed to bzImage.efi.
 
 **** The "dtb=" option
 
-For the ARM architecture, we also need to be able to provide a device
+For ARM and arm64 architecture, we also need to be able to provide a device
 tree to the kernel.  This is done with the "dtb=" command line option,
 and is process in the same manner as the "initrd=" option that is described
 above.
-- 
1.8.3.1
