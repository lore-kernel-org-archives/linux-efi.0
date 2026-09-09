Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E22E559CBF;
	Wed,  9 Sep 2026 13:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788959167; cv=none; b=eb7Y8k4Xp+G/xe+0qm5PRQf+hA2DerR29irgqlx6OqjFg53oM6P+cDAkCgqrC2nDe0o6cMUcZoW7W0qsZR9QpEeC2GdQgme65Q3VW/qiq5BX4ZtwRMu5JolTh4S5Rxi82AN+AHXjPsypo6p0klwROVwGAl9jwHp1ubJ2yzD24jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788959167; c=relaxed/simple;
	bh=G/5j7rsIscbBgBtneBLPilSXxmgZFKIcKtKDiTsarp0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=l+5juQVK6KqWxkaRt5MEuUj+8llusb4mb5Gz7ocJnAqnv6zujSmjQMA9K2PndbDJrcSFDAOfShB5SnsKHf/TIRCjjqcG8JjPE3rVASrKFdfwuUW3jXEVWo2nXbAqS2V8jRrGYqVu7Zy3UCMm9XGZ2lL0DoOswPAUZ+qSV0nu9g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=SCHv2xXp; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="SCHv2xXp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=YFlbwOUaTYTpmzRCwo3A4gN794fb+Hu6KI6v7Kc1WAo=; b=SCHv2xXpEY/t6LyYuHR2v0GOQ+
	WhzT9t5hmqeq/XQszVbAUaIqIQgPwEn7kN9V5EtI/rDx8aAO1VzTJ8U4EuN0D47XqELv5umpqzB5o
	I0aNkW05z7CR+VCt72cZgvOfPMVvw74GHvk1IJZkp1RC8HLvscxTeAgCGbvhccYP4A7eHgFgo+jar
	Nx3QqLLYglA34GdCrYdR2LQ8/yqIpLPXMGn7vLHZSEuYKq06oW4f05smMUpCmvZnMU7Rsnx67JBMJ
	NvYE/BwYDzfC0R7m01Kkk2ioW8xSTA5iYTN4QJO63G8gg4EjtpOja89C23iWXJRei3uDXRokI7rk7
	YaIG8BrA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x4Hzb-0034d0-0v;
	Wed, 09 Sep 2026 13:05:35 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v4 0/5] mm/memory-failure: keep hardware-poisoned pages out
 of the next kexec
Date: Wed, 09 Sep 2026 06:05:19 -0700
Message-Id: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAI9ZoWoC/2XMy4rDIBSA4VeRs84paqLGrOY9yiy8nDRSiEWHt
 CXk3Yd0FtPL9ofvX6FSSVRhYCsUWlJNeYaBdQ2DMLn5RJgiDAwkl5prKXG6XnKqecbzlHEMNnr
 pouu9g4bBpdCYbo/d8bthMKX6k8v9cV/EXv9GRpjX0SKQow2KolNKWNt/RfLJzYdcTrCfFvmve
 ynetESOynStsYK6nvSHbp+1ftMtctSjsaHzmisfXvS2bb9tZeAYJQEAAA==
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
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, harry@kernel.org, kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=12085; i=leitao@debian.org;
 h=from:subject:message-id; bh=G/5j7rsIscbBgBtneBLPilSXxmgZFKIcKtKDiTsarp0=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqoVmYl9SbuMuP5HAxzSTBwcLXjL7RVuKAhOYM4
 8yu4TlDU8uJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaqFZmAAKCRA1o5Of/Hh3
 bSBlD/9lyXRbwoaUVm+8hoQ4AGBuTiFce+sWIsQ6XIQagnb7NASp7qzUOeWpZ951HGxuHLag+2X
 +jDalCAoNwgkbl6kPXBb0jRpXqg2Jdj5aA5JYPkLbCpoQ/NlxKJGwRg0Un+x8iJ0QczcY03sKMi
 kDRcMfabcv4XGujBdhHW3P4yY24ZgieFng2lIOZeHPefpvh/6wsSqpjQKeGLDjVKdadhQ5NoKxN
 jD7/Iax41/lqW1bFYK+3bejhTktVn3OiZkiAfCArDe4wDMPFuOjZ9SVg5uxgGelhqzjpk7deB85
 1jip2gReEfTidWu2aUcUZm1AOpHkGenWeuB2hSPsUrfQRuLbaei9TwpPy9t50aW10/YWXcp6EvT
 G4H07cTR6ydYLx6I+VInD4cjwkGgycHghfxVBvPonhdB17unzVl9Szq6EOed6C0qSikiigbrYAA
 2d+vrezRXQLnarE6y+7FmgHGFqdYfR4omtqytX/ilw7J/GdnEkllIZlNgb9QVyZBPbklVsn+oUr
 rST+SRjE/crj0UlagVI8JTTDqSa8F+wvMaZ8HfF9cISMb1cZKW6cP+a2h7C34BOaCDCVypbie0r
 M71mO4d3fk0YMYlqj9eR1B3yJjjz/7XMzGpPaYZIgfqLroF6PJ/jq7lrkxGitoU3qNHrlww7+bH
 8pHWkQr67T24Ocw==
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
consulted. A block covering a recorded frame is dropped whole rather than
freed, so the frames never enter the allocator instead of being taken
back out of it. They end up in the state a frame poisoned by this kernel
would be in, so everything that already understands PG_hwpoison covers
them -- including the kexec segment placement check from the series
linked above, which is what keeps the next kernel image off these frames.

