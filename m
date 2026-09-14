Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB9063D6CB6;
	Mon, 14 Sep 2026 13:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789393927; cv=none; b=sEis6oStUEdQLsLxv1TlbV81UA4KuTwhDWEmQRoVLK35sRtmsW1d5OPiVHLRIrEVlQsg/rFJX5saaeVKym/SSwp0LjoOe57I0wES8a2K9cJri95LtdcddN6xw0M14yyFxGXC7aqvaTPyttBwUENWv1RMNSw2su/4rT4EYjkWQZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789393927; c=relaxed/simple;
	bh=8bcmJRzDVb4V3IZFLlLeumBeTAhSpAnT5L10Em+D5OE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=gLcr5acbPFNkfiXlyyn7IRUn99/eu+00xUaAeCHRaS8Ze03E9hBUJ+EaX0UizP17Un8krM9QkUq7UwgtoFDwW+swmGFavQip/dASKdcWBADNvlpSMHEynDD+0vSiZDJTZUGFqANW4o8eNTupn9+emLYceWwnJ91VMY9mRITMjf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Tk+RZPyw; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Tk+RZPyw"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 741FB1570;
	Mon, 14 Sep 2026 06:52:01 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D203E3F882;
	Mon, 14 Sep 2026 06:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789393925; bh=8bcmJRzDVb4V3IZFLlLeumBeTAhSpAnT5L10Em+D5OE=;
	h=From:Subject:Date:To:Cc:From;
	b=Tk+RZPywSSvl3bQ1edKhmEVBmo8RzAH7Qc5AZ04G0FWVQoL1uB6jo76WbFghq8tLT
	 Bh11TN1PblPVURJeW05SCe/mV9ww2hDTyRxTgOtUOziFsLhEE0FYtkiV6Ckg2mcu/S
	 SUNuZxyGBkb4FupTF3a5LT3fgJ+c6Euuof10W8mM=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH 0/6] arm64: distinguish HW PTE pointers from SW PTE value
 pointers
Date: Mon, 14 Sep 2026 14:51:30 +0100
Message-Id: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOL7p2oC/yXOQQqDQAwF0KsMWXckUaytq96jSBk1tlMYtRMtB
 fHujbrL/4SXLCAcPQuUZoHIXy9+6DXQyUDzcv2TrW81Q4rpGa9EdpwYHy4G21FdtF3RYJ0T6Po
 YufO/nbpXR478mVWcjhICi7hdLM3hYUaYIaYJqX3Jr5bsLC64xPXvOdz0TNIMYdNrJ2x1Dn4qz
 f7D1kC1rn/5OF0MwwAAAA==
X-Change-ID: 20260911-pte0_arm-f1b7df7c0b51
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>
X-Mailer: b4 0.16.0

Hi,

The generic series introduces hw_pte_t for HW PTEs, while SW PTE values
use pte_t. This series enables the distinct type on arm64 so the
compiler can distinguish HW PTE pointers (hw_pte_t *) from SW PTE value
pointers (pte_t *).

The conversion updates HW PTE pointers and accessors, including atomic
updates, fixmap, and early page-table construction, before selecting
ARCH_HAS_HW_PTE_T. Higher-level entry types remain out of scope, and
shared helpers retain explicit casts.

The linked generic series is a prerequisite. Its cover contains the
Coccinelle script used for most pointer conversions; the remaining sites
were converted by hand.

Link: https://lore.kernel.org/all/20260903103002.1091859-1-usama.anjum@arm.com/
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Muhammad Usama Anjum (6):
      arm64: use hw_pte_t for HW PTE pointers
      arm64: use hw_pte_val for HW PTE atomics
      arm64: convert between HW PTEs and SW PTE values
      arm64: use hw_pte_t for fixmap HW PTEs
      arm64: use HW PTE accessors in early map_range()
      arm64: enable a distinct type for HW PTEs

 arch/arm64/Kconfig                |   1 +
 arch/arm64/include/asm/hugetlb.h  |  19 ++---
 arch/arm64/include/asm/pgalloc.h  |   2 +-
 arch/arm64/include/asm/pgtable.h  | 157 ++++++++++++++++++++------------------
 arch/arm64/include/asm/vmalloc.h  |   2 +-
 arch/arm64/kernel/efi.c           |   3 +-
 arch/arm64/kernel/pi/map_kernel.c |   4 +-
 arch/arm64/kernel/pi/map_range.c  |  20 +++--
 arch/arm64/kernel/pi/pi.h         |   3 +-
 arch/arm64/mm/contpte.c           |  49 ++++++------
 arch/arm64/mm/fault.c             |  11 +--
 arch/arm64/mm/fixmap.c            |   8 +-
 arch/arm64/mm/hugetlbpage.c       |  48 ++++++------
 arch/arm64/mm/kasan_init.c        |   4 +-
 arch/arm64/mm/mmu.c               |  46 ++++++-----
 arch/arm64/mm/pageattr.c          |   4 +-
 arch/arm64/mm/trans_pgd.c         |   4 +-
 include/linux/pgtable_types.h     |   6 ++
 18 files changed, 215 insertions(+), 176 deletions(-)
---
base-commit: ead700ca770c82167af32622cf8b68c9f87c3c7c
change-id: 20260911-pte0_arm-f1b7df7c0b51
prerequisite-message-id: 20260903103002.1091859-1-usama.anjum@arm.com
prerequisite-patch-id: 0114fcc6ab0dbb739b5bb6fc0fe6b1c8f1fa37a1
prerequisite-patch-id: 09fcf65970074620dd3a9cce6850b901beb01db8
prerequisite-patch-id: 9b2fdab97c99effabb85526fa7f141c933b3aa23
prerequisite-patch-id: 1aa309a26d98a1e93a54742705a03567ee93be71
prerequisite-patch-id: ebe32f52c95ad0542982f0b37798d209595e25e1
prerequisite-patch-id: a60d249f52d092524176851b2570d7245bb24434
prerequisite-patch-id: 81ebd1378e25d40a1771b53973abcc4defa87535
prerequisite-patch-id: d982f2b00c5eddb2459f69008a73e4f4ae4d8299

Best regards,
--  
Usama

