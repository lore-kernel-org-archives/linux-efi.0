Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB6394F4CFC;
	Thu,  1 Oct 2026 11:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790852879; cv=none; b=DVd790lI337690nVcxlRhPquH+Z1btCcXaFXJ4dEzeK6SPHyVMT52qGPIMNQoZer7odPNfmQjmEX2WHrdR7hOrrrqLO9jS6IwLHj3qClAzZM/VBZVFm818zurDoebbDUj5/kkHJDFcP9CQWl1b7bWXcvIM8+NgzT6Z/remNqdsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790852879; c=relaxed/simple;
	bh=j+uQKqTVanjvf4slAELPAurZMlnXXqOg6QOnGPE5FgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PVahE5oRcQjsmWr9z9Tcv1yAuFxHFtCgdNA9IQAECfGHlGQNFUPxVGm1ZQbGqQlVVXZyvxrVmXCnxjrxuJwrpPpE2I4WqX7NM0AUNGQyK8rqdyUpn8h6D0/mVYPguru9cUV0C6u7LPJe6THwSRpFo5BcP5Tf3yEd5JRYxoX99E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Zow3GMjl; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Zow3GMjl"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BB75D497;
	Thu,  1 Oct 2026 04:07:52 -0700 (PDT)
Received: from e142392.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 920643F86F;
	Thu,  1 Oct 2026 04:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790852876; bh=j+uQKqTVanjvf4slAELPAurZMlnXXqOg6QOnGPE5FgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zow3GMjlhNUsMykAZZ1UomKuSGJjjQb9lvsCfoIsGuvylhDJ0bhKfYZRxSHtcN0yV
	 QO+YpAHaCoXmOrMw0TNSzkMNTNKvjXY7BDq0GLV48VXoSKzayLbuwKY3yTGTdQ49vA
	 gVc4hqS+SuK0e81WGEoXV/3a1nV8OHZjj57gPHEo=
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
Subject: [RFC 06/12] ACPI: TLBI: Parse domains from table
Date: Thu,  1 Oct 2026 12:06:49 +0100
Message-ID: <20261001110655.461473-7-kristina.martsenko@arm.com>
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

Parse the Arm TLBI ACPI table.

The table contains a list of TLBI domains. Each domain is identified by
a domain number (which can be passed to a TLBI instruction). Each domain
contains a list of descendants, which are CPUs, SMMUs and subdomains.
CPUs are identified by their ACPI Processor UID in GICC MADT, SMMUs by
their Identifier in IORT, and subdomains by their offset in the TLBI
table itself. This allows to describe a hierarchy of domains and the
CPUs and SMMUs that are part of each domain.

Parse the domains from the table. For each domain, build a cpumask of
the CPUs that are part of it. Only add CPUs that have not been disabled.

Parse the domains recursively. Use an arbitrary depth limit of 10 to
prevent infinite recursion in case of firmware bugs. For simplicity each
subdomain hierarchy may be parsed multiple times.

Validate that domain 0 (the fallback broadcast-all domain) always
exists and contains all CPUs. Also check that domain IDs fit into the
architectural limit of 16 bits and what the CPUs support in TLBIDIDR.
Sanity check the table itself (i.e. table sizes), as usually done in
ACPI parsing.

The list of domains and their CPUs will be used in the next patch to
set up domain management in arm64 code. Place common structures in the
arm64 ACPI header. The ARM64_TLBID kconfig symbol will be used later to
detect compiler support and disable all TLBID code.

Assisted-by: LLM
Signed-off-by: Kristina Martšenko <kristina.martsenko@arm.com>
---
 arch/arm64/Kconfig            |   5 +
 arch/arm64/include/asm/acpi.h |   9 ++
 drivers/acpi/arm64/Kconfig    |   3 +
 drivers/acpi/arm64/Makefile   |   1 +
 drivers/acpi/arm64/init.c     |   2 +
 drivers/acpi/arm64/init.h     |   1 +
 drivers/acpi/arm64/tlbi.c     | 188 ++++++++++++++++++++++++++++++++++
 7 files changed, 209 insertions(+)
 create mode 100644 drivers/acpi/arm64/tlbi.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b5a51b0ef944..46701449fef2 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2329,6 +2329,11 @@ config ARM64_LSUI
 
 endmenu # "ARMv9.6 architectural feature"
 
+config ARM64_TLBID
+	def_bool y
+	depends on ACPI
+	select ACPI_TLBI
+
 config ARM64_SVE
 	bool "ARM Scalable Vector Extension support"
 	default y
diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index 8a54ca6ba602..fb0bddd3b7ef 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -10,6 +10,7 @@
 #define _ASM_ACPI_H
 
 #include <linux/cpuidle.h>
