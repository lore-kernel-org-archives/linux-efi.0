Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B46473C93;
	Fri, 21 Aug 2026 10:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787306828; cv=none; b=p4NsybA8nSTaoE0hFlS4FteeZgAUPltcvCFm6An8JpoY1+X2fzmWfJhwaiipGGD7lLJdlcfoW8ek86iydn/8UB1HzDM85IPVqTUn+++C/4iywtT+eNkuXKJr+7XtNSuOByhr+bz5DqYp8HiY9wZnJGLBfFLWWMUZJtASym30pSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787306828; c=relaxed/simple;
	bh=IhL9GgBO2hAIgOdl7Kbn9jq1kWSJaGfIHt9nwTEdyWQ=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=r4sCYHyfGMVr/iiBhVK1ICe/F8a4fNNOpAxEQ/SUkeH5KnEQ79sHK1BFLO39XXLiArWxcUcSjMj2hZDlyG+pzplmg6qtGLbtQspfZkrjjjVquJBoQ4wxKZbC93b0cptViCuEatSvnPHF3+On+GqMmI2Jl2g3dAFb9xhEcKW5rk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=rpDyyExh; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="rpDyyExh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=KH+sv+9sUWAZcKM+nxSCuKtzFi2uZkPnsx03LNTjwYw=; b=rpDyyExhDdsHBTZcCwTFYvChrg
	pJYvGGThjVRX4M5AE4tZjTrUJ0T/AcphWhldNtSh2LyEkI4G4pmFoEIonJkmdo3IPnuL9ozlbwxvV
	cqZYiTh6DiAvjTcRUEN5yoO/O3t0meIcFqOZH/cbIKPDpCOzx0hq69qfzwLt5Q2fAKAmTANlWggss
	Xjwstm9a2uX1V5uWRiCD/Gj8ntCoQLdJSHBH158BpgiOaa+I/tAqknPCLmDArE/bUmE22SukoqVlP
	h2qtdQbEB/j2JnKH3N2geAMbfJd87xhRb5nzFGvki8HhhFGoG2OWkpFMQ+lAMjQBJhTjPfyRsEs+j
	lAhOKQfQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wxM8k-00BGB4-2K;
	Fri, 21 Aug 2026 10:06:23 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v2 0/6] efi: mm/memory-failure: keep hardware-poisoned
 pages out of the next kexec
Date: Fri, 21 Aug 2026 03:06:00 -0700
Message-Id: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAkjiGoC/1XMsQ6DIBAA0F8hN0sjJKg49T8aB4RTLk04Aw1tY
 /z3pnbq+oa3Q8FMWGAUO2SsVIgTjEI3Anx0aUVJAUYButVd22kt43NjKpzkPbJcvA2zdsENs4N
 GwJZxodfZ3aZGQKTy4Pw+96q++ot61f9HVclWWm8wOGOUtcM14EwuXTivMB3H8QEc3KOfqQAAA
 A==
X-Change-ID: 20260622-hwpoison-kho-fc9db2ada8ba
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, kas@kernel.org, riel@surriel.com, 
 kexec@lists.infradead.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=6898; i=leitao@debian.org;
 h=from:subject:message-id; bh=IhL9GgBO2hAIgOdl7Kbn9jq1kWSJaGfIHt9nwTEdyWQ=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqiCMZSk9qLKjKMpjQ2izguFSZsT2d2M2dwIu7T
 spQ9H65rwCJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaogjGQAKCRA1o5Of/Hh3
 bRL8D/42XgX6AMJJnafaGOIqSinOguqJGUqHHnrusfgwD5mf5Ten9vKrlYr+718x5dXdJ6mkBzO
 6J+829uDKeAY1E6e9vWIrdcvgkeDUfYxZi6dzI9CUpOsLKHe/fXM8NclnWCUBA1mfy2ZlLt4KW/
 3Xv7SxOVOpWukTlDtbS9+VFQc5Sjg3fcy1QM5Pyzy6OhYDUvNCYqHtPuGGX/TdO2vk5cfKLVqUd
 yO2R32CfeLWmw1Gae1t1eL6wYXt5g8WVHC391xb4I8QZ1AXb2nj/X5sHTMBGLqB65gGD2KYCrNU
 kRZQArS4X1BF2TsiZEtZQZrTq712zldbvj/CbG9WxkFP1Ye/nr9bAI7gTI/2HG7EQqAV50DXBh+
 m92+rikxFUEVuD24xXQrlII7SuPjpRfhVolbBn7T7R7VPw+xgz5mRm0znNViFtwqLOWTq8e5TJg
 QfnwSAwvEIOS1wRCwKh7aYNCPEVTYxZnuv2fwDIHMkN+b679J2Z4bCxTS4SgyQfKFWd7xWDe8ja
 TM0V7uLQosMjbgnkh+SWfatM+lp+jPugEVKGlDTW9aP7EvTeJtLgJCPuuLPQ7BjxX0LYj/n/XN8
 +YInhCIVr83/OSUToVFi+XpxpEfZirPVb/4Fw6lHNiun0/uuVQomH6yK+33C47f9exrgCBAVQ7P
 ykwCDAOA9ji7BPA==
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

