Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.26
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795692451;
	b=mjkgALOTlIWh5D+TenNfT9WQ2IIxcnlRIcgh+FDvve5oPwqkCC/wuLJoSM7ZeRu8mxGX
	 H2IcLu4vkim9XuYe2t9Aku0Dwd0K802+PTPoyxsnTPBSZkGoGy81hpVMvljH+gIKsOuEO
	 AFJlJzFcue1r6JLTvI45iobmiBRhAF3HAG+cY/afJQPhYPcXAUVk/8apyUQX67ukbO041
	 Jkd47Elx3spkOu3wlIjFapDQUceRxrbunVQTN4XPQOXSVBO5HC6aVCAs1vUqHaf6xiYZR
	 92bi2AM7Bia0BVet0PZuGHTs5XSqhbL9alwn/hWow2kB2YSqRgNb6d5XbMxkOzGy11g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795692451;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=6x5hkGBtAbDU6PzsiysjxuJwEh6KRU2eivBUt00sbQs=;
	b=M83VgpURXwbdWGfcjkOKZRQkS41oghJW0LxNVCkG2Y/hhXdsHdRH4+ggYtyYqgoF2MK/
	 PxIbV68VdkQ6PtVc8qs0C+lnoZlvpn7DfKyHJMV9nrw/LKK9DiSV3QDpFkiA5VvtFVIkR
	 r771KAaHA4QcDpuq8zTraTzb1UxDJACHxbpP8hwIGLo9Z90Hdh8dBp3O8etfI1JVrNE2j
	 RjLDzPZp7I+wmdo9s8DTuQnWqRlzXjnNryW1oGwDJb5UqrwjMKHN+fBl477owXQXYxsLB
	 HNPVKxPdG6k/Rh/eEqPSbBv1QBbXrpThg6WcJda86TjCKsCZgEBK+VaIVi3Xnq5Fr9w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b="R+s1/L19";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.26
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013026.outbound.protection.outlook.com [40.93.201.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E25606A326;
	Thu, 26 Nov 2026 11:27:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1E25606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=R+s1/L19
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rqu2C9x701BTGfjzDMiKVFNu6NhMmE0WyUV7J9/RIZTLqU50gfUvYzKW2yfRws6dduZ5Ml1ico+jX2bRIwX+cW+o+WbrS6pd6FoWLr0iff9xcOplnQb+lUip80U9AyqM3fbUd3cYve/O9aBQhztdGT39n/VWxePJ0BDhIpS+NAECdf1t2GwBiuXx3T6loYmreTXfEGy32yjfZK9A+4OA7tmFIJEvLzrzPczxDb1fM5OpgH/iuyGpOGgmZZnU3qpOBf3/SM62OG90R54ZMdV36hd8EJJcP+/u97KtMgugqNsjKqdyNzU1B8AD0O7jXw+kvOWw4HuJGH8fqVUEMfgGHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6x5hkGBtAbDU6PzsiysjxuJwEh6KRU2eivBUt00sbQs=;
 b=mycvqWFFGz9sUCSEbF/Jb0D6IrOA/81EYUNzxV2uY1dH4Kwxyp7c6FUcH1hZI+YZfZCpiAK/p5B7bGpLrJ49i9cTUDA3dHTg18FT4iw6lT4VYo7vYE88k5JNyaDOm3QaL0gRLBanxtIACE9joVx0otCkX97t8WJXyVLry7D4PFOJzpsv8KZ5+Lo/rEXeQYgok/sLXIFoJbmnG0whTPs/RR+YPVrtjV6e0QkWo9rrzoiakC5SIeEp+9g9bm0fwovExt706tyHt2cPljkoZrnGrk2iX20pyqql/cZKSfb51sWXzRy0Imyay/BgOKUr4BEhAUTVgsOMZ2tn0wi/PCXPvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6x5hkGBtAbDU6PzsiysjxuJwEh6KRU2eivBUt00sbQs=;
 b=R+s1/L19u7OogVzJp3O5hi818WDGJxomu5IARnIcU3yJPFzUg1b/y36IQhbeBnPzKtbnh4GiEe/Fm7kBngoz3sRAB5CYUwqg0cZ4z2rKzP6A64SQXwRBUcF1wkrdM2cRodrUl6E1/YcXvpf3fI1OBoLWDKUR4gKDSCrv0NOFbUk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB7771.namprd12.prod.outlook.com (2603:10b6:8:138::6) by
 IA5PR12MB999300.namprd12.prod.outlook.com (2603:10b6:208:608::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 11:27:28 +0000
Received: from DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c]) by DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c%4]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 11:27:28 +0000
Message-ID: <909a375b-7251-4763-877f-4cf36a9957c9@amd.com>
Date: Thu, 26 Nov 2026 12:27:22 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/efi: Handle EFI_UNACCEPTED_MEMORY in
 do_add_efi_memmap()
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Mike Rapoport <rppt@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, linux-efi@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, stable@vger.kernel.org
References: <20261125173338.1250080-1-kas@kernel.org>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20261125173338.1250080-1-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0270.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e8::20) To DS0PR12MB7771.namprd12.prod.outlook.com
 (2603:10b6:8:138::6)
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7771:EE_|IA5PR12MB999300:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f63ba39-24f5-432e-ab81-08df4bb0405a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|261009223027099003|22082099003|18002099003|11063799006|10067099003|56012099006|261102123227099003|261026140227099003|261028144727099003|261026121527099003|261022105027099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	CXmE/rpgz74mnZ+q52+CHNv/1fo4RM242HqfDqil6VKikRVWeSLFkEk8Y1u/Wbq4wQni3WD5IgVzRqVCOfGpkG9vjDhTVLJqmpZBB/AMc1hEbI3/oqZ4OVPBFcBNTf2rIN2g8BCIRNWoganO7zulmUHs7mmSUlKyD1OtyeKutxfhS9cp1YQV3u8vNNDFrXqQy9vsXaXO8ZLRx3+SUtR6spI9iLfiDOlXRIBO4rVLaBxdiwBJo0/2GV44yFuh/P/yUgLPQ3BfqY2iiu9FmA1LeQ61NuTGRL5W6wFO8kTNHo6qVXCat7Q9OIaAGCkdNHlV+AHAb/raCQeLlDO13Z/Xc46uzQ8iDAenNc3UucyaceDPXlt9SSr5ZI9Vg4apnhr63BQEqgDeGmF/L/UYfDGME9S31xRNG1Ck+7zqmxSyeZlr8oNWRINSi18FfchX+n1W9YqdYB5tlj87Te2NIzywU6PGDoBGZfiHHK1CC26OcAIXSVNAB72Cscd0UiY3nokgfRWVTRCjWL6DDP2vvwYtzGokgUdtZ10pko3UpPCTzb1TGeOT/Eab3XvA+2rKzYPm60t1HaDpSst25FR4IX4T5PxZcxBZ3KGKB+fUcaEchE9nD+192eR0ihTJqkJpkpVy+EgeOcBx7cXNnqJjpy29Hlz1Hfu+1zbtDUbIf6hiYBI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7771.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(261009223027099003)(22082099003)(18002099003)(11063799006)(10067099003)(56012099006)(261102123227099003)(261026140227099003)(261028144727099003)(261026121527099003)(261022105027099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eU9zSDczRU4vTzkwS2M3TU1BTkR5RHRNUlJLV2p6Y3dHV213R2tXK1NWUUhZ?=
 =?utf-8?B?NUlSa1phM0pzSmtKbzBCRXdFVU5oZzlEanA0USs0V2xOeTlNVEtyR2RLM1RS?=
 =?utf-8?B?MGltd0pOOTZGamlHRlRzak9JOXdrdFV0SUlPcXhQRUluVVZld1JZOG4ycGJ0?=
 =?utf-8?B?aEVBM3VnTEdnQ1ZPNlpiWVNoK1poYnJXbEFYZ1laSlorMm1YeE1tdFZGYjBT?=
 =?utf-8?B?cmhLV3VmVzROUVlmaXE3T3JLUHJUZWJKSmxPY3lWSEhNOGZYeVY0SjdiaXow?=
 =?utf-8?B?dHhtR2JLTi9pUGZrdVQ2eE1XS3JlVUozRDZIcTM4Z0xnaU8wY1owUmF2TExK?=
 =?utf-8?B?SGp5bmdGWGl2TFNRL3kyTklySEt4ZktzT1ZUM3gxdEZqbkRDbGU3QzdZYmRI?=
 =?utf-8?B?dW9Ld0NzOTlNbzVaeElWWjZTTmxIYVNETForVjhONzZqeTJHay90MHIxaVZ1?=
 =?utf-8?B?N2VFVUtNQzJXa3RvRjQrWnB1MzdUbTBZMThxK2JjbVZRVzlVWmdobDZtUDVw?=
 =?utf-8?B?VDIzZHRZQ3R1NFVPeDUrLzRaT3lTMUtkVjE2R1lwRlZnMk41b3RYdlQyUlNo?=
 =?utf-8?B?QjkyMUdVemdCcDBmaGtmNW9zUDFJL0FRUXRNaEV6b3lYYzhZS29EZGp2ajVU?=
 =?utf-8?B?MXprVXViYnAxTmd3cS95WUJzakM5aU96eTlza1drZmppN0Y2SVJqZnQ5a3RD?=
 =?utf-8?B?cnRiK1BBRkdTVDJKaTZiWTkwRE9BcXlYZEhiNnlLeTBtQ0M3WlVVaGFQZHdO?=
 =?utf-8?B?MEwzUk9SVndXMlhkTlAyVWd0SitrZGZsSENEK0Nja1lGVkNKRW56ZUxSQU1V?=
 =?utf-8?B?dlFVTDlXeDFxOUQ2U1FwT3BBV1YrNjVRY0MzN3hYVnlNbmN1TXVkQ3JoTmkw?=
 =?utf-8?B?bEUzYkNKbVN0TE50TmdYRVBwRzQ4QStKajIxVXQyVjhsR1YyVU45TzJRYm9o?=
 =?utf-8?B?TkRiUXo4L3VaMDIyMFlUNTgvbUVncGxFbnRXTHcrWDEwY1VjUmx5YkRvTkN5?=
 =?utf-8?B?TS8xTDlKeEJMSHEweDNBais5cHkxWGs1OUxGckZsblhVUDBXWXNmSTF3cStx?=
 =?utf-8?B?N1kvVkFJWE9FY3h4WlNWTitJZ3p2OEVCVUhJK1NEckRwaWFONW9oZmdQbml3?=
 =?utf-8?B?elZhY2hhODNrcVNkbGY1eGtCanFWNlg0QkhpcGI5WWdWTGZUajFyQitZWnlL?=
 =?utf-8?B?aDh5VWlwRDZpWXppUzhhSVAwN0ZRQ1pEVjZ2cE5jQVNGVjgxdTd1clhSZ1dS?=
 =?utf-8?B?NTZsNmZxVktyUndZWXNnTkZyVWo1QjZ2OFRrNkR3T0lZeHdZUEMzVFdFdktB?=
 =?utf-8?B?b1VERmsrYThLZnNTRDd3aCtBem1VZVFxcm1MWm5pMklCQUZPMTJpTUFTR0RP?=
 =?utf-8?B?MHRwclVMZVZJMmxFd2NxL3N2TWFFMTlDU2pjV3Y1djl1NG9jQjlHNUpQQkww?=
 =?utf-8?B?VUFuaG9aWTIwMjVGODlBY0VhckhkOFM5RHh2UEMvT1ArM242WDY0ZitUMC9M?=
 =?utf-8?B?Mk95dXJoLyt0eVpMeWRZMjcxV1I2czZCNFliUWJPc1lhdkhJaUoxUmxteE1Q?=
 =?utf-8?B?cjM0aE9hTXlGZ0V3Q2YrNjBWRVJHTTVWR2VhVGoxbmsyK2E5ZmNsRlczLzRa?=
 =?utf-8?B?U3hsNXk5RElFRjNJQiswUTRiQ3hnQVpjMFk2TERGc2pHNWxNc3lJdmJVVWY5?=
 =?utf-8?B?dWRSVmxoVlh1OWgxbGllRUVxUkZwaHZzYmJpNkh2cmt4KzBXM1NIN1llWU4r?=
 =?utf-8?B?S1ZMRUNONGhha29FcTMwN1hCWXJBaUUzY0NUYzRhYkVTalRKTEpwZVRocXVC?=
 =?utf-8?B?c2kyQ3JBNWQraVNoNXcxcVZiN2JtSGNONFo0eExEcktaUGJaN0YyRVo5Y3Qx?=
 =?utf-8?B?OTlnVk04Z05kMnRWLzE1ZytOSWNFUGIrQkFzTmhJVnZndE1MT01vb3l3OGRC?=
 =?utf-8?B?RHhoZHNsdVVEQ0ErOEJLLzdmVmhRak9jcnJVNmZ1eWI2TFdpZHU4YTJnRy80?=
 =?utf-8?B?MXdQdkt6RUxnUnZRR0U0ZHV5RGJHY3NDOGx3NGk1eXhPYTlzS0pJQldzQ3cw?=
 =?utf-8?B?NnM2US9rY2VWeHB5N3ZndEo2dzFSaGQrREh2Z1ZUWmV3dERlZkU4eVBMKzN3?=
 =?utf-8?B?QjdMUFhnbXRkNjFKMWpGbjBYcHA1ckdqR2ZFVDNyNVY3bmJnUEw3aU5xRllr?=
 =?utf-8?B?bzdMajVRY0FrM2xqZWcvdnZVazJTS2hZSnFuQlpCR2d3REs4M2V1WkttUjFL?=
 =?utf-8?B?c2ZyZEF0MlJGS1VReHBhUUZzTm5MeS9JRnE5ejN1SkdaU0ZWWXRMd1M3Rmwv?=
 =?utf-8?Q?b2L0MIRhht9ZfP/3cD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f63ba39-24f5-432e-ab81-08df4bb0405a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7771.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 11:27:27.9058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EGH/TSxk7rmf5KUrrgAqZMHP3wjNgrc3c17Ck1LQs1l0qpy3vfTCSGAoLd/gJm5qqNN1lLhq//2N7p1fgPJbiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA5PR12MB999300


> The EFI stub reports unaccepted memory to the kernel as E820 RAM.
> do_add_efi_memmap() has no case for EFI_UNACCEPTED_MEMORY and adds the
> same range again as E820_TYPE_RESERVED. e820__update_table() resolves
> the overlap in favour of the reserved type, so the kernel never uses
> the range.
>
> do_add_efi_memmap() runs when soft reservation is enabled and the
> firmware marks any conventional memory EFI_MEMORY_SP; that takes no
> command-line option. It also runs with the add_efi_memmap boot
> parameter. A TDX or SEV-SNP guest booted either way loses the memory the
> firmware left unaccepted, and it does not show up in MemTotal.
>
> Add unaccepted memory as RAM, as the stub does. Without
> CONFIG_UNACCEPTED_MEMORY the kernel cannot accept it, so keep it
> reserved there.
>
> Fixes: 745e3ed85f71 ("efi/libstub: Implement support for unaccepted memory")
> Reported-by: Mike Rapoport <rppt@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Tested-by: Pankaj Gupta <pankaj.gupta@amd.com>

Tested on SEV-SNP with CONFIG_UNACCEPTED_MEMORY=y

Best regards,

Pankaj


