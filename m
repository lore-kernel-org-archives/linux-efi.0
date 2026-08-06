Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B002550D5
	for <linux-efi@vger.kernel.org>; Thu,  6 Aug 2026 00:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785974547; cv=none; b=ae/wkxhhnpkg8aOv9OZZN1Kvg3kLw5j2lyahQqgUB7dNB39W9BXojqZKn+fs4uRkUsadKV9xDGa3K+GRAKQcNQHFmrocB6b1XGsPGe5Fo8saCfnXsONcCizUo4kPIDa8EQQE8ZmiMkZUFWqOYAwJ+7NIn3dV0pvTYY5QUmktWHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785974547; c=relaxed/simple;
	bh=OYt1NcAB8ZvbK7dcVxHMwgHBezL+06d25+6wCfka1TU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UKYOP5bOZ+n4/Z+qElUiyRA8Xa5LSgXTedtfbMvt+dvCQazvrI6FH+li5NRdHlNifBa90fmqmTmKstRU+ECYBoiASKgoiQn+jmWSlnrW0BhkKluNyLz9hMKJJ4TXkOTCrB4EW2q0eukVr50AIFvoeB7Du4rS4b7lLUCZ5x9U3NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bourg.net; spf=pass smtp.mailfrom=bourg.net; dkim=pass (1024-bit key) header.d=bourg.net header.i=@bourg.net header.b=jIS6fk45; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bourg.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bourg.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=bourg.net header.i=@bourg.net header.b="jIS6fk45"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8485ef63b68so2315702b3a.1
        for <linux-efi@vger.kernel.org>; Wed, 05 Aug 2026 17:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bourg.net; s=google; t=1785974537; x=1786579337; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=C+ndS92zXPqAJ+cNcpLuaSmLaftIm1AvtWGzzi2M09w=;
        b=jIS6fk45PsAM7cHCJu2vGwYJwpRiNDbUpIDR3Wzirds2wnGT99f2D6G82oOS3ItSDs
         vTP4Q8/LyUSCd/JyIjt56DFOmhXDUJpr1CP4RZr1jTNKfWH5SG24WZncpaS4Ds4Onvmz
         Fu8k6b5HvVnkzpl3Ypydop1oJ/V/bWWbph3d0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785974537; x=1786579337;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C+ndS92zXPqAJ+cNcpLuaSmLaftIm1AvtWGzzi2M09w=;
        b=O2Pu6X7np4eCvpu0tBBq4bJYIB1SBsp48iiYM/86DKIiCk058pkRbrp5XC2Xjo//YM
         WrP8epjIR6WOxQ8/GyyW+R+zv44e/DAyI2i+QdYYL16DPfJ5KaNFVZpN9T12BxSzPXi9
         8IByh2t+1DOHo9LJBynRFfZ5SZXqe2zUs50Q+3xts1DSfw0HWHotk7JKP2Z5VDXwFMct
         Ol2z6JeDhVX4BwszLsrh06t4sVZ66lHwHdLfMz1qZsxcgfyo4M6qPA2CZ+yQxj63Grol
         91l0DgW8ILJtvVLNVlpYCVTHaO1OPCuJYS2mJJvlPQDp+W+HCtEfbL1V4O9mtXopt1Mn
         Pp1g==
X-Forwarded-Encrypted: i=1; AHgh+RosvjxQxLXnOxHrDbgj3/o1ftvAMtYRgppGE3ntUFEDG32isMB3ljRnVQlohWWumsmNvx6CnfLqZ/c=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywmf6jSqayA30th5+mJgv+8SVKH4Y2kOmZ8WIcTQ+NBAeOyZac0
	meVAPRF3VZjoeF29utowc8cKnqJL39bn+WgyTJT2sn7edH1HjuvPXx5JBAp6eWeUx54=
