Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010054.outbound.protection.outlook.com [52.101.201.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1149A3BED2D;
	Thu, 24 Sep 2026 23:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790293989; cv=fail; b=LXrM/EhCXyolRY4oLO0QdyJR1tTJf/P2EIwGu832SVlTMSe84vypQ0qgZI/nviRXAFeE4y5eeakgdb5C3dhUmvRTV43cUQYSc8LyDJ0me4K29mzQca+uPFBoXozxhkb18tfb4Ew/670GZSfvh7QyK0H57MEKZUaBM1Se6JnyJYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790293989; c=relaxed/simple;
	bh=dm2XjwZJB09T0L+IuOV771bgetdiI/vpdp6Zj7KftU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XFPFmj/qKMoy8C87Yqlb7oR4OAHYgDzZYMCBX0q0hT8ZtLTWTQF8GfnX/wMGM5NTRODvdR+o566MvQcr3zvqTECp6hXN5xDJh3e4uVvSfY4c/4K2/5HJq0WoBSVsEeyVz6i1GYGkttrlmwoxjLYp7vourgkKIBpCN3XnVDQaTq0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sK7ymlln; arc=fail smtp.client-ip=52.101.201.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sK7ymlln"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XTfVj5rs5R4j9cGmeMsWdmNXXm9GlxyR6tFa4SPvcWF/T2+EIzWytOexFNzeIe7uZbgxfaVEq9c7FczZy7fD/uiZaIWHojtfFEqvUnruAaO+YDa0RjOxZGUkhYnMxvqfZNQBbhubtE6N0pxN56VLuRMyfjyPNG2ztUQf/ZQBFyg+jjyjTY8FE3CGhJeAtnIyjpqkjYsdabdjaYWYBY9Bnr1z2rOmSoR+PfwXUA6dG34fpsH+MTrDo4j8HBZetSnr8YrhWFedBFOd3J+GP2/oaAakW+vBn3QYsugoLkcmJqW2fK1wsdjW4D51bYa4mgsHJ0N4DUxlwWoavggF+6gw0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=toGtRNTsegMbCpUo/5qafYKG4Wu7JkiAYWs2eJ+g/1Y=;
 b=ChqDgc/+FsDjFV9kJW31sfPlrvu+DXtZFMIEn7rkTKqgMOE2C7Xvr2Smamr0ufpGClnAYa3Rm3U6P9fLSuwhoNhf0klxiKuZAqm8VVHELBmJpczgRJ0dmityYUp0J7BPYNDM1LHfX5KKBF3XLaiIgwAWN4i0K+TzBpbE7qAbu83U/hyjH4d7+fxMVLkDX37FjRsqU2mpKI3kWoYWFbmU3fjEcpR/3KgoiXSEJF/G8K+yc+gK2mBtD4PPAuOtEqiHls+UAXWpO3TQ/TIpFEyB/LnLk9StLSeTLAP9Qh+SB1uwnkYcg+j6FBlEePcnocSyOoy3z9tgAOlxG5VqzXrUQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=toGtRNTsegMbCpUo/5qafYKG4Wu7JkiAYWs2eJ+g/1Y=;
 b=sK7ymlln/W3xifdSAwxFeVVVLqxHozGYbzozQhjSKe9c9m2A4KCgfnc1LBA8wbdyakkAunX5LjN1oqIBZDZXSj5sLHIznNe2HMOnkUcvmLtPMiQs1ImF2VSID1qp3MC9M6ZWUbPIaMpTjCCqXHq/Y3fS7k24HpqfE9XNMmluwjcXjRPYQaISj7cqT488jFZVAgntCnR6xwYsEs5Cx0ihqP5yIBHifI6yxAAfpMHLlCpPR/e7RrsKnjKwLLqCaElZa8umxF+qp2hlD2h6d8LXEkQJmOfe97jz/CqbGuVbaHELPDAlV3A8qUfidb8/1xErk2BjaJryi+9oKhXDHa39CA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SJ0PR12MB7473.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 23:53:04 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 23:53:04 +0000
Date: Thu, 24 Sep 2026 20:53:02 -0300
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
Subject: Re: [PATCH 07/16] efi/zboot: Lift efi_cache_sync_image() from
 efi_zboot_decompress()
Message-ID: <20260924235302.GF9354@nvidia.com>
References: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
 <7-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
 <20260924155721.000016a9@oss.qualcomm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924155721.000016a9@oss.qualcomm.com>
X-ClientProxiedBy: BY1P220CA0007.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::13) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|SJ0PR12MB7473:EE_
X-MS-Office365-Filtering-Correlation-Id: e9bbe4b5-774d-46b2-7fa4-08df1a96f98e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|10067099003|56012099006|18002099003|22082099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	Wa6Qn0qOqIFMBvOsiPr7f15pVj3A3e8t3MsU+LB98BOtaXpb6bw5GYxwRop3t4QnTjNG9TaFYQ2MLFXEfxFQYWAWIdDT3OHmUuT9d1GO9j3j9alGW+sYiYh7DIA3Q/VuUiiLcd+LWOoBKQKYOH57Q/Zl2D4RyAoDW4++0+IOTZVzRpW/kxD4N/DPxOb7wGmhUtSQpGtIitHAl6X6SWLgrtDLsD7IrqwCiTmSZMsH6JQ8pw0vBC+AyZLZxIjhV73CPxb/akwDvEdQT9E33uU1sBmJslGPUl9g9I7SMcG434KCpNI0VcggZNDkMQhvSx5EngZQRHu8NaEaN3AniBr7nhuMnRYZCbYa15WzZOt9sBH9+bq5FMonxvKlEiJwTV1l6B0iEpVq05HE8saMfNH4DCvurC6WQFzxRx13u8SID5Jm6MkhzfxWwJ79jDBJzoEHX0aUJ0QK89Lf7oqQbFoW6gHTWF796Mwps00x4dA+MepxX6JpH4M3z97PuUsSq/9PpPTqMBc1o4t9XYhOo3X+50TVni0s5UsH7Sm1+iTRYnd/qiW8ced66aj/Wxb3yP/emlqDVQcFX8HvZncYN9LFBZ/aCcPowWrCZlCU3X9dk69wQ25g+rSeHe+Gq/bMcBwlUpXekhocz9KtaLugN8mp1Gw4mAY8fbfMlTtndIiaCJY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(10067099003)(56012099006)(18002099003)(22082099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GfYsDyn0NF3WgXk09TNrAixYS6tnXtzqyFtkPfF7jSyS7qqf8UbrU7XGsIto?=
 =?us-ascii?Q?Me4pL0lhUK6ySKHucdWTCKwVRyfowUSEQrfttdPwphrtktM2eM1SEDoYJeA5?=
 =?us-ascii?Q?PK3xruw6Oj8zhDlK/lpFDkfkw+XJtUCJwXa0mgQ7CVOFN3atMiSyX0yVx4rk?=
 =?us-ascii?Q?UytemhXtYuY89yUTk9B2XDyOu1QRNRCbSkMa5X5RECel/ZcBR0xNx3Sm3Zp+?=
 =?us-ascii?Q?UsZOODmPkGPr6NBUROwhR2lQ/cQpBWrUgEQPsXWjVEdgM3jUPhMj33Sr4opC?=
 =?us-ascii?Q?1rC9e9GPJpr/WUC9Kijz1wBAy9Y+fBKEJmACXAHk4bmyPzh8zeT3cUPh0uDK?=
 =?us-ascii?Q?DXjXeG+wF3eXGb4G/7LkliPDGiKDQv9cUgPr3wH0QoGc4otax4teVyUbBgwC?=
 =?us-ascii?Q?IwpZvkA8CZtcJmnkhdz3qkEENREgQYWlWDS00tyecxvHjglzfjrijkLyMOAb?=
 =?us-ascii?Q?NlMNw3fwc0Vj1Q+/JZV9g4JLf30Pnxq2Dg9Kht0TzFZej5rBdLzfDJkxgpGD?=
 =?us-ascii?Q?mq2asy2ogchDv5LYux0QJl3+vWAVNr3k6q1Oi7aoHgGgP79i6AuxKaAqLWUY?=
 =?us-ascii?Q?GGA5BI+D5DBHHle/E7P1ReJFdjxlsLwHHlodJjXmmiC+H9dIrUS7SMvt4pg5?=
 =?us-ascii?Q?pnwLe7HMW4f/kZh5VRU4MH8LPYYsnBQa3wXPe10qwc80uMu4PefDHAWlGDsv?=
 =?us-ascii?Q?WJ0x2BlDNzW88l5jL4N06vHLJtP55Siu5U1BRkmSQdcusX6Osd8Pk6fb7/KJ?=
 =?us-ascii?Q?90haOAaI+rCH/U0k5EZ/jfbmtKVuqrtKImjdikd6XtjJi/B7t7vmT1aorbBL?=
 =?us-ascii?Q?a3AzdjauzuEt84sJfROgVqun79vsFusKrkG7V1y46e5ZChgHxch47SAoJcjH?=
 =?us-ascii?Q?Z0wEyAQgQu2sHt6hKo+vCJNCzsckwAyJQ5Wih+yo9vCwM4OdicBfddZSZEVI?=
 =?us-ascii?Q?UvmfHg2YSTt7uE1vPdv7Kgf/xi1F8s1ZmohSbTmNDyikJ50vRbjo65VBfOsC?=
 =?us-ascii?Q?ops+74YDrpI92sJp4dA+SD158tRmLQJbxsyX3or/ttEL1p1w75YxILrEpIf6?=
 =?us-ascii?Q?6ZA158ZRA0k9XYFbHbbBTg8ETYJJfRUVBEFE/I3WKeJVu67GQr0/x60SKcDE?=
 =?us-ascii?Q?jxk2+mMKPnd5vdN2oy0dnaB/vyzBf61P+lidinXp0aGbBcEbGEBYdr6RTq2l?=
 =?us-ascii?Q?uii4loYacYt2AhdnP5XCYu+RDVi968PZzSvUJ7MzlXc9YDhmWYemFrbFai5v?=
 =?us-ascii?Q?aVk4g00yQjVyARJfv7abFHAUXDFOaOzcYhKB5tiZ6N+2OJJvzXIVG3fWzzqN?=
 =?us-ascii?Q?pV1rcifKpv67COiW5D1EtGnfWyi47F3qtc8IKwXX/ch0xAqeiqZ2h7QNS4ON?=
 =?us-ascii?Q?D8SPjQJjgmB7sXIsoeMnb0cCkVFzSB1XTV8WzkzvFUROgx/VVc7U+9pUGCHq?=
 =?us-ascii?Q?kyNAwXXlqx0Tfgfk61pUzP8DxFnXyC9RTKroHxa4VD0Gp0HcA8D6Kw7Nu4E1?=
 =?us-ascii?Q?TK3rXCIusewynmCXAQ6gIT/oDNOMnFk57P8mEFLX9lODwxTepanPcbFJviT+?=
 =?us-ascii?Q?SON1vNS/rOJKElXLbIolsgEAW4LrRRWmAukvHW8pU8VbzXokoDxi6hC94wRz?=
 =?us-ascii?Q?mlcRVkfS2/SyzVW6XOwdcpKZ1cxK0kAvSTbJdajjmRoXcjHaJQmO0xvACjsB?=
 =?us-ascii?Q?rEKE/mtRRSE8Hhre6UdMr47OE3+gmndE1CoiW9yv1SFAyiUY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9bbe4b5-774d-46b2-7fa4-08df1a96f98e
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 23:53:04.4843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rUkBTxJ77XbKUDiQ8XW7CD3ptytBO+1M5VFEZ0mY+tYRz8bMKFNxVkXL+fqYSAz2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7473

On Thu, Sep 24, 2026 at 03:57:21PM -0700, Jonathan Cameron wrote:
> On Thu, 24 Sep 2026 10:53:10 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > The two decompressors duplicate this call and the next patch needs to
> > change the argument. Hoist it up to remove the duplication.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> > diff --git a/drivers/firmware/efi/libstub/zboot.c b/drivers/firmware/efi/libstub/zboot.c
> > index 4b76f74c56dae0..960a542881d875 100644
> > --- a/drivers/firmware/efi/libstub/zboot.c
> > +++ b/drivers/firmware/efi/libstub/zboot.c
> > @@ -92,9 +92,12 @@ efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
> >  	}
> >  
> >  	// Decompress the payload into the newly allocated buffer
> > -	status = efi_zboot_decompress((void *)image_base, alloc_size) ?:
> > -	         efi_stub_common(handle, image, image_base, cmdline_ptr);
> > -
> > +	status = efi_zboot_decompress((void *)image_base, alloc_size);
> > +	if (status == EFI_SUCCESS) {
> > +		efi_cache_sync_image(image_base, alloc_size);
> > +		status =
> > +			efi_stub_common(handle, image, image_base, cmdline_ptr);
> 
> Just go one character longer!

OK! You have good eyes to notice that! I use clang-format and stopped
caring! The flexible 80 unless you need it unless you are in the wrong
subsystem scares me!

Thanks,
Jason
