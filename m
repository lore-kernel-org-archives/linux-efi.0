Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A36404BC0;
	Tue,  9 Jun 2026 11:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781006203; cv=none; b=cZgeLdx9jnBTqJfq+5bKfXKP/+Cj0U+EfJJO7wfifD1iNvQv1D0B1Uy8coQSo8Pz4WSOkdEMsbhL6XF/xaud7mOIkSfkZszKI/0MivqkYhkm+hGoLQ8jgh5VYcGru2frcJs6+wQqMuROANYXXp4tR93hG0ZC4drVp5+j4L4Jb3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781006203; c=relaxed/simple;
	bh=aIWiOUjx/ZsFM15GQooU6hRsgp9KnCF9/0Kl/rIkFA4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UT/9WEJc/HfkMKBp2O5lPN33eC6spfIMcm+p+Rp6X34m1lV61i8ZmVFgQD7LCKCZhc/EYH0aJoVbILzVX+jXSTZ2AKjuiG7lbtenzLVeV4MAu58Tn3PFiQi87YiUr6xu98fTvdtQtvYp7wPQ+t2uLyA4LMAqFktzz+kisAdCt/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=gca7K0S0; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="gca7K0S0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=5/gDh6zZe2vcPzmWwr5grgCtc2OnYcVQE4zAyHVDadE=; b=gca7K0S0utaQux5tG2fj6UHPdV
	ry3tCKHeHGbDLpJUJQJDXV29dVwl/53mwEhwVt/lVMi1jhvF2QxX5rZIO6EJmG8QFSkY4AZmXuXXP
	kWxQOmPoMFNu8rr/UjWjdd097g9Ey7jxgM8q5QbcRovee1cEt5QHqUTVZATLfNAm1f+jgyPLnDKAK
	zfpaai2dPfoyOHTxuDhp6nlMe2O/elBJ3CFFhvIMDcPRKeToVPyhnWhkw68vKDYMnswpcMKeRID6G
	NBaFcSOjbfs1HybgA7D0hxh0MIOfB0RrRpHlUYm8eI72BCaZplriKmwo/laER0ByY20SG0tnbtqAA
	dphzj6+w==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wWv4P-008Nre-2N;
	Tue, 09 Jun 2026 11:56:38 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 09 Jun 2026 04:55:28 -0700
Subject: [PATCH 2/2] efi/runtime-wrappers: disable EFI runtime services
 after a hang
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-efi_timeout-v1-2-69a896faa805@debian.org>
References: <20260609-efi_timeout-v1-0-69a896faa805@debian.org>
In-Reply-To: <20260609-efi_timeout-v1-0-69a896faa805@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2739; i=leitao@debian.org;
 h=from:subject:message-id; bh=aIWiOUjx/ZsFM15GQooU6hRsgp9KnCF9/0Kl/rIkFA4=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqJ/9rSSXBRClm2sAHCfvefgHt6ZWtsUmLSCAv0
 lyfVBlqPVGJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaif/awAKCRA1o5Of/Hh3
 beI1D/9SOVyJ4KVo52/hq7hClzkBfERemG9I2nOZBvsApwAe6cWd6fOxDGAHBUV14vzVkIr3vaA
 lX9KvqFKIVDAZElZm671ihM9FEyHPYVeYqx4Utarr0THc9ThFoNuMnC4dEURO0iGvF0EHoadJCM
 EE4+391kBXGglSvKbgCco9SKobM+dj1z7Xpe0kqTWyP7+Vk+aeHcbj/+SwTgZz1NxsbK2BYzQXR
 g+GLz8ExvounqPpijfu7y63PzR558FszEN57ThfohUPFCvww4YMD/9xaPkjCCwl1iOxVAzPO1Ca
 ZJVpbL1YPs9D3u2/zMnvcoYanUY1NqvhnELYG/UH31kOYTx15jkaXSe1kXaLeAmGjWTnVI5bgW/
 VwVamjm+rXsZ/w6eKGfMzdvDoGOHFQPmVXwSdRSYDw3pHxjO01pFgzGcR5iBaXW/ij2qWh+Dmv+
 7fD+WYxBA9qZdAg9H/4cOMSsy6jCyPgajGaUjeZw64Wm/NTHsGmbtJyO8+KHsIGPdU8bGSzgj6X
 7NWoUSVNtxAsVcostjSDY0YFp/HMYvxiNzjJcRjwJ5ra6w4wEk233siPTe7kqYnA/orqKJAFOib
 KxEXxCXeRW1fN0+NStyFvh92FOjOFf1lBYElQmhTOkK/e4NhP2sE3EDpFQv7Gw/HXUbVUEm1dGN
 h54oujQY89kae5Q==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

Once a runtime call has tripped EFI_RTS_TIMEOUT the firmware is
wedged and any subsequent call would also hang for 120 seconds
before timing out, blocking userspace each time.

Introduce a one-shot efi_rts_dead flag set on timeout, and check it
at the entry of __efi_queue_work() so further calls fail fast with
EFI_DEVICE_ERROR.

Beyond the wall-clock saving, the flag is required for correctness:
without it the next __efi_queue_work() caller after a timeout walks
into INIT_WORK() and init_completion() on the work_struct and
completion that the leaked worker still owns, which can corrupt the
workqueue's bookkeeping for the leaked work and let the next caller
observe the leaked call's status as if it were its own.

The flag is intentionally never cleared: the worker that wedged is
leaked inside firmware, so reusing efi_rts_work is unsafe.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 6ce6d094066e..a76ba819855f 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -126,6 +126,16 @@ struct efi_runtime_work efi_rts_work;
  */
 #define EFI_RTS_TIMEOUT		(120 * HZ)
 
+/*
+ * Set once an EFI runtime service call has hung past EFI_RTS_TIMEOUT.
+ * Subsequent __efi_queue_work() callers fail fast: the wedged worker
+ * is still inside firmware, owns efi_rts_work, and any reuse of the
+ * shared work_struct or completion would corrupt the workqueue's
+ * bookkeeping for the leaked work. The flag is intentionally never
+ * cleared - recovery requires reboot.
+ */
+static bool efi_rts_dead;
+
 /*
  * efi_queue_work:	Queue EFI runtime service call and wait for completion
  * @_rts:		EFI runtime service function identifier
@@ -328,6 +338,9 @@ static void __nocfi efi_call_rts(struct work_struct *work)
 static efi_status_t __efi_queue_work(enum efi_rts_ids id,
 				     union efi_rts_args *args)
 {
+	if (READ_ONCE(efi_rts_dead))
+		return EFI_DEVICE_ERROR;
+
 	efi_rts_work.efi_rts_id = id;
 	efi_rts_work.args = args;
 	efi_rts_work.caller = __builtin_return_address(0);
@@ -353,7 +366,9 @@ static efi_status_t __efi_queue_work(enum efi_rts_ids id,
 
 	if (!wait_for_completion_timeout(&efi_rts_work.efi_rts_comp,
 					 EFI_RTS_TIMEOUT)) {
-		pr_err("EFI runtime service %d wedged in firmware\n", id);
+		WRITE_ONCE(efi_rts_dead, true);
+		pr_err("EFI runtime service %d wedged in firmware; disabling EFI runtime services\n",
+		       id);
 		return EFI_TIMEOUT;
 	}
 

-- 
2.53.0-Meta

