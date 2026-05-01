Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCA53612F4
	for <linux-efi@vger.kernel.org>; Fri,  1 May 2026 09:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777626208; cv=none; b=JbdaVrh+aXl4kKhe2+Ef2st62Ga19IvbCd/Z7jjQA4nqM3Io2+sBvMNOdKiNWb2wzmFgVJnYEPyQ5lV1sNWQNmk1murycD1HtXWg2MoMwJrKS1XQ23uFKGrP/vV6zaQfAwOrLoa01qq/VmRW7ANRDoJeWvsjjwD+oY7QBMHASSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777626208; c=relaxed/simple;
	bh=UTxTNlPvMQAxuIQfM8ucjW02c4NzPC0nduST+ic46Tw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=i1SEC4VZzhlJM6SvEKn1jQCv12Xf31W5cQA4LNQKjE9i4XXg7rGPC3HMY6O9lrDP28uU3lEyGf01t+9VIXohQzmeSj190j3Zoa+Ch//jRCn2wdhSj6LEI17v+QuwXVRYeo+wTRv3X4eJaE667Wgpe9h1W0zR8sQ5mKF6XGpWVts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BPRmIehP; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BPRmIehP"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4836abfc742so13630775e9.0
        for <linux-efi@vger.kernel.org>; Fri, 01 May 2026 02:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777626205; x=1778231005; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tio/gNpGkd5IolmHkaATgFk8sZ/Tf3HaTeyPGhlgp0I=;
        b=BPRmIehP63XwoG1TYrJ6ct00ws8zAnohWUDAIHb6c+9guTKUx3O+xoIioLQXXHqBPL
         D+OnDr++ba4eVw34oe4VQjC/kD5OyrePYZRHn46mEsC9IaV18ccJlwzTFzm32MpxtGvd
         RGLRbgqaNa6SRbIYWuTPyMOyeFOa5dXmBrUbwFxIXOPe8UkNPCQdSNKW5EHazSSEiLco
         MTtrcZDY6+m/q649/sdeKwD7002HZVXfe0a5EHVTH44oRwv05aJjs7NpbjgetmYiyvRo
         xgukW1iaakCScpiFyVpH0Cl4y9l+Z9ID9hHnxWddKLW/64AfHtwlUuOTkBPeZbd0Tqna
         hBXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777626205; x=1778231005;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tio/gNpGkd5IolmHkaATgFk8sZ/Tf3HaTeyPGhlgp0I=;
        b=VhjfGM5a7f/QXWKPF8RTxQWtBbtMasmo1r2TM8Bm2gZTbyHBWRRG1KQ6OG5Kkr1BEY
         a1MkXlu/fHouhxwZu14BULWmDkJskq9dDZj6Z1Ji/3s1SWgmQOe5dGUQWcKkogCDSYoc
         XSpIWXAfVxWSuNef0b3bKP6ydXJW7xUnynnQvuP2x6NaMoTbId8BM/ak1P3Hccq1SA1K
         2oHd4pZZ81GIIfQnFjVzAKFPMK2N4acLKRduYsl+lhA0/GUTsM2inGY5fx8CGyvoAmRB
         YDrX8zmBzb7ebSP/XbQRSVlo2EM1NUUkSMo2B2cvuIxYuWk33GIX7FddBO3rYlMRJCnJ
         MMww==
X-Gm-Message-State: AOJu0YxTOmNRqeUr452/hHjRLM6GBaJbs2oOSZnmWfhC1UrgQ3VeV0A2
	k2iBkORitMs3MPzjRZCqycoWbTFz3c+TMNhBI3K0Hq3HE03tYo1R4RhoCw8y81TeqvBQ2U1ha9z
	WKzWkXr3K7YpAVMTfnXm1GCgR1hB8Gi4cxupJ2bqkzEpufC60wZ4RVtQNG8fPCyzodmPfu0lf/3
	pb8sPmfpqNa9JtpcEUwJfxp/GJLHazwA==
X-Received: from wmpd19.prod.google.com ([2002:a05:600c:4c13:b0:48a:5970:2007])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8710:b0:48a:581c:ead
 with SMTP id 5b1f17b1804b1-48a844448f9mr109857905e9.10.1777626205147; Fri, 01
 May 2026 02:03:25 -0700 (PDT)