+#include <linux/cpumask.h>
 #include <linux/efi.h>
 #include <linux/memblock.h>
 #include <linux/psci.h>
@@ -171,6 +172,14 @@ static inline int acpi_numa_get_nid(unsigned int cpu) { return NUMA_NO_NODE; }
 static inline void acpi_map_cpus_to_nodes(void) { }
 #endif /* CONFIG_ACPI_NUMA */
 
+#ifdef CONFIG_ARM64_TLBID
+#define MAX_TLBI_DOMAINS	(1UL << 16)
+struct tlbi_domain {
+	u16 id;
+	cpumask_var_t cpus;
+};
+#endif
+
 #define ACPI_TABLE_UPGRADE_MAX_PHYS MEMBLOCK_ALLOC_ACCESSIBLE
 
 #endif /*_ASM_ACPI_H*/
diff --git a/drivers/acpi/arm64/Kconfig b/drivers/acpi/arm64/Kconfig
index f2fd79f22e7d..d7ba9add438e 100644
--- a/drivers/acpi/arm64/Kconfig
+++ b/drivers/acpi/arm64/Kconfig
@@ -24,3 +24,6 @@ config ACPI_APMT
 
 config ACPI_MPAM
 	bool
+
+config ACPI_TLBI
+	bool
diff --git a/drivers/acpi/arm64/Makefile b/drivers/acpi/arm64/Makefile
index 9390b57cb564..9cee81ce834b 100644
--- a/drivers/acpi/arm64/Makefile
+++ b/drivers/acpi/arm64/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_ACPI_FFH)		+= ffh.o
 obj-$(CONFIG_ACPI_GTDT) 	+= gtdt.o
 obj-$(CONFIG_ACPI_IORT) 	+= iort.o
 obj-$(CONFIG_ACPI_MPAM) 	+= mpam.o
+obj-$(CONFIG_ACPI_TLBI) 	+= tlbi.o
 obj-$(CONFIG_ACPI_PROCESSOR_IDLE) += cpuidle.o
 obj-$(CONFIG_ARM_AMBA)		+= amba.o
 obj-y				+= dma.o init.o
diff --git a/drivers/acpi/arm64/init.c b/drivers/acpi/arm64/init.c
index 7a47d8095a7d..3affc7abf156 100644
--- a/drivers/acpi/arm64/init.c
+++ b/drivers/acpi/arm64/init.c
@@ -10,6 +10,8 @@ void __init acpi_arch_init(void)
 		acpi_apmt_init();
 	if (IS_ENABLED(CONFIG_ACPI_IORT))
 		acpi_iort_init();
+	if (IS_ENABLED(CONFIG_ACPI_TLBI))
+		acpi_tlbi_init();
 	if (IS_ENABLED(CONFIG_ARM_AMBA))
 		acpi_amba_init();
 }
diff --git a/drivers/acpi/arm64/init.h b/drivers/acpi/arm64/init.h
index dcc277977194..c036e2622a2f 100644
--- a/drivers/acpi/arm64/init.h
+++ b/drivers/acpi/arm64/init.h
@@ -5,3 +5,4 @@ void __init acpi_agdi_init(void);
 void __init acpi_apmt_init(void);
 void __init acpi_iort_init(void);
 void __init acpi_amba_init(void);
