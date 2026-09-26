Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012027.outbound.protection.outlook.com [52.101.43.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBD6392C3A;
	Sat, 26 Sep 2026 18:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790447264; cv=fail; b=agf/L1i93kYsTAmWBdvWjHaX2bcizLjPcR1RFTPfR50QfhwQvU84GeClEXjhPOdt/FwYYZmLJ1ShrpJoqg50PAWMnvhkp+Cxg2lUUqCHzCypuHyCXhjLKLHJEil0/SaFheddpIuuUQiPNB4+AYhUxA70xVrSJwQWRFolIddbsNU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790447264; c=relaxed/simple;
	bh=wq8/kwI/k6y6JYjcG2DndgCEdz4tPU/yxoOZR+ovrHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GMZZl1OM7NbWWEf1T0N7tUJwL3DR3Pe4e1iTw3GkcGOKSzb7lu/QQylk1IP6OXggQfo5obYPkwfAOF3z3ZyzL1Wp517HTZJoP6PuLJdNRT1BaJrUD7PzQcP7HU8L2jFK3zCAB0zSqNbZbKiUm7iiXl1Rre7JG4bTpCQ7iZtAkDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=C/3QEAyL; arc=fail smtp.client-ip=52.101.43.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="C/3QEAyL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nosdLy8nRUby5Ns2d3DeOrfyeQE9v42k0EeYwi3sxA6bNHOIy63raEhII3ZPTuzG2ASWQpIXWjASsA5UmkL+dpC2jtCo8UrZLy9OO4dwzB3Kd5kGESw4vXx+SkaFjpgb6j9CBV1eYq2CVRjJBmAX7qOlHLV9oS5NhlBzeAJ2SGr3lRF5W31vRxqXxHcx04dhw9c7gB7P4E4gLgIps1KuBG+sEvhqd4umccEeKb8RjQ3/wwtGGqYZvzHkGRqsIWs/osijajrPRGtIJx4do7T0V8immCEAE8NRhPHVbz3C0VODLgH/jeM9Skw0Yr77ThvzDMp1/QUYXeXy/z2/9HmT6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aJsRb1/nw4q/dpsi/IT2Cexb4DylEARhC1JgpVcCMuA=;
 b=HxOJu63San3DCKeC3TVCWUDFPrrJxRMqF0PlzH/esCG1OKkDI2FrvzfHZkJlb0WVT5F3KblaEECSDKkzewBlmavBAsSAFDUNPl9UiXsfNaa8O8Lf8PrB7PqKnWwgFelQAQNv4klTuoOSMyDQHxuJeJo6eI7eCHEKDUkZiyDEF7Am+uBx6VW7qppQb6PFjl6NcVktA/HHATf03PlU5nIBIdAqrnZpLDP/W4HTbcgPZ5JiZBCak/AyFzUzq3NmbFrTUeCBfKKQKV7cVtD61dDL2W9Y91XajeWx3Kl0cTd6HgUfe/dtsCJs9cIu/kV2mLV5TCL9ucb0SMcFkPzH5AauPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJsRb1/nw4q/dpsi/IT2Cexb4DylEARhC1JgpVcCMuA=;
 b=C/3QEAyLw7YN3p4mjp158Mo3XEDA6ZWcHsfOc63EdDbV2JR1FZLsCyBLqCIKYKRaWHWvJTH6RK7+s8bTLfQsXtTn7fLsSO2Of+pWa6oQ22itZr5Sg23sK9nEz591V49kC8lSN9vRTyLYkjwLnauhaUv9nI3CG11T/K1wwdqMJCyRWgz4gsdKxVVSQPHxT6jZd5X5mK27VKJd7OTUjyHwwG2Tqg9/xNgWKyVegv1nu2oE3I6sj38eZLERQuSAyh/y9xaC6clncTqRPvNNNL+7fjmKoG1qbL6wuq9Hgyb73BObFqbXF0XczqUopjQJY6FibAGFTLGzx1aeImTHo3iEkA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by MW6PR12MB8868.namprd12.prod.outlook.com
 (2603:10b6:303:242::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Sat, 26 Sep
 2026 18:27:38 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Sat, 26 Sep 2026
 18:27:38 +0000
Date: Sat, 26 Sep 2026 15:27:36 -0300
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
	Song Shuai <songshuaishuai@tinylab.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 12/16] arm64: drtm: Add macro definitions for DEN0113
Message-ID: <20260926182736.GA473004@nvidia.com>
References: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
 <12-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
 <20260924172952.0000527e@oss.qualcomm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924172952.0000527e@oss.qualcomm.com>
X-ClientProxiedBy: YT4P288CA0023.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::24) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|MW6PR12MB8868:EE_
X-MS-Office365-Filtering-Correlation-Id: eede5eb7-558e-4978-4183-08df1bfbd7e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|3023799007|6133799003|10067099003|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	UA+sCkz5pHrUIm2WiWp0NTTEu0/ziz1MYhhlIhK3UyJlLeFUiagSpQxvrmFJYnbQsxity7uqDDKtyt2NKod6lOuJ8m3bM0hbdX7k9rIBXdOkvb12UYNkWN0n5NhpxfaTCavMPhpbUB0edxCGx8eg+k2GIcsTSaP54lb1WE9EsTj/SCBhw3VFukUdczUn8IM+RZLi9QS5XUJ16RGq/et4KdaNrWNWzWyTmQ6azAmfeNXgqlu2dzetfH8+n0M9352Lo+EyYb8/e7jm1ouJR6zoNt7bXcpxGH5QKolCM9/JDkkzXX+3/+FVSv16FbCyWMw8m74F5zG/EpeSFkuBjJ5lF9FfhFwGw1azS0AJh5HtkeBYQpVByWzv+Krcm3vDvHPMFyYe3lnDbnBnqMkagj38AB39rVPDf+gCjqgwzRsc0VYOznHS4iS1lchzBf7NANAbZnHQGpNyDAfoEx23XFyDsHRrUQr+5B4NG8F2d6NxdM5425FUV7bCoratt8Br/B6JVS+Em+wD74xl65SbwlfJ/TzvITr9Wk4gmGBfhRkJ+CNUCoF/3G7aDa/dd+0l9G7+o5KIM+vm0Q/rE+HD/GE8ppG9ZYXD8cVPG2pwanCALZ5HfTm+20hmUXxE32YHXhC9NoS6xdlET1c2AZvvbZYdkPITSo5AjgfhyWWmNhXCwr0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(3023799007)(6133799003)(10067099003)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D+hMZDL5GTVRnJXhX1ycnCQKro2VyOEevI/a0FU7AAg28ujiSf+rHIhhO12m?=
 =?us-ascii?Q?k4QQ9yzrDo+oELqawOVMREAnHiJR5NFinC3U2xcGDFq673x7w5VZS/at7Raj?=
 =?us-ascii?Q?0J+c0p9WC4nE8hJH0jnM5ERRStnlE0nUKVXSwMZ5exij8mUwbwqzI5hCGa+m?=
 =?us-ascii?Q?Bg015eaqX2VgtIePU8gIYGgxmGiFExRLd6Uc2wLCAhDXiAi9NKmy7XJBnTRv?=
 =?us-ascii?Q?GGZo0+hy6qGNEiGmcwCHC4vf65QgK6D62nQ4MGhltAPriahvYpBplDOv1uaU?=
 =?us-ascii?Q?ozv5SkiwEkfrhYwnbUKFP0P6xHCKKFrH/Yl+5bHitWBCAyQ8jH5HiWWDoPZp?=
 =?us-ascii?Q?zGoF3critkIlrvNjLKqX6u84q4giDV9sMQF2jeA/+O6gBW7IjJbCnT6FOLop?=
 =?us-ascii?Q?v0CcFtVDNMJJ+vPVApe4Ys7aSLXLrqMghOFdTMCNEcSKlnzSEiovJ0mHaa1W?=
 =?us-ascii?Q?MItcwDCKoFJ/6cFwyRAQ+uZx2f3j9GJuf6RKMiDVsdCpeJbKeTuXspl8OMm3?=
 =?us-ascii?Q?IaHKbwPdPoTmToFdnxI2NSf17mtzs9fa6XmpQpH8W0Fs8qV+fXF7YJYwgVDr?=
 =?us-ascii?Q?BEJSSsNXUk9ZE3rtO5N7YxBm5DMrAYlgnbkkrQqFj4KZOXQ0EqDNkQVGSdE/?=
 =?us-ascii?Q?NnAtXd8Hnw36E8iW4quo8bO0qDrDTOaju73R3EqUw8Xv1q8oS+8bH6IApzaC?=
 =?us-ascii?Q?VGTpYt4nDjsyzLxvjYBWVI5gyA3QfT2UV6uFkl9M2Kp9AQmrCfJj6g6LPn8f?=
 =?us-ascii?Q?89Ocn5Qh6ALlVH+QAalVUfabKUMT8Q7tAN8i/QRBkNurisbILo2/aWpLPUNM?=
 =?us-ascii?Q?uVky9WDRqqQ7Vcy1H3FcMQv9FFyyd2TDqmNKEREh9EOXOuCHKXy2oumCHkTD?=
 =?us-ascii?Q?TbzLGP/regQaBHa0oGpc2t+48aMa2meAeuAvgYaC0aGf25tGmgZoGff4cx5b?=
 =?us-ascii?Q?TQHMBcx84NLpV15YBDnxcS2h6p3IHmI26OsV2WdmmBxGnPXA9+nXC+w6BN2O?=
 =?us-ascii?Q?jhBVsgq8MDTc3ytMMW5d7BT84vZa2UJPUjWs9WOYBb3erhmKWm990o/ljjpR?=
 =?us-ascii?Q?8Y38CuOIy/8aNlDO5FVdbbO1JrTlTLYW23gl+AF9v9HwVP1Bbz3gmxQ6GKlg?=
 =?us-ascii?Q?8PXCltQczsne/uBFFmgZmLQqqxDBz/OGFJ9aXGCOWbKZFTdnGqtkuhgRKSAh?=
 =?us-ascii?Q?tvPo+pXMX2HE5Fow6d5qN617leVavFOuEVfFA56AP7ZXLnczDarPnzMN4VDo?=
 =?us-ascii?Q?sbnC3Xew2EaQvoW6YIlimQgqpG/J3Y3xC4TrkHDSZBqjWHpzFrs9BuuS1RN8?=
 =?us-ascii?Q?aA7DRE19LJmt58DiI9fPo1Y6Y3zm8NG4MaJxkQVUi1pBiriAijhyPVuEpafG?=
 =?us-ascii?Q?VgBw+X3Wq5lekPbkP2/RygtNhSfMIsPHUCPjDiiH+ImbD8Q+/3poNBmx/j7M?=
 =?us-ascii?Q?tUtB2rP4cgCNXqxXk4E7fSJHcA5R1iU8cPL5FAju27US1F/hDtZq5hKWUtP+?=
 =?us-ascii?Q?P7UXGDIeJTeuBA10sJK2B2h5qXlJbLfCoZ4/0UJ4UMxJZPI7i8OOTgoD5yXB?=
 =?us-ascii?Q?ELgQDvmMz/jI8YGWWobLSeEii5waOIl8pwclhMyju0214ku/67ZSGVL8LIbm?=
 =?us-ascii?Q?jQEOqIs58IjIPIv9VPhB7TQxoj0KfMJkR+KPehLdgxlqYdzaPjZtda+nysm1?=
 =?us-ascii?Q?vtNrgp1rrcYJXrD5D2up/cDZoFHnjvi9jL8tdRv2118OYZmu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eede5eb7-558e-4978-4183-08df1bfbd7e2
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2026 18:27:38.3404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4WkVDWy9d1m2jBxVXSVCgjtHKEoJtN8zmy/AWLWcfFFM9j7383msZvR4xirS9tTG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8868

