From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCHv2 2/6] arm64/efi: move to generic {__,}efi_call_virt
Date: Fri, 22 Apr 2016 14:51:19 +0100
Message-ID: <1461333083-15529-3-git-send-email-mark.rutland@arm.com>
References: <1461333083-15529-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1461333083-15529-1-git-send-email-mark.rutland@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-efi@vger.kernel.org
Cc: mark.rutland@arm.com, linux@arm.linux.org.uk, ard.biesheuvel@linaro.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, leif.lindholm@linaro.org, mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

Now there's a common template for {__,}efi_call_virt, remove the
duplicate logic from the arm64 efi code.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm64/include/asm/efi.h | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 8e88a69..f4f71224 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -14,28 +14,21 @@ extern void efi_init(void);
 
 int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
 
-#define efi_call_virt(f, ...)						\
+#define arch_efi_call_virt_setup()					\
 ({									\
-	efi_##f##_t *__f;						\
-	efi_status_t __s;						\
-									\
 	kernel_neon_begin();						\
 	efi_virtmap_load();						\
-	__f = efi.systab->runtime->f;					\
-	__s = __f(__VA_ARGS__);						\
-	efi_virtmap_unload();						\
-	kernel_neon_end();						\
-	__s;								\
 })
 
-#define __efi_call_virt(f, ...)						\
+#define arch_efi_call_virt(f, args...)					\
 ({									\
 	efi_##f##_t *__f;						\
-									\
-	kernel_neon_begin();						\
-	efi_virtmap_load();						\
 	__f = efi.systab->runtime->f;					\
-	__f(__VA_ARGS__);						\
+	__f(args);							\
+})
+
+#define arch_efi_call_virt_teardown()					\
+({									\
 	efi_virtmap_unload();						\
 	kernel_neon_end();						\
 })
-- 
1.9.1
