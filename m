Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387B9391855;
	Fri, 12 Jun 2026 11:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781262146; cv=none; b=FvQGklsaYzBKQIxjlidsLkI/WGIYvphVECTaIJqT5fVBQP7MatYEcMF0iKnwAf9UIGFiTLcNkl3H08EOOGYd6J8uN+SeoiBgToVw+30LvLd2GU5c2r7eb9ZY2SkLU9rXxhYd5cOfj5fTlUo8EikMFHd6UyrWr02wWO+8YLoXJq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781262146; c=relaxed/simple;
	bh=c9UvbmSrpBtM03PhN0G99CHIJTa4nAHxZsz3kcWNGt4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=i2ICV4/d8cg87OXGmU3rASCQ0vUcrJDFU0yHJvrgfxpqvgnHJ/JAj0A5K33Zc0/kmOTQs+Pu2v2N+JZeAwtorbxLd/kRL8M7ZhwTXETERb+Jp2lOwk1PjzlSoKycM6K2fZ4/CbRyEzTz5FdO2/TpQTRcWr0/u8Jy5tsdc3RDhwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=TUX8I7ad; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="TUX8I7ad"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=ANHKuNnrzkf/ed56kk4rON1wlVdNb6ZK0cDJo1oaBcw=; b=TUX8I7ad6s7BNXtXLgNg2hIM71
	AjWZfg1wuRb2m4C/0dh+5gc5kpxFAby764KDpk5Uj0iLC0+gEFMXUYyOnyRJDPHdi3ZALGNdUfiZl
	8Kewd+HV/O/7Be0kkYDiegXmxBU5H+qd1P55ZAd6lOR+gOdjRxBZjcuPlmLPYawl1sfX51hL+ftCV
	TUUiN2ci+kJF5rlHFV7W5t78jTEYqDv90CGrqxiws+Qg0SZWsR+F6Qa79j+IiEqSA9a4X4eh1Yh2+
	VXHDf0/VIiPWShb2YJa0iei/5+KL04skWiRQl2Hv3bYhmnjonv4DPeN3ZIZ5pUTxTov4AF2lSJr0C
	ICgWdLLw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wXzeP-00Aghy-1p;
	Fri, 12 Jun 2026 11:02:13 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 12 Jun 2026 04:01:33 -0700
Subject: [PATCH v2 6/6] efi/runtime-wrappers: retire the worker if a wedged
 call ever returns
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260612-efi_timeout-v2-6-f714bb016df6@debian.org>
References: <20260612-efi_timeout-v2-0-f714bb016df6@debian.org>
In-Reply-To: <20260612-efi_timeout-v2-0-f714bb016df6@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3582; i=leitao@debian.org;
 h=from:subject:message-id; bh=c9UvbmSrpBtM03PhN0G99CHIJTa4nAHxZsz3kcWNGt4=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqK+cTcupHD+TtoWHXecIH+3ssmZ85WbjjMQlFC
 Qs2DCaCHreJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaivnEwAKCRA1o5Of/Hh3
 bVobD/4vVlsR6pi0OXbCu6wHO1CBYQoAxYD7mpuOP4JhrTXu/4Fpuq0kmTKeMOTiQ6DKAAsxv1n
 hKvSoCkRs2TnvX+jGuTktrlvyoCjYlWWiZX/LN6g90GaFbZ0nPRnqvtSkTVdwM9rU6vmSRAgXj0
 qauUjhS/XmiOanW2jqhlc7vcofT74WgAddkQ5nqDzqaxXJRN5BIKTl3YVnX7WOFCnaWmUMumtWW
 5vZaTpNT+JMaP7AHUKDRAG9hdI+cPPHFw6HtGY8EEed6u4emPLQHszwksxOPp4ZGWUdveT/KWH3
 myhM8wiMYFOdHNC6P+Dtvcu8VXnOPaSHo5HT0j+u21qxOqtQCtpm8WGaGeniRjQvDmAlu4QBX1L
 LPOs2I/S50VeNIen3gb1S7gtMgtmEGypVvDTHmScHrJmon3ii2Cf5tSL0zXNltwMf8QsdLfQa0X
 /Rzs8Gar4aGamaTEeCvOl/ACWlxryLbKouGPrhNDCeOe4ooiXqaZ8ZpaBkb+wONKHXO1bWi6CPk
 ibcnWF1dWbZYLcDmx567QaCDdqCPKxERsARIvAkHw01jcz7umcKd95nhqFmVj0UWt9JvE2V3GXA
 nq0E+A398Ch2ku5uV2xX22KyKZwyxUQHtGewwayPhJsyf34TOoPHDz7tQx5nbEsFtsEHrRl/tst
 fDhqytEbWtaBx+w==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

