Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795693855;
	b=40APuirgDTg0dXmX5CRJCku5pFCq2KItTdhF3gO6RPiGJVQtOvveaG26jdOKG/8A6FAr
	 SMe8+V9YLvOXzvEgjaPdq5bFCsDFV1+/pR7tY2yS5FKkiE4y8tk3VB3HbcmtWdCNcbriN
	 LPKdih52nXzaDN5wEKWwcrY2nph5pjGkoB2uMM/mHIYjU9p24nZu/I0YlUqvyLyFJ3GUe
	 k4fErX4yIXA1GTlDMka7DfHrd3SfEWP1/MuidGtbiDlLrQB5kM63CE3zjp17lTFd0MJD5
	 1m4Xt8/1mOK/bvhzcmxngy7QcPICGptzQz6nPBkDUmGs2Xchlb21njetakiYkKhWAuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795693855;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=EL1rGzuTeW3MVgLe5/KZaT1wUaWiPydzOexl70Ne1SI=;
	b=XJbbPTfz1vBC4G0wzvx9Fxt8N6+H7Ard/YbFiPNK8twL52kjottUdm4ATXvQ0Y2QDbDL
	 ifLehc5HqjoUH7NVQydfre3IpD6JECs9md1N0HA3w36CezHeYXrYGYeSOU38Z5pP2z2Or
	 pT22dEKN2GWvEsU1x6FXpVnb1lPT7KDobcV3E+16Vw6Ohgfuay8srBzipyYRe9+qskPKe
	 qfqJeV9matcRUAcb14moQhv9ygQZj1bSAyipKLNDKHhRHjnua0xRftgweQJTlvSUKrXz4
	 tK/35ZbDhapZ+P0tI2jlLUKIb03SLZ0Kp0JMvbwY5OrhhpVASV8VuW7lu6QcSLECjxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=sg+Hr6MK;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22B2B606A323;
	Thu, 26 Nov 2026 11:50:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22B2B606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=sg+Hr6MK
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A47481CE2;
	Thu, 26 Nov 2026 03:50:51 -0800 (PST)
Received: from e142392.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3CD8C3F632;
	Thu, 26 Nov 2026 03:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795693854; bh=BAzpj4e1o9HZLbqYKvamfN3ccwawKGBx7s3KRS4gDEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sg+Hr6MKDsS0eivBvx6N2sk0aF+F8MRF5M2sQFgSJRyQYHznSza1v9EhzYEBrS1hm
	 8THRimgD3p1aIaCT8x2/7B5w/Z4ZUl7PhXeGdC3JTg0+QWuXeuq+QQgQNS7xSEbQiQ
	 Rj18EDFHUSe3XyXJMIjdoqepJk8Oi5UuR8WstqJM=
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
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [RFC v2 13/13] arm64: tlbid: Add documentation
Date: Thu, 26 Nov 2026 11:49:36 +0000
Message-ID: <20261126114936.864256-14-kristina.martsenko@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261126114936.864256-1-kristina.martsenko@arm.com>
References: <20261126114936.864256-1-kristina.martsenko@arm.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add documentation to describe how the kernel manages TLBI domains. The
bitmap approach is based on ideas from Miko Lenczewski.

Signed-off-by: Kristina Martšenko <kristina.martsenko@arm.com>
---
 arch/arm64/mm/tlbid.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/mm/tlbid.c b/arch/arm64/mm/tlbid.c
index 2615ccb6bc56..85b6e33c82b9 100644
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

