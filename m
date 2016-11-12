From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 7/9] efi: Allow bitness-agnostic protocol calls
Date: Sat, 12 Nov 2016 21:32:35 +0000
Message-ID: <20161112213237.8804-8-matt@codeblueprint.co.uk>
References: <20161112213237.8804-1-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161112213237.8804-1-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Lukas Wunner <lukas@wunner.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Andreas Noever <andreas.noever@gmail.com>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

We already have a macro to invoke boot services which on x86 adapts
automatically to the bitness of the EFI firmware:  efi_call_early().

The macro allows sharing of functions across arches and bitness variants
as long as those functions only call boot services.  However in practice
functions in the EFI stub contain a mix of boot services calls and
protocol calls.

Add an efi_call_proto() macro for bitness-agnostic protocol calls to
allow sharing more code across arches as well as deduplicating 32 bit
and 64 bit code paths.

On x86, implement it using a new efi_table_attr() macro for bitness-
agnostic table lookups.  Refactor efi_call_early() to make use of the
same macro.  (The resulting object code remains identical.)

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Andreas Noever <andreas.noever@gmail.com>
Cc: Peter Jones <pjones@redhat.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/arm/include/asm/efi.h   |  3 +++
 arch/arm64/include/asm/efi.h |  3 +++
 arch/x86/include/asm/efi.h   | 16 +++++++++++-----
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index 766bf9b78160..0b06f5341b45 100644
--- a/arch/arm/include/asm/efi.h
+++ b/arch/arm/include/asm/efi.h
@@ -57,6 +57,9 @@ void efi_virtmap_unload(void);
 #define __efi_call_early(f, ...)	f(__VA_ARGS__)
 #define efi_is_64bit()			(false)
 
+#define efi_call_proto(protocol, f, instance, ...)			\
+	((protocol##_t *)instance)->f(instance, ##__VA_ARGS__)
+
 struct screen_info *alloc_screen_info(efi_system_table_t *sys_table_arg);
 void free_screen_info(efi_system_table_t *sys_table, struct screen_info *si);
 
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index a9e54aad15ef..771b3f0bc757 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -51,6 +51,9 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 #define __efi_call_early(f, ...)	f(__VA_ARGS__)
 #define efi_is_64bit()			(true)
 
+#define efi_call_proto(protocol, f, instance, ...)			\
+	((protocol##_t *)instance)->f(instance, ##__VA_ARGS__)
+
 #define alloc_screen_info(x...)		&screen_info
 #define free_screen_info(x...)
 
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 389d700b961e..e99675b9c861 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -210,12 +210,18 @@ static inline bool efi_is_64bit(void)
 	return __efi_early()->is64;
 }
 
+#define efi_table_attr(table, attr, instance)				\
+	(efi_is_64bit() ?						\
+		((table##_64_t *)(unsigned long)instance)->attr :	\
+		((table##_32_t *)(unsigned long)instance)->attr)
+
+#define efi_call_proto(protocol, f, instance, ...)			\
+	__efi_early()->call(efi_table_attr(protocol, f, instance),	\
+		instance, ##__VA_ARGS__)
+
 #define efi_call_early(f, ...)						\
-	__efi_early()->call(efi_is_64bit() ?				\
-		((efi_boot_services_64_t *)(unsigned long)		\
-			__efi_early()->boot_services)->f :		\
-		((efi_boot_services_32_t *)(unsigned long)		\
-			__efi_early()->boot_services)->f, __VA_ARGS__)
+	__efi_early()->call(efi_table_attr(efi_boot_services, f,	\
+		__efi_early()->boot_services), __VA_ARGS__)
 
 #define __efi_call_early(f, ...)					\
 	__efi_early()->call((unsigned long)f, __VA_ARGS__);
-- 
2.10.0
