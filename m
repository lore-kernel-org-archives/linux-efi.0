Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93C643D4E8;
	Tue, 16 Jun 2026 12:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781611804; cv=none; b=dmxdgR2vxzOHv29xJq7R0vEF3vzhUrKPGNGsNyYXKNMgnb/cEsaIXCdcVMWFxQEf0veJ8lsZ1cIAfyoTMVffqtVk+g+F4OVTmSlwPCg4aIyBCfKAMs856Zj66q6uWbszWw6NQVNSWPfLbYQjCsiT+k7Qtchzk0RNhMjBVDu/sGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781611804; c=relaxed/simple;
	bh=FQE7ybV99BMlIVdJ+mmYjaTeQL2S1rRPXQbCjv3P8rY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=N6siIZigbyi1pcqE0ukxium6H50L5UIDK2MqASN56UjvC3UoZILqt1hfUGtQou64JZdTX6QtppDcsIlGMjJB4VY7GlCG/mnSp1ig57nYj+pnmMgCqaKKFpGKe1ImdV8LAJUAVF/CmD+xpFlsfg+B32/2dFC5905TzXIzSGf6wCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=hnIKRBuq; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="hnIKRBuq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=+L34aHUzNvK03IjgFQ6odD2fLOIPjUENcEEOj7gv7IQ=; b=hnIKRBuq/IOfBrH6fpxPQpO6a5
	F6JyunAvmv15LvSp/NrQT2uZPi1Y9x3/Kx8f91cJ89Nk9vWYf0n4xa7JHN5f8kLRyB5QLvQ22lSqo
	B8nR19yEKP+87M3mnA/4S5H+JQi+5XcZYePxpxaxwe40qqb3Mt3yM2WDEGOom7xnufjj/QwCQmxvi
	0z7uL4owlWstg+57Itt/LGkaqXox3a+ddwbtOvnovCtP9rzOpPGP9N/S88hTd9uPhYV0iESYdbZVO
	Ht4neF9rdP6wTji1lNQSKKJ8IiosZA2OKyvyzG1Z5mpo6Pmv9dPNIOaBIiJvzAzNnNCAH2IUELKow
	TeEuSHBw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wZSc5-00Dpsf-2N;
	Tue, 16 Jun 2026 12:09:54 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 16 Jun 2026 05:09:34 -0700
Subject: [PATCH v3 1/7] efi: fix stale reference to
 efi_recover_from_page_fault()
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-efi_timeout-v3-1-76dd1d26657b@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1036; i=leitao@debian.org;
 h=from:subject:message-id; bh=FQE7ybV99BMlIVdJ+mmYjaTeQL2S1rRPXQbCjv3P8rY=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqMT0GCr1J8mQ7IbXOXQr6b5nEBsBWK1/Wk4E1I
 +jrSP0ytniJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCajE9BgAKCRA1o5Of/Hh3
 bbwID/oCDOF1I6NQPocjnF8T6QBiQ8Y/DkVU8ylGqvpzAtH6fbeZIrBopZOboo5Ue3PR1lmY3uh
 t573e00/oU6S7KkZ0R65kAabRpEtsVWE9pwl6wYpk0GI032/cOz2AzljhI0nYSSYS0MWBPCWkMs
 iD/NUElvhPbJEBoZyvQCKAfNeyI15XkcMHFyodsc5nZCf/x/lg5C+O4d5aG8yBFzNhFjQJ3/lg2
 KZIYNRSyyBpULlB90iz2tYh2H2M/wQ4PXVNUyTYfhTGMqu4SrJKiPTkX6WTBVHdxu7uq1t4RZP9
 GXPq8p7utwUfqes691x9mF+fwrMPwy/2OCF6dIdQykbxg8ouxymINZ1ZqOzXLwp+jIagvqNr2WG
 gvMfwIhSDW4xQRgsONu/2WFMLFVmPwncLb/leM+JbIEgkDa+zaxZjzroM2FdsUYisD2fgGn453S
 EAyqR28NAUZREw3mgR5fSKNu/Q/34tkPdrfOlH0U8zTxLtib5Vgs/18rJ4SkfKFOfHir0Lk07ns
 qWqJJqlneWPgDVUCiy/aftDtEqiac6m9pSpB06wMbRqpngFIktFOkfOmbOnmRR25MVQaVRO83l+
 i4XraJ4i62jTLM+Bco2LNc18mj6+QcvOv2r+k7jxwvaFOSr65k2CIv3IYeKYDGo8fG0SHmTdY74
 SutGAYevjmvTi0w==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

efi_recover_from_page_fault() was renamed to
efi_crash_gracefully_on_page_fault(), but the comment above enum
efi_rts_ids was not updated. Use the current name.

Fixes: c46f52231e79 ("x86/{fault,efi}: Fix and rename efi_recover_from_page_fault()")
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/efi.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index ccbc35479684a..24221a8424121 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1212,8 +1212,8 @@ efi_call_acpi_prm_handler(efi_status_t (__efiapi *handler_addr)(u64, void *),
 
 /*
  * efi_runtime_service() function identifiers.
- * "NONE" is used by efi_recover_from_page_fault() to check if the page
- * fault happened while executing an efi runtime service.
+ * "NONE" is used by efi_crash_gracefully_on_page_fault() to check if the
+ * page fault happened while executing an efi runtime service.
  */
 enum efi_rts_ids {
 	EFI_NONE,

-- 
2.53.0-Meta

