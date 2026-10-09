Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C733BED42
	for <linux-efi@vger.kernel.org>; Fri,  9 Oct 2026 14:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557303; cv=none; b=lp+aOYai4WMlkhHDFcg1rTB9Tn7h1oLaDo/BhmYcEiX+rr3NfsHrFhBoKj/Tut7hZoXjC7puiphD7Qj6eK73feNSsWYJqS281e1XzwZEwAWBgcom8YW8lwuULx9XT5Z/b6hmkQ+CKRbrl+NZZ/Nk3oTX5PN5sx8cJrKiUAXlVXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557303; c=relaxed/simple;
	bh=hfujBAEmcIhSealf5RC/85UhZDAtYqd4BmsotyawY5o=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=raxIuSSvjqV5igDx50VcPnn4WerBz0YxPVCkUV0evipFJv+9fh3e46VvxwOtvXYM5gQDAezbahulx83Ny6qtlBL9NI5nBZjKA60S8+jLdoabmk/muzpee0YecYi2/niV5F4fFhIAO7TuIIfrfJ+u5rUOMwNo77BK5myVQ/tRtPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cH+hm1Aj; arc=none smtp.client-ip=209.85.208.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cH+hm1Aj"
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6a9caf60126so6734379a12.1
        for <linux-efi@vger.kernel.org>; Fri, 09 Oct 2026 07:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791557300; x=1792162100; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8GQLai1q3g0rRcmv1fTe0FzNYaIAMNXM+p6sj732n0Y=;
        b=cH+hm1Aj8Vx32jbytirSJALer6wSuG/Dfl2JW9AuCk4nLggArRr+F1e38C/XhnHmbp
         3ITjeGUXODC85RSmy40CRidh9JqU247/3jKLOaZFgE4CKV2PpzX5FLUZODyI+Q8UC6SN
         fIQkrXxy8Si8xDlNa25Fg8CEf9vbjwA00kL7HAseSywVqGM/fl1oao1FxkNI7WqX6sj1
         pMGa6JDp6xxOX5n1kvHa1dGtUfSBNnX7w6opQ0POhrb7MsT45pkdbUODYg+9RLGOgQgf
         P8veaRLVE8DxJDF+OIvARYZtv2gWvGCXSiTINMwKgTw7CTSZHd0RC35gOFh/2NbS/zr/
         oDjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791557300; x=1792162100;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8GQLai1q3g0rRcmv1fTe0FzNYaIAMNXM+p6sj732n0Y=;
        b=xO6gwRD9NkZYQbulnuOWgyi9KafhHs7u+kMqChg2n3fei5EweylWByMbKCOOSPmIVp
         NjkHiNB7BS5l49IPM2DMtXPdpX6hN+jHafwt+XEVJwdQj30+9NhnbmSWuAwcTu7xsCvb
         Vu068K+Pdz8h7qoQWotb+aXvZUY3ym0V+bcsIte9cCHoJR0hF7jK1ZOGaQ4Z5oQ86NDX
         ry9L0jMwxpUYbl2xjLYa/cXeWAWZKPM36SdXq10NJQy2sYwFcs3/WXFIbAxlKBlHXemE
         d2o8P6ggiyL0ci/toQovOangapIEeueireh0MPPf51mkGuMejQ1OeumJ7m7OFDrZLJUb
         yrAQ==
X-Gm-Message-State: AFq9FYLU0K+8OP0VDjiQo2gHSDqty9MwTVDmP6GYHXGuCg18Z/wtFYXP
	UB8hsG8CCVJN8gfYj7meRg8cSgmw+B5VhbBb5+cDn2pmzUXjCewQt5oQQzyxw9Jo2UHPRYM+cl5
	jjo/v8AGu3eameBoqr/t8c/bhnbE4+4sSA7wRmHObtEO8dAffNce+Su8kmQxkACbDeaQ+cIlpy3
	ql7G9/XI8gdzXsoZGEPI7uxKGDhleBiQ==
X-Received: from edzd7.prod.google.com ([2002:a05:6402:8c7:b0:6ac:b9d2:4d62])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:210f:b0:6ae:19c2:bae8
 with SMTP id 4fb4d7f45d1cf-6b17c265833mr1923034a12.26.1791557300216; Fri, 09
 Oct 2026 07:48:20 -0700 (PDT)
Date: Fri,  9 Oct 2026 16:48:15 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261009144814.338052-2-ardb+git@google.com>
Subject: [PATCH] efi/runtime-wrappers: Don't park the worker after a recovered
 firmware fault
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Breno Leitao <leitao@debian.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Commit 4b2c033b5bc9 ("efi/runtime-wrappers: retire the worker if a wedged
call ever returns") parks the efi_rts_wq worker instead of completing the
call if EFI runtime services have been disabled by the time the firmware
returns. The assumption is that this only happens if __efi_queue_work()
has given up waiting for the call.

However, arm64 also disables EFI runtime services when it recovers from a
synchronous exception taken by the firmware: efi_runtime_fixup_exception()
clears EFI_RUNTIME_SERVICES and unwinds the call so that it returns
EFI_ABORTED to efi_call_rts(), while the caller is still waiting for the
completion. The worker now parks without signalling it, so the caller is
stuck for the full EFI_RTS_TIMEOUT of 120 seconds, after which it reports
that the firmware is wedged, which is misleading.

x86 is not affected, as it signals the completion from its page fault
handler before parking the worker.

So record explicitly that the caller has given up on the call, and only
park the worker in that case.

Fixes: 4b2c033b5bc9 ("efi/runtime-wrappers: retire the worker if a wedged call ever returns")
Cc: Breno Leitao <leitao@debian.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
I don't remember the details exactly, but I think this is probably my
fault, as I think I suggested using the EFI_RUNTIME_SERVICES flag to
signal that EFI runtime services are now considered broken.


 drivers/firmware/efi/runtime-wrappers.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 740f422df337..33f256dd3d2c 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -126,6 +126,12 @@ struct efi_runtime_work efi_rts_work;
  */
 #define EFI_RTS_TIMEOUT		(120 * HZ)
 
+/*
+ * Set when __efi_queue_work() gives up waiting for a call that is wedged in
+ * firmware. EFI runtime services are disabled for good at that point.
+ */
+static bool efi_rts_abandoned;
+
 /*
  * efi_queue_work:	Queue EFI runtime service call and wait for completion
  * @_rts:		EFI runtime service function identifier
@@ -336,7 +342,12 @@ static void __nocfi efi_call_rts(struct work_struct *work)
 	efi_call_virt_check_flags(flags, efi_rts_work.caller);
 	arch_efi_call_virt_teardown();
 
-	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+	/*
+	 * EFI runtime services may also have been disabled because the
+	 * firmware faulted, but the caller is still waiting for us in that
+	 * case. Only park the worker if the caller has given up on it.
+	 */
+	if (READ_ONCE(efi_rts_abandoned))
 		efi_rts_park_worker();
 
 	efi_rts_work.status = status;
@@ -373,6 +384,7 @@ static efi_status_t __efi_queue_work(enum efi_rts_ids id,
 					 EFI_RTS_TIMEOUT)) {
 		pr_err("EFI runtime service %d wedged in firmware; disabling EFI runtime services\n",
 		       id);
+		WRITE_ONCE(efi_rts_abandoned, true);
 		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 		return EFI_ABORTED;
 	}
-- 
2.56.0.385.gd3acb90ef8-goog

