Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010039.outbound.protection.outlook.com [40.93.198.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6E43515FC;
	Thu, 24 Sep 2026 13:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790258008; cv=fail; b=mCS6sxM5rEZk0Lo/dmROX2kM2aVs6ldVP7L4oFTkMyyDbViWas7YTlwPlNJCT3YjWyGKZGeDu3xBw9o5dHmMUbWrVD8iAN0oSV8M1xpVhqh+Yhsz9Y1nGjIhWj4uI37NfW/V7k48pAJd+y8CsI1YiW+5daNHKFueXXb01hZSY8E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790258008; c=relaxed/simple;
	bh=Lt9qzVScktaur8W1eRTqgbBOHj6kYymkI9Dyf07bB4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TmVjyliAsD9Eug7eqoj1E+Yy4aVYOmpFBf3aoqorc0ogc3ncv93/o/Z3mS0KlPFTQChNcJS2MYUvIkog+iPpF8zKqjkyHhN5h+ziVEcjUVGMWbR443RkIUrfzp8fFy2JasRKP+JcjINyZUck+RXjUyxq2YbfVCZ99miHBqvZdQA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=B27Mevkl; arc=fail smtp.client-ip=40.93.198.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="B27Mevkl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HQUhfQqMsObmkOIhscpLMUihZGGKU8zh4LihWCZ/dEneccvD7d+YFoVtQJ4EFCVfGFoKOD2yUiA4g/77bPCAT3EHGqIDkmMjRNx3HyRqsNVlYzFCUtohRx9LtTrils17PjgkrtCgUhy2wi2msAQXrk4JoqQ34HbZytPy3ThKnjee150bLq4/rhgTVrottYvfLVOFdnbqIirZWw4L8jUAnzV5IZz2qqdkUlUJI1u2eNfEVZMe9CpwAj8orxCtSGyDHHaqk/9oC0+uEFHManqVEZkYKWa69+ynTly5PYKjJlvv2rzJNeNUTacOPPc+EQUNQunz0P4uDf+8Ps6R2cj5gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hjZROA+4HmRedO50bc/ZSCbT1mxRaRI6UzqOntV1t3g=;
 b=Ru9DAOSS0csyxVm+TTSFsdZ/6pJWmqtjJTUlxGO1wr9/qzEuD0OS6Pl7y5HER/FoVZO+8nBeKtu1sLsO3MxTkfSIdWZur2Fmd/zFklkuof+7B9wIemOrWCc/kfroJXLNWHJCcAlY+cmWztxMfZgYKMUqmBGy2stS6L9+RRlYWjqqjhXMUXmKlrx8ii/0XbJTwcr0Y/XAHxpU5HWtHUSLf/Mv48awm1D9bVjm8VXDyOhOjBxk/5BQsx8C0Twa+9NJn7YxhIZ3Njfaai8ADF/PgQlvnLxDxRR2z3mPaldE6oN+MLlHIgXnaF7x70Zyo258OTf7gVV6Knc4uYg5sI7Raw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjZROA+4HmRedO50bc/ZSCbT1mxRaRI6UzqOntV1t3g=;
 b=B27MevklegjCVxEs17mSNSMTrSGlCrIMLdFBwGX4OOdO6r1rgPogSLu7NS3GpZSkKr0YIXvRPhKFVLaUn4k4A7NsemUY24cw2pl5Nu/R6/9lu4oQ9EQTmbar5ZEY1c5Nw927FsfDunKocs00F5J8eUjXe2WZNGap3G7gJQMwIhyk3gxs+vvTlN2N3nAUfzynd9gKb8CuDDIOrV3aNFZkY9qurV2Do7Evnf7Gpd7sgGgaqZHY2JEDOHCVV8cdfIoAvUGPSEoWNBoUyXPHRPLoHZEwI+2aZkeGoHibJR5yf+vCh1EJBTyY/uyVFO0aqNZjcHK7NY6zZniAxNkYi3dQSA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH8PR12MB7375.namprd12.prod.outlook.com
 (2603:10b6:510:215::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 13:53:21 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 13:53:21 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Simon Glass <sjg@chromium.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Nick Terrell <terrelln@fb.com>,
	Will Deacon <will@kernel.org>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	linux-integrity@vger.kernel.org,
	Palmer Dabbelt <palmer@rivosinc.com>,
	patches@lists.linux.dev,
	Ross Philipson <ross.philipson@gmail.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Song Shuai <songshuaishuai@tinylab.org>
Subject: [PATCH 01/16] efi/libstub: Fix error unwind freeing fdt in allocate_new_fdt_and_exit_boot()
Date: Thu, 24 Sep 2026 10:53:04 -0300
Message-ID: <1-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0102.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32d::12) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH8PR12MB7375:EE_
X-MS-Office365-Filtering-Correlation-Id: 157f3b73-e1a5-465d-1d1e-08df1a433218
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|921020|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	T5utDGxpEzJDwKs2WYn3ppPvFJIHT0lV81xmkw56K5+1UxsVDvruBIYkHAsMO+mEbh2eY1ZebkmLOwPqWa/qWrprt8DPDgtQXX3wZovSbo6DFhOMZYZVH8DhLZ0s9Raf4ksKzuKafnvIESNY6gyAtoID+cQI2ckpsiOQVkNRE+KkoSPG15Gq1pSQpBU5VuqMiQRWqeS77gENsKBL9zYDl3IMAtgXFF7oicRXGE39/IS7em5ShIryp4lwtA98Ov97ikP0S4CCIlO6pK0a/OTMNV6FCm8F+KI3G6f+W/SToJx7fUjuhSrGnubyVmnsPtZ+rR83JeNpXJKtaUWC/hJNuNIjN0bvSrk2JzV2DbNQXRhlm8tF5sl8rVxpt+gVGVk+S8vIRFtpIWRFSBEQDhG57X45IBv6hsPPUjmTsv3RF2Pd5reSCQplfplnERGETo7lWHIkZKG0BzaJc6PCbnWwzM7jCjro6dN4YDvR0fhVMTDF+qRYrbqzrvKf1Vhw2b2nodOYxuTN8UmkXIbF3MfKonmv7pRTwTEnop13gE50rsxfKOoq/VKrqX8/xg0KzsoMB1fZe3jxKZzNNEWugksDw+OzauPXJdFP64QeIH4Kyc1pJdYBb/4o4XoiEjjYLacXbv0GCzEhvXObN5w1ZhfY8BadHWyPGV9O6HAOYnLGwJLMj3T3xF6EfqzT2Ur/TO6m+n7hR/jvkkgimYVOHKgbiw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(921020)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rhcPvh93CpRt6cQFzCYjWzMsiY0NJzuaSZR9nutmYC2f1eTcIRIjFgIpY2/V?=
 =?us-ascii?Q?4NamulQOgXXhUJ0ToBxGxDBX0H8IFXGA6qK+6cX3KNQypeMprCTqdhJvkyn1?=
 =?us-ascii?Q?15FfQ9579lhLrbq1e0YcJ+RUWtulJGjYKS1t3X2ormFTPlTUh5XUt3kNrb47?=
 =?us-ascii?Q?PdtNiUc10FmVCx35smF6/F1S8bkQtcjy7hFFc3YqV5Pz80S1QBiKpz5GGioV?=
 =?us-ascii?Q?Gy0Z5HmnDCE3L6ZMli6An8Dyh0AYWCjOVlz8UE4Gex1Dzw5Yg0BpCpzj8Kzn?=
 =?us-ascii?Q?OzqIAKKmHB4/DduU/7GRQIOIwYp4MVb6N3QAGSH2115GoutelAUz2yEHVe6u?=
 =?us-ascii?Q?tpt8cP5v6S30w1rEPz7JEJZkquAeebeKUy/ZFTnrPpiTHsxoddUoXsQl93/J?=
 =?us-ascii?Q?phZeyycx9eL903Zq0Acar8AHd5qadgZ/r52LUXxHQzrRKri107J7szGyXh+F?=
 =?us-ascii?Q?GIB+gsd70yT6TVkdj7lUIgnF66fgQMdrw9x0Dc3HuHJKlYxV3mSgwZ+jVU8a?=
 =?us-ascii?Q?bBSlpaWlQPwqcrmbgj7oDBAAf5EV0mkr9JnCI93dD/8jzTefwJLD9cPXknBo?=
 =?us-ascii?Q?PW2CdcPPdT6UrxRclwTwqx3ClJTRxdMIAmP4LNRO3oSwmBufpeR8buP6MRF5?=
 =?us-ascii?Q?+yqSTgiBh0g4wKK91qXA5MWmsRYaPoYSVJyMofIIjf8scC1R+GPsJRWFVlP3?=
 =?us-ascii?Q?k3GP3ituu7PbjzLnXeU7XSC5WfGknmV771XbiQsw9s3IrlhenrAs4eWGEKiE?=
 =?us-ascii?Q?anwli6gBtk3hzf+64pCNWQnFx68KrJm/DZ2zQNNmfLj184/zbg0v+Y0OKWyb?=
 =?us-ascii?Q?q3unJijkL9lTNCOYFoMJZJxOOzMCnCaaENWM6nEydOY+TX8Gwzj94bFcwIGq?=
 =?us-ascii?Q?o/xoqctNfqxuMX8O2+321e01fOBqLlsYR3tA8sW/0t+CKOs/GkTsVTiWMVT2?=
 =?us-ascii?Q?CfGtFD+vxZCD1QBfbV4ahEVf+sA+AuiILKQxDhKbPcz+mmKRO9Aunnkqn+MS?=
 =?us-ascii?Q?Jf7V1UVs5RcTUNtVBDIcKNsSA9O7oEHOteR1fUjGW0MD5S7H5buypXnKwa9q?=
 =?us-ascii?Q?3e8hIb3wWiBOlajPv0ZXcdUl7YTyEHObqOOOc7mudUsvjA0G2HVS1s+/G5U4?=
 =?us-ascii?Q?JVu5OlJFAr6KA6GrvGmdU4Ax06q5umoEPmrLaJMsit24SKZl/EXPjwNB+nLA?=
 =?us-ascii?Q?bGF//Bb1GuKVc6uSMS4bMHcTnhmddFjlb2lNIC2KBoxTN0ZruvoIqQfUaMB5?=
 =?us-ascii?Q?8V7qp23lHWz8zdTZR3Y+Wf8oh/JqbRQhUMIVrOEvuYkJRfHrk6ZryW2FKPn2?=
 =?us-ascii?Q?M1k+NpCzHmdZZ9bG++UGrA5rLKMBYZJNvtQXPdWYNZaLsAt4ahhQai84ClCp?=
 =?us-ascii?Q?qrwljUOujgbcAtl6cJkMVpeqFQAqIg1dqunXglPKatdyhjdpgNmmv9/stUvc?=
 =?us-ascii?Q?dkDkzGec2chP+qovC+4s+Cx6wXAa/u4HXVHrXpnCyr04H9E4FQBD5vlyA37/?=
 =?us-ascii?Q?2SAJm3TLEgzIiOVVo4G3UqZzRcvfXdmyYTuX+7JzYKPwBLq5LPtS+2pvSmri?=
 =?us-ascii?Q?3k9m6F6U3us8axgfw9ZgdWwj8zg0dJefkjkNfNfnI7f+DDndYLMxTI/RbVgS?=
 =?us-ascii?Q?UgW9vDrxmfyp41n6hbzc6jVnPm9uqeR0Y6eGxxOWCuNFfVHdSacdFvv+cmeU?=
 =?us-ascii?Q?o3VGxqhHoiQbHwBFXI/K7TcGnXdahdzo4KbLrBUsVtNGiJXa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 157f3b73-e1a5-465d-1d1e-08df1a433218
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 13:53:21.6613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sEYKxlI48RT9odQuLwYZ9rcqRmnLbgRb8OyEwVgVWiCi1jnmImRSY+SeeeM3lE4c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7375

Sashiko says fdt_addr can point to either an allocated fdt or the fdt from
get_fdt() which is memory owned by FW.

Only the allocated fdt should be freed on the error unwind path. Use a
dedicated variable for the allocation's size so that the free does not get
confused.

Fixes: 4fc8e738ff3e ("efi: libstub: remove DT dependency from generic stub")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/firmware/efi/libstub/fdt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index 23b3543d3041b0..5b2dd709d7b151 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -229,6 +229,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
 	u32 desc_ver;
 	efi_status_t status;
 	struct exit_boot_struct priv;
+	unsigned long fdt_size_allocated = 0;
 	unsigned long fdt_addr = 0;
 	unsigned long fdt_size = 0;
 
@@ -257,6 +258,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
 			efi_err("Failed to load device tree!\n");
 			goto fail;
 		}
+		fdt_size_allocated = fdt_size;
 	}
 
 	if (fdt_addr) {
@@ -334,7 +336,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
 	efi_free(MAX_FDT_SIZE, *new_fdt_addr);
 
 fail:
-	efi_free(fdt_size, fdt_addr);
+	efi_free(fdt_size_allocated, fdt_addr);
 	if (!efi_novamap)
 		efi_bs_call(free_pool, priv.runtime_map);
 
-- 
2.43.0

