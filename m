Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BFB3469EE;
	Wed, 26 Aug 2026 12:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787745887; cv=none; b=TroiN6CtB+JpO87kChdrFh+vjKciWPRYxh2ny3+IDeHZY2nJ60uIe8GinaHyhmoM1w9RWA8/U5hTrOapSGSP7wurgPSnCB7x4jSSe90araTkG2UQ3J3J55cfwTsQxVUJd3uPgrQ5esqUQxABhckL+wu61XpY+kCp39wqv8gsKyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787745887; c=relaxed/simple;
	bh=WCOJsPp/NC0CGsS/LKREsuX9We14eNeSVrhHInh9OUc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=ocXQ9jT5J76Gb/KGtMuUWBX/5Ng9P5FZsng1MfUava5nekUeY6cV3EOvv7c3z9rG2W4hq5Mpk8tOWn358L+Y7AmrC0GHknwOtaJlGPs5iym8CYQFdLT8DnWw6A6KZdUsMpecofxJnko1BbvSLn97h6fSzm0kswz93dfAdVvCI/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=T4ECihFZ; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="T4ECihFZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=qFwt/irMyfR5ULmWvclkAj2/vGaiBlcUVJujqDai+yg=; b=T4ECihFZoCE09PcK/JRkVVKZb0
	iuoSs5g2mJl8diNZJG9LFBtKgkw/CytBBtl3BGUFXugx4BFEbKSQh4xa0V4LAX4rtHs+YFI+71Opg
	xbSZL+5/PX4HwRxRvJc2NoXhuRWW7OALlqHfWbE05mykHXxCUYlhVB8bawQ2IfXid9BIAznbZjYsa
	hFWfpMN+05F5NXVu99BrG6lkyaoz49vA/eu6hkPWLsqh6B20i6dGC12TekZSJZE9ZxVzTio59icu0
	B3rHSHy04qcGnP1fBvsz1VyMtqck9pkkdGHjguX07LApdodjasx0oxoIbfyP/cfYi3NoKygIdqVWg
	48Ya+08Q==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wzCMq-00FCWf-1s;
	Wed, 26 Aug 2026 12:04:33 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v3 0/5] efi: mm/memory-failure: keep hardware-poisoned
 pages out of the next kexec
Date: Wed, 26 Aug 2026 05:03:51 -0700
Message-Id: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACfWjmoC/13M0Q6CIBSA4Vdh51oaoAh41Xu0LlCOwdrEQaOa8
 92bdtHs9t/+b4GMKWCGjiyQsIQc4gQdqSsCg7fTDWlw0BEQTLSsFYL65xxDjhO9+0jHwbheWGd
 1b6EiMCccw2vnLteKgA/5EdN71wvf6hdSXB2hwimjZpDorJTcGH122Ac7nWK6wSYV8bu14H+3o
 IxK1dTKcGw0tod7XdcPN30pQecAAAA=
X-Change-ID: 20260622-hwpoison-kho-fc9db2ada8ba
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
 kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=9956; i=leitao@debian.org;
 h=from:subject:message-id; bh=WCOJsPp/NC0CGsS/LKREsuX9We14eNeSVrhHInh9OUc=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqjtZKXYy6V5NbPLbnx8/fI4m8kehbnkkz2d/eO
 dftu0aMTrCJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCao7WSgAKCRA1o5Of/Hh3
 bUr8D/9GyjEUbvvfagt8beBTM7QD3weQE5WwkyA+6hy7jigvw8fReIB4TIMND1BunCY7T/Qoeop
 4/BJfzeTqHpILBbX/iyEsjzGotptgUzgHQMM5iihye/Hb+qpeGNsVK2actVoJKu/JS20zu+o1/k
 I9x1wXFwclvIH+Zg35pKwC5vFU7TLN3dPRyJQM/1kRqUfy9oLWjWltANcPsINnRsa2ChOfggOcg
 pEBD8HYA887MXBZBgOoJ+DerczeN5SWI0IdguV//KQXIsZOMdc0uv9pC28iqKpw9rxj1sAbh0gs
 eQXaAXF1/E0ByZlba70+jTtCLk8ARiB8LDnQPgfXFkvFmcNPZQXCQUaeKEyRVmjIVWt4ZRCG3+v
 v/z4dvtBjbkEiQopdXs07wLWQWgTQHMYig4OmIGy3fFH3XNr7FhqBbyDCBKwsAnbxmcCVMOxCJG
 rN+vc+V3aMCIPwlhcX62WfXjCqAnFxdAsdWkmk29DuJXVDn9uhjt+bGEVUIP8+1SIcB+W0Dkkmq
 crGATacmWCyDzOlTPCzQwbPmFBSc0Y1NWH2jugVJH1KObWRPv6xYd9qUQs5ofwJHfo6iNx4f5Y7
 CRUE9KVK4UgN3jFhWYkQBLWwYe0FAdWKC+fyDlTSqgSqz7i/NKCkCmAYGt0wVwcilIs6oKPSa1G
 MSjG9X5J74oa8zA==
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
fixed-size allocation, 64KB per TB of RAM, with no list to grow at
runtime and no chain to trust at parse time.

