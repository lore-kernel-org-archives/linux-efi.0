Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A112039E6F5
	for <linux-efi@vger.kernel.org>; Fri,  1 May 2026 17:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777654961; cv=none; b=EmIKZgDuG7WGpdpsAANS+BhLU61bpFY20my/gYKN0/yihe7VMVcJbujABJVICzDQjjr/LrqzhZxrnAdUEPHHJ8e6ZEHehciTWwomw1ctEd4BnVsLN4+AkaUmQ9WrxtHdqXCERQ8dYnfP/pQpndjdXP25G4u2zQpPLvmekgBcIqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777654961; c=relaxed/simple;
	bh=vrXGDOvv+I9VblEZ6ULVsnDeJq4mvLLyUm145L2FSkk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=rymVKoFAFcuzDrEQfKB5ImqL4H+MqXbjM+U97kEYCqlKhkTUw0XAg+rCqx19291nFLINIqBfIy2t+jdyo+F64CZ9OCcmXEmNOcandPJ+Jz+Gh9yKhb95zkgZJoj4zw0RdmbjFpRdCvyV6v0JD8WHBUWEM2z4hhdnFs2z09lUKKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rza+ZpZ9; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rza+ZpZ9"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43d721a4858so1175780f8f.1
        for <linux-efi@vger.kernel.org>; Fri, 01 May 2026 10:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777654956; x=1778259756; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1D3U9MdOuOvhcHjaYZRqsbpng9ecEfkOjlwAVarhjZw=;
        b=rza+ZpZ9TdYZy1eO7+PaIPdFNdTi5MzqkxuYXuC8mL3/cei21Hq9K3y0ll9jHRFE4w
         gZ8tkwA4w6hTetbK3lbQJSPm0kC6awfrlvs+C9ZXN3YPkjBPERmhb4zErVjiiNz0PtN6
         9ESx3EClFxEJkbQ4MlX5gAlZlFGl4asxJ0zA/6izqkPIVYk26+e/0cmSiUfGIwYwMj2b
         ncRbDX+IET5FSUGCnvJ5F64xBulX5aR2JqaMUeUbCdmP21IeqCzFPcxf4Mc+Pg/h3He4
         32pD6Eqj5c3W57+DodQnLPqGaAGtuUa1IOX5fkk/4w22fN/WDc51dyZ3SA1GxRan/tE2
         vTwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777654956; x=1778259756;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1D3U9MdOuOvhcHjaYZRqsbpng9ecEfkOjlwAVarhjZw=;
        b=mgHKl+JnCungcgaKe1AViiQFGaEl66tsDhxc4AYxJY0sTfSPYjv70H0mTe2dZttAD/
         8s/+qgKQyK0WmjQ4Upu9fSChb6fLanCl+3I7aLe/tLRJZGYQMX63613fbXPle87yNLe8
         a0k7K7mviqp9dvAX8veL5j3kVbIHZhnct1aXnrq2ggizgD4evgbNuVGE1BBZfVIgezxq
         Qq2e5EBQEcMM2RJefSbHbfJs+CJfmYJkJcHN99wLKUXFboTNPG65CKMdp3v/YMiwzcZU
         2GAGD5U5AmQpORz5DI4dgknAs3FoDWm4bhL4MODPnsQhpiGygeTFKuPthrFeprM3Eg5y
         iiIA==
X-Gm-Message-State: AOJu0YxBHYpTk289N2Wa4vy3ymGuu59wCP8v1/cqnrzO7QQSMk5ytc3u
	U/1cmKrZvwi4STUddctSjHAXsdAXSr4gdvA3oW8W+jTfvIMo6/Mg6bFY+sT5szCfBF5BJG1OSA=
	=
X-Received: from wmxa17-n2.prod.google.com ([2002:a05:600d:6451:20b0:48a:5d27:4655])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1f1a:b0:48a:54fd:54ea
 with SMTP id 5b1f17b1804b1-48a83f6e505mr123665385e9.12.1777654956469; Fri, 01
 May 2026 10:02:36 -0700 (PDT)
Date: Fri,  1 May 2026 19:01:56 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2030; i=ardb@kernel.org;
 h=from:subject; bh=eW28QWYklRzu7ULCf62Dq9i4UtDPBofwdkliIhgjOGg=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfPLnZbDmwRy+Yq5pijm3JrKn/KqiOvi8ykB/iEOTWY5r
 rmpb2d2lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgIlsyWZkePjnQl/Xib8xQlJr
 Dnxe8FztEcsMQfklHbcSt0lsv/vHM4jhf2bdA4GpUSkXchNKWAo3P/aS7G3fqJ/9tbu1a9WUW4L p/AA=
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501170156.2833364-2-ardb+git@google.com>
Subject: [PATCH] lkdtm: Add case to provoke a crash in EFI runtime services
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, kees@kernel.org, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Add a lkdtm test case that triggers a fault during the execution of a
EFI runtime service by passing a read-only variable as a by-ref argument
that the firmware is supposed to update.

This is useful for testing the graceful handling of faults/exception in
EFI platform firmware, which is implemented on x86 and arm64.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/misc/lkdtm/bugs.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
index e0098f314570..3eca2ef64aff 100644
--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -7,6 +7,7 @@
  */
 #include "lkdtm.h"
 #include <linux/cpu.h>
+#include <linux/efi.h>
 #include <linux/list.h>
 #include <linux/hrtimer.h>
 #include <linux/sched.h>
@@ -817,6 +818,29 @@ static noinline void lkdtm_CORRUPT_PAC(void)
 #endif
 }
 
+static void __maybe_unused lkdtm_EFI_RUNTIME_CRASH(void)
+{
+	static unsigned long size __ro_after_init = sizeof(efi_char16_t);
+	efi_status_t status;
+
+	if (!efi.get_next_variable ||
+	    !efi_enabled(EFI_RUNTIME_SERVICES) ||
+	    !efi_rt_services_supported(EFI_RT_SUPPORTED_GET_NEXT_VARIABLE_NAME)) {
+		pr_err("FAIL: EFI GetNextVariableName() is not available\n");
+		return;
+	}
+
+	/*
+	 * Provoke a fault by asking the firmware to write to a read-only
+	 * variable.
+	 */
+	status = efi.get_next_variable(&size, L"", &(efi_guid_t){});
+
+	if (status != EFI_ABORTED || efi_enabled(EFI_RUNTIME_SERVICES))
+		pr_err("FAIL: EFI GetNextVariable() did not abort (%#lx)\n",
+		       status);
+}
+
 static struct crashtype crashtypes[] = {
 	CRASHTYPE(PANIC),
 	CRASHTYPE(PANIC_STOP_IRQOFF),
@@ -850,6 +874,9 @@ static struct crashtype crashtypes[] = {
 	CRASHTYPE(UNSET_SMEP),
 	CRASHTYPE(DOUBLE_FAULT),
 	CRASHTYPE(CORRUPT_PAC),
+#ifdef CONFIG_EFI
+	CRASHTYPE(EFI_RUNTIME_CRASH),
+#endif
 };
 
 struct crashtype_category bugs_crashtypes = {
-- 
2.54.0.545.g6539524ca2-goog

