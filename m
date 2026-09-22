Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAA58542809;
	Tue, 22 Sep 2026 17:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790098375; cv=none; b=pccKmagdozX2KLmB7/fpYhWqZ6OIcAgf8uD1PyYsUUOpYAKWqSgzyyIoRF5Y03JCCKQ6XoGef0UrYhbWRfR0bjzY560iXqS4xeUXDv8dTXWMqfp7vnI5RguTv2rVZFpn+dx87En1W2bfIpRlLdTwUWv1X2PnsebTpBciDbHv/as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790098375; c=relaxed/simple;
	bh=+Su2l1Ft0WBIXjZQ/cFjqH8CISUnq3bv3Vk6lON45EY=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=elHNiVOKzmzDQrep3yVP2k8cVwDNFxdJDE4ALJ1kFDIBkyTPnMWzg5a/kfj/mJKtPlnSg/pHBu9SGoWtH5x1g7JxbPnfIqxpvsDIsRrE7oGBUuYLXQceS0FRk3pwx1TF5nokjCL8qmnkiJ4WPQsnS0dST73Luwdjk6VuT4yiON4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CLvRHaG0; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CLvRHaG0"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 882C71576;
	Tue, 22 Sep 2026 10:32:46 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C8B23F86C;
	Tue, 22 Sep 2026 10:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790098370; bh=+Su2l1Ft0WBIXjZQ/cFjqH8CISUnq3bv3Vk6lON45EY=;
	h=From:Subject:Date:To:Cc:From;
	b=CLvRHaG0VyM0revKNsxvp8O1elOZLQpJ6DZ/UqshepIIeiFSTz9Cvbo1Bi1RsOx1U
	 8EaiMzAhvfYdAUN/o0PB9bBvwOXciKqWtNyWKjdw8/ifa495+DcTdpxoDTKvE9pwHx
	 DnO9RWv/nE2LTlquxhGKLaA4/gNOjwqqlKJzSX7Q=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH v2 0/6] arm64: distinguish HW PTE pointers from SW PTE
 value pointers
Date: Tue, 22 Sep 2026 18:31:55 +0100
Message-Id: <20260922-pte0_arm-v2-0-a3f1ddff0a8a@arm.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIy7smoC/0WP0W7DIAxFfyXieUwGFgx92n9M1QSOWXlI00IWb
 ary76N02t58Lesc35uoXDJXcRhuovCWa17OLeinQdApnD9Y5qlloUFb8ErJy8rwHsosk4o4JSS
 IoxLt/FI45a+Oejs+cuHrZyOuj6WYudbQiU3QeVp3ntyMBDlahOgoehj9azM80zLfwTFUlm2e8
 3oYOEwIQAERyGllMSSjrdaUXLSOfHJIhpDE/YVTrutSvnu5TfUffnu8/PfYVHPHOJporWHj7Z/
 7uO/7D/xl6R8hAQAA
X-Change-ID: 20260911-pte0_arm-f1b7df7c0b51
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Ard Biesheuvel <ardb@kernel.org>, 
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

Testing:
Testing was performed with and without the series on both x86_64 and
arm64. KUnit and the MM kselftests produced matching before-and-after
results problems or regressions. Fastpath performance testing was also
completed on arm64. No regression was found.

Link: https://lore.kernel.org/all/20260922-pte0-v3-0-5670b8cb9059@arm.com  
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes in v2:
- Move hw_pte_val() to the generic series and drop an unrelated comment
  change from the atomic-access patch.
- Use raw PTE values instead of generic HW/SW conversion helpers.
- Drop a comment and add testing resutls in the cover letter
- Add Reviewed-by tags.
- Link to v1: https://patch.msgid.link/20260914-pte0_arm-v1-0-bb53b663e396@arm.com

To: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
To: Ard Biesheuvel <ardb@kernel.org>
To: Ilias Apalodimas <ilias.apalodimas@linaro.org>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Alexander Potapenko <glider@google.com>
To: Andrey Konovalov <andreyknvl@gmail.com>
To: Dmitry Vyukov <dvyukov@google.com>
To: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: usama.anjum@arm.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org
Cc: kasan-dev@googlegroups.com

---
Muhammad Usama Anjum (6):
      arm64: use hw_pte_t for HW PTE pointers
      arm64: use hw_pte_val for HW PTE atomics
      arm64: use hw_pte_val for HW PTE loads and stores
      arm64: use hw_pte_t for fixmap HW PTEs
      arm64: use HW PTE accessors in early map_range()
      arm64: enable a distinct type for HW PTEs

 arch/arm64/Kconfig                |   1 +
 arch/arm64/include/asm/hugetlb.h  |  19 ++++----
 arch/arm64/include/asm/pgalloc.h  |   2 +-
 arch/arm64/include/asm/pgtable.h  | 157 ++++++++++++++++++++++++++++++++++------------------------------
 arch/arm64/include/asm/vmalloc.h  |   2 +-
 arch/arm64/kernel/efi.c           |   3 +-
 arch/arm64/kernel/pi/map_kernel.c |   4 +-
 arch/arm64/kernel/pi/map_range.c  |  20 +++++----
 arch/arm64/kernel/pi/pi.h         |   3 +-
 arch/arm64/mm/contpte.c           |  49 ++++++++++----------
 arch/arm64/mm/fault.c             |   7 +--
 arch/arm64/mm/fixmap.c            |   8 ++--
 arch/arm64/mm/hugetlbpage.c       |  48 ++++++++++----------
 arch/arm64/mm/kasan_init.c        |   4 +-
 arch/arm64/mm/mmu.c               |  46 +++++++++++--------
 arch/arm64/mm/pageattr.c          |   4 +-
 arch/arm64/mm/trans_pgd.c         |   4 +-
 17 files changed, 207 insertions(+), 174 deletions(-)
---
base-commit: ead700ca770c82167af32622cf8b68c9f87c3c7c
change-id: 20260911-pte0_arm-f1b7df7c0b51
prerequisite-message-id: 20260922-pte0-v3-0-5670b8cb9059@arm.com
prerequisite-patch-id: 0114fcc6ab0dbb739b5bb6fc0fe6b1c8f1fa37a1
prerequisite-patch-id: 09fcf65970074620dd3a9cce6850b901beb01db8
prerequisite-patch-id: 9b2fdab97c99effabb85526fa7f141c933b3aa23
prerequisite-patch-id: 1aa309a26d98a1e93a54742705a03567ee93be71
prerequisite-patch-id: ebe32f52c95ad0542982f0b37798d209595e25e1
prerequisite-patch-id: 22950028c3d2060de8acd3fe4a73d755b18215e3
prerequisite-patch-id: a60d249f52d092524176851b2570d7245bb24434
prerequisite-patch-id: 81ebd1378e25d40a1771b53973abcc4defa87535
prerequisite-patch-id: d982f2b00c5eddb2459f69008a73e4f4ae4d8299

Best regards,
--  
Usama

