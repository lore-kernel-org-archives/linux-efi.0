Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010003.outbound.protection.outlook.com [52.101.61.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1767395AD5;
	Sat, 26 Sep 2026 18:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790448365; cv=fail; b=gT6Z32pLR1oXuXxmSAUCMTdCs1sAUR8Ggea0Wurc7toQcY8ocDmU79/eQuMjLTuo+HjOUQzlqC1OXdkdbxFLaYAgkpE94Y6wXLr7u7SupsVAMqfIrTmgaCIj0TTXIEH2RG/bXjzvA6J7tHdH4vBsfXfwDuz5ie3GZfaQ1I/y49k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790448365; c=relaxed/simple;
	bh=o0uMLxTI1xVrIut3XxN7UsyiLovOSrIuR8sTQBezPJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aZzYtmZWHVIwbscgAX7VsFi35rwwRn51nq1aoqdBjYaPx8PwDRDFl9RHkklAag78cnc6CUwMcZFsdTz7PWtcoK2xaGJ2jVpG1XQnnqlZ9xfOM7JUUad4bVUQdMZnVf8v2oazmxmsTPLeqpL2HXJVbtKFBAn+zQHUID4HszN8w0Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IrGl31j1; arc=fail smtp.client-ip=52.101.61.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IrGl31j1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WvCIvyGe09xnt0xNQ1qXMF5w8kJU4YBHKRMSAOSGVljqY9fQhGi5qoyuoj5MmnVxJcstFckNdE782t2IMkJljQ/LoKDlQl404EwU6VSzNVjiVopzTGUFuvouHbEaMLOdFvhd1Ih6RWUTwlDEEuYpeMso7TR6kqbDtI78sapfwmbxAx9a7aoqm0qLPx6/iiU+8ltCXmAguXz5Tl0Ml+jqaVr1R/eE14avVOsRodQq1YxspcUB9xPFE8bjZ7PeVeIm5/B2xCFdYSvoRGZUYePZS+DGSNiWX6ebFDOxXhpK69yz2zxWP4vODiTAgkBEO1nftz5fxoBTUCpXLBy+Hhq7xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rPJSWCK+lwQS5s8kV2JpbENy9VWhMOo8bp2XUDLokKM=;
 b=CK8K9uIkXtExeVog0Q+OTjfH4QYBSDW8MNuiFJEYbXYg9z3LbG/n48YnMjc+xDVyC1tK+dKh1KA4p+weuwytrH5l1XhEN/641P+kZVmeouj0mPdEZWVKx3r1Wmkn8ECvFcSlfm5Yhlimn9/Co5Fc2vc9c4DQ+sEjvvaFbVnlDkJgQM9g4Cp8P6OupLvjWfnIcxm4bRxqfhcxxrEschwMJax8w+cD6u05Aw7AgNPjfT1WkXG04RQ8xuytd6zrPRDDp3p+GVTb8A+PZVpZdsI8t9cJH9EwrzsRT8hDOEP3RJsqKRdt1MgvfKmoLHshgdCSbIOmnxI6VDo1K6Tlj7CL8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rPJSWCK+lwQS5s8kV2JpbENy9VWhMOo8bp2XUDLokKM=;
 b=IrGl31j1sUfpCEOBnVadQb/Uws64VnWDw8qb3jVzFKhmr0g5OCpf+HilhFl7gTSpvOfW5sMiRtdxS077B05WR0Z8fgSnV7KZZ6WFXanoruui6uMmTM4AbsN4WiVBDnrY/hCkPj8seWZXYYcV6lUkMcwMvfwIcGfoc7hlxUhTxhNxAjwOVEXYZ1wWiCxxrYZlseCJGb9/9OW0kO9CUsMrPEk0wYH8LNxe3rdQx9sRNw3QfKzUU2MCM/DPYBBmCaNrFWneOKpH6nW/2bxeUAeLMpamSYWYy1iN4aT6Bj9lhVXUGMbqvXqlTY7DDJJpYUuGn0Y5zDN26DA0OxbY7L6AFA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV8PR12MB9690.namprd12.prod.outlook.com
 (2603:10b6:408:296::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.19; Sat, 26 Sep
 2026 18:45:59 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Sat, 26 Sep 2026
 18:45:59 +0000
Date: Sat, 26 Sep 2026 15:45:58 -0300
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
Subject: Re: [PATCH 16/16] efi/arm64: Implement ARM64 DRTM in the stub
Message-ID: <20260926184558.GB473004@nvidia.com>
References: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
 <16-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
 <20260925113709.00005cd1@oss.qualcomm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925113709.00005cd1@oss.qualcomm.com>
X-ClientProxiedBy: YT4P288CA0066.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d2::29) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV8PR12MB9690:EE_
X-MS-Office365-Filtering-Correlation-Id: 39cdece0-8545-42b4-d2b8-08df1bfe6806
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|4143699003|10067099003|6133799003|11063799006|56012099006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	UwO2XeLf0Co06FtjTdaIaZNTHERoAvQmy/Ul6JHxMmh+sTHufnArVpyS8rrtWHvVd6Qu7hHHVpjaUmDlIu2RXPl0Jf1fEd/O/IloHJxdzYjlOPRdA1dd1zpayyCDFkk6Px+6/4+SSEzwT0sZwf0+2iLQv9bSe4NfS1CxDyTsirN2Zo8HwFzDOAKmB3AL+5Ll5K15LwQ3+g+y2if7cMTQuCJpEjKssOzXz+FdOyopAzneG1eu8CkPXg3E4WDcgu5AZJpBYJteIjTbc3y6fhK1zRh0lX3XR+NE8QTSNubQ1IjVr53+2rUp5fh1WLArRv8IcWJjeawO3BAC86/HLMxdF8vJpZAyflAqaTQ7wxZop2hNBRqSsPyghnuj7fOwQQKDVfrFBckRHUY2Qdiqg9prtAQjbYIYOFTeJjWe+249hRv2cMJmNPgsmX4J5vQAk9RecL4+bmQ6nX39gnLXbuVUETColQjXQDGa2vxC2yyF2FIhKcwBduUxFNmWhmMci4qkK1ZAkDm5pe4fTapM8UE8SaMS+fP/6Hfkt5yB9r5VWHRMcCv4wPOBjihUTJLXdrYgewnG9bBRm+LpwwvUPXDlZQSaRpNLjSW3W5493kYpdIJlQE0yrVp0lzOymdkZaEcj7WBzzlQJDdHbBfCck04EPMDX7a3QGu/bg9prlPGFcQ4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(4143699003)(10067099003)(6133799003)(11063799006)(56012099006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jentSjukOMJtDkl8RkK5YMqSvkDGw981oOi/PpHNphryJJzVOOzszncv4kuD?=
 =?us-ascii?Q?J6Ko7mgkq/MNvzQ7BRvwt3SkLLasxmXDuh9pngKGmn+9oObDvFP4Zaj4U4B3?=
 =?us-ascii?Q?ToybcmoG8knMQwRWAmqUfmAgp/3WlWv0vabd0jQOS1ccgiVGyu1jxX8wEsgv?=
 =?us-ascii?Q?xerHyUvmTFFtiWhoFi5cXPOD0553CoxiDxdPC3XgGYOl9KUlNeN89DZf66ey?=
 =?us-ascii?Q?aQQmFH9JixuJHHDlpM5coVyz6o4TaS0NbIQ1ssELO65ErslgN+PFtdhNbhTv?=
 =?us-ascii?Q?obMI7uWHlcRZ+noWypmkogO71UIiRMgfrbI5fWbwqpPXEurgVbJMXYy6og38?=
 =?us-ascii?Q?ita1LyuG6PKg7guXgz1ln+eyeEwb/Sl2YOPUoOlaSM1WlH5QYkpWuxk4qhQb?=
 =?us-ascii?Q?/WLqQK7QzSABfmzncSK7DWy9XBVcckTJZyUg8Bd0pwbmytxMGA9RCmVfhMTd?=
 =?us-ascii?Q?Vs0tvGf5e+ek26xNjwoJZR8zsxgN+oeM4XqDYJZtsegW9dLS6KxrCqC+jJva?=
 =?us-ascii?Q?Myna6TO1RrBJw+uqIChFDhmEQ5d1EufKOHIc3hLckIlrIZl9yETGHAsfl+Fh?=
 =?us-ascii?Q?EUvp6dNsQQ46sJF9ltM2Le5vakuZXfpoLwHPYaHW53LD58V8u53mmadUZoqv?=
 =?us-ascii?Q?qcQ1dHL+TSSx+M//It6Ef2tzLoUQz44kaZt5qIGjsiv9mMDeQXJybAhNCl2K?=
 =?us-ascii?Q?4k/bnNAeSZNDjoSbRBJ1s7LuTiDT8/BYTimyrNuSPogVV0Ux3aSfNFQcsNPI?=
 =?us-ascii?Q?ZqIF+VydglKnx12qNHsVbwhvtxfaYhFomjUTvUtmZFXhlDBELwNCuabhb9XK?=
 =?us-ascii?Q?M+QdlO4zmQPinWIRytJP8rj/hYtF+EtdXHGbtY8AS7beAGvnNH3ndhvmy5Ri?=
 =?us-ascii?Q?JwkWDhrtyZ+8mVKw13lDabmH/vSQzYDFMSzxo8NBdrYHhBmtCwfC/u3ezplV?=
 =?us-ascii?Q?KLSxsOXKzBjX0KRLHtECzAwWuDiyCk41FFsfV+aKEFYFNBIw0AKd91+opVLq?=
 =?us-ascii?Q?9NoQc7ZzF/yasJ4O3sOQ7T8fc20bj+RwYiDkAPfzoq7B43We/J+FLZ/GanWL?=
 =?us-ascii?Q?TKRjGnDBgK8SKRsLANd0KBteFygc3CooDNaUdLrSqEhrK+ucDkN71tO50E/N?=
 =?us-ascii?Q?tBm9peXqOx3Ot9WapPtaAqHyixOqcwPeDp2SX4boXsQrQfnAvEJCGR9n9qjd?=
 =?us-ascii?Q?khVfEQtsMPGKKeAtYVYb0IA3XV2Zeh843JpyEAQY4KoK7mq+XmclJfXGbRM8?=
 =?us-ascii?Q?hW6dd1/yBVmjCdH92a7+Kg6Fpbb5Q2OuXCXTSuVS8TW5fgIp6Vo6L7CWyS7U?=
 =?us-ascii?Q?DQ7s1bKdYQ8LgcvRgEGtc2Hez+TRIX0ANmqrqzoEtsdC0q8lzxTyj8KX3g2H?=
 =?us-ascii?Q?AImmDkUQN4lENF53mTaTzR3AKRoIf/Cffy7opz3qbszoNQqFmBqpUW3VSuCj?=
 =?us-ascii?Q?HUVkuQy/G/B+/XCQf8fk54WVDzHFdMUOOiHl7iEoU0qdCNqPndamZNpUOatw?=
 =?us-ascii?Q?tmsh3lqzxSjfAcZ8+nl2SAnh2CebDrRw+pOknpvVyp3Pphv1EYRnfxlsRy1s?=
 =?us-ascii?Q?KrsIvr2/d8MVJLCW6Gz5U3zg1uZWxtwN6IV48OwVJdN2ZE3OMxduQJcS7n/S?=
 =?us-ascii?Q?3bvZsVciAWhxp3NmhTxdKJRjPsmnvebnOVtm51MtYno5iJvIs5BtRA0g9XEM?=
 =?us-ascii?Q?Zs38WX2KtnVIgl23GX261WoTASuwEa+XDZPRLTGPoxk6TbpV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39cdece0-8545-42b4-d2b8-08df1bfe6806
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2026 18:45:59.1485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7sDJZQhd6yOVoRS+drHRbqMh/xB9L2gYKQk3AeSz8RWtmpB88bww5E+IleDVdghS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9690

On Fri, Sep 25, 2026 at 11:37:09AM -0700, Jonathan Cameron wrote:
> > +efi_status_t efi_drtm_prepare(void)
> > +{
> > +	s64 feature_status;
> > +	u16 major, minor;
> > +	s32 status;
> > +
> > +	if (efi_drtm_policy == EFI_DRTM_OFF)
> > +		return EFI_SUCCESS;
> > +
> > +	if (!efi_arm64_psci_smccc_compatible())
> > +		return efi_drtm_failure();
> > +
> > +	/* VERSION must be the first DRTM call. */
> 
> Words like 'must' should be backed by a specific spec reference.
> I couldn't immediately fine one other than common sense suggesting it should
> be called to check we have a version we understand ho to talk to.

	/*
	 * v1.4B section 3.2.1 "DRTM_VERSION usage" explains that a new major
	 * ABI version may "Change behavior of existing functions". Verify the
	 * major version before calling anything so we don't trigger unknown
	 * behavior.
	 */
	status = arm_drtm_version(&major, &minor); 

> > +	/*
> > +	 * See arch/arm64/kernel/vmlinux.lds.S for the DRTM Memory layout. After
> > +	 * the DLME we choose to place the Normal World DCE region followed by
> > +	 * the aligned DRTM_PARAMETERS structure.
> > +	 */
> > +	memset((void *)dlme_start, 0, efi_drtm_get_extra_size());
> 
> Is that efi_drtm_get_extra_size() adding much? 

Yeah, it is the one place we compute the extra amount that was
allocated. How about:

	/*
	 * For robustness zero all the trailing space at the end of the
	 * alocation. This contains the DRTM_PARAMETERS structure too, so
	 * must be done before filling it.
	 */
	memset((void *)dlme_start, 0, efi_drtm_get_extra_size());


> Maybe it is worth keeping for the big comment in there, but it does
> feel like that and what we have here could be combined.

efi_drtm_get_extra_size() is called by the generic EFI code, I can't
remove it.

> > +	/*
> > +	 * DEN0113 section 3.4 returns from DYNAMIC_LAUNCH only on error. Boot
> 
> I'd use a spec version for references + ideally title of section.
> As much as folk may try, sometimes these things move around.

I tightened all of this

Thanks,
Jason
