Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795541293;
	b=iIWTdBsysM27LIwP1vIGNoBndQtttyVXZgddFuT99hKRKGLDtMhr7BIrFwqxgklWkXZS
	 F2ikGmVVg2y9i94YDNOSkQitFZ3nw2mhLc6UAFFj51PDkVhq9giJqEVqp9vCdCUNfB77G
	 acVXSf78BO4Z0o1l4qMgzELyRXrc/A2Ml5JsIvbSXTlMjoEdhqKSjpaoCvhg0B4TG4uOS
	 KuvIGghX0wUONcwabJMgfX87nq7lGUMSVrFlqRoJzZztycN6YjMmLITgl2auUXJ6ry2zD
	 zfgH9sDMnZLHpFm3hKXp4tPDiTCo5rQ9tMfGR6dhV3T3zg1sYwOvDQLaZuBnD3H6UPg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541293;
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
	bh=ZCwp05IcpcNS3RLWAuz6/8Sd0BXA3jsJ8MNUidlQd8g=;
	b=uLprGpxJ6iecduO8sHZs7EOFizbQWv6rqBvHSmXWNdgPAAle5s5bjwnynXOGxQEHVqRz
	 Iaw6wc+yVrx6+p+M6BV0jM4dselBtxp5XNupRO05XJUnALhr4rJzO+32Vvo3UMO7bDXg4
	 12FytDySiY4cauX3+Whf4suXzmsCMHtPMSds62IQqvsBm0FZWXOItBKDGamyrr2fiie4B
	 +9s8paRT0jUg93GJkip0CgO18qUA8gLTyKwqM3GLKXr9BBNFK5r0zregaWLr0B16GDE9e
	 /0HdNHIupWYpWROm7QnoFX5oQJqcAzrlE4/fWrLjT+vT956uz9xM8wxP+iorWabZSfg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=cvbCY3wk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.43
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010043.outbound.protection.outlook.com [52.101.46.43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A588F606A323;
	Tue, 24 Nov 2026 17:28:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A588F606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=cvbCY3wk
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lQBqZWuegtoEJQQ/nzfe7AHYhviQVncqUhnyncdEv9nZncNNnwHv8Ud4/h8xWdUZ/0l0sOJotjSESL701CSmmczS9nmLzNkYjTupE/Lhy2kdDAqzIr7msNvjzJJLt1RMog4XJgwjIufX8wnzgVW8I/ROVnM4VG2kKVfL/aJzjLobqq3hf5MlkMLIvt8QasQKVsIpLvN33VVEzH+WJ+acYxOfsCZ1wnNQ2X7EIAq9CbJ+1q89MQB4wT369XmY6+fhF8zzj4aX4YDHsJa0+TQS32ycuVwfM/CPzump6H8D0C9FpULEpYgcOisXghHc1qidQK7FznPnJHLjyjwv1He5iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZCwp05IcpcNS3RLWAuz6/8Sd0BXA3jsJ8MNUidlQd8g=;
 b=pXdykWLFfte7EkgpEDQee2sJBUk1psB0UX7tGRHhpFX9HiDeaNWx4ZQfpqSlesaXZlGzakxt9lfx98//EaSzn0x0ZLx5Ycvb/5ePmSIJojyLSVf9yO0QZHAe/rx1kMZNnLpDizCJhMWHJze1PTYQ/N/u4SvA1vKe5K6ULqSEzJ7cT3CykT38uDnQeaseZsUj2WWjKXrjx0hW4Ngc6H0hnB+oXpNFqAacHe+tRTyIBdbR4/xqp7MH9vYYnmiFk0m5Y4XxDS5eVMhg0K6R9lk0oAp87/JAhVhkBL2Nfq/Kl+5zsZrJBuyiJ4GLzB8uyuWo9QSBs9pZpasZj+Q/6kLMEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZCwp05IcpcNS3RLWAuz6/8Sd0BXA3jsJ8MNUidlQd8g=;
 b=cvbCY3wkLE3hai4NK5Oir+8evhdhh3ekVxtQo2BuPXSKBEdAynkwPsw4J7zYNETeykZwCyuLWW4FBibd1CV4CONM/Q/GQJT4emYiX3g3s8C6e28bvE4VlWZb/X+3WGOCjxd06DXogGynHok85snWbcQ62to4hIvNhZUXXsZ6BBo=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB7771.namprd12.prod.outlook.com (2603:10b6:8:138::6) by
 PH0PR12MB8823.namprd12.prod.outlook.com (2603:10b6:510:28e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 17:28:02 +0000
Received: from DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c]) by DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c%4]) with mapi id 15.21.0639.011; Tue, 24 Nov 2026
 17:28:01 +0000
