Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC343B6C0C;
	Tue, 15 Sep 2026 12:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789476853; cv=none; b=Tk6IS9L0cy0Crni7yhLWodQV9u0Ca496ImWHIhxVQvs+tQ4RmucUkFKJe1Mma6+fY/lpaS4KDLCBggDC0hWq/N1NjKekVMvEWi9AHqIvZuI3UodhIatTYuJ1PvP2n2HmJCbquD/yn7zmBmIK6M8C1dBnCAXLfYH7NxYWdZ4xvAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789476853; c=relaxed/simple;
	bh=dYSNhP+ZS+ffftSzmlHLXr0gc4H25T3o72l/Lg5rrdA=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=j7Chajvjy9kuZ/HHUa01YFP5q6TWeceu5GniUH7HUbIhJ4TV+E7GFb+j1o2h9g0zjqy3tPgaynkP2NESEl81dBki60yOoslAFFb52pvITQwqVJf4ZIPMWA3xZyLfViYpXQy9HYFKske9SCxbQvBeC2hfVbz8KPhrcWBMZzZkNZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=D0MrxDb/; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="D0MrxDb/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=meJXk3BBE4ExulRfRgnMMcUKW2wDV0BMkxctXpihjYE=; b=D0MrxDb/Y8O2qYzsco73xHCh4r
	F/M6OZp9v0lmch3i2XJ9HVTE+aYU7aUkBa8O5c2fD3E+0Ss/R4NI9pNwLGGvNDll+5c2jF6GTC5W5
	LwdGVPAvboObncD2YmmqTCLME2ZHfrSMCe+Ruc3K1BOvsvCpa0gKQQMT/pD1cSy/CLhN6dmfAlOF8
	CPbz12D66OKWaogfjO4R05WljmbUHjaBbH4+xv8fu/6yPBZ/AoX7QkcsxMfdAzXn6780zYohlOJnm
	CG0ZtLCrSmPAkDkSttS+Zs65viqHpY25L4R0MWnc1c56zHkvKOZ+HgqQdWowVJQq5EctFNWoLDO7k
	mbsDBSpQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x6Sfd-004P5Q-1G;
	Tue, 15 Sep 2026 12:53:58 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v5 0/9] mm/memory-failure: keep hardware-poisoned pages out
 of the next kexec
Date: Tue, 15 Sep 2026 05:53:34 -0700
Message-Id: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAM4/qWoC/2XMy2rDMBBA0V8Rs/YUveXxqv9RutDLsShYQSpuS
 /C/l6SLNM72wrkX6LmV3GFiF2h5K73UFSZmBgZx8espY0kwMZBcWm6lxOXrXEuvK34sFedIKUi
 f/Bg8DAzOLc/l+7Z7ex8YLKV/1vZzu2/iWv9GTrjH0SaQI0WTkzdGEI2vKYfi15faTnA9bfKuR
 ykOWiJH47RyJLIes33S6r+2B62Qo50dRR0sNyE+aX3XxOmgNXJUhpRQxmpN5kHv+/4LLzD/yGM
 BAAA=
X-Change-ID: 20260622-hwpoison-kho-fc9db2ada8ba
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
 kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 hannes@cmpxchg.or, shakeel.butt@linux.dev
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, harry@kernel.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=15428; i=leitao@debian.org;
 h=from:subject:message-id; bh=dYSNhP+ZS+ffftSzmlHLXr0gc4H25T3o72l/Lg5rrdA=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqqT/eoLuJmRdxMi2ImNcJza3zPptYxBlLhNTWK
 M5ulW0rWAyJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaqk/3gAKCRA1o5Of/Hh3
 bX6jD/9RKmndNAiqtjRBmjhMXiIB31kOV7A6duMfwg1eQ4Y9XZQ7q/GGAF6MxM/PClirNgC97qw
 XRHE3cmv6+7qIq8MJ9Ku+/gGoL51pBusAla+U+0iy8vgdqZxe3N0ndM5YfE3vTUMk3G2YfVaMH7
 HM+fBhDufF0NHlNTnWWGHO2eS+HWdKkSu8pprbxvI0k+EKHR8aAyT9DkgGT3feW2Jt4p+7ci4F+
 KplHJindU30OdCGifAGNciEhkgiBApSmItnoasMZmB6QqY4gyM8NmgKnJMg8Eiw+N4voUSI3dan
 8qV5hmar0PewRPez5JSTd2fAQH4giK5D9q0N2EWYTrsmnm3WkHBk3qx3dztIB5TfArhKkgXVcdH
 RTXXI4aOmAT7D/Kopnpv9t3s5FdGR0plcbk1owG3UpF4UtHF+EmLNrZhMMKQ7hCAB3m5oChSvsZ
 73fEfiuYcbNywUk/yuESeD0nBlx7jQy4CL0LuGRyWKO9B3iLB1yhLzuAUZ227C/G2YcD+jcKJA3
 aL0TWbMnD3rZefq3TDUVkmaAq+4h4bUVBRl2speyjdl6bqpD5kqdTEfAkHOk5rZiuEBwluBftEE
 LtyYjAXmzNj0uQYs+7pwY7CbR08KqI+OpZmbvHYPtuq2ibkExdyO1zdUGRy7RkB1a5dXWZ6/K3i
 jBFM+iMelMIxCcQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

Problem:
========

When a page is hard-offlined due to an uncorrectable memory error (multi
bit ECC), memory_failure() sets PG_hwpoison, unmaps it, removes it from
the buddy allocator. This information is not carried to the next kernel
that is kexeced. The new kernel kexecs and trip over that bad memory
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

