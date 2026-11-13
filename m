Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794569628;
	b=QL0w/wanQErPtQS6YbYjQknzv4SadVe/UFNHEfRgvtALww/tonGJWg44pNWRIKTAiuQb
	 LyassKFzxXubYG0ckg0MmatORsL1XogyObc1R4Nu6BX9OGF6536Rd7HWioNIJkDZO24dN
	 uxTcoISNHzpLyCpEbY4CXXbtae55CeWSeaMJznAMx/jbgFSjoidbgmvrB7x6LBC902Dv/
	 UObfAw4vWcjzSQwlfd0JSMFd/AxyoCge5VH21dm79YZErsEW3u6tFgdUA1mviph/14pL3
	 27FPNFJNtu/Fe0W934TnCmThValFt65X1yNs06qaDqYkYSnT7WhvsmAhqDBDC+dVcuw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794569628;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Fn0MxtUkrP78BGjsRvrORM/5qKcHjoQt4s8RCTWu6OA=;
	b=T9yXcdatf8X9lMZFXx6UTMpLIxf7VClzDdl50pTtALdwPwsnlNJ9q1WKXmmZnDQRe8NH
	 Er48cC84cmCvnZikfQn7K5XucNDVEEOnOUjuP6PGC+SM3aEHHG1KL1sTRvIhmbRF5CJI9
	 mlSkePjMEl3ii/Of+V4DugmXdnJPrQXGgFYPWCO8qJsB9waI4FxPUHc1iJP/MHl62WGxV
	 kiRcVWPcXEVI3fWH2yCz/m6uiKVE3IytJxNFyDEBPH6DN/8PGk/Uw/Tl/V4ycx/dyQwsR
	 BCJYKt/c3FYkPWhRWUTEEyu2dUwmwu/3hEDmniY0rDLhaxlY2/NB+cKJcV/Lnbu2Nmw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=KDY5W6UY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.11
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012011.outbound.protection.outlook.com [52.101.53.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F8C606A885;
	Fri, 13 Nov 2026 11:33:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1F8C606A885
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=KDY5W6UY
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JO+fkSt3IxCK0yE1eAhZi/MisTywCTCgIYiUwUronia4ecfbUeTGtb+kJ1l320N8+ALxVm3H4lwR6pnXLfeSQ+hnUhv3nd0AhWiU+xol23+pdM97gZ2FcXi6n/67Faxfh4V664Ib6hBaUwtVq8b1QOZMX8w6xJhwWV1Kfm1R2Hon1ZFCI7GxAvdPNimKT5VK1wRHJlHDPKCeXOczu8N/fQsOyeb39R9mTSK5egoN3gC4hkMKOjnu+d4YMpMP0W8zd2p3sJ5lTrZ5+e9tn5nUZ2NFYW2HcQgvwYqsZ/uGFqAnn5r0NHEWIVVyy3rDzG0udELg5NApylohwgycI9EASg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fn0MxtUkrP78BGjsRvrORM/5qKcHjoQt4s8RCTWu6OA=;
 b=lk/vbgCEL2+vzoA8H1Rppq3QWAp/oUeLZRxn0C3fYn60ayl2NSaGGuead0nCxpYgarTGrQ+YEPjiP76fHmKrQvsTh9Cjs4nQI9PJxbX6jFt0DXNLzRyfNUEbFh0PW/zzpAs/zDUBhEBp0BMqHIHZvGLWzborDVzr5OqBN4BHwuUHtdXQWsqD6OrpdYuVFDHzMksGeK+EgNPUNQGV+rCeRvr2/vvqd1TNBM5dguZ2ItnBkQ1EZ9O5uSwP0B4GsMXgAWrUwJvDly9/lltgUKdBo00LPQ8ZQ1HgFJHVk418KrsJ6miPmzwwrBHXQD8p51IMI2hwzkZNyEkR7XC8HYyGCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fn0MxtUkrP78BGjsRvrORM/5qKcHjoQt4s8RCTWu6OA=;
 b=KDY5W6UYb/QtxiNZEpAx0orq9GCiPJDdsQxZkkmCY4Oko5/lfOsE/3dKBDvy7yDC72iuCv9rxmPpCMvu58HKFhL7YTJoDq9cdb+/kDQMD1vki3HXnt41cIA2t/r28kC8TDmwkZYJW/0Q64a3Gj2cTCQbS/lWewraFdhWA7Dc8g8=
Received: from DB9PR05CA0028.eurprd05.prod.outlook.com (2603:10a6:10:1da::33)
 by IA4PR12MB574288.namprd12.prod.outlook.com (2603:10b6:207:14c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 11:33:39 +0000
Received: from BN3PEPF0000B370.namprd21.prod.outlook.com
 (2603:10a6:10:1da:cafe::5e) by DB9PR05CA0028.outlook.office365.com
 (2603:10a6:10:1da::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Fri, 13
 Nov 2026 11:33:36 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B370.mail.protection.outlook.com (10.167.243.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.2 via Frontend Transport; Fri, 13 Nov 2026 11:33:35 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Fri, 13 Nov
 2026 04:55:55 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Fri, 13 Nov
 2026 04:55:54 -0600
Received: from pankaj-M75q.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Fri, 13 Nov 2026 04:55:54 -0600
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>
CC: "H . Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, <linux-kernel@vger.kernel.org>,
	Mike Rapoport <rppt@kernel.org>, <linux-mm@kvack.org>,
	<linux-efi@vger.kernel.org>, <Pankaj.gupta.linux@gmail.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH v2] x86/unaccepted_memory: Do not accept ranges that are no longer E820 RAM
Date: Fri, 13 Nov 2026 04:55:54 -0600
Message-ID: <20261113105554.199912-1-pankaj.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B370:EE_|IA4PR12MB574288:EE_
X-MS-Office365-Filtering-Correlation-Id: 157246f3-2656-4b37-6d8a-08df4179f48d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|376014|7416014|1800799024|18002099003|261009223027099003|11063799006|56012099006|10067099003|261102123227099003|261022105027099003|261026140227099003|261028144727099003|261021121427099003|261026121527099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	0h6PefNRxgwF5Hr50dF2rsVWkLmwrLcKa5+UOT+5/KDRwn7T4jcZskZ9nAKdaNIW3+sIfGKkbpShx9kya3OtG6iBMIefjgqae6EaZTAnT9Xxe0v9rr+rYxHlc4HBH6OY2rmS8rCqpAy13cmHBgawgMBm84tg3YGS7mzGnsM0QkMOPjBwipZOvFqOmxU91nnG4dxsQ7DnseUL8oIeFXpFzP9PYJxIzr6jcH57csIXSiqfTkk7n7+b0an8qqtmaj6JKCvUGnqJCMcBckp9S0nXZtFc71ZKn/afHTdNGncTJbY4rtJz9HTqnw7MkagWnaZyAVH4N3TYJ2pm2oC67gyMCvUm2x9/6Q4KK9UmEekRnkzpx/4y3Qgg+OmNHPh3u+BelZ81aUdFnpI3tABBgMoKH8NtsUcN04pvOF1mMQC/dLLL/1OcVi0OWk/QndOgV4cn/0z9YVpUdSgMYrxFYD6vVgWjRQ5CYVNxlRZcqNGU3aoPMzuqBICWw9cxW+e/eegYm10AMsuoJ2BamGS5v9JLgpgcDsd9fJ8sWt0b472J2d5KLpl267sNXHQnwy+LOvu4J9tLTEIntkZFdnUR5B4jdvl+KBGQO46gfV5OvHKjhZIhuDju2UkKq01Pj9JAKU809uFcvQZ2JP6Sd6ikDnUtXQRdM9WuTMp8LUb98z/U0F0=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(376014)(7416014)(1800799024)(18002099003)(261009223027099003)(11063799006)(56012099006)(10067099003)(261102123227099003)(261022105027099003)(261026140227099003)(261028144727099003)(261021121427099003)(261026121527099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EK/PXW+y459foCP6ysFiBP5Uhh4XmpHl5mrRAZejBqVXUVgHJZ2NZi8gEXiD9S3t5PbIe0y9wStN7NUKaCLD6IvOg95sTdCjXL7i/9rbMLB6ChX0RDuPy6AhxtwA9zlgPK/jQCnbCWDFaMGYVh05Po51Cege9BnHTwvl97f/42hYWF6WWu7TkagXTCb9NqZWBg705wwTcu+pENtXbuMOxmzjBob8xrUnxM8sWpGcnzmoM5MGLN0XuO5mfQZXhMM+vSP80Xeakoe91CIYs1t6HWzRymvzxkGdrRFbs4ynitiDs+NgdFsFmVbMJvC5GBR3QRcCQL4G/mFbc5nBPFZbjZvytNQCOSgw+gTWEldShkaInxw4dhokaUXsGUQzSZ5/dsyCbxTRgtdjpspyY8O9i7CoWjv86D4oPGEiA1eP4zbi5X2eOVZKNBjOifcRMacw
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 11:33:35.9167
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 157246f3-2656-4b37-6d8a-08df4179f48d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB574288

The EFI stub builds the unaccepted memory bitmap before the kernel parses
its command line.  Option memmap=<size>$<addr> removes RAM from the E820 map
while its bits are still set in the bitmap.

The removed range, such as a memmap=...$... hole, is then still treated as
unaccepted RAM and accept_memory() tries to accept it.  The hole is not
mapped, so on SEV-SNP the PVALIDATE faults and the guest crashes early in
the boot:

  BUG: unable to handle page fault for address: ffff8a14bfe00000
  RIP: 0010:pvalidate_pages+0xc0/0x250
   set_pages_state+0x41a/0x440
   snp_accept_memory+0x3e/0x50
   accept_memory+0x186/0x260
   __free_pages_core+0xd2/0x240
   memblock_free_pages+0x1b/0x30
   memblock_free_all+0x275/0x2d0

This was seen with memmap=2M$0x1ffe00000, a 2 MiB hole in RAM, on a 19 GiB
SNP guest with lazy acceptance.

Accept only whole pages of E820 RAM, and clear the bitmap bits only for the
units in which memory was accepted.

Fixes: 2053bc57f367 ("efi: Add unaccepted memory support")
Cc: stable@vger.kernel.org
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
v1 -> v2:
- Clear the bitmap bits only for the accepted memory
- Round E820 RAM range to page boundaries

v1: https://lore.kernel.org/all/20261102113127.161823-1-pankaj.gupta@amd.com/

 arch/x86/include/asm/unaccepted_memory.h | 44 +++++++++++++++++++++++-
 drivers/firmware/efi/unaccepted_memory.c |  4 +--
 2 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/unaccepted_memory.h b/arch/x86/include/asm/unaccepted_memory.h
index f5937e9866ac..9e27a9953dd8 100644
--- a/arch/x86/include/asm/unaccepted_memory.h
+++ b/arch/x86/include/asm/unaccepted_memory.h
@@ -2,10 +2,11 @@
 #define _ASM_X86_UNACCEPTED_MEMORY_H
 
 #include <linux/efi.h>
+#include <asm/e820/api.h>
 #include <asm/tdx.h>
 #include <asm/sev.h>
 
-static inline void arch_accept_memory(phys_addr_t start, phys_addr_t end)
+static inline void __arch_accept_memory(phys_addr_t start, phys_addr_t end)
 {
 	/* Platform-specific memory-acceptance call goes here */
 	if (cpu_feature_enabled(X86_FEATURE_TDX_GUEST)) {
@@ -18,6 +19,47 @@ static inline void arch_accept_memory(phys_addr_t start, phys_addr_t end)
 	}
 }
 
+static inline bool e820_ram_pages(struct e820_entry *entry, phys_addr_t start,
+				  phys_addr_t end, phys_addr_t *s, phys_addr_t *e)
+{
+	if (entry->type != E820_TYPE_RAM)
+		return false;
+
+	*s = PAGE_ALIGN(max_t(phys_addr_t, start, entry->addr));
+	*e = PAGE_ALIGN_DOWN(min_t(phys_addr_t, end, entry->addr + entry->size));
+	return *s < *e;
+}
+
+static inline void arch_accept_memory(phys_addr_t start, phys_addr_t end)
+{
+	phys_addr_t s, e;
+	u32 i;
+
+	for (i = 0; i < e820_table->nr_entries; i++) {
+		if (e820_ram_pages(&e820_table->entries[i], start, end, &s, &e))
+			__arch_accept_memory(s, e);
+	}
+}
+
+static inline void arch_clear_accepted(unsigned long *bitmap, phys_addr_t base,
+				       unsigned long unit_size,
+				       phys_addr_t start, phys_addr_t end)
+{
+	phys_addr_t s, e;
+	u32 i;
+
+	for (i = 0; i < e820_table->nr_entries; i++) {
+		unsigned long first, last;
+
+		if (!e820_ram_pages(&e820_table->entries[i], start, end, &s, &e))
+			continue;
+
+		first = (s - base) / unit_size;
+		last = DIV_ROUND_UP(e - base, unit_size);
+		bitmap_clear(bitmap, first, last - first);
+	}
+}
+
 static inline struct efi_unaccepted_memory *efi_get_unaccepted_table(void)
 {
 	if (efi.unaccepted == EFI_INVALID_TABLE_ADDR)
diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
index 4a8ec8d6a571..b8a0c0d1d289 100644
--- a/drivers/firmware/efi/unaccepted_memory.c
+++ b/drivers/firmware/efi/unaccepted_memory.c
@@ -130,7 +130,6 @@ void accept_memory(phys_addr_t start, unsigned long size)
 	for_each_set_bitrange_from(range_start, range_end, unaccepted->bitmap,
 				   range.end) {
 		unsigned long phys_start, phys_end;
-		unsigned long len = range_end - range_start;
 
 		phys_start = range_start * unit_size + unaccepted->phys_base;
 		phys_end = range_end * unit_size + unaccepted->phys_base;
@@ -150,7 +149,8 @@ void accept_memory(phys_addr_t start, unsigned long size)
 		arch_accept_memory(phys_start, phys_end);
 
 		spin_lock(&unaccepted_memory_lock);
-		bitmap_clear(unaccepted->bitmap, range_start, len);
+		arch_clear_accepted(unaccepted->bitmap, unaccepted->phys_base,
+				    unit_size, phys_start, phys_end);
 	}
 
 	list_del(&range.list);
-- 
2.34.1

