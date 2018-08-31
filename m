From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 2/4] x86/efi: Get rid of custom ICPU() macro
Date: Fri, 31 Aug 2018 12:10:16 +0300
Message-ID: <20180831091018.17543-2-andriy.shevchenko@linux.intel.com>
References: <20180831091018.17543-1-andriy.shevchenko@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180831091018.17543-1-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: linux-efi@vger.kernel.org

Replace custom grown macro with generic INTEL_CPU_FAM_ANY() one.

No functional change intended.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/x86/include/asm/intel-family.h | 2 ++
 arch/x86/platform/efi/quirks.c      | 6 +-----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 093014aceb65..be28519b2020 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -16,6 +16,8 @@
  * that group keep the CPUID for the variants sorted by model number.
  */
 
+#define INTEL_FAM5_QUARK_X1000		0x09
+
 #define INTEL_FAM6_CORE_YONAH		0x0E
 
 #define INTEL_FAM6_CORE2_MEROM		0x0F
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 844d31cb8a0c..cf8ea09cc52b 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -610,12 +610,8 @@ static int qrk_capsule_setup_info(struct capsule_info *cap_info, void **pkbuff,
 	return 1;
 }
 
-#define ICPU(family, model, quirk_handler) \
-	{ X86_VENDOR_INTEL, family, model, X86_FEATURE_ANY, \
-	  (unsigned long)&quirk_handler }
-
 static const struct x86_cpu_id efi_capsule_quirk_ids[] = {
-	ICPU(5, 9, qrk_capsule_setup_info),	/* Intel Quark X1000 */
+	INTEL_CPU_FAM_ANY(5, INTEL_FAM5_QUARK_X1000, &qrk_capsule_setup_info),
 	{ }
 };
 
-- 
2.18.0