On Thu, Sep 24, 2026 at 05:29:52PM -0700, Jonathan Cameron wrote:
> This one at least does it via base and sum.  But that then separates it from
> the spec?   That is sort of the case anyway because the spec has the full
> number.  0xC400_0110 so I guess not too bad.

I wasn't sure what to do with this since the spec had the full hex and
we have these helper macros.. I made it look more like something else
with the offset style instead of the function call style:

> > +#define ARM_DRTM_SMC_VERSION			(ARM_DRTM_SMC_FN_BASE + 0x00)

IDK, maybe ARM_DRTM_SMC_FN_BASE(0x110) is more connected to the spec,
but I'm used to doing it like this from ioctl land which is very
similar.


> > +#define ARM_DRTM_FEATURE_SELECTOR	BIT_U64(63)
> > +#define ARM_DRTM_FEATURE_TPM		0x01
> > +#define ARM_DRTM_FEATURE_MIN_MEMORY	0x02
> > +#define ARM_DRTM_FEATURE_DMA_PROTECTION	0x03
> > +#define ARM_DRTM_FEATURE_BOOT_PE	0x04
> > +#define ARM_DRTM_FEATURE_TCB_HASH	0x05
> > +#define ARM_DRTM_FEATURE_IMAGE_AUTH	0x06
>
> Nice to have a mask for the 8 bits of the feature field.

