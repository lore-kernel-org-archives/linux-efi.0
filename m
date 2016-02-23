From: David Daney <ddaney.cavm@gmail.com>
Subject: [PATCH v12 5/5] arm64, mm, numa: Add NUMA balancing support for arm64.
Date: Mon, 22 Feb 2016 17:58:23 -0800
Message-ID: <1456192703-2274-6-git-send-email-ddaney.cavm@gmail.com>
References: <1456192703-2274-1-git-send-email-ddaney.cavm@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456192703-2274-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Frank Rowand <frowand.list@gmail.com>, Grant Likely <grant.likely@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, linux-efi@vger.kernel.org, Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>, Robert Richter <rrichter@cavium.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
List-Id: linux-efi@vger.kernel.org

From: Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>

Enable NUMA balancing for arm64 platforms.
Add pte, pmd protnone helpers for use by automatic NUMA balancing.

Reviewed-by: Robert Richter <rrichter@cavium.com>
Signed-off-by: Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>
Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/arm64/Kconfig               |  1 +
 arch/arm64/include/asm/pgtable.h | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9f0972a..6e22503 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -11,6 +11,7 @@ config ARM64
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_SUPPORTS_ATOMIC_RMW
+	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	select ARCH_WANT_FRAME_POINTERS
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index bf464de..5af9db2 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -346,6 +346,21 @@ static inline pgprot_t mk_sect_prot(pgprot_t prot)
 	return __pgprot(pgprot_val(prot) & ~PTE_TABLE_BIT);
 }
 
+#ifdef CONFIG_NUMA_BALANCING
+/*
+ * See the comment in include/asm-generic/pgtable.h
+ */
+static inline int pte_protnone(pte_t pte)
+{
+	return (pte_val(pte) & (PTE_VALID | PTE_PROT_NONE)) == PTE_PROT_NONE;
+}
+
+static inline int pmd_protnone(pmd_t pmd)
+{
+	return pte_protnone(pmd_pte(pmd));
+}
+#endif
+
 /*
  * THP definitions.
  */
-- 
1.8.3.1
