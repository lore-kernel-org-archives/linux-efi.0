Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0003AEF2D
	for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 09:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911166; cv=none; b=DKLWwwC4dQsquchDPMSCHuXrNGvhmQGhwFBy8FMsoDsQraMn3BA/BubQN7/dkjVYMo14AtgtbUPdr7ifgySx0Zlw/NkzlSC0RFjlHq66oQVo0DyWmUHIXvkpDx3dvBK8Ia7oOVbo/8ryLR/hTNvrtNDWq60QaEylqwSYA+MMlak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911166; c=relaxed/simple;
	bh=UhRbffPHR4xaRrOY3SlHxBc36WXKGHb7cGdhs1/qzuo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=r0+4ZOfN3c+CaUUIIZtl0vvD8hIY5Jk4CN8/408nbToR+MAnXOFhLN0FqpLtFwahxwflPXYj7ADmLmvw1b50YAw7i8xT74dHrwtDlo+sJXB6U9X4BFEJUs/2SMx4DA9IynFWAveFGa0OBS2TsKkfyxvh0wfw29VLTQV82JIvmCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=akA6197h; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="akA6197h"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4839fc4cef6so18557665e9.0
        for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 02:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773911161; x=1774515961; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lqHnVRy+4N6H3/myt2w5WB+syGlQGLfAKUfJ5JisA6E=;
        b=akA6197hYivUcU40cQjGB/FCIMNdxWcfo2m8ddPhSsO5Ec7DtEhlvEaYOyRLgq21S8
         ZcmEhuzz7BeZUhHMyagZqDAszrSrJCquLRkTmV58LXV4yYYIILXLbRR8iD3gaF08SHDH
         P++fron2QrRuO5Va+n1LxY4cjxccJlr3iIl9HcTEZuH1VQCpt4Ur8bBK/TMsb4pNi90F
         fCQfCNCQ6xTyERqO2bXVIY60LW9CgH5l1/8igyy+l1naW7Vq1ApxhN74abuQQRJatpID
         bpXgawVq8CzyJYoCsWQ2xGBdx8QSLQ43Te8btDELHomr5XFnOQjwdm2yP0E0Nb3cAsEO
         EE6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773911161; x=1774515961;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lqHnVRy+4N6H3/myt2w5WB+syGlQGLfAKUfJ5JisA6E=;
        b=KeFP/NDe+cBxawMFENdy1RaACLZX+OwDKd/IQkIOeGlkOjMVTraDgy2OaCoQzE7Ctq
         rqj93orpJZcqB5lEonSt41Hepkfrgkj+d8atmlzrIENyzj9K9uKqBOhilQpehSd0aoc4
         MocjfMQNiUR0c3H8d5xMFnnEpHZyaYFsKuPWBzfmdncuTj1bOLofAaxSgwpGtyGlpXJD
         nd2xgP29y65Eh2VmsYSWDA7oSAaSgAxPSPOB5A2UaGy8jtdnQ0VqADILp4rVLZhG6SNh
         D+Ha9AuNB6frRlUJmLSHB/tDAazZtjO2M4xsQ02IsMqQAzBzonDdlh/N1cMEBCF3doty
         +G6A==
X-Gm-Message-State: AOJu0Ywlas2I0gECt69CzqqtsRn8iIihhd9ydPtugdg5VsCMs48GuIaO
	7jBjVNfUvgJ2ujqqq9zP1PhTxBv6MXmTNNacusnuZoMBZ5K6vWGMLycD/DxVB5TE1YVwem4W4g=
	=
X-Received: from wmqn21.prod.google.com ([2002:a05:600c:4f95:b0:480:4be7:3f3a])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b10:b0:486:f893:56c6
 with SMTP id 5b1f17b1804b1-486f8b46651mr40619935e9.10.1773911161203; Thu, 19
 Mar 2026 02:06:01 -0700 (PDT)
Date: Thu, 19 Mar 2026 10:05:30 +0100
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3964; i=ardb@kernel.org;
 h=from:subject; bh=C29TbN8FYL2Jar0q2tz+iaf8aS/IZ1gkOCU4Mq+Lfxw=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIXP3niiOGc2NXsfmsm5Y0/3iTymLFROHY+29qWY737dsb
 lPjUdnXUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACZypYKRYVefqlHtvJRMscsL
 V7CXaKu9vH7uxHZ35w2P7i98uGFyzwuGv/IaBi5zX5cutFSY/uTaa69XXhlbX5o57eKftargjde +bCYA
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260319090529.1091660-21-ardb+git@google.com>
Subject: [PATCH v2 00/19] efi/x86: Avoid the need to mangle the EFI memory map
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

