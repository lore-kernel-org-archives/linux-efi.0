From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC Part1 PATCH v3 02/17] x86/CPU/AMD: Add the Secure Encrypted Virtualization CPU feature
Date: Mon, 24 Jul 2017 14:07:42 -0500
Message-ID: <20170724190757.11278-3-brijesh.singh@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170724190757.11278-1-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Tony Luck <tony.luck@intel.com>, Piotr Luc <piotr.luc@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, Fenghua Yu <fenghua.yu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Eric Biederman <ebiederm@xmission.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>Paul Mackerras <p>
List-Id: linux-efi@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Update the CPU features to include identifying and reporting on the
Secure Encrypted Virtualization (SEV) feature.  SME is identified by
CPUID 0x8000001f, but requires BIOS support to enable it (set bit 23 of
MSR_K8_SYSCFG and set bit 0 of MSR_K7_HWCR).  Only show the SEV feature
as available if reported by CPUID and enabled by BIOS.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/msr-index.h   |  2 ++
 arch/x86/kernel/cpu/amd.c          | 30 +++++++++++++++++++++++++-----
 arch/x86/kernel/cpu/scattered.c    |  1 +
 4 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 14f0f29..b6ae647 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -197,6 +197,7 @@
 #define X86_FEATURE_HW_PSTATE	( 7*32+ 8) /* AMD HW-PState */
 #define X86_FEATURE_PROC_FEEDBACK ( 7*32+ 9) /* AMD ProcFeedbackInterface */
 #define X86_FEATURE_SME		( 7*32+10) /* AMD Secure Memory Encryption */
+#define X86_FEATURE_SEV		( 7*32+11) /* AMD Secure Encrypted Virtualization */
 
 #define X86_FEATURE_INTEL_PPIN	( 7*32+14) /* Intel Processor Inventory Number */
 #define X86_FEATURE_INTEL_PT	( 7*32+15) /* Intel Processor Trace */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 17f5c12..e399d68 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -378,6 +378,8 @@
 #define MSR_K7_PERFCTR3			0xc0010007
 #define MSR_K7_CLK_CTL			0xc001001b
 #define MSR_K7_HWCR			0xc0010015
+#define MSR_K7_HWCR_SMMLOCK_BIT		0
+#define MSR_K7_HWCR_SMMLOCK		BIT_ULL(MSR_K7_HWCR_SMMLOCK_BIT)
 #define MSR_K7_FID_VID_CTL		0xc0010041
 #define MSR_K7_FID_VID_STATUS		0xc0010042
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 110ca5d..c413f04 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -618,11 +618,16 @@ static void early_init_amd(struct cpuinfo_x86 *c)
 		set_cpu_bug(c, X86_BUG_AMD_E400);
 
 	/*
-	 * BIOS support is required for SME. If BIOS has enabled SME then
-	 * adjust x86_phys_bits by the SME physical address space reduction
-	 * value. If BIOS has not enabled SME then don't advertise the
-	 * feature (set in scattered.c). Also, since the SME support requires
-	 * long mode, don't advertise the feature under CONFIG_X86_32.
+	 * BIOS support is required for SME and SEV.
+	 *   For SME: If BIOS has enabled SME then adjust x86_phys_bits by
+	 *	      the SME physical address space reduction value.
+	 *	      If BIOS has not enabled SME then don't advertise the
+	 *	      SME feature (set in scattered.c).
+	 *   For SEV: If BIOS has not enabled SEV then don't advertise the
+	 *            SEV feature (set in scattered.c).
+	 *
+	 *   In all cases, since support for SME and SEV requires long mode,
+	 *   don't advertise the feature under CONFIG_X86_32.
 	 */
 	if (cpu_has(c, X86_FEATURE_SME)) {
 		u64 msr;
@@ -637,6 +642,21 @@ static void early_init_amd(struct cpuinfo_x86 *c)
 			clear_cpu_cap(c, X86_FEATURE_SME);
 		}
 	}
+
+	if (cpu_has(c, X86_FEATURE_SEV)) {
+		if (IS_ENABLED(CONFIG_X86_32)) {
+			clear_cpu_cap(c, X86_FEATURE_SEV);
+		} else {
+			u64 syscfg, hwcr;
+
+			/* Check if SEV is enabled */
+			rdmsrl(MSR_K8_SYSCFG, syscfg);
+			rdmsrl(MSR_K7_HWCR, hwcr);
+			if (!(syscfg & MSR_K8_SYSCFG_MEM_ENCRYPT) ||
+			    !(hwcr & MSR_K7_HWCR_SMMLOCK))
+				clear_cpu_cap(c, X86_FEATURE_SEV);
+		}
+	}
 }
 
 static void init_amd_k8(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 05459ad..63a78d5 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -32,6 +32,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_CPB,		CPUID_EDX,  9, 0x80000007, 0 },
 	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
 	{ X86_FEATURE_SME,		CPUID_EAX,  0, 0x8000001f, 0 },
+	{ X86_FEATURE_SEV,		CPUID_EAX,  1, 0x8000001f, 0 },
 	{ 0, 0, 0, 0, 0 }
 };
 
-- 
2.9.4
