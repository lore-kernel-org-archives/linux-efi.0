Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C68A3F5BE6
	for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 21:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879725; cv=none; b=f4K96x8xTWSYKLZo5Ly603cIdoLNAetS3xZ7aVU5w43IHMq5B1y0dv2Mk1KA7qiSA0nn8wyE+jWZqF0bjZ9H8w2eMwJtsgvGBDemXt6SDy1YudVLOp9NBoHqyL4JzLG6HCnOmVtDnbGjdLP1NwWlc7/kdxO7ui7lIlWtbXcf+6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879725; c=relaxed/simple;
	bh=DULLarGA3N2WbmTOoIAH6Z6cAJNNwTwfc+oSbMTDbH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFtxEZh3TxKIQ8bbIUYAa7acc/IjDaoKMFdmXRVvvycKFZ0p+l+P631QW6upSYnsR7Kw/bJvwhPTyyXSIeG/YNWBihIWLM2q80nIJqxHKo6dCuUdOQIaguPEMEEwWzQH8AG+N4FPMx576Nhsr62TO8n+xnsrKCjO7S2/DfKSuKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GfxRkan2; arc=none smtp.client-ip=74.125.82.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GfxRkan2"
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-30246cfd41aso1513771eec.1
        for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 14:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879723; x=1779484523; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ER4IWQsMKw/HNZSo0sHiz6UgahZlpRSMvCUCrr/URAk=;
        b=GfxRkan2jXb/hDtBDF0b2sCZ9HhiKP1Jj/yCjehZ+FkCiZlTYroSSQI6ZCBGNx/FBH
         nB/APZdgfAjcUw2LfZ3ELWjaOwm/EVaIrw6+uWbd46OCgIH2/r/rsmi8lFGVmYlCYmz5
         iihILkrwP8lqd2Dn4bjCqFt+vijLcekhje43yv4KJ8blEx7Jga1xd2AM5HfyT9v3Etfa
         aBW7LDioHVaE1M7oNwRvB5TxwC+2TRLlsekBab0tgxFWaCbgvF+FxIoX0AAFL6kw9CJV
         rm/gWOxfdEdyOeJakpFiJ9XLMAElhxeMRQzo54xa/6YGBaLUk0AH3FHDfgIQiVMNwZMb
         i+RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879723; x=1779484523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ER4IWQsMKw/HNZSo0sHiz6UgahZlpRSMvCUCrr/URAk=;
        b=ciCkEWwejqe2BNS2xX1RBKT2GCTmafKgAi7+3paxJ9g7Or6ygPHiqaMGwA9KDfjpZL
         zlh1bNAV3QTYTJ01ZhkVrjL280xHCn/U/odUNqJwAeJWYo/gzL3COz+jhp2genePn6/s
         62qbQRW5lUhJ4feq9gAiKf7589wglEJyUdGGY952dEnpKAACkWlxneL/kFouGpeRHzWW
         A7IBX1Anc0PIYhvInzLpgirL33NeIr+NjPQpaXEzITtDv+9jovYyyPyLohEGKGsipeQj
         kpJIDlIXMAFS6aJyIQp2GhM3YSirQV1TKf84qdbxAg5K74z5lwLacFIEz5LP8DokJ9am
         1qVA==
X-Forwarded-Encrypted: i=1; AFNElJ8WEsSwbNHztkrVfGyaQZevYtluvdNo9bvCy42sRqum0hKcDj98+pReR/WWlxsg8+FrD0k8DLrYOQA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDtqjW0xOx0S4CKKjd9PHpWWPkRE1cJDDjJCtiS7zeQZ/8Vnry
	R+2U7eLmjQz/W1j2JTN0zmCsBFpCgyU2strL2gUR0gdU4RdgAHkS9Vzg
