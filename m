Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8664543C055;
	Tue, 16 Jun 2026 12:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781611823; cv=none; b=gpDbbVJOubApazKRHqKVQTBIB7cLFNcRauJUycyk2AT02CtP+OaEGt6dfvmRTn0n9Mb2Yle6dMW217ckBdC8+NC5cABh3FQzlNYAaFFlL77WqRtWioWEK6p52qBWNyG7OCGuvv0Mzd2/en18/r1bCq2BCTc+KTmDzNlgHyRbolg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781611823; c=relaxed/simple;
	bh=8GDi8ljfM8/vnGhuawdO6534eyJN2KmQ7rDwVws8qK4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DYq2E5/7BzKN/2zJeFtx8BSYUDbQocqIezhu2f3GFpsF7jewY9TFF9oS1yNHRt6quQ38yMPxBuuKmRMvkcQatUnRG74eT1uWvp9w1AG2eDqon/OmlU0+URxDqIsDncqGBhmx33ClnZWjWQvDi4ANYVKlT8vZKVqi35ophxnYr44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=cNh8LdST; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="cNh8LdST"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=shkeidSvOicgoTy9nkfu6ftwaYtuV0Spmxwgovplp/Q=; b=cNh8LdST8rfKCgFcRfcZfNiUDi
	6AM3TTSjnl76FCnJ+PQb4v5gJ9IlXuG6e6cSGp3USBmHD+CLO/03Tpzj2/L34AKLNAFlM1wy6PjQU
	x1Tk7jNb+UPA6LKmMGO80khvsZLNjmK3DBrXpbI6VOzjKJHYI+K8W/25TtrtRWZ6jAHSxL5tqYLNP
	UbO9ay/KL/LuTGgt65Bo/E6a14MTxZ8ategRZEouB8ILoxLeFHDqN6i+nqI+bByxDgsrhOXH5cqj4
	L8b55K9LRlkJGulHkcU40OvQ+zGZ0CqCgeSNVi/hylFa4YKGs44L9txs3S9HTNdIoCJp+MWrihx0a
	rWEzdRXQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wZScT-00DpuM-2c;
	Tue, 16 Jun 2026 12:10:18 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 16 Jun 2026 05:09:39 -0700
Subject: [PATCH v3 6/7] efi/runtime-wrappers: honour EFI_RUNTIME_SERVICES
 in the non-blocking paths
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-efi_timeout-v3-6-76dd1d26657b@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2705; i=leitao@debian.org;
 h=from:subject:message-id; bh=8GDi8ljfM8/vnGhuawdO6534eyJN2KmQ7rDwVws8qK4=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqMT0HWziOE8P4YWam7YZBXjUJDaSL9VdD/Oras
 vlTx58wdWmJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCajE9BwAKCRA1o5Of/Hh3
 bfF0D/9bRVrHbV45ZPODfugzj1qd7PZTZ9yA3m/+A494YGI1Aa8xuBnjn6f5pyaF8eZ/87ic/QH
 RpkxelAAO3ifIhB42rj9urAp6AR+lHrz8bQIlYWPc9VBEGRRzTnXKKJpTUdZQ8y/GxEZKWywaZk
 vRjN62KtW1t6ZJ6nVb6vI0UCXIGwVE+gb5Tujfg0Rcm97ytqzaTAl4QZBX/vUAywFeoqP5eCPZo
 1/62iJhAeDl7f0iijMEmWFtnY6IFFAZDbBkS+hrFWFRaw4cp8jl0f50Syv+NPwcQzSPSqHiPC+n
 7FC0FWehAc+Z3sSlhMRB3TgAWLGN8tapKfcXevf4Yo+qEc/d1EXyqOccDdp/1HA1XYXEs83rhrh
 kzjdAjdvG1wycZ3GUAIJRXcIeA6KSfZx69f9nDq/bUsoHz/iCcDl9zW1N12p5KjkbBBapORgsY8
 n9PYpu5x9fGsY5vckFVv5+FCpKBfZsEoYngeyZ843WZfgWVMAnQaitcNf9DA5WgJx9D8L6Zcfit
 e9pcPgdhKopnMcxFbnV6NRe7LnHw9mdhJu/TxZ7RM+PVN7lXqviJcAZrKvhLhtf06HhXffHEpEP
 DGWiVkC3ACOuXBWRbgK+2lOd8H+uvINeXFEGcZ2jDFMAnXB3Nj1L3I7Y4ptTUFGkMqTm8r415bs
 9NH4NWdAsqg0PcQ==
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

Check efi_enabled(EFI_RUNTIME_SERVICES) in each before calling into
firmware. Test it after taking efi_runtime_lock rather than before: the
bit is only ever cleared at runtime while that lock is held, so checking
it under the lock avoids racing with a concurrent timeout that clears the
bit and drops the lock.

Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 2ec5cbdf46d07..2b0a7caf90944 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -480,6 +480,11 @@ virt_efi_set_variable_nb(efi_char16_t *name, efi_guid_t *vendor, u32 attr,
 	if (down_trylock(&efi_runtime_lock))
 		return EFI_NOT_READY;
 
+	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
+		up(&efi_runtime_lock);
+		return EFI_DEVICE_ERROR;
+	}
+
 	efi_runtime_lock_owner = current;
 	status = efi_call_virt_pointer(efi.runtime, set_variable, name, vendor,
 				       attr, data_size, data);
@@ -519,6 +524,11 @@ virt_efi_query_variable_info_nb(u32 attr, u64 *storage_space,
 	if (down_trylock(&efi_runtime_lock))
 		return EFI_NOT_READY;
 
+	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
+		up(&efi_runtime_lock);
+		return EFI_DEVICE_ERROR;
+	}
+
 	efi_runtime_lock_owner = current;
 	status = efi_call_virt_pointer(efi.runtime, query_variable_info, attr,
 				       storage_space, remaining_space,
@@ -549,6 +559,12 @@ virt_efi_reset_system(int reset_type, efi_status_t status,
 		return;
 	}
 
+	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
+		pr_warn("EFI Runtime Services are disabled, not invoking reset_system()\n");
+		up(&efi_runtime_lock);
+		return;
+	}
+
 	efi_runtime_lock_owner = current;
 	arch_efi_call_virt_setup();
 	efi_rts_work.efi_rts_id = EFI_RESET_SYSTEM;

-- 
2.53.0-Meta

