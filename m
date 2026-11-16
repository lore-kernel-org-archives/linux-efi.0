Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794855148;
	b=uUYDZX5oy2081knsHpFLIS3Oih5KhmkmvLC5YfhlqdOApPK9hv7o9frt9/eVFkFnxJNN
	 tReqpMxdXIgqg6EC1zwZfcZy5DuGq/gvkpF6SDIOxJlNwAQdZO8P01dojb+UbZ7FmQCQD
	 M4zEeIKRU258F1Y+7+NU2VEECk/zXAeqooJK2sduL7acn9bhYVqWu18atX+ucZ39XD5oL
	 9VDyWkz7i4Il5/ZxGbIRCQIrQZV7h+QZuM43R0N3c1057Tq30nvt47o9XeUeUE2rLLKXf
	 2N/goB4AVX2FgK1XPQowfbvrcadDKMMJVJqC85U70iB/XqfQ7k7KLiQqhr13YT5uNPw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855148;
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
	bh=fne59OLCfzObsqoTcBwjTpqKprh3ztnnwcCbs7+DLs8=;
	b=AvDV4qHyOksL1+FNyLpFpNMCLFqQNzU2x3Dzl0N1SQ1DjtRuKR6NBMxs8O9idSimysVw
	 lC2VE8IXrBMs+U5yVKY/wFcQtBZJdnQx2o/H1OPSif84NZILxpPzZgnWj1gLIYpXUsBLm
	 sEAkV4htcimH2rSY8lfZMJJBi3HHhkIZ/48+yQ/fZB1urcLIPljeXI7SkBD+f6BhDlnDe
	 Ti4fZYg+yvHkvJ+wUtJxQw37LTlXrhz+hiQybv/nxd9pfba+e0vZzFrVMzsNaGzkluT7f
	 YGAQrlqi92mcH+6nT6sx3TungSLBcK96EkF4ZdJ/8G12CkHx+e0wbxUlz2FoQMbroMA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WmWHOmR7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.7
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013007.outbound.protection.outlook.com [40.107.201.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4BD606A31C
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 18:52:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB4BD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WmWHOmR7
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V13l+X2wzTn4hJh8viS7CKjw0dB4PgvxpNrkpoclRVcNOriXqdGCy8uXtg8epNQf0h9Q9jdiobNfPAnEybNxQ288oQVopXJZdrTp+Mk/i1A/IjbM3AW58bScYCULNqWnTbT4fuPKCtuEhcA0dORM3lEK7zIUNrG6dGoIsguVOTv4UkvxLHnrKdabN6ueFL4+rg/HSkl62YRYKfd7jr29zVBM6QADs0YXTUi2khew6n7yM/IfYObeSr9Zr2xTvzMqcmZQPRsP00MSvP3nTwwrbmWQym1spq480vHo6vjAzmoMC3/YXGJRyE0mwQcFodT3wKX5loBvGpYhHaN8GQh8ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fne59OLCfzObsqoTcBwjTpqKprh3ztnnwcCbs7+DLs8=;
 b=DGN+2rh4QsjvQYMTkbbOZj7lHK6QWbrrvQbNzqp+d+f8xxn/ws2PlNIUCfeDd/LKtKPDMeT8/M5ZVHtJmHQiOKn2e2DL2RZUrQ7IZh73w5+nx8rR7CEI1D4JVWgMrAN6yXl3r96E1WaA+zSSoXC1bbKELwy3ucwgAuJd9yG/zqvhLis1pk8e2BLPzFIz3Ue8FrU1ckpGTy7+TlNlLTQf7p3TdQoncLEUg1X22Ef9SR/LJdR+hnT8BV8F0HlaP+sbHwupPovZ8clFSOoT8ztKz0NKju5+T+/P4rXgkt7oMG4Cxpv4LYi1S6lzeo0LTWij3uK8zUdnuBo6NFc8ePMspQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fne59OLCfzObsqoTcBwjTpqKprh3ztnnwcCbs7+DLs8=;
 b=WmWHOmR7QNNcgFHynsQMFvEGZG/7LcEes2SszPPgxeNunIQSucXMHS7UwGFN9Rbk49B1kekLoSWh12jz8X1OFa33KK9Embx95agjsfbxpJ1yj98tt4fyFZV+oeZ0Le7noGPUx51PuLTP1KK2XyoczNQUWgQKuAC7zkt1S85sBE49Xk0sbSy6N9lNvtw1bhJCxmlI+k5s9MHi97+Fy0SifodRjgh6hBUEkppGPo/ys863qviN03uIb+5cil/sH+OIqvpnxqe/snoEj2K+mxskt53OL6bc9od1P6B29eqvIRCfVnUjpfv3YMVzXigWCJLfLseRinOD8HwAOSYE/hfDVg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA1PR12MB9062.namprd12.prod.outlook.com
 (2603:10b6:208:3aa::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 18:52:22 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 18:52:22 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 15/15] Revert "efi: earlycon: Reprobe after parsing
 config tables"
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, 
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
In-Reply-To: <20261116142618.1687025-32-ardb+git@google.com>
References: <20261116142618.1687025-17-ardb+git@google.com>
 <20261116142618.1687025-32-ardb+git@google.com>
Date: Mon, 16 Nov 2026 14:52:15 -0400
Message-Id: <179485513576.2274641.4258294521341946928.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: BN9PR03CA0583.namprd03.prod.outlook.com
 (2603:10b6:408:10d::18) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA1PR12MB9062:EE_
X-MS-Office365-Filtering-Correlation-Id: 897e503a-401e-485b-8c14-08df4412be6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|22082099003|18002099003|6133799003|261009223027099003|11063799006|4143699003|56012099006|261028144727099003|261102123227099003|261026140227099003|261022105027099003|261022075727099003|261021121427099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	1C+Z5pdE8qP6pLeXCyWCPXSGnwoNVmrhXOq2/XeeY8F8Dh3dAtCKu4IbTmDF2e34bIl3a7I9o8rlPSlRV2+ywTpXO0IrRZ3K/wgKOPYmuZ+Dr/KxKgB9Xzy4B8XgHW46vP8U5zTn6rHPSOcCzh+r5MLGq6fV95GWgsOjPWtzR1EQy1ODirIznrFv2NcijfC7TNSehlmoh/1mKwKUTWoT2FUi0puCNqsE3H1hIgmeEtecNKy7Vk26WrLzuxHYEVIQhO5/dU7+DJlo96/F3u45gGQNPh7oDSh6t+5R8SO7W7ajNhAi12ytrv0hY6bRwiLLHl3P9q03bqXVFETHzn6uduTT8uYukB1u88J7x8fr1l3rPv2lqs1stub/On4U5v8YIYMXh0xdztDkPCIjIFo4OYIbqJaLtks2eO5ULEpfcQDH6NpIimvZa2Hzsg+Ni1XRdCqtGIk8H15/Jw6r9kCA0vDX2GPf30ZFYBbm8G3JNwd39QD0fW1gcgcF61/mQKNSzR6430FsQ/VYjkTVI/Ib/+nvwOov5oXuXjbh9XTilwJSn0zeXkQkWB1pK4+LCsrS9175svhpbI+Z71ZrVGfeALqbIYxvC460RCFaCzIef91rs8YZwMdA9haUeGfXHctnr80hzZWEbC/+qPpZEACCrSHnn1pshMMzeMvWaU624R4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(6133799003)(261009223027099003)(11063799006)(4143699003)(56012099006)(261028144727099003)(261102123227099003)(261026140227099003)(261022105027099003)(261022075727099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vml5S0NHUm1wY2hKUjhMNHRzbENVcy9GQ05JVWkvR0VUNFZlaTZrUU4wNEx6?=
 =?utf-8?B?SkxHL24wRFg5L0xLQnlSb0lCVk1aWng3UnhSVlNFM3F6MThHU09aM1hyN1Jz?=
 =?utf-8?B?UW5lUUJESW11eHpONEV6cUxZaUZiTUMvLzBqZ3gwTVU2R1BTaWw1RFlQcCtw?=
 =?utf-8?B?Wnlablg2YmVuQ0xyNWFwVmV0clBPMXEyV213S01yc0JNUUVTMGI2b2tJNm9z?=
 =?utf-8?B?a2pRRDNXWVI3ZWdsVEhGTG5xTk1GaEY2RG9Ra0RiWk5ZZlRpRkhnQWFXRWRs?=
 =?utf-8?B?bTRkdWptYm5MM0hwRmhPL2lxRDZRS1RxckJEWGlWREZMZldrbVZDUHVlYlc5?=
 =?utf-8?B?NSt4UGZKbXZ0cDlOZnhCZ2x4MWtsN1VhcU1wZjNVcHNlL0w2L0xSbnE1ekcw?=
 =?utf-8?B?TERLTUU2UEVJKzF0T1VxRkJpYm9OaEtEcW5UZk1WbERmRVNHZmJqUEFlR1dp?=
 =?utf-8?B?cDk4aVhKZzF4bCtXdWxGRGg4T2RPMDJCVVptbU5pZFZROXJWelJqOHArdjFL?=
 =?utf-8?B?MWcwTVVzLzBEYk82NEVXN0FpeEtyUlFiUkh3YkY3TW0raEs0enFpZG1IMmhT?=
 =?utf-8?B?djZ2aUxDbkN3a2NSTXJXT3NWR2FYZHBwKytyN1pzSVJ2Q0FocG16aU12Z0FF?=
 =?utf-8?B?bVVYRGNrOVlSRFBnRzhnRW9RMzNvK0F2bUs2L1Q5SnBsNTlmMU9hM2VwQjlQ?=
 =?utf-8?B?YjhzcDIzT1NkN0RzeTZPRndFemlxK0xVUWJqamVJTDhPa09PNTBUSHNrd2Zy?=
 =?utf-8?B?TG5SNGxlUGxqUU0zVmhlT09TYllxRkMxZ3d4RW1ueGk1VG5aQ3pJNHFBSDAr?=
 =?utf-8?B?enU2aFJzaGNiV1pMT2RKV1g4ZzhpUzFOdFZWNFB0RmlxS01DbVBLNkhhdGJU?=
 =?utf-8?B?N2FXQ210TGdQVk1MYnpWYmZDVHdnejFsSHNhQ2YrbXV1UlpzcDBBWDB1MWlU?=
 =?utf-8?B?b3BkRkF0WVhWNUF4bW9naDV2Z1lpUTJueHpYbGNYMzBvSklBNUtmQS94RFVh?=
 =?utf-8?B?Q3htUWRKMlRhWlk4S0xmQ0FqVm5udlZYOURYZW1aOHBqV3lVb01SY1RWQURW?=
 =?utf-8?B?bEdGOENiRG5jWUpFajNPZC9lL2hNL21SVURNL2JIV3MvcXl4cERHU29TbWZw?=
 =?utf-8?B?Z2VVcVdWeEdEQUlSNWFZOTZtRVExazJlRzF5U2JGNTdnaUNEUnJ4cWtRWjJh?=
 =?utf-8?B?YzBXUlNmU2YrdmExelhycHRiMHFUcU00VHRQdTQ5RDFLa1RJK0pDSnJhVzRJ?=
 =?utf-8?B?ZThVS0tpeW5hVEZ5alpLdzBkbU5XL0l3YWtCVWlxZjZHQktyanQ2S1JpdHk4?=
 =?utf-8?B?NVpkZ0EyRmlqZ2dMVU9EU3cxOW1rdGRLTXpqU0ZBeHBPOWtYMGhCbGhzQThn?=
 =?utf-8?B?QjVROFY2cUVwSzJDeHoxWG1BL01NWU15ZUI3YW5GU3lhS3VFSU44Z0k1c2Ra?=
 =?utf-8?B?TWtEbnZBTEpyTVE3VUJEbzJ5U2FzZXV6aGgvYUE2ek5yZS9ydHphU2FuK01E?=
 =?utf-8?B?d09kSVFyekZPUHNBZW9iWVEwZVpqQ1VXcTZaNExHU0lONldrZCtvUkJNZ2hv?=
 =?utf-8?B?UlNSWVpUa2QzcG5ER1JOVXdnK2diUE5OaS9jcEl4T3hTcThnMXVjZU1NTHBl?=
 =?utf-8?B?d1MxZTJXa09BMi83bVR5eklscWN6Qm9BTnU0Z1M4amZXYUEzeW16eU93Z2JL?=
 =?utf-8?B?VTRQNmFYNldsY1FsQnZqY2k4RGtrckpNNDNOeGdyNCtQaUpkNU5tQjVkbGgv?=
 =?utf-8?B?dlVyaXRxU3dyZnhmWlZ5UlcwOFI0ZTdPL1lyR3ZvMjQyeVBUQVhuWDdRQzNr?=
 =?utf-8?B?UWlrREU3WElaM0UwSDhFeERGazJRdFFldHU0aHVTMXdId2lKb1R2YXVRSHk2?=
 =?utf-8?B?NVF2MEVNT1F5bkd3ZElnSWNBVjArc2U4Zks1ajZGSm5lMUhodVlnaFpKUDBH?=
 =?utf-8?B?U3pMMDhSc3BGOGdxTGFxTnVFYVRDVFYxL20zOVJ1VnFXMnUzekdyMlpVY0Zu?=
 =?utf-8?B?TTN1NTA5VHB3Qzh4U0RQRG9CNTdoQ1ZTVDd6TFVMc1hpdUNqZ2dhNnBkSHc3?=
 =?utf-8?B?YkxxSmQ1NE0vc2dnanBUWm9ZdTVGTzJ0ejcrVitEaytEYjVhcjd0dVFzR0Rx?=
 =?utf-8?B?MGVWcWVlelkrUktiNzZKT1UyczNIOWhGeHVpdXZhaUltYWJOTDVheDBZUkxO?=
 =?utf-8?B?R2EwSFd0N0k2SlRzMEhPYmNCdEZwMm5FYzVkbURkQk56WVh6djV0eE14anZn?=
 =?utf-8?B?amJwUm1TZGpTdWpHalRMV3R5MUtjR2RpVXdkc0tjRTZFZlZHTi9Cdmdva09u?=
 =?utf-8?Q?TZ0zAvc6W0MxYl0l2g?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 897e503a-401e-485b-8c14-08df4412be6f
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 18:52:20.5911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8SqOPO7SFeBg1lzx9zZcIyFYuuyzhgCB/DpQzPJ1I0lOK7Bgr51dHkMzn0iLeDqQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9062

On Mon, 16 Nov 2026 15:26:34 +0100, Ard Biesheuvel <ardb+git@google.com> wrote:
> This reverts commit 8b3a149db461d3286d1e211112de3b44ccaeaf71.
> 
> That commit added logic to probe the EFI framebuffer earlycon again after
> the EFI configuration tables have been parsed, as the primary display
> information may not have been available yet when the earlycon= early
> parameter was processed.
> 
> [...]

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
