Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF343D75D1
	for <linux-efi@vger.kernel.org>; Thu, 30 Apr 2026 07:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777534884; cv=none; b=E3XVu0HvlcEBi1C7hcNcMPVWpWq90T4V/0DDoTaHZopB6bvgLKszm3vAnCUJ25NE7zBgClIjywNi7wAQ7mtJT3/rOPtwrwU/iZnAMDvfbHkNYcCCqmzmrE8Nbwnzhoaw6odmbKsxYtP7UWSgksPbFgThphaMmrf9ZosapswKHz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777534884; c=relaxed/simple;
	bh=sszepgGox8yNjq+U78WVIYY/O3P/3k6fk57CLmDvdFM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Li2NUFM1NshNTxGxXPWlEmpWq9pyx1TdMWXDvl0PgydhcFAHG9nSb+csWQDk1yudpB9143YtpdsJiPgLUU3e54kvA5o1tYpEk6FA8+nPLLLBAP0c0CBxOCKFeCIP1QgmiODb7afJJgwdN4RSgJxW8OCGHLGnWUQzPmich9nulLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=Jkcvv+45; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="Jkcvv+45"
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id CC81A3FE99
	for <linux-efi@vger.kernel.org>; Thu, 30 Apr 2026 07:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1777534871;
	bh=ODQqFWQ+Nyy1EoDDiIJY4t1vvTxH4z/U+/Jg6s6lDMA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=Jkcvv+45Xi3slANXxH5umNKTmHbMrB1Hl5GvLpKEzRPeFjQXDdaN/yqYBFhs5gRkh
	 xZ59F/F7UVUxgXXsoaDgyesDQXjWaTgaFr44n5gVkLlCildykJbN9E/r+iogLJIwKW
	 viSqZ5w75xI/zOF5X775lCMFlRcrc1lTgRLbDuwmM5EW1AwUTk+Gd04pEz99YqPTZQ
	 KsoR55GXAfGRTtLYTNa45lmqjUeBt7hmui/VdScQTc27EYbBAgP2ajMmOXP/oV9Opu
	 I/NpXhen0JzBepKlI7q+GUpB3QaOZgZfPNyRhhLuSTxhBkUtEpJuJgu2Y14GYLkiK+
	 pb6vkXZ2rksaODxZm4dnrIPJBoCfuW1QZQ9lXf3Ac1X7yMhjGJOTf21Y6m63TfQx3x
	 cbSRP1KTpUsrP7xj5fWzObbCyZ0+LeBwh4uh3P3He0WCpph7DyEDwbzVZ/5X3Zi7c3
	 5PtaXrSeyANhb0fAIJuihEL8d10bIEtChXzPlTG/zeB+RBPg4Ci6bIyMfBtSGa3yhd
	 HDuRgLSg0XmcRuyLRHpAg/0eoxqXS0Kv9fOk77Bil7kojE1qsFgdlI2ugmu1N6ZK5d
	 QDHTJNhk0CQWo38FkSVNTHfstoU2tJOqVdkqogKgfhER4hs533uZSjajxB/hw8VYTn
	 kEJVqyNDUTnWXrQjJCF4IwUA=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2b24cd2e2b3so6189375ad.0
        for <linux-efi@vger.kernel.org>; Thu, 30 Apr 2026 00:41:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777534870; x=1778139670;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ODQqFWQ+Nyy1EoDDiIJY4t1vvTxH4z/U+/Jg6s6lDMA=;
        b=DFzCoY7nWBKAoluTOBdy23VhYfZBbTdhHomZQ3ucOW5e2mOBtpB4eElt/Q5RTuo2x5
         MKoXTX9uyDhwVLEk2Ecb6DbB72UoqV/0QWKYN1VPaJq9APgIUPDPPZQa7Ni5hGm/As4V
         1frnh3e+W0JBQ2Qxla61SR2EUGxh2hhxISBXi9yT4tANN4QXUjGRgU0pKjvFSIo839b6
         Pu0ra14K3OzNOm/HAiptAWNAD5dfIwzHNGsxgUfvz2OQbwrFmk2JeHGusXNmTRP1dDWE
         gGpxlC26foUX47LAp5C/N7a5nVwUdLrJlnzpn8V35rUKsYuSET9Sc5DrqiaTDNKtPlfD
         t4mQ==
X-Forwarded-Encrypted: i=1; AFNElJ/BXkPFit5GlawaWyEyfmC6bUkBJDoj1Oo5LF6FGWNePG/0dJ1HWXhsQzxdj8WpeDlNRpV27BRfBfg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiJCNkflFqC2HyKXu8ZHeR2fMmTMgj2PZ/fe8vKqiaaJCAcewG
	C1RNPVHK+CcS70eTnVZx7QsZYSrz324/zJy7qaq/c9WDuXbQa7LNRiKjYm4Lr2LAKCZTvvHl6r6
	J1C5FErEnxpOs88Th/Q5QvD4vmNIsyZOh+IqDk/A0ME/a38v8OzdFwxUCGez8T4OXTEUfr7KXhI
	C8HA==
