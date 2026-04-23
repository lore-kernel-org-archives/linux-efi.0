Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A2E31DDBF
	for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 15:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957662; cv=none; b=GxR25QVZ1jmt6CcqCdhv7aaIo055c8iKgKo0te3cE3HW7tvMLKhfOw0zB43ZM5EUjudebP+GtsrzeRBfopZWi09I2WGQjM1Qa9oul5mzJEBTY7zsbAlEA00Kj2vpBpaMDxs+D7urprD666kaPLeil4DWQtvzyQ5JT9ll0VQRdcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957662; c=relaxed/simple;
	bh=kNDfe3oxfK44qlUVfVqsUFak5NvdX4VRjyFAxoJx+ZI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ozTf+cauu/4gUl31AZ9u8tC7S1wbHlrOX881oSlawwJlCH+7EwQ40+gfQwiioxGAm912FJEE6tgclJN9sDIz18T4yXfBpyXi6o3w4MsbvTKr1pew6/WpovBxA1wmBp13317+Wik4ulda+qmBOYh4HZGCBDFAZaQ+GiUGqR3bxnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IiGmpRen; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IiGmpRen"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b938cb02038so739322266b.0
        for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 08:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776957659; x=1777562459; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ho4OFmmurdXYucVXM7gVmg8MsOyxw1IoQDXU4fTVDCk=;
        b=IiGmpRenUP05QmmJ9G7/JmeXQTSmaHfqS2Ur9QkfJ8IWx9JHRbHDpCauoQSlfzsNeI
         ZkLwxcPx1Rm5zjC3QyQA33dIPNRLUJ/GTbQjYcm/FCRqeVum8Ty4G+lvlG/8wvy/APGh
         4UYo/ZVFpIhstQabiZBf5E12+/u73vBK8Z5tVmWzJbewrktpR7lzEEuB5wVVfxHzkeBd
         8DXrhE6kRaJ+dt3YRaII2bKUJhohuKNwNt+3XsB7y1FKW9qqoqVPRZgFYGU/maySNlPh
         LZi0F2PhlGVlIrIu7FZAmZj/aIbqfwnZqZBblQB8oxepzFJq9fTXrrqc9G15jXtPGBTX
         Lw4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776957659; x=1777562459;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ho4OFmmurdXYucVXM7gVmg8MsOyxw1IoQDXU4fTVDCk=;
        b=M7iOv9MUkkllJGENGKdtkNIBSVoKGmkOP/8ufGKvH6Gf3kvD6a+viADKS3fUgweWoK
         YBPgPhv1PgGx8XF07R/Pq/37+mw955jbZs+vz+AjTB9Xsa5G9yNtXxzSdJb6A2LHSZeB
         ky6Q5Sg/l6K01wSlLq7cOP/6QtVnN9Ct25D/91u372aGueRbSTw7VjDbsbmzlbIe69p+
         ZxvckYn3e/lZmoFFbuBxS65TCoG+yhnlnvpMfsMAVfUoqOI0nIGYSwdaBo/QQJDhii1h
         oqHyth2aFf6/97VtvdHopIhTkhaXHBVOQ6XASW8kiAO4ypfMEll8WTY84HD7+YSy93cS
         uTCw==
X-Gm-Message-State: AOJu0Yxmajm7FUTTNBbAWQ2yvGjXuxFgtZZd8ITiWA8mq4bbb0aJyOhl
	7N60xWzcuk+x4DtHwm+gEGMRm0KCuvBdKYeO0/nLP6eQA61LWGpB1ACOn/eQ0LpBQiNUB3u03A=
	=
X-Received: from edtw24.prod.google.com ([2002:aa7:cb58:0:b0:674:1f9e:8c89])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:86aa:b0:ba6:74bc:5604
 with SMTP id a640c23a62f3a-ba674cb9c38mr1049083266b.26.1776957659367; Thu, 23
 Apr 2026 08:20:59 -0700 (PDT)
