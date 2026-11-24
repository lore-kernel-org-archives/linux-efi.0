Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795527195;
	b=Yx6/kUtNWG04yklDP8yC4YnaA4osyABfB9uH/IE4CWzBe5NGZ7uvSrFk+cGkTbmK9mxW
	 eJhYuvdT6e5Nk4wXhXN0os23JhpCIA29F6X4H5VKR634E2IedHF4AKElSnDB/gLRgG5v1
	 vOGEik/s3FWKKg//Cb4FBZSxpBHf+jfqe9LXEe2hmVDmBqXD5pBMka+RYrpgN89xmqWy5
	 JFKKlFtsV1dRzZMMmTEm+6H9jxxQQM4YOsxr92KpFrT6x14KBuJWVQnv8Y8r0iIZ6mRzH
	 zq7jToMOmNQC/J//ejRMU0D14NhY9Z0gDu6cGgvo0SFzQh/o07szaNKo/jXxkzwsSQA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795527195;
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
	bh=1wdoQHbPv3tXS7S4MStolc76uOgtWQZBqgClzx/HElo=;
	b=f6qcwYIUmop/Lp4bHCuKJBzocaQAKuM+v9kJX8UIqaGgV0GrgdlaaqBp2RBcxv63NSt5
	 rb8oiQmBt5IrPwdSQtlc3oLdMsyZY6SmDod0tf/2g82IDxfpONn8XFisOVCbBjx/vSwMf
	 PEJu9dlcgyVywIUNCy3zrKA7rjrM3maP2gMGR8JoIyUkxAa7PpCL9YLFf9vz3xXuafV6v
	 vOU+6xjv9SWeOvbcF2IpcNLHNnAU3pE8FpsCwVNwyNPlBFn/DD1PCjddAejCGuIm/PD07
	 xSLhZvhimMvl1+Jvi8aS+NASzPj9w7meAly56UlPRYHJzH/sTe520i1N1rxZyzqM4hA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=gcMMxg3e;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.35
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010035.outbound.protection.outlook.com [52.101.61.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F396606A33B;
	Tue, 24 Nov 2026 13:33:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F396606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=gcMMxg3e
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pF1JYmYHIJI+BSYrbbuTbLmOFm/ZXrTaMfx+Cu1Tnb7k8tdSYaVGxI8LMCNcFNTJ97emGsY+UVwG+Sed1L+LeEiMmx8EsEWrR7GNCZVXIPyjedu1mmEbSsfJl/YquIOUPQSFFTlKs1A5pBY/kJ/b5uTJPASCqlVyYTZZm1TD8Pnh3j5g6I2UL9k0ch5Vq/XPVlaMbVMLwlgiNjjVo642IsiZ5wpLuYMTtlpiEBvWSxe66AGP9y+pPStZ58f+tOvjC/BIVJr5p3gDJ95KU5rTHOtAr23Cl7YtmJt1fnvnX8N0Wj1Qi3ILQ2rB5DF9H1N3cPiKOGA50rIidfex69b+ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1wdoQHbPv3tXS7S4MStolc76uOgtWQZBqgClzx/HElo=;
 b=tHLihW/e+afyCpontU84xI86CxDAzcn0d74in9RTPpBicHnXgmoRJGNdIETpcO7mil5l8Nz5pa/N1eSqhWALxD2/aksL3koLiiqA9tXQHUTorHP+y5Yk09GjbmwMYZY0AX9Shgim0Qtw3Eg6TaEaYLDW1wyoWeuGP+7HroKjgwBu9i6CGFKWa8qH/nrj8aLq/2wehR/4r2tuJAzvBW3IzkwfmfHgKQStcgn6FW4cxKEr22G7BMJ46CpN737++HgEsL4vvSamUH5ih/gPkYAE8Zh00dsDp7Uotiku2TC55QCjlpBF2Xpnnzhm/PW7jogpfBBDt3dJgGQT1d2C0BEQPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wdoQHbPv3tXS7S4MStolc76uOgtWQZBqgClzx/HElo=;
 b=gcMMxg3ek/EA9w8jNoQ9wguHVXjoN+Uf6Tx9bXmO1PSimCMjs+YY2sovr50+tX/QkUoNFoPklYZusfktfBl4jRX1VI3VCBxajpQC6GDBhGEvdtn4tcgZ1XLa4I+X25LpPAkhOBFVgnVYt3cr04RxoShrMbwYwQzvWXBNLfAWLvk=
Received: from BN0PR04CA0080.namprd04.prod.outlook.com (2603:10b6:408:ea::25)
 by DM4PR12MB6109.namprd12.prod.outlook.com (2603:10b6:8:ae::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.4; Tue, 24 Nov
 2026 13:32:47 +0000
Received: from LV8PEPF00000068.namprd03.prod.outlook.com
 (2603:10b6:408:ea:cafe::aa) by BN0PR04CA0080.outlook.office365.com
 (2603:10b6:408:ea::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.6 via Frontend Transport; Tue, 24
 Nov 2026 13:32:46 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 LV8PEPF00000068.mail.protection.outlook.com (10.167.248.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Tue, 24 Nov 2026 13:32:46 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 24 Nov
 2026 07:32:45 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 24 Nov
 2026 07:32:44 -0600
Received: from pankaj-M75q.amd.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 24 Nov 2026 07:32:44 -0600
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
Subject: [PATCH RFC 3/3] x86/e820: Ignore mem= in confidential guests
Date: Tue, 24 Nov 2026 07:32:41 -0600
Message-ID: <20261124133241.221719-4-pankaj.gupta@amd.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF00000068:EE_|DM4PR12MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: a137cdd8-6f2b-4f86-8c0b-08df4a2f6d26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700016|23010399003|1800799024|82310400026|10067099003|11063799006|56012099006|261021121427099003|261102123227099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	u+MHLehXfHQFP4KAI7hgNY4Ncw+1lRAgTb4UnFBKqz1oyJDrLyo/8tKOOndwbJ/V3e54sID08W7stvfkV5Fblx3lIUdS/YvRwau1yeud0PCzQmtSg1bUVsblLnG9RCTI6U6TdUH1nhpUm+qiMObY7yqhgHM7c2eHOWXlDKl0kelzC5z9wfjvqAw0fMNNNK5u8XqnGJ18mIx+zGtjtJrue7VZPsRhNaqoX6VuQWykvBEoHrGDK/lQNFTRZ4NIiaDUCYDX6vI6vcbYlTtR3RpphqQzA9ZW+e1nQSl8BVWG2/tBEpF54QM1wo1aDkFz32UeOQ7JkO327huBeC5TaCO/HbDu0w0b5EC/Ia2MC9NtQM2IeuW84RfH4lJnDrVgdFlViZ0h0CPfr2cfAFK9E/YK92h6+5gQKHgjgpkcvXFbQzbYEadMnjX6zWNBIvLktnnV23/2he/G/CXkOIRds7TYJBoAJrnSDTLtPD/lrnjp65Oe+3eLktsZvRn2wrpaOEN/eI0P3eUJIT0Na0Xkhy3uSzCOUxVuFLeiGMIFeWtigpw4/it/Q3nCtzsh/mLyemceRvsvjdsh8hQmGBPjkJnRoePh6G3cWQWxdUD7bqGSWOJ84bR674MioTpklLybAOcT6mgYGh8mRPSAIExBToO7LBLlArbENuDCuSgmGQmJGifDG6PazyvP47366XETbYqkZBMg1B4QdA5WJ6+RhgagzQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700016)(23010399003)(1800799024)(82310400026)(10067099003)(11063799006)(56012099006)(261021121427099003)(261102123227099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mP0Kptxin80t7k+xLYrlgUvxTQdLtQouTV4MJsn+XF9jSK6afXJmVsimjjtTRAIZInFA5Ihc+YXKWmPuIhHkI8PwHn2TIwR3WSTppMtTiVwGkgq0AKryZW3E93n/UcunOraphXLHFJYZ5xVR59/ZnWtzBYRfOCoHnU+oAiyDa3W3RV/JruajYzv+aYG3rk3jj/03jOtCZt/Vo3x8pt2s25hJqOcJLYqV9T3QlVzTT9aXKwhkBbHQCuWzAmNPl3k2qyCMiJfFEy4jCE+PXqX4hoIZ5Txgu7fmB4SUgck2avijYiieOyp0coZCOp9xwrABhacipiF3aeR0YIKpwlx7S6WLDOHSYcKkTFPV/nh6F+uiixo2losInk7VtfLBp4wU4AZGnA3CwS1SkB4//lVdNdyol4dOBct1eZlajjnil77Otum4LxDO8xBt4DoRTD08
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 13:32:46.4507
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a137cdd8-6f2b-4f86-8c0b-08df4a2f6d26
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF00000068.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6109

mem= also only edits the E820 table, after the firmware and the EFI stub
have set up the unaccepted memory bitmap. It removes the RAM above the
given limit, but the bitmap bits for it stay set.

accept_memory() accepts whole units, and one more unit when the range ends
on a unit boundary.  Memory below the limit can therefore pull in a unit
that is no longer in the E820 table. On SEV-SNP that memory is not mapped
and PVALIDATE faults.

Warn and ignore mem= in confidential guests, for the same reason as
memmap=.

Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 arch/x86/kernel/e820.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 9c206ad4369c..c7b86267a480 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -940,6 +940,9 @@ __init static int parse_memopt(char *p)
 #endif
 	}
 
+	if (cc_ignore_cmdline_mem("mem"))
+		return 0;
+
 	userdef = 1;
 	mem_size = memparse(p, &p);
 
-- 
2.34.1

