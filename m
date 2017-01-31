From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/7] arm/efi: Allow invocation of arbitrary runtime services
 [ver #7]
Date: Tue, 31 Jan 2017 15:13:29 +0000
Message-ID: <148587560927.4026.13631713806987809459.stgit@warthog.procyon.org.uk>
References: <148587558696.4026.16034622623568539004.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <148587558696.4026.16034622623568539004.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

efi_call_runtime() is provided for x86 to be able abstract mixed mode
support.  Provide this for ARM also so that common code work in mixed mode
also.

Suggested-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: David Howells <dhowells@redhat.com>
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
index 0b6b1633017f..e7445281e534 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -50,6 +50,7 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 
 #define efi_call_early(f, ...)		sys_table_arg->boottime->f(__VA_ARGS__)
 #define __efi_call_early(f, ...)	f(__VA_ARGS__)
+#define efi_call_runtime(f, ...)	sys_table_arg->runtime->f(__VA_ARGS__)
 #define efi_is_64bit()			(true)
 
 #define efi_call_proto(protocol, f, instance, ...)			\

