Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.34
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793721731;
	b=kkLzPwIgKx75mytIBq8+db8dlOCnmHn5sx4mMZbBoN+z650+W6qd8NqzKzBYUrpNJitL
	 t2BTDA/IRkRalJ7R+YBCabf4YURhZzuYVjob2qWXqEmHKvsbrKmKnFESiYCdHvgp4tdVn
	 Eh30Nu9z60PlYbIfS/jVdbIQe0iOpAbKqJtc3Cy0jSXS+XML8FBGtaKRzzad9yIq/P7ei
	 ebfUuospE/mTm1VGph8L0CoK3RmYjqUTOOT52vnats7IWMxRefzEFXchHYEjmXhsGz5/u
	 cg17a43r5ZDd2X2pOi24YtNgQQAUPeZz8I8BZ/nJYoRNNeSqO1bIuRKreI4hg5fsQQA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793721731;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=NxRFJnP0vCfVm5KhlOIIHh2uAAiRiqctWk96g7tOrUs=;
	b=HsJVcZtahhhDMNUYz1QZ94HJLYPnpol6zRQPEz2wYFZ1i3F6BK7Jz3h/JwfMUXgoANiG
	 jFBuomb/ZrjslxK9LFWskeGO2G2oZ7ebVwpSBPDJEJnSDz4NS2h170N8uHCBdH+HHEdYi
	 IdbqT+ym0mopDhsUKi8eKqhUPFzfFljzBdC1EGfS7oGrpfsTAgTY0X25Iie1gP0bUbWJl
	 iqnjSQ4fxr92us1ip6yWJRNnQGUNGQK18MSMq1czR2GbnxlpVJhwLDqZexP6hY4mYabPM
	 iLMgKNtBTXtiDMIOt1RPh3rdcXUKT/RHgUeO+IUdzq5IG5V++fFUamljuVCiwlLKHsg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=rLQlUCJO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.34
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010034.outbound.protection.outlook.com [52.101.61.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA4D606A32C;
	Tue,  3 Nov 2026 16:02:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BCA4D606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=rLQlUCJO
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mR75k6cpFMLwvaYJm4aInbg9uPFkjAp8TRqL9tl/o0lAaOyIQRVSTB8ypKKJtvLCr9h/GuQsdjD3CGfWWrJvN4rkgiTfmFzeqgJtmlnJVsTWGzNy8PAdtpfv9IGIwwJ3EsxugiK5+vodySPIKp4RWx4N7X/yCTgZ2ZmKyPpz1vmyudCC9DrZnk9qPWb+zc4F1obevCFSDVEDZ78KkkkXLiAZbj1JgJxkCMbCmR8bwRDwCm6oQT4eoQOXFtZG8/+aPrhn5D+TojucC72MosFFpbXW/MD/UtSNGD0Qrp90TlP28AH1MP4juBDm+Ac+eFSq3zbDEfM4EipK+gR+OP4utg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NxRFJnP0vCfVm5KhlOIIHh2uAAiRiqctWk96g7tOrUs=;
 b=Ho/5yjF9c668r32HEkRnmt77MBlpNkz8/3l5ohIx/9JtNYvTEEH0gRgG8fv0xMfmlL+8l/Z2YO1iz1NXfVcW8uQLy621eot8bEBMTtLjtG1R1Ui79aNKoYxpXkSIllzt4N6MtHk9lxb0fteNEtEPJ3jXImxhnY0/qVPIWgfulXd+kxHJw94cfYIBFVd9DWrb3QUiPJFP6FC7OMDoCbHNOqf41nmRjkSHBiRoRVHQqOARBVRxG/0he/XT620d1/WhA0hcQu40okGaxqC9vnYO3boC9QxekpDO0PFdZzvse/lcXiVxLcSPLKJQ0auNCFNi3P+e4RnJpIvWeOb6uHcSUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NxRFJnP0vCfVm5KhlOIIHh2uAAiRiqctWk96g7tOrUs=;
 b=rLQlUCJOTjylveRzkwMb1EAto8v2Hqi+zRG1dr+X3BZ1gjpwh3mZfkVcFCagBIbu/Jnd6v+4rygpHNX+X70uRdINv3roH36eqMLFasbR5q/whzC60h8uIf7Q2G41KxpgWOlgid3HJ3QDSiWMRfEQ4KMxO28mWGzZR9p5BsazGmDlWhTyo+qqco7iG3WamnHqWefcI2q20Ugp7Fxl/jG+8GvBbFAJcGz8aBK1SB2rYYwKAkkUSefm7pRckT5fX9dlGztjjNFuB28Kw4JRzawQB1Hmrgr17FAc/BzFuy18DlZCA4jeXBQ34jAo4eoy36pG5P/mAkThVzSfadPOvZlvZg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA0PR12MB8375.namprd12.prod.outlook.com
 (2603:10b6:208:3dd::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 16:01:41 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 16:01:41 +0000
Date: Tue, 3 Nov 2026 12:01:38 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, David Sterba <dsterba@suse.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Simon Glass <sjg@chromium.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Nick Terrell <terrelln@fb.com>, Will Deacon <will@kernel.org>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	linux-integrity@vger.kernel.org,
	Palmer Dabbelt <palmer@rivosinc.com>, patches@lists.linux.dev,
	Piotr =?utf-8?B?S3LDs2w=?= <piotr.krol@3mdeb.com>,
	Ross Philipson <ross.philipson@gmail.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Song Shuai <songshuaishuai@tinylab.org>
Subject: Re: [PATCH v2 04/15] efi/libstub: Add a general way to get symbols
 from the vmlinux into zboot
Message-ID: <20261103160138.GA3165945@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
 <4-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
X-ClientProxiedBy: YT4PR01CA0318.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::9) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA0PR12MB8375:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b409bb8-c304-4df2-37e4-08df39c3bf0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|10067099003|22082099003|261102123227099003|18002099003|261021135927099003|56012099006|11063799006|4143699003|261021121427099003|261022075727099003|261022115727099003;
X-Microsoft-Antispam-Message-Info:
	WTbVxq4H8WiM2LXuASztVVzLIU7xAC78p6y17VXQi/75pxtZSIkBgauQBRQc/YJvQasEpwDgQBHSQU3PDsMogQO/E8mhtB3xLlm9ZodMMyIJWjA82Vh9pAnQ86uV0cLZCq87SYZhQ6hy3d/FdLn+6zo3XYEdU+ntlbDOD81n/aHeinGBxeeq9jwOe+GSNbWSUUUhnrPFeteACCQfjza7ryeE0QYWq9HLZFcGyHWtu7Ol1Ho/YzFjFVGqvZHpr2FSiZ6D3zc0ExyMLwuAZaJ6QAJ/PYPQebzr8xXCze3X68aZe9OSRXPdb9CPwj5SP+4Z6f+owCs/GHVEjXAZQn1kSvKQROQo5JRROq1KQQFDjMLdOX/scNd8TmZHgfluk1a74u/gNKcdrEuv2AxArehKrjk1EKchKJ7i1U/wUS5iDGRcQPV5zQjAmUSnEwDrpgfFMKfIDyGg6BmA3THaT3LxgDuAbUGRGcwSNaO2dRDEUAOvxNk3u4Ui/Akvz4HXH13ggA2F36GfgoQLwPsbZWiobnfTJnHNdozPThE+5qcSmEP4X05YyocxNRY4GO7qbTMtZ0WZApCmigURFsTvyHsuTLCqIHHFcApJ9rKubHy3AfD6TRoT8FIj/XWG+qxZ9Jch6CH3QDj/Lm2o4xhxCqihvi9m81XP5SmxyMj5LwCScaM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(10067099003)(22082099003)(261102123227099003)(18002099003)(261021135927099003)(56012099006)(11063799006)(4143699003)(261021121427099003)(261022075727099003)(261022115727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?v77AKHZwBL46MFGmwAsRPMZWrqHkaiynTP4GPl0EMrln8qTi0owllx80PUgQ?=
 =?us-ascii?Q?IBHswilCMYAexjNwjc41nfcENVKm6dDvKBTkul5maWucZEMNx8YSLUG09Zf2?=
 =?us-ascii?Q?NbW0BWkRJoHT0UeXj35JrXqRbJaVW1YaJ8a63mY7EN12ti4TdPq+tjv4Ixio?=
 =?us-ascii?Q?z9HZNaANHHp2nKxKdjYnN+rhgHap+Z/ho31JxicMPg337WtHNiav33HbJB7K?=
 =?us-ascii?Q?Z4Kg+XivAhDL17UDejyLQM8C0CyTpG58z25nQezVy3FVPlyNMsSyyT2VOwMz?=
 =?us-ascii?Q?PEKYh9wrtOZdSXoqqHr8oTtg2Doqc466PfQZkE4Pagw2BFvwdcffpepz2zj4?=
 =?us-ascii?Q?QOfEQPbUW+n9HSKCzSPHQpY/6ut1ZMaRAg37aavwKaFaiYZjK1hKoPdv/UOS?=
 =?us-ascii?Q?kQ88gbCyJbtNXtlauVEed8vz8PBI1QETKYoT42KrebkhWac4dVDKL9P1l65E?=
 =?us-ascii?Q?d7TxwqJbOu3vq/f+FnRHqdbti/AnU0r2uSwRp8wtSiYx17Fzl2pLIvdyDgEn?=
 =?us-ascii?Q?AFRwy+eX7zlXqv9/SZyPpOP8cTwhHYkKVpkElJ75D4ZoWEnfqJXH4wnUotOK?=
 =?us-ascii?Q?J4ljmKnbOd+vXJHDpRpUkht0rS26NksoPbXGgmgk7/FbdHzo7Mt5Eadg5Fp8?=
 =?us-ascii?Q?bc19h1FJEWS7FC+OLUMJVrABmALIAW5LwXXZjCeelUpQYcTgNeIQjc1tIKbu?=
 =?us-ascii?Q?epbfR+5koQvyxUfQgBNgnsPZaZrnxEC1ObXGkPhyubbkXa9qlr6EOKsyKPAJ?=
 =?us-ascii?Q?SsYiB27xA1EKpTwruaymoks0ww3jfVfDV1+0+wQEJHAe3IN6LpsA3cDa/1uz?=
 =?us-ascii?Q?QQRcrFOyLVbqDhYVdWU7GeidJLaZ2fw9XTP5EsHTMzCFebYMSKuAMsD25pFY?=
 =?us-ascii?Q?72y354zQHs9a8LVJJL56QOBYIBDtvYH5+PSjf/ISO+U/SZWyyoESaW+FoHuE?=
 =?us-ascii?Q?5YY8ZepAoIda3JdUFL1sjq/nrw6tt+8RccF8TYNFCFqwB5AUCeqjY2lo3b/f?=
 =?us-ascii?Q?/2a+ZCq4s6AVAj9v66LbGKFrDJzLUfWEuuLqmsZYVZrqW1DFKllhuTZvp98F?=
 =?us-ascii?Q?D+hSr3rp+H7EnaIfzshKWoqVz389XA22tCBEEkwxDi845uAKUPIQ4s0vOPms?=
 =?us-ascii?Q?U0USQRqyuTS50jvoDSSmGXD1O5olThDH+hIPiuSCg7l3yaODI4bv3DIEHLzX?=
 =?us-ascii?Q?0WhVNwMOg2DbThDEjKqrbRGQ7MM7iQ8iaP68AchCVfs1i4+RMeF9Ea0SXJ4P?=
 =?us-ascii?Q?8dJrEwAIjrdITqV7I07dknGiLWosQCL+r5sKhoF4BQ+QCJCwsrOwH15Quz1A?=
 =?us-ascii?Q?+PIxcXnPVzfaLpfal1n8GwV3GPZC1XT/kBvNFWYST+M0N9uojs0fv4XLW+v7?=
 =?us-ascii?Q?tf0jzYCJU8mSDIZdmD/uKMa5BYimrN95MQd3Enl6UzdrPLTxxL7qtY2eN9ZZ?=
 =?us-ascii?Q?4t6yzPiA2QIwn1KahqbmVonBnffdaMhiudE6P1/SJxCJUkbQFa1oDCeJDJ8D?=
 =?us-ascii?Q?uTIQ7kLTID42fcK4HdVI4vaKAqaT3zMznfRK8x/+iVz+gTq54RrMreYwTovk?=
 =?us-ascii?Q?O9H39FjTI3FAS/J0Z+YrG4g1BU31SNdAafqB948T2axCK/xwA4UCMQNJ9fHF?=
 =?us-ascii?Q?9n6G2UGNN8NlJme1Mbe9WeSwGC15nPtFjxO+dT4r00BnvHk8ZfA8DypP/0wE?=
 =?us-ascii?Q?KcdkXi2zRjN14esufG9ykUsuJF3xoYNm8D4KGicjnv3Ic+Rd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b409bb8-c304-4df2-37e4-08df39c3bf0f
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:01:40.7413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7iV7et6HbGRij22+uJGcgmJwUxXSV51jcnTkKHZgS6HdJG9Ct0nWTx5a/f13IbkI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8375

On Fri, Oct 02, 2026 at 08:31:41PM -0300, Jason Gunthorpe wrote:
> Currently the zboot stub has no access to symbols in the vmlinux. In
> contrast x86 has a voffsets.h header that allows the stub to know whatever
> symbols it wants for the decompressed image. ARM DRTM needs another 4
> symbol locations to work, and it also wants to compile the DRTM libstub
> code once and have it work in both zboot and embedded.
> 
> The current solution in arm is "code_size" from commit 45dd403da851
> ("efi/zboot: arm64: Inject kernel code size symbol into the zboot
> payload"). This is neat, but it makes the zboot and embedded cases
> work differently.
> 
> The x86 voffsets.h approach is also nice, but it can only work in zboot
> since it relies on 'nm vmlinux' to extract the locations. That's a
> circular dependency for the embedded stub.

Ard,

Did you have any further thoughts on this patch? Did the sketch you
showed me at LPC turn into anything?

It is rc1 and another month has gone by so I'd like to repost this
with all the feedback

Thanks,
Jason
