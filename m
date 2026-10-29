Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793295009;
	b=SUsSNcB+Wn36Pf40revUXpdsxyCDWIypCMGznHWloLWufsCBnaVLtVM5gQdYFRYjSvEH
	 1D7ZyCerlS15u7rDh/uSOLoyZ+N+NrWYamoWdKN0A6FFVCNvhoDNtnvUrTc5x0hPK8sJn
	 2wvv3YGgXB27A/XMU7tDeOTI2QnEOB5JHBeA4cZUljB2e+Pspy64yP8Ry5DrJwd7cd/ty
	 jeGNUN2+IMLLgC5z3mbQD+HCiSen0KyVdw9Et/Tptv63NQNvPx7VX41TwC4RNraCT9teg
	 bAHQ89ye35rLG1+qK4YgG2IUx2bHMRqHvI0lFM7E83uNJVJqcC3+Bu4bbqjZO9/U5VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793295009;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=74gBWRt7WtLpCuOuHi792FTVea5VELP18N+2xYhOiBw=;
	b=efXwLDEn2qRoL+LmvrxkR9CXhiPYFmtzrlOh5nuhvXATiHd1r7ycGkUcnQBRclJWTKKg
	 Ez80/jr0Xm4osqkqxItbET07vBVnJ8qKVz3gmEnqk58Lgrg2sCQziynBebwfQWajc2U1q
	 ac/vf+GVSCR+4zFV67vLpsd9SZXnayzhZrI+NnDHx++1TCP09uoX4GvrHYo0QldOEhKnA
	 R2t64I7HkbG/34ZtRsD7FamMVLhh43uUD5oQaeyk0INkj9ZdaFmbtXA1eNbtdidQpfZ8w
	 99K+s4yeOLbnxl5rA20eNlgCZ6VwSGTXi9aWdxfwDSqhNmvuU2IEGyP5xx9Pnmd/LOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vlE7YCUk;
	arc=none smtp.remote-ip=95.215.58.171
Received: from mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB29606A320
	for <linux-efi@vger.kernel.org>; Thu, 29 Oct 2026 17:30:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DB29606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vlE7YCUk
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=MYWB4yKYU3wamhVGzDfXOfnneQtLbPsY49kJbIwQCX0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793295005; v=1; x=1793899805;
 b=vlE7YCUkXd3612qrpE2Q4jETXeA7ZxK5A/P0k9sfX+Ip5mOP32HD90gE+B2sI/iiFuffNFep
 7+XL2w1wZQ0UmcpXM/ow0Mut/D32YcyiR3advKwEPIiaHTY0yqS7swFS+RkYFW3zmZydxHB/XKw
 V33v16m+l43DjsInf4BZDvKU=
X-Envelope-To: linux-efi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cb79ae80c03f3ace;
	Thu, 29 Oct 2026 17:30:03 +0000
X-Mizu-Trace-ID: cb79ae80c03f3ace
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	chenhuacai@kernel.org,
	ardb@kernel.org,
	shuah@kernel.org
Cc: ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	ruirui.yang@linux.dev,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: [PATCH v6 0/8] LoongArch: Add KHO support and selftests
Date: Fri, 30 Oct 2026 02:29:47 +0900
Message-ID: <20261029172956.20791-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: George Guo <guodongtai@kylinos.cn>

This series enables Kexec HandOver (KHO) on 64-bit LoongArch and adds
LoongArch to the KHO and liveupdate QEMU selftests.

KHO has to give the next kernel two addresses: the KHO FDT and the
bootmem area list. arm64 and riscv put them under /chosen in the boot
FDT, and x86 puts them in setup_data. LoongArch systems that boot with
EFI and ACPI have no boot FDT, so this series passes the addresses in a
Linux EFI configuration table:

  - On a cold boot, the LoongArch EFI stub installs the table, zeroed.
    Kernels started by kexec are given the same EFI system table, so
    they find the same table.
  - In early boot, the kernel reserves the table and calls
    kho_populate() if the table holds KHO state.
  - Just before kexec, the kernel writes the KHO state of the image it
    is about to run, or zeroes the table if that image has none, for
    example a crash kernel.

A kernel started by kexec from a kernel that did not install the table
has no table and cannot pass KHO state on, so LoongArch turns KHO off at
boot in that case.

Patch 1 adds the table, and patch 2 writes it at kexec time. Patch 3
fixes a kho_block.c build failure with CONFIG_KFENCE=y on LoongArch.
Patch 4 adds kho_disable(). Patch 5 lets the LoongArch memblock
arrays grow, which restoring many preserved regions needs, and patch 6
enables KHO on LoongArch. Patches 7 and 8 add LoongArch to the KHO and
liveupdate vmtests.

