Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012039.outbound.protection.outlook.com [52.101.53.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001A547ECF9;
	Sun,  4 Oct 2026 18:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791137228; cv=fail; b=c5/XnhFYXjkwb+jqu0NzgKyyOE74A9+TTyrEaWiEG6Jnr+a9YNj0Lxc/BrKjDXYW9tjv8Fivit3YUliH1xzBJC+fr0D1D3IMNGdHkxcpn8rcOozX7O5hTbBhsX1dJE6JEzKVrGnXBB3ZLgExqKyYtnqsGrxpYHCNFALDMgB6KMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791137228; c=relaxed/simple;
	bh=i8KmsE0pQNQm7Bq2SVjfjPanFF6LruXVJiw6x1WN/6Y=;
	h=Content-Type:Date:Message-Id:From:Subject:Cc:To:References:
	 In-Reply-To:MIME-Version; b=k7I4cov9pm5w+UOzL+HOYX/vtyTdgGZEVexwnwA6xqAhgV8npN566brzldzmuHCjiynYm9pUcC4gHqwmMJMRcWmmUt/v493Ib+nv09fy3cQ5Cdh/qdJ43suNkagnXJUptGDXh9H3O+BAUp4JNagalxtm0VDnEVi5G5sAAQxATIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QOvGeb1x; arc=fail smtp.client-ip=52.101.53.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QOvGeb1x"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vgGw5Yt3EPdBosBy1PvIYMGsB0eZN46t/nDmcJwfgdM/BgkaGXCfvlsYVxQ2Ul5Ou826qW51QgbnCkgauYoMQ3LscBsVrpgEs1jh0rbq3vFZnYSuI0anYGal3pSJjWlSs8d3+5hHpeYWlr2WSUOsqxOKROJT2yjLnnF6vdZLGFtYntGHkNucsgCvaKcGL+QwUE0xBbiuB+esCF6V6/2ypG6qnM2A87/BLALZiJ7WX2q46XK8AtvLSQg0dCDAMdLSBG9ePoIkALYw0WMT9sQwEfYmuHjyW64KwhjGqDk8szeiU97yuesNG8/524raVQJXw5b/nZpUGcTJ/6TGIQVNbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LKl1Pq8id71YkKUpt3N3dSvtHPnSmyqjIoaUcssKSRY=;
 b=qe7XH2VuKGQOXDcybHbQbrCuWsF4D4HO2cA+A5SiCO8q9JKhXSpJhhQpCIIWq6qw8f/j7NSaysBG93Z0O1U+tP5TyLLuGlupOx+/6O+HjjqBBxJezzsbBXVN6xR6NCWyZMKOwp2otj1CVnFYcKvYhzfY2LGNhoJkcVaMkt8S63uMTNbH6vps2EoxRfshDFC3B2SjRKRtV5YUSH5ap/R0hjBf9UwCctwY3MmOQdFTuIFgxkfsN68k4mgP/IjHR+VO6WzZdWMgqD+Sbo8sjirfuOch7tL/D+BnfIQIgjvjiBMTie0h5F8/fymsCcBkS4m8/jxF5ntvuOg8/d4VzNsnyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LKl1Pq8id71YkKUpt3N3dSvtHPnSmyqjIoaUcssKSRY=;
 b=QOvGeb1xTBbPwugR+Ewlia464ENfu5yQpqUnHDTbAIjIojV07ImleqrhdVj+rqxp8qGcB4AS5XuaRNdRPTCD7++xiYmrTkDkzAhan2dyrbP7zr7XL5qXiFY/nysXRFv4iv/XgHCFX/0pxYgz1geIk9TrSJpf+Z6ESgBuVpfS1D16eYgq+7/wEUXRaa6p5nBQjjmdg6fcR5ZBNKyiA8iKCMoCKPwNjYtE4+Nkf3JOAqHr6omziGYW7qlGSQTZFUC/iAwmBzmta/HC7yNJMCqZSeeYFNn5pWKV4/KS2+g951nYTHjQXEEtGujSzv2uD8Jyl7PTg1ey1ALESpWACdQBwA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB8479.namprd12.prod.outlook.com (2603:10b6:8:155::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Sun, 4 Oct
 2026 18:06:56 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Sun, 4 Oct 2026
 18:06:50 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 04 Oct 2026 14:06:48 -0400
Message-Id: <DLW95E2XWSVT.8W90FW4WG6K8@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [RFC 00/12] arm64: Add support for TLBI domains
Cc: "Catalin Marinas" <catalin.marinas@arm.com>, "Will Deacon"
 <will@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>, "Ryan Roberts"
 <ryan.roberts@arm.com>, "David Hildenbrand" <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Linu Cherian" <linu.cherian@arm.com>, "Anshuman
 Khandual" <anshuman.khandual@arm.com>, "Lorenzo Pieralisi"
 <lpieralisi@kernel.org>, "Hanjun Guo" <guohanjun@huawei.com>, "Sudeep
 Holla" <sudeep.holla@kernel.org>, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>, "Fuad Tabba" <fuad.tabba@linux.dev>, "Joey
 Gouly" <joey.gouly@arm.com>, "Steffen Eiden" <seiden@linux.ibm.com>,
 "Suzuki K Poulose" <suzuki.poulose@arm.com>, "Zenghui Yu"
 <yuzenghui@huawei.com>, "Ard Biesheuvel" <ardb@kernel.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, <linux-mm@kvack.org>
To: =?utf-8?q?Kristina_Mart=C5=A1enko?= <kristina.martsenko@arm.com>,
 <linux-arm-kernel@lists.infradead.org>, <linux-acpi@vger.kernel.org>,
 <kvmarm@lists.linux.dev>, <linux-efi@vger.kernel.org>
X-Mailer: aerc 0.22.0
References: <20261001110655.461473-1-kristina.martsenko@arm.com>
In-Reply-To: <20261001110655.461473-1-kristina.martsenko@arm.com>
X-ClientProxiedBy: YQZPR01CA0136.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB8479:EE_
X-MS-Office365-Filtering-Correlation-Id: b2303fad-ba7f-4d9a-e50f-08df2242437b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|10067099003|56012099006|6133799003|11063799006|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YG8SbDp3221bnK0U74/vL9hMkGDwxNd+ugi8N606yyH2Gtg5WNDraHWqrSNAvD+Z4pDFpT80gddM3AgUGwimLuqUanvgJTY4FDVyQflVLlbnmH9b/DLNFj0oxCf9UChYc9ndSlfOmxTrRy5MlU5RLcRBfJIjGOt6reDI+x6XysEQsyJANOvLTSn8eNj7d6jjBT89TyEuXCgq2OgLq2btlaNG0HYFlj5vYns+0fKKc+ALd8wz4tU6noVvLbi7HI+vnSIDBbOKO3ed9zmWVjwDTXe271uegekqkcHzQdlkPEBmbSsvSTnTt4La5rUKc95frZttQPJOplkvSh99A8f+pN1w6uz1ev2s196IxuXD5raa30qQXN1KsNwy3mw4csE5hbvfGaS6R/9YZyog/x57sg41ZYU2TLazbJhobGR+jr2WA090szU94E+3L9DrsTKkYXk0OXDSo1uPUtCiZHWPObFPBvJiZJb6cHbmfTkFUnQcXsb1YjQiWQ/LqLIVTJfZL2dcush1iJIg1JwSQSj0fR4YCLaDklRc0tOjhRQU++eaTcPvP23evBnbyAI42LnCbBTbIj71AzE+kDW8b6SJN15J2G4cefhnlkGAjyI7XosdbgpH86Sp+VN3YTO2+6wt0NYmaD+eBtSdE82kP7GbbP25Byio1JoJSXz2+2CZ1GQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(10067099003)(56012099006)(6133799003)(11063799006)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U3FsMWw3Mkh3WE1jNlQ1SUNINlg3ZU1pNDlqRnNMTUV3ZW03MjBWY05NZ29X?=
 =?utf-8?B?RVRaVG92ZU5mRURVMUgyNUZrblVZVFM4aHYyTkNVM3lQRFIyN3ppd1JkbnVi?=
 =?utf-8?B?YnRBbVFMN21oQ0pTNEtnSVZXRnF1Y3NCMndYOCs5UGZkK2hrOVlRbWU5Q29Y?=
 =?utf-8?B?WjlERUJjMlhEWWRQY1VvZkFSSjJXMVdTaTdsUUxSTVlXekY1V3QwZ0Rsdlhj?=
 =?utf-8?B?Q2EyR2h6eWcvYlVqNVovK2V4UzRCTm9zS0h0eGJUVEVrUGxxZHFBVTVkNUpO?=
 =?utf-8?B?QUNmYUlod2hQQjBnOENiSDE2bjlkZVVWWWxaNHpSalNLTjQrWXBIT1R2U3R6?=
 =?utf-8?B?eDBmY3BhLzhselY4THJDZ2NhaW1kbGIzTUZhb0VJRGtIa25sbHpCMU9kSnJr?=
 =?utf-8?B?K1BHckFpYno0YWE2TmE2WlZBUWhaSEJIT0M5cSs4NXpZUkppTG9LMHU3WmR5?=
 =?utf-8?B?SVhBWTZMN1hsZXc3TVJlMWR0NjI1U3ptVE9KMjRWN3gxUE82TllzMFhJZXBF?=
 =?utf-8?B?eFRwR2xDVjdWcXdqNDlwM3l4aDFPOHVpMlZWVHdrKys5UDF6ZytuOHNDKytj?=
 =?utf-8?B?ajk2d1R4ckpIUEUrWGwrT2lzb1FoL0RuWmVkRkVCbmVMSEpkSmdrbytMYVND?=
 =?utf-8?B?dXpBYnRWYmErNFYwaHIvek9OZ1IzY00raGx3RmttamFFSU9jN2NsT2FKbU1P?=
 =?utf-8?B?U2orS0I5QS9XS2N4MWRVZlhtVWh1NUhCVS91Y0s1bk1sMzJvOGxUb2s1RTU0?=
 =?utf-8?B?MGZlQVZVQUlMOHo3NkxUYUtDczZzRFpFQVRRWWQ4NXI0TDlIM3o5SkRxWHVa?=
 =?utf-8?B?WkdJUnFrVFBYREF3UHFwU1FNTWd5THJKTzNDdEpzdTM3K0lOb0Q0akVkU0Ja?=
 =?utf-8?B?VXJqM21MeHhRUStOc2hWbjJLWGdVamp5WHpxWTdSWFRCSTRLbnhmRWRsMkpM?=
 =?utf-8?B?dXd3RmVxbDdsTnhGYjFrWjR0bEQ1bkd2bVRORU56RzArNlZHOFordnRCL013?=
 =?utf-8?B?SnkyZCtKRnJlNFlTSDlkMU0yd3VNbUNzV3VCblAzTVBQUzZZQkpzZ29DVFVC?=
 =?utf-8?B?THg1YlRPU292TmdWU0FVelRRd21nbHVyMEZJbzA0WEpUVlJieHNXRzdmTGZs?=
 =?utf-8?B?YVp5Rm0zOXdQV29uc1NPTnRSa29hNzVyTlpCYXZNR0tJQVN4cC9sMlAxQldP?=
 =?utf-8?B?S013VUtzSHIva1lQMVczOXpxNitoL1YzZHlhVUNmZnlnOEtpeHhUZktoRVpK?=
 =?utf-8?B?SjdydjRQM2hPcXJUZXMrKzRNL3JUV1FHN2Y5WGZtbDd5WVoraEtyRlQyc05N?=
 =?utf-8?B?RHJwTkR1aEgySHUwSWV6SDh3eXIzbzd3dEVsSnZQN1FZM1VDb1Z2WkFuZjdp?=
 =?utf-8?B?eklJdU5WMzh6aG1vTW9CajRNTzEzcnFWTVNpWXpEczhmdnZobFdRQS9rN1li?=
 =?utf-8?B?UWk1SE05MmJYYU5TY3pDTk1tK084Q2djQlphZ245NWFMTmhhcTVUV1JoU1pP?=
 =?utf-8?B?d1I3S2QrZXAwTS9wZVJsNXkxUzRmdHZELzlYc0dWN2JUR250MG1hdVYvV0U1?=
 =?utf-8?B?ak1ES3Rra2ljK1NlWFRqYlNBOFRweklDMDhDTFZIZXJCaG1iN2tka0xSbHlp?=
 =?utf-8?B?cTAwei85OFZwNG9rU3Y4eHJiRkF1dlBXbmRKTjJyUnphRHB2R2VSRkgydDA4?=
 =?utf-8?B?b3lRZGNDQlhQSnYyenhadndwM25EaGR0Q1BzWEw2QVJPd1g1aUtNR2d1RUZs?=
 =?utf-8?B?UkZiVnpCSTZMRWdNODVGeGZOTlkwSElkTGIwRWtwM2QyQzZpeTZkQ0dOMG1W?=
 =?utf-8?B?Vzl4VTIyL0w3ZzZMNEZucFZyR0lJVitxRHl4SmxHdmlDVVJBNFkxMGowbThN?=
 =?utf-8?B?VjBMZXlQdjhrdThQZE8zNmVPZzhIQkpzVkNvbGRnc0lkU2ZsUHdLYlNnK2JZ?=
 =?utf-8?B?eHdXN0wwcVdwcWx2RzZLT1V6aXZDblIzQ011K2h4S1piTDQvcWk5UUVTTmx2?=
 =?utf-8?B?cWpXb1VuRStRZThsT1E3Qjk3RVFkTFZhQmI3ZHRTZTVaRm81WGh3ZVUrNllv?=
 =?utf-8?B?YTdKSndNNVoza2FqemxFU1lXcCtDSW5WUzlDWE40N09HRWhlcmgrdWJHR0No?=
 =?utf-8?B?ZkpVRFRnVjU5dTJxN0cveEpCVUVCQmJDN2UyNDFwOWoxeHFJM0FGOVZHcFZL?=
 =?utf-8?B?dktyWnM2WmpYcFVTYWYxOGN3R2ZPSlJWcmpibFd6cVhyaGRhTGpBSnVxWFNN?=
 =?utf-8?B?Q09sVmY5ZnlHZWdOZlNxUW04U0NXNnRKZnBsdWxaMEdiRXhEbVdaNUdnL2hk?=
 =?utf-8?Q?udgJfHDof4oLWJ84Wr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2303fad-ba7f-4d9a-e50f-08df2242437b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2026 18:06:50.6717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lw3as9qm8Yr60/LalEpHR2zBOc9gmZP9NFUGiyUAYftemw1lSX9sc8Mgw/AcJ+iT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8479

On Thu Oct 1, 2026 at 7:06 AM EDT, Kristina Mart=C5=A1enko wrote:
> Hi,
>
> This series allows the kernel to use TLBI domains. TLBI domains (FEAT_TLB=
ID) is
> an Arm architecture feature that enables a TLB invalidation to target a s=
ubset
> of CPUs instead of the whole system. It can improve performance on system=
s with
> many CPUs. TLBID is not yet part of the Arm Architecture Reference Manual=
 but
> some of it is described in the latest XML [1].
>
> The goal of this series is to send TLBI commands only to the CPUs where a
> process has run (i.e. where its page tables have been installed). The las=
t

IIUC, mm_cpumask() is used to store this information on x86 and other
archs. I see you put this information in tlbid_domains of mm_context_t
from patch 9, although in the form of tlb id domains. I wonder why not
make arm64 also update mm_cpumask() like x86 and other archs and derive
the tlbid domains based on mm_cpumask() and a cpu-to-domain mapping
(added in patch 7).

Thanks.

> patch explains a bit about how it works. This is an RFC since I'm not fam=
iliar
> with the kernel's TLB/mm code and I'd like feedback on whether the genera=
l
> approach is correct.
>
> A few notes and open questions:
>
>   * Domains are described in a new "TLBI" ACPI table. This is not yet par=
t of
>     the ACPI specification. There was an initial proposal [2] but this se=
ries
>     uses a newer WIP version of the table that aims to be published by th=
e end
>     of the year.
>
>   * There is currently no device tree binding since the feature is mainly=
 meant
>     for server-class systems.
>
>   * It's also possible to use TLBI domains to limit a KVM guest's TLB
>     invalidations to CPUs where the guest has run. I'll try to include th=
at in
>     the next version. This series only disables domains for guests.
>
>   * With this series a long-running process may eventually run on all CPU=
s and
>     just issue broadcast TLBIs. It may be worth periodically reducing the=
 set
>     of CPUs but it's not clear when.
>
>   * There are currently no performance numbers since there is no hardware=
 with
>     this feature yet.
>
>   * The series has been tested on an Arm FVP which supports the TLBID
>     architecture but does not have any domains (except domain 0).
>
> Any feedback is welcome.
>
> Thanks,
> Kristina
>
> [1] https://support.arm.com/architectures/a-profile-architecture#Download=
s
> [2] https://github.com/tianocore/edk2/issues/11999
>
>
> Kristina Mart=C5=A1enko (12):
>   arm64: sysreg: Add definitions for FEAT_TLBID
>   arm64: Detect FEAT_TLBID
>   KVM: arm64: Hide TLBID from guest sysregs
>   KVM: arm64: Hide TLBID from guest instructions
>   ACPICA: Add TLBI table definition
>   ACPI: TLBI: Parse domains from table
>   arm64: tlbid: Set up CPU domain bitmaps
>   efi/arm: Check return value of init_new_context()
>   arm64: tlbid: Track the TLBI domain of a task
>   arm64: Support TLBIP instructions
>   arm64: tlbid: Pass domain to TLBI instructions
>   arm64: tlbid: Add documentation
>
>  Documentation/arch/arm64/booting.rst    |  10 ++
>  arch/arm64/Kconfig                      |  12 ++
>  arch/arm64/include/asm/acpi.h           |  10 ++
>  arch/arm64/include/asm/cpu.h            |   1 +
>  arch/arm64/include/asm/cpufeature.h     |  15 ++
>  arch/arm64/include/asm/el2_setup.h      |  76 +++++++-
>  arch/arm64/include/asm/kvm_emulate.h    |   5 +
>  arch/arm64/include/asm/mmu.h            |  13 ++
>  arch/arm64/include/asm/mmu_context.h    |   9 +-
>  arch/arm64/include/asm/tlbflush.h       | 219 +++++++++++++++++-------
>  arch/arm64/kernel/cpufeature.c          |  25 +++
>  arch/arm64/kernel/cpuinfo.c             |   3 +
>  arch/arm64/kvm/config.c                 |   6 +
>  arch/arm64/kvm/emulate-nested.c         |   1 +
>  arch/arm64/kvm/hyp/include/hyp/switch.h |   7 +-
>  arch/arm64/kvm/hyp/nvhe/tlb.c           |   2 +-
>  arch/arm64/kvm/hyp/vhe/tlb.c            |   4 +-
>  arch/arm64/kvm/sys_regs.c               |   3 +
>  arch/arm64/mm/Makefile                  |   1 +
>  arch/arm64/mm/context.c                 |   6 +-
>  arch/arm64/mm/tlbid.c                   | 210 +++++++++++++++++++++++
>  arch/arm64/tools/cpucaps                |   1 +
>  arch/arm64/tools/sysreg                 |  53 +++++-
>  drivers/acpi/arm64/Kconfig              |   3 +
>  drivers/acpi/arm64/Makefile             |   1 +
>  drivers/acpi/arm64/init.c               |   2 +
>  drivers/acpi/arm64/init.h               |   1 +
>  drivers/acpi/arm64/tlbi.c               | 196 +++++++++++++++++++++
>  drivers/firmware/efi/arm-runtime.c      |   3 +-
>  include/acpi/actbl2.h                   |  32 ++++
>  30 files changed, 858 insertions(+), 72 deletions(-)
>  create mode 100644 arch/arm64/mm/tlbid.c
>  create mode 100644 drivers/acpi/arm64/tlbi.c
>
>
> base-commit: 93f51579e7df248780214094418f205253383cc5




--=20
Best Regards,
Yan, Zi

