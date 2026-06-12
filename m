Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6368F39E6D4;
	Fri, 12 Jun 2026 11:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781262141; cv=none; b=ZVqzOO1f3v3yzY+sEb9FDX496qOn3iwmV8shmDvuwBFx4lInSNHD5XKLeQfcf8k8rxY8hqw2EPIrZESMtyLg5ifQS0Sc2TLRGKFS8Mm0PFu3SP0VabtkFZf3lDAnhEMEmx1Beh1E7Fb8osvG34lc2oWgRfkNyjJ0nK3jwq/f6F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781262141; c=relaxed/simple;
	bh=ExZEGeAKb8Abe8FuJSPKlUqN/XGe2L+2AaiXj3Aue30=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=a39/0+sDd53RnJR7tin5bLOGHmI3lT4T1/hLZsnNtpvMQZzEZqmKj0FwechP3R6jq9FYs3tC/Y65ivtZic68alLp5FaCS6kxmztanmNus1EX4unJ0TtrMikrzp3IrWoX0+XtbQekUT97WgZMZnokvlKnoG6cjLej7EEsxnTyBsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=nMwC5Mqf; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="nMwC5Mqf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=6KOw4vKZntTKEbqtxTt5q4WIyNqHTwvW8Y79zQ6s3lo=; b=nMwC5Mqf5QI1iNq2ljWlOG4WK8
	r92QryolAkLpHPH0hiWTDyn9QV+4gk39PPTsoIm+2j2WrIwmN9MnLmt+l+5bjcE6ea7dmYTDe2RZc
	XWPNc4rX/hKgRoUHH8OcVuSdv5bxn4XeCIJu0Np3o0Sret5or25iFgD5sr8+1t2cvz9Z35ERBKYII
	3V99GpF0TcYKTb6F2L9bGFmh+YidzKVjH+l/nPnCiWrSxunGZ2mIVkkH1/C78ET8aJ1e6pN8CFxD6
	XPXCc5IlAYOBtAsGLgOefaqUli/g1uSaasErzDFannB1gbzxW55eBg++X7uMJIb/2iVDErLn9vzh1
	DYGC5nsQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wXzeK-00Aghi-2h;
	Fri, 12 Jun 2026 11:02:09 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 12 Jun 2026 04:01:32 -0700
Subject: [PATCH v2 5/6] efi/runtime-wrappers: honour EFI_RUNTIME_SERVICES
 in the non-blocking paths
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260612-efi_timeout-v2-5-f714bb016df6@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2339; i=leitao@debian.org;
 h=from:subject:message-id; bh=ExZEGeAKb8Abe8FuJSPKlUqN/XGe2L+2AaiXj3Aue30=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqK+cTlq4lHgEvFVaax9NYsmdKbRr5kTyqx0eHL
 loQs1zE2bqJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaivnEwAKCRA1o5Of/Hh3
 bfPoD/91+DRLsbfEaStihLIf5MII/kHtLWISVuZn4mxv1v8UN4egOjoqMdqLLa6tzkGdbd2VYgl
 +Ubt8FA/UJWEYskLshRreLNjxFZ/Fhehh/kBIPCk86rSQiIM9Exbmntl4oZgNJjm99gBmrlvpFF
 2GNhQMYKvFE6R7zSebhFhDUeGuUuybULd8fWNuRgAzCo3GHSKz1lt19Db6nbfSrDf0bi6j3DmMS
 ZbvGOWs7cj7fZCDicEDebxcfSOqVAGlu2D6dVtCsI4DgaVwJ6vyo2CyiZt2gRBRWVpEYGPLBgWB
 uiWOSxLXPYrJ5nhMY6XaoLPdkqr9fLOPHptZJ231wiOjEcEuCn4UZ6kD3HM3iY14dbT39GH2pV3
 CJEAKQJtY59VqAXugb80aK3SilkDLjiBZV9YUwAqm3tf3cmIG6A+gZPJ2C/wAvt3/CTHSInYcY3
 67kHzusmlt/eCkQjO0c+bNmPFAgddkX9DkTZOK2Mj+Pu7m2uhw7FRtsX6PtjFUxqyS/xopYs4Tw
 rt5kP9kEDANx++PDmKuWKUJqOrADonUQFDcTK28IY2OgSwAmSZFEkkXtqkriJs6hs6Y21XwoOD9
 +sqVMPkrIQmn67f8XNEO09+R+mzs4RHNxEtXnscWho35a40GddHy8MHcXlbIIBNVBMqXPaLd9iV
 MibD2Xf/3HWhIvg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

Three wrappers call firmware directly instead of going through
__efi_queue_work(), and none of them check whether runtime services are
still enabled: virt_efi_set_variable_nb(),
virt_efi_query_variable_info_nb() and virt_efi_reset_system(). Once a
hang has cleared EFI_RUNTIME_SERVICES - or efi_recover_from_page_fault()
has cleared it on a firmware page fault - these paths still enter the
(possibly wedged) firmware, e.g. an EFI pstore write through the
non-blocking SetVariable() variant, in violation of UEFI's
non-reentrancy rules. reset_system() is reachable too: efi_reboot()
only gates it on the static efi_rt_services_supported() mask, which does
not track the runtime disable.

Check efi_enabled(EFI_RUNTIME_SERVICES) at the top of each before taking
efi_runtime_lock and calling into firmware.

Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 8badf0419a148..842f72d44211f 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -461,6 +461,9 @@ virt_efi_set_variable_nb(efi_char16_t *name, efi_guid_t *vendor, u32 attr,
 {
 	efi_status_t status;
 
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		return EFI_DEVICE_ERROR;
+
 	if (down_trylock(&efi_runtime_lock))
 		return EFI_NOT_READY;
 
@@ -500,6 +503,9 @@ virt_efi_query_variable_info_nb(u32 attr, u64 *storage_space,
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		return EFI_DEVICE_ERROR;
+
 	if (down_trylock(&efi_runtime_lock))
 		return EFI_NOT_READY;
 
@@ -527,6 +533,11 @@ static void __nocfi
 virt_efi_reset_system(int reset_type, efi_status_t status,
 		      unsigned long data_size, efi_char16_t *data)
 {
+	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
+		pr_warn("EFI Runtime Services are disabled, not invoking reset_system()\n");
+		return;
+	}
+
 	if (down_trylock(&efi_runtime_lock)) {
 		pr_warn("failed to invoke the reset_system() runtime service:\n"
 			"could not get exclusive access to the firmware\n");

-- 
2.53.0-Meta

