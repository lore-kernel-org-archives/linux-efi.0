Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795693837;
	b=pJIAoilVbcnBfy7jK6n+n3J976jwIqyMT+iW/Izjh8ddi0nvnf8eI1C2+MFbaAZaCeDq
	 0/QgZetrOyuXITYNVOBXvS/Ym4NVPG2GY6yxbXvKgfhqmKWKA1hYyDT4Q87AW3ZUuUylF
	 olyvOLyIRTNvkg1Ezta/Hxoq5LVKM07eCuApeq80AgzVHoL6ZPLLiHzk0jRHefgt1qkeK
	 lwdMHVI2DQb7kqyqDbebJxJ+rVYG5saTvPWRuTl20Ymz48Xmy5NjO0B5yFGvaodzS+f6M
	 htDZdgDD9Q8hrW2rHdodb1TQES51+JQ5+5qs3dWZUEhx8gjKr9CCGnjVrKnMZfiUogA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795693837;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=azZ3KQu2QEF63DgvbCLhBPpTz7ayv4JWXUinkgaEY0U=;
	b=IPGAbTd4/bsNPS4MTP0xhhNCwK+75VYgUr1TurZnw5w9ZzMOTHtHW+ZNgfSpWBHeWxkL
	 6+Hcfprq46NGh/1nL3Z/G9SGeijQQQq4rhKhL8ShaevhAcE+bFpDIS6k6nSNd+J2vu+EX
	 MBLw51wXZvk0M4z+UaAPxM3pYJ/cm65Jm71kDnGOqbgvqg7Ed37A6PV9tA/ZMZlxShIWX
	 w7fc4rtT0P5OzA3+ySHQPwHaS6cNv+Y9wfyRU13fS5jjfMcTGX8gbZy6DHutbC3JAL4JN
	 s1SKOHh39e4sPCdNQlq82ervYCqPARPOY2dfr8RJt56vM2dK/dLdEDsAb52j1Pd3IXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=G1Zv6WOA;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32F95606A31C;
	Thu, 26 Nov 2026 11:50:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32F95606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=G1Zv6WOA
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC68F1CE2;
	Thu, 26 Nov 2026 03:50:33 -0800 (PST)
Received: from e142392.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 58F933F632;
	Thu, 26 Nov 2026 03:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795693836; bh=8QlSd2smlIXF53k84CUiTHAkghqqHY3TKxduzhWQPs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G1Zv6WOAFD8/+FkhhNw32S6gMJlePJnG8ukoIiPetxSDatIDtRyd9u+5dFjhW8Z2b
	 XbBsR36uioWjYtKZ6Vj57dU+Ce4XtFma7xFeBQom+oHteqvFlwmzE63o/u5MDSpzzP
	 rVOgpgjskrN0SUkT91zvfzzO4HQbKjy7PBH9c8ec=
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
Subject: [RFC v2 08/13] arm64: tlbid: Set up CPU domain bitmaps
Date: Thu, 26 Nov 2026 11:49:31 +0000
Message-ID: <20261126114936.864256-9-kristina.martsenko@arm.com>
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

For each CPU, set up a bitmap of TLBI domains that contain the CPU.
This will be used in later patches to select a domain that contains a
given set of CPUs.

Sort the bitmap by size, with the largest domain at the smallest index.
This will be used to select the smallest domain. Domains are sorted
based on the number of CPUs that they contain. Domains may also contain
SMMUs but we ignore that for now.

Do the setup in arm64 code, near to where it will be used. The ACPI
table parser calls the arm64 setup code directly after parsing the TLBI
table, and passes a list of parsed domains. Afterwards, the parser's own
temporary structures are freed. Alternatively the arm64 setup could be
done from a subsys_initcall_sync().

Add a static key that will be used to check if TLBI domains are enabled.
Disable domains for nVHE EL2 hypervisor code since it would otherwise
need access to the static key (since it #includes tlbflush.h which will
use system_supports_tlbid()) but it wouldn't use domains anyway.

Signed-off-by: Kristina Martšenko <kristina.martsenko@arm.com>
---
 arch/arm64/include/asm/acpi.h       |   1 +
 arch/arm64/include/asm/cpufeature.h |   8 ++
 arch/arm64/mm/Makefile              |   1 +
 arch/arm64/mm/tlbid.c               | 114 ++++++++++++++++++++++++++++
 drivers/acpi/arm64/tlbi.c           |   6 ++
 5 files changed, 130 insertions(+)
 create mode 100644 arch/arm64/mm/tlbid.c

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index fb0bddd3b7ef..5d173c26b56c 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -178,6 +178,7 @@ struct tlbi_domain {
 	u16 id;
 	cpumask_var_t cpus;
 };
+int arm64_tlbid_init(struct tlbi_domain *domains, int count);
 #endif
 
 #define ACPI_TABLE_UPGRADE_MAX_PHYS MEMBLOCK_ALLOC_ACCESSIBLE
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index b236fe3077f5..93da0ab03177 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -916,6 +916,14 @@ static inline bool system_supports_bbml3(void)
 	return alternative_has_cap_unlikely(ARM64_HAS_BBML3);
 }
 
+DECLARE_STATIC_KEY_FALSE(tlbid_enabled);
+static inline bool system_supports_tlbid(void)
+{
+	return IS_ENABLED(CONFIG_ARM64_TLBID) &&
+	       !is_nvhe_hyp_code() &&
+	       static_branch_unlikely(&tlbid_enabled);
+}
+
 int do_emulate_mrs(struct pt_regs *regs, u32 sys_reg, u32 rt);
 bool try_emulate_mrs(struct pt_regs *regs, u32 isn);
 
