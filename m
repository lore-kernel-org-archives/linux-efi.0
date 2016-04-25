From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCHv3 2/5] arm64/efi: enable runtime call flag checking
Date: Mon, 25 Apr 2016 14:46:31 +0100
Message-ID: <1461591994-14918-3-git-send-email-mark.rutland@arm.com>
References: <1461591994-14918-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1461591994-14918-1-git-send-email-mark.rutland@arm.com>
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

Define ARCH_EFI_IRQ_FLAGS_MASK for arm64, which will enable the generic
runtime wrapper code to detect when firmware erroneously modifies flags
over a runtime services function call.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-efi@vger.kernel.org
---
 arch/arm64/include/asm/efi.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index f4f71224..b44603e 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -4,6 +4,7 @@
 #include <asm/io.h>
 #include <asm/mmu_context.h>
 #include <asm/neon.h>
+#include <asm/ptrace.h>
 #include <asm/tlbflush.h>
 
 #ifdef CONFIG_EFI
@@ -33,6 +34,8 @@ int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
 	kernel_neon_end();						\
 })
 
+#define ARCH_EFI_IRQ_FLAGS_MASK (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
+
 /* arch specific definitions used by the stub code */
 
 /*
-- 
1.9.1