The series is based on liveupdate-7.4 and depends on "liveupdate: kho:
calculate per-node bootmem sizes before allocating any" [1]. Without
it, the KHO vmtest fails on a 1 GiB LoongArch guest because KHO cannot
reserve its bootmem areas.

Tested in QEMU: the KHO vmtest passes on LoongArch with both
CONFIG_NUMA=n and CONFIG_NUMA=y, and run-vmtests.sh passes all four
liveupdate tests on x86_64, aarch64 and loongarch64.

Changes since v5:
  - Drop CONFIG_EFI_KHO. Only the LoongArch stub installs the table,
    from efi_boot_kernel(). The other code is built with CONFIG_EFI and
    does nothing when there is no table (Pratyush).
  - efi_kho_update() returns 0 when there is no table, so kexec on other
    architectures is not affected.
  - Warn if the table cannot be mapped in early boot (Pratyush).
  - Document each member of struct linux_efi_kho_data and drop __packed
    (Pratyush).
  - Rename efi_kho_table_phys to efi_kho, mark it __initdata, and join
    wrapped lines (Huacai).
  - Rename kho_sync_channel() to kho_update_efi_table(), and stop
    calling the table a "channel" or "transport" (Mike, Pratyush).
  - New patch 4: turn KHO off at boot on LoongArch when the table is
    missing.
  - New patch 5: allow the memblock arrays to resize on LoongArch. The
    liveupdate luo_stress_files test overflowed the reserved array in
    the next kernel when CONFIG_SMP was not set.
  - New patch 8: add LoongArch to the liveupdate vmtest.
  - Rename scratch to bootmem, following Pratyush's rename series.
  - Drop the luo_session history from patch 3's commit message
    (Pratyush).
  - Capitalize the subjects and use the kho: prefix (Huacai).
  - Rewrite the cover letter and commit messages (Mike, Pratyush).
  - Rebase onto liveupdate-7.4.
  - No Assisted-by tags, although my v5 reply said patches written with
    LLM help would carry one: the Assisted-by references have since been
    removed from the documentation in mainline.

[1] https://lore.kernel.org/all/20261029103425.14689-1-dongtai.guo@linux.dev/

v5: https://lore.kernel.org/loongarch/20260904100852.26006-1-dongtai.guo@linux.dev/
v4: https://lore.kernel.org/loongarch/20260807103714.33074-1-dongtai.guo@linux.dev/

George Guo (8):
  efi: Pass KHO state to the next kernel in a configuration table
  kho: Write KHO state to the EFI table at kexec time
  kho: Include linux/mm.h in kho_block.c
  kho: Add kho_disable()
  LoongArch: Allow memblock arrays to resize
  LoongArch: Enable kexec handover (KHO)
  selftests/kho: Add LoongArch vmtest support
  selftests/liveupdate: Add LoongArch vmtest support

 arch/loongarch/Kconfig                        |  3 +
 arch/loongarch/kernel/setup.c                 | 19 ++++++
 drivers/firmware/efi/efi.c                    | 68 +++++++++++++++++++
 drivers/firmware/efi/libstub/efi-stub.c       | 22 ++++++
 drivers/firmware/efi/libstub/efistub.h        |  2 +
 drivers/firmware/efi/libstub/loongarch.c      |  2 +
 include/linux/efi.h                           | 40 +++++++++++
 include/linux/kexec_handover.h                |  3 +
 kernel/crash_core.c                           |  6 ++
 kernel/kexec_core.c                           |  5 ++
 kernel/kexec_internal.h                       |  8 +++
 kernel/liveupdate/kexec_handover.c            | 35 ++++++++++
 kernel/liveupdate/kho_block.c                 |  1 +
 tools/testing/selftests/kho/loongarch.conf    | 11 +++
 tools/testing/selftests/kho/vmtest.sh         |  3 +-
 .../selftests/liveupdate/config.loongarch64   |  5 ++
 .../selftests/liveupdate/run-vmtests.sh       |  4 +-
 tools/testing/selftests/liveupdate/vmtest.sh  | 14 +++-
 18 files changed, 247 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/kho/loongarch.conf
 create mode 100644 tools/testing/selftests/liveupdate/config.loongarch64


base-commit: 9a6a70aefe77f6fb9ff2b3037dcf87f6dff65c8c
prerequisite-patch-id: 433e6f8fdec5151f12221a0a34f8fb111b95bb46
-- 
2.53.0

