From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/6] arm/efi: Allow invocation of arbitrary runtime services
 [ver #2]
Date: Wed, 23 Nov 2016 00:22:43 +0000
Message-ID: <147986056324.13790.12670822944798392730.stgit@warthog.procyon.org.uk>
References: <147986054870.13790.8640536414645705863.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <147986054870.13790.8640536414645705863.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Provide the ability to perform mixed-mode runtime service calls for arm in
the same way that commit 0a637ee61247bd4bed9b2a07568ef7a1cfc76187
("x86/efi: Allow invocation of arbitrary boot services") provides the
ability to invoke arbitrary boot services.

Suggested-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 arch/arm/include/asm/efi.h   |    1 +
 arch/arm64/include/asm/efi.h |    1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index 0b06f5341b45..e4e6a9d6a825 100644
--- a/arch/arm/include/asm/efi.h
+++ b/arch/arm/include/asm/efi.h
@@ -55,6 +55,7 @@ void efi_virtmap_unload(void);
 
 #define efi_call_early(f, ...)		sys_table_arg->boottime->f(__VA_ARGS__)
 #define __efi_call_early(f, ...)	f(__VA_ARGS__)
+#define efi_call_runtime(f, ...)	sys_table_arg->runtime->f(__VA_ARGS__)
 #define efi_is_64bit()			(false)
 
 #define efi_call_proto(protocol, f, instance, ...)			\
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 771b3f0bc757..d74ae223d89f 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -49,6 +49,7 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 
 #define efi_call_early(f, ...)		sys_table_arg->boottime->f(__VA_ARGS__)
 #define __efi_call_early(f, ...)	f(__VA_ARGS__)
+#define efi_call_runtime(f, ...)	sys_table_arg->runtime->f(__VA_ARGS__)
 #define efi_is_64bit()			(true)
 
 #define efi_call_proto(protocol, f, instance, ...)			\
