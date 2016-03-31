From: Octavian Purdila <octavian.purdila@intel.com>
Subject: [RFC PATCH 01/10] kernel: add TAINT_OVERLAY_ACPI_TABLE
Date: Thu, 31 Mar 2016 12:36:57 +0300
Message-ID: <1459417026-6697-2-git-send-email-octavian.purdila@intel.com>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>
Cc: Joel Becker <jlbec@evilplan.org>, Christoph Hellwig <hch@lst.de>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, Octavian Purdila <octavian.purdila@intel.com>
List-Id: linux-efi@vger.kernel.org

Add a new tain flag that indicates wheather the user has loaded ACPI
SSDT overlays. This will provide a clean indication in bug reports that
the user has added new information to the ACPI tables.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 Documentation/oops-tracing.txt  | 2 ++
 Documentation/sysctl/kernel.txt | 1 +
 include/linux/kernel.h          | 1 +
 kernel/panic.c                  | 2 ++
 4 files changed, 6 insertions(+)

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
index a93b414..547173e 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -895,6 +895,7 @@ can be ORed together:
        signature.
 16384 - A soft lockup has previously occurred on the system.
 32768 - The kernel has been live patched.
+65536 - ACPI SSDT overlays have been loaded.
 
 ==============================================================
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index f31638c..18ff9c7 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -519,6 +519,7 @@ extern enum system_states {
 #define TAINT_UNSIGNED_MODULE		13
 #define TAINT_SOFTLOCKUP		14
 #define TAINT_LIVEPATCH			15
+#define TAINT_OVERLAY_ACPI_TABLE	16
 
 extern const char hex_asc[];
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
diff --git a/kernel/panic.c b/kernel/panic.c
index d96469d..bf4b6d0 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -263,6 +263,7 @@ static const struct tnt tnts[] = {
 	{ TAINT_UNSIGNED_MODULE,	'E', ' ' },
 	{ TAINT_SOFTLOCKUP,		'L', ' ' },
 	{ TAINT_LIVEPATCH,		'K', ' ' },
+	{ TAINT_OVERLAY_ACPI_TABLE,	'N', ' ' },
 };
 
 /**
@@ -284,6 +285,7 @@ static const struct tnt tnts[] = {
  *  'E' - Unsigned module has been loaded.
  *  'L' - A soft lockup has previously occurred.
  *  'K' - Kernel has been live patched.
+ *  'N' - ACPI SSDT overlays have been loaded.
  *
  *	The string is overwritten by the next call to print_tainted().
  */
-- 
1.9.1