Date: Fri,  1 May 2026 11:03:12 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=4168; i=ardb@kernel.org;
 h=from:subject; bh=Y7NZlpIwmYsLcYL4hyqTcDON27lg9AznNGlzwjvPhX8=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfNLjr9yxmYZ7T31rgmyvgm/m8NvzNsze+lM8V15XmwPn
 h+s703tKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABO5kcrIsCVTW7HpzqkvK4Iv
 Wm7d+PX7avWHWw7muQT9ncj1fGLNFhtGhqMbJa58Ov3C3e3rvw1ulWd0pqwU8r1iway5wdlnat3 rTYwA
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501090311.2483809-2-ardb+git@google.com>
Subject: [PATCH] x86/efi: Restore IRQ state in EFI page fault handler
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: x86@kernel.org, Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>, 
	Ivan Hu <ivan.hu@canonical.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The kernel's softirq API does not permit re-enabling softirqs while IRQs
are disabled. The reason for this is that local_bh_enable() will not
only re-enable delivery of softirqs over the back of IRQs, it will also
handle any pending softirqs immediately, regardless of whether IRQs are
enabled at that point.

For this reason, commit

  d02198550423 ("x86/fpu: Improve crypto performance by making kernel-mode FPU reliably usable in softirqs")

disables softirqs only when IRQs are enabled, as it is not permitted
otherwise, but also unnecessary, given that asynchronous softirq
delivery never happens to begin with while IRQs are disabled.

However, this does mean that entering a kernel mode FPU section with
IRQs enabled and leaving it with IRQs disabled leads to problems, as
identified by Sashiko [0]: the EFI page fault handler is called from
page_fault_oops() with IRQs disabled, and thus ends the kernel mode FPU
section with IRQs disabled as well, regardless of whether IRQs were
enabled when it was started. This may result in schedule() being called
with a non-zero preempt_count, causing a BUG().

So take care to re-enable IRQs when handling any EFI page faults if they
were taken with IRQs enabled.

[0] https://sashiko.dev/#/patchset/20260430074107.27051-1-ivan.hu%40canonical.com

Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Ivan Hu <ivan.hu@canonical.com>
Fixes: d02198550423 ("x86/fpu: Improve crypto performance by making kernel-mode FPU reliably usable in softirqs")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/include/asm/efi.h     |  3 ++-
 arch/x86/mm/fault.c            |  2 +-
 arch/x86/platform/efi/quirks.c | 11 ++++++++++-
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index dc8fe1361c18..be58b7f5c806 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -137,7 +137,8 @@ extern void __init efi_dump_pagetable(void);
 extern void __init efi_apply_memmap_quirks(void);
 extern int __init efi_reuse_config(u64 tables, int nr_tables);
 extern void efi_delete_dummy_variable(void);
-extern void efi_crash_gracefully_on_page_fault(unsigned long phys_addr);
+extern void efi_crash_gracefully_on_page_fault(unsigned long phys_addr,
+					       const struct pt_regs *regs);
 extern void efi_unmap_boot_services(void);
 
 void arch_efi_call_virt_setup(void);
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index f0e77e084482..63de8e8684f2 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -686,7 +686,7 @@ page_fault_oops(struct pt_regs *regs, unsigned long error_code,
 	 * avoid hanging the system.
 	 */
 	if (IS_ENABLED(CONFIG_EFI))
-		efi_crash_gracefully_on_page_fault(address);
+		efi_crash_gracefully_on_page_fault(address, regs);
 
 	/* Only not-present faults should be handled by KFENCE. */
 	if (!(error_code & X86_PF_PROT) &&
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 7475405119ce..425552e4ec36 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -761,7 +761,8 @@ int efi_capsule_setup_info(struct capsule_info *cap_info, void *kbuff,
  * @return: Returns, if the page fault is not handled. This function
  * will never return if the page fault is handled successfully.
  */
-void efi_crash_gracefully_on_page_fault(unsigned long phys_addr)
+void efi_crash_gracefully_on_page_fault(unsigned long phys_addr,
+					const struct pt_regs *regs)
 {
 	if (!IS_ENABLED(CONFIG_X86_64))
 		return;
@@ -810,6 +811,14 @@ void efi_crash_gracefully_on_page_fault(unsigned long phys_addr)
 		return;
 	}
 
+	/*
+	 * The API does not permit entering a kernel mode FPU section with
+	 * interrupts enabled and leaving it with interrupts disabled.  So
+	 * re-enable interrupts now if they were enabled when the page fault
+	 * occurred.
+	 */
+	local_irq_restore(regs->flags);
+
 	/*
 	 * Before calling EFI Runtime Service, the kernel has switched the
 	 * calling process to efi_mm. Hence, switch back to task_mm.
-- 
2.54.0.545.g6539524ca2-goog

