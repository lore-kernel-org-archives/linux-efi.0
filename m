Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010028.outbound.protection.outlook.com [52.101.69.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AED3468C38;
	Mon, 21 Sep 2026 10:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.28
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789985465; cv=fail; b=B5Gh1djIs8Xo3XQK6+FIFL3e99l/9StqGmzwRqeWrRbMb/CV6bPiEMKIN0it5YrTjGQyST30udwB3jPh/Hi2QUrsDDiyWl8XQFvotdCiJm7xA/8xW0H++wpFhXt0YBqUrXb3xnnOwgd2M1ez5cyFemV+OulDmm5p/a/yxR8iHIc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789985465; c=relaxed/simple;
	bh=aETYjRpJWjr3oB1l2oTB33T0Emy1Az4jez/MTNpjzfI=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=k0q7ch34lqmC+vVrmmd6Y3cE8NeesQe+947JLwF+IAN3Mkq6a21oWXs005ypZ6kFFfJCaNpps7FfQUDurdL6EjDBLq1ECm7UJaViMIMMWRCsh4Lu4GPTphC3KGsIIYmMD5K3DckN+8sYZSYz/qBKQkfmiCFp8dBmBGeAixkYJKw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KSjYm7Od; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KSjYm7Od; arc=fail smtp.client-ip=52.101.69.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KSjYm7Od";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KSjYm7Od"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=nNt3sJzi7fP6XjyA2ppCkFF7+K1m2IzQ0SNDBm73MJFg6gNuq82/KCz+Y+TAk16QNn1HMZZixg33eZsp0CYsxwOEoIktgXt9V6YKTWhSvxcYD90EtAaRUZXYvZGwOJGX7Hxc1DYwu/h7W2uHpniYuWHsc9CRot2jA16CwaN8yvHtWQwF0V/10itIut1z4kGo+2HfZmvdrbsL8OZSR0S0F7SoPVyej5si3VoH5W5+WY9WdyaUqd9JjwErgF9GZY1f5YLRoOMbmUKWXd8+rriu/s72YIpzZvOxicn3gvtxwAKuG9zHktIcTvsZDpzPJymiC8KgfjgryBdFvXuCIhNagQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F4oj47cuKoBuocTWEpuMe6bRhgzlfgxqzYPzZ7en4FY=;
 b=Zrbcil4MA2o0TdXrm5aoFoqHYrgffPopaxeHzRXVlYXqpBaA8lRA03EwQcjDV4pWxWFM26VJUtnEJLW3ff/kyzvzb+sQDwGNyB86CMJ2tlD5lwHzCA51pwTCkkbUVVu0cAHuwU4HvEqmI5fqkVcFTBBhHkAbaoV/KqCZlAzJzfkSyKFVRyZ6pDdwPWXL1VQey0dEByP4RAoE4IsRXXRbR7fjkS9UhHiUuhLrsb5yvOyMfDHFo0nFiCdYkq3nJ1iu1y8neYFYFC576RCxVL5HBPkuwNvcZUrXAwA/6WzCswANVvt8lLT2GCtZAt3Dk0tp6ZdxcXXEav6IpGp86un2HA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F4oj47cuKoBuocTWEpuMe6bRhgzlfgxqzYPzZ7en4FY=;
 b=KSjYm7Od6bd+XjJdb2pYFmrp6UqN6j+uTY+rULw1r70P1pf7Ku9g3IpEXXXfHcFJn8ZmVVrLlM1NDCk9NZ8+Z5Zp44V1Qm9JRaFtRWViclnT+N1l3LZ+sd1WH3Tr5JxB++xU6ryGeUpYqXArKLvOp1BQUO6mBSqFjGPJmD3p1VY=
Received: from AS4P190CA0015.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:5de::19)
 by AMBPR08MB999823.eurprd08.prod.outlook.com (2603:10a6:20b:786::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.13; Mon, 21 Sep
 2026 10:10:57 +0000
Received: from CPH1EPF00000523.eurprd05.prod.outlook.com
 (2603:10a6:20b:5de:cafe::50) by AS4P190CA0015.outlook.office365.com
 (2603:10a6:20b:5de::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Mon,
 21 Sep 2026 10:10:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 CPH1EPF00000523.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.8
 via Frontend Transport; Mon, 21 Sep 2026 10:10:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U8zPozQgyO0BdotAodhEOQanTbZUGxGx6CQEreObegNvFSt0/VLBDRj7TKgFeukluhvdiTHYwVwAmk3LMYlpTWH8R0wORVUv9jw4KnZYjBAR3SOL9nG884moC/UVQOcytVVv5eig/91+Y8LWnfq6PVzWb5BfCwRqqISiPwUR9T1nnes3UVBEu1/cfK2LRtREsG693kGlN4LBGXwictJj9eNSnX4dT2+d5qxByoo+01DEFXzapO041HP3Ds66HSNc7qfDzU8ohiAWjIpqySDHzTq1BCX0MpNL/OZqNxZ3SlaVZI9WsgQi4Qo9YVZHXcjwr4BCDTG47AOnGIgIzT8BvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F4oj47cuKoBuocTWEpuMe6bRhgzlfgxqzYPzZ7en4FY=;
 b=B1Jc7+vfiqNkyGFz4OGNmgF/VawzDnBLv6wG3wEyZMl+vwDhc+4ogE1U1fdLqDRXkiqflNc3/2UJdCRO6nIogYN5wcNfR7FskMVlytMePDUXXlP3cwgcOCwLDv6TptbGzB8QAbKZzil6FemEx60mPVxSL0aEONQfXK4/fvpGrtNe2jXAqmecixMVGHiN+gYT8gPM9H8xcp5xCku+yUJaR9Hw6w5V/HaB7HKpF01sE2zQ/QW8SHz/vakqc4s2PN+havXOm/ZmjmWpNAGGJMFeOvom8TLAy91rY0PExX6i3K51PO+4GlrkHdBrCE//4zzAuKtgFfifF4pr+eaftgNQBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F4oj47cuKoBuocTWEpuMe6bRhgzlfgxqzYPzZ7en4FY=;
 b=KSjYm7Od6bd+XjJdb2pYFmrp6UqN6j+uTY+rULw1r70P1pf7Ku9g3IpEXXXfHcFJn8ZmVVrLlM1NDCk9NZ8+Z5Zp44V1Qm9JRaFtRWViclnT+N1l3LZ+sd1WH3Tr5JxB++xU6ryGeUpYqXArKLvOp1BQUO6mBSqFjGPJmD3p1VY=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by AS2PR08MB8261.eurprd08.prod.outlook.com (2603:10a6:20b:550::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 10:10:20 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0451.004; Mon, 21 Sep 2026
 10:10:20 +0000
Message-ID: <468def35-77e0-4fd7-9e4f-30d982bc17d7@arm.com>
Date: Mon, 21 Sep 2026 11:10:18 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
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
Subject: Re: [PATCH 0/6] arm64: distinguish HW PTE pointers from SW PTE value
 pointers
To: Ryan Roberts <ryan.roberts@arm.com>
References: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
 <27fb625b-7117-4666-9a34-3b8aa9a43833@arm.com>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <27fb625b-7117-4666-9a34-3b8aa9a43833@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0096.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::11) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|AS2PR08MB8261:EE_|CPH1EPF00000523:EE_|AMBPR08MB999823:EE_
X-MS-Office365-Filtering-Correlation-Id: a9dfeb28-c408-45b5-d1fe-08df17c8a0d4
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|11063799006|56012099006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 S1gkwUjzI6hLTUdJefCqchG2z08f70MFKw7j3RZF7mdWwC199J99DvWzQ4Q2efig7Rhhbq4KPrISi7ZisnwvqfSTv4pGhsnFgVJwnOvOf/xUoZF3cdlScHCcBwBFlJ0I0Kxv6vSyytQ++XSUyM4Yg7TVbsDuixcgmu6n0QWB9tFzOfuMevYbJ2NKOlNFzXCVFhSjHg9z1u7E2MajhM/ltyuEcdEwzAr4BRGXKRNd/uTt2NG412BCXp82OPQlOMLu7KFGza1OCBTIZMzdo0Bbwx375T7+CDA/qkBNZTvEIuMdTUXDsa1pqhf3YKctV7EMKqcIPwUZ1nzXGe8s8+3CpZpRPORSv7pCIMHsIPSxn+2K7TaOO5FYC2iqEADzkZDaRmPN1rFoNRdTMmxHLsDnPVYwKQVUZqhGSr8YSNZr4OQyU7tCgM/9XjYwa53/8ocFgVbWICdQl/uQndKWRFoxYr7JA0zudfepRuEqjp1EC22/hBgOrghZcJfNcysRQnlQh1rS2DfdyqU+0yIUq31V2X8MbdAIg/WYD6riPl8NFHzS082amDq4ZpRFUO/TnVBvigojuVOQ68Jp+JOyvk6EYvGa/PsX5Cby1W+bBsXpkrXvUWcG6/+eWkCji69lvWoa
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(11063799006)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 rl06URALHKu9lH9IrHbTSjPBsZzwBNyFdM/UfO3CNw/LmDVti3TwRevqN9vM5c3TOVnFOVQBuOVw9zZkGR1HLCPk+ueV5Lq9ic/5CI1m59oBMElF/d29/X4fAvkJn3tnIkcSRpVA7bgYXrtL2fbnR8/1VvcLi8e5gdinyWL1mh5oLp7gtp5yq10CGFq/EMUobT+NCdMknQUVI9LuEmb2BLEPBXpDjMHH1Yxb5Q8agjLvytM9JsiytdDLLBLZANX+fPYLbdHrJy9zQn6/ds/JITeTFuQVGK7aM+LDtg936XQJUVUmmvdzKV6xZ/JKIT5mMSx/BJ7OnZJsvc01caAtkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8261
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 CPH1EPF00000523.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	23fb0ac7-6f51-4db3-b85d-08df17c88ac9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|35042699022|82310400026|14060799003|23010399003|36860700016|13003099007|10067099003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	0wSYVsyYf3fJwoYaSW1fYZ2VpU6hrN+bRHOkP0Y6ZtivbS5b44NHaScjQ8Pe/uVK++hDwB/TJswKKmffug2EI5wx4h27Y4bBfQL9/IoqeU8fTjFTOqFiowgZ0JyjQRVP7ExKj+vtx8ak2jeVu7INGBMWoQ3eTdBDoWgxgkdYGVo/DXEPjdhUx9QwXvAYcJzwiCEakXgSF1ba7E96j1D51SPjiFtmUwod5FQBN47r/1/dtcuVUrS67Bv6A+pcMEcW2AbZqwTg7S7wl/3XZryHdmsw4+35HwyD1Y91jXpd+UDSHG5xdYIuR/o5vcI2dwbQHyJ7DXil703gDFfejU+mXvECT2+chIDHk8h2S2r2hPgRwEalYZAJOeh3iRUTYHm1o0VgyGlHwq/fsTvXO0IYmWjZ8VJivNGnGFntcOVyYaLY/iHzQYVm2LC9KRvdbK6cSeDBGadWx1LvW0OZikrHm3S+lFOFMqjldAZRBsLrkjSDE8RI/JC7L3LfFsLpOkNN3UkGkvr7g4vZCbubpsRXYwcmuutsVUrb7DiEZuLCW4DLxCF1fwHpLfQM7N/9fNH7riMh4bwGtFtKjmXQhk4YQP/WwhKDVPSr9wX3N2Hk2x/Kp+/xg8xmcBEalfia4BB3xt/QXZlTLE1ybhqN2T4dG9gThwd8UWEpUrKSBu5cNAhwHz8kbsqTuOnTYa6pVugePVq+n6DRBNLNF/Mpu0VmKA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(35042699022)(82310400026)(14060799003)(23010399003)(36860700016)(13003099007)(10067099003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	l3Ri6a9lpCxi4mnZ8Lld+rn0qrvjMWcgnK8kVNLGXW7crdYil187pYpLydbxza0F9nPvP6Z1MwzWesfr8BWqib1oN5O0Ighj0gSLY0BFPBqm69qqFd0gPZD8WBX2ge+3Ty5Xjp7eMFSol8BNICAplFfVrR0VjK2eOgE/DVeEdOFSQ4DXHW8SfWg5ZA0gdYO7TjIry8yxoIbWIH4HZWK5hGNh0lbWIB6Llve9Kbm9ShNY/803m3e552EME1FtfUpNlauBiy8exx1DQ6nOQLKJ1r8asYjdqd+6lcp5C5LaCzx4NgFTv5c7dncJmtCO6KPWXVWiAeSFtLcfvg8NRtMuqFgFuk2SoSWZW4E3c1zi1h826deeO3Y6l7BO2fi/Nd1yeA5p8enOCSRNes6wxoDoDVLn3ehZ8mvFTSs2oixRJzzuNAtoiCMdqVjrmH7ol15K
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 10:10:56.7568
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9dfeb28-c408-45b5-d1fe-08df17c8a0d4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CPH1EPF00000523.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMBPR08MB999823

On 21/09/2026 10:51 am, Ryan Roberts wrote:
> On 14/09/2026 14:51, Muhammad Usama Anjum wrote:
>> Hi,
>>
>> The generic series introduces hw_pte_t for HW PTEs, while SW PTE values
>> use pte_t. This series enables the distinct type on arm64 so the
>> compiler can distinguish HW PTE pointers (hw_pte_t *) from SW PTE value
>> pointers (pte_t *).
>>
>> The conversion updates HW PTE pointers and accessors, including atomic
>> updates, fixmap, and early page-table construction, before selecting
>> ARCH_HAS_HW_PTE_T. Higher-level entry types remain out of scope, and
>> shared helpers retain explicit casts.
>>
>> The linked generic series is a prerequisite. Its cover contains the
>> Coccinelle script used for most pointer conversions; the remaining sites
>> were converted by hand.
>>
>> Link: https://lore.kernel.org/all/20260903103002.1091859-1-usama.anjum@arm.com/
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> 
> I've been through this as best I can and provided some minor comments. This all
> looks ok over all. But given the number of small changes, it would probably be
> wise to go big on testing; what level of testing has been performed? I'd suggest
> mm selftests (with all the magic to make all the tests actually run) at minimum
> and all the fastpath benchmarks as a stress test.

Sorry, it wasn't mentioned in cover letter. But mm selftests were run. I'll run
fastpath benchmarks as well and mention clearly.

> 
> I think it's quite ugly (and adds a bit to the cognitive load) to have this
> intermediate state where only ptes are converted. But I understand the need to
> do this incrementally. Hopefully you can follow up with the other levels soon :)

Yeah, I would have loved to do everything all at once. But it would have 10 times
more complex. I'll proceed to PMD after this series which would have most complex
conversions. Converting other PXX would be straight forward after that.

...

-- 
Thanks,
Usama
