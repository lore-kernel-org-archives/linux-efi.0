Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9726439EF25;
	Fri, 12 Jun 2026 11:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781262137; cv=none; b=Lq6I4F0vu5f+SRIuC/7g/RmPy123JfiCWByP3ZaE2X1Ye4yzcD7yUxZvz+LWLourhfw2UU8u0UgNXfCv4gZ+ZMZ6Fg7C8AL9FTu/pFvs9h/liOhfUemh0gsdo3jzV+QxLlTKdNIr+ZT00XPPsuA+YgqLqHjEO9QOPeVO8zd3G58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781262137; c=relaxed/simple;
	bh=bkKVE2YBxypJKYTqkpdYBWYX53CfufISKEIkFDmo6ms=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nCBlmCXOSp68XCCOYJtpWGAPw86mvOAiI/gBE5rr80BfCV+tlyEyEMXsE85zhHJzbu86vM55oQqQ4jD2hn6apCUdQfCuntaryKye5ZUn2Kp1JUcQzWg8iVueRgF0rNF+K0/nbKcmWnYWMPzKYKCvft3tuLzyale66vY1vl06emY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=MQPNA0j/; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="MQPNA0j/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=ZxoLbrwOxQ8F1qc420GPLoYoR+1OtMo+FJvOdtqt+5g=; b=MQPNA0j//j7v9i0Q63HN7lUHi5
	gN2we90IfkDrNPplJGGMZsxdnjJH54vcsXpGoHX6V7EPVabZsWoCs3H9ZFTaXaVaWnMlLOhjESHQ7
	w0/70zr43jx84bI9GS6zDZ1TWdMkADEQ4+T8dKTzi330hMFZzyg0IpwtNLGCiJhbOrA6loI04bCGw
	sLZDrTaexqO0ERtXd4HGMrBgPYmiQUIdoAFoA21U+mmERvAyBVLPSGLYd6JiVr7KY8Qm6sqweK17F
	xxQ1LNmyud33rxNvEvfkn/v6yAFWhpjklFu9gw4Zf3ohkWiTH5PqYRbGbuhcmZ9374NNxZFRRf6TK
	XTwwFozw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wXzeG-00AghH-0s;
	Fri, 12 Jun 2026 11:02:04 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 12 Jun 2026 04:01:31 -0700
Subject: [PATCH v2 4/6] efi/runtime-wrappers: bound the wait for EFI
 runtime service calls
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260612-efi_timeout-v2-4-f714bb016df6@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2443; i=leitao@debian.org;
 h=from:subject:message-id; bh=bkKVE2YBxypJKYTqkpdYBWYX53CfufISKEIkFDmo6ms=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqK+cTLDVY9+SNrKXmbbBU439YRGdsoCTs0RKME
 9qnhEuRAjSJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaivnEwAKCRA1o5Of/Hh3
 bZtNEACODfgkkhov52ktCKOOonBFpDdsMae+B7MvnG9rLUMnM4501f4t+/O4WTcmPtxhEbCpkJh
 5yvDtZmnypi4Qnf+VzjuNt37Zm75p7RblfnYFo3k3TjFiCEGx65K4XCDIEefcUUKpagWWlVVGQL
 UoHTd6xoIPbrZa78bpuvvQqLZ3alBy5f19GhA1jlA8zaEyQdSpvRFJTYlbxEGWrRQf4/VGsLjRL
 hZ1Hbv2RjPkVjmDGwOMPGeDvDoiZUUdxGZoRRJCQirveN2F1r6hdvE8JztoSjJa4rVsKFGSHnvi
 9/MXskvVrmmeBZMQIMc5uhe+09HEhf8z3ZQEdvuf7gbAc6OXfVzlGpBWK3iLh7oAOOO7zFUFDUO
 utzprWDv3ZKEXNSf7iAgDYs2R5g36HFChZtCRExarpiqQfiAgGNnI0ZZn6xHa9S0aIWdJsgnYir
 u49JZBo1jmfQYSW6pGOItAbqxHk/0KNV8wmZdg73TEHpSY+/+hU66Ghc36PXvHDPzIQbSbB1aBg
 axYJnz1iz9cC5chupaYm9rAMVDIFhbNlnre+aK6EtucufsrBjeNowQ/kRE5RpNDHRulrNKO2QDj
 15ICnRLkGxpgP/hIZArqiqf6uRoTtpSZvL3UFd3R+X+2t/jDkD/KYxMi/wxOJ5/Hw8qeNK0ogie
 eCEO9V5P6ghXstA==
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

Known limitation: the efi_rts_args the worker holds points into the
caller's stack frame; if firmware unblocks after the timeout and writes
the output buffers, they land in reused memory. Firmware hung this long
rarely recovers; a follow-up could bounce the buffers through kmalloc.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 0cd350760446c..8badf0419a148 100644
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
@@ -342,7 +350,13 @@ static efi_status_t __efi_queue_work(enum efi_rts_ids id,
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

