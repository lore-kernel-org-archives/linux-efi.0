Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677263812D1;
	Sun, 11 Oct 2026 11:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791718824; cv=none; b=iqePkyHz1B4e3udsw4ixzCPyLogfEQ7XrpkpR44htGFV4ove5HON8eME8mbaV9USbf8jKXS1iKmDg56eud9fAltTd6OxSiLeSQkVhPGhlAIPa8VcYdveXHIPls5CvCMo3t0EnopMf5mHEImF+Zcz2eiM8aMfzAT7mjlWnvImbz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791718824; c=relaxed/simple;
	bh=T7cK/R/Rz4UY5/gKGUaVwf4Zm5yQeMzS5TFruYzkwOg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EwzYL5PBlZS89w8L5y/hZ7XjHbJfxWQQ9YivilIXsg5YMOoqMirjeVvTI1ufUigyw+4YCdMY+MqH24Iy2MYP8CTla1gDenRa6z6n0chBmlIWwPMIZGHxayf4y2J4CfZUd0VZgMCKBxoHIvI2Fg6H5KI0Jo8cHJnF5V80bZKNNsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xb0FNW1v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xb0FNW1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD901F0089B;
	Sun, 11 Oct 2026 11:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791718823;
	bh=8Gih7pRKwmb9/BEMsnODS6+H1iPxgsF0R+pvFyv4uQY=;
	h=From:To:Cc:Subject:Date;
	b=Xb0FNW1v0lnTXH4XbADnn50y/HzNGRp33B2WGO/qM5x5Nk7Z20RxtYMEZHEBK5YRJ
	 J9IFGKNaHxySTFWl5uKFoG+0Ltb1UKPw8i6pn+xivGMuXzb/vcBk0ZJRL2iyWa0Dnb
	 MM9W/fJpTW6ddJAVoxfM+6s/tOqKMjTV3YOkIM9/8ChVOdC0W359eTEIhdbfDrfazy
	 VJCtPbs4AmjDHACQWXUzPrh+C0jbSSoMz/4qy2/J3aFDC33eE1oa8SIIUQhc1Vmq/R
	 s+jGMj2p9YeQYaIVMe9oDGjczOPip4itVfNf9vHUfOVPda/YmS/za/8mlkB7SpbgHR
	 ki5B+YD5yojUQ==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	kees@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] lkdtm: Add more EFI runtime tests
Date: Sun, 11 Oct 2026 13:40:14 +0200
Message-ID: <20261011114013.1130-2-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5843; i=ardb@kernel.org; h=from:subject; bh=T7cK/R/Rz4UY5/gKGUaVwf4Zm5yQeMzS5TFruYzkwOg=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIet06dxqmR/B5XffVplxmry/1BlRJ1v+zUb5kObUp9aRb 27/fFTTUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACZyrozhD0fyMzVG/fkb7Zm9 gmZcaGMOyXw+6aGh7bOZF0ru/PoasY7hr0iC/oaLz+RPvFjxbZvWlEJNSeX0nvwtvYae4o8SYso TmQA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

Two bugs were found in the arm64 EFI runtime support that weren't caught
by LKDTM. The existing EFI_RUNTIME_CRASH test instructs the firmware to
write to kernel memory that is mapped read-only, which usually fails as
expected. However, this does not exercise the runtime mapping logic in
the kernel, nor the fault recovery logic when the faulting address is
inside the EFI runtime memory regions itself.

So add two more test cases:
- a write to R/O memory test that uses the firmware's own executable
  memory as an output buffer
- a branch to memory that is occupied by the firmware's runtime services
  function table, which is usually mapped non-execute.

This depends on the EFI memory attributes table having been exposed by
the firmware and having been taken into account by the runtime mapping
code, so this is used as a prerequisite by the new tests, otherwise it
produces an XFAIL.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 55 ++++++++++++++++++++
 drivers/misc/lkdtm/bugs.c               | 23 ++++++++
 include/linux/efi.h                     | 10 ++++
 3 files changed, 88 insertions(+)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 33f256dd3d2c..7a43ea5f81b5 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -337,6 +337,29 @@ static void __nocfi efi_call_rts(struct work_struct *work)
 		 * function identifier into efi_rts_work->efi_rts_id
 		 */
 		pr_err("Requested executing invalid EFI Runtime Service.\n");
+		break;
+
+#ifdef CONFIG_LKDTM
+	case EFI_LKDTM_RUNTIME_RO_TEST:
+		/*
+		 * Call GetTime() with the output argument pointing to
+		 * executable memory, which should be mapped read-only in the
+		 * EFI page tables.
+		 */
+		status = arch_efi_call_virt(efi.runtime, get_time,
+					    (void *)efi.runtime->set_time,
+					    NULL);
+		break;
+	case EFI_LKDTM_RUNTIME_NX_TEST:
+		/*
+		 * Call efi.runtime, which points to a data object in a EFI
+		 * runtime region, as if it were a function pointer.
+		 */
+		struct { efi_status_t (__efiapi *fn)(int); } s = { (void *)efi.runtime };
+
+		status = arch_efi_call_virt((&s), fn, 0);
+		break;
+#endif
 	}
 
 	efi_call_virt_check_flags(flags, efi_rts_work.caller);
