Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0A437AA78
	for <linux-efi@vger.kernel.org>; Thu, 15 Oct 2026 15:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792079203; cv=none; b=B4Ue7zp7G2g4MlJ/gjKLGd7+hqSW/e302S64Z4zLK4+Aj1GdWEn1ts7I+cN04wvxfUVb3LDGrKpaPsaU3MAjPPThp9i1xK5izSuYVxcL2wtDj8nxRXu+7DdUiyS1G2lIx1yETz3KBkshYNrXudTfSG1pQuBq3Xv7Hv59brsBk58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792079203; c=relaxed/simple;
	bh=RaSKnpohn/a0FBZWs6DUgO05EqKlyNBnDQSqxF4eZ5M=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=TtdIgvuyMiQAxQQhU8W7jY7AnQ0i5zCso8Gx0Vwcyn029RuVUPxIhXIIy0l7vPxtaBk/i7wZToUPp8JEWE2/2U8ILtxyLyzkV0GZ2DxmDQ6wcS9hLZ7bnrC69BsEeRHYnNsFOEeo8Do6mKCWhYSpzwU7tSLfn57UeIT1C5Q5+ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xoc5yMgi; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xoc5yMgi"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a01ba12198so619905e9.1
        for <linux-efi@vger.kernel.org>; Thu, 15 Oct 2026 08:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792079190; x=1792683990; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lG0Z4SvBAfj9Av6Tnq+22F6zrNXtluUjzfA7kSDSk+A=;
        b=Xoc5yMgif0J5dpXXzKOAiTQmklEqiSpXY/acdm4Q4yu2MJwb4lOBrnR2IptE8tcQEE
         nru7kOX07d1RwPidMziZCzrqb1HEprtGbJhFzpIcet0roPJffzUfkIzpo7fmEYf25xoc
         JbBMhM+pmpqBrVNvp3eVXgAzAB8v04rKnz2Rbb1O/h1T7TlAMbVUphedxO1uX7ELX3je
         /8DjaoMT3TanhyXMIGVJHFY4NYay/bysE5cWZYWBCOy8BogvjnAi61VtQ7fqokk0wFDP
         hJQ/MitW8vV2Md2EK5LtIL3RJy1FiYahfysItUQk216yW1vwoT0tAhylZcBsWOGfxUdV
         zu6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792079190; x=1792683990;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lG0Z4SvBAfj9Av6Tnq+22F6zrNXtluUjzfA7kSDSk+A=;
        b=t3psrSeDCZdqrkRz4QVEhQBj+wzXIlRwHgZXNtDggfVdWDBJ7CJydJfOWE2o9pWDW8
         nEwFBlOE4TzUQ2TkOrAV3lafIUL6oyg64YwRxeLx+lCwvEocDu8uFzW17pXHt3/2cej8
         2/CphfwGvXBm83+F6CvZoV0+lvU6OrfGOE03JBM+a+yayYpRD4p1WKHFiTSaJeDUkO1d
         +Et44gdrch2v/Xb57SUVn+ZBNblZGWFEQvFCS20gDKIPJ3L8lvWplxAihgUaSv/I9fTH
         dG07r0BWh3qhsnGM2Q1HSzbGk0eiXddc2aLqybRXQlFbt2TZYK+xm/l2OWk7+erH9rt2
         0uRQ==
X-Gm-Message-State: AFq9FYJRviKBbfpSawELyGmzNBvzRhpMBN4qA+tlTTSrmsTnW/MavH4S
	CsIbXzNctlPxWnjJJzHAW00SBGr1uCo+aIdOIgts1XuKTHwtCM4Ye2vvUZ9UXOw/LQe2qMW1LBH
	UVeT09eoDQaFbhwX2tPJxQD9ZJjOEVIBo4ZtlmCy7TJBcfxRRYKy8zriJQ2kyd7YqFHghWvn89d
	Q5/MgMlLp/ixXEwizN7a4MuvQW4xD/qA==
X-Received: from wmbjt9.prod.google.com ([2002:a05:600c:5689:b0:4a1:9c49:8b1d])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1f86:b0:4a1:c27d:e1a8
 with SMTP id 5b1f17b1804b1-4a1c6672f2emr8813795e9.10.1792079189972; Thu, 15
 Oct 2026 08:46:29 -0700 (PDT)
Date: Thu, 15 Oct 2026 17:46:27 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261015154626.552282-2-ardb+git@google.com>
Subject: [PATCH v2] lkdtm: Add more EFI runtime tests
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

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

Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
v2: - split XFAIL into four different conditions
    - check that we are using the native EFI runtime services
    - use the address of SetVirtualAddressMap() as the R/O buffer so
      a spurious successful store does not clobber code that we might
      try to run later outside of the lkdtm context
    - use IS_ENABLED(CONFIG_LKDTM) so the modularized build works too

