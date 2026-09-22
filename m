Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D69F55C30D;
	Tue, 22 Sep 2026 17:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790098400; cv=none; b=AW0i/erb7U05yZWFnYvAmXN0oFszyHabXi8YCuyp3dPoCHZ1iev3MlRiz58poIzawmiAXRUH461p+5oahUFDWj/0RfdpsekY2ohSEXdogVXuc7XvWIFxSSbwm9wSWtNJNdCv0i88py10HI/hblhZtal2c61osiovKP9Wpv5c3NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790098400; c=relaxed/simple;
	bh=PeJQ7fYXLGcw4P0kvfY82twCI/k6VJB344U1K7tkEMM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MHr6VSwUWuL0nrikyk8x09865keW9lYaR69SbA/WCgiiA7E5TRe5MZuQj9GeL2SSTLPTonB1LZLn8XttUCao7ipD+rg8KTcEZK89eVZiOuJYUtLRcyBwNVphQH3Rue4Ifh29ffkfDnlVTrzxr3kh0o3p1rH1BA/Lv619p2oiL/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=d3xeuRYT; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="d3xeuRYT"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 49DA01AED;
	Tue, 22 Sep 2026 10:33:09 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 616B73F86C;
	Tue, 22 Sep 2026 10:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790098392; bh=PeJQ7fYXLGcw4P0kvfY82twCI/k6VJB344U1K7tkEMM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=d3xeuRYT+klOzNDSyNdM3rcbkRZj3fdN5cBa1D1YwCIZyxd+7f7Sy8BgbNUmU5al1
	 3s/0EsafMWeY/ZZrmT+pw9w6TaZJeLQe8kr+7niH1ZmkhigzCVK9Oe/kkhM5HFTKdQ
	 LdRNH7rjihzI3dDQ1qhnr2R8GM6p9/Ohat1pmPv0=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Tue, 22 Sep 2026 18:32:01 +0100
Subject: [PATCH v2 6/6] arm64: enable a distinct type for HW PTEs
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-pte0_arm-v2-6-a3f1ddff0a8a@arm.com>
References: <20260922-pte0_arm-v2-0-a3f1ddff0a8a@arm.com>
In-Reply-To: <20260922-pte0_arm-v2-0-a3f1ddff0a8a@arm.com>
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

With HW PTE pointers and direct HW PTE accesses converted, arm64 can use
the generic hw_pte_t wrapper instead of the pte_t alias.

Select ARCH_HAS_HW_PTE_T to give HW PTEs and SW PTE values distinct C
types.

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 arch/arm64/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 2bbeded33da0d..42841d5e2ed26 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -31,6 +31,7 @@ config ARM64
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_GIGANTIC_PAGE
+	select ARCH_HAS_HW_PTE_T
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_KERNEL_FPU_SUPPORT if KERNEL_MODE_NEON
 	select ARCH_HAS_KEEPINITRD

-- 
2.47.3