X-Gm-Gg: AR+sD12y82hx2+HBjf3eMSMa9rIHYYCZuX8/5GBMtfHPs7nLmGB/nnX+k5aNrQJM53y
	91tHuWEQRNcIlnyJMBv9yfqmObnbDVK01Yl3Lzg2L/8cS3q+V35Pksl7cizmeyvMEQquh5r9KY7
	kFmagDgVA8wpj6TTxFHifrAkxNTVEuJbRUBaNt38dmRUVx/EasXTxZGGT2SzyWyyZv+Iqi93Gtv
	nXU3OSBpdcR0yKd/03bCHC1jgrrZrYWWgDYbrd+BcvhYBqqgPTyUQithTUWgjee+BDLkui4XNfS
	elMTcDkhi9xNYenW6Zj0tZdYE9D/9SJWswbOsbHb6CeCuhZaoPCvrpFF+jVT0jN/cyDAZsL9MqR
	1MHGbzdyCZobhWWB8jUsGidzprOsN48I/zPzPYQjc3t8LBzvaEVCKm39PRII1xtryJwx4BPRXhZ
	gspY+d/ryPxcRuGVY1AsbbFyOQAtosoZ/BzfcUm4gmN+KKNgn/gj6OpXpA95cBNK6JgJFzw4L23
	HnX6DKLvWmbHzR2+8pOALTpqejgAZH8U7xRHJtg3lqK9RKX
X-Received: by 2002:a05:6a00:8d81:b0:847:7f3c:b5f5 with SMTP id d2e1a72fcca58-84f2dfc8f83mr13807202b3a.11.1785974537350;
        Wed, 05 Aug 2026 17:02:17 -0700 (PDT)
Received: from deskstar (syn-024-216-245-233.biz.spectrum.com. [24.216.245.233])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f4538bb3bsm180478b3a.12.2026.08.05.17.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 17:02:15 -0700 (PDT)
From: gus bourg <gus@bourg.net>
To: ardb@kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	ilias.apalodimas@linaro.org,
	linux-efi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Gus Bourg <gus@bourg.net>
Subject: [PATCH] arm64/efi: Do not call EFI runtime services preemptibly under SW PAN
Date: Wed,  5 Aug 2026 17:01:44 -0700
Message-ID: <20260806000144.3388823-1-gus@bourg.net>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gus Bourg <gus@bourg.net>

