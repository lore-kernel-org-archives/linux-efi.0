From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: [PATCH 2/3] arm64: Prepare SCTLR_ELn accesses to handle Falkor
 erratum 1041
Date: Thu,  2 Nov 2017 22:27:43 -0500
Message-ID: <1509679664-3749-3-git-send-email-shankerd@codeaurora.org>
References: <1509679664-3749-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1509679664-3749-1-git-send-email-shankerd@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: linux-efi@vger.kernel.org

This patch introduces two helper macros read_sctlr and write_sctlr
to access system register SCTLR_ELn. Replace all MSR/MRS references
to sctlr_el1{el2} with macros.

This should cause no behavioral change.

Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
---
 arch/arm64/include/asm/assembler.h  | 18 ++++++++++++++++++
 arch/arm64/kernel/cpu-reset.S       |  4 ++--
 arch/arm64/kernel/efi-entry.S       |  8 ++++----
 arch/arm64/kernel/head.S            | 18 +++++++++---------
 arch/arm64/kernel/relocate_kernel.S |  4 ++--
 arch/arm64/kvm/hyp-init.S           |  6 +++---
 arch/arm64/mm/proc.S                |  6 +++---
 7 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index d58a625..b6dfb4f 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -499,4 +499,22 @@
 #endif
 	.endm
 
+/**
+ * Read value of the system control register SCTLR_ELn.
+ *   eln: which system control register.
+ *   reg: contents of the SCTLR_ELn.
+ */
+	.macro	read_sctlr, eln, reg
+	mrs	\reg, sctlr_\eln
+	.endm
+
+/**
+ * Write the value to the system control register SCTLR_ELn.
+ *   eln: which system control register.
+ *   reg: the value to be written.
+ */
+	.macro	write_sctlr, eln, reg
+	msr	sctlr_\eln, \reg
+	.endm
+
 #endif	/* __ASM_ASSEMBLER_H */
diff --git a/arch/arm64/kernel/cpu-reset.S b/arch/arm64/kernel/cpu-reset.S
index 65f42d2..9224abd 100644
--- a/arch/arm64/kernel/cpu-reset.S
+++ b/arch/arm64/kernel/cpu-reset.S
@@ -34,10 +34,10 @@
  */
 ENTRY(__cpu_soft_restart)
 	/* Clear sctlr_el1 flags. */
-	mrs	x12, sctlr_el1
+	read_sctlr el1, x12
 	ldr	x13, =SCTLR_ELx_FLAGS
 	bic	x12, x12, x13
-	msr	sctlr_el1, x12
+	write_sctlr el1, x12
 	isb
 
 	cbz	x0, 1f				// el2_switch?
diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
index 4e6ad35..acae627 100644
--- a/arch/arm64/kernel/efi-entry.S
+++ b/arch/arm64/kernel/efi-entry.S
@@ -93,17 +93,17 @@ ENTRY(entry)
 	mrs	x0, CurrentEL
 	cmp	x0, #CurrentEL_EL2
 	b.ne	1f
-	mrs	x0, sctlr_el2
+	read_sctlr el2, x0
 	bic	x0, x0, #1 << 0	// clear SCTLR.M
 	bic	x0, x0, #1 << 2	// clear SCTLR.C
-	msr	sctlr_el2, x0
+	write_sctlr el2, x0
 	isb
 	b	2f
 1:
-	mrs	x0, sctlr_el1
+	read_sctlr el1, x0
 	bic	x0, x0, #1 << 0	// clear SCTLR.M
 	bic	x0, x0, #1 << 2	// clear SCTLR.C
-	msr	sctlr_el1, x0
+	write_sctlr el1, x0
 	isb
 2:
 	/* Jump to kernel entry point */
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 0b243ec..b8d5b73 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -388,18 +388,18 @@ ENTRY(el2_setup)
 	mrs	x0, CurrentEL
 	cmp	x0, #CurrentEL_EL2
 	b.eq	1f