X-Gm-Gg: Acq92OFv45NlnyahbgO6zx87GzuxIvuXrqiYVWNjbDzL5y2aUqx5r6ioF1iHoMlPOu1
	rV28VW4Ar1LrvTyQN0e5k5R9XNltLNiFQwbY2b9uGKWmCFKSXnoyQISyIUPMYxoOmCb1ppiDKEy
	DfuiSQMMtQoSjR7A+9sCQuBGIQJDGzKjc5udkTYNEmrzQDcb/xoBiP1RiwKAPPmV+NAfjUlNP09
	YSBfwNmWZhnVSlUNc/2mc51elDZ8xP9xbDn7ZqYNRHWPVwRIsQuET9y2WVB0MrZ61V/ME1UFbzm
	TalHRojT7ZmbrA3OK8JDkOAcD+ia5zu6Q6WQXR7saqBL6tLnp6KIuitpfgW4J29bl/x6u8LEQ5E
	jm6iCzeebw/OuUbLV1nGpD0yR6OX/7S+ih3h+3geZEy02jyKTLlNSAnlrm74FcoSS/jQMMhvx4X
	kcWGllOT2TCwq/wFH1uekoH0/GwIrNoa/mFnCdfFv1UQ==
X-Received: by 2002:a05:7301:4184:b0:2f4:3a9c:818c with SMTP id 5a478bee46e88-303986b1521mr2959973eec.29.1778879723496;
        Fri, 15 May 2026 14:15:23 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-134cbcb9ef5sm10736508c88.2.2026.05.15.14.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:15:23 -0700 (PDT)
From: Ross Philipson <ross.philipson@gmail.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-integrity@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-efi@vger.kernel.org,
	iommu@lists.linux.dev
Cc: ross.philipson@gmail.com,
	dpsmith@apertussolutions.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	dave.hansen@linux.intel.com,
	ardb@kernel.org,
	mjg59@srcf.ucam.org,
	James.Bottomley@hansenpartnership.com,
	peterhuewe@gmx.de,
	jarkko@kernel.org,
	jgg@ziepe.ca,
	luto@amacapital.net,
	nivedita@alum.mit.edu,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	corbet@lwn.net,
	ebiederm@xmission.com,
	dwmw2@infradead.org,
	baolu.lu@linux.intel.com,
	kanth.ghatraju@oracle.com,
	daniel.kiper@oracle.com,
	andrew.cooper3@citrix.com,
	trenchboot-devel@googlegroups.com
Subject: [PATCH v16 25/38] x86/boot: Slight refactor of the 5 level paging logic
Date: Fri, 15 May 2026 14:13:57 -0700
Message-ID: <20260515211410.31440-26-ross.philipson@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515211410.31440-1-ross.philipson@gmail.com>
References: <20260515211410.31440-1-ross.philipson@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ard Biesheuvel <ardb@kernel.org>

In preparation for adding Secure Launch support, which will require that
the number of paging levels remains untouched, tweak the logic slightly
so that the slaunch check can be inserted easily.

No functional change intended.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 arch/x86/boot/compressed/pgtable_64.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/pgtable_64.c b/arch/x86/boot/compressed/pgtable_64.c
index 0e89e197e112..3e9d651da73e 100644
--- a/arch/x86/boot/compressed/pgtable_64.c
+++ b/arch/x86/boot/compressed/pgtable_64.c
@@ -102,6 +102,7 @@ static unsigned long find_trampoline_placement(void)
 
 asmlinkage void configure_5level_paging(struct boot_params *bp, void *pgtable)
 {
+	bool l5_enabled = native_read_cr4() & X86_CR4_LA57;
 	void (*toggle_la57)(void *cr3);
 	bool l5_required = false;
 
@@ -118,10 +119,12 @@ asmlinkage void configure_5level_paging(struct boot_params *bp, void *pgtable)
 	 *     + CPUID leaf 7 is supported
 	 *     + the leaf has the feature bit set
 	 */
-	if (!cmdline_find_option_bool("no5lvl") &&
-	    native_cpuid_eax(0) >= 7 && (native_cpuid_ecx(7) & BIT(16))) {
-		l5_required = true;
+	if (native_cpuid_eax(0) < 7 || !(native_cpuid_ecx(7) & BIT(16)))
+		return;
+
+	l5_required = !cmdline_find_option_bool("no5lvl");
 
+	if (l5_required) {
 		/* Initialize variables for 5-level paging */
 		__pgtable_l5_enabled = 1;
 		pgdir_shift = 48;
@@ -132,7 +135,7 @@ asmlinkage void configure_5level_paging(struct boot_params *bp, void *pgtable)
 	 * The trampoline will not be used if the paging mode is already set to
 	 * the desired one.
 	 */
-	if (l5_required == !!(native_read_cr4() & X86_CR4_LA57))
+	if (l5_required == l5_enabled)
 		return;
 
 	trampoline_32bit = (unsigned long *)find_trampoline_placement();
-- 
2.47.3

