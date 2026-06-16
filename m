Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6E343CEF7;
	Tue, 16 Jun 2026 12:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781611819; cv=none; b=PyTVwi24byeA3BvO9vPir4Hib4S7FOxiHJwoMgv7lhblsklUisZgxlYeWXnqmANF47GhiFuz4qxiEAgrbEgfWmUExK42NgYBXMplTqs3gaJqztYF+f9a1beDS9PlXupopGYaHTay/XmpKOCOFhjuuNQ1/mwfzRvQAhN6VTIvZHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781611819; c=relaxed/simple;
	bh=gkJVl+G3AR+pdw6hy4mEIZXwzqFOA/7OzAcb7b3DVJw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fzZWfaF+FO4IO9rH3BTp1VrK7HW8sdfqBfaWc3tSFqjcabZi5dtfZKGvgfgqSuw4gaz/OAD1op67FtmxGkkOFBMFqI/Ux0IawXKu22I9VNDt4ikLeSYfZc7kE5QxiAbw9QNxmtgHX0aHf3T6WzrizE/9KczNy7ZhfOU+LLHDtTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=LvRUyvfJ; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="LvRUyvfJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=dp7/NkoLD3uIBMfUaP5vZkvCwtGpOrZTX3PazFCXUQs=; b=LvRUyvfJeqQ1CQSb9XvTjS6VuR
	lWzfhgba+kGR77apbxRy8hpOIEAi3ClZuAgPu51oXiBsD90GdG7qbXVIdtn++YHH5x98vQLREaP19
	B2Zqdsz+rGzwbtYnqpvUXo7KoeRsx5TgvCE3pZOjnIWemgvq0oJN7Zrl9DnBEXiDpuDKqIwuObyBA
	ncmZIm8CZ2hTh6ATPvZOwadItlohs/TqL0YDhXJ8dKEmUSIu8piZkF43zfbXH7h8kotYVmKb9QXQk
	kkPd6/cDIpwsueSOt/GNNA9hyc7ozXgeqNbASMY40d5z5j+MevwB1XeRyw+1pgJxkfumMfAMKvQn2
	wUd2WNGA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wZScP-00Dptg-0f;
	Tue, 16 Jun 2026 12:10:13 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 16 Jun 2026 05:09:38 -0700
Subject: [PATCH v3 5/7] efi/runtime-wrappers: bound the wait for EFI
 runtime service calls
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-efi_timeout-v3-5-76dd1d26657b@debian.org>
References: <20260616-efi_timeout-v3-0-76dd1d26657b@debian.org>
In-Reply-To: <20260616-efi_timeout-v3-0-76dd1d26657b@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, 
 Kees Cook <kees@kernel.org>, Tony Luck <tony.luck@intel.com>, 
 "Guilherme G. Piccoli" <gpiccoli@igalia.com>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3126; i=leitao@debian.org;
 h=from:subject:message-id; bh=gkJVl+G3AR+pdw6hy4mEIZXwzqFOA/7OzAcb7b3DVJw=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqMT0H0QwGydVlYvImQoepQo1YtgdULl5/YmLUX
 AVYqyKLHQCJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCajE9BwAKCRA1o5Of/Hh3
 bUCSD/919r8PwkNGp1ywxVIs1akVh2OqzZ90lTRKTCVWIcZkiZgenExDDo0wufk3OYB75OYQUSJ
 P7RjNyrJsYhWVwhhOt9xNegqZOZv46hvtlqMrg/34PR9DQtrEeWskZ3bgp8vUOJ8YZHV93CNyck
 Z0CCnLUAxiWcIZgj5WXxIbL7gCFV2zLqTg/toYJXAEsFRkfEwD2dYrh9TlHM6WGkMVbUob/JS8a
 KEnguQWdSgw0fsjked+BowprwfwpQGgvhgSJBym5m3bSC/i7VWXC9cMwwLoTyTYe69ZOupdijWp
 sHWibJZd8QCiHZFUtO6U+l+hDOLRDhxmBkBwFmvXeK8O3kEJ1wjbq5schqIJcGyQAZBwft6baBE
 HtxBly5QAxS8z97DrpOOpEPn5Ea4KSg+4QzHGOkUri2g9Jm68U7+YsEXDoiWvGerXv6VZvMVNMn
 9wnfbKLe6ln+N5GBoLMTSAMOlNg0bTqE4uB+gcYQ4iahpqXzOKyAGgYj4SvhZAPtdkz/PF4Bo7k
 526aXr9Abnvgq2964Jyl23Y075bH2407RUA1a1B0MYrZZF6cPUIbmPXXi9iozLU/gonW2OMpZo6
 nH5/lSbZ3MRNND0aF02alxgTfShUIUy1Qm5sDyn14h3jYGRzub52OesbWGJciacS5+saWlv5iUY
 /Tly7F/u05C7Kmw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

