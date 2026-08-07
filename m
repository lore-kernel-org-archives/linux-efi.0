Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8AB83DD86A
	for <linux-efi@vger.kernel.org>; Fri,  7 Aug 2026 10:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786099064; cv=none; b=ZQ/3yoqsBuhaoKzgUsE/vPN+ksMrydjZUFnBRubqpujrZpfhK5O4yJ4zP4gRF46t5oNLi+9C9GRpOMKom2/0r8b7liACNSx8MdDRvXisjTsVfMbcByL2TiYFyrRZGldHQciCy02az5Bt1MQxjuvNZXwRSz393IGHFDQAN3qo6xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786099064; c=relaxed/simple;
	bh=+9NMX/X3s7VxPcdjVvvpKj6PsqSVc1Z0Q5fvBvtwqb4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gwLWfYoTjUTf/zwrhZLcywGDVc6QjqNlhWA86cuRrjcpa/n5x5vHW6aAOcciXtPbHhJX3dJ/icUCRewrJCxb09LYTxOaPbM6e97/lprhIUjfbm0m5dILh2FaojR8uqo0VtC6an9SzWjQa62W/bOqq0MkNz9ijJKWDCiVccOyoew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WLPoKe7s; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WLPoKe7s"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786099058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=T8eUR9MkUG60eJZwmCZAPZdUpIwjYHZLD8FcPW9hHxQ=;
	b=WLPoKe7s1dubXiAmrOn/QUOvubfTBkfa0El+vYm0jaNP0r8ZVbkIgRUDAyINqUkRDJEe8Y
	J+HiF8MsfWjXy7RLn5mdtCbDGnmZAkDxiXBr0UnTbqUpb4vDFfLahzbrQ6g4KutgO4RYfY
	kn1sFGJtexHELzrKxrchUC6XOhAF4ms=
From: George Guo <dongtai.guo@linux.dev>
To: chenhuacai@kernel.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	shuah@kernel.org,
	ardb@kernel.org
Cc: guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: [PATCH v4 0/4] LoongArch: add KHO support and selftests
Date: Fri,  7 Aug 2026 18:37:10 +0800
Message-ID: <20260807103714.33074-1-dongtai.guo@linux.dev>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This series enables Kexec Handover (KHO) on LoongArch, making it the
third architecture (after x86 and arm64) to set
ARCH_SUPPORTS_KEXEC_HANDOVER.  That is the only remaining gate for Live
Update (LUO) to run on LoongArch.

The hard part is the transport: how the first kernel hands the KHO state
(the KHO FDT and the scratch region) to the second kernel across kexec.

Why not the command line or an FDT
----------------------------------

LoongArch boots from EFI, but unlike arm64 and riscv its efistub does not
build a boot FDT.  It passes the EFI system table and the command line
straight to the core kernel [1].  There is no /chosen node to carry the
blob, so the arm64 path (drivers/of/kexec.c:kho_add_chosen() writes
linux,kho-fdt and linux,kho-scratch; drivers/of/fdt.c:
early_init_dt_check_kho() reads them) does not apply.

Two earlier transports were tried and rejected:

  * v1 put the handover addresses on the kernel command line.  Pratyush
    found that odd and asked for a DT-based alternative.

  * v2/v3 synthesized an FDT and rewrote the DEVICE_TREE_GUID entry in the
    EFI config table so the generic FDT reader would find it.  Pratyush
    called that "even more hacky" than the command line [2].

The v4 transport
----------------

v4 follows the x86 setup_data idea, in EFI terms.  The first kernel packs
the KHO state into a small struct (linux_efi_kho_data: fdt addr/size and
scratch addr/size), appends a pointer to it under a dedicated
LINUX_EFI_KHO_TABLE_GUID entry in a new EFI config table, loads both as
kexec segments, and switches st->tables before jumping.  The second kernel
scans the config table for that GUID in setup_arch() and calls
kho_populate() directly.  This is the approach proposed in [3].

It addresses both objections: nothing is exposed on the command line, and
no FDT is synthesized.  It also meets Huacai's constraint: it reuses the
EFI system table LoongArch already has, with no dependency on a boot FDT
the efistub never creates.

Patch layout
------------

  Patches 1-2 implement the transport.  Patch 1 adds the EFI config table
  GUID and the handover struct to include/linux/efi.h.  It is split out so
  the EFI maintainers can review it on its own.  Patch 2 wires up the
  LoongArch side: ARCH_SUPPORTS_KEXEC_HANDOVER, the write side in
  machine_kexec_file.c, the st->tables switch in machine_kexec(), and the
  reader in setup_arch().

  Patch 3 is a build fix for kernel/liveupdate/luo_session.c that the
  series depends on under CONFIG_KFENCE=y on LoongArch.  It was sent
  standalone as v2 and acked by Mike.  It is folded in here at his request
  to send it along with this series [4].

  Patch 4 adds LoongArch vmtest support to the KHO selftests and folds in
  the two points Mike raised on v3 (use "VM" instead of the ad-hoc
  "virt machine"; run every architecture under timeout(1), not only
  LoongArch).

Patch 1 is aimed at the EFI tree.  Patches 2-4 are aimed at the LoongArch
and KHO trees.  I expect the whole series to go through the KHO tree with
Ard's and Huacai's acks.

Changes since v3
----------------

  * Rework the transport: drop the synthesized FDT and the
    DEVICE_TREE_GUID rewrite.  Pass the KHO state through a dedicated EFI
    configuration table GUID and call kho_populate() directly (patches
    1, 2).
  * Fold in the luo_session build fix (previously standalone v2, acked by
    Mike) as patch 3, at his request.
  * selftests: address Mike's v3 review (use "VM"; always run under
    timeout(1)).
  * Rebase onto v7.2-rc6.

[1] Huacai Chen: https://lore.kernel.org/r/CAAhV-H5B6Mj2-AffkstJ4f8EEmvvPOGXoDy2QNudKD2kSz2XkA@mail.gmail.com/
[2] Pratyush Yadav: https://lore.kernel.org/r/2vxzjyqzj8s2.fsf@kernel.org/
[3] https://lore.kernel.org/r/20260717071551.11904-1-dongtai.guo@linux.dev/
[4] Mike Rapoport: https://lore.kernel.org/r/ai5nYlbERQBXRHSp@kernel.org/

George Guo (4):
  efi: add a KHO configuration table GUID
  LoongArch: kexec: add KHO support
  liveupdate: luo_session: include linux/mm.h for virt/phys translation
  selftests/kho: add LoongArch vmtest support

 arch/loongarch/Kconfig                     |   3 +
 arch/loongarch/include/asm/kexec.h         |   7 ++
 arch/loongarch/kernel/machine_kexec.c      |  16 +++
 arch/loongarch/kernel/machine_kexec_file.c | 131 +++++++++++++++++++++
 arch/loongarch/kernel/setup.c              |  41 +++++++
 include/linux/efi.h                        |  24 ++++
 kernel/liveupdate/luo_session.c            |   1 +
 tools/testing/selftests/kho/loongarch.conf |  11 ++
 tools/testing/selftests/kho/vmtest.sh      |  22 ++--
 9 files changed, 249 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/kho/loongarch.conf

-- 
2.53.0

