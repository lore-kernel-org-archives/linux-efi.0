Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E843368A9;
	Fri, 16 Oct 2026 12:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792152979; cv=none; b=CIxmZockNBMcI7shcCPdF6rt7jSIhMV2lnGoLdqVAIQjCBKUbxWk8bAWN4Whdd76fzHzUXVQSjvlLpECVxI/tdZD0dDlN2VF4PWcBGuhKXD+yLYHNtQnbY9jscgeuMRK4QcfYda5OYXLtjTooEUMa4QCM/W3qSn7B20S4amAkAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792152979; c=relaxed/simple;
	bh=1k93cf5MKhVkjcQvTNw5WBZH+bZNWNPY9aOVyzZGhGg=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=CPHHlAKHqk6ixpNTH3s1EtGo09mbh5TkflRsgmE6WUQrEilJPfNAmbP5GEepo2hF0I2c95HUAv6tqZpRQdUePD1Cl1Io2xTFXIueysvSH80Vugtrzt3aBywCG29D2J7rjOBtBsiiLOYoOvHcMuvKFfcgzwORMjkWefoD7KwxBaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=hv7m4yJY; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="hv7m4yJY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=SMyeb0TPlDp+5iGy2w5sWmOpqn+etT9xkF8lgFC0TDs=; b=hv7m4yJYlURQ1VtfxsKUORkx6h
	pJXdsK+wxLc2Rktrbe0UkzwU3W6wdbudYsscRi5+TwnC7kie1BOtMdciPC0Bn16QAIoYEHmB50Shz
	PkSB3XR4IYmfqGqCOben2xQK/soQSslY/0+vOlhreElevT3sfvzmAs7Riv77o7xlhWI3TJUWPvTGk
	WH92WdsfIrKXongtQevT8r2/l4xi+pXCWHxnG7loG6qJShOdMu7h5Vnuf+bbk5gty/Yd+Y6gGvUon
	ja7TI5IwyCj6kMb0xpzvHdU7GRaBqTzW0YTBTwNNoNgRmYfDTZXPOTkRUzWHpH3liqarbX/ELuMyA
	JtYmBbUA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xHgqq-005xSX-2c;
	Fri, 16 Oct 2026 12:15:57 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v6 0/7] mm/memory-failure: keep hardware-poisoned pages out
 of the next kexec
Date: Fri, 16 Oct 2026 05:15:40 -0700
Message-Id: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAG0V0moC/2XMy2rDMBBA0V8Rs/YUvUayvOp/hC70ciwKVrCDm
 xL878XpIom9vXDuHeY8lTxDx+4w5aXMpY7QMdMwiIMfzxlLgo6B5NJwIyUOP5da5jri91Cxjy4
 F6ZNvg4eGwWXKfbk9dqevhsFQ5mudfh/3RWz1f2SFfR8tAjm6SDl5IuFc+5lyKH78qNMZttMin
 7qVYqclciSrlXUi6zabg1av2uy0Qo6mty7qYDiFeND6qR13O62RoyKnhCKjtaODphctaKdp0yF
 aTzYk4upNr+v6Bygm+LyhAQAA
X-Change-ID: 20260622-hwpoison-kho-fc9db2ada8ba
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, kas@kernel.org, 
 kexec@lists.infradead.org, Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 shakeel.butt@linux.dev
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, harry@kernel.org, kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=18436; i=leitao@debian.org;
 h=from:subject:message-id; bh=1k93cf5MKhVkjcQvTNw5WBZH+bZNWNPY9aOVyzZGhGg=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq0hV0jhzREAd0G3imvy+BI0XnQ3zytR24P/ADe
 ELNXcy20D6JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCatIVdAAKCRA1o5Of/Hh3
 bSybEACJ0PVwseZx4etiu8nccgq1mAMfz+y25yA1zStrlp07djejaQTCmKYOH3kpA+nwfPSUrGP
 vbPv4uR0T3+eX04uBaJwZIvzqIpn48YZ7vi94vqIhft9QTW9mu08a2FFw6J3jQMnEnKvKGRhX4O
 bmrLwZNtRNsgQjW4J0qSOflBPX2U1KzhLUsZB1cLB7zjzkVCcw1sEInf90ruWGztUSBiWQTF/jS
 nM2glb03vIIcH2mtDIQJtHjgqZTPftOG6HTnGlN+YsR6MPGkaUmVM6/Bbwue7feZDhHlHvYp42I
 +0nq6Mi64x74cxinEYAdVLh5hz5VX5QvYhXOuXu/MrriWbRO3eOWfIp7OT6a9GtU785wySFCl6K
 6No8lxXAg3Fk90o+HCy48JjcJyLnGYlTyTyGeJw2kc2rL2UOLt87fG44V7c9naYCv2x5pKiKcLf
 am2XiGMNcu8tjyPfXXhqhmXsGRCOmASlX+eSmvNctVipnhkK3ziAmkXxgZdSaoWL3G0DQn8CWWY
 g2EOh/miM8bpYu3gGeYUUUHfS59xpMP7q4Q9bNHGx2U9GSVF/o8c7JXACk9Y4nyRPMBMJqQyymL
 qd9ENa6Jq4Men/sXG9naf1jshVAYQDKtSXdZsNJcWlEzs+UBsVW++PXD3yAN1gvLFWg2bHnwAAp
 y3AR3nHxSNW6w9A==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