EFI configuration tables already survive kexec: firmware hands the EFI
system table to every kernel in the chain, so a table installed once is
seen by all successors without a new handover channel.

The table is a bitmap with one bit per 2MB of physical memory, modeled
on LINUX_EFI_UNACCEPTED_MEMORY. The stub sizes it from the EFI memory
map and installs it empty while boot services are up -- a running kernel
cannot install a configuration table, it can only flip bits -- and a
table inherited from an earlier boot is reused as-is. That is one
fixed-size allocation, 64KB per TB of RAM, with no list to grow at
runtime and no chain to trust at parse time.

The allocation is capped at 1MB, which covers 16TB at 2MB per bit. Past
that the stub doubles the unit rather than growing the table, so the
table stays bounded on any machine.

The mechanism is architecture independent, so x86 and arm64 use the same
code.

Each hard offline sets the bit for its unit. Soft-offlined pages are not
recorded: they are still functional, and were offlined predictively.

The next kernel walks the inherited bitmap early in
efi_config_parse_tables(), before memblock and the buddy allocator are
up, and memblock_reserve()s every unit whose bit is set. The bad RAM is
never handed out.

Granularity is the trade-off: one bad 4KB frame costs a whole unit --
2MB, or more on a machine large enough to have coarsened it -- in every
later kernel of the chain. In exchange, a row or column fault -- roughly a
quarter of the DRAM faults reported in [1], and potentially thousands of
4KB pages scattered over gigabytes -- collapses into a bit or two.

A bit is never cleared, which is a known limitation: it stands for a
whole unit, so an unpoison of one frame cannot tell whether the unit as
a whole is good again, and after a kexec there is no PG_hwpoison left to
consult either. Unpoisoning a frame does not hand its unit back to the
next kernel.

Memory hot-added after boot is not covered either: the bitmap spans the
RAM the EFI memory map describes, and a frame outside it is silently not
recorded.

The series is six patches:

    1) add a libstub helper for the top of usable RAM
    2) add the LINUX_EFI_POISONED_MEMORY table
    3) build the table in the stub
    4) install it from both stub entry paths
    5) record poisoned frames into the table from the memory_failure() path
    6) reserve the inherited frames before the allocator comes up

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
Cc: kas@kernel.org
Cc: riel@surriel.com
Cc: kexec@lists.infradead.org

Signed-off-by: Breno Leitao <leitao@debian.org>
---
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

---
Breno Leitao (6):
      efi/libstub: add a helper for the top of usable RAM
      efi: add the LINUX_EFI_POISONED_MEMORY configuration table
      efi/libstub: add the poisoned-memory EFI table
      efi/libstub: install the poisoned-memory table from the stub
      efi: record hardware-poisoned frames into the poisoned-memory table
      efi: respect the poisoned pages coming from previous kernel

 drivers/firmware/efi/Kconfig                   |  10 ++
 drivers/firmware/efi/Makefile                  |   1 +
 drivers/firmware/efi/efi.c                     |   8 +
 drivers/firmware/efi/libstub/efi-stub-helper.c |  89 +++++++++++
 drivers/firmware/efi/libstub/efi-stub.c        |   1 +
 drivers/firmware/efi/libstub/efistub.h         |   8 +
 drivers/firmware/efi/libstub/mem.c             |  53 +++++++
 drivers/firmware/efi/libstub/x86-stub.c        |   2 +
 drivers/firmware/efi/poison.c                  | 197 +++++++++++++++++++++++++
 include/linux/efi.h                            |  21 +++
 mm/memory-failure.c                            |   3 +
 11 files changed, 393 insertions(+)
---
base-commit: b8809969e1d7a591e0f49dd464a5d04b3cf02ab1
change-id: 20260622-hwpoison-kho-fc9db2ada8ba

Best regards,
--  
Breno Leitao <leitao@debian.org>

