Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795195775;
	b=4qo6AOidPRlATEyyukEgT3fWcMpU/QI7toLZvoCPf8iMkqVenmHdVn7oJEr0LiKKYmX5
	 RglybaYGUMvH5R75SdUWTJ5Wdl492jr4uclj+ngia9hBXpdCwguJc73yMxwkrAdtyEDFc
	 PgN9q+1C+9zZPHhPgQzWZmthHzZX8WcnqwHzMjfi7bAUgyM73Am1xel+u2aMemuejvMMl
	 19LJSt9HgqAG413hwlr9y5JtV0VmpWPLw/QJs0n3f16tww/3QOfhwSBRBYlsysgaQ2TJo
	 b3F5nGoVkRkDlF+iFl3m58LA5PHAn2RzAuwwJLXN2IOXYVPbIGPQgmZcKA/A7SbYOxw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795195775;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Content-Type:
	 Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:References:
	 Date:Message-Id:X-Mailer:X-ClientProxiedBy:MIME-Version:
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
	bh=oGnUUCXeUCOJ16CkWh7YQnDtI0mikaCtQG3sfuy+gXA=;
	b=RdVSV27BvuQKM5nX15tYSmtR2BzQirbkJKSS8FNP0KYPyyT31n60zcuNxg9yarJDwKZ6
	 MbbAftKCLtoTc3hsMAYXNxVwRGKonpAdBqiRZzl4/yuRFr+OFHz03THl2EHboxr0Mha/X
	 aXiCHPtJKMCbQfKsA6AW2odVlD2DxOjfzWw7oN7WRK1mPApzfSHC6GUitUwTHLKOgZMNj
	 +h4fJ0q+T2ZCD9StegfklqlpphxbypFn94NGUTEqWG9QG5wSqu7KjzVGPmiV8uejwDY8M
	 arxv2XAPai0qAP9jizpxquh1YBH3neESPOJDfcvRquc3KegeDVioYJkk8AlTd2idxcA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LasebwMC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.48
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013048.outbound.protection.outlook.com [40.93.196.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702D4606A32A
	for <linux-efi@vger.kernel.org>; Fri, 20 Nov 2026 17:29:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 702D4606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LasebwMC
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kxMkgPUyjFNzQ40O9tfA44Kq80hToTTJXlQl2j8TxUR88iC3c6ssZ4fvvXQYMms5CjZ3/V8ZPpW/dE9GyXPhHbTHu9YB+FBOEB71PlzFzc7Rf3VUPE08YmPWMbKYbqmL8DEaBNxp9PI7/8sIiLRPk+DPVqQ5DekoMLYmoTzK5PeggDbwG9aRhkgqBZldHlIOYgWsW43fm9Dr7P3fsw/C0lHhVQmBrhQYWnbc749Qkgilgen+PgaCmyn67lOCEV3yNvy0xJGIeDm88yqLNg68XJ2NxdOBOHrn1+WfvaQtiORtYPZPjlzYtsGjiXx/wdz091Nfe/Ccc3f4fQ5T6bgCwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oGnUUCXeUCOJ16CkWh7YQnDtI0mikaCtQG3sfuy+gXA=;
 b=bI/UM/Dk8j26yzuTWuue4PsRHzr89H6hFLPJFrOVJWV1oBETTpY7877Ug8Ffzh48ZJ8h8NA4s6BlJVO0kTTUrjesxzwEevTM5JAu7reY3XsislOSo4veO8ogXZAYoO+rS/2ogAq6+S28mXznJMVEhghIAGbXhsJeb9A+9jfD1w38SBCwj6p3eHxHvsnyut0DXtebWnkJHi2kWtJdVmfKOwHcGAcI6Gb/7a8bV80pBA7qsPikXdy0KKptobOJih2quWYofja+tMw4KXM/HC5h16K1cTWaXsH1LawHEhE6NJxCztdO1gE7QRa1gkSySvfHjGDRmPmJXhLzg9pJl17AGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oGnUUCXeUCOJ16CkWh7YQnDtI0mikaCtQG3sfuy+gXA=;
 b=LasebwMCTqOdnhTiLwC38bVKzLroKRO6ahfliASyTmN/8tcCON0bXkgDAYG6Vd2sEk9gwc+lnxfkLahINvTfRDm/CWFDurHk7evKh2r1GeCKdmW1wbK4PddIs9jHVCQeTCwVIR01UPlQNjMtRWmjcH127QrGj2u5r8lpRAJ6csaF/pzuDRLDu726p2vweOVZBvkmemHaNqAhAInfsG5gRTrwjEU6zZjn5sYY9BvZORYFl3KBdoGO78PknLegfBM/RiDzkKxxep0iQ+o/rCojIl7zYqTJlVpdc90RN7CIRWsOrKoRGuOORBYEzgVvh6Fx2/ulcRH0jkIEayHiNNKVsQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SJ1PR12MB6099.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 20 Nov
 2026 17:29:28 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 17:29:28 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 00/19] efi: Expose loaded image properties via info
 struct
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, 
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
In-Reply-To: <20261118182105.1633603-21-ardb+git@google.com>
References: <20261118182105.1633603-21-ardb+git@google.com>
Date: Fri, 20 Nov 2026 13:29:22 -0400
Message-Id: <179519576288.392094.5864308719635887096.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: BL1PR13CA0184.namprd13.prod.outlook.com
 (2603:10b6:208:2be::9) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|SJ1PR12MB6099:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a79b00b-d231-449c-bd4f-08df472bd3b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|6133799003|22082099003|261026121527099003|261022105027099003|11063799006|261102123227099003|261026140227099003|261028144727099003|261022075727099003|261021121427099003|261022115727099003|261102130727099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	2xpAb8vKieghm5sjEP49vfT80cU3AVvdkOenuGA3IqzkOUFOW+bKzFqDz2QGOnRCFASvc0dAXqfJVu3VOxkAc/IuJcB7+PwKInkzkWeQAA4bKvdgS9BA8AlJVYP8GyFxW9prLPn31fJ0mYjS7Zm72oEnei0SO6KIHyHg49/m0s0o/MFwdvVpKOU/6/Rz5UiA0ucZsQ+6Ok8Lf7rcYqBiUlkg25mZC6rPpu0scutIEl7gJFMSH+mLNQxJz1KlbSlfxsPhImy11lYmV0lR9P41HSsBoh3qwEfsdVzUTRsn0PQstulUsgEGGIABgv7Kfk6QC3hwhK/Wu4/ucUx5TgZS8XzTNjIgoheTtKV0AKIPLnZ9jwG8nTvMWaxBMRBQyBTQDzrJ8GyursjFYbF+51TdSVcd6iUfQ/d66eQcGOgdv8yHTG+ln+MlT7boEdOiFLfGpA92CTXBdZhIMRiynwS6j3StdKgv0rXr7HALrTtF+b8LL/8XmHbRG+q9/45sfrJzoUTrhsUsHqWsh+7lTunmc42k8Ll8DyVT3uriC3W5lwpTUFdxDndP3FCVZ5sY3NTawXRmClcBvGzIwmWBUGNsCx1/YkC4qhZGEXJjG2PvdMSewOYav7d5dtAmVr8YydnVyIahBsLSs8s6nPYN5HUnTb6O1MgC36YHI7tj5yJZvrQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(6133799003)(22082099003)(261026121527099003)(261022105027099003)(11063799006)(261102123227099003)(261026140227099003)(261028144727099003)(261022075727099003)(261021121427099003)(261022115727099003)(261102130727099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NWJtenkzaUhsMUJnWFg5SXJOcWQwWHAwWkdjQzZKY3FPODNlenNBSkdzUTZw?=
 =?utf-8?B?N01QMno1TXpHY3NsWXJYSzUrQU5zbDFlcTluODhpdjkwS3JkWGZXemtDMG5u?=
 =?utf-8?B?OTV2RzhGa0Z2TEtzYUxPNEhYMEtzY1FvWlBjVkxtUEFKSUViZWxCZ1dNdi9s?=
 =?utf-8?B?OVcwV2h1NkIwYUE5bWpZckJYOXJ5ckJNNzBpWFhoVlJwTkdONHBNMWZ2b1BE?=
 =?utf-8?B?UFR3WTRqNy9rL0NuaFB4ZTVGNDd3cTA1b0c2SENUMTFkQ2prNFVDSzZsd0V1?=
 =?utf-8?B?Q1BMT1FiUjFLMW55NU84SzFpbUdDbHgxc1JtNmo1d0hUclFUd09tSzlVdmZL?=
 =?utf-8?B?Z0dJOGFPTzQ0bnRMOTlUYU5SNzE1QUkxaXIyeUttS2MzanJqekpRNGViV3RK?=
 =?utf-8?B?SEFPZ1NBT2pMdzFIaG9zODVEMDNqN2VaTW5WWUxDalFZMGl4MFN2S2RRMHF2?=
 =?utf-8?B?bmhSQ25ZZ0dsSnh2SVFiclFkQk9raGRpQzhjNWV4VXJMdnhGZVdvc212ZmYv?=
 =?utf-8?B?SHpCQ1NXcjBFT1NPY1VTTHB0VlhRMGI5NzZNckVaYmt3cEJpZVNJZzZsVDlz?=
 =?utf-8?B?NUd6MzQ2NG5qbDc0Z1BXMFB2NkJ6aDBGZXZza3BQTkxTYjBMeVBzL21UZTFk?=
 =?utf-8?B?SzBsbndNQSsvYlpXS0g0RDI4cVVpS0NMR3l1bFBobVhycHhrV3FSRzJma1p2?=
 =?utf-8?B?MjIwUUpEQ09PWDdUeXNvQ0xPWXptM0FkN1F5dWJBSTlZblpJNGRGckNISENv?=
 =?utf-8?B?YzZ4dExNaWEwZnZwVmF5Zlp2ZjZ2VUFWSzlPdDlXdytod0VLL2Fnb3VJcDc0?=
 =?utf-8?B?NWpubUNGNThKb25GaXI2cnJBYk5ub0grSEJ5K0I2VUJFY1ExakhJMEtwR1pM?=
 =?utf-8?B?bllDdkxFdUF3SU9GMjd4YkRhTnlyQXFRSXFmLzh3UFE4a1dkdUJncThRd1VI?=
 =?utf-8?B?Q0hzdG1ja2NMby85bThadDdQZzRlcVZlTUJrTkpTNWZvTzRLNXJiRXBlNktm?=
 =?utf-8?B?OGF0RFBPK1g4bnVuZzFick02WVFWUFZWd0s4YURMQ05vWlMzN0Y1bS9XNEM1?=
 =?utf-8?B?ZkI0UTRFQ0s1ekRyck5zcS9XL0l3UE1iK21NcDU3eU8yR21VbHUySnJjZkpj?=
 =?utf-8?B?eDdnUW55WEF5UnlNRHBVRkpNbFpZYjFwOVhjdFQ0LzduOVUyclZzV3BrMUpL?=
 =?utf-8?B?K0ZOSHc2eW5wQ3RoRXNKcVZTdmcxS0RhQUVmbFlCeWxpczJkK1VDY09SbG5F?=
 =?utf-8?B?clU4cDRDbEpKWnVaRGc1TW1zSXhldUdBWHZ3UktIZm1XaXFMM01rMmNncHBv?=
 =?utf-8?B?bHdaT3E4c0ZrQVA3V1hDVVh2aTIyRFVFNVhmR3NkWmxrSkJxcHNVWFFGbm5C?=
 =?utf-8?B?M3B6MzdYOU55dVZ6allhSW5ta0o4ZFVHWC9nU0M4T3F0OVlyeVd6RXNCK2c3?=
 =?utf-8?B?cmtYN2FnemdVVDlkMDdtVHBra0FYL1cwTjQ2aHFEYmU1NGJqRG93TXVqbnNw?=
 =?utf-8?B?aTduRnNONjdlNGdtbFZycEp6cWZuajJOS2lJbzk2dDhkaUtFWU1hMDJDcUtI?=
 =?utf-8?B?dUlTQkVQbkZnZVYrUXorSzdIWnh2aHpSdnlrVFd1STlFbmhrejJIU1d2Tm54?=
 =?utf-8?B?T0pDZDg1T0lFdTlWS1lGbmtNaHR4T0l1MVJ2dHJrVGFaek1XS3VndFIwek94?=
 =?utf-8?B?R1FnckREQnI0bm4zb0NFZm9RSXdoSkhseDA4UGxFcFNxTE1sSGJIb05IMVJi?=
 =?utf-8?B?ckhiaHQ5MkI1V1dhU2tDQndzcWtZenZBdWUzK2UwcEVIZDQvcmEwNVgxVndo?=
 =?utf-8?B?S3ZldFpYUFhHOWc0NXhhN2h1dzJaMjR6NWhrUEdFNTc2akg5NXRhRTFQaG5L?=
 =?utf-8?B?L044MitFQ0drbjh5QVVydTNwWExHV1ZtdGJ1UU1CN00wMlpiRldVU3UzbWFJ?=
 =?utf-8?B?QzR0cmNiNHM5ZGJGeXFMQUh5eWluY3d6c0s4NUlESHFhRFJqeEo3ZUU4SHJW?=
 =?utf-8?B?NVRwWXBIYmJEMCtjZlk4aUl5Rkk1Y2xKa1pnb0JxVlNyTGU4ZkNHM0RyN3RE?=
 =?utf-8?B?SENETjFnbk1kdzhYWHRLRU12cTlPcS9yTUovYWtESHdPL1JkcW9zNXRBWGxD?=
 =?utf-8?B?U3hYc1hnOEttNnRZSEZkUGtkM2RzSERCeEUza2ZFeC9yWmlQbzVHdzVPZW9s?=
 =?utf-8?B?dEVEOVJSY2hzUE5qdzhXaTR0UWF6TVV4UVhTRDBLSlp3ZktUK2dqRGk4bEV5?=
 =?utf-8?B?cXJFUzMrTStJZEx3VkhpSk9BcGVYakZVWEVVRWt6K3lYbzBER0xoUUllR25I?=
 =?utf-8?Q?4yWQdn56yQw4uz1thG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a79b00b-d231-449c-bd4f-08df472bd3b8
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 17:29:27.6215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QtqvTXHtoMPEHRtPkCH8DHQiNABPkdQewMs0rk5tCgCMiy3Che3FCHsbJCqNHffq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6099

> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Clean up the arm64 build script and linker hacks that zboot uses to
> obtain properties of the loaded image (which it cannot access directly
> via a relative reference like the ordinary EFI stub).
> 
> Instead, define a generic struct efi_image_info, and expose its offset
> in the loaded image in a similar manner, but without relying on explicit
> linker script exports.
> 
> Populate the struct with section markers that all architecture use for
> loading the kernel image at boot, so that all the linker exports can be
> dropped for them.

This one looks fine to me, other than the minor sashiko note. Still
works

Tested-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