When an EFI runtime service hangs in firmware, the efi_rts_wq worker is
stuck inside the call and cannot be cancelled. __efi_queue_work() then
waits on the completion forever while holding efi_runtime_lock, so every
later EFI caller is wedged until reboot; the only symptom is a "workqueue
lockup" and tasks piling up on the semaphore.

Replace wait_for_completion() with wait_for_completion_timeout() bounded
by EFI_RTS_TIMEOUT (120 seconds). On timeout, clear EFI_RUNTIME_SERVICES
and return EFI_ABORTED so later callers fail fast at the entry check
instead of each paying another 120 seconds. The wedged worker is
intentionally leaked and keeps ownership of efi_rts_work.

A worker that only starts running after the timeout would otherwise
dereference efi_rts_work.args, now pointing into the caller's freed stack
frame, and hand stale pointers to firmware. Park it with
efi_rts_park_worker() at the entry of efi_call_rts() when runtime
services are already disabled, before it touches args or enters firmware.

Known limitation: a worker already inside firmware when the timeout fires
still holds efi_rts_args pointing into the caller's stack frame; if
firmware unblocks afterwards and writes the output buffers, they land in
reused memory. Firmware hung this long rarely recovers; a follow-up could
bounce the buffers through kmalloc.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index ae974edc0b04e..2ec5cbdf46d07 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -118,6 +118,14 @@ union efi_rts_args {
 
 struct efi_runtime_work efi_rts_work;
 
+/*
+ * Upper bound on how long we wait for a single EFI runtime service
+ * call to finish before declaring firmware wedged. Chosen to be longer
+ * than any plausible legitimate call (including UpdateCapsule on slow
+ * SPI-NOR) while still bounding userspace wait time.
+ */
+#define EFI_RTS_TIMEOUT		(120 * HZ)
+
 /*
  * efi_queue_work:	Queue EFI runtime service call and wait for completion
  * @_rts:		EFI runtime service function identifier
@@ -234,6 +242,9 @@ static void __nocfi efi_call_rts(struct work_struct *work)
 	efi_status_t status = EFI_NOT_FOUND;
 	unsigned long flags;
 
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		efi_rts_park_worker();
+
 	efi_runtime_lock_owner = current;
 
 	arch_efi_call_virt_setup();
@@ -355,7 +366,13 @@ static efi_status_t __efi_queue_work(enum efi_rts_ids id,
 		goto exit;
 	}
 
-	wait_for_completion(&efi_rts_work.efi_rts_comp);
+	if (!wait_for_completion_timeout(&efi_rts_work.efi_rts_comp,
+					 EFI_RTS_TIMEOUT)) {
+		pr_err("EFI runtime service %d wedged in firmware; disabling EFI runtime services\n",
+		       id);
+		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+		return EFI_ABORTED;
+	}
 
 	WARN_ON_ONCE(efi_rts_work.status == EFI_ABORTED);
 exit:

-- 
2.53.0-Meta