At boot, x86 uses E820 tables, memblock tables and the EFI memory map to
reason about which parts of system RAM are available to the OS, and
which are reserved.

While other EFI architectures treat the EFI memory map as immutable, the
x86 boot code modifies it to keep track of memory reservations of boot
services data regions, in order to distinguish which parts have been
memblock_reserve()'d permanently, and which ones have been reserved only
temporarily to work around buggy implementations of the EFI runtime
service [SetVirtualAddressMap()] that reconfigures the VA space of the
runtime services themselves.

This method is mostly fine for marking entire regions as reserved, but
it gets complicated when the code decides to split EFI memory map
entries in order to mark some of it permanently reserved, and the rest
of it temporarily reserved.

Let's clean this up, by
- marking permanent reservations of EFI boot services data memory as
  MEMBLOCK_RSRV_KERN
- taking this marking into account when deciding whether or not a EFI
  boot services data region can be freed
- dropping all of the EFI memory map insertion/splitting logic and the
  allocation/freeing logic, all of which have become redundant.

Changes since v1:
- Also get rid of all reallocation logic, and just reuse the initial
  allocation throughout, and keep track of the number of valid entries
- Drop abuse of the EFI_MEMORY_RUNTIME flag
- Add acks from Mike to #1-#2

This v2 now gets rid of all manipulations of the EFI memory map except
for setting the virtual address field and suppressing unwanted entries.

Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Ard Biesheuvel (19):
  memblock: Permit existing reserved regions to be marked RSRV_KERN
  efi: Tag memblock reservations of boot services regions as RSRV_KERN
  x86/efi: Unmap kernel-reserved boot regions from EFI page tables
  x86/efi: Drop EFI_MEMORY_RUNTIME check from __ioremap_check_other()
  x86/efi: Omit RSRV_KERN memblock reservations when freeing boot
    regions
  x86/efi: Defer sub-1M check from unmap to free stage
  x86/efi: Simplify real mode trampoline allocation quirk
  x86/efi: Omit redundant kernel image overlap check
  x86/efi: Drop redundant EFI_PARAVIRT check
  x86/efi: Do not rely on EFI_MEMORY_RUNTIME bit and avoid entry
    splitting
  efi: Use nr_map not map_end to find the last valid memory map entry
  x86/efi: Only merge EFI memory map entries on 32-bit systems
  x86/efi: Clean the memory map using iterator and filter API
  x86/efi: Update the runtime map in place
  x86/efi: Use iterator API when mapping EFI regions for runtime
  x86/efi: Reuse memory map instead of reallocating it
  x86/efi: Defer compaction of the EFI memory map
  x86/efi: Do not abuse RUNTIME bit to mark boot regions as reserved
  x86/efi: Free unused tail of the EFI memory map

 arch/x86/include/asm/efi.h           |  15 +-
 arch/x86/mm/ioremap.c                |   6 +-
 arch/x86/platform/efi/Makefile       |   2 +-
 arch/x86/platform/efi/efi.c          | 247 ++++-------------
 arch/x86/platform/efi/efi_32.c       |  31 +++
 arch/x86/platform/efi/memmap.c       | 250 -----------------
 arch/x86/platform/efi/quirks.c       | 287 ++++++--------------
 arch/x86/platform/efi/runtime-map.c  |   4 +-
 drivers/firmware/efi/arm-runtime.c   |   2 +-
 drivers/firmware/efi/efi.c           |   4 +-
 drivers/firmware/efi/memattr.c       |   2 +-
 drivers/firmware/efi/memmap.c        |   8 +-
 drivers/firmware/efi/riscv-runtime.c |   2 +-
 include/linux/efi.h                  |  29 +-
 include/linux/memblock.h             |   1 +
 mm/memblock.c                        |  15 +
 16 files changed, 236 insertions(+), 669 deletions(-)
 delete mode 100644 arch/x86/platform/efi/memmap.c


base-commit: 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
-- 
2.53.0.851.ga537e3e6e9-goog

