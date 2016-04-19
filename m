From: Octavian Purdila <octavian.purdila@intel.com>
Subject: [RFC PATCH v2 01/10] kernel: add TAINT_OVERLAY_ACPI_TABLE
Date: Wed, 20 Apr 2016 01:38:59 +0300
Message-ID: <1461105548-20618-2-git-send-email-octavian.purdila@intel.com>
References: <1461105548-20618-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461105548-20618-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>
Cc: Joel Becker <jlbec@evilplan.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, Octavian Purdila <octavian.purdila@intel.com>
List-Id: linux-efi@vger.kernel.org

Add a new tain flag that indicates wheather the user has loaded ACPI
SSDT overlays. This will provide a clean indication in bug reports that
the user has added new information to the ACPI tables.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 Documentation/acpi/ssdt-overlays.txt | 64 ++++++++++++++++++++++++++++++++++++
 Documentation/oops-tracing.txt       |  2 ++
 Documentation/sysctl/kernel.txt      |  1 +
 include/linux/kernel.h               |  1 +
 kernel/panic.c                       |  2 ++
 5 files changed, 70 insertions(+)
 create mode 100644 Documentation/acpi/ssdt-overlays.txt

diff --git a/Documentation/acpi/ssdt-overlays.txt b/Documentation/acpi/ssdt-overlays.txt
new file mode 100644
index 0000000..54ee74a
--- /dev/null
+++ b/Documentation/acpi/ssdt-overlays.txt
@@ -0,0 +1,64 @@
+
+In order to support ACPI open-ended hardware configurations (e.g. development
+boards) we need a way to augment the ACPI configuration provided by the firmware
+image. A common example is connecting sensors on I2C / SPI buses on development
+boards.
+
+Although this can be accomplished by creating a kernel platform driver or
+recompiling the firmware image with updated ACPI tables, neither is practical:
+the former proliferates board specific kernel code while the latter requires
+access to firmware tools which are often not publicly available.
+
+Because ACPI supports external references in AML code a more practical
+way to augment firmware ACPI configuration is by dynamically loading
+user defined SSDT tables that contain the board specific information.
+
+For example, to enumerate a Bosch BMA222E accelerometer on the I2C bus of the
+Minnowboard MAX development board exposed via the LSE connector [1], the
+following ASL code can be used:
+
+DefinitionBlock ("minnowmax.aml", "SSDT", 1, "Vendor", "Accel", 0x00000003)
+{
+    External (\_SB.I2C6, DeviceObj)
+
+    Scope (\_SB.I2C6)
+    {
+        Device (STAC)
+        {
+            Name (_ADR, Zero)
+            Name (_HID, "BMA222E")
+
+            Method (_CRS, 0, Serialized)
+            {
+                Name (RBUF, ResourceTemplate ()
+                {
+                    I2cSerialBus (0x0018, ControllerInitiated, 0x00061A80,
+                                  AddressingMode7Bit, "\\_SB.I2C6", 0x00,
+                                  ResourceConsumer, ,)
+                    GpioInt (Edge, ActiveHigh, Exclusive, PullDown, 0x0000,
+                             "\\_SB.GPO2", 0x00, ResourceConsumer, , )
+                    { // Pin list
+                        0
+                    }
+                })
+                Return (RBUF)
+            }
+        }
+    }
+}
+
+which can then be compiled to AML binary format:
+
+$ iasl minnowmax.asl
+
+Intel ACPI Component Architecture
+ASL Optimizing Compiler version 20140214-64 [Mar 29 2014]
+Copyright (c) 2000 - 2014 Intel Corporation
+
+ASL Input:     minnomax.asl - 30 lines, 614 bytes, 7 keywords
+AML Output:    minnowmax.aml - 165 bytes, 6 named objects, 1 executable opcodes
+
+[1] http://wiki.minnowboard.org/MinnowBoard_MAX#Low_Speed_Expansion_Connector_.28Top.29
+
+The resulting AML code can then be loaded by the kernel using one of the methods
+below.
diff --git a/Documentation/oops-tracing.txt b/Documentation/oops-tracing.txt
index f3ac05c..40e1117 100644
--- a/Documentation/oops-tracing.txt
+++ b/Documentation/oops-tracing.txt
@@ -272,6 +272,8 @@ characters, each representing a particular tainted value.
 
  16: 'K' if the kernel has been live patched.
 
+ 17: 'N' if ACPI SSDT overlays have been loaded.
+
 The primary reason for the 'Tainted: ' string is to tell kernel
 debuggers if this is a clean kernel or if anything unusual has
 occurred.  Tainting is permanent: even if an offending module is
diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 57653a4..e68d4168 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -917,6 +917,7 @@ can be ORed together:
        signature.
 16384 - A soft lockup has previously occurred on the system.
 32768 - The kernel has been live patched.
+65536 - ACPI SSDT overlays have been loaded.
 
 ==============================================================
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2f7775e..8c90125 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -502,6 +502,7 @@ extern enum system_states {
 #define TAINT_UNSIGNED_MODULE		13
 #define TAINT_SOFTLOCKUP		14
 #define TAINT_LIVEPATCH			15
+#define TAINT_OVERLAY_ACPI_TABLE	16
 
 extern const char hex_asc[];
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
diff --git a/kernel/panic.c b/kernel/panic.c
index 535c965..1ff0819 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -284,6 +284,7 @@ static const struct tnt tnts[] = {
 	{ TAINT_UNSIGNED_MODULE,	'E', ' ' },
 	{ TAINT_SOFTLOCKUP,		'L', ' ' },
 	{ TAINT_LIVEPATCH,		'K', ' ' },
+	{ TAINT_OVERLAY_ACPI_TABLE,	'N', ' ' },
 };
 
 /**
@@ -305,6 +306,7 @@ static const struct tnt tnts[] = {
  *  'E' - Unsigned module has been loaded.
  *  'L' - A soft lockup has previously occurred.
  *  'K' - Kernel has been live patched.
+ *  'N' - ACPI SSDT overlays have been loaded.
  *
  *	The string is overwritten by the next call to print_tainted().
  */
-- 
1.9.1
