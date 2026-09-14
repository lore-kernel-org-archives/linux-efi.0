Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20276473C67;
	Mon, 14 Sep 2026 13:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789393948; cv=none; b=tND/xHe7vESYXvTBA+BG6mBHWVLkIN02gmF+Vbud+gTm9xTjwYnVrpuBlbxVdTMu/CjjWan5ou/TgI4f5eu/rQn+RPDQNGT1MQb8FUNzEfR8hA3FPRk37xzaGyH1ff/gI8Hv4JshBHvoz2eTVdtTfCJF9ru1ZXRdqtLF62MOtps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789393948; c=relaxed/simple;
	bh=e4ntXcUDjdHd2MfAB02Vr1Et9b59XeXUsYWhphwiZL0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AV6dvD2WoW2DfeTv/TOj4IHxClYfeL3eVBUHSafIZHOFeXcPw2Az8GY9ZQ/UBIOUmYWb91+yLkjxMBDlwfOiH5L1xVASFj07Ll9VQUKTf+Nhvb915hVsR+OGxKsKzH2/qDmtSMXyeHO8TjFKxn/xHrm/4kpjMYZnDujtO2i5nrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gHy6581v; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gHy6581v"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E6DC61570;
	Mon, 14 Sep 2026 06:52:22 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4FC283F882;
	Mon, 14 Sep 2026 06:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789393946; bh=e4ntXcUDjdHd2MfAB02Vr1Et9b59XeXUsYWhphwiZL0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=gHy6581v3Osy62vEgipfLO7U9hGflqXQ1eCPuqXwQrCBqd/7/OFx2bCOuwhgz4k3E
	 ZnsOLh53E6Jlr+SeHyB3quPKCabxE0k+Qxa0dkfRIjMVgipHmzQYWXIFYq3OLPXMss
	 Mc8NOBq/1UzJG/ibmkDVamAsZWuVXbHEJOWLMyeo=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Mon, 14 Sep 2026 14:51:36 +0100
Subject: [PATCH 6/6] arm64: enable a distinct type for HW PTEs
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-pte0_arm-v1-6-bb53b663e396@arm.com>
References: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
In-Reply-To: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
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

With HW PTE pointers and direct HW PTE accesses converted, arm64 can use
the generic hw_pte_t wrapper instead of the pte_t alias.

Select ARCH_HAS_HW_PTE_T to give HW PTEs and SW PTE values distinct C
types.

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