Problem:
========

When a page is hard-offlined due to an uncorrectable memory error (multi
bit ECC), memory_failure() sets PG_hwpoison, unmaps it, removes it from
the buddy allocator. This information is not carried to the next kernel
that is kexec'd. The kexec'd kernel then trips over that bad memory
bank _again_.

Why now:
========

Several industry trends make this increasingly important:

    1) DRAM is getting more expensive
    2) soldered / on-package memory (LPDDR, HBM) is becoming more common, so a
       failing part can no longer simply be swapped;
    3) memory is kept in service far longer (at Meta, DRAM lifetime is being
       drastically extended).
    4) It is more and more common to kexec instead of full reboot
    5) Increase of memory per system with CXL

What was done already:
======================

To deal with the problem above, I have already fixed a few things in
this area:

1) Panic on unrecoverable errors, instead of "printk and carry over":
https://lore.kernel.org/all/20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org/

2) Respect poisoned memory at kexec time
https://lore.kernel.org/all/20260812-kexec_posioned-v6-0-e477887086f0@debian.org/

Now, the natural follow up is to carry the poisoned memory information
to the next kexec kernel, avoiding tripping over a known "bad page".

Proposed Solution:
==================

Carry the poisoned frames to the next kernel in a new EFI configuration
table, LINUX_EFI_POISONED_MEMORY.

The table is a bitmap with one bit per 2MB of physical memory, modeled
on LINUX_EFI_UNACCEPTED_MEMORY. The stub sizes it from the EFI memory
map and installs it empty while boot services are up -- a running kernel
cannot install a configuration table, it can only flip bits -- and a
table that an earlier stub run in the same firmware session installed
is reused as-is. That is one fixed-size allocation, 64KB per TiB of the
span the memory map describes, with no list to grow at runtime and no
chain to trust at parse time.

The mechanism is architecture independent, so x86 and arm64 use the same
code.

Each hard offline sets the bit for its unit. Soft-offlined pages are not
recorded: they are still functional, and were offlined predictively.
Errors injected by software (MADV_HWPOISON, hwpoison-inject) are not
recorded either: they are not hardware faults.

The next kernel takes the table into use from efi_config_parse_tables().
It vets the inherited header and reserves the table's own pages in
memblock.

Then, once the architecture has reserved the kernel image and the
initrd, it reads the bitmap once and reserves every recorded unit in
memblock with a new MEMBLOCK_RSRV_HWPOISON flag. On x86 and arm64 this
runs before the page tables and the memmap are allocated, so memblock
cannot hand a recorded unit to an early allocation, and it never frees
one to the buddy allocator.

memmap_init_reserved_pages() then flags the frames of those units
PG_hwpoison, initializing their struct pages through init_deferred_page()
where that initialization is deferred. They end up in the state a frame
poisoned by this kernel would be in, so everything that already
understands PG_hwpoison covers them -- including the kexec segment
placement check from the series linked above, which keeps the segments a
kexec places off these frames. From there on the memmap is the only
source of poisoned frames: nothing reads the bitmap again.

The memory block poison counter is seeded from the memmap when a block is
created at boot, behind num_poisoned_pages.

Granularity is the trade-off: one bad 4KB frame costs a whole 2MB unit in
every later kernel of the chain. In exchange, a row or column fault --
roughly a quarter of the DRAM faults reported in [1], and potentially
thousands of 4KB pages scattered over gigabytes -- collapses into a bit
or two.