When PAN is emulated by switching TTBR0_EL1, arch_efi_call_virt_setup()
installs the EFI mm into TTBR0_EL1 via uaccess_ttbr0_enable(), and only a
return from exception ever puts it back: check_and_switch_context() skips
the register write by design ("Defer TTBR0_EL1 setting for user threads to
uaccess_enable() when emulating PAN"), and __switch_to() does not touch it
either. switch_mm() updates only thread_info->ttbr0.

Since commit a5baf582f4c0 ("arm64/efi: Call EFI runtime services without
disabling preemption") the runtime call is preemptible, so the EFI worker
can now be scheduled out inside that window. An involuntary preemption is
harmless, because __swpan_entry_el1()/__swpan_exit_el1() save and restore
the state around the exception. A voluntary reschedule is not: it performs
no return from exception, so the worker resumes with another task's
TTBR0_EL1 - or reserved_pg_dir - and the next efi_mm access takes a level 0
translation fault.

There is such a preemption point in arch_efi_call_virt_setup() itself,
immediately after the TTBR0 install: __efi_fpsimd_begin() ->
kernel_neon_begin() -> put_cpu_fpsimd_context() -> local_bh_enable() ->
preempt_check_resched().

On a Khadas VIM3 (Cortex-A73/A53, no FEAT_PAN, so CONFIG_ARM64_SW_TTBR0_PAN
is in use) this reproduces as:

  Unable to handle kernel access to user memory outside uaccess routines
    at virtual address 00000000f322ff30
  Mem abort info:
    ESR = 0x0000000096000004
    FSC = 0x04: level 0 translation fault
  Internal error: Oops: 0000000096000004 [#1]  SMP
  Workqueue: efi_rts_wq efi_call_rts
  pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : efi_call_rts+0xd8/0x288
  Call trace:
   efi_call_rts+0xd8/0x288 (P)
   process_one_work+0x178/0x4f8
   worker_thread+0x194/0x328

The faulting instruction is the kernel's own load of efi.runtime->get_time;
firmware is never entered, so efi_runtime_fixup_exception() declines it
(the PC is kernel text) and the result is a full oops rather than
EFI_ABORTED. The EFI runtime path is then wedged for the rest of the boot:
efi_rts_work.efi_rts_comp is never completed and the runtime lock is never
released, so every subsequent caller blocks in uninterruptible sleep, and
poweroff hangs because EFI_RUNTIME_SERVICES is still set.

The failing window was identified with ftrace, tracing efi_call_rts,
arch_efi_call_virt_setup, kthread_use_mm, __efi_fpsimd_begin,
kernel_neon_begin and arch_efi_call_virt_teardown together with
sched_switch. Of four preemptions observed inside the window over 12726
calls, the two that landed before the TTBR0 install (in kthread_use_mm)
were harmless and the two that landed in kernel_neon_begin were not; one
of those faulted.

Keep configurations that emulate PAN on the non-preemptible path, which is
what they used before a5baf582f4c0. Systems with FEAT_PAN are unaffected:
system_uses_ttbr0_pan() is false there, uaccess_ttbr0_enable() is a no-op,
and check_and_switch_context() installs TTBR0_EL1 on every switch.

Fixes: a5baf582f4c0 ("arm64/efi: Call EFI runtime services without disabling preemption")
Cc: <stable@vger.kernel.org> # v6.19+
Assisted-by: Claude:claude-opus-5 ftrace
Signed-off-by: gus bourg <gus@bourg.net>
---
 arch/arm64/kernel/efi.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 30cd7f804398..1b666ca79758 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -166,11 +166,32 @@ asmlinkage efi_status_t efi_handle_corrupted_x18(efi_status_t s, const char *f)
 	return s;
 }
 
+/*
+ * Whether an EFI runtime service call may run preemptibly.
+ *
+ * When PAN is emulated by switching TTBR0_EL1, the EFI mm is installed into
+ * the register by uaccess_ttbr0_enable() below, and only a return from
+ * exception ever puts it back: check_and_switch_context() deliberately skips
+ * the write ("Defer TTBR0_EL1 setting for user threads to uaccess_enable()
+ * when emulating PAN"), and __switch_to() never touches it. A voluntary
+ * reschedule performs no return from exception, so a preemptible runtime call
+ * can be scheduled back in holding another task's TTBR0_EL1 and take a level 0
+ * translation fault on its next efi_mm access. Keep those configurations on
+ * the non-preemptible path, which is what they used before commit
+ * a5baf582f4c0 ("arm64/efi: Call EFI runtime services without disabling
+ * preemption").
+ */
+static bool efi_runtime_preemptible(void)
+{
+	return !system_uses_ttbr0_pan() && preemptible() &&
+	       (current->flags & PF_KTHREAD);
+}
+
 void arch_efi_call_virt_setup(void)
 {
 	efi_runtime_assert_lock_held();
 
-	if (preemptible() && (current->flags & PF_KTHREAD)) {
+	if (efi_runtime_preemptible()) {
 		/*
 		 * Disable migration to ensure that a preempted EFI runtime
 		 * service call will be resumed on the same CPU. This avoids
@@ -207,7 +228,7 @@ void arch_efi_call_virt_teardown(void)
 	 */
 	uaccess_ttbr0_disable();
 
-	if (preemptible() && (current->flags & PF_KTHREAD)) {
+	if (efi_runtime_preemptible()) {
 		kthread_unuse_mm(&efi_mm);
 		migrate_enable();
 	} else {
-- 
2.53.0

