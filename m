From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH v4 2/4] efi: Allow bitness-agnostic protocol calls
Date: Mon, 7 Nov 2016 11:09:00 +0100
Message-ID: <b6591dbe76700984afd4c881408aadb7b10587ba.1478506920.git.lukas@wunner.de>
References: <cover.1478506920.git.lukas@wunner.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1478506920.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

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

Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
---
 arch/arm/include/asm/efi.h   |  3 +++
 arch/arm64/include/asm/efi.h |  3 +++
 arch/x86/include/asm/efi.h   | 16 +++++++++++-----
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index 766bf9b..0b06f53 100644
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
index a9e54aa..771b3f0 100644
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
index 389d700..e99675b 100644
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
2.10.1