A bit is never cleared, which is a known limitation: it stands for a
whole unit, so an unpoison of one frame cannot tell whether the unit as a
whole is good again.

Known limitations:
==================

In order to keep this patchset digestible, I am making some trade-offs,
thus, this feature has the following limitations:

  - Memory hot-added after boot is not covered: the bitmap spans the RAM
    the EFI memory map describes, and a frame above it is not recorded.
    Same gap the unaccepted-memory table has.

  - The bitmap spans the descriptors that are write-back cacheable or
    unaccepted memory. On x86 the stub also reports loader, boot services
    and conventional memory without EFI_MEMORY_WB as RAM, so such a
    descriptor at either end of RAM falls outside the bitmap and its
    frames are not recorded.

  - A recorded unit that overlaps a reservation made before the units are
    reserved, the kernel image or a kexec segment for one, is flagged only
    where that reservation leaves it free, and the overlap is logged. A
    kexec segment was placed around the bad frames, so the frames it
    leaves free include them. A unit that is covered entirely is skipped
    with a warning.

  - The reserved array cannot be resized when the table is parsed, so
    memblock_reserve_hwpoison() keeps 32 slots free for the reservations
    that follow and skips the units that do not fit, with a warning.
    Adjacent units share a slot.

  - Memory preserved across a KHO handover is not covered.
    kho_preserved_memory_reserve() reserves it after the units are
    reserved and marks it MEMBLOCK_RSRV_NOINIT, so
    memmap_init_reserved_pages() skips it and a recorded frame there is
    not flagged. The frame goes back to the allocator once the owner
    releases it.

  - On x86 the next kernel picks its own physical address again.
    choose_random_location() draws from the memory map and does not know
    about the table, so KASLR can land the kernel image on a recorded
    frame. arm64 does not re-pick; the outgoing kernel fixes the address.

  - An inherited frame keeps its direct map entry. On x86 the MCE handler
    calls set_mce_nospec() next to memory_failure(), and nothing replays
    that half here, so the frame is out of the allocator but still mapped
    writeback. set_memory_*() needs the allocator to split a large page,
    so this wants a later pass.

  - On a host with SME active the frames are not recorded: the stub writes
    the table in the clear, so reading it back there needs a decrypted
    mapping. Parsing an inherited table is not affected. Mapping the table
    decrypted is follow up work.

  - The CMA patchset is being worked by Shaikh Kamaluddin
    https://lore.kernel.org/all/20261010162017.62506-1-shaikhkamal2012@gmail.com/#t

All of the limitations above can be fixed in follow up work. I am trying
to keep this patchset the foundation, with that work done on top.

The series is seven patches:

  1. Add the table: Defines the EFI table: GUID, Kconfig symbol, and
     a bitmap with one bit per 2MiB.
  2. Install it from the stub: The EFI stub allocates the table at boot,
     sized from the memory map, installed empty.
  3. Flag an inherited frame: Adds a helper flagging an inherited frame
     PG_hwpoison, counting it in the global counter and the managed pages,
     and disabling unpoison.
  4. Memblock flag: Adds a memblock flag keeping poisoned ranges from
     allocators and buddy, and marking frames PG_hwpoison.
  5. Memory block counter: Seeds each memory block's poison counter from
     the memmap at boot, only when poison exists.
  6. Reserve the inherited units: Reads the inherited table once at boot
     and reserves every recorded 2MiB unit in memblock.
  7. Record poisoned frames: Records each hard-offlined frame's unit in
     the table, so the next kexec'd kernel reserves it.

This was initially discussed at
https://lore.kernel.org/all/ajut_LDQGYCShApx@gmail.com/

A special thanks to Kiryl and David, for feedbacks and suggestions.

[1] https://arxiv.org/abs/2408.15302

To: Ard Biesheuvel <ardb@kernel.org>
To: Ilias Apalodimas <ilias.apalodimas@linaro.org>
To: Miaohe Lin <linmiaohe@huawei.com>
To: Naoya Horiguchi <nao.horiguchi@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: rmikey@meta.com
To: kas@kernel.org
Cc: riel@surriel.com
To: kexec@lists.infradead.org

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changes in v6:
- Rework the consumer along the lines David Hildenbrand described: read the
  bitmap once, at parse time, and reserve each recorded unit in memblock
  with a new MEMBLOCK_RSRV_HWPOISON flag. memmap_init_reserved_pages()
  flags the frames PG_hwpoison, so the memmap is the only source of
  poisoned frames from then on. memblock never allocates from a unit or
  frees it to buddy, which also keeps early allocations off it (David)
  * This was discussed in the MM alignement meeting/thread as well.