I'll queue this up in efi/next unless anyone spots a problem.

 drivers/firmware/efi/runtime-wrappers.c | 55 ++++++++++++++++++++
 drivers/misc/lkdtm/bugs.c               | 33 ++++++++++++
 include/linux/efi.h                     | 10 ++++
 3 files changed, 98 insertions(+)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 33f256dd3d2c..f663342bcc72 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -337,6 +337,29 @@ static void __nocfi efi_call_rts(struct work_struct *work)
 		 * function identifier into efi_rts_work->efi_rts_id
 		 */
 		pr_err("Requested executing invalid EFI Runtime Service.\n");
+		break;
+
+#if IS_ENABLED(CONFIG_LKDTM)
+	case EFI_LKDTM_RUNTIME_RO_TEST:
+		/*
+		 * Call GetTime() with the output argument pointing to
+		 * executable memory, which should be mapped read-only in the
+		 * EFI page tables.
+		 */
+		status = efi_call_virt(get_time,
+				       (void *)efi.runtime->set_virtual_address_map,
+				       NULL);
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
 
+#if IS_ENABLED(CONFIG_LKDTM)
+static efi_status_t efi_lkdtm_rt_test(enum efi_rts_ids id)
+{
+	efi_status_t status;
+
+	if (!efi_enabled(EFI_RUNTIME_SERVICES) || !efi_enabled(EFI_MEM_ATTR))
+		return EFI_NOT_READY;
+
+	switch (id) {
+	case EFI_LKDTM_RUNTIME_NX_TEST:
+		break;
+	case EFI_LKDTM_RUNTIME_RO_TEST:
+		if (efi.get_time &&
+		    efi_rt_services_supported(EFI_RT_SUPPORTED_GET_TIME))
+			break;
+		fallthrough;
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
+#if IS_ENABLED(CONFIG_LKDTM)
+	efi.lkdtm_rt_test		    = efi_lkdtm_rt_test;
+#endif
 }
 
 #ifdef CONFIG_ACPI_PRMT
diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
index 3eca2ef64aff..8ed368ea3e8b 100644
--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -841,6 +841,37 @@ static void __maybe_unused lkdtm_EFI_RUNTIME_CRASH(void)
 		       status);
 }
 
+static void efi_rt_test(enum efi_rts_ids id, const char *desc)
+{
+	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
+		pr_err("XFAIL: EFI runtime services have been disabled\n");
+		return;
+	} else if (!efi_enabled(EFI_MEM_ATTR)) {
+		pr_err("XFAIL: EFI memory attributes table not provided by firmware\n");
+		return;
+	} else if (!efi.lkdtm_rt_test) {
+		pr_err("XFAIL: Only supported with native EFI runtime services\n");
+		return;
+	}
+
+	efi_status_t status = efi.lkdtm_rt_test(id);
+	if (status == EFI_UNSUPPORTED)
+		pr_err("XFAIL: EFI runtime service not implemented by firmware\n");
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
@@ -876,6 +907,8 @@ static struct crashtype crashtypes[] = {
 	CRASHTYPE(CORRUPT_PAC),
 #ifdef CONFIG_EFI
 	CRASHTYPE(EFI_RUNTIME_CRASH),
+	CRASHTYPE(EFI_RUNTIME_WRITE_TO_RO),
+	CRASHTYPE(EFI_RUNTIME_BRANCH_TO_NX),
 #endif
 };
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index cd8728702e93..cc1df1577d5f 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -631,6 +631,8 @@ typedef struct {
 
 extern unsigned long __ro_after_init efi_rng_seed;		/* RNG Seed table */
 
+enum efi_rts_ids;
+
 /*
  * All runtime access to EFI goes through this structure:
  */
@@ -667,6 +669,10 @@ extern struct efi {
 	efi_get_next_high_mono_count_t	*get_next_high_mono_count;
 	efi_reset_system_t		*reset_system;
 
+#if IS_ENABLED(CONFIG_LKDTM)
+	efi_status_t			(*lkdtm_rt_test)(enum efi_rts_ids id);
+#endif
+
 	struct efi_memory_map		memmap;
 	unsigned long			flags;
 } efi;
@@ -1254,6 +1260,10 @@ enum efi_rts_ids {
 	EFI_UPDATE_CAPSULE,
 	EFI_QUERY_CAPSULE_CAPS,
 	EFI_ACPI_PRM_HANDLER,
+#if IS_ENABLED(CONFIG_LKDTM)
+	EFI_LKDTM_RUNTIME_RO_TEST,
+	EFI_LKDTM_RUNTIME_NX_TEST,
+#endif
 };
 
 union efi_rts_args;
-- 
2.56.0.385.gd3acb90ef8-goog

