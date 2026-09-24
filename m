Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013010.outbound.protection.outlook.com [40.93.201.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462293AA9D8;
	Thu, 24 Sep 2026 23:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790293840; cv=fail; b=TSxmyeGI9+Fu0AG4gmDrfy4ofJvcpTySzTVNngJ09J8bqfBdYVcspR2ynFSS5ATSL7IS4zHV94z3vf5LdfrIqupE/LGpKhtGXeo1pEjF0NzfU9Pp+emDz/59WLP/PrNTzFjLs1jqDxnH84l3PonlDYqH89B4Nze2zgZRWYygOqs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790293840; c=relaxed/simple;
	bh=wGWRI8mnJuTIBhWxrxuZqfq9Sgz069mjh6Ajgh+Pj2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NL3oZB6g77tJAs9KrqZRA5A6aLVmPeTCECCzH5oecp4psaHKfLMUj9e2cxSICtwG06Uf2+U9VZrXsn25ADLKIgYC8vP3iYB/xycRR2ZI1lXnM8cBbWFwFusFx/SdgfXUendrOrr3AZYz4nqbIbysWoxDqqBtdSpyZZ0u4arm60A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Xp1gduMp; arc=fail smtp.client-ip=40.93.201.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Xp1gduMp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AxrYc65V9LTyErM+TWOZqENHPPTfYSiqojZ9hsgCd8OmBWMh2elKhEh7Dh/200R7Uijg+WZBMykGW4XmFrdait+8NFzvOUmhOrQN4qEiCX0XiSeFjVdy02yRXgywvh90A0s5ZIMBPm64wzKIJkVLSFzkIjlFzsJZ2Ta5xydGoyvC69ptbCw65vV5/SOqkI4wvyRJ/Yw/vuYuut1awBca/qAemn6UcYNspgpq3f1dDulp0Xc1JeH/MgzJenkxAkAgfXKOgXyZ1Z7MZmlA7ojzgH4EilQGPHYRvV6EQiDzxeySx2yQZgkPsrk3clnBNXUiXQYHAPgZYztr9RSAfLec8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=igCmBKFXcMeRrcriicqHdsaxMmYYqq5vn4VTeG7fPdY=;
 b=K0TnoB88qE3vYXFA52qo7HwnwAtAUVyPvrFc1tejdy1EHyUzmRhGCMsv6G36umBTKzThoSplMv219I47Amgkrl2Iw/40mxwz1s/9/IZpq2taJ5J8vNZ59RXdcds4DFb8Nn5o5H0zJqB5dI59JAI1s/Ab8u20fGJq5CBkozIsHx+cxldFhbbq+uTjyC5FdNgzQAGSJqu1CsiUUoLMBIVAztsYcq453mJd/eMAGcJs43Ld30sD/xHY0e6pJy0FkZfZFyRy6iYX1KSvqTMNGgR96wdmvM0lTmXZzLrQwpii9TbrJWHGglwxgBKWjLVWWb+ifHQc9YwMAf3Ofl3C3S3qyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=igCmBKFXcMeRrcriicqHdsaxMmYYqq5vn4VTeG7fPdY=;
 b=Xp1gduMpaV1GqynEEkNLiSVBQzf/tLy6FeF5ttzyooakTrA+50hl2jkNER76PaSknRHSGlOs/q3nIqGPUmS7lfcOEOn23nS2vVyMtxPJrNh3wpgbkpy55VIaWw28L/ycnPa05PD3GhwOE3M0CR6JqiVcWM2UKLRenXw8DbBK64Y3VTzwB5p/HPu7LyTLa7xj6lKhDKYHtaJlLEwPbkldxxYIdBsbgieXTweqYbA9/PGHf8RcwDVIAti2kl+DIa/rkxJNvU5C8Eh03PTjwkc1lJ2xn1X6eswwd6+lag3M5Hn+pOwJWnyxTqEdSLFpqiLn1fn52nMxUwlE7Fr1f9Bfkg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SJ0PR12MB7473.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 23:50:33 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 23:50:32 +0000
Date: Thu, 24 Sep 2026 20:50:31 -0300
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
	Ross Philipson <ross.philipson@gmail.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Song Shuai <songshuaishuai@tinylab.org>
Subject: Re: [PATCH 04/16] vmlinux.lds: Move DATA_LE32() from arm64 to the
 common linker script
Message-ID: <20260924235031.GE9354@nvidia.com>
References: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
 <4-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
 <20260924155307.00007dfc@oss.qualcomm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924155307.00007dfc@oss.qualcomm.com>
X-ClientProxiedBy: SJ0PR13CA0208.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::33) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|SJ0PR12MB7473:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e3bf982-c03e-4575-e933-08df1a969f30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|10067099003|56012099006|3023799007|18002099003|22082099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	hjVWnfEj6ieBCIowbGX+3xs3OUdp6SRFG0KhdRRCtwHMcwC44dAH/NIrJF1KVh1ed88UbnWG0gCyMG8iU6eOirh0VMoxojjWU2i5OyBT0nJEnXbUkssZTNuTzCA7zoNni092bPtFBhLbx79ihd6PyMICixD1E5kxm4wfFGQQXyTUQQ5wHLWfn2FbdUqkkvHApd8DwYXThL7V8eoCiHv2nqjss0d03tWcCZkG9VP+qfsFTqsxmGycmikLneuw67h6AaE6RaUj5Zv0xk3kcz0IBXlQwhKZ4LcTpTdj3MsAK/44U/ONmPQFMm435hDv6ztbb2NHweHKUeTh5mtYKMeOwZswVw/Z7CT3gGEIeWJEbPtsudMTJIaZmj3ejbBFXETDRD7nS60lo3waL1Dnqixbue096XE7ArisxePKd+u1CoVfsuKxH2Uf1vhHkjjrUPae/c1zbtE371Uzih2BE89R/EiMOchjc9u+rIAywnOvshWEF1jlVE0lLiLLMINj5e+AcCg3VmAWTpIvzGcMaRoZfc8UdBWqZsxLvrYyxSjOBYU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(10067099003)(56012099006)(3023799007)(18002099003)(22082099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5n+2wF2ZX76bHDWNjVmvkE7WsM8eA6T77Yz+D9q9di82ATZpr1KzOs25cXNR?=
 =?us-ascii?Q?Xm1LFq1Oi5y4UJgumBTikwwl8hRQRpneUXIbXAMfCyTv5hdxm/QgW2TYCAo6?=
 =?us-ascii?Q?wiyCCCTwF2HWEbN2yQwbhccHPZDS2msMj73jb3WEn7EVxnqqiSYyvtJG+fjb?=
 =?us-ascii?Q?oesDq+42objWVIH28g9WBBFrzUILMUTmPJIXK0xofvWj404aQdrGLwdioIGx?=
 =?us-ascii?Q?EosHtss0L6/rP/6GRoDlC0KdOUMGckHGqKqk6chnvHZJtDrZkLKdinkoYtkt?=
 =?us-ascii?Q?mZOF0FfhAd0y/pxKS2xBBZc4tRknMDyzrRUFYBYo6DnsT+w62HnIXA/Pw0pG?=
 =?us-ascii?Q?ZAbOlaOFOSQffMlPrAdFHye6yqAIY6iYO83DKvZucnoeiIA6Fn8Ud/DyaBJN?=
 =?us-ascii?Q?PuhT4U08VjquW8IEe6AvvJMwT3xWgQOiL7uu07I8MG15usgImy/46oOHPtAO?=
 =?us-ascii?Q?L11wPftHR3QzpH9Sxp46MCdFpN6ZRxGH1OAbGX7tOFCISa6D7Vi6vnfS5i5o?=
 =?us-ascii?Q?JdsSEfcvMneUP9t8pjJa+tGn3BLhbhwo3g1Al9YxMXem2fDjZ18zXaBE2GNH?=
 =?us-ascii?Q?v/jVUJXBikVGgsnPDRMn6x9IYZ00FjPHWjY77AhtR3acSDzar9//amul7jLE?=
 =?us-ascii?Q?ynqYRAQvTv538To3vW/Bva5X4N5/7Lbak8DYq+QdeFdl7HHQ2HaBz9W2Am96?=
 =?us-ascii?Q?5C2rEL300aZ0OSC3Mkm5LgfFvIGW8HldB18Av3mlWwQBrIU295sRV/PJyk8y?=
 =?us-ascii?Q?gpqdRDO2Nqahunv0J53bvZThmERWVD0fRw58quOZxMe/u3yQPpqn9blNksJm?=
 =?us-ascii?Q?xO/kWKDRUK+2oee5lyE+kej5bB5rCWQb6PKrILZKOgfKQNd3CzKDyuApnlBj?=
 =?us-ascii?Q?DGWJjbjWv8/75JuH3B/Vo/FtBcypWBdmbWWw8hiFZXWS6trG+f6kVF/OxtsO?=
 =?us-ascii?Q?2H68sKKeNsMmNR7d9plONdor/vIpgncpBDWLpkBgUGEWTmGSQgzaRqb5hnGT?=
 =?us-ascii?Q?tR+qMcNkpNS4LjRrMRhOS7lPn7IS0bsCzdS00bQk2LoYM0mcPUKwCt9GkEvb?=
 =?us-ascii?Q?KoI0YBiSut0gp03qyr2LWtTELLCDV4K3U1JoNWVjvoEZgcKA2XPEy/NvLS/6?=
 =?us-ascii?Q?6Ks2C5ZCeThO8K+SPggiy6qj1RpJUrJiX79Kcrj2zHFJyxVp/vBO8YPZtiWZ?=
 =?us-ascii?Q?WISMOFPn8yclXeIYjM67EOkLBGQmqS+795VDyatP+whZB9Iex8KWCTqVzXaG?=
 =?us-ascii?Q?trYL8k2OnarcyZP0UqRbDxvv5oHjiKLKoT20N4lpUZ/Z/BUoIJ5qOWHe5KyQ?=
 =?us-ascii?Q?F+5qO3CrCWAn+7jT2Bf4Q4pzCynRB6OvF3406TNJR6sLvgRifT9sCYt1Mh6I?=
 =?us-ascii?Q?XlOshvqgg92uzFp7gavkIYP021TwWAyp26/dvOVw0Gc6Dao9OKGokZ/KvjQG?=
 =?us-ascii?Q?zipBVFuONHQLV3TAEJl0fakNVEgNmdXzv8SF4TQm8TJqrbV2n9a0STiRZGSz?=
 =?us-ascii?Q?1+qQ+OnHEcE4CcUug6/9+dGv+vOnRXE2lVSNZ+6PcjrPum+7ximeyFG2EBJG?=
 =?us-ascii?Q?45OXbuBsDk4Br/LtXKBOuOLVOwVe9XnJr+cc15k28kY0y3e6CzHSvBa0o0kj?=
 =?us-ascii?Q?vlZnvaS0Z4+rbAhMmyk8qpIR3QzhYNvp6YZJ15JKLvWeGGz7nVuD8TYI9SMC?=
 =?us-ascii?Q?8vXnYN5JWqLTSjkoPTWwUlmirRdEdn8k3c/bGp8QJKBNw9M9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e3bf982-c03e-4575-e933-08df1a969f30
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 23:50:32.8864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1K5TlSQpaiMUQQCDQWnS5raH7+dyXn/Pzy4YYDz0x4H2hywZXUhHmRGNNwzswPCp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7473

On Thu, Sep 24, 2026 at 03:53:07PM -0700, Jonathan Cameron wrote:
> On Thu, 24 Sep 2026 10:53:07 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > Other arches may want to use this to get consistent fixed endian output.
> 
> You will have to grab it quickly!
> https://lore.kernel.org/all/20260918145217.1669-10-will@kernel.org/#Z31arch:arm64:kernel:image.h
> drops that definition as part of ripping out arm64 big endian support.

Ah, well easy conflict resolution then :)

When I was doing this I was really doubting why it had to be endian
specific, this is mostly a cargo cult from the other stuff that was
already working that way..

I'm personally skeptical any arch could have either EFI stub a
different endianess than the vmlinux, it seems like nonsense on alot
of levels.

So, I will remove the fixed endian pieces from here? Does anyone think
otherwise?

Thanks,
Jason