- Drop the __free_pages_core() hook, the accept-and-free refactor under it
  and the range query. Nothing queries the bitmap after parse time (David)
- Seed the memory block poison counter from the memmap, behind
  num_poisoned_pages, instead of walking the bitmap (David)
- Record a hard error on a frame that was soft-offlined earlier: the hook
  moves ahead of the MF_MSG_ALREADY_POISONED statistics guard (Sashiko)
- Do not count inherited frames in the per-node memory failure statistics:
  this kernel handled no failure
- Reject a table whose units would run past the address space
- Do not record on a host with SME active: the table is written in the
  clear and needs a decrypted mapping
- Do not record errors injected by software (MF_SW_SIMULATED): they are
  not hardware faults, and a recorded bit is never cleared
- Map the table with memremap() for recording instead of using the direct
  map, which mem= and a crash kernel's usable range trim on arm64
- Reserve the table's pages without adding them to memblock.memory: they
  are no longer read through the direct map, and with mem= the extra
  region made a CONFIG_DEBUG_VM kernel warn
- Treat an inherited frame as a hardware failure, so unpoison_memory()
  cannot free it, and count it as managed so that memory offlining adds up
- Link to v5: https://patch.msgid.link/20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org

Changes in v5:
- Free the part of the block that is not recorded instead of dropping the
  block whole: the leftover frames were neither buddy nor poisoned nor
  offline, so they leaked and left the block impossible to offline
  (Sashiko)
- Count inherited frames into the memory block when it is created.
  memblk_nr_poison_inc() cannot run that early, and unpoisoning a frame
  whose block counter was never incremented wrapped it to ULONG_MAX,
  which then refuses memory_block_online() for good (Sashiko)
- Keep the caller's end in range_contains_poisoned_memory() when the
  start is clamped up to phys_base, rather than shifting the whole window
  past what was asked about (Sashiko)
- Reject an inherited table whose footprint wraps the address space,
  which fed a negative range to memblock_add() (Sashiko)
- Say in patch 2 why the native bitops are safe: EFI_STUB && 64BIT is
  little-endian everywhere (Sashiko)
- Split the accept-and-free tail of __free_pages_core() into its own
  preparation patch at the head of the series, so the replay patch can
  reuse it without carrying a rework of that function
- Split the replay itself into the page flag helper, the memory block
  counter and the __free_pages_core() hook, one per subsystem it touches
- Split adopting an inherited table from recording into it: the parse-time
  plumbing and the memory_failure() hook are unrelated pieces of work
- Put the memory block counter ahead of the __free_pages_core() hook, so
  no revision in the middle of the series flags a frame the counter does
  not know about
- Size the bitmap from the descriptors that become RAM rather than from
  every descriptor in the map, which v4 argued for. Both architectures
  gate on EFI_MEMORY_WB, so spanning that plus EFI_UNACCEPTED_MEMORY
  stays wider than either accepts on its own while leaving out the MMIO
  apertures. On a 5G guest the table went from 65536 to 320 bytes
- Link to v4: https://patch.msgid.link/20260909-hwpoison-kho-v4-0-359313564495@debian.org

Changes in v4:
- Poison the inherited frames from __free_pages_core(), as each block
  reaches the buddy allocator, instead of walking the bitmap once from
  mm_core_init(): with CONFIG_DEFERRED_STRUCT_PAGE_INIT most struct pages
  are not initialised there and the poison was silently lost (Kiryl)
- Hand the table's pages to memblock at parse time, the way
  8dbe33956d96 does for the unaccepted memory table; it is ACPI reclaim
  memory and touching it through the direct map faulted
- Add phys_base to the table, so a machine whose RAM starts high does not
  pay for the hole below it (Kiryl)
- Size the bitmap from every descriptor in the memory map rather than a
  descriptor-type list, which was x86-only reasoning (Kiryl)
- Drop the max_pfn clamp on the inherited bitmap size (Kiryl)
- Drop the stale memblock.h include (Kiryl)
- Link to v3: https://patch.msgid.link/20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org

Changes in v3:
- Poison the inherited frames from mm_core_init() instead of reserving
  them in memblock, so everything that keys off PG_hwpoison sees them,
  the kexec segment placement check included (Kiryl)
