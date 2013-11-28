From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 1/3] Documentation: arm: add UEFI support documentation
Date: Thu, 28 Nov 2013 16:41:21 +0000
Message-ID: <1385656883-4420-2-git-send-email-leif.lindholm@linaro.org>
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385656883-4420-1-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linaro-uefi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

This patch provides documentation of the [U]EFI runtime service and
configuration features for the arm architecture.

Changes since v1/v2:
- Complete rewrite.
- New FDT bindings.

Cc: Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 Documentation/arm/00-INDEX |    3 +++
 Documentation/arm/uefi.txt |   61 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)
 create mode 100644 Documentation/arm/uefi.txt

diff --git a/Documentation/arm/00-INDEX b/Documentation/arm/00-INDEX
index 36420e1..b3af704 100644
--- a/Documentation/arm/00-INDEX
+++ b/Documentation/arm/00-INDEX
@@ -34,3 +34,6 @@ nwfpe/
 	- NWFPE floating point emulator documentation
 swp_emulation
 	- SWP/SWPB emulation handler/logging description
+
+uefi.txt
+	- [U]EFI configuration and runtime services documentation
diff --git a/Documentation/arm/uefi.txt b/Documentation/arm/uefi.txt
new file mode 100644
index 0000000..9ba59509
--- /dev/null
+++ b/Documentation/arm/uefi.txt
@@ -0,0 +1,61 @@
+UEFI, the Unified Extensible Firmware Interface is, a specification
+governing the behaviours of compatible firmware interfaces. It is
+maintained by the UEFI Forum - http://www.uefi.org/.
+
+UEFI is an evolution of its predecessor 'EFI', so the terms EFI and
+UEFI are used somewhat interchangeably in this document and associated
+source code. As a rule, anything new uses 'UEFI', whereas 'EFI' refers
+to legacy code or specifications.
+
+UEFI support in Linux
+=====================
+Booting on a platform with firmware compliant with the UEFI specification
+makes it possible for the kernel to support additional features:
+- UEFI Runtime Services
+- Retrieving various configuration information through the standardised
+  interface of UEFI configuration tables. (ACPI, SMBIOS, ...)
+
+For actually enabling [U]EFI support, enable:
+- CONFIG_EFI=y
+- CONFIG_EFI_VARS=y or m
+
+The implementation depends on receiving information about the UEFI environment
+in a Flattened Device Tree (FDT) - so is only available with CONFIG_OF.
+
+UEFI stub
+=========
+The "stub" is a feature that turns the Image/zImage into a valid UEFI PE/COFF
+executable, including a loader application that makes it possible to load the
+kernel directly from the UEFI shell, boot menu, or one of the lightweight
+bootloaders like Gummiboot or rEFInd.
+
+The kernel image built with stub support remains a valid kernel image for
+booting in non-UEFI environments.
+
+UEFI kernel support on ARM
+==========================
+UEFI kernel support on the ARM architectures (arm and arm64) is only available
+when boot is performed through the stub.
+
+The stub populates the FDT /chosen node with (and the kernel scans for) the
+following parameters:
+________________________________________________________________________________
+Name                      | Size   | Description
+================================================================================
+linux,uefi-system-table   | 64-bit | Physical address of the UEFI System Table.
+--------------------------------------------------------------------------------
+linux,uefi-mmap-start     | 64-bit | Physical address of the UEFI memory map,
+                          |        | populated by the UEFI GetMemoryMap() call.
+--------------------------------------------------------------------------------
+linux,uefi-mmap-size      | 32-bit | Size in bytes of the UEFI memory map
+                          |        | pointed to in previous entry.
+--------------------------------------------------------------------------------
+linux,uefi-mmap-desc-size | 32-bit | Size in bytes of each entry in the UEFI
+                          |        | memory map.
+--------------------------------------------------------------------------------
+linux,uefi-mmap-desc-ver  | 32-bit | Version of the mmap descriptor format.
+--------------------------------------------------------------------------------
+linux,uefi-stub-kern-ver  | string | Copy of linux_banner from build.
+--------------------------------------------------------------------------------
+
+For verbose debug messages, specify 'uefi_debug' on the kernel command line.
-- 
1.7.10.4