@@ -624,6 +647,34 @@ static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
 	return status;
 }
 
+#ifdef CONFIG_LKDTM
+static efi_status_t efi_lkdtm_rt_test(enum efi_rts_ids id)
+{
+	efi_status_t status;
+
+	switch (id) {
+	case EFI_LKDTM_RUNTIME_RO_TEST:
+	    if (!efi.get_time ||
+		!efi_rt_services_supported(EFI_RT_SUPPORTED_GET_TIME))
+		    return EFI_UNSUPPORTED;
+	    fallthrough;
+	case EFI_LKDTM_RUNTIME_NX_TEST:
+		if (!efi_enabled(EFI_MEM_ATTR) ||
+		    !efi_enabled(EFI_RUNTIME_SERVICES))
+			return EFI_UNSUPPORTED;
+		break;
+	default:
+		return EFI_UNSUPPORTED;
+	}
+
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_NOT_READY;
+	status = __efi_queue_work(id, NULL);
+	up(&efi_runtime_lock);
+	return status;
+}
+#endif
+
 void __init efi_native_runtime_setup(void)
 {
 	efi.get_time			    = virt_efi_get_time;
@@ -640,6 +691,10 @@ void __init efi_native_runtime_setup(void)
 	efi.query_variable_info_nonblocking = virt_efi_query_variable_info_nb;
 	efi.update_capsule		    = virt_efi_update_capsule;
 	efi.query_capsule_caps		    = virt_efi_query_capsule_caps;
+
+#ifdef CONFIG_LKDTM
+	efi.lkdtm_rt_test		    = efi_lkdtm_rt_test;
+#endif
 }
 
 #ifdef CONFIG_ACPI_PRMT
diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
index 3eca2ef64aff..7bcd88d05505 100644
--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -841,6 +841,27 @@ static void __maybe_unused lkdtm_EFI_RUNTIME_CRASH(void)
 		       status);
 }
 
+static void efi_rt_test(enum efi_rts_ids id, const char *desc)
+{
+	efi_status_t status = efi.lkdtm_rt_test(id);
+
+	if (status == EFI_UNSUPPORTED)
+		pr_err("XFAIL: Test not supported on this configuration\n");
+	else if (status != EFI_ABORTED || efi_enabled(EFI_RUNTIME_SERVICES))
+		pr_err("FAIL: EFI %s memory not caught (%#lx)\n",
+		       desc, status);
+}
+
+static void __maybe_unused lkdtm_EFI_RUNTIME_WRITE_TO_RO(void)
+{
+	efi_rt_test(EFI_LKDTM_RUNTIME_RO_TEST, "write to RO");
+}
+
+static void __maybe_unused lkdtm_EFI_RUNTIME_BRANCH_TO_NX(void)
+{
+	efi_rt_test(EFI_LKDTM_RUNTIME_NX_TEST, "branch to NX");
+}
+
 static struct crashtype crashtypes[] = {
 	CRASHTYPE(PANIC),
 	CRASHTYPE(PANIC_STOP_IRQOFF),
@@ -876,6 +897,8 @@ static struct crashtype crashtypes[] = {
 	CRASHTYPE(CORRUPT_PAC),
 #ifdef CONFIG_EFI
 	CRASHTYPE(EFI_RUNTIME_CRASH),
+	CRASHTYPE(EFI_RUNTIME_WRITE_TO_RO),
+	CRASHTYPE(EFI_RUNTIME_BRANCH_TO_NX),
 #endif
 };
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index fda81d7c4850..dfdb3352ad9d 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -631,6 +631,8 @@ typedef struct {
 
 extern unsigned long __ro_after_init efi_rng_seed;		/* RNG Seed table */
 
+enum efi_rts_ids;
+
 /*
  * All runtime access to EFI goes through this structure:
  */
@@ -666,6 +668,10 @@ extern struct efi {
 	efi_get_next_high_mono_count_t	*get_next_high_mono_count;
 	efi_reset_system_t		*reset_system;
 
+#ifdef CONFIG_LKDTM
+	efi_status_t			(*lkdtm_rt_test)(enum efi_rts_ids id);
+#endif
+
 	struct efi_memory_map		memmap;
 	unsigned long			flags;
 } efi;
@@ -1253,6 +1259,10 @@ enum efi_rts_ids {
 	EFI_UPDATE_CAPSULE,
 	EFI_QUERY_CAPSULE_CAPS,
 	EFI_ACPI_PRM_HANDLER,
+#ifdef CONFIG_LKDTM
+	EFI_LKDTM_RUNTIME_RO_TEST,
+	EFI_LKDTM_RUNTIME_NX_TEST,
+#endif
 };
 
 union efi_rts_args;
-- 
2.56.0.385.gd3acb90ef8-goog