Blocks run up to MAX_PAGE_ORDER and a unit is 2MB, so dropping the block
writes off more than the unit itself, and MemFree falls by more than
HardwareCorrupted accounts for.

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
    recorded frame before the flag is applied. The frame does not reach
    the allocator afterwards, but the memmap or page tables may end up
    sitting on it.

  - The per memory block hardware-poison counter does not include
    inherited frames. memblk_nr_poison_inc() finds the block by pfn and
    memory_dev_init() has not built it yet, so the count is dropped and
    the block is later created reading zero. This is not a big deal,
    since I do not expect the kexeced kernel to try to unpoison the
    page that came from previous kernel. The only downside is the fact
    that kernel B will not have a proper counting of how many pages
    are poisoned (they will be invisible -- aka 0).

All of the limitations above can be fixed in follow up work. I am trying
to keep this patchset the foundation, with that work done on top.

The series is five patches:

    1) add the LINUX_EFI_POISONED_MEMORY table
    2) size, build and install it from both stub entry paths
    3) record poisoned frames into the table from the memory_failure() path,
       and hand the table to memblock so it can be reached later
    4) answer whether a range covers a recorded frame
    5) apply it from __free_pages_core(), as each block reaches the buddy
       allocator

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
Cc: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: harry@kernel.org

---
Breno Leitao (5):
      mm/memory-failure: efi: add the LINUX_EFI_POISONED_MEMORY configuration table
      mm/memory-failure: libstub: install the poisoned-memory EFI table
      mm/memory-failure: efi: record hardware-poisoned frames into the poisoned-memory table
      mm/memory-failure: efi: answer whether a range is poisoned
      mm/memory-failure: keep inherited poisoned frames out of the buddy allocator

 arch/x86/platform/efi/efi.c                    |   3 +
 drivers/firmware/efi/Kconfig                   |   8 ++
 drivers/firmware/efi/Makefile                  |   1 +
 drivers/firmware/efi/efi.c                     |   8 ++
 drivers/firmware/efi/libstub/efi-stub-helper.c | 100 ++++++++++++++++++
 drivers/firmware/efi/libstub/efi-stub.c        |   1 +
 drivers/firmware/efi/libstub/efistub.h         |   6 ++
 drivers/firmware/efi/libstub/x86-stub.c        |   2 +
 drivers/firmware/efi/poison.c                  | 141 +++++++++++++++++++++++++
 include/linux/efi.h                            |  22 ++++
 include/linux/mm.h                             |  19 ++++
 mm/memory-failure.c                            |  18 ++++
 mm/page_alloc.c                                |  25 +++++
 13 files changed, 354 insertions(+)
---
base-commit: a9d7ced84989ec05be09b4b8428759ef60450a0f
change-id: 20260622-hwpoison-kho-fc9db2ada8ba

Best regards,
--  
Breno Leitao <leitao@debian.org>

