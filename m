Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010050.outbound.protection.outlook.com [52.101.56.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B67372B32;
	Fri, 25 Sep 2026 12:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790341195; cv=fail; b=uVo9eapUc8gkNt/S0iwATzKVP8GqJMsRvW6/6jOsDnG+WobweOQZ97kob+EZfcylesG6K76kxkPdDcNyHnkvW6DMRf55IYFkvVyTqkLdg1wf+cf7D2+ho89CGkT57RvELs0mAqhPM/p82Vp3oyW4cI8Y1Gs5YQ0fZsJkjrtvJQk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790341195; c=relaxed/simple;
	bh=WpGgiEq8wqSwxnmhWYP6UhPVHQBujwWNo0Rkhj2AjeY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NCqloO3GWo9KsOKZ1ynV6Nb15I/lecAV1NmLTdbqmmS59mocpEF4+jLXO3p95BU/lm+CVuL4to7M0XXQznrcLX4Z339thZpA4Bilu4GWzsKSLfLW/jK5XgehXYiXbvzRkULi8NDdmkk15wGUgczLDr4Nopu4t2sG9a40Ow1HXRc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dAro/vxC; arc=fail smtp.client-ip=52.101.56.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dAro/vxC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qZWVupCuy1DwI4CBNHC7CR8CBgPuxhnKLzQtjP7hpKgZ4o0e3w7BGItIWlQlOUGS/CZRZ0S3ymgH2eembZ/pPbNClqq21j+Er+DK9p3GZMABXoirTqC64RnvZ4LuIeinBcuCyE2AJdWNUEzli5xOG5d/3eTgv+3N/4+MS5qcqe2gPoyVFUgmlmvazO5tI2aPQHwQRuhDyPzFFs8IM3D35N+Vz9PNATX3Ai89i9L6cG2B8/kEyC6raZNLJCPeTdWxRgiFhwdrtyaqT/E2E4tX4FY6IkNHxOe0RxUXdqDtWDDXKrrCOOwhNXiEdVUGKIb/n3Y/t6Md0aXotQ/j0U+V8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gY8SQn1sQtQmyRMtW8IO4cO3YMtlEBJJwOS/MpFHpaU=;
 b=Fbo+UowfiYBnYJfoJNnP0LADgV51BnO9foVuy0QX3hjAwsc0ilZyCfxG7Vm4H2HTDPA3uKI5CzVWwkuJEKuAFIzpGaGCQ8EnkS9ntsyPsSUcZy2UX2l7sCfL6H6w3JaCzj6nFoikhW6x2KIEXy9+uQQBJtiBKBAyh6q1ebmHF0oJCdt3uZE9Qvx/EAOe8NHWKp2x+ryc9Ze5/pPF5OoVpdeLVDDi+9P88FbYZASUkehMxBeiMbzgre17F4LCuFNnLenXTIsG8TNB+z8dGX2HQT1+9wQ5qq8Aa8cL4ZXfweUFMsWUvMMWc4qBkfP/6AlIDMNwt3SxMAyKYniIlDduMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gY8SQn1sQtQmyRMtW8IO4cO3YMtlEBJJwOS/MpFHpaU=;
 b=dAro/vxCR3ZysiXSqcfYvdmk94K9u/NZexZ6kKGDTdTd9eCKk5xt07s3/W4NoUtfRAuv98y2qQ7jD+pznQrz0+0jdYaTNBFYHRLOMLRYyOPgJdo0GWuWEkLdJfIcbCn1b7pKxHKDaL2Z1+vq6tfDua/5Q3/c/drwXWbEGTdw3L3Vk6KPeooRcM0z7w54KuqkyD8x2EqV9jH3r6h8REx1pEqx+s8VrjuQA3643Y9zjy29viTAgzzWWM+3d6s5neWJpcwV1ZzZNMqIaFq8+feKh1IzoKtQSoLfvYjAZGK+GmZxAxe6oe9lWHdKXXl6+ACmdTtrb2PNvU7ICQoYj8LXng==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by PH0PR12MB7486.namprd12.prod.outlook.com
 (2603:10b6:510:1e9::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.19; Fri, 25 Sep
 2026 12:59:47 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 12:59:47 +0000
Date: Fri, 25 Sep 2026 09:59:45 -0300
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
Subject: Re: [PATCH 03/16] efi/libstub: Free cmdline_ptr in efi_pe_entry
Message-ID: <20260925125945.GN9354@nvidia.com>
References: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
 <3-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
 <20260924154902.0000528b@oss.qualcomm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924154902.0000528b@oss.qualcomm.com>
X-ClientProxiedBy: PH0PR07CA0085.namprd07.prod.outlook.com
 (2603:10b6:510:f::30) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|PH0PR12MB7486:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a3586fd-cb47-4951-456e-08df1b04e0de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|7416014|56012099006|11063799006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bd45l8a6+3JSVM2BocLqRVv7s0WhaFpc59mAV/8qTDsagbzKgkVbvdEVXW1sMBa2DtT9tZ1AiShZOCpSRu5Zj3j2AhXLScIMYDwy+d0KIsoSLn0zI8u8k3+awPmHOEhG8gaY3k5pEZ1RAP/diSROTUd3u6CGOiujR76ovRZFOZx7TP+S9jSoGj8RDirT9eE03dK5QjR/Vn37ZZ5Upvbbt/etpF+JcICPuWgNKtTrq33AGwpiQilQCJmz8qprQDcPUoDgbohasaawwYyKyJp/ETPADWVsx9j6gyY0EvGKnR86cNme9EHK7l/fYZbhSQlR8SmBTi3/n0/SIs77bzwInneLyVBx4jWf4MPi9/6Du7DxKGljbjjKxguH4g7fHvGdgv8IfAGLMXmfIw9ac+4EMvBeZe7XRFezSrcPEdvyTYOSituT0CkUQ4pqIVjoSHe81Fr1VF/r/ODu0KswagC8/oHwQRPSJbh1OPdz1KnMbeoISTeJOR/0XjTAMXd4b1elBbg2iThKJbuLdMPoc0OSvoAsqC/80bbJZ0TARXgLQbi1qeKnAB8ON7BAJD07NkxUD8g4BZ3F8kDkLZRxlF/7/TzDe/nS+pAGMntGMVL1p4f+lW6SfocM1N+JjlGcBKNaToI6NsJhTSDkU4vGrp+DDpdj4vuRwQRAHIssPDjzhJc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(7416014)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9174e60iO/U1g2vZ34+JVZRfVBLj+NAIm7nRH/YwZwNVfhJyAbrm1bHjMdZf?=
 =?us-ascii?Q?ffWUPxXQJEGrZEw9Hml9OnFNdngQt53rziqJC4aHQ5iqVjWHc9bIz/GtN4vv?=
 =?us-ascii?Q?B4GxHLYRFysSBCeQphSman33sH8DVs+myRI4NZtiNtuXq621Nn7KUcBe1HgK?=
 =?us-ascii?Q?du1P5O4/x7Cla72X1axPbKPKJTBoRd859f7e7fXDeQ2B1Tzv3hjIQ5MKS8Qb?=
 =?us-ascii?Q?NJBqndtfzF2/Gm54i36G1aEfInRmtrPq9QdWAE1yZm/bnuuGDNo2pLNPGvGX?=
 =?us-ascii?Q?OFHzmy/KLPDJ/QgZ5Qu/QLY0MJoV/zMFjfyQfDV5y0ehoOIsCZA+PGG0IWYC?=
 =?us-ascii?Q?aixnPL4OlbQzUT6jfUj0FrMLNJGgiLnGbGyER1RVqF5pepcnN02WyzIH1hlC?=
 =?us-ascii?Q?iwuZ9T61cIMoAXnp9fgOmKScynErK2eOIT1tPtDJNUsQQ8S4uuFK9jh73PWe?=
 =?us-ascii?Q?I5HY/W5T2r/RAdgnqjILlF8Ev8Cz0zEk2OhKOygXmyuTzmuVkh4TJMBp5XtL?=
 =?us-ascii?Q?z2dnugB4JWpr1S3mC9/F6IRiB1f+uawUZjG02WEWB+LZeULs3fgfyMQSc536?=
 =?us-ascii?Q?fe3hcEh0PHhle+jiayup8aStdBzI0CgL9Y1WA+9U7xWY3oR5i3xcimVKUPp4?=
 =?us-ascii?Q?pwdXcF7QLuaZi6ijhbieXWSxAOX6grSuRJ6RtzwPGANkWgZzF4NYfmh9mZkQ?=
 =?us-ascii?Q?iMWBtwRzlYCIlINoCduoRcXrjaXmX/YJX3A8grDURVreQNu4FM9ySVLd1wAd?=
 =?us-ascii?Q?zlFDvpkzDCqWN9I8Jz1p+/dQlpYc5xXT2/qF5W8rqYmgB07Lr04PHk5IrLyN?=
 =?us-ascii?Q?CGF0OaSTFvV/q0+FFeD5I0uh9r6wrBmi33GdgtDyr1h1Vq/ThnJTm7wX1Pjf?=
 =?us-ascii?Q?D8aV0c984VfrDkUP9oXjwgRsLT3glCdQTb+uQjzSkkIQSpHs+zyHTrlT9/+X?=
 =?us-ascii?Q?bpZ28+Avnk4MDrxWRP56GBr7Bi/5VSHLaT8kUHg58+tIAHQz+T8T7r/7BYG5?=
 =?us-ascii?Q?eaioQuWBDDzMrEHet4fakLGZkD26P6MwRT4f2d9VI/b5nUydhhQmkZzSiX9E?=
 =?us-ascii?Q?I1j+lCt+CDmnpq/0GlsVc2gaGaXQ9ZW7hVstNvciXslbzalfWLqwDcIWfzK7?=
 =?us-ascii?Q?mdmiwzr4aiBw9KaY8l7YerMRsJLg1U2rE95V3yxeHYdn12dlP80Yq+Xrd7i7?=
 =?us-ascii?Q?U/pyOuGtME2v+sWHZGPpFC/+bMQqS4YUaHGavmowk9KZVYBtbDiy+aO89A1d?=
 =?us-ascii?Q?AntFQAz2GaRicz0BsqB6PTNHPUUnKcl6mHbPhVMPBPcyRYVl3suhJ2lSYEHx?=
 =?us-ascii?Q?4gP76lzH12npuPFn2Gijbp9KeML+HZBJCLU8eg+RXEU0wLAYfaJvzBDo/UyQ?=
 =?us-ascii?Q?uFt7NlzFaIv1+jpDw4ojY2HeaHgYTPiXPN3K5KZpRPm4tvVHkPSVgAORNIz3?=
 =?us-ascii?Q?S0uqtFUyDT253F70hpenwSIFc+SoP8OFGDkTWwK00XNN0+hgDkfW+RIME2M5?=
 =?us-ascii?Q?/rr9v6/RaDUtoqY5GaODwQIm+B7msRBbvTdkejy1BGq5GS4p8WwSQqDxpihy?=
 =?us-ascii?Q?mAWfvUaeurBa0WqdFwxS+AOk5GCfNyRTUohREyV3ULhUSsOUmJyEwiRgYi5k?=
 =?us-ascii?Q?ZFCTPkg5R4LkJY7+/V7DS48TUFZSvi3QgkjoeFbfyYEeYyDMag63K8CRzqzT?=
 =?us-ascii?Q?g8uqxkl/ru06E2OWs4e3RZtS4nYXnqIxHP38120FXHxDkr4c?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a3586fd-cb47-4951-456e-08df1b04e0de
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 12:59:47.7080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jhVtn7Kc9QS1xKM8u+Y+7p1hOHgu9nCv44P10gaNRBrkW+BhX3dGHJPjW7KdNT8d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7486

On Thu, Sep 24, 2026 at 03:49:02PM -0700, Jonathan Cameron wrote:
> On Thu, 24 Sep 2026 10:53:06 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > Sashiko points out that efi_handle_cmdline() allocates this memory and
> > hands it over to the caller. If efi_pe_entry() ever returns it should be
> > freed. Add a __free annotation.
> > 
> > Fixes: 42c8ea3dca09 ("efi: libstub: Factor out EFI stub entrypoint into separate file")
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/firmware/efi/libstub/efi-stub-entry.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/firmware/efi/libstub/efi-stub-entry.c b/drivers/firmware/efi/libstub/efi-stub-entry.c
> > index aa85e910fe595e..83fade2b0d3b84 100644
> > --- a/drivers/firmware/efi/libstub/efi-stub-entry.c
> > +++ b/drivers/firmware/efi/libstub/efi-stub-entry.c
> > @@ -40,7 +40,7 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
> >  	unsigned long image_addr;
> >  	unsigned long image_size = 0;
> >  	/* addr/point and size pairs for memory management*/
> > -	char *cmdline_ptr = NULL;
> > +	char *cmdline_ptr __free(efi_pool) = NULL;
> 
> Can we move this down to just above the call to efi_handle_cmdline that
> does the constructor side of this?
> 
> I see none of the efi stuff follow those guidance note that went in
> cleanup.h.

Yeah, I stuck with what was there.. It looks kind of weird that way:

	char *cmdline_ptr __free(efi_pool) = NULL;
	status = efi_handle_cmdline(image, &cmdline_ptr);
	if (status != EFI_SUCCESS)
		return status;

Jason
