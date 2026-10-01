Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C13B5511180;
	Thu,  1 Oct 2026 11:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790852907; cv=none; b=VDmc2nblp9dxepOpMWuTox3FUjywZu73qVdyuvg4KJrXSRxuLvJCC6L7qX9q1bYT0BUQ6sZuDtcLO/t5XfngieQj6bufQkK9wXpFoFgdu55ULqdd7ALzA78Vi23LVcNzfOYB1YnxG7l5ZENEAfo2t/C2ERpf6tULx0GTcSubqeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790852907; c=relaxed/simple;
	bh=756vPQ/U2HqARpKFmioH59ZHD/jvMRybv2zdUwtJ7QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uPmDN/Y0AfTl8vKtDyub/sHYswfWEFUul+sw5bIlb3JWSWogoHI6RWZsY/Po4JZbF5o/EVkZFF4jxXfHv6gVdKjeevjMglmbbAM7wUUV9HBkLsvE0dXB8YGrzeTP3WoD9g/Lia8CPr1Srzhc//zI+Wk+2J05auavjFb58cybGxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MgJCuqrw; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MgJCuqrw"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9D2A2497;
	Thu,  1 Oct 2026 04:08:21 -0700 (PDT)
Received: from e142392.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 750E13F959;
	Thu,  1 Oct 2026 04:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790852905; bh=756vPQ/U2HqARpKFmioH59ZHD/jvMRybv2zdUwtJ7QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MgJCuqrwOr1ieJjj6sTN2msgmjC7iS2oLeK438Q5jropr1Yl5jfrJSAMEPgnTiNkR
	 umFQXQ13adZTBLlsLVPKEJpmqvGA/q0vX8o4oIlZPyMbSKGmZXWph+RVvklWpuOxZk
	 F8cckDf8Ky4ID24zj41VzzzB1wX2wAiAesd7s9sc=
From: =?UTF-8?q?Kristina=20Mart=C5=A1enko?= <kristina.martsenko@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-acpi@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-efi@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [RFC 12/12] arm64: tlbid: Add documentation
Date: Thu,  1 Oct 2026 12:06:55 +0100
Message-ID: <20261001110655.461473-13-kristina.martsenko@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261001110655.461473-1-kristina.martsenko@arm.com>
References: <20261001110655.461473-1-kristina.martsenko@arm.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add documentation to describe how the kernel manages TLBI domains. The
bitmap approach is based on ideas from Miko Lenczewski.

Also document booting requirements for TLBI domains.

Signed-off-by: Kristina Martšenko <kristina.martsenko@arm.com>
---
 Documentation/arch/arm64/booting.rst | 10 ++++++++++
 arch/arm64/mm/tlbid.c                | 18 ++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
index 13ef311dace8..6a2c46cc4b22 100644
--- a/Documentation/arch/arm64/booting.rst
+++ b/Documentation/arch/arm64/booting.rst
@@ -568,6 +568,16 @@ Before jumping into the kernel, the following conditions must be met:
 
     - HCRX_EL2.EnASR (bit 2) must be initialised to 0b1.
 
+  For CPUs with TLBI domains (FEAT_TLBID):
+
+  - If EL3 is present and the kernel is entered at EL2:
+
+    - SCR_EL3.VTLBIDEn (bit 56) must be initialised to 0b1.
+
+  - If EL2 is present and the kernel is entered at EL1:
+
+    - HFGRTR2_EL2.nTLBIDIDR_EL1 (bit 30) must be initialised to 0b1.
+
 The requirements described above for CPU mode, caches, MMUs, architected
 timers, coherency and system registers apply to all CPUs.  All CPUs must
 enter the kernel in the same exception level.  Where the values documented
diff --git a/arch/arm64/mm/tlbid.c b/arch/arm64/mm/tlbid.c
index c748e710e2ee..2b3e41e6ac22 100644
--- a/arch/arm64/mm/tlbid.c
+++ b/arch/arm64/mm/tlbid.c
@@ -19,6 +19,24 @@
 
 #include <asm/mmu.h>
 
+/*
+ * FEAT_TLBID enables a TLB invalidation to target a subset of CPUs instead of
+ * the whole Inner Shareable domain. It can improve performance on systems with
+ * many CPUs.
+ *
+ * A system with FEAT_TLBID contains a number of TLBI domains. Each domain
+ * contains a number of CPUs. Domain 0 is always present and contains all CPUs.
+ *
+ * For each CPU we maintain a bitmap of domains that the CPU belongs to. For
+ * each mm we maintain a bitmap of domains that contain all the CPUs that the
+ * mm has been installed on. When an mm is installed on a new CPU we reduce its
+ * bitmap to only include domains that include the new CPU.
+ *
+ * When issuing a TLBI we use the smallest domain for the mm instead of
+ * broadcasting to all CPUs. The domain bitmap is ordered by size, with the
+ * highest bit corresponding to the smallest domain.
+ */
+
 DEFINE_STATIC_KEY_FALSE(tlbid_enabled);
 
 static u16 *domain_ids;
-- 
2.43.0