When __efi_queue_work() times out it disables runtime services and
returns, but the kworker is still blocked inside firmware. If the
firmware eventually unblocks, efi_call_rts() would run its tail on an
efi_rts_work that the timed-out caller has long abandoned: signalling a
stale completion and clearing efi_runtime_lock_owner that may by then
belong to another caller.

If runtime services have been disabled by the time the call returns,
park the worker in a schedule() loop instead, so it never touches
efi_rts_work again or returns to the workqueue.

x86's efi_crash_gracefully_on_page_fault() already ends in the same loop
for the page-fault case. Factor it into efi_rts_park_worker() and call it
from both paths.

Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 arch/x86/platform/efi/quirks.c          |  9 +--------
 drivers/firmware/efi/runtime-wrappers.c | 21 +++++++++++++++++++++
 include/linux/efi.h                     |  2 ++
 3 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 90a065fcb1fab..02c56a02eb9bc 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -832,12 +832,5 @@ void efi_crash_gracefully_on_page_fault(unsigned long phys_addr,
 	clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 	pr_info("Froze efi_rts_wq and disabled EFI Runtime Services\n");
 
-	/*
-	 * Call schedule() in an infinite loop, so that any spurious wake ups
-	 * will never run efi_rts_wq again.
-	 */
-	for (;;) {
-		set_current_state(TASK_IDLE);
-		schedule();
-	}
+	efi_rts_park_worker();
 }
diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 842f72d44211f..998e5f8f1c62c 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -219,6 +219,19 @@ static struct task_struct *efi_runtime_lock_owner;
 extern struct semaphore __efi_uv_runtime_lock __alias(efi_runtime_lock);
 #endif
 
+/*
+ * Park a worker that must never run efi_rts_wq again: EFI runtime services
+ * have been disabled and its efi_rts_work is abandoned. Loop in schedule()
+ * so a spurious wakeup cannot resume it.
+ */
+void efi_rts_park_worker(void)
+{
+	for (;;) {
+		set_current_state(TASK_IDLE);
+		schedule();
+	}
+}
+
 /*
  * Calls the appropriate efi_runtime_service() with the appropriate
  * arguments.
@@ -320,6 +333,14 @@ static void __nocfi efi_call_rts(struct work_struct *work)
 	efi_call_virt_check_flags(flags, efi_rts_work.caller);
 	arch_efi_call_virt_teardown();
 
+	/*
+	 * If __efi_queue_work() timed out and disabled runtime services, the
+	 * caller is gone and efi_rts_work is no longer ours: park the worker
+	 * so it never signals the stale completion or runs again.
+	 */
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		efi_rts_park_worker();
+
 	efi_rts_work.status = status;
 	complete(&efi_rts_work.efi_rts_comp);
 	efi_runtime_lock_owner = NULL;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 24221a8424121..015505423277e 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1256,6 +1256,8 @@ extern struct efi_runtime_work efi_rts_work;
 /* Workqueue to queue EFI Runtime Services */
 extern struct workqueue_struct *efi_rts_wq;
 
+void efi_rts_park_worker(void);
+
 struct linux_efi_memreserve {
 	int		size;			// allocated size of the array
 	atomic_t	count;			// number of entries used

-- 
2.53.0-Meta

