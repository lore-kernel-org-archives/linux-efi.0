Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.26
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795608192;
	b=RPGJTmyMTPPng2SBz1H9T7kyQ38riU+XDF8GZKFweh4nu2kiroOqsFqM1uvlK7146IH4
	 6LZBurN7kOInQliL9VJ+kvDXVhtQ8oKetFI3iECoEzoaeqO3srKQFLw7L07Hl3Y/sCAlX
	 4JiVXPvQNNzXPH2MHBAXkQ0xnzhV/MIBJxSMU0CqX6mxWKI+EOs8X9md7C28h4b5YH7aV
	 VMgfcgFQFf4SlD86lHrbHZY7xGVEyg50C4zMHlQrXrWEinWHXm1jjoX99SxauLeawRJ+5
	 qWFLmM9Zra1nWelHzgBglUQog4dWfOlKTKPymfpXpHdEJ5VfXU0Z3AMl13Wxsu12EHQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795608192;
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
	bh=oGy+saAa+it6vMWgG5xmcyVHalVc+ypp3DKxMEpyBLk=;
	b=E4Sa4RtEez8K2nUzgwakez7ErABAy7LfzlHqIOBjuRZrMaWfF701F9H29Y7IY/4VVo4r
	 WTsIa/xCzmmd9zmtRd24QYbDFWDiuTBykGM+dYUEwE+jHc0FPaWmLa/qeXc3gueGZGFO6
	 VGEKCt5icXflR75JCGtB4Rea5NoPMbgzQnk4qLxOInxw5veO3mhkAZ1Ynjv/dvx1HuMVv
	 l/o9kGqzhDmBnvg3IN9SLAcby4nvdIfmRGTnT7Wr47LcKHjuRc7DDdGH9NGUtUaAitAc2
	 vWUzIRRziznckPlGmyOVUAAJkRFw9mERAxowRrJPZgO28rMkiGzYmKrxMhdprcMdAJw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=XsdkYRYB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.26
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010026.outbound.protection.outlook.com [52.101.193.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6525A606A333;
	Wed, 25 Nov 2026 12:03:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6525A606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=XsdkYRYB
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PKEk81YjjmVP+X16/60s3VUw4nj495QD+w75zW8mjCA8MLEr+R4fj8t6lU76FCluR47M1rGLqTVtbabWXOUkLzai6XwU7mKCMX6f53eTuR8JdZwYFxV42gHBysJtKusWLFcQeoB84Qkjt9j1KSGy07z8ho1Cf1YazwRlLt4T3InaXa6m/MQ21hi4RTF5lnXwkQ56HjnisUM75AFEVrZ00JHPXMguMqg3DAHCQCjABOr2+AIEdFBCGK5nkirhO4kk75gPzGubd+5+QFO010wN7ms3tjP2+IS9W+aCLgzwWh/m7LZjvQyP+nAvnCupnOKZKF7YZR/LAwDWshFqQHrvzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oGy+saAa+it6vMWgG5xmcyVHalVc+ypp3DKxMEpyBLk=;
 b=JcEzx9drHf+A/nr3A3CNhAUscQh3eHE/FzQtl+9O6+DMkRlUDJcUjsXQnT8hmzHGELSadS/yN1MeI64zMFMZydFx/7VtQbHxCCdspHiWOuSnfNmSnAWjgP3WilA9tA815OPnketO3sl1ZGJ1v5VrepUfC11ckOvMlmQXUnSAYGL8OhjNrsNdvnp9uo5bDVEkzNdoIQmDgwlTF+GQ5sNh0igNTchmWZlhhJi/+ybcEvvpet26LsRyfXCQpHNnPQn/KSLmIjWGxCzv5Z6L30xnqwKcgq7N79ktTbb8vcVGa0RKaBawrvZy9dBBPFfC/Arml4TPQysVtIJs34KHlzOZcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oGy+saAa+it6vMWgG5xmcyVHalVc+ypp3DKxMEpyBLk=;
 b=XsdkYRYBUrHmrBhklqAxPRTF1WYR2t4hN0HJCIwT145HIGBsPx39bI4GHxu6pHeQIt7EFTCBVEHRISPeTj/wfUO1BVnEhkkt5cAaR46Gogj6tAHBkVEA8hihFG5O9T+6l5Nm+5DzatGXAJcRU/NEgq0kNFXIECy0c8jeYQYGUiU=
Received: from CH0PR08CA0016.namprd08.prod.outlook.com (2603:10b6:610:33::21)
 by SJ0PR12MB6735.namprd12.prod.outlook.com (2603:10b6:a03:479::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 12:03:03 +0000
Received: from CH1PEPF0005BD61.namprd02.prod.outlook.com
 (2603:10b6:610:33:cafe::88) by CH0PR08CA0016.outlook.office365.com
 (2603:10b6:610:33::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Wed, 25
 Nov 2026 12:03:03 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0005BD61.mail.protection.outlook.com (10.167.244.250) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Wed, 25 Nov 2026 12:03:03 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 06:03:02 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 06:03:02 -0600
Received: from pankaj-M75q.amd.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Wed, 25 Nov 2026 06:03:01 -0600
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, <rdunlap@infradead.org>,
	<linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Marco Elver <elver@google.com>, "H . Peter Anvin" <hpa@zytor.com>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, Ard Biesheuvel <ardb@kernel.org>, "Kiryl
 Shutsemau" <kas@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	<linux-kernel@vger.kernel.org>, Mike Rapoport <rppt@kernel.org>,
	<linux-mm@kvack.org>, <linux-efi@vger.kernel.org>,
	<Pankaj.gupta.linux@gmail.com>, Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Karl Mehltretter <kmehltretter@gmail.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>
Subject: [PATCH] Documentation: kernel-parameters: memmap= and mem= in confidential guests
Date: Wed, 25 Nov 2026 06:03:01 -0600
Message-ID: <20261125120301.223907-1-pankaj.gupta@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0005BD61:EE_|SJ0PR12MB6735:EE_
X-MS-Office365-Filtering-Correlation-Id: 51706745-e4c3-40c9-a7c9-08df4aec0ee4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|7416014|376014|23010399003|82310400026|10067099003|11063799006|56012099006|261021121427099003|261009223027099003|261102123227099003|261026121527099003|18002099003|6133799003|13003099007|3023799007;
X-Microsoft-Antispam-Message-Info:
	wnB0FcRGvoqCkRlai19Kzh4LY+pROvIOyjKnRS95lMWLQPEDAkZ2w86lDJRFr18ekclttZ/CY8vz3ZtOgOS26eKfo0oY5KLbKzGWOaHHkY8lE6jwc1z6SSLQuuGAlYIPjAM88fKsORhglQqPlVPXKeK84POQpXNWEIrVRRPSle4ThzYlCEsU53Fw7sMkuonXDAQ6JitV6UK5+XX5Nw+uGVYLYmTF5gdWkdnYpBu/sJwWgP2tEvEo33rus4cWGXE+c5tMvEfn7P6tZX9bLxcT6ar1zCWiW5B5kmdUQnu2w1vMVzm6DULJdtBJK715/7yu9Jmnaxb/104mjQfTIpK3+REp69t9mw8YlGWo6xMnZGZcG7QOOS5UjIJB8jKHvk1WFSoIFi9X2kGtg8odtgVYKZGu8tjyx8cvPwOlBZn2VwMTrMtgZ1CBBUxIrON/ynHSL6zVSIj2WWb+yaL5v8Z8UNted6GlQ1RqxuRJ+THCFq+b8V658DQ32htp4/7JSMwUOjHQuqPvxgal0kxKfaeZI/P+yctqThay/A3QHktziL3KSUhPPqWDqrb8zVGsMKVpsv3a/EdCgOJ70/MS9j40SGWK6zTbxu0+hjIY0pTnnD0J0+T4bZA0TuOB+bNdABvON8VveLrycZ0Qo9U1GOQeb2/JZcCYwKUMWZgEF9IYtHU=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(7416014)(376014)(23010399003)(82310400026)(10067099003)(11063799006)(56012099006)(261021121427099003)(261009223027099003)(261102123227099003)(261026121527099003)(18002099003)(6133799003)(13003099007)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nlj0ytbhmoAGAAo1N23hl3D221oEbMX07qEek5fJmAUKwk1dFU3qqaZFtnazt79cdNc/jorBlETDPYvTOO/o5XH7G3igfyuNI1subTZL6bywTz/+2Nfj+nH7RQjhqAfSW1xhQE+SrKpjNC5Z1hLLhOSKTrmIyso/d9vj6NwvqH32Gt+xZ7yik/D2V9VNb7KCRfkw0JsmnRev0AZQ35O96JgpX+4nkKPcapHx/aNZYUq0odBF+hPUq/YyKfCPzirn8CH7kaJfT1tThEpu5GDDQPCBVEfWyp5ZCNvcUonAHCTrQF4z2Of0+lWgobkgPn0+A4dlYcB3BVbFqBmPufqoOplJj/7/7y7bDvKELJ6k0hTLLaDlZ5H31O40nk5A/FHKdSANSy4oaBC7sEjq9aGrcCXLGxlyRtewdlVNrfOpF+i5C700ff1dhWWZweAO8147
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 12:03:03.1921
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51706745-e4c3-40c9-a7c9-08df4aec0ee4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0005BD61.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6735

In a confidential guest (SEV-SNP, TDX) the EFI stub builds the unaccepted
memory bitmap before the command line is parsed. memmap= and mem= edit
the E820 table only afterwards, so the two no longer match.

accept_memory() accepts whole units (2 MiB on x86). On SEV-SNP this can
touch a memmap= hole, which is not mapped, and crashes the guest early
in boot. TDX accepts by physical address and does not fault.

Making the bitmap follow these options is not feasible in current design,
as a unit cannot be half accepted. These options are debugging tools,
so document that they are not supported in confidential guests that use
unaccepted memory.

Link: https://lore.kernel.org/all/96be8f5a-8f65-48ff-8263-1d5d5f706354@intel.com/
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index dce9b8f3ae98..d0e9a2c7dddb 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3930,6 +3930,12 @@ Kernel parameters
 			in above case 3, memory may need be hot added after boot
 			if system memory of hypervisor is not sufficient.
 
+			[X86] Not supported in confidential guests (SEV-SNP,
+			TDX) that use unaccepted memory. The unaccepted memory
+			bitmap is built before the command line is parsed and
+			does not follow mem=, so memory that is no longer in
+			the memory map may still be accepted.
+
 	mem=nn[KMG]@ss[KMG]
 			[ARM,MIPS,EARLY] - override the memory layout
 			reported by firmware.
@@ -3971,6 +3977,12 @@ Kernel parameters
 			Example:
 				memmap=100M@2G,100M#3G,1G!1024G
 
+			[X86] Not supported in confidential guests (SEV-SNP,
+			TDX) that use unaccepted memory. The unaccepted memory
+			bitmap is built before the command line is parsed and
+			does not follow memmap=. A memory hole can crash an
+			SEV-SNP guest early in boot.
+
 	memmap=nn[KMG]#ss[KMG]
 			[KNL,ACPI,EARLY] Mark specific memory as ACPI data.
 			Region of memory to be marked is from ss to ss+nn.
-- 
2.34.1