OK

> Also nice to keep order the same as the SMC defines which would put this after
> version.  That also puts it next to the values returned for each feature.

I reorganized everything

> > +#define ARM_DRTM_TPM_ALG_MASK		GENMASK_U64(15, 0)
> > +#define ARM_DRTM_TPM_HASHING		BIT_U64(32)
> > +#define ARM_DRTM_PCR_SCHEMA_MASK	GENMASK_U64(36, 33)
> > +#define ARM_DRTM_PCR_SCHEMA_DEFAULT	BIT_U64(33)
> > +#define ARM_DRTM_PCR_SCHEMA_AUTHORITIES	BIT_U64(34)
> 
> Ah.  Always love a field made up of a bunch of bits. Hard to define
> cleanly.   Do you actually need the PCR_SCHEMA_MASK?  

I did it with a field content which gets reused in the launch struct:

/*
 * PCR schema numbers. ARM_DRTM_PCR_SCHEMA_MASK is a bitmap indexed by these,
 * and the Launch Features ARM_DRTM_LAUNCH_PCR_SCHEMA_MASK field holds one.
 */
#define ARM_DRTM_PCR_SCHEMA_DEFAULT		0
#define ARM_DRTM_PCR_SCHEMA_AUTHORITIES		1

/*
 * DMA protection types. ARM_DRTM_DMA_PROTECTION_MASK is a bitmap indexed by
 * these, and the Launch Features ARM_DRTM_LAUNCH_DMA_PROTECTION_MASK field
 * holds one.
 */