-	mrs	x0, sctlr_el1
+	read_sctlr el1, x0
 CPU_BE(	orr	x0, x0, #(3 << 24)	)	// Set the EE and E0E bits for EL1
 CPU_LE(	bic	x0, x0, #(3 << 24)	)	// Clear the EE and E0E bits for EL1
-	msr	sctlr_el1, x0
+	write_sctlr el1, x0
 	mov	w0, #BOOT_CPU_MODE_EL1		// This cpu booted in EL1
 	isb
 	ret
 
-1:	mrs	x0, sctlr_el2
+1:	read_sctlr el2, x0
 CPU_BE(	orr	x0, x0, #(1 << 25)	)	// Set the EE bit for EL2
 CPU_LE(	bic	x0, x0, #(1 << 25)	)	// Clear the EE bit for EL2
-	msr	sctlr_el2, x0
+	write_sctlr el2, x0
 
 #ifdef CONFIG_ARM64_VHE
 	/*
@@ -511,7 +511,7 @@ install_el2_stub:
 	mov	x0, #0x0800			// Set/clear RES{1,0} bits
 CPU_BE(	movk	x0, #0x33d0, lsl #16	)	// Set EE and E0E on BE systems
 CPU_LE(	movk	x0, #0x30d0, lsl #16	)	// Clear EE and E0E on LE systems
-	msr	sctlr_el1, x0
+	write_sctlr el1, x0
 
 	/* Coprocessor traps. */
 	mov	x0, #0x33ff
@@ -664,7 +664,7 @@ ENTRY(__enable_mmu)
 	msr	ttbr0_el1, x1			// load TTBR0
 	msr	ttbr1_el1, x2			// load TTBR1
 	isb
-	msr	sctlr_el1, x0
+	write_sctlr el1, x0
 	isb
 	/*
 	 * Invalidate the local I-cache so that any instructions fetched
@@ -716,7 +716,7 @@ ENDPROC(__relocate_kernel)
 __primary_switch:
 #ifdef CONFIG_RANDOMIZE_BASE
 	mov	x19, x0				// preserve new SCTLR_EL1 value
-	mrs	x20, sctlr_el1			// preserve old SCTLR_EL1 value
+	read_sctlr el1, x20			// preserve old SCTLR_EL1 value
 #endif
 
 	bl	__enable_mmu
@@ -732,14 +732,14 @@ __primary_switch:
 	 * to take into account by discarding the current kernel mapping and
 	 * creating a new one.
 	 */
-	msr	sctlr_el1, x20			// disable the MMU
+	write_sctlr el1, x20			// disable the MMU
 	isb
 	bl	__create_page_tables		// recreate kernel mapping
 
 	tlbi	vmalle1				// Remove any stale TLB entries
 	dsb	nsh
 
-	msr	sctlr_el1, x19			// re-enable the MMU
+	write_sctlr el1, x19			// re-enable the MMU
 	isb
 	ic	iallu				// flush instructions fetched
 	dsb	nsh				// via old mapping
diff --git a/arch/arm64/kernel/relocate_kernel.S b/arch/arm64/kernel/relocate_kernel.S
index ce704a4..4381c92 100644
--- a/arch/arm64/kernel/relocate_kernel.S
+++ b/arch/arm64/kernel/relocate_kernel.S
@@ -42,10 +42,10 @@ ENTRY(arm64_relocate_new_kernel)
 	mrs	x0, CurrentEL
 	cmp	x0, #CurrentEL_EL2
 	b.ne	1f
-	mrs	x0, sctlr_el2
+	read_sctlr el2, x0
 	ldr	x1, =SCTLR_ELx_FLAGS
 	bic	x0, x0, x1
-	msr	sctlr_el2, x0
+	write_sctlr el2, x0
 	isb
 1:
 
diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 3f96155..22996a3 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -113,7 +113,7 @@ __do_hyp_init:
 	 */
 	ldr	x4, =(SCTLR_EL2_RES1 | (SCTLR_ELx_FLAGS & ~SCTLR_ELx_A))
 CPU_BE(	orr	x4, x4, #SCTLR_ELx_EE)
-	msr	sctlr_el2, x4
+	write_sctlr el2, x4
 	isb
 
 	/* Set the stack and new vectors */
@@ -148,10 +148,10 @@ reset:
 	 * Reset kvm back to the hyp stub. Do not clobber x0-x4 in
 	 * case we coming via HVC_SOFT_RESTART.
 	 */
-	mrs	x5, sctlr_el2
+	read_sctlr el2, x5
 	ldr	x6, =SCTLR_ELx_FLAGS
 	bic	x5, x5, x6		// Clear SCTL_M and etc
-	msr	sctlr_el2, x5
+	write_sctlr el2, x5
 	isb
 
 	/* Install stub vectors */
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 877d42f..958c3a1 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -69,7 +69,7 @@ ENTRY(cpu_do_suspend)
 	mrs	x7, vbar_el1
 	mrs	x8, mdscr_el1
 	mrs	x9, oslsr_el1
-	mrs	x10, sctlr_el1
+	read_sctlr el1, x10
 	mrs	x11, tpidr_el1
 	mrs	x12, sp_el0
 	stp	x2, x3, [x0]
@@ -115,7 +115,7 @@ ENTRY(cpu_do_resume)
 	disable_dbg
 	msr	mdscr_el1, x10
 
-	msr	sctlr_el1, x12
+	write_sctlr el1, x12
 	msr	tpidr_el1, x13
 	msr	sp_el0, x14
 	/*
@@ -217,7 +217,7 @@ ENTRY(__cpu_setup)
 	 */
 	adr	x5, crval
 	ldp	w5, w6, [x5]
-	mrs	x0, sctlr_el1
+	read_sctlr el1, x0
 	bic	x0, x0, x5			// clear bits
 	orr	x0, x0, x6			// set bits
 	/*
-- 
Qualcomm Datacenter Technologies, Inc. on behalf of the Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