diff --git a/arch/arm64/mm/Makefile b/arch/arm64/mm/Makefile
index c26489cf96cd..cfd3255d8f0a 100644
--- a/arch/arm64/mm/Makefile
+++ b/arch/arm64/mm/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_TRANS_TABLE)	+= trans_pgd-asm.o
 obj-$(CONFIG_DEBUG_VIRTUAL)	+= physaddr.o
 obj-$(CONFIG_ARM64_MTE)		+= mteswap.o
 obj-$(CONFIG_ARM64_GCS)		+= gcs.o
+obj-$(CONFIG_ARM64_TLBID) 	+= tlbid.o
 KASAN_SANITIZE_physaddr.o	+= n
 
 obj-$(CONFIG_KASAN)		+= kasan_init.o
diff --git a/arch/arm64/mm/tlbid.c b/arch/arm64/mm/tlbid.c
new file mode 100644
index 000000000000..33d669e6bf1e
--- /dev/null
+++ b/arch/arm64/mm/tlbid.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * TLBI domains (FEAT_TLBID) support
+ *
+ * Copyright (C) 2026 Arm Ltd.
+ * Author: Kristina Martsenko <kristina.martsenko@arm.com>
+ */
+
+#include <linux/acpi.h>
+#include <linux/bitops.h>
+#include <linux/bitmap.h>
+#include <linux/jump_label.h>
+#include <linux/slab.h>
+#include <linux/sort.h>
+
+DEFINE_STATIC_KEY_FALSE(tlbid_enabled);
+
+static u16 *domain_ids;
+static unsigned long **cpu_domains;
+static int domain_count;
+
+static int __init init_cpu_domain_bitmaps(struct tlbi_domain *domains)
+{
+	int cpu;
+
+	cpu_domains = kcalloc(nr_cpu_ids, sizeof(*cpu_domains), GFP_KERNEL);
+	if (!cpu_domains)
+		return -ENOMEM;
+
+	for_each_possible_cpu(cpu) {
+		cpu_domains[cpu] = bitmap_zalloc(domain_count, GFP_KERNEL);
+		if (!cpu_domains[cpu])
+			goto err;
+
+		for (int i = 0; i < domain_count; i++) {
+			if (cpumask_test_cpu(cpu, domains[i].cpus))
+				set_bit(i, cpu_domains[cpu]);
+		}
+	}
+
+	return 0;
+err:
+	for_each_possible_cpu(cpu)
+		bitmap_free(cpu_domains[cpu]);
+	kfree(cpu_domains);
+	return -ENOMEM;
+}
+
+static int __init store_domain_ids(struct tlbi_domain *domains)
+{
+	domain_ids = kmalloc_array(domain_count, sizeof(*domain_ids),
+				   GFP_KERNEL);
+	if (!domain_ids)
+		return -ENOMEM;
+
+	for (int i = 0; i < domain_count; i++)
+		domain_ids[i] = domains[i].id;
+
+	return 0;
+}
+
+static int __init tlbi_domain_cmp(const void *a, const void *b)
+{
+	const struct tlbi_domain *d1 = a;
+	const struct tlbi_domain *d2 = b;
+
+	/* Sort domains from largest to smallest */
+	return cmp_int(cpumask_weight(d2->cpus), cpumask_weight(d1->cpus));
+}
+
+static struct tlbi_domain *__init sort_domains_by_size(struct tlbi_domain *domains)
+{
+	struct tlbi_domain *domains_sorted;
+
+	domains_sorted = kmemdup(domains, domain_count * sizeof(*domains),
+				 GFP_KERNEL);
+	if (!domains_sorted)
+		return NULL;
+
+	sort(domains_sorted, domain_count, sizeof(*domains_sorted),
+	     tlbi_domain_cmp, NULL);
+
+	return domains_sorted;
+}
+
+int __init arm64_tlbid_init(struct tlbi_domain *domains_in, int count)
+{
+	struct tlbi_domain *domains;
+	int ret;
+
+	domain_count = count;
+
+	domains = sort_domains_by_size(domains_in);
+	if (!domains)
+		return -ENOMEM;
+
+	ret = store_domain_ids(domains);
+	if (ret)
+		goto err_ids;
+
+	ret = init_cpu_domain_bitmaps(domains);
+	if (ret)
+		goto err_cpu;
+
+	static_branch_enable(&tlbid_enabled);
+
+	kfree(domains);
+	return 0;
+err_cpu:
+	kfree(domain_ids);
+err_ids:
+	kfree(domains);
+	return ret;
+}
diff --git a/drivers/acpi/arm64/tlbi.c b/drivers/acpi/arm64/tlbi.c
index 1a4b591f8f70..7fa7439a296f 100644
--- a/drivers/acpi/arm64/tlbi.c
+++ b/drivers/acpi/arm64/tlbi.c
@@ -208,4 +208,10 @@ void __init acpi_tlbi_init(void)
 		pr_err("Failed to parse ACPI table\n");
 		return;
 	}
+
+	ret = arm64_tlbid_init(domains, domain_count);
+	if (ret)
+		pr_err("Failed to initialize domains\n");
+
+	free_tlbi_domains();
 }
-- 
2.43.0

