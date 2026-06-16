Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A673B9D97;
	Tue, 16 Jun 2026 12:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781611805; cv=none; b=SO0tlv11eoj9+TuKcNIo3MY2bugPcMvJDlCcwEAhSbFLITkBqwPJ9KChqGhJ97qm3IT1ybSxaOGvWQ7kVgnl7g5CiiNzs1lb2BCx5xhqLmjU2+AETYrd1xqDP7Klaf0Tri+fhzzqsgQNEtRCRAy4rbDakknzSa7J9L4B1HLNHuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781611805; c=relaxed/simple;
	bh=SLD34W7CoRVSbmBMu5pS1HEpqVJ+uepGd1TaRxKO69A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GjDy0DAj0mi9rZ5Fl2KrDks1AKmPwY+C8b1uSgpZFCWqa0/cD2jvq0BYDcCobYiOn9m0ubCGyi4gZya+DXK3fDRy8VV2fuE5ZU5g3Yuauxlrr3GOfZ5yLkWCMbDgHx768WErGXXhSQMhZLkAkx9W6c8F0Otf+XpmCVIfhKPUCuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=jNIkJrrY; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="jNIkJrrY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=KLW0qbtpyW93HnHXZfuX/a6moNQod643wcBgtDkzCsM=; b=jNIkJrrYglpiftQzu0XSMsyqXx
	miYu12x/vWUt3aP3LHM20BiWcqFbCmgQK/7mhC+A/WfBjxtMTpysdMqPyZ31jdx5/uLKPFcONB8cl
	GtgFCud/S3TyUeXvSMfZhB5mCfh5S9XxHoCcx5pZPMG4X4dsSgz8zwMkUVLQ9fCA2t/pHCnr7OeQB
	jHeUmKo8MPTtgm260o/geSsHL4wtk9bSVkDL313BRytNJliMyOwkMe33MTywteyCqgy/ggiwRk4bi
	GcIva8eZP84a+G1MJxPHNLlNcY0lY6IBzYW2i0cR4vh6Z/Y0klcNWsFilyH33pgOmjLHb2zNeosYS
	ZbObbaJA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wZScA-00Dpsh-0v;
	Tue, 16 Jun 2026 12:09:58 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 16 Jun 2026 05:09:35 -0700
Subject: [PATCH v3 2/7] efi/runtime-wrappers: factor out
 efi_rts_park_worker()
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-efi_timeout-v3-2-76dd1d26657b@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2597; i=leitao@debian.org;
 h=from:subject:message-id; bh=SLD34W7CoRVSbmBMu5pS1HEpqVJ+uepGd1TaRxKO69A=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqMT0GbHepGv3ZK/GXKqsUm1810IZz14PyKVx6T
 W03MIXvFOGJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCajE9BgAKCRA1o5Of/Hh3
 bQ/WD/40XCPiM5oE5Ap2ZUPaBTMDhWLPezmg2t3glv1qvEfGTuWogNeXOxEI7r3eSqJIS29+Euv
 gy3OqwtRmBEH49OvilOdWXLl4JcIptWiTCGn7QBB3S1JNDUJkvfY2oAbcRzCsQNlQZsVcq6Qjvr
 2NU7AmJ/KSxfFkFqt5bx6M+7qev8e17rVeVt5gHkT30W6SS7eBIL10oghSYeqR3p+euot8Ml7fR
 jd5K0++Xs6IALdnSCNBevTQ0fY6jI2AiwSccZ86SQBojZ/h2+dZUt4GQiNHYQIPYytg1MF5ltoF
 6aoL3iee8IBKninZ0FhfWZ6Kh+CvFhuWUc3T831hBgU4EfkXr5P1+8c4jIU8PP1dMPfr2ZRubuI
 hNN0qKHp0YEHD6Br8KyqCa9ZNhYBoSTQE3DNAhyrCcXRNaDK176us6xg/tWLGTV+1IbNhtHro7v
 TkzR4tbBC5WM+T2fVJyW5RoMSgAmuJopWfn77rXPk6T9RF/5KFmmxQKB+TQtTf8rTf85miOK5Ya
 WM3BVZd+3fulYOUlpDVjYa+8I+EKWNczvDzA+jMsGfsyU1BjLOPSCQGO5Cyyw6AVs9dPdKsu/uU
 1zpkIPKa6bwoiTnS34egHTwIo9AJTyl0jLxCPa5FwWgfGUZNFoTAASe48ic0hg2Hz1W46KSYsqv
 8GVAZr9nt5xD6JQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

x86's efi_crash_gracefully_on_page_fault() ends in an infinite
schedule() loop so the kworker that faulted in firmware never runs
efi_rts_wq again. A later change needs the same "park this worker
forever" primitive on the runtime service timeout path, so factor the
loop into a shared efi_rts_park_worker() and call it from the x86
page-fault handler.

No functional change.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 arch/x86/platform/efi/quirks.c          |  9 +--------
 drivers/firmware/efi/runtime-wrappers.c | 13 +++++++++++++
 include/linux/efi.h                     |  2 ++
 3 files changed, 16 insertions(+), 8 deletions(-)

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
index da8d296216441..a1e46ab003668 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -211,6 +211,19 @@ static struct task_struct *efi_runtime_lock_owner;
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

