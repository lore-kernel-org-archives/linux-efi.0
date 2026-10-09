Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7AF3C9893
	for <linux-efi@vger.kernel.org>; Fri,  9 Oct 2026 14:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556490; cv=none; b=h6a/75wOPbPABbDgUmSRAqwaTd6lisCpKSexaT4Y2LOZsHLr+XRQmzPGSpeVK2M4GtFBxobTcKmpOY5Q4JjCIi+LU5T2cxO18RUwMuy8muRSHLVN4ZMe+ZwroiFffU8YC1a+JHKBr2JaZuWIUjtS1aBzB41OUYQeDQ/rQyJoe0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556490; c=relaxed/simple;
	bh=bifech1LEJvHRf/+AS+pGLYXRKKjJSlywFibq7Mt/VA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=heQNK+EuXwUGDhc6BnDDxv1iAVSSu5eJ2wmO5OE/UbV2+JTauxx2LEgU4SP26EmnDwQQ7YHJIAq8yXyGa1isjUATsOm7mVI4T6E5Xc9N6qHqYRZ1N3OQEKxl1JOgHb0Mj8CPgho9py7HawLQdYGXVtHvEnFAqR9z+aujnLNKYRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eyKVfOzE; arc=none smtp.client-ip=209.85.208.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eyKVfOzE"
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6b13fb91795so630036a12.0
        for <linux-efi@vger.kernel.org>; Fri, 09 Oct 2026 07:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791556487; x=1792161287; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mHDReJbU9bHLWD9bwg1RVBJ1LaKr4aLK8gowy4oSBzY=;
        b=eyKVfOzEFZHlDPZzzJ0OmWTlKqt+BmMCTt9RkKFziz5xucIxb1Afp70PCKIInB9wx0
         SdpagOvOH9+CjBhyoYgUeUtG0/75HTR1XJKVPTcFPCWco6Ck/I7+2qeub1KlI+WAtFqx
         I9uitUwuk72wknhm2vra65/RDYw2zH03azboKWz884yPQl5NcaLh5LxiWgcW3KZ+g6mB
         QSGx2jQoE2K4HP1T+1nCVFIoh1Ce3bYvxqUv830o6YgpguELbLJf6KCYIO8eRfE2lPhs
         1VzfOWIqW07V/Z/3z5XiGoNaBC7hFHT5UfU/CbxXVnZaH5y6oN0yNUQ4coOChcFEUg/t
         7F7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791556487; x=1792161287;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mHDReJbU9bHLWD9bwg1RVBJ1LaKr4aLK8gowy4oSBzY=;
        b=Os0ZEw/bVqGfnrFEc+X81UZU1auXlEnrPUlMM7JmqzCzZkzYRFYh+hJP/t8Yq6OiqB
         eEUtE7Ldgb80sz3gEpFL13rpX4ZhW3vRJPe+xx6nrZLyha9P7B3mUaVIk1cg1QDQfseI
         k1wBUzfMDawPWprmwJF7caFz1E6y9R2plju6YClNDJOkYoZXoJJigws6JVvQhCsGJdLd
         Jyg3Ux2g2JZ3ayrnIQhu7Rg4bFc1colDjTkOak2mttpTWRjh+Ah8bvAOrTysQnb2Unko
         CbZ67YvEjj9/S0kFBSXm1Nu407JLcG1eLK8KGaWIPcbVJUgEmhCIXk6awP2c9Hnw/JrS
         slOQ==
X-Gm-Message-State: AFq9FYLezh+T1eHAbZNtZMsSAGeSaFmMhKAm6auj0isQ+gqx+N4bTYaW
	9TJOQ5+5wIPvX80P9WAiFngZ77MirlPqfd+JOBxRLUxLY0L/vBLxztaQG+d4YMdK+xIvWhW6Gg=
	=
X-Received: from edsf8.prod.google.com ([2002:aa7:d848:0:b0:6aa:e0cb:47eb])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:3218:b0:6af:9f9e:c1bf
 with SMTP id 4fb4d7f45d1cf-6b17c257b08mr2023254a12.21.1791556486444; Fri, 09
 Oct 2026 07:34:46 -0700 (PDT)
Date: Fri,  9 Oct 2026 16:34:39 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261009143438.330265-2-ardb+git@google.com>
Subject: [PATCH] arm64/mm: Route faults taken by EFI runtime firmware to no_context
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-efi@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

When EFI runtime services are invoked from a preemptible kthread, the
kthread runs with efi_mm installed via kthread_use_mm() and preemption
enabled, so neither faulthandler_disabled() nor !mm applies in
do_page_fault(). A permission fault taken by the firmware on one of its
own (TTBR0) mappings then hits the 'access to user memory outside
uaccess routines' check and oopses, without efi_runtime_fixup_exception()
ever being consulted.

efi_mm has no VMAs, so there is nothing for the mm to resolve. Send such
faults to no_context directly, so that __do_kernel_fault() can recover
from them as it does when the call is made with preemption disabled.

Fixes: a5baf582f4c0 ("arm64/efi: Call EFI runtime services without disabling preemption")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/fault.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 0b52557652be..db308fe01c4f 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -40,6 +40,7 @@
 #include <asm/kprobes.h>
 #include <asm/mte.h>
 #include <asm/processor.h>
+#include <asm/stacktrace.h>
 #include <asm/sysreg.h>
 #include <asm/system_misc.h>
 #include <asm/tlbflush.h>
@@ -621,6 +622,17 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 	if (faulthandler_disabled() || !mm)
 		goto no_context;
 
+	/*
+	 * Faults taken by EFI runtime services firmware are never resolved by
+	 * the mm (efi_mm has no VMAs), and must reach __do_kernel_fault() so
+	 * that efi_runtime_fixup_exception() can recover from them. When EFI
+	 * runtime services are invoked from a preemptible kthread, neither of
+	 * the conditions above applies, so check for this explicitly.
+	 */
+	if (IS_ENABLED(CONFIG_EFI) && !user_mode(regs) &&
+	    is_ttbr0_addr(regs->pc) && current_in_efi())
+		goto no_context;
+
 	if (user_mode(regs))
 		mm_flags |= FAULT_FLAG_USER;
 
-- 
2.56.0.385.gd3acb90ef8-goog

