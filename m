From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/4] x86/cpu: Introduce INTEL_CPU_FAM*_NODATA() helper macros
Date: Fri, 31 Aug 2018 12:10:15 +0300
Message-ID: <20180831091018.17543-1-andriy.shevchenko@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: linux-efi@vger.kernel.org

These macros are often used by drivers and we have already a lot of
duplication as ICPU() macro across the drivers.

Provide a generic x86 macro for users.

This adds no driver data variants.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/x86/include/asm/intel-family.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 7ed08a7c3398..093014aceb65 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -83,10 +83,16 @@
 	.family		= _family,				\
 	.model		= _model,				\
 	.feature	= X86_FEATURE_ANY,			\
-	.driver_data	= (kernel_ulong_t)&_driver_data		\
+	.driver_data	= (kernel_ulong_t)_driver_data		\
 }
 
 #define INTEL_CPU_FAM6(_model, _driver_data)			\
-	INTEL_CPU_FAM_ANY(6, INTEL_FAM6_##_model, _driver_data)
+	INTEL_CPU_FAM_ANY(6, INTEL_FAM6_##_model, &_driver_data)
+
+#define INTEL_CPU_FAM_ANY_NODATA(_family, _model)		\
+	INTEL_CPU_FAM_ANY(_family, _model, NULL)
+
+#define INTEL_CPU_FAM6_NODATA(_model)				\
+	INTEL_CPU_FAM_ANY_NODATA(6, INTEL_FAM6_##_model)
 
 #endif /* _ASM_X86_INTEL_FAMILY_H */
-- 
2.18.0