Message-ID: <f059498b-1e65-48cb-bc40-62323e161a14@amd.com>
Date: Tue, 24 Nov 2026 18:27:55 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/3] x86/e820: Ignore memmap= and mem= in confidential
 guests
To: Ard Biesheuvel <ardb@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Dave Hansen <dave.hansen@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org,
 Pankaj.gupta.linux@gmail.com
References: <20261124133241.221719-1-pankaj.gupta@amd.com>
 <e08f2321-749e-40f6-9ed4-3dba8e1625ba@intel.com>
 <awWzrkLxfQ2_ODKe@kernel.org>
 <2dd40d0d-2e1f-4a7f-ba65-2cceccd82028@intel.com>
 <awW31hUpXuujSAXA@kernel.org>
 <c0e82936-9436-45e4-a8b6-07bdaa9680df@app.fastmail.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <c0e82936-9436-45e4-a8b6-07bdaa9680df@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0223.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e4::6) To DS0PR12MB7771.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS0PR12MB7771:EE_|PH0PR12MB8823:EE_
X-MS-Office365-Filtering-Correlation-Id: f6d74bef-9f31-47d3-f930-08df4a504a44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|5023799004|10067099003|261026140227099003|4143699003|11063799006|56012099006|261026121527099003|261021121427099003|261102123227099003|261022075727099003|261022105027099003|261028144727099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	14pARPdHgRclmWCsXClL9wdGqB8IrYD4nZi/+DLf2X847fpR54jia0BU0pt5IB6TOOJRE1PwG9GfO2hiIYP9cSXw6jg7vPfnA1ttbfY0OmfrrQxc0Fq4lmQJgKzVcSg8IP0+b91d2SG1InQh+vZ6ObD3nGitUAV3UxttKAhNBm3y5DDw3LKU0qtR6xamWZ7Eo2gYWfBPLSlc6BWC9doQMd68etNEv0QFA7OcD/SLn9rpv77GnC9skZC25lhxYtRB7Zoyb6uVgySiY8Jz4jeIscQYeL0Ahb/bmozWMw2e46vneplw0u83DmFxdmx6rK62IgKUzezH24cVPXyRDC9aP0V9Cd4iecrbPy15E/ccUTpxa4217StbUBtyWlmWeidPncIbxxWuVgo4Vw4/JJXhcEZqqMPLbTC6gV79oQCyPSb81oZ/k6VsBpiifzAqbZIEIxKZvWs9NbAxk7xjXci/4t0FkNxrfoxPgs/dNrAmOf/y0rNEn8mU9QsO2yqsrXVVgXP8tQ2WeIXPYYg1XaqS7BrX8YAOyqUfMwNJs0s4DpGmST/PJEr5eshaYhAi0IVwhGUesAM1hhNKTQNrTJimea/lv0A0dJyZdStjZ/3/UsqrdTP8zTDSuOHEII/gs0pp
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7771.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(5023799004)(10067099003)(261026140227099003)(4143699003)(11063799006)(56012099006)(261026121527099003)(261021121427099003)(261102123227099003)(261022075727099003)(261022105027099003)(261028144727099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R3FiU1NvZTd5S0M0MEtneTVrOWl3bW1VMlVGblI5Ylo0NWtQUE90UkoxVnY1?=
 =?utf-8?B?a0hKelowTVlmeVYvc3pqN3lzZWdTN3UxMnE1VkR3Y1lFN1o0TTZyT2FmcTJB?=
 =?utf-8?B?alhHaDFIRzFzV2VBcGdnc3BHcTJTK3RwNHBnMGNtTjYyQk10MjhGMzJ0WEFB?=
 =?utf-8?B?YXU3MXl3cTlMM1hKc0g4NDNJTUlzNWw2ZDJTQU1hTFY2RUdqejNrcWxkTUJK?=
 =?utf-8?B?MVRTL3hQQm9ickgxZ205TWVOUzU5ZXBWdXA4V1UyR1RBd1FHS2RkMnRTQjM1?=
 =?utf-8?B?aFRnZndyWWgzSkdVVmRHZGJ2Zjd4WTEvenlDTnNOSllVVzM5bTRsNUhaeDFv?=
 =?utf-8?B?dGx5SS93T3A3Rk1Mcmh2a2c1V3NINWNtdjNkSUVsaHJRQlNYM3NzSUM3Rk9O?=
 =?utf-8?B?dEllWk5jMXpvZ3owTHE3aVR6TkJxMVVUd1orU2RNcFFQMUVvVGZrei9BdTZr?=
 =?utf-8?B?RkFSM2xmV1ZkZjZCWlBFd2ZkSDJGNW53NllBYnQrWGQ0Z2VxdzJLcEpwT21s?=
 =?utf-8?B?RjJNM3JvVGgxaHVGaEk3SnZxZ1N0SEpGNno1cG5iTFJTYVVFbGMyV2NIY25m?=
 =?utf-8?B?aFMvdHpmZm40Z0tzdTAvSFpteDZ0NWcyeXJmV3huU2Y5akNCeEM3eCtuQlJ3?=
 =?utf-8?B?d01JUG5TTEZEbEZWTC9HWDJOcE9TWVRPOFowdlN2SDhVUUcyQXowYkNqTWRk?=
 =?utf-8?B?MU5qMGQ1QW9TSkV6MG5XR1FqQVBkRW5sR2xvdnZwVkVPZHo1RHpTOTFwdW1X?=
 =?utf-8?B?V0xjREdYRjFpTEtVUyszc2VqMUYwZGd5cWt2SHBseW1SN3JpS2dSVlhlb0RV?=
 =?utf-8?B?T3QrdTRmbU05SkN0SmxEY0lRSHA1NEwxMVh2QTRpbGZIWGVpYkthNG9leHRB?=
 =?utf-8?B?T3BvSmI5NWhCcW1DaDd6Wmo4WTFTVDdvOFBTM1o2dkpZMFhzTWNvMXU4OXVE?=
 =?utf-8?B?VURDL3Q4cXF1Qkt3SDFuK0xrVlMrdVBCWjFDQUFHTlJVaHVjZERWclpaVTZY?=
 =?utf-8?B?WHplK0lCVE81czFDYitabTc4UHRwNmVmVk1GVWVTM3RlQ0pQOWhvd1ozTlhZ?=
 =?utf-8?B?QU1uS2xOcmtVYktJK3MzRHlvb3BnVW9BL0FUOTRYZVJqbUtiS1RlL0pXQ2I3?=
 =?utf-8?B?cEVuWXYvUzV0U2hoS1BJNjdyTGc3NWRVYUdITitVenBHdTltcjRxdTd0TzM1?=
 =?utf-8?B?ZHlGcDFucUM4UGVkZytuVGFOZDZPbnNOcW55aVVIdUpKMVBSOGY2SzFFb2da?=
 =?utf-8?B?UWtXckVpVjZsZVpoR3BXaVVKcGEzOE9ZVkxBYWFUVkJ6RkVIMXNTWnZqM2Ir?=
 =?utf-8?B?Nm5rTzU1aEc5R3B5L0p1Tm1pNVBtYWY3cUZJZnAraW43Z01EcUxQTnllejF4?=
 =?utf-8?B?ZDBSb3g5MUU4SlcrbmNvRnlGcjJ2SUFjSFg1K2ZtSG5OU1NCcXdVSVNEWXdj?=
 =?utf-8?B?QzhZQ2EvQVhXdEZxQ0JxRjdqY3pjcVE5elpnVDZpbFpFTU01ZDc2NHF3ZkpP?=
 =?utf-8?B?a1lxbng4RVdGd1NTSlc3QTdzeDN0cVE5azZDU1dDRm5JR2ttYng2eFdYYXFv?=
 =?utf-8?B?Z1QvZEEvM0E4NE9jYk92NVhSMkxTWkhGdVZoWkMvRThhWjN6T1grRkg2N2JS?=
 =?utf-8?B?eW40aHUrc29RMy9naWZvbUJWV2pMdkV2dXk1eGlGWE5Sdi8rU2Y4YWhmL2Ur?=
 =?utf-8?B?aTlXYzR0M0drNFRDZERGeEVvNUhmdW85MDI3ZU1ickV4Zk9mQ1VwandUNkt6?=
 =?utf-8?B?YjVxNmxwbEd6Zi9wUVdVK3lOUVhVckJoOXdZNzRHcW1qcDRBdjZOUU5pOWxV?=
 =?utf-8?B?TW5wd0p5R0k2VkJGbFcxejFmY2orcDRxdjM3dXBXTEhOU053eVZQSkxCQnZ0?=
 =?utf-8?B?TkZQeFl1ODhYOHFTazJNRmZKR09sSEVYKzBud0p2akpJLzdRZzFtK3Y4QlIw?=
 =?utf-8?B?SWY3SnJaM1FuTW1OMDNFajRDRk91ZEZGQjFMVlkzejRsK2dTRTFWUVVuZXV6?=
 =?utf-8?B?VGlTVENyRlczTkZkbmdaQ2MzcWdzYS9kYjdoc09JNGd1QTRGdnpYeUFUUmV5?=
 =?utf-8?B?eUk3amhGNmZrZWxYdlRDY1YxZDhwSFI0M2d5ZG5ybFhUMERtZVFQZ0hxTE1o?=
 =?utf-8?B?cmo4TG5kdDNlbTFVNnNTUmVWQ05Ka1JaaE4rc25lNTFwODNwbjFra1hGYStG?=
 =?utf-8?B?ckRRQnB0Smg0Mlphd0pRR1ZjTFc4V1dQVlBSQ1VsS3FMWlFKZjFDNThpQXpF?=
 =?utf-8?B?cmk3dG4zMmkzNnFKaU5Qa3lEaDYrRUYrdDBkTnpSTGMvaWl4RzJubFREQTVE?=
 =?utf-8?B?My9hWGd3WHdJbUJDcEFsR0kvTzMyT3cralZqRXN1Z0NxMzRmYnFuQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6d74bef-9f31-47d3-f930-08df4a504a44
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7771.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 17:28:01.7079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P0CymmQFL1KDF/rylAkxan7VWsJSlyILdAPzWbpcUt0mBK0gb9b7mn2gYQDOf55C+XlE4z3tVhHGmLpWFuROJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8823

>>>>>> In a confidential guest (SEV-SNP, TDX) the EFI stub builds the unaccepted
>>>>>> memory bitmap before the command line is parsed. memmap= and mem= edit
>>>>>> e820_table only afterwards.
>>>>> memmap= and mem= are debugging tools, right?
>>>> I wish they were 🙂
>>>> But AFAIU they are used to carve out "pmem" or PFN-mapped memory.
>>> I've used them that way for development, but production pmem systems
>>> always had persistent memory in their BIOS-provided memory maps.
>>>
>>> How are folks depending on these in production in confidential guests?
>> They shouldn't but you can't guarantee that.
>>
>> But I don't mind letting them crash if they do :)
>>
> I'm fine with either approach (i.e. disallowing it or doing nothing
> at all), as long as we don't pretend that this is something that is
> expected to work.

Yes, it is confusing for a user who expects it to work.  I hit this
myself and spent time finding the cause: a memmap= hole consistently
crashes a confidential guest (SEV-SNP) early in boot.

I tried to fix it [1], but a bitmap unit cannot be half accepted when the
hole is not 2 MiB aligned.  Also, a TDX guest does accept such holes.

So we are left with the following options:

  - disallow the memmap= options with a clear warning, as this series
    does,
  - add similar handling for TDX, so that holes are not accepted there
    either, as done for SEV-SNP in [1]; memmap= holes that are not
    2 MiB aligned would still be unhandled, or
  - only print a warning and leave the options applied, in which case
    memmap= holes still crash SEV-SNP guests.

Which of these do you prefer, or is there a better way to handle it?

[1] 
https://lore.kernel.org/all/20261113105554.199912-1-pankaj.gupta@amd.com/

Thanks,

Pankaj