+void __init acpi_tlbi_init(void);
diff --git a/drivers/acpi/arm64/tlbi.c b/drivers/acpi/arm64/tlbi.c
new file mode 100644
index 000000000000..b705a5b19842
--- /dev/null
+++ b/drivers/acpi/arm64/tlbi.c
@@ -0,0 +1,188 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Arm TLBI Domain Table (TLBI) support
+ *
+ * Copyright (C) 2026 Arm Ltd.
+ * Author: Kristina Martsenko <kristina.martsenko@arm.com>
+ */
+
+#define pr_fmt(fmt)	"ACPI: TLBI: " fmt
+
+#include <linux/acpi.h>
+#include <linux/cpufeature.h>
+#include <linux/limits.h>
+#include <linux/slab.h>
+
+#include "init.h"
+
+#define MAX_HIERARCHY_DEPTH 10
+
+struct acpi_table_tlbi *tlbi;
+static struct tlbi_domain *domains;
+static int domain_count;
+
+static int __init validate_tlbi_domains(void)
+{
+	u64 tlbididr = read_sanitised_ftr_reg(SYS_TLBIDIDR_EL1);
+	int domain_bits = FIELD_GET(TLBIDIDR_EL1_NIS, tlbididr);
+	int domain0_idx = -1;
+	int cpu;
+
+	if (domain_bits > 16)
+		return -EINVAL;
+
+	for (int i = 0; i < domain_count; i++) {
+		u16 max_domain_id = (1 << domain_bits) - 1;
+
+		if (domains[i].id > max_domain_id &&
+		    !cpumask_empty(domains[i].cpus))
+			return -EINVAL;
+
+		if (!domains[i].id)
+			domain0_idx = i;
+	}
+
+	if (domain0_idx == -1)
+		return -EINVAL;
+
+	for_each_possible_cpu(cpu) {
+		if (!cpumask_test_cpu(cpu, domains[domain0_idx].cpus))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct acpi_tlbi_descendant *__init tlbi_get_descendant(u32 offset)
+{
+	struct acpi_tlbi_descendant *descendant;
+
+	descendant = ACPI_ADD_PTR(struct acpi_tlbi_descendant, tlbi, offset);
+	if (descendant->length < sizeof(*descendant) ||
+	    offset + descendant->length > tlbi->header.length)
+		return NULL;
+
+	return descendant;
+}
+
+static struct acpi_tlbi_domain *__init tlbi_get_domain(u32 offset)
+{
+	struct acpi_tlbi_domain *domain;
+
+	domain = ACPI_ADD_PTR(struct acpi_tlbi_domain, tlbi, offset);
+	if (domain->length < sizeof(*domain) ||
+	    offset + domain->length > tlbi->header.length)
+		return NULL;
+
+	return domain;
+}
+
+static int __init parse_tlbi_domain(struct acpi_tlbi_domain *domain,
+				    struct cpumask *cpus, int depth)
+{
+	u32 offset = domain->descendants_offset;
+
+	if (depth > MAX_HIERARCHY_DEPTH)
+		return -EINVAL;
+
+	for (int i = 0; i < domain->descendant_count; i++) {
+		struct acpi_tlbi_descendant *desc = tlbi_get_descendant(offset);
+
+		if (!desc)
+			return -EINVAL;
+
+		switch (desc->type) {
+		case ACPI_TLBI_DESCENDANT_DOMAIN: {
+			struct acpi_tlbi_domain *child;
+			int ret;
+
+			child = tlbi_get_domain(desc->identifier);
+			if (!child)
+				return -EINVAL;
+
+			ret = parse_tlbi_domain(child, cpus, depth + 1);
+			if (ret)
+				return ret;
+			break;
+		}
+		case ACPI_TLBI_DESCENDANT_CPU: {
+			int cpu = get_cpu_for_acpi_id(desc->identifier);
+
+			if (cpu >= 0 && cpu_possible(cpu))
+				cpumask_set_cpu(cpu, cpus);
+			break;
+		}
+		case ACPI_TLBI_DESCENDANT_SMMU:
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		offset += desc->length;
+	}
+
+	return 0;
+}
+
+static int __init parse_tlbi_table(void)
+{
+	struct acpi_table_header *table __free(acpi_put_table) =
+		acpi_get_table_pointer(ACPI_SIG_TLBI, 0);
+	u32 offset;
+	int ret;
+
+	if (IS_ERR(table))
+		return PTR_ERR(table);
+
+	tlbi = (struct acpi_table_tlbi *)table;
+	if (tlbi->header.length < sizeof(*tlbi) ||
+	    tlbi->domain_count > MAX_TLBI_DOMAINS)
+		return -EINVAL;
+	if (!tlbi->domain_count)
+		return -ENOENT;
+
+	domain_count = tlbi->domain_count;
+	domains = kcalloc(domain_count, sizeof(*domains), GFP_KERNEL);
+	if (!domains)
+		return -ENOMEM;
+
+	offset = tlbi->domains_offset;
+
+	for (int i = 0; i < domain_count; i++) {
+		struct acpi_tlbi_domain *domain = tlbi_get_domain(offset);
+
+		if (!domain || domain->id > U16_MAX)
+			return -EINVAL;
+
+		domains[i].id = domain->id;
+		if (!zalloc_cpumask_var(&domains[i].cpus, GFP_KERNEL))
+			return -ENOMEM;
+
+		ret = parse_tlbi_domain(domain, domains[i].cpus, 0);
+		if (ret)
+			return ret;
+
+		offset += domain->length;
+	}
+
+	ret = validate_tlbi_domains();
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+void __init acpi_tlbi_init(void)
+{
+	int ret;
+
+	if (!cpus_have_final_cap(ARM64_HAS_TLBID))
+		return;
+
+	ret = parse_tlbi_table();
+	if (ret) {
+		if (ret != -ENOENT)
+			pr_err("Failed to parse ACPI table\n");
+		return;
+	}
+}
-- 
2.43.0

