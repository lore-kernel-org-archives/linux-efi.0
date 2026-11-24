Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795527167;
	b=RhvJ5CnWo21nnXLQYp/JSMdUsfMVZD4bzYCbWaIUYh3oVBtXVgkoT1/PRnW8LWvEwfSm
	 jXYM6Pb5M0onb5WJG2UCUmyL1uoLSnEOMbA2fRAZaPw6Ni/oOkkznwLyHExAt0IkxI4dS
	 SiVuBusqHbLanpKoCiTdWm+zzLGKL7H/TqWzJTaD+t28A4kYnhygDRoU2S7S+NZTsAw/X
	 0tO2LsfqgpgNx6gNuJ00lvX2smGAFSiCjNE0BF9BLAJzeVGMUWAewDfq9+LSGNg6O22d/
	 OICjFaTg/zG4enTZM0nSzTvrhecOi7j6JQjwVScTSa+xppaRH4rR72qLaf37Ob+gWug==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795527167;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=dofZdROUMZPu7dFW3u4qdC+7Fdjz/G7X4RZlyzhURoo=;
	b=OjDS9zqvHI5bs+YKqXByFsSskUdDUPT7Ek3qxNtBxtcIGW0HHyNDzrXzN66zz54nrxNh
	 m9aq4tmTaVy2Mfk8CKEOXnEooM16an6YM62sloRrqC+1bSYnwsTrKbV4ZLPcjcSLOL1XX
	 SMCn/BRc5QsGdeoP23Kvy01MGr3xvsV+WFdKb2WMiUzAeD8d/XIqAx+svZUBv2oN+oWus
	 hhZI0yJiJ9V1Ji8UbyjsvCZVmdsYq13HfpsbxwyKRxS70gi3n5SWtrEiOZzPbnV73b3jW
	 e4ic7LctPk2D+cCUZvmweVGW7i5VpLm+YCreSv+Gr8gifEMtLNhYg6+ToPIgeoz88Zg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=TP7ACaWA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.9
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012009.outbound.protection.outlook.com [40.107.209.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5A0606A31E;
	Tue, 24 Nov 2026 13:32:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E5A0606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=TP7ACaWA
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LeKvpDJ0/6Gnq29D7ZT12l0fjAHIHX1XVCozu9DBSweXKLU9pjpncc4C9fgharkns0smbvHZgNEuUaPS3OOdIqDSiZZF65UNgPDYW14A37EIisvfE/p1Te7zvb0qKSCO5A0BGlWRMV2Nm0Lfgv1Imrbk0IyurjyCYwCEKfXv4o1h2TDS445NYjIsBWDD1FHuoCNKScGYHby8KEn+svKPRcMIYikiIdyygJoPoGztZcL8KpCPWs5iWK5Zu6H2SJepxiA2og9MzR4kU+Izg5s4pZpIkLjOzQrhdl3p4xTyc6a9BJ6ckSFNP81TL7bR4kA+97UasFEUUNrR3WOiTvNB2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dofZdROUMZPu7dFW3u4qdC+7Fdjz/G7X4RZlyzhURoo=;
 b=h8ceNq5eOMw7aQ36Dsv8FANh6roC1haUA4SWjmVGdcCULCPahrXMuhvsnc6/S3qo4w/w2vMDgp7jz1431TOxPOnmxVTH31GhZCf4xQAsVpiOuE+DxqJ1Z0NbldbqQ1dYR/6eMuK0lDbotgvj1FAEXes7dMCxuKf5wXE+NBttiA4+C4cmwBCytTtZlhVo4/xqJlBSenU7W2ETw4TFACEjxcMIsgzgqiASgycbFONORwCa2r8JVyqWfdUzy5YtTT+01k/Mbof9MHEd+i5FV6mdttMR2X/rDXPe1eTQO59kdka4tSWki1ydY9FfCaGYggBruXwtYvjZwkA1gGDPCWaC/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dofZdROUMZPu7dFW3u4qdC+7Fdjz/G7X4RZlyzhURoo=;
 b=TP7ACaWA8tS06brQJ83Eh9dOmiZO3opdhZE33sMacn9x/Dvem/4kUSJ7AtwqDscsTTDOlOasIVLKINlXBZg3k309cMSGeldLKBu9RDJGXf2Cva2B9kEUjAeryHuYbGWG3hVS6GanjXhiJjmINHLqNYe23fyWc+dbe+MFP3qd948=
Received: from BN9P220CA0012.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::17)
 by CH3PR12MB8307.namprd12.prod.outlook.com (2603:10b6:610:12f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Tue, 24 Nov
 2026 13:32:43 +0000
Received: from BN1PEPF00018546.namprd05.prod.outlook.com
 (2603:10b6:408:13e:cafe::6f) by BN9P220CA0012.outlook.office365.com
 (2603:10b6:408:13e::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.13 via Frontend Transport; Tue,
 24 Nov 2026 13:32:43 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF00018546.mail.protection.outlook.com (10.167.248.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Tue, 24 Nov 2026 13:32:42 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 24 Nov
 2026 07:32:42 -0600
Received: from pankaj-M75q.amd.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 24 Nov 2026 07:32:41 -0600
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
Subject: [PATCH RFC 0/3] x86/e820: Ignore memmap= and mem= in confidential guests
Date: Tue, 24 Nov 2026 07:32:38 -0600
Message-ID: <20261124133241.221719-1-pankaj.gupta@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00018546:EE_|CH3PR12MB8307:EE_
X-MS-Office365-Filtering-Correlation-Id: 96d9d5ba-4e80-4047-f5bb-08df4a2f6ad8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|1800799024|82310400026|376014|7416014|261026121527099003|261022075727099003|261102123227099003|261021121427099003|10067099003|11063799006|56012099006|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	Iv/nkqYAZBvwK5QFN7x05U2QMx7FIW4ZGKoaXWL49Rf7ui4mDGte40cY9wShD2wDRKXFZMwjRAw7+3h3Xv4LI1SNExSTKYU5gF5Fp/t4iqgUvsWxOdvq90gOjkbrE2nQv8/n3eGD2A178v1X7O1ofgw5ctJqs01T4NRmW8+z0Wgw4RplmGGWfbHLxnk2ik+iNsaeE/Ajittg8PE9WT1Ammo13BulS9pLd7WAwcS8fjIUcloHiYQ3mxOFEjcXO6JgoXAEG10qbbEdsPp6zyZN32tiSkWl+EcZWgm9U6PqNQ+p15JFo5N2lLjsrszFpovd04Uyw5kGfxOd3SII3LmNuaV/rFG0Q2W0RjVPKWue03kJHj5C64CqwdTsL1/KXahM5KWflxCmCgZ2OSBffseH0xP601tffAjI5gTzWIy7TftBzIEBY9nvOurIaeyuddevxdXo+OiHYd/J3nVJdgfPlhfMDorNO6dG9ghRNV2b5xI85Le6W9tcDrP2h34xsePudXBuKHqBMmjU49XOwnE4klheDdN07bspDkiv9Iv6CEf6/rVBRKH3tabKXNHW+tXDdQnVUWFnVS5rNtr3vUY+Vagql1F2XTPXxreqVFeKPZpdiFEY0VKhJqynSsdjMvZfj6nsVXhzjJixVmnU7zUm0s9jciezudi/Ngerdgl29FE=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(1800799024)(82310400026)(376014)(7416014)(261026121527099003)(261022075727099003)(261102123227099003)(261021121427099003)(10067099003)(11063799006)(56012099006)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	IhBXbntBtOPPZuLsGCYS40b/KkOLYPbVBf0rN8t2sF+ShJU/dN9/WU3FPCKaVKc+yPX8L0FKYlws6gPk5i2KdFnanUNLSqbudnQwUTYx4T73fMt3Ywe75j7Y+2UBQNPwbCBhz9sQDl90QUwrFlzeqC13Gi/valGdEttmiPr1GGSngc8xAzfxuzmUm6qn975u/RumjWev4I0fPfUmtX2TngOK1DKvwDzRFGDKaIyHdYWFlnBfVydzXL+UxUcEhdjr9pUtwIHSz7qrgvUiGmMUzUcoTykH4it4EsHmoTjWqK/gt0LrdFbn+INcu2yBomcFm4IO84J7DMRIB0RrM072W07vJ7geLMTeLqXOIRRQxoP2wI2UVFsFtt5EWQY+ReSdn9Wk3CpqTnRz4CRhAtElWhtFtMwU3ET0LBV9Vo3X/TCE0RAVHAA8Zf/QFQ3FauoU
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 13:32:42.5915
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 96d9d5ba-4e80-4047-f5bb-08df4a2f6ad8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018546.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8307

In a confidential guest (SEV-SNP, TDX) the EFI stub builds the unaccepted
memory bitmap before the command line is parsed. memmap= and mem= edit
e820_table only afterwards.

accept_memory() accepts whole 2 MiB units. A memmap= hole that is not
unit-aligned is touched when its unit is accepted. On SEV-SNP this faults
early in boot and crashes the guest (e.g. memmap=1M$0x1ffe00000), because
PVALIDATE needs the page mapped and the hole is not. TDX works on
physical addresses, so the hole is accepted and the options work there
today. The same option therefore behaves differently per vendor.

This replaces my earlier fix [1][2], following review feedback from Ard
Biesheuvel and Kiryl Shutsemau: the firmware's view of memory must match
the OS, and a bitmap unit cannot be half accepted. Instead of making the
bitmap follow memmap= and mem=, ignore them in confidential guests.

Patch 1 warns and ignores memmap= in confidential guests.
Patch 2 keeps memmap= in a kdump kernel (elfcorehdr= on the command
        line), as ignoring it would let the kdump kernel use the memory
        of the crashed kernel.
Patch 3 does the same for mem=.

[1] https://lore.kernel.org/all/20261102113127.161823-1-pankaj.gupta@amd.com/
[2] https://lore.kernel.org/all/20261113105554.199912-1-pankaj.gupta@amd.com/

Pankaj Gupta (3):
  x86/e820: Ignore memmap= in confidential guests
  x86/e820: Allow memmap= in a kdump kernel in confidential guests
  x86/e820: Ignore mem= in confidential guests

 arch/x86/kernel/e820.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

-- 
2.34.1

