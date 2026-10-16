Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010051.outbound.protection.outlook.com [52.101.85.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FBE4F85B7;
	Fri, 16 Oct 2026 16:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792169656; cv=fail; b=armz2SVfzT7+thWUtAXxPgPEOX2jXYx8O9MI2/ihMZj16u1RBlNbpRF7eBEADQ7jDcvM6xkWlOYTwt8H9FfJdVN8DvZouzUepqEsq8h+Gtda/eeiflTvIsrGAT7MUSw2m0suKSkoptLo893ku4tPIYtlmpfWLlOSPRauXuvEKao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792169656; c=relaxed/simple;
	bh=MUwdEgIyK9UwUuge7riCvmrgZFjRt2Kr/z41tCBB+y4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GmD+n8GGpeovaOKwZ89H5sx4g5rWg3A4kZPsWj5hJ43uQrvSZExF218TYNfEKILYGMiNNETgCJrO1GKYmXhG+N6235WHOMbct7AwcKBu5dVMDcmVsIMXUK9m5Gexmyq6FrsA3c0/FLxb3xshdgHiMQ0QqmDmx4opfjtbD17Ngbs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hpIC53TB; arc=fail smtp.client-ip=52.101.85.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hpIC53TB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wt0WQzP+cDQABQM4Kn4ut3QLMDntSP0WAzUsZUtQ6nScJ7SjVejlP94jglp3XOniYxoQik1ORKyA4l6WbmYWOHsAGH7HmhZLP5baO33qgbknlwdhW6oPIy0KWYUqziWls6vGMKoyKoYbRCDuSV+kWk2oUOzHYPW247E5mG+wkudlug0XUqdIJ0JalxfjDEBwJZWnTCIIejffaFWjr965uaUMksr6Z3naYzFLYjWj1omR4iHify2++qTR4B4lss0m8rOZSppR8m/NaU+GAIHZLuOgjx4ZfxN1BKVXIOXLWSlI9aADN1Ws1EDUTGc2AIRZo2oPbwD21kpmZVlchqM3cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q+idNlqcAGbMoo3CQDK4SQZ7yrzN7w+FLH/16+j578k=;
 b=BSNkhceOzZPadk9V4ftGrAeYkvMtRI7sIVnESnIJdc/ZL778w/4P3voz2erjMMepFlb6fpdJIQGveAsmSZ2LGs3DWbz+7vqd9gjrU3nf0dAw21xZe8r9mnUJ4TcioXe+uxSszUduAp99te6XveMSg9tamvMDEHejppbzT7aU9V/dsJFDiVBT7fy2JS4sRXyEElcnZZExFHClvkzgMU630c0Q1WrSEtBDJ6l0w+Zre8GE7cIKT5k1xxLkjy3takeSjgJgRIZuSUshYb/G8tt9mSgRiYZRdJD9WBwp+i5bNVZwjovUyEqojTbUw+TTXQM+QaWjIdAG+v7ksBKoELslGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q+idNlqcAGbMoo3CQDK4SQZ7yrzN7w+FLH/16+j578k=;
 b=hpIC53TBADFZkxW/Whg28yqcNEvN4CFz8nImTgGVst0tZRLTcpnzqH4bxwC93qZbKK8CKx6THDD/SIIiLI93Eq+NebGsHiNYQCRtMavpjtysp8IFA0PppLVSTLH8nNvT1dFYe3QL9eBhNJvdJclJepchy5n7NHAlnbmwwTPaTDLDJMJwTyMC7cvHMy7FuoMdTqndnhHSD8AzF9C6r7pT8Bmlj/om/ZPMgOfhs+mE+un42A2A7TycR6N6acwYupfK+elNfqc9wCxq4980dmrMyFIPewlxTFKMyrwtY4aGl1MRl+rIczAexLW2bFFu6Awa1Kgn0aftfoq1ZfJt3fM8AQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CH2PR12MB4165.namprd12.prod.outlook.com
 (2603:10b6:610:a4::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Fri, 16 Oct
 2026 16:54:04 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 16:54:04 +0000
Date: Fri, 16 Oct 2026 13:54:03 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
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
	Nick Terrell <terrelln@fb.com>, Will Deacon <will@kernel.org>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	linux-integrity@vger.kernel.org,
	Palmer Dabbelt <palmer@rivosinc.com>, patches@lists.linux.dev,
	Piotr =?utf-8?B?S3LDs2w=?= <piotr.krol@3mdeb.com>,
	Ross Philipson <ross.philipson@gmail.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Song Shuai <songshuaishuai@tinylab.org>
Subject: Re: [PATCH v2 15/15] efi/arm64: Implement ARM64 DRTM in the stub
Message-ID: <20261016165403.GA503225@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
 <15-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
X-ClientProxiedBy: BLAP220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::26) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CH2PR12MB4165:EE_
X-MS-Office365-Filtering-Correlation-Id: bf5ec9ae-d639-4d45-6986-08df2ba615ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|921020|56012099006|11063799006|4143699003|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	vyI8zSyIm4k8XZhp7n4MVPqQQBU/Ch2U2xf/qt8bc6dlvGIyTIdDlezVdJUZdZyPX72znxM/K/CCuKvhEsUbQpDliv4WXkBTm4/8CTmseZlChZnoo0nmZXcvbSqIfkLZzmGR2UleJn7mUzd4rOJ936YkQXbuyFiUjgoz0x9Dsyo2N+ab2nzfDnsVIcbMVaBoanqkYkYoOAROO1nJMk4ndvERxehA7ELPhsw9oB5KlL1MYGXvCZXRlYne7D7wTPoxrp4hjfXxP8a3Oq/rIlMq9i9P139ZhfWf+CW2aioZayVqXdkXSqpSC5luDDBaFlSmv8nsVKWTrJdBO1CJo+BI/t2/VDqzZwyevMaLkPjpvGRsMXyWn7kuuRpYr7lu2LcWK8fE+m6kpZslk2oHrgdNhKB6HRSzNIQWyYAzoOKV8aVpQh1eP0UiQpAvq5ZeKdU4Cw4KwD0/jSUGKx8G5njDGTlLx4gChMFBoqbbvkXwRbkbWPmS2xgEw1O0iZ1Xd3+6oYpprSfyK9cmFeoONywapvKWBZqos2KeRNK0XAAoKRJ6wuhQZO/F4yUhLPfBCMOqR6dTBmO0vLWWWJlwpfdBzP+BQDy0CyGXQqRwfpyVZ42gjyI4S+iqjC+ypkt06wmqUCsne2wzCzTzWsFufJVil07IyY3GqNqmQnpSFYj+/XW6MEFjdXXlmBsRFSwX9vdUMAubhJu7vhsuzY4be6cl7g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(921020)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Sl8cWOobVfWulWC5LserYRmzRpgwGZrgoFWMDrFAMVxLzC36I4A03l6sfuri?=
 =?us-ascii?Q?r+i56ozJlLsilcb0I4llCpfUDE4B6vuLbISa4e1vfSaFm1mCeXTSkXpI1o4l?=
 =?us-ascii?Q?GV7D5NtL+sEXXV2zsVSIsRgXVfzG49FwDSwC5kbXpoKQTVp5rXQHTCRgQSy6?=
 =?us-ascii?Q?lOun31crKdy1I5S/TpxGcArXFabtfTh9e2beC2n7x/8XHdWgMxjbtPHD5dte?=
 =?us-ascii?Q?Zo+2UwLlwHRq0b0T+4w9I/fFqj9ctwFERkXn2fk/yZ7EV4r430BXH49RFdIi?=
 =?us-ascii?Q?AHRPyBmKwx+8Rgn8jqXXiMdCN9o5psPYionf40J3h06ViKfpb65gwUrXOGKz?=
 =?us-ascii?Q?7zUHF65/5D1956GzAQVXfpYZ+kiYIdDpoGhP9gdg7I/qLlyVxKKk1ETdJH+5?=
 =?us-ascii?Q?9nHJDgeGUpoOaBIng8F8jnOnA6gmeN3XNMMI3/+316L5ifP0W5OueI27AmHu?=
 =?us-ascii?Q?PjqavIt7eGXSzgFt3FvXR8vM/Iwgp0WitWXwO2glC+cvzWcc5GXhKrLgV9gH?=
 =?us-ascii?Q?yxKJYnAWOIhfqWFsbYmA1qM4CDVGHNQuEILsl/W0UeveRMsqPEoAJfQTnTpi?=
 =?us-ascii?Q?9+dLYrWK4vZOhhC5jI6zNda1SAA8Lq6BhOUPe97Hw5antUkcz7s3qArlAXBW?=
 =?us-ascii?Q?gCAXnyBICrs2I+IceefwZM7krnB6ua20ZjpXi/p6pIgmXmdhEDrPz/T8TbDC?=
 =?us-ascii?Q?WhhkaTaoVHxv1gPth3rIbezpPvMO8fVt2UkgJYtYnLE0Ra81PJhrUJRWjRiY?=
 =?us-ascii?Q?fS7izEXjl283SIRsNpsEnn7yEmDXjvXhwey3g8qhZ3mHZ1ahTcL+tSxwcLx8?=
 =?us-ascii?Q?hREPKvsaUyqZrAlpMMYAUu+AkoNhJ38k1aWsS4t5t5U9sdJ9LlJEPKBT279O?=
 =?us-ascii?Q?75j1u0FqOv4r+z1q/pYwqwFHla8YaLm4wS6OEDzIdKSfSLdBpZp+fK43+M2U?=
 =?us-ascii?Q?9AN2CxnXQ9kDmX8QCKqO4cucD0bEYDdwrgOJArhXsaK4+l5EQbFooEPQSo8w?=
 =?us-ascii?Q?4tjAMXHTYYIkI6cEf2rhCxLD0r2cxpXBHptuKNPbuKTHLMRpGKxQB2MlBK3P?=
 =?us-ascii?Q?nX4AWNe6n8S1wpuXPAfM7rSm7IE8xt4a65s2mJVYIhF2JlVALB5hyrQQ/eFq?=
 =?us-ascii?Q?maT3wTIOseDrkOT7c5o0ubcUjW5bkbm/IKhvt8VS+HbgKswEUiyGV66RoXAb?=
 =?us-ascii?Q?E4Fh9ETYHgrpVJeaO8levKj5xwmwNvDDLrRvsHUrDwGQg3HF09a43eNZT82k?=
 =?us-ascii?Q?A4K35xvYiCYkuFXBjFo49tu7D4h6ZcCuuH4Sb8OpLexB0B+sqHAWdd9+dll6?=
 =?us-ascii?Q?gRjm4phpIPyaaKUkU5ol7nSfN7S4Z8eGRfeh3QB6P/dZxq8PvDqzMOUYjBj0?=
 =?us-ascii?Q?t4No/BYD1nvrMgbE7PteedWMsmos9wyHc28Cx9ef/gUS3wd3ZDujWUyzGTtH?=
 =?us-ascii?Q?DUacqnZwBNXn/aZQaS8SUVzPiTbafPRU/xlGLHUpT8lwxp27yZjMJduMEJi7?=
 =?us-ascii?Q?2K3vd2kUSWOJzyknbpkbCGDt4F+c4x9TPZAAwr+djWEkgO7GtSXiXN5L4mGw?=
 =?us-ascii?Q?qhEXAp0xO/B/phraAiRzjp6pv4UWKA+B0wCBCyQgfK583tgcb1ka90/1JXdh?=
 =?us-ascii?Q?gBO1+2c+CpScH0mmkoxc+gHMOcJc9CqVeDKCFO1x4AHC07YNCvTEpMgHSVRv?=
 =?us-ascii?Q?L49Oqt6mrV1hWFaRalVRgUqAh10j7VXlKrCPRmkuUSlV+GwK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf5ec9ae-d639-4d45-6986-08df2ba615ff
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 16:54:04.4535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LtOCklqy5zPgujMF+vKP1en6w9/UtYIJWSsiOToDhNNXJ6blRA5yKPjHpqRyAB7i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4165

On Fri, Oct 02, 2026 at 08:31:52PM -0300, Jason Gunthorpe wrote:
> +efi_status_t efi_drtm_prepare_launch(unsigned long image_base,
> +				     unsigned long fdt_addr)
> +{
> +	const struct arm64_image_header *header = (const void *)image_base;
> +	const struct efi_image_info *info = efi_get_image_info(image_base);
> +	struct arm64_drtm_handoff *handoff =
> +		efi_get_image_symbol(image_base, arm64_drtm_handoff);
> +	struct arm_drtm_parameters *params;
> +	unsigned long measured_offset;
> +	unsigned long measured_size;
> +	unsigned long image_size;
> +	unsigned long dlme_start;
> +	unsigned long dlme_end;
> +	unsigned long dce_end;
> +	unsigned long entry;
> +
> +	if (efi_drtm_policy == EFI_DRTM_OFF)
> +		return EFI_SUCCESS;
> +
> +	image_size = le64_to_cpu(header->image_size);

We've been able to do some testing with UKIs now and this line doesn't
work with systemd's PE loader, it discards the PE headers. The stub
already has a comment about this:

	/*
	 * When built as part of the kernel, the EFI stub cannot branch to the
	 * kernel proper via the image header, as the PE/COFF header is
	 * strictly not part of the in-memory presentation of the image, only
	 * of the file representation. So instead, we need to jump to the
	 * actual entrypoint in the .text region of the image.
	 */

I will fix this by passing the image_size through the efi_image_info
instead.

Jason
