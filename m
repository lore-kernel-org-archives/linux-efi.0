Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.34
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794582636;
	b=SyT3c27iO/cJAAdt1L6UEiy3RePUrKj6yQjeaOWOXiirEHLeeNzAwMA9m8v0EcnBTCGr
	 3oi8tnKvkFQ45eCR6pLaJ354CnQB0uU8tYIx8fXvgMH3fL/u4G2VS7NTX0acaWNUA6BFN
	 4zrvm5gPthsuNdWIlF+R9ohsqbdn6B4ZQMI0uXqX36id+6Rns6LDGUa8RmwyCLwCs+dlO
	 CJ46mszaHKB2zgZu+s3+j6rmR3PARIt9GiAFYmQQChBUAr3f7tOsJaVqLrfPfidoO71yL
	 10AzHKna0BBV0CtNtkJmDfY3pVdu/tkoHklBCb86XqNZnyZh5rq0yd7CQoucvXIXskQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794582636;
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
	bh=k6x0VuUO0GYkxDaYcjvmAuGzdvUMZ0O8Cyp9uzcwxKY=;
	b=l2xAPf4Dm5C3t5ecfEcf9pHR4x0vb5eqvOPyk/yDQ1rH3p7Q7grOkpCTO7oziXSrDH/m
	 5Q29vn8kZw32M/kA6/lUzEaEnt/WiwwCK+dBMeo6YLNw0M287Ciw/r7eGIE427xgf5FzG
	 O618/MgRF9L6XdXBA/X2ZrmdQgZgCKj1DAKWyfTDABGnWryqd3coNFBQHNhlT5rX/0lfv
	 30cNwMgNveoaOHiuX/wZMfLG4/kk6X3AGyRFNt+UUe2NpcCGZldTq7S19j1+a/dhYuwuc
	 RMPqoIdJVXpd8hU1VhjgQEtPbRLAcZg4nrDi/RQSDfKnCYrnNMvFachTmvHw59DzoiQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WMs3Cyj6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.34
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010034.outbound.protection.outlook.com [52.101.56.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D740A606A333
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 15:10:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D740A606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WMs3Cyj6
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qeiFExsnHvWQeOLTwl1yONqTD+gRKI+oO3dDFM/TPHvYOiD0Yh1suennGeynZUnF5yemofLy7FkITfDaXxXk9uULzsvMf5uCW03ZzDnLQrKCSqW8JjAdUFTX49vT7g7Mwzp3uJGnp1GKXBq3GPhmpyOgsTCWnSr5bIfU55Bjct4jNl8EhsMqBACvY2sVxC8GlHomYSMKNUVhXUjwSAOc9FyOpv9E1Bg+fYDuc5tmOaq+EYmi+o5s82ZEmMn+wMZsTozPRdqdpmHctTK/YhVVrlcIFp7sjtEZANGgsoF3xaqLFsuotVVdZXZDOCIXflbqCthIXA57WgYpySbm4bcBqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k6x0VuUO0GYkxDaYcjvmAuGzdvUMZ0O8Cyp9uzcwxKY=;
 b=XXypcempK/coKxuAO7DMfG3j6xp5kP4OQrLltXOOtngcbjbtZOkdsmPQNLwHckkAgYqc+GoKeFTu3ERLqsW8D9ophh2asFXklI1kDO3he7CzbVP6kAQ6sVnAu3NqAm2F42aY7I1xY8BuBjN685JPjzbw4dQHxTjYKG5NCCSOHFwPty554DZ2AM3cU6+8nvCp3Ze2Gn9cwWqI1/dTDnRrEmfAgH2pJEz90+YUvxvk1l/x21mUI3wohYj1aI+ftcBFb1UzLAht3vkWzzTAEJKbRVa59BivdHRSHNuU+xaPuoyit+z+FSiKrVOkU9tHyoy5eXC1tzq0UUFVyW7voWeOZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k6x0VuUO0GYkxDaYcjvmAuGzdvUMZ0O8Cyp9uzcwxKY=;
 b=WMs3Cyj6bH2WlpwMvKqr8RxjuU63y+Rq/DBmqn1OwWFDerB4ELGnwSY2yZfVNmwAuw5LprY7g+SnOafZoINCdCFSL8I4Q1vPoh1n7KTrv64aMh+rBoNv6Dk02HHyve/Te0DvtiyCTK09hj5ZurS+FoxiXMbQV9UO1LENjTr1KpmuGD7XPk3hvL+4W1j9IwDiqIL7BSNqK0/yHEk/Cn9sV9NTb38iZmXEOVgG6f5GWrxpWHS7hftKLk3Uq3gUsWR/EiMH2D06o0l5wy8eQL+AMMzmuOxkRKwDajvhkQCuVAfeZE6qI+GtE1f/Wo+JaLkaViST2yTdEdf4Jeox83JCrg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV3PR12MB9332.namprd12.prod.outlook.com
 (2603:10b6:408:20f::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Fri, 13 Nov
 2026 15:10:25 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.009; Fri, 13 Nov 2026
 15:10:25 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 02/10] efi/riscv: Rename __init_text_end to
 __inittext_end like other archs
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, 
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
In-Reply-To: <20261110121731.2728824-14-ardb+git@google.com>
References: <20261110121731.2728824-12-ardb+git@google.com>
 <20261110121731.2728824-14-ardb+git@google.com>
Date: Fri, 13 Nov 2026 11:10:21 -0400
Message-Id: <179458262193.3625095.9553451202764579940.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: YT4PR01CA0272.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::24) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV3PR12MB9332:EE_
X-MS-Office365-Filtering-Correlation-Id: 794e9d13-b4e9-4366-fb31-08df41983ec9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|11063799006|4143699003|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	FSL0JcNHzpdVjUnKoY1PC718lHe+8Zusg4mT4vMXmPDSjxJ71frWl1JG6eSVGtk3YNKpfcWuZQ5rCWhwwkSBklgFj9/SYBo0xovY+uMusv/6nQvfsgubnh/GyNB0XD0wQA69O5RjQoR0tD+idFS2nHGF8I8ADCamzLt5rPuXOX9blygKldkXD74HpQTeJDJNJ0x+eG5CohdJfsgPfu50Il3740FQKmDWQ6zX2oU6VbC71x/i7UfTxbRNcMZlaWjiQN8sm7bZ+GjM1oa8rGvk2QtMo3PvsudDQmohOKDb3tQxqOmKlxYujK3cr51Qz5fuQ3kztRkJpUnxcvlETT+/s/k5zyAGLKjq70O01rpA1Jm5ZYzHjJTbroJPNmK+Gq+C994sf37pW6/Rv2TKJRkoON2S0HaHjmX+HOfROCA0kUWw5Ytkl/Crbp31B3wJHYLWyEJjUH8Oso0ibgK80jvUd2PDiYHINaeZwYo0NOboQeLR7iC++trci5dm2At+i2YgB/rOdLXe36ibtvdrmcwgfu/qz97/0I4Xd07CR5/c7e7r22EGCHvsOzWx9jmheWxKz0auFVaNuEnsl7/xIbe/Uxexy/VJc2FkN0IVweibHCbC6rIwU9qq9bvtZ5a/2ZSr46R/12IhuZDQrTqrwVoNpK9DPdp5Ef+A5s1WZDkpRiw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MVBqNnMyQ1VYNTEvS2pHdjU2T0pPYmZqQnUrVW9kUWg3WEd2NkFmekY3Qjhz?=
 =?utf-8?B?SnppTU94NVR1UTd3ZDFkSUVtN1NUSmNmeDEvTHg2cWc4clNxZDhvbDY1dGRY?=
 =?utf-8?B?M3hMakw1YW5tYzd5ejVnWXdldVZHZTFVc3UyN1ozckpId2FhVlNNdDJvc1Mw?=
 =?utf-8?B?ckpuYk5ZTERmeXozVElCbXNYOGcvcnFXWlp3bDROTUNjWU5OYUZEckUrYVJG?=
 =?utf-8?B?THBEMVdZekIzcnlXaS9kUGplbHQrY1E5MnBDYWdScWUvVFFKMmI2aHNaNnhT?=
 =?utf-8?B?T2xIZGxRZ3JkUGFuVlExWTBPN2pBV1FDSjV3RklpTWFkY2gwNjA4ajZieTF1?=
 =?utf-8?B?bWUrRlJsY29JdkNzaXZFN1ZqaHl6eGxvclhtZ3daZGZjVko2RFJOK1IxeVdu?=
 =?utf-8?B?N3ltay9UTVcza3lMYWsrSFVGVllWb0gyWXQ0WjZkdlJ1c0dRbWNzeXRBaXhx?=
 =?utf-8?B?RlBHZ3BTc015RGplUy91UEoxdi8vYlc1NkVCREUzOWRXcEZBdEt2NUhuNUVQ?=
 =?utf-8?B?aTUrQlVyYnFhYjk0ZWhmTjNWN2RVSXFSR3RDMXpwd2k1dGZNM3lZTy9FNXls?=
 =?utf-8?B?VG5WTzkvaVZBZU1kd2dBbDA2S2VqbDdSVXhTNmpNalBiSFkrQ0JSL1dvb0tX?=
 =?utf-8?B?Q2gzOWIvTU1ISjFpQ2tyQmd4cTBWNUtDK1ZKcVFFMk0wQ0JjLy9aWE9qZkND?=
 =?utf-8?B?RzdUam44bmxyU2E0MmZiZ0tRY2ZCdWZCLzZCTU01NnJGYUNoSWZlSitxcytM?=
 =?utf-8?B?aVhRVG1aRXR2RlkxeklHZC9jbDR1ODkyM20wdFBnSmdZYm5tQ2wyd1YwNlF6?=
 =?utf-8?B?cnlLTGhnbHp4RUtHV0pQTEtsYnpCb09EbmxSSFROSkhQRlJSRWVQMjVkbFB6?=
 =?utf-8?B?NVF4clJhdmFaWWZkMXUwdFRSWmNkUGFqZThoQ1Q0WUF0NFhEQ05neWtzenRp?=
 =?utf-8?B?Nm5YVER1RHYzdlo5dXhZSXpVU01VRnJKUVliYkhpaXdMU0s3N0JvY0ZmclU4?=
 =?utf-8?B?WVptQkllMU92LzQzRzFCL2EwVGVIdXlLdSsvTXh2aDV1WmhQTmUweWF4U1dO?=
 =?utf-8?B?TEoxTHpZbnc1MUxYK0NCTmkwS0NSUDhiVkpLamo0YWVMZXhPTEFHM2NialVD?=
 =?utf-8?B?ZERYSjJSMUpLQW05MWc0aXlhWlVVK3ZzVXVXczF5d0FkQmJPd0sveVBCdjM1?=
 =?utf-8?B?ZDM4WFR3VFVUTnBNR3dpVDRmeUtUVUVIM1lsRHJLVXFtem55d0R5akRtNE1I?=
 =?utf-8?B?QytvazJrYkMrb0d0eVkzWjlLSXlIMkdROXBneGtYd1FwZGVURDA4U0Z3dTN2?=
 =?utf-8?B?UFdYa0lVcmJqU0pXajU1b3FuTGdXbHBQaEljOW5wMjBWbXdQckltdm0vUjYr?=
 =?utf-8?B?dE9QcEJUY0xmSXY0Y1VYWlNDeDd3d3FLa2FONzNEVU9PQWF4UXBBNGhhNFMy?=
 =?utf-8?B?cFp3aEN1d1dIQjRRbitOR2lvL3ovREtTbjlPejZVNXdwNUVzZVZIRThESER3?=
 =?utf-8?B?V1JwT1B0QUsyN3lMZGJJWGJ5VFB2eFhiU2pLK1FZYUVYaHNHV3RzVlBJMTB5?=
 =?utf-8?B?Q2VMUHB6RUF0M3dUSmdaK09LNnlZNTMvN011RzV3azBVc0YvVldibkRVZkow?=
 =?utf-8?B?OUJTS2U2K0hXWm9FQUxMWm1mZzJSRkJuMDFRenZ6OFBpMU5zcXhaYnNvam1z?=
 =?utf-8?B?ZDUxQWI1Z2RWbXprOXJIQkhrT1p1UHUrYlpFRVYxalU4K3F0N3dzQkNMTEZS?=
 =?utf-8?B?VEF5NGI0RkloTU12QXBmdnUwYk1aMWlOYkdJZHVuY1pLdWxCOXVhS3FDYWhJ?=
 =?utf-8?B?aytxZWdlcFlVRHhlN0VobTFhZGlZVkg5bTh3K00yWk5kVEdWQXVqWDRMdGMy?=
 =?utf-8?B?cVYzdEVEM09xdlcwVmc4UXQyZkJ1NmVuaEp2RUJjWVRPdk9pKzZyYTV4Z0Zv?=
 =?utf-8?B?cVk5dGFyMDFjMThZK3hTTDhzbUZTRHFXd3Y0dkMvRFhIclF3VVJCRGx6MCtR?=
 =?utf-8?B?dUI1SmFxTVhIZFpLUStzZHhLemgwcjdTdnZjR3luVTdobUxlNXFiaGNXUmhq?=
 =?utf-8?B?azZhc2hHSEl6SDdvZFZRS0taTGQybVEwQlFUZmxMdi9BeGdLYnM0ZDI2ZGJu?=
 =?utf-8?B?c1F6d0lReDJqQmV2NVhsUkRMdVI0QkU3M3hCNUY5WmV5ckkwZXFaM1hiQ3pJ?=
 =?utf-8?B?bmdlam1XbEpSbHpKTVh2am1odGtEb0FvS25WcnFwWHFkY3NNZkNjZGZDaGxx?=
 =?utf-8?B?RVRWQTlTcGxqd1BmbW04c3BWVjAwb0R5V3pGczdQQXZ4VkJlbjlOVGVOMnU4?=
 =?utf-8?Q?bURkZ//QkzDAEvxHu4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 794e9d13-b4e9-4366-fb31-08df41983ec9
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 15:10:25.5390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g0mElw+zmWSdBg4PEU100I/31FYBkaaP1x/6JLO5GLcDr7MX2E/tTCWK0Xgp/RjF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9332

On Tue, 10 Nov 2026 13:17:34 +0100, Ard Biesheuvel <ardb+git@google.com> wrote:
> Align RISC-V with arm64, LoongArch and x86, and drop the underscore
> between 'init' and 'text' in the section markers. This allows the value
> to be captured by generic EFI stub code that can be shared between all
> those architectures.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
