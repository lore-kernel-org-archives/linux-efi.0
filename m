Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.20
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795527173;
	b=CcUJiaQfe2GXihC2cf0YYT1U5vd2EXtYmFCKyR+XwHkBlhhQg3JBZ4mPddC09lAe+ms0
	 bsmJTzhAOQOBlfzGC/vJhe9TpbfYqJa4a/DQ+SYO/wjWLHv6CPN1r0XqFSZO+xSek4oUm
	 oAi7IfxthSVb0x0VLe9G8I12OtJherqmJPGNpjzcTLVnOEr89rsEJYEfijCP5NZZQyqol
	 i9QUcSIsFp3USTA9SNg/QxSLm6NV3oZHN7Ea2/NVlBTwt0n1HcyEYyEDrJIU6SaW8E8cm
	 BzMkUMztZzeIifK5bWMj1lky5XrhnJseHjOblQGPU9Da3SGc2yYS4lR8zCJRc1SdntQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795527173;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=UgBMFkDq8qy+YTgmKNNuphPfoBuAEJXoicWHMnVzLHM=;
	b=iznYJ632NIkEhwUiEY8W8TnaZUQpyvX7//eDlBuP/O6XUBzP04D9/R0RqvaPux0PIrfT
	 dOAM5FJSezytATFUkq+EERKL3z3Hgv6okAXhGYYpM1D1iRbTvnnU5PLI9HLw314HjLmht
	 vmxqMTTIGT2l+1pcViiFOHMmGzpm4WmGJVctAw9cvjWYAant4RRcgpLPwXJ8enuB0jXpA
	 eDS+SzVp2w3rf3bBcM5uuQ9UsfVB/Cuil96Aq6HBi7OETwQ4k7xbEe9iJXENhk7hHqnjL
	 L4OTqspzFVmunLyAQtYgPIt9V/Exl5w+0dTUzNHmFn8iFS5pH5h/AxE5o9WUMEqWC9g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=Dn06AEc+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.20
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013020.outbound.protection.outlook.com [40.107.201.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76863606A33E;
	Tue, 24 Nov 2026 13:32:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76863606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=Dn06AEc+
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=as63O/AC9NToWnrYhHVv+Kdk0uDdrGlUGhgVFQAMShCM9mzyepDHkzKdxl9uURSC0o293euwvHybLBsSZ2m6rBgcej2KADEQ+WvYz4FJJl2W67jbLoTrgRIjqd+sCmUK4DtxQEQ5VXMgBqIGif0BX646bz6kz633Cx4dBYStyL+qh9aJOb6Vwf+3+OXecivNdvsv0zrZKAUMzDR/RyM0/Bi5x+tYsdaiCF1H1PrXVqYqNCxHc4zqxyuOp0aSoXh9DMVDwFuyd/FYkd2mAR7D1s3zUSKFzXqDtnCTyR8g7hdZcEv4gdjWXPPJYemJJ5gjmN+pRsB5TKqwTMGY2F1rmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UgBMFkDq8qy+YTgmKNNuphPfoBuAEJXoicWHMnVzLHM=;
 b=pJMmNVAgY8vqBpjScyEqDPaR3R/g6Q/eayBZ3Q+SQLT6Sq7mFiaknHM1X4k+FSvY8JjoP23qGBw762gn4aOHi5Gnz4qx5sGAHGX48pd+MKxK9pH5DMNoMqPnDDPanlQzs6REYSO3dr19+h0ZHfNnx6ymra54OKP9qvqTPtkyY0fW2cHfKILX0jYyhRpZHZkDWpH04n6SWyAV2zm8W/MjWtvq8JUA1+uFCnrx/jvAl8OZ+IWNpbBHBmJVyFIPacY4itGnfJHXWcGsyzMu+TxJKs/zAoQbGAMm003MKunRe/IezFKqFsJfnBY3Ufad2Q1UJbSlIW0mTg9KHsn6u8aHHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UgBMFkDq8qy+YTgmKNNuphPfoBuAEJXoicWHMnVzLHM=;
 b=Dn06AEc+BGRRKS2h+timKuo+DkP35TvXdHsrEHO2dBY/WKdj2LVY2iJtfm2ABRKg74nMfnU3crx7KQ6dA9Y4aMG8nGVv6ExQAkdGVr7IL7Wiw3n9daIvMHFiDPTJpxVpqj2FFVT8ov75w7DvghzuHTbbfe2GliEPIuS8P4Jxqk4=
Received: from BN0PR04CA0073.namprd04.prod.outlook.com (2603:10b6:408:ea::18)
 by MW4PR12MB6705.namprd12.prod.outlook.com (2603:10b6:303:1e3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 13:32:45 +0000
Received: from LV8PEPF00000068.namprd03.prod.outlook.com
 (2603:10b6:408:ea:cafe::73) by BN0PR04CA0073.outlook.office365.com
 (2603:10b6:408:ea::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.6 via Frontend Transport; Tue, 24
 Nov 2026 13:32:45 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 LV8PEPF00000068.mail.protection.outlook.com (10.167.248.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Tue, 24 Nov 2026 13:32:45 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 24 Nov
 2026 07:32:43 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 24 Nov
 2026 07:32:43 -0600
Received: from pankaj-M75q.amd.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 24 Nov 2026 07:32:42 -0600
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>
CC: "H . Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, <linux-kernel@vger.kernel.org>,
	Mike Rapoport <rppt@kernel.org>, <linux-mm@kvack.org>,
	<linux-efi@vger.kernel.org>, <Pankaj.gupta.linux@gmail.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>
Subject: [PATCH RFC 1/3] x86/e820: Ignore memmap= in confidential guests
Date: Tue, 24 Nov 2026 07:32:39 -0600
Message-ID: <20261124133241.221719-2-pankaj.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261124133241.221719-1-pankaj.gupta@amd.com>
References: <20261124133241.221719-1-pankaj.gupta@amd.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF00000068:EE_|MW4PR12MB6705:EE_
X-MS-Office365-Filtering-Correlation-Id: fbd2def4-b305-4bd0-afef-08df4a2f6c84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|82310400026|36860700016|10067099003|11063799006|56012099006|261026140227099003|261021121427099003|261022105027099003|261009223027099003|261028144727099003|261026121527099003|261102123227099003|18002099003|22082099003|13003099007|3023799007;
X-Microsoft-Antispam-Message-Info:
	HitkX6ivI+idpQeccciY2CvjA9LdQv4XwvxsOdZFgAmzLAJl7HxMfUK0HN85S5HtfJELej1TY033+b6Nekh01u/mAtUwXcpbxg41/DGtK71Asx0ID5FluUcU1eLmXMJOsFz5m5HaDNNd0VUw/c/3P+mp4nXVW2T/yBzqpGG2L0nscG8znNAkuJYX4oA+qjwUqb/nDaEppVTi+KUKJaiuegpmzCv0LR6s1/0/2Pjg539dhINUrnUmRecPjEAJuDjPzrhP4mc1PhslsMSfmhe06eUFinb31JJSKMpAb70eJpN4M/yGB/vpg4foRFBj4LyGV/tZ6Dyw+vJ0CQowtcLIqJLWw4sqpy9thFWJZeb+saPlvgafqvhXF03XdZt1NU95NBX745jQqLK9E9t6EoH2FT6lEUBFi92+X+DpTtCZ0we0gSniCinLw9uu6W1mJbTIDyjIITNnccfGc4jzonjJD9XYdmTk+V9Oz6HMzkFI29IPa6D24/LUA+RKJiUv8N9Pv8ilGo8reWJsGlZS8/DubAEOS0oxWNijJuvhwkiYxv2ahPqpLdNt2jdVNAGiZmBvOb/waXNAZjyRkeq1g4PICg0Js8KuLjznfD3u5ZU+1o1JW4AsMNqHeXqNkBXOdjSnG9gKvUOlDd77aAbcY83PLQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(82310400026)(36860700016)(10067099003)(11063799006)(56012099006)(261026140227099003)(261021121427099003)(261022105027099003)(261009223027099003)(261028144727099003)(261026121527099003)(261102123227099003)(18002099003)(22082099003)(13003099007)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	l+9Y6GimPThjmkjK0VDkvb4904ai7waVJZOrznIsDmbtT9B3SMHqS4jG1CmEqBWod3RBY1D9yvp91S6tdZXP4lUoSd7fCccwr4EtyGta2htIr472Db/fZDXY56vOxwJZv+Y4Xpbq22flM9XedAdzGV5LoWprg8eYysO3kRBwaNoctYm6pikQiJGr54yyaf3GRv6dbVnwEZ0XfRmTnM9QPLyPIL+arDs/ogUnPssYi8yNkq+4LlhO+FTrWUGfGfQ6jFLaoxTTclg67YaRuAGPIRg9cH3CMn837CU52oG5Hkv7ujDghU4v9HpbWFPKv+1FY0RF79EGYM8+PxTrEne4s/cHia0mU0Ou18efXXiJzay8p9eeNWlKd7fQS80g/A/vKcFnd/7UvEkCmDRGda1NHBQSTsG+U/iW/0CRX+mA1l14znRc/Qj2UBRJn8Pbow8k
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 13:32:45.3934
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fbd2def4-b305-4bd0-afef-08df4a2f6c84
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF00000068.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6705

In a confidential guest the memory layout, including the EFI unaccepted
memory bitmap, is set up by the firmware and the EFI stub before the
command line is parsed. memmap= only edits the E820 table afterwards, so
the two no longer match.

The bitmap has one bit per unit and a unit cannot be partly accepted. A
memmap= hole that does not start and end on unit boundaries splits a unit.
Accepting that unit touches the hole, which faults early in boot on
SEV-SNP. A kexec kernel gets an E820 table in which the hole is still RAM.

Ard suggested to avoid such command line hacks in confidential VMs, as the
firmware's view of memory should be in sync with the OS [1]. The
discussion of the unaccepted memory fix [2] showed that the bitmap
cannot represent this case.

Warn and ignore memmap= in confidential guests.

[1] https://lore.kernel.org/all/deb5ea81-70bd-463d-8d98-ed51c316cf75@app.fastmail.com/
[2] https://lore.kernel.org/all/20261113105554.199912-1-pankaj.gupta@amd.com/

Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 arch/x86/kernel/e820.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 0967b485f38b..142657be690d 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -15,6 +15,7 @@
 #include <linux/firmware-map.h>
 #include <linux/sort.h>
 #include <linux/kvm_types.h>
+#include <linux/cc_platform.h>
 
 #include <asm/e820/api.h>
 #include <asm/setup.h>
@@ -905,6 +906,15 @@ __init unsigned long e820__end_of_low_ram_pfn(void)
 
 __initdata static int userdef;
 
+__init static bool cc_ignore_cmdline_mem(const char *opt)
+{
+	if (!cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
+		return false;
+
+	pr_warn("%s= is not supported in confidential guests, ignoring\n", opt);
+	return true;
+}
+
 /* The "mem=nopentium" boot option disables 4MB page tables on 32-bit kernels: */
 __init static int parse_memopt(char *p)
 {
@@ -997,6 +1007,9 @@ __init static int parse_memmap_one(char *p)
 
 __init static int parse_memmap_opt(char *str)
 {
+	if (cc_ignore_cmdline_mem("memmap"))
+		return 0;
+
 	while (str) {
 		char *k = strchr(str, ',');
 
-- 
2.34.1