- Reserve nothing in memblock: the page flag is enough, and reserving
  per unit that early runs into the fixed region array (Kiryl)
- Drop the 1MB cap on the table and the unit coarsening that went with
  it (Kiryl)
- Size the table from the memory types arm64 turns into RAM as well, not
  just the set setup_e820() maps to E820_TYPE_RAM (Kiryl)
- Make CONFIG_EFI_POISONED_MEMORY unprompted, so it is on wherever its
  dependencies allow and nobody has to decide (Kiryl, Pratyush)
- Fold the top-of-RAM helper into its only caller and make it static,
  rather than adding a generic libstub API
- Fold the table build and its installation into one patch
- Spell out the known limitations in this cover letter
- Link to v2: https://patch.msgid.link/20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org

Changes in v2:
- Replace the growable linked list of 4KB entries with a fixed-size
  bitmap, one bit per 2MB, modeled on the unaccepted-memory table (Kiryl)
- Record hard offlines only, by hooking action_result() instead of
  num_poisoned_pages_inc(), which also fires for soft offline (Kiryl)
- Allocate the table as EFI_ACPI_RECLAIM_MEMORY, so it is not System RAM
  in the next kernel, and reuse an inherited table instead of installing
  a second one
- Validate the geometry of an inherited table before using it
- Cap the table at 1MB, coarsening the unit instead of growing it
- Restrict to 64-bit, as the unaccepted-memory table effectively is
- Never clear a bit: an unpoison no longer un-records the unit
- Split the table definition and the stub installer into separate patches
- Link to v1: https://patch.msgid.link/20260717-hwpoison-kho-v1-0-9c5eda551998@debian.org

To: Ard Biesheuvel <ardb@kernel.org>
To: Ilias Apalodimas <ilias.apalodimas@linaro.org>
To: Miaohe Lin <linmiaohe@huawei.com>
To: Naoya Horiguchi <nao.horiguchi@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Thomas Gleixner <tglx@kernel.org>
To: Ingo Molnar <mingo@redhat.com>
To: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@linux.intel.com>
To: x86@kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
To: Brendan Jackman <brendan.jackman@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
To: Oscar Salvador <osalvador@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rafael@kernel.org>
To: Danilo Krummrich <dakr@kernel.org>
Cc: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: harry@kernel.org
Cc: linux-cxl@vger.kernel.org
Cc: driver-core@lists.linux.dev
To: shakeel.butt@linux.dev

---
Breno Leitao (7):
      mm/memory-failure: efi: add the LINUX_EFI_POISONED_MEMORY configuration table
      mm/memory-failure: libstub: install the poisoned-memory EFI table
      mm/memory-failure: add hwpoison_boot_page() to flag an inherited frame
      mm/memblock: add a reserved-region flag for poisoned frames
      drivers/base/memory: count the poison a block already holds when creating it
      mm/memory-failure: efi: reserve the inherited poisoned-memory units
      mm/memory-failure: efi: record hardware-poisoned frames into the poisoned-memory table

 arch/arm64/mm/init.c                           |   3 +
 arch/x86/kernel/setup.c                        |   3 +
 arch/x86/platform/efi/efi.c                    |   3 +
 drivers/base/memory.c                          |  30 +++
 drivers/firmware/efi/Kconfig                   |   8 +
 drivers/firmware/efi/Makefile                  |   1 +
 drivers/firmware/efi/efi.c                     |   8 +
 drivers/firmware/efi/libstub/efi-stub-helper.c | 103 +++++++++++
 drivers/firmware/efi/libstub/efi-stub.c        |   1 +
 drivers/firmware/efi/libstub/efistub.h         |   6 +
 drivers/firmware/efi/libstub/x86-stub.c        |   2 +
 drivers/firmware/efi/poison.c                  | 243 +++++++++++++++++++++++++
 include/linux/efi.h                            |  24 +++
 include/linux/memblock.h                       |  10 +
 mm/internal.h                                  |   5 +
 mm/memblock.c                                  |  80 +++++++-
 mm/memory-failure.c                            |  61 ++++---
 17 files changed, 567 insertions(+), 24 deletions(-)
---
base-commit: a9d7ced84989ec05be09b4b8428759ef60450a0f
change-id: 20260622-hwpoison-kho-fc9db2ada8ba

Best regards,
--  
Breno Leitao <leitao@debian.org>

