Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012024.outbound.protection.outlook.com [40.93.195.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D67372686;
	Thu, 24 Sep 2026 13:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790258021; cv=fail; b=pNcW56qForbM8YrVM74Gnph11h7pkDRF13yt3V+YfWyWqwFOu2JvNknnRvc9L4sk7JfAdGvNwVsib2Mp+BfB/tDKXSoLOjVv3sP8TPE5um8dN3I3xDEr3yV1DofvvFHVZvjl6qESI/FNKmHUvea3NxaZ94P146IAhWkEFzOsvJY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790258021; c=relaxed/simple;
	bh=UeBONd9+F9gmO5i1k2CHjwptu+o/0iy3e/PXI8aoork=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lJ/OliWRvc8XfOxrDT0LsP9j9nLRYyxRD4TbqqjPHAH+gIB5Yh3NIZG+hJn5gZtBy6jEemIoNkq4JHFmZQyBYALYuqd41Opv3WmpaBRcv2b/p+Jlg/e5wLBvGukHaNUNDWIorh1N0wnDRlElPjIfO5nkRfFV4fI3s49j5hNWSVY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sWu2aoly; arc=fail smtp.client-ip=40.93.195.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sWu2aoly"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S+vOYVSB0SoaatAmJiGAMH1vBAy6oJHchuNY8PB0JSv5v04cS/LkdHO7ZJ13axTMrZ3ORI05PBD3elksZpSPOXS6Z50rsPX6oaBwxjW4svpQj1+RSmYgzTrZ2dW5Jg7y+BeY7kVeFoN/hC7kY6sUwZxMQZ8ymzRQbeclwLT046kX/Y6RSs66+ZSG5D3jIxcBTrOeXlKZPJPDw0RMbriZQZFpkB2vqW4zu3KpceIzid6ECBkzevUQfx9h1tNrfnYCQpzi5OoG9rX7/iMkXHj3KzyBjO6FPlgjPIR6Hk8ZdF/gAfzee3XwhKUyW1KTfBMgJf8/2og7diief+y8340t5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nw7PzHQwbEo5I9z07gtV3tA6jK2BAsEGh1TBpDu6LAQ=;
 b=iNLfdXX1d4VbryWo9Nda5alsuyxuYQuzx0RS5U4/pfLuVI2iYFis3Sso3TSyEYe6WoEwTsuyt4BW9cfFOquJ6U8ZXD06ZvKyF0Ha9Y0E622uYE44CHpQQy28gfOea70ONMjpo+HYb6VdqXN/b0EaPMih+1E8qSriGo8vPVzxKAe5PzGVkzLFhd1w4InmgpjorTk/qnh8z2pA4mFBfx5qAPSHHCbp82n35hOqg6KtUJrd/IbrXISrJfuRjI6qgKTogz4IWrcnJfPhv0Ilpcg6+jShbn70u6uNe/7f/2qs6QTJE6YICnlhXAMLOgNyaxkWGcL2hTOS7g2bcDvNoo9lwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nw7PzHQwbEo5I9z07gtV3tA6jK2BAsEGh1TBpDu6LAQ=;
 b=sWu2aolylQzBGYT7L0zH9+KBfbIHYYbqETFtY2RiJXY1NUvReuXcXiwTrikk6q9XCEa46Ou9gK/w6GPpCuYWeE8gv8pKy8Wequ2uGBT3f53aqiKAhbNbdTpoZyVdGfxrUkBNcU0BDXRpLIA17haKJxicaeoO9DaflVtTZryfT4qbR+xbADPvCLS5XpvGy+f0XyP4RMox8xiPbiReDSaO6//4thyZnTO7syHhsUrkZMWgk9+TUarVulG9podzAm+Foyvy9TpzfZYyZeb7a7VYBjPqztUkJOSW7GIEOSH+5bJk3sa8PYAt2RgUA9+7nbWZJTyN2phBpc3SkePrN84jBQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH8PR12MB7375.namprd12.prod.outlook.com
 (2603:10b6:510:215::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 13:53:25 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 13:53:25 +0000
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
Subject: [PATCH 03/16] efi/libstub: Free cmdline_ptr in efi_pe_entry
Date: Thu, 24 Sep 2026 10:53:06 -0300
Message-ID: <3-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0081.namprd07.prod.outlook.com
 (2603:10b6:510:f::26) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH8PR12MB7375:EE_
X-MS-Office365-Filtering-Correlation-Id: 687acb3f-232c-4a7b-d544-08df1a433351
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|921020|11063799006|56012099006|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	G2T7kXUNAs+TBXP0ruIc2AZ1KNs6DXHJW0RFAwsmZ6kozXjUcq/NS2Vo+B9pgXnSChxA12eaQ6vggMgqibfeHK4m1wUSRdBmH4U01pf9yTUy70oGfA5ShYNNoA52HT9t640EMOuTyGcolR1ULaMzLzOSTNzGVY51Nwlf5aIY5lnxtrn79iX6OKw37btHu3SXodObKlWAj4w5XPjVDQsIWWhes6C3eHWGCI/HUTK1LPuo/GyvB//Cq1sk5Zgdv00Tc3nMfdVdIQo905/QOaE6pL4SfwaEt2oOSDh+XzPcCZH3Ib6YEkikwChQPi4m56OYs6SECeWXvBlD4SlGNnv58HviwxNhDdCRkXLfjTfjvDhVAa7sA2S5HYHhQ1afXdr2BJu3+Fze8LPQw9nPuJIvri2btffARsHpxw3dCH/sw4+GcAltpAp21m0cnaJxymNuUPPScYJA9pT2r+u2vfwfXdBqCvZ3KGucfSl5KNJLPbuu0CUsIbggvwifAfTjgh2DvuKbKjMbjw+2RWTps74CcRT6TsnNRj23JgUwaXbvUTY92MoprTR6q2w0HVVdYvat6skaM1Gk8e2H3XBzDNCSJEqFByMLWfKtfX5ZJcxfpya9OA0w2UVsfUyIBK9TY6f9rLxaaRJJqRm7qLmgrd6u52XW6BZC8+2SmKqXUKQlxb9sFjYJN0x0KLDTsndZ7QnnqFykxGs4C5IPYT0Bg8V+dw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(921020)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YCsvxliBZTPBChi9lW3bK1sHJiBCvuwXsUEWR+7iO2Pm5KOXzQyCxPGPI0U5?=
 =?us-ascii?Q?S4dskgAkslnj0ewccp06r9BgqrX0kIrB20YTbiYdaCHZ+Kq4vRMzjXJRot4n?=
 =?us-ascii?Q?CcD/Y07z0D8AsS2cjlaUG/cWCRrQTwk+1c657Z7m0dSOABAN610RaU9ijbln?=
 =?us-ascii?Q?6C6IZoKWv5dVdxBTcf1OzWAKSsa0PuywdcuS/WDFrGGRU/MPGl6yrZjjyb/E?=
 =?us-ascii?Q?M0+0KsywyJimDRYYdp+AHXS0cYX+0FSlHKktAjNjlgFaBjDOEdtkTqS1JpaY?=
 =?us-ascii?Q?IaUl/3S8cqfqL3yvCNt0tONy5HbkAwtbPZkK7U5TG9bNs2lUJWOdVGnvZEgF?=
 =?us-ascii?Q?jbsYvnjcS15Wa48qkVkT7FZm3en+iAcdodKA68TIDj24S8e0V+SEIb8DqGlC?=
 =?us-ascii?Q?jsryYUZZUZjlmTMeUumKhn9RRBrq+y8N0QE4cQvDCGD+aVKXljW9+QV7AdRC?=
 =?us-ascii?Q?bANtU+bUIOcalgkOtdR764mOAllc0T3FFyIQJulXIWdhlLUB+/+07Yzs6b3Y?=
 =?us-ascii?Q?v0ePPT4BlppN/5D3fuuej+5O/LNu2MaEZgkDw5tSSgAi1fu/s+TWbKda/By7?=
 =?us-ascii?Q?owPdJ8RODWGQ/ecrIdYZDY4AXXZJXPz175D2jINU8CFKtcqvxyHCkwORR9mB?=
 =?us-ascii?Q?Jo1HqzkFs9h/qXocAx2qg8AGyboAbG+Wbbayy6T49vFf7yyMabCgrOYjlR6c?=
 =?us-ascii?Q?xzQ6MDQQVBhYvid2NBjT3gwrEr8alvltyDHqg+Qod2eMB6y+68ODaP42G/Ge?=
 =?us-ascii?Q?0KPUCHGh/zqAuwLh4a8hfaNYUoVhZaDRRqjDG6W70ybYHIEiFjWgW443iCyc?=
 =?us-ascii?Q?qhFnODrByTGQL4lFIbcK0JDi5HXJciHw1RS+rQ6hjo1QHCZdWYqB/8/884zZ?=
 =?us-ascii?Q?M0aqJfPEUm+PWJaGE/v/Lafpr/2pA1GLd+FoSg3u7MKHB5RWe97mCanwE00l?=
 =?us-ascii?Q?y9lYmvtg4q9NL9EBCxGW6IFV3vjAcMXg66XmiEo6rgLPCSj4+j67eyYyrmb6?=
 =?us-ascii?Q?WuD0wVa5jw8FJ4L0Vil/kYFHkBkp0vs7fdCZsgr3aPJkpM/PiLzl4c6FtjJW?=
 =?us-ascii?Q?uJgEScHZxyIIAUwNvwf7MGwzfyxvreRsrFPCyqOW9hWJGICTndeyJorESJwt?=
 =?us-ascii?Q?S473SVQWzuGJyZbEnLprkJLFpcAj7ra6xGOQwn+01W6qs2ZIy3LARR7A/rsn?=
 =?us-ascii?Q?Jpi0wsehu/x/ASgrNwMxz43KI6RL3/exA6t3cJZ797C3bym0MbvFl+DaEdeO?=
 =?us-ascii?Q?fNGlsGpIbzMq027MJ8SCgGk/HOtJfuyo35VrHcb7d1UvddAeGIgL90tLl8/R?=
 =?us-ascii?Q?MkQ3gFPK2AN/nPxQ7lt2bWSyIJIuqWM+xZGqXGtN4L23uMPFiTeb441+Zl+5?=
 =?us-ascii?Q?OErKaCLuWA7bQaQ4WOhAYW7sDq88V4exic0JA6VRoVJsJiADgWDHqQwLTot1?=
 =?us-ascii?Q?r25VEJQYyaccukMa9sD5SPQuhTNCscbEs0vw/vLFIWtqk4UkzsN3kV6IGfn8?=
 =?us-ascii?Q?gVgvkPh+G1/XE8LGgUS1MWKZB6jpuDB/lNtZ1t90/MbhPsCl9+rcCENN/ZVj?=
 =?us-ascii?Q?x5kdl11hD461Yoy3aWCkpkHTVEvnZAF7QwVkwvcfD6NFV450on/vnIbe7hek?=
 =?us-ascii?Q?h27EnPYi8w48mygRYqa4OgGWRp2RrocptNDpp8YtcvzEzePaW36HeJoJbZcb?=
 =?us-ascii?Q?bKPHMMR4hCD/Z0UJKYf6kh3DHyTaUq7X3MTAWcwqBUkqYLOn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 687acb3f-232c-4a7b-d544-08df1a433351
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 13:53:23.6960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VbqVU3mEckO0CU1fJPb3Ndh3LaR2Ytcn1aeOq0N83OfZPmmY5Rq78KQsm/o2hut4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7375

Sashiko points out that efi_handle_cmdline() allocates this memory and
hands it over to the caller. If efi_pe_entry() ever returns it should be
freed. Add a __free annotation.

Fixes: 42c8ea3dca09 ("efi: libstub: Factor out EFI stub entrypoint into separate file")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/firmware/efi/libstub/efi-stub-entry.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-entry.c b/drivers/firmware/efi/libstub/efi-stub-entry.c
index aa85e910fe595e..83fade2b0d3b84 100644
--- a/drivers/firmware/efi/libstub/efi-stub-entry.c
+++ b/drivers/firmware/efi/libstub/efi-stub-entry.c
@@ -40,7 +40,7 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 	unsigned long image_addr;
 	unsigned long image_size = 0;
 	/* addr/point and size pairs for memory management*/
-	char *cmdline_ptr = NULL;
+	char *cmdline_ptr __free(efi_pool) = NULL;
 	efi_guid_t loaded_image_proto = LOADED_IMAGE_PROTOCOL_GUID;
 	unsigned long reserve_addr = 0;
 	unsigned long reserve_size = 0;
-- 
2.43.0

