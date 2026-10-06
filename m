Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E3F3D5C38;
	Tue,  6 Oct 2026 20:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791319346; cv=none; b=MneTQ3hcV/S5wxqEG7dOi/OjjJ4165CalD+3rrUmeLeF18t4nkHMhKOrw9Ksgr2y30R35hd2MLfNWDp6G3ixcdE/RrEDlx5wIV/QHJex9lUvmY4kal/id28XNOdvzQ10cbLLIfk+RlBltSIT8Uz5ofT1uukhvHdhO6zi2VJdIes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791319346; c=relaxed/simple;
	bh=I5P3QncE9DpIK7FbawgHR3kxZq5bR9Oa+8QqioqGnrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dV3yi3jOl+jSOIpNMOdlaLBOKY5/2fvjl0r3KBCU3VHyfRMRKfSM2U6IvELpBAXEFmBXFvsG41G8dgUfHMZjC95pvxpyVX1ZlFvB3k5+I3Ou9sykdiG9mULg9yKJouoRUiD9GNfn7bzBVLdyu5FPwIBWt4NGwRL7FCfcW8uL7RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nPK8sfiA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nPK8sfiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239631F0089B;
	Tue,  6 Oct 2026 20:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791319345;
	bh=EQYGbTwRYp0+ByfWlAKOYk/am+mKAFiYFPyQYF2sqW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nPK8sfiAbLMZq2OpA0BGLAVTMuB5f2GOOWP4DaRhuMv6ghLzz/oiVePRuySiaUv/Y
	 5RtKdSKZaYIVHn+dhUM6gx3YnyTxDPFdnpuxyWUN/qiI0zmfZQQ5aDa6bDDUKC5hAf
	 7Ur3QV4VDwwbHJtevzNluYPMcu25amUKPtJP9YJuGKqBSz3TG5Wpha/iwCa3t+CjmG
	 ErdOsYBBahipMur2wZIPUliL/lseoQL0rHn4doReln9BxoDxlg373k0M/AOTw126Ha
	 q4lqrRWGuD9/unYrX9Ag4hTPjgLtYCczxPhhN0lelItdnaShQqp/ezzk9ZfZKEBLC8
	 /x5vHCcpb75EQ==
From: Kees Cook <kees@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH v1 1/3] efi/libstub: Declare the x86 stub's assembly entry points
Date: Tue,  6 Oct 2026 13:42:21 -0700
Message-ID: <20261006204224.1536491-1-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006204210.i.137-kees@kernel.org>
References: <20261006204210.i.137-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1327; i=kees@kernel.org; h=from:subject; bh=I5P3QncE9DpIK7FbawgHR3kxZq5bR9Oa+8QqioqGnrA=; b=owGbwMvMwCVmps19z/KJym7G02pJDFlHY/UmWl9fZPh0+fdb7wwiyxxmly3acjVuU1nWpHf7p I82zjKe2FHKwiDGxSArpsgSZOce5+Lxtj3cfa4izBxWJpAhDFycAjARFQ+Gv+Ln5r++dbpIIu70 Hdl5n6pdz4WsvX3Ubu/byQv+OG7njc9hZFh1p/lQ6OLC0olXbhkZTpM0mla35/t61ku7L0dxe3e +XMMIAA==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

efi_stub_entry() and efi_handover_entry() are entered from efi-mixed.S
and, through the efi32_stub_entry() and efi64_stub_entry() aliases, by
boot loaders using the EFI handover protocol, but have no prototypes.
Declare them in x86-stub.h, as asmlinkage, so that the stub can be built
with the kernel's -Wmissing-prototypes.

Assisted-by: LLM
Signed-off-by: Kees Cook <kees@kernel.org>
---
 drivers/firmware/efi/libstub/x86-stub.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/firmware/efi/libstub/x86-stub.h b/drivers/firmware/efi/libstub/x86-stub.h
index 1c20e99a6494..cc2474c0f95b 100644
--- a/drivers/firmware/efi/libstub/x86-stub.h
+++ b/drivers/firmware/efi/libstub/x86-stub.h
@@ -8,6 +8,15 @@ extern const u16 trampoline_ljmp_imm_offset;
 efi_status_t efi_adjust_memory_range_protection(unsigned long start,
 						unsigned long size);
 
+struct boot_params;
+
+asmlinkage void __noreturn efi_stub_entry(efi_handle_t handle,
+					  efi_system_table_t *sys_table_arg,
+					  struct boot_params *boot_params);
+asmlinkage void efi_handover_entry(efi_handle_t handle,
+				   efi_system_table_t *sys_table_arg,
+				   struct boot_params *boot_params);
+
 #ifdef CONFIG_X86_64
 efi_status_t efi_setup_5level_paging(void);
 void efi_5level_switch(void);
-- 
2.55.0