The mechanism is architecture independent, so x86 and arm64 use the same
code.

Each hard offline sets the bit for its unit. Soft-offlined pages are not
recorded: they are still functional, and were offlined predictively.

The next kernel poisons the inherited frames from mm_core_init(), right
after memblock_free_all(), the first point at which they have struct
pages. A frame that is free is taken off the buddy allocator; a frame the
kernel is already using is flagged where it is, and free_pages_prepare()
drops it if the owner ever hands it back. Either way it ends up in the
state a frame poisoned by this kernel would be in, so everything that
already understands PG_hwpoison covers it -- including the kexec segment
placement check from the series linked above, which is what keeps the
next kernel image off these frames.

Nothing is reserved in memblock. An earlier version did that from
efi_config_parse_tables(), but the page flag alone turns out to be
enough, and reserving per unit that early runs into memblock's fixed
region array before memblock_allow_resize().

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
    inherited frames, because memblk_nr_poison_inc() divides by
    sections_per_block and memory_dev_init() has not run yet. A block
    holding an inherited frame can therefore be brought back online, and
    HardwareCorrupted stays high after that memory is removed.

All of the limitations above can be fixed in follow up work. I am trying
to keep this patchset the foundation, with that work done on top.

The series is six patches:

    1) add the LINUX_EFI_POISONED_MEMORY table
    2) size, build and install it from both stub entry paths
    3) record poisoned frames into the table from the memory_failure() path
    4) add the mm helper that poisons one inherited frame
    5) walk the inherited bitmap
    6) apply it from mm_core_init()

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
Cc: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org

---
Breno Leitao (5):
      mm/memory-failure: efi: add the LINUX_EFI_POISONED_MEMORY configuration table
      mm/memory-failure: libstub: install the poisoned-memory EFI table
      mm/memory-failure: efi: record hardware-poisoned frames into the poisoned-memory table
      mm/memory-failure: add a helper to poison a frame at boot
      mm/memory-failure: efi: replay the poisioned page in the next kernel

 drivers/firmware/efi/Kconfig                   |   8 +
 drivers/firmware/efi/Makefile                  |   1 +
 drivers/firmware/efi/efi.c                     |   6 +
 drivers/firmware/efi/libstub/efi-stub-helper.c | 106 +++++++++++
 drivers/firmware/efi/libstub/efi-stub.c        |   1 +
 drivers/firmware/efi/libstub/efistub.h         |   6 +
 drivers/firmware/efi/libstub/x86-stub.c        |   2 +
 drivers/firmware/efi/poison.c                  | 237 +++++++++++++++++++++++++
 include/linux/efi.h                            |  21 +++
 include/linux/mm.h                             |   6 +
 mm/memory-failure.c                            |  33 ++++
 mm/mm_init.c                                   |   1 +
 12 files changed, 428 insertions(+)
---
base-commit: b8809969e1d7a591e0f49dd464a5d04b3cf02ab1
change-id: 20260622-hwpoison-kho-fc9db2ada8ba

Best regards,
--  
Breno Leitao <leitao@debian.org>

