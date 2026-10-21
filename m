Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.69
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792626012;
	b=TTIHW55duGeZ8RolfUbRdt9AvhSSvgtCPynt3fcGLev2sRTsV/lq2BV0TkLIEifnH8GG
	 Fn30QUnpxqOQYdv0+wKi410gsWMMo9rby55jjaWNHCSb/blBYWPw8Mq+xLY/Vr+b6XLeg
	 /RR3lyATxOvEnbGKuAwB8rMgpQjwu5YojclpjssZaOnOFwMw/Gk2OVYKMF3/eTVm2M9u8
	 bEj68KysAgSw1feWkzSJq8iCEn0QMlhcM21bD7uq5xXy248YHjfvITSdzlc4wNiGKPg3w
	 zDeZgnEst7Zl80wlw8/AhXRb6dexiLEe9Ii74xFN5SRy6ZXFfqDddE3h58/y4ZVBFgA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792626012;
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
	bh=2O8TahgdwUGx77k9JZ9UQFrF7VrFYUWIYsUZJN2OGPI=;
	b=STzf2K47fuo23ubCkjDvLqvBIQ1Ev8JBv9RxE/WDm7Z5DLW7vKbNsZsgzdTeHmskgV16
	 0ispN6/WxBRbxC7gtEkmRY90ONueqwki88CEIJE2YmIWV6zZLBXIkws9pl0jr5XjZOSkk
	 5GJqjSxRI+hDW1nEd7mnf64UDpKBcT5JIz2wp7bkQimaf7Ph7N+88EydRFzC/AUMSYcb9
	 8VLp/4PPjZsbj1/LM2jamo0KNqQ3EgoUg9WJuOqMpTF8O13hdMjth6swM4JTGKJ5O/Zpv
	 DWSS5xUSpc+cfCGiarqrlo99iviTVfJf9w5tkJAfiXUmL8PPY8iKtg6dtBcZVDqdkeg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WtC6NUG2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.69
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010069.outbound.protection.outlook.com [52.101.61.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BEB606A319;
	Wed, 21 Oct 2026 23:40:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7BEB606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WtC6NUG2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pWpif/gAvxxTLPhcBkOtf6E2PcHjIDs1vgZXMw3cdc7aVkU2egcEd0jYjkd6qxNvKLLqWCxQTEaeGqWaaJNjHZa1vMBs7oCq0aexPWyBhWwCr87MtZiAcaIgwosUK5RRjtDwBNpbrmV3OGJ0FZYOS5JpK8ZpPayuEFHWNe5SncvwDJmm9G+/YR2UNKYyDd5vjmS2RpoBBrZ17sKq3Je+czN/Xh6QMByXJIaaVEBXB+iHXScCtUVNH6oeDVlqtPfjl0tCfZiOnqNdVCf3ttkgITlUtDbitEpTvHefUtmvdxbcb8yhLkQyeTVaCVMKwIcSTqDAFEvaMz7xV6O25X5Z7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2O8TahgdwUGx77k9JZ9UQFrF7VrFYUWIYsUZJN2OGPI=;
 b=aTG+GjUFAUy4oXinujtE99nYIQQJHVsy9CO74tuoKVlv0G2Z8+h104Im3CGt3rFaJhrko6Rz52pHGcFxR3VS4MKLaCSQuQzNhl5Jt7sVS9wnydVQAS8x5PwnePNly6WJ8EaKVNMuShjVDN2QnpCuPDU4GJL3ViwdhU+98ursCy796qkjsVDdSXV4CBuCZyYRfirPRuu/YGNbzLHGCtdXq7Q44XkPythaLGW9YkJ/Wu2Xz1JeIt9w1e+LiQyg7Jl+3cE+nh3F7BORD7AEycyF4k59UMabnzo9pCJgNOLzNvbZgxBNih6jMRN2zGC6gtcr/7UALR3VvZiMYNkRrKpvMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2O8TahgdwUGx77k9JZ9UQFrF7VrFYUWIYsUZJN2OGPI=;
 b=WtC6NUG2SsxW8CgG1RxWrvBViz5JRa1bm2ynUTMWOaEtZ5XMEnN2aL4LQ1eVBtelM311XcdYbHny5sVtU9y9+s5yZRWLtqg+lcvtmUSBpwl/lqY+SQpwhBHORDok5fXvMX3DeHfpToi5vcygbPJSFuFGdgKwlBntX3BvzKrpe4V5qUaTFRXIbEhq8MNDYw1Wz8im58jzOBAV9FPkL4iOrjD6B8kPpucPZZlOmH8gvaJYq2QgBIT986LWVtx0M5LO64O01b36QApuysOt803EhIun0tIlLnyOevSJDubnXicAvudc2pblx7w8vtZ0zxlSxPKVUmhCsOcc2oyDgND1bA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SN7PR12MB6910.namprd12.prod.outlook.com
 (2603:10b6:806:262::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Wed, 21 Oct
 2026 23:39:10 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.012; Wed, 21 Oct 2026
 23:39:10 +0000
Date: Wed, 21 Oct 2026 20:39:09 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
	Ard Biesheuvel <ardb@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
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
	linux-integrity@vger.kernel.org,
	Palmer Dabbelt <palmer@rivosinc.com>, patches@lists.linux.dev,
	Piotr =?utf-8?B?S3LDs2w=?= <piotr.krol@3mdeb.com>,
	Ross Philipson <ross.philipson@gmail.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Song Shuai <songshuaishuai@tinylab.org>
Subject: Re: [PATCH v2 15/15] efi/arm64: Implement ARM64 DRTM in the stub
Message-ID: <20261021233909.GX3008132@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
 <15-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
 <20261021111115.00004c5c@oss.qualcomm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021111115.00004c5c@oss.qualcomm.com>
X-ClientProxiedBy: YT1PR01CA0107.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::16) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|SN7PR12MB6910:EE_
X-MS-Office365-Filtering-Correlation-Id: ddbc71d2-4abf-4532-77a6-08df2fcc81b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|261021121427099003|18002099003|22082099003|261021135927099003|3023799007|261021123027099003|4143699003|261009223027099003|260925021311599003|11063799006|260925022911599003|10067099003|260925021911599003|56012099006;
X-Microsoft-Antispam-Message-Info:
	mjAaNPVHKA5PDAfBFhaJ+2+5vonkcsmRSVo2KvhjteLq9X8VAHPiPIAi76j27U+PraY9TBXjqFwk8p6pqXxV+SIu12kq16YGUap58ts24VQQigoVMfTJGmwCbANczu78AjzriZI1iXNXMEB20tVOp6AXxjdxgJSi1xShnko5ynX8iggpXBIop7kvwjxRBvRA3R0GpSYOeUmg0gVA4BLwIqOsEHbshMJ/n4VxvBJOl8sV6TKJDot8rmsHoG7Sr+zlP4uaB2U6Ox6dFWnO04dvESVDpqqUnn1636DkgO4cfsRhopR7CDHk241hOhxb7R9WtNGJpxVFhiTnRFldXLmr1OkIvm9QtpLgW2k/RcZLc8cAJ8gWtWHb9Kzf6ex3XeA8Nkd38h8/YgSt+x4b0siZZ4HFkd1DuTYfINwwaJGjWV396GcR246fiykqmHN1IBZRPP02GuZh4zdicqqlBeqjCDADY+Sb3HmRjr0kBj/zLH2zPVjxWaSdkQGkmKIgxrFjPD8ktgqJvdKzq2enbZCR2qU1ukeaKo5fdwHDQi4wssxgwZ1leS4i6UwAOE8U3bSZhVOOS1JEPVH2m9afvF6UGERn/YWdVIiz9jv6QCJJ2UDXKvGrz9ys4ECoDMe+ycMMZXELZb/73Q7sk1H/YQ76X/qTwt+qMEL4ACeWxFVTQWQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(261021121427099003)(18002099003)(22082099003)(261021135927099003)(3023799007)(261021123027099003)(4143699003)(261009223027099003)(260925021311599003)(11063799006)(260925022911599003)(10067099003)(260925021911599003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4V2Q2GW6mSAa/9KioMwxGvy5i+vi4GMj4dEWMuKfPFM077W+goMyLY6tTXy6?=
 =?us-ascii?Q?pPb8q6BW2Yicz5UGKWntz9QFEj+ENOxAaN1M+G+byOowQ8tuJP48kHQcNNRW?=
 =?us-ascii?Q?75BbvMKbhftRIYaND9owe/1cVlqQJIiQK+PtcIL+dAcIvs3Ihg5iSZkG/4Qu?=
 =?us-ascii?Q?Jfai6ztl8XCR2CJkGC2rinQoqtBms/8yjsPYtHBgwU09uGGOJHp75dg28VPg?=
 =?us-ascii?Q?uy+Emm9kHgBvp/GJghbKBhF5tgy5e7w12mUPYOGZaD9fBwFLMEBOqu5aLQgT?=
 =?us-ascii?Q?q4I5fZMt/fhNb1WoTGGA0tU3UgUpcZfbFyYGbWvnHzy/W+rX/275HOwQvTaA?=
 =?us-ascii?Q?UsTo9kxj3RgD21mqV47upb38x2BNqYKqQ+CoIaYIdZ8Dz2NBe7G2zMLpJ8kb?=
 =?us-ascii?Q?sqyx5MgO2aesPOzbOU7ZC7G3rVtQO9uFv2+e6/KtisKa2l3oiNr2NLIvOo03?=
 =?us-ascii?Q?7fRRg3L6DZ5fWUIILjQ6izpI5TIsuMPsVoD642XXgXycv+QvSgxnjWBe52Gq?=
 =?us-ascii?Q?ICxb3xa+40SkGqFAHOiy0cSgyTIWp3QYlN7sjbKZ8j3SN7XcHNLjGyNwn0bu?=
 =?us-ascii?Q?bnFMvoaNCFZpiGNbLwN4yjCrNuf2ZFGcaR9RtD3XLeSY+RJlbJt9zhtSlp5s?=
 =?us-ascii?Q?bkakZQhqU7Qtk8QISK3nI6Rc1xQtj1YG6YQ/YswXN1+SypRcbOibS2KI5jD1?=
 =?us-ascii?Q?AlOuSWjyOAcKW2yiDqlVJERVl6rL2+/E6CiWAISx68PuCA5GGh+NpGA33nhL?=
 =?us-ascii?Q?qrwNEqyNSsHu0bQeOoitWEeWc55WPa2kj7b6e9spd2ddlFaGONqNOekNx46I?=
 =?us-ascii?Q?lF8DgEzhWBmqWpZmL3OUVLpcyLFTIh19kZtLL2DQB7uXo1nJ59hIyKK5KVc7?=
 =?us-ascii?Q?wwMgPjgjU20ouAG1fWllP6GGRdD8o2uZQrVIeGcGrkepYdj/SoLZi49d5CMK?=
 =?us-ascii?Q?U/fdij0TzRGaCReEAy0BH+trwIMNFHeiSkgRLgjGItVjccch4kOp2Te8s1WE?=
 =?us-ascii?Q?hwoElSgRBs0HCVQjuF6f4QnuyCsp4iblDiabZ06SEKmj7zEDhgx7A532jbMU?=
 =?us-ascii?Q?EjhRH4IM0GLwqyVgLqTiGDjqK/qvI8aoCaP7S4SYcRZ4rGy/EU7mi52E8LT4?=
 =?us-ascii?Q?aIJoo3gD6H3POICL6J6ftDOsH9WsslzxySC6XPhHEXsM7ju85C/sanL2jbB9?=
 =?us-ascii?Q?+F1YyDJC7BTVv6rDPIYSM4Nxb3MQvETMld2y4iZ3OJZZeeHTWF1qUw+tHwKC?=
 =?us-ascii?Q?CywYQ0O6Ts5X04JD0YLJKqbH5Z8WdfNemuZXKLBKglCGQGWG9hRGqugujNd+?=
 =?us-ascii?Q?zlfFljlrzT5F+qs2Iif19jKWH/IB/q6FycA3JPCQ8pZSoI4CKshiVhVgdZUd?=
 =?us-ascii?Q?pMnH8WMUXsnZ+t347WLhNffLaRHM/ZqM6kWxSAgH+MAeFGUkqrxIHAveJiSL?=
 =?us-ascii?Q?54v08YnlPe/CMBhM8XHCKqh1cXw59YHNTqsnXr7tjHJyGUEUG++mHtJuWKqd?=
 =?us-ascii?Q?B+nwO6saDtH4uQWmo7g5qnCQtHg1gJT9Ud817FwGFbD184HkMAjyDCyDNSlE?=
 =?us-ascii?Q?8OlHbClq3kaS7ui+pSStSMCJGZtpa6CKxZhufatukh5L4SkrXRAt6VV021BC?=
 =?us-ascii?Q?9bWk4QTq1x05nQ3VH4EtldJQKocnaYq+/nbsofw4cB6Tv9cL7ItpOdonuYcC?=
 =?us-ascii?Q?pdk8wXFdOKjs2/WarAV2RtxuId7/ZIQi3dJwNfodCuLQrs4M?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddbc71d2-4abf-4532-77a6-08df2fcc81b1
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 23:39:10.6555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nUvwOB7Yp9MiNYzogIW/C8kaQ3sw5orNrTDXTK+W2MZSuK9tusVudET/j8RvG9V1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6910

On Wed, Oct 21, 2026 at 11:11:15AM -0700, Jonathan Cameron wrote:
> On Fri,  2 Oct 2026 20:31:52 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > Provide an implementation of the CONFIG_EFI_STUB_DRTM protocol for ARM64
> > DEN0113 >= v1.1.
> > 
> > First, it queries the FW for support and collects all the
> > information. This is needed to compute the extra_size, which comes
> > from FW reporting how much memory it needs during the launch for the
> > DLME Data and DCE-owned data. The generic stub ensures there is
> > trailing memory after Image for this.
> > 
> > Then the DRTM_PARAMETERS launch structure is computed using the
> > offsets in the efi_info.
> > 
> > Finally, the stub does ExitBootServices and calls the actual launch.
> > 
> > The feature discovery process is deliberately fairly verbose to help
> > debug any FW weirdness in the field. Enable it with efi=debug
> > 
> > It looks something like:
> > 
> >  EFI stub: DRTM: interface version 1.4
> >  EFI stub: DEBUG: DRTM: TPM algorithm 0xc, TPM hashing unavailable, PCR schemas 0x1
> >  EFI stub: DEBUG: DRTM: minimum DLME data 73728 bytes, Normal-world DCE 0 bytes
> >  EFI stub: Decompressing Linux Kernel...
> >  EFI stub: Generating empty DTB
> >  EFI stub: Exiting boot services...
> >  EFI stub: DEBUG: DRTM: will launch, selected launch features 0x0
> >  [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x000f0510]
> > 
> > Eventually the launch'd kernel is going to require built in crypto
> > libraries that match what the FW is using so it can validate some of the
> > information left behind during early boot. Refuse to launch if these are
> > not built in and build in the most common ones from the ARM64_DRTM
> > kconfig.
> > 
> > One nit, if the platform does not support SMC then using drtm=auto may
> > crash on the SMC op. As far as I can tell there is no way to discover SMC
> > support through EFI. Learning it from the ACPI FADT is doable and costs
> > about 250 lines of code.
> 
> Ouch. Sounds like a must have if there is no easier way.

Yeah, maybe so. I will include the patch in the next version. Though
I'm not keen on it and I don't know very much about ACPI.

> > +/* True if SMCCC 1.0 or later is available. */
> > +static bool efi_arm64_psci_smccc_compatible(void)
> > +{
> > +	struct arm_smccc_res res;
> > +	s32 status;
> > +
> > +	arm_smccc_1_1_smc(PSCI_0_2_FN_PSCI_VERSION, &res);
> 
> A function that is meant to check for smccc 1.0 is using the
> smccc_1_1 namespaced calls?  Maybe add a comment on why that
> is ok to do.  Is anyone actually using SMCCC 1.0 on systems like this?

This is a good point, I didn't quite get all these details at the
time, but yeah, technically we have to use the 1.0 calling convention
due the register clobber differnces. The other reason is we can't use
the kernels 1.0 helper since it is an asm function not an assembly..

Fixing everything I came with this:

/*
 * Discovery must tolerate SMCCC 1.0 clobbering x0-x17. The EFI stub cannot
 * call the kernel's out-of-line SMCCC helper, so issue these calls inline.
 */
static u32 efi_arm64_smc_1_0(u32 function, u32 arg)
{
	register unsigned long x0 asm("x0") = function;
	register unsigned long x1 asm("x1") = arg;

	asm volatile("smc #0"
		     : "+r" (x0), "+r" (x1)
		     :
		     : "x2", "x3", "x4", "x5", "x6", "x7", "x8", "x9",
		       "x10", "x11", "x12", "x13", "x14", "x15", "x16",
		       "x17", "cc", "memory");

	return x0;
}

/* True if SMCCC 1.1 or later in the 1.x series is available. */
static bool efi_arm64_psci_smccc_compatible(void)
{
	u32 version;
	s32 status;

	version = efi_arm64_smc_1_0(PSCI_0_2_FN_PSCI_VERSION, 0);
	if ((s32)version < 0)
		return false;

	if (PSCI_VERSION_MAJOR(version) < 1)
		return false;

	status = efi_arm64_smc_1_0(PSCI_1_0_FN_PSCI_FEATURES,
				   ARM_SMCCC_VERSION_FUNC_ID);
	if (status < 0)
		return false;

	version = efi_arm64_smc_1_0(ARM_SMCCC_VERSION_FUNC_ID, 0);
	return (version >> 16) == 1 && version >= ARM_SMCCC_VERSION_1_1;
}

efistub can get away with this inline asm since it isn't 32 bit and it
doesn't deal with quirks.

> I a bit surprised we don't have a common helper for this -
> I guess the version checks are often explicit in a particular
> driver being bound.

The PSCI stuff in the kernel is all very early when establishing what
the channel is and is done only once. Here is a bit different
since we only accept the smc instruction used by drtm..

And even if there was a helper we can't really call it from zboot..

Thanks,
Jason