#define ARM_DRTM_DMA_PROTECTION_COMPLETE	0
#define ARM_DRTM_DMA_PROTECTION_REGION		1

Have to use BIT() to get the bitmap encoding.

> Same here.  I vaguely wonder if it is worth adding something
> reflecting the relevant feature ID to each of these defines
> so we know what the are referring to?

I added comments and spec references for everything

> > +#define ARM_DRTM_LAUNCH_HASH_FIRMWARE	0
> > +#define ARM_DRTM_LAUNCH_HASH_TPM	BIT_U32(0)
> 
> I'd rather see them as fields and field value pairs but
> can see that is going to get a bit verbose.

I think that would be too verbose in this case, and the usage is very
limited.


> > +static inline s64 arm_drtm_features(u64 function_or_feature, u64 *value)
> > +{
> > +	struct arm_smccc_res res;
> > +	s64 status;
> > +
> > +	arm_smccc_1_1_smc(ARM_DRTM_SMC_FEATURES, function_or_feature,
> > +			  0, 0, 0, 0, 0, 0, &res);
> > +	status = res.a0;
> > +	if (status >= 0 && value)
> > +		*value = res.a1;
> If status == 0, is res.a1 useful?
> You have a helpful comment at the call site in the final patch but none
> the less I have read the spec section a couple of times and have no idea.

I read the spec as 0 is not allowed.

I changed this around to have two wrapper functions, which works a bit
better.

static inline s64 arm_drtm_query_function(u64 function_id)
{
	struct arm_smccc_res res;

	arm_smccc_1_1_smc(ARM_DRTM_SMC_FEATURES, function_id, 0, 0, 0, 0, 0, 0,
			  &res);
	return res.a0;
}

/*
 * v1.4b Section 3.3.1 says:
 *   A return value of greater than 0 means the feature ID is
 *   implemented, and there are other feature-specific
 *   feature or capability bits available in other return value
 *   registers.
 * And for FEATURE_SELECTOR all defined features return data in other
 * registers, so 0 is not an allowed return.
 */
static inline s64 arm_drtm_query_feature(u64 feature, u64 *value)
{
	struct arm_smccc_res res;

	arm_smccc_1_1_smc(ARM_DRTM_SMC_FEATURES,
			  ARM_DRTM_FEATURE_SELECTOR |
				  FIELD_PREP(ARM_DRTM_FEATURE_ID_MASK, feature),
			  0, 0, 0, 0, 0, 0, &res);
	*value = res.a1;
	return res.a0;
}

Thanks,
Jason
