Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E685A38399C;
	Fri, 12 Jun 2026 11:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781262134; cv=none; b=OTYHwlFRreMTJvddKeRRPXsjjIsGtoDIjFJHHfq0vGFiHeRPXNPmSwbgWSmHgHXmM5YtUGYDCc84PKDU5CPb5Fpxl9X7KlLKwyUutlg30Mt6+exS4K9gGA7+P1mSQMUSGeP7XBHhlVw22tOP7hgimIg2yNNTkqFIKpkZ3TEm+vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781262134; c=relaxed/simple;
	bh=33t/1G5J3HxpJ/KN9N/mgfp4LBDJ+TIU8e97+j9Mu4A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OiLCYthbD617UH98vwjh1toBjhQnxdhFLMl+CYv1fi99GFTtGniB9/XAPcJtyT5iR92Kx8HMYs3UDXUTHBHFI9y7VpvZZ2LVz55fff/JHsyDg/OhRyZMU85R957uN8HxmQUL3kAOtX8EVkkVQb8mZNLtFNdXtYoDOKF89FMYwOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=N4nn7SBQ; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="N4nn7SBQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=6mOoquVS6hM/jmcIG5f21NqpMKlTPF5dDI6NvYponNo=; b=N4nn7SBQSdjHxBEAlwnZS7xxb3
	BGLtjfVToVzFZKe5KjBa+h8S/whw/GIr9tlgebOWSewFetQkhf98vlGBVrC+gvpu8a3kQaazmQHSw
	KJ0Pkc9ad1OhmmbrPTmT78bPxhKcXoUeiw9kKKjUS6I8ynx8fPaJya2c9dNCfewYkAhMiQe4oAdJP
	AWmtTVWoujeBWKKwlubKrBq1Muf3F1eLby61H4u9TiOAnEjOnbpZCRJz1zqsKkptOqvovPMKfilAA
	K0ZC4gJfEGT38AbtqApFQUwrrDM8nEYEkpwqJaP77wA1tPjEPq6wVlfDlgIdM+DiF7bnxC64P8XV8
	8KqNNSgA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wXzeB-00Agh5-10;
	Fri, 12 Jun 2026 11:01:59 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 12 Jun 2026 04:01:30 -0700
Subject: [PATCH v2 3/6] efi/runtime-wrappers: check EFI_RUNTIME_SERVICES
 before using efi_rts_work
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260612-efi_timeout-v2-3-f714bb016df6@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1582; i=leitao@debian.org;
 h=from:subject:message-id; bh=33t/1G5J3HxpJ/KN9N/mgfp4LBDJ+TIU8e97+j9Mu4A=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqK+cTeT2jqPMdD3siakL6IMf41KAgGdxI4yupN
 ciKd2vXDHCJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaivnEwAKCRA1o5Of/Hh3
 beBqEACSUObj3jn50lskqM3G/FVoWRBEX3vRW/xtcdMdu5zQMKdjybtDdnj2EL+nDWI0YqjSXMf
 Y3FhbPrroyatBNuc5N+1UZEn6Zi2gAh1LlFrgmVdjz30AnZwqjibw3mjg3lT3v7z9cfC2DdsopX
 LCIqd9auY/oXuMTI4JPbElhTHoeK38H+A44CJ3i4Favh9vXmDBqDejghmdkJ4eZBRW2TVyoi1bw
 BcQw8iwBMQHHmX5UgAlc8QTVYR9L5WyO9090U72I0xyY6y/oTzMzM9oYPVqCCCNEzmy8DMHqt42
 tCwFGYwSPhgGCfWLyxP5azDSIr3J/WH7UH3mGjNmdCd1tMl0UT9jSgauX/IFLaANKMME2y1KV99
 JcXsB+NixcILLUpebkpgm6y2DRZlJ/nXNCanO7WsE6fa+PMw0stPyD0qtFFz6xqdxgXgR/ls+ph
 o+mSCZUhmHjD2nPMQpBDEqlqF2TphsO2xtCPDijGeIVc8h8BvV+p+RIbQluk4jdilbH4m4LzunW
 D8FXxpGgkU5H+TSR2C4mbvNQtUkuZCyN7dI8TjiD3RYNmLlVnd84Fu2+B9bUXlrKUaYwGPjcRB+
 eMQ00uP5AdPor3rTPpvWU6g9yUkg5IECFsSeoBQT04UpCeA/deQDdzt2DoMfaMJNJ/x0H801Cjq
 yCPpOUMrAlR1hoA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

Move the EFI_RUNTIME_SERVICES check to the top of __efi_queue_work() and
return directly, so a caller that finds runtime services disabled returns
without touching the shared efi_rts_work. No functional change.

This prepares for bounding the wait, where a timeout will clear
EFI_RUNTIME_SERVICES while the leaked worker still owns efi_rts_work; a
later caller must then bail out before reinitialising it.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index ebeec87ed0b0a..0cd350760446c 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -320,17 +320,16 @@ static void __nocfi efi_call_rts(struct work_struct *work)
 static efi_status_t __efi_queue_work(enum efi_rts_ids id,
 				     union efi_rts_args *args)
 {
+	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
+		pr_warn_once("EFI Runtime Services are disabled!\n");
+		return EFI_DEVICE_ERROR;
+	}
+
 	efi_rts_work.efi_rts_id = id;
 	efi_rts_work.args = args;
 	efi_rts_work.caller = __builtin_return_address(0);
 	efi_rts_work.status = EFI_ABORTED;
 
-	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
-		pr_warn_once("EFI Runtime Services are disabled!\n");
-		efi_rts_work.status = EFI_DEVICE_ERROR;
-		goto exit;
-	}
-
 	init_completion(&efi_rts_work.efi_rts_comp);
 	INIT_WORK(&efi_rts_work.work, efi_call_rts);
 

-- 
2.53.0-Meta