In order make linux deal better with the problem above, I've done
already fixed a bunch of stuff in this area, such as:

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
table inherited from an earlier boot is reused as-is. That is one
fixed-size allocation, 64KB per TiB of the span the memory map describes,
with no list to grow at runtime and no chain to trust at parse time.

The mechanism is architecture independent, so x86 and arm64 use the same
code.

Each hard offline sets the bit for its unit. Soft-offlined pages are not
recorded: they are still functional, and were offlined predictively.

The next kernel takes the table into use from efi_config_parse_tables(),
which vets the inherited header and hands the table's pages to memblock.
It is EFI ACPI reclaim memory, which x86 leaves out of memblock and so
out of the direct map; the unaccepted memory table is handled the same
way for the same reason.

The frames themselves are poisoned in __free_pages_core(), as each block
reaches the buddy allocator. That is the one point every producer passes
through -- memblock_free_pages() early, deferred_free_pages() once the
deferred struct pages are up, and generic_online_page() at any later
hotplug -- and it is already where the unaccepted memory table is
consulted. The recorded frames are held back and the rest of the block is
freed, so they never enter the allocator instead of being taken back out
of it. They end up in the state a frame poisoned by this kernel would be
in, so everything that already understands PG_hwpoison covers them --
including the kexec segment placement check from the series linked above,
which keeps the segments a kexec places off these frames.

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

  - Memory preserved across a KHO handover is not covered.
    kho_preserved_memory_reserve() marks it MEMBLOCK_RSRV_NOINIT, so
    memmap_init_reserved_pages() leaves those struct pages uninitialised,
    and a frame there is neither free nor PageReserved when the bitmap is
    applied. Its record is dropped, and the frame goes back to the
    allocator once the owner releases it.

  - Without a memblock reservation, early boot can allocate over a
    recorded frame before the flag is applied, and the memmap or page
    tables may end up sitting on it.

  - On x86 the next kernel picks its own physical address again.
    choose_random_location() draws from the memory map and does not know
    about the table, so KASLR can land the kernel image on a recorded
    frame. arm64 does not re-pick; the outgoing kernel fixes the address.

  - Only memory that reaches the allocator through __free_pages_core() is
    covered. Memory memblock hands over reserved and something else frees
    later is not: CMA areas are freed from cma_activate_area(), and init
    memory and the initrd from free_reserved_pages().

  - On a confidential computing guest the frames held back can still be
    accepted. accept_memory() rounds a request up by one unit, so freeing
    the last clean frame of a block accepts the bad unit next to it.

  - An inherited frame keeps its direct map entry. On x86 the MCE handler
    calls set_mce_nospec() next to memory_failure(), and nothing replays
    that half here, so the frame is out of the allocator but still mapped
    writeback. set_memory_*() needs the allocator to split a large page,
    so this wants a later pass rather than __free_pages_core().

All of the limitations above can be fixed in follow up work. I am trying
to keep this patchset the foundation, with that work done on top.

The series is nine patches:

    1) factor the accept-and-free tail out of __free_pages_core()
    2) add the LINUX_EFI_POISONED_MEMORY table
    3) size, build and install it from both stub entry paths
    4) adopt an inherited table at parse time: vet the header and hand its
       pages to memblock so it can be reached later
    5) record poisoned frames into it from the memory_failure() path
    6) answer whether a range covers a recorded frame
    7) count inherited frames into their memory block when it is created
    8) add the helper that flags an inherited frame
    9) apply the table from __free_pages_core(), as each block reaches the
       buddy allocator

This was initially discussed at
https://lore.kernel.org/all/ajut_LDQGYCShApx@gmail.com/

A special thanks to Kiryl Shutsemau, for feedbacks and suggestions.

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
To: hannes@cmpxchg.or
To: shakeel.butt@linux.dev

---
Breno Leitao (9):
      mm/page_alloc: factor out the accept-and-free tail of __free_pages_core()
      mm/memory-failure: efi: add the LINUX_EFI_POISONED_MEMORY configuration table
      mm/memory-failure: libstub: install the poisoned-memory EFI table
      mm/memory-failure: efi: adopt the inherited poisoned-memory table
      mm/memory-failure: efi: record hardware-poisoned frames into the poisoned-memory table
      mm/memory-failure: efi: answer whether a range is poisoned
      drivers/base/memory: count inherited poisoned frames into the block
      mm/memory-failure: add hwpoison_boot_page() to flag an inherited frame
      mm/memory-failure: keep inherited poisoned frames out of the buddy allocator

 arch/x86/platform/efi/efi.c                    |   3 +
 drivers/base/memory.c                          |  35 ++++++
 drivers/firmware/efi/Kconfig                   |   8 ++
 drivers/firmware/efi/Makefile                  |   1 +
 drivers/firmware/efi/efi.c                     |   8 ++
 drivers/firmware/efi/libstub/efi-stub-helper.c | 103 +++++++++++++++++
 drivers/firmware/efi/libstub/efi-stub.c        |   1 +
 drivers/firmware/efi/libstub/efistub.h         |   6 +
 drivers/firmware/efi/libstub/x86-stub.c        |   2 +
 drivers/firmware/efi/poison.c                  | 149 +++++++++++++++++++++++++
 include/linux/efi.h                            |  22 ++++
 include/linux/mm.h                             |  21 ++++
 mm/memory-failure.c                            |  29 +++++
 mm/page_alloc.c                                |  53 +++++++--
 14 files changed, 431 insertions(+), 10 deletions(-)
---
base-commit: a9d7ced84989ec05be09b4b8428759ef60450a0f
change-id: 20260622-hwpoison-kho-fc9db2ada8ba

Best regards,
--  
Breno Leitao <leitao@debian.org>