Date: Thu, 23 Apr 2026 17:20:25 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=4266; i=ardb@kernel.org;
 h=from:subject; bh=bivaPju7+uHYSytUrGd7KpP4iG3xagwRlbVWOs0JmyM=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfOVxc5pzNe+T2X0nOQXuzi3V0hvxR955R1iX7d3LLm70
 ZbpY4NhRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZhIWjgjwxLVfQZPZsYc5E/5
 vD+m2WiPYs8KxfpVt3Iucacu5zV/dJuR4aJ4afAN27mB2pM8VXkZ287KH/ow586WQ5zzNaZNM9f 4yQcA
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423152024.1098465-19-ardb+git@google.com>
Subject: [PATCH v3 00/17] efi/x86: Avoid the need to mangle the EFI memory map
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Young <ruirui.yang@linux.dev>, 
	Gregory Price <gourry@gourry.net>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

At boot, x86 uses E820 tables (3 different versions!), memblock tables
and the EFI memory map to reason about which parts of system RAM are
available to the OS, and which are reserved.

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

Changes since v2:
- Avoid relying on memblock tables after those may have been freed
  already (spotted by Sashiko). Instead, tweak the ranges_to_free code
  added recently by Mike so that the array can grow arbitrarily, and
  carry multiple entries per EFI boot services data region.
- Fix use of the memory attributes table after kexec too, which is now
  feasible given that memblock_reserve()'ing EFI boot services memory is
  no longer broken - this supersedes [0]
- Drop memblock changes that were merged into 7.1-rc0 (formerly #1-#2)

Changes since v1:
- Also get rid of all reallocation logic, and just reuse the initial
  allocation throughout, and keep track of the number of valid entries
- Drop abuse of the EFI_MEMORY_RUNTIME flag
- Add acks from Mike to #1-#2

[0] https://lore.kernel.org/all/20260326132655.1733873-7-ardb+git@google.com/

Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Young <ruirui.yang@linux.dev>
Cc: Gregory Price <gourry@gourry.net>

Ard Biesheuvel (17):
  x86/efi: Omit redundant kernel image overlap check
  x86/efi: Drop redundant EFI_PARAVIRT check
  x86/efi: Only merge EFI memory map entries on 32-bit systems
  x86/efi: Defer sub-1M check from unmap to free stage
  x86/efi: Simplify real mode trampoline allocation quirk
  x86/efi: Unmap kernel-reserved boot regions from EFI page tables
  x86/efi: Drop EFI_MEMORY_RUNTIME check from __ioremap_check_other()
  x86/efi: Allow ranges_to_free array to grow beyond initial size
  x86/efi: Intersect ranges_to_free with MEMBLOCK_RSRV_KERN regions
  x86/efi: Do not rely on EFI_MEMORY_RUNTIME bit and avoid entry
    splitting
  efi: Use nr_map not map_end to find the last valid memory map entry
  x86/efi: Clean the memory map using iterator and filter API
  x86/efi: Update the runtime map in place
  x86/efi: Reuse memory map instead of reallocating it
  x86/efi: Merge two traversals of the memory map when freeing boot
    regions
  x86/efi: Avoid EFI_MEMORY_RUNTIME for early EFI boot memory
    reservations
  x86/efi: Drop kexec quirk for the EFI memory attributes table

 arch/x86/include/asm/efi.h           |  15 +-
 arch/x86/mm/ioremap.c                |   8 +-
 arch/x86/platform/efi/Makefile       |   2 +-
 arch/x86/platform/efi/efi.c          | 167 +++--------
 arch/x86/platform/efi/efi_32.c       |  31 +++
 arch/x86/platform/efi/memmap.c       | 247 -----------------
 arch/x86/platform/efi/quirks.c       | 291 +++++++-------------
 arch/x86/platform/efi/runtime-map.c  |   4 +-
 drivers/firmware/efi/arm-runtime.c   |   2 +-
 drivers/firmware/efi/memmap.c        |   8 +-
 drivers/firmware/efi/riscv-runtime.c |   2 +-
 include/linux/efi.h                  |  13 +-
 12 files changed, 197 insertions(+), 593 deletions(-)
 delete mode 100644 arch/x86/platform/efi/memmap.c


base-commit: 2e68039281932e6dc37718a1ea7cbb8e2cda42e6
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog

