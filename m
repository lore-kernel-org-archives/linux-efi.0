Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FCF3859E2
	for <linux-efi@vger.kernel.org>; Tue, 13 Oct 2026 07:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876612; cv=none; b=G6WpGYruRNt4PrmTTy78W6DgUqHqLYEdhIP+x5BlTywYuR5iWetmSSOPxwbiDiKtHbW1R+Jy0CM5W4dOPRRF4nbNFT7wUL89KWALVvvCesir3Pnu2bHOfLdSgeMzXDkzQIWKaCh3rMACPY+GZKGJqm3xOBS+XdfmceudppyYCcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876612; c=relaxed/simple;
	bh=SQVhxLQ/X6XSlUdwzKFBesyNu2Kf7QCW9ql9pcvFLtg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ksZjcMddiA1P6nVc58sWWHU+m2TjgxhwfP5jVblIpgPB4PKy32T64fz7886PoLBpe1eW0gkUANYSNfCMBOd6LPxu19vZGaW7ppsbpt0Z/EdJYa6X1CK40lbhqxkrgkhk6rtN78LXzZt0HXLsXQHEOo0YRY2bYW9vEUfV+dUj2+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZAdfU6wH; arc=none smtp.client-ip=209.85.221.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZAdfU6wH"
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48b00febba3so2130161f8f.1
        for <linux-efi@vger.kernel.org>; Tue, 13 Oct 2026 00:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791876609; x=1792481409; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Jl+U0D/FiXUkrTDEZdBlXfNsgWlEbpM5w7FZsJdpD+I=;
        b=ZAdfU6wHE6lSM+4j6gcheVy2oXbF/XZYvZkwNd/fegvOI4/KcScbq0MtWNIRbGxrnU
         kuQhKjfJW7xWe9w5jXZ7fcURGdjOggphd7jxaJb3VvZ4sWzXK8KnXVSe9s1Uog/wrkMM
         CZHaBU+5wjwjDaUJhQVm4C8xeUpbgxdWxCOGkuj+734qsVTYSrCNtYnLnRAyRcn2m/W5
         YMjPsUvIlfKTFhz4uMUXCpggBEPPXLBB0c5fVvgymLt3/rq4bfa2ClBsWv6mU8kP2r27
         qz44VbQPzHeIFgKbJ1bJNGrQZcIx20h3vG1Gte4uyBcuLXYS/TTRayvJygZTA7Jz1dx+
         kSXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791876609; x=1792481409;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jl+U0D/FiXUkrTDEZdBlXfNsgWlEbpM5w7FZsJdpD+I=;
        b=fl0NgBnEspDME8D2SgRTETeA0SUKs2P8uk/w34Z3McYY9oLbexzBGdGKmSvPN1yd8W
         QZC5ijR+JPs4uNRTyBNzLZEFavFWLYruXAe4cENWO/HZXyopu85COOW0rUzQGYf9dZnE
         p4fMo6FVJptXs1syjeodwUr7lmC6WNxTVmRuOChENZ4dhtR5izKl3DCve94NPV69NISf
         LoYqgiDcUhfytclXADV+TyY8RNbrvPXXJ9HsHTg6pKDiVs+wG1cvGN9wraQFpHUJRkIx
         E2aovC2XqR5fkkV8pjaYLikgLsd5PQbrWCMFQo755ciajyhMwqeBpAVH0vnYj7fXzJHn
         zgfA==
X-Gm-Message-State: AFq9FYLCm8baOC60iHLfWnR8dSmDzgekS/nOUOyAgY91uwwpIUrZWN+/
	sxxbKv/yTuzLh0d/AkbawsFmCABSir32VqP1UMYarPMjsSJxN7TN+t8jWZMbpgVpH2j1GPGir5W
	L1nKSvpIDvzI5bFTAsOP8hSXbnuuSxmFsWjWw+/T4/fwYIcznbwY4TjpQ1m1+I7racJoivA8VDi
	l+vTQh0axoVOjzJwAF3xbymA1ZaNd8kA==
X-Received: from wmxt8-n1.prod.google.com ([2002:a05:600d:8648:10b0:4a1:711a:c8d3])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3f06:b0:49f:ce78:356f
 with SMTP id 5b1f17b1804b1-4a18e4ca2acmr226773285e9.32.1791876609223; Tue, 13
 Oct 2026 00:30:09 -0700 (PDT)
Date: Tue, 13 Oct 2026 09:30:08 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261013073007.1431719-2-ardb+git@google.com>
Subject: [PATCH v2] arm64/mm: Treat faults taken by EFI runtime firmware as
 kernel faults
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, 
	will@kernel.org, catalin.marinas@arm.com, Ard Biesheuvel <ardb@kernel.org>
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
 arch/arm64/mm/fault.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 0b52557652be..87b5fd77d9ca 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -616,9 +616,10 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 
 	/*
 	 * If we're in an interrupt or have no user context, we must not take
-	 * the fault.
+	 * the fault. EFI runtime services may execute with preemption enabled
+	 * and mm == &efi_mm, but faults need to be treated as kernel faults.
 	 */
-	if (faulthandler_disabled() || !mm)
+	if (faulthandler_disabled() || !mm || mm_is_efi(mm))
 		goto no_context;
 
 	if (user_mode(regs))
-- 
2.56.0.385.gd3acb90ef8-goog