X-Gm-Gg: AeBDievhme05cW4gxVkDUhC6WH3c1Ltk0F1bWEebYjHwCAYL7HSrUK0AqYrBD3PZHpw
	SuHgZKtEajrWnXZzjMM3j0UgSigUVH0nBYLLvyAPcgJ5bHgkTPPlS648ut4mIf/loXmPpWeFMfS
	MsCYkYLhegFV+AMbZr8hFg3WETB2ononlTQUJwGgZYAg5WxKgZwS1eHdBafZrT+/P+0LokHct72
	kpiVZILO8XV8/OgLQXlHeETKT0ZLC+cTJ2yBHv0uCOOzbb7o7l3I5+IxkRIMIM+vwdi4ffo1jrO
	0YqJXTKjQMX+kK3So74DdxMenA63tLpZbiN2F/WAMeMsdNNZsddMCuhLhfH+uEhMRh2YnvAfzWv
	7a06Yh8XKIgDqeK5zjt6E1PKOwbfT3v/pajlL40uQ5hHSvrTqVeCz6Rg6B/wfBBLtFgEW13gCdw
	==
X-Received: by 2002:a17:903:908:b0:2b9:59ea:7eba with SMTP id d9443c01a7336-2b9a2341a18mr17569565ad.13.1777534869937;
        Thu, 30 Apr 2026 00:41:09 -0700 (PDT)
X-Received: by 2002:a17:903:908:b0:2b9:59ea:7eba with SMTP id d9443c01a7336-2b9a2341a18mr17569355ad.13.1777534869574;
        Thu, 30 Apr 2026 00:41:09 -0700 (PDT)
Received: from canonical.com (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b98893fbbbsm43706285ad.41.2026.04.30.00.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 00:41:09 -0700 (PDT)
From: Ivan Hu <ivan.hu@canonical.com>
To: ardb@kernel.org,
	ilias.apalodimas@linaro.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	ebiggers@google.com
Cc: x86@kernel.org,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] x86/efi: Fix graceful fault handling after FPU softirq changes
Date: Thu, 30 Apr 2026 15:41:07 +0800
Message-ID: <20260430074107.27051-1-ivan.hu@canonical.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit d02198550423 ("x86/fpu: Improve crypto performance by
making kernel-mode FPU reliably usable in softirqs"), kernel_fpu_begin()
calls fpregs_lock() which uses local_bh_disable() instead of the
previous preempt_disable(). This sets SOFTIRQ_OFFSET in preempt_count
during the entire EFI runtime service call, causing in_interrupt() to
return true in normal task context.

The graceful page fault handler efi_crash_gracefully_on_page_fault()
uses in_interrupt() to bail out for faults in real interrupt context.
With SOFTIRQ_OFFSET now set, the handler always bails out, leaving EFI
firmware page faults unhandled. This escalates to die() which also sees
in_interrupt() as true and calls panic("Fatal exception in interrupt"),
resulting in a hard system freeze. On systems with buggy firmware that
triggers page faults during EFI runtime calls (e.g., accessing unmapped
memory in GetTime()), this causes an unrecoverable hang instead of the
expected graceful EFI_ABORTED recovery.

Fix by replacing in_interrupt() with in_hardirq() || in_nmi(). This
preserves the original intent of bailing for genuine hardware interrupt
or NMI faults, while no longer falsely triggering from the FPU code
path's local_bh_disable(). This is safe because softirqs cannot run
during EFI calls (they are explicitly blocked by fpregs_lock()), so
they can never be the source of a page fault in this context.

Fixes: d02198550423 ("x86/fpu: Improve crypto performance by making kernel-mode FPU reliably usable in softirqs")
Signed-off-by: Ivan Hu <ivan.hu@canonical.com>
---
 arch/x86/platform/efi/quirks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index df24ffc6105d..7475405119ce 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -767,10 +767,10 @@ void efi_crash_gracefully_on_page_fault(unsigned long phys_addr)
 		return;
 
 	/*
-	 * If we get an interrupt/NMI while processing an EFI runtime service
+	 * If we get a hard IRQ or NMI while processing an EFI runtime service
 	 * then this is a regular OOPS, not an EFI failure.
 	 */
-	if (in_interrupt())
+	if (in_hardirq() || in_nmi())
 		return;
 
 	/*
-- 
2.43.0

