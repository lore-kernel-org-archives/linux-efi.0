From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH v5 25/32] x86, realmode: Check for memory encryption on the APs
Date: Tue, 18 Apr 2017 16:20:44 -0500
Message-ID: <20170418212044.10190.49261.stgit@tlendack-t1.amdoffice.net>
References: <20170418211612.10190.82788.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170418211612.10190.82788.stgit-qCXWGYdRb2BnqfbPTmsdiZQ+2ll4COg0XqFh9Ls21Oc@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Radim =?utf-8?b?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter
	Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Add support to check if memory encryption is active in the kernel and that
it has been enabled on the AP. If memory encryption is active in the kernel
but has not been enabled on the AP, then set the memory encryption bit (bit
23) of MSR_K8_SYSCFG to enable memory encryption on that AP and allow the
AP to continue start up.

Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
---
 arch/x86/include/asm/realmode.h      |   12 ++++++++++++
 arch/x86/realmode/init.c             |    4 ++++
 arch/x86/realmode/rm/trampoline_64.S |   24 ++++++++++++++++++++++++
 3 files changed, 40 insertions(+)

diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index 230e190..90d9152 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -1,6 +1,15 @@
 #ifndef _ARCH_X86_REALMODE_H
 #define _ARCH_X86_REALMODE_H
 
+/*
+ * Flag bit definitions for use with the flags field of the trampoline header
+ * in the CONFIG_X86_64 variant.
+ */
+#define TH_FLAGS_SME_ACTIVE_BIT		0
+#define TH_FLAGS_SME_ACTIVE		BIT(TH_FLAGS_SME_ACTIVE_BIT)
+
+#ifndef __ASSEMBLY__
+
 #include <linux/types.h>
 #include <asm/io.h>
 
@@ -38,6 +47,7 @@ struct trampoline_header {
 	u64 start;
 	u64 efer;
 	u32 cr4;
+	u32 flags;
 #endif
 };
 
@@ -69,4 +79,6 @@ static inline size_t real_mode_size_needed(void)
 void set_real_mode_mem(phys_addr_t mem, size_t size);
 void reserve_real_mode(void);
 
+#endif /* __ASSEMBLY__ */
+
 #endif /* _ARCH_X86_REALMODE_H */
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 21d7506..5010089 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -102,6 +102,10 @@ static void __init setup_real_mode(void)
 	trampoline_cr4_features = &trampoline_header->cr4;
 	*trampoline_cr4_features = mmu_cr4_features;
 
+	trampoline_header->flags = 0;
+	if (sme_active())
+		trampoline_header->flags |= TH_FLAGS_SME_ACTIVE;
+
 	trampoline_pgd = (u64 *) __va(real_mode_header->trampoline_pgd);
 	trampoline_pgd[0] = trampoline_pgd_entry.pgd;
 	trampoline_pgd[511] = init_level4_pgt[511].pgd;
diff --git a/arch/x86/realmode/rm/trampoline_64.S b/arch/x86/realmode/rm/trampoline_64.S
index dac7b20..614fd70 100644
--- a/arch/x86/realmode/rm/trampoline_64.S
+++ b/arch/x86/realmode/rm/trampoline_64.S
@@ -30,6 +30,7 @@
 #include <asm/msr.h>
 #include <asm/segment.h>
 #include <asm/processor-flags.h>
+#include <asm/realmode.h>
 #include "realmode.h"
 
 	.text
@@ -92,6 +93,28 @@ ENTRY(startup_32)
 	movl	%edx, %fs
 	movl	%edx, %gs
 
+	/*
+	 * Check for memory encryption support. This is a safety net in
+	 * case BIOS hasn't done the necessary step of setting the bit in
+	 * the MSR for this AP. If SME is active and we've gotten this far
+	 * then it is safe for us to set the MSR bit and continue. If we
+	 * don't we'll eventually crash trying to execute encrypted
+	 * instructions.
+	 */
+	bt	$TH_FLAGS_SME_ACTIVE_BIT, pa_tr_flags
+	jnc	.Ldone
+	movl	$MSR_K8_SYSCFG, %ecx
+	rdmsr
+	bts	$MSR_K8_SYSCFG_MEM_ENCRYPT_BIT, %eax
+	jc	.Ldone
+
+	/*
+	 * Memory encryption is enabled but the SME enable bit for this
+	 * CPU has has not been set.  It is safe to set it, so do so.
+	 */
+	wrmsr
+.Ldone:
+
 	movl	pa_tr_cr4, %eax
 	movl	%eax, %cr4		# Enable PAE mode
 
@@ -147,6 +170,7 @@ GLOBAL(trampoline_header)
 	tr_start:		.space	8
 	GLOBAL(tr_efer)		.space	8
 	GLOBAL(tr_cr4)		.space	4
+	GLOBAL(tr_flags)	.space	4
 END(trampoline_header)
 
 #include "trampoline_common.S"
