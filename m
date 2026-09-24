Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013070.outbound.protection.outlook.com [40.93.196.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B2241A92A;
	Thu, 24 Sep 2026 23:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790293509; cv=fail; b=mOLS9R5Eu+nuiXxuHFDNQzP3YTGcrC61FxlL7VPG7NJYU5yhUeJbmJ1nw1SwV+mKXpzkXlbzvruSpops3IpwRH+cZKmAGM05MCwFw4FXxeGydaXCOX+J2pft4X1ztUI6wYaJjjAFHGDGWneNk5z1QKSgJzrFeteIQfW3aQtUyNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790293509; c=relaxed/simple;
	bh=22DgX4VmtSMie25D5Z1jWlLd5cbP/gcLoW4Xyzbw+s4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uCOK6JsASeft5NPuNTVSNrWHCnBnqos65h9iM67gTarY1Ellq8+2zuXJLmGVZSVG4omvcOGhDs3R2Lb+UYQmjQDBsavLuScyNyDuX7tY/KDBWbvniSundMeuxTLbC/VJLP4UL2OH034g0EhClu8oC2f+E34e+PmHGMa+7npsx+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WC/qhUAe; arc=fail smtp.client-ip=40.93.196.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WC/qhUAe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kQHKU9aKnyR79094OA/45vQvp3qHboDkabsF6TTBJzxEADX2PNE9TGkwusu4hOJayypBVPCsfGqzKF5kmwNbPrmZxINPBT6yIeU4iolCJ5NidSAKJ+Cll/LSysgfpyPOgFiQUL/C2aXe0QN5gBHEGlvBkYj0OGaT1gddc5bE+jwc11ZfmwlNcik3MWE9Ev81n0xGH+WQK5ZvurPBtPMDX7lxv6Ifs3AUgCylRfqcmS+ozoaZNxVp3b/WBx5roLOHvF9MyQl0qbhFZ4gb5mAyRPyJKySTTmfCqv1UJumEQOZrFVUdG/nPCJZ9+kHjHYKn/hgIxNtWycJSRnenGT0dLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zaUI6T+DlcXrBhQVMPTTfZX5DUPSsfm8m5KwoTkD+vs=;
 b=WhxIf4ltQDYtMHaZ4rlyrUCKENypb1StPSTe0IHIre2lBUpxAvT68xqXwczA/g8j7KRbdk0sFBax7mHWDI13dt+1piHkhlmBzhZ/V2+XllvyOAeeDhdTNFsiPG5x1RJEgtM97XmpBXzzpFspYmjl7PfcgKrpxTQFjFUDB4wlX54NpiBHlenM5mCGTevvZZAohrLqE7u3Nl7GkgIuSS6OsW7IX+WRfyLqlMWsdXFm3+5Nck67AymyaBbTk4cmlegKisksSKEPiJ8adXXn50EMs51LCqitawMO+7pLCpYZ8EUX5aDOrKHkXV1P7l4halWZaV6SvNK073x/aFVM2sj8Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zaUI6T+DlcXrBhQVMPTTfZX5DUPSsfm8m5KwoTkD+vs=;
 b=WC/qhUAeP4TPL/Y2bwblrsoScX6yHGqrFGAUOUygblw+1nzWEJWuYpB9Dv9bRbI3C3KAkihfzVZAQNRUjPmo3r+wQjfYon/etxMlYUuv0M8ZX85Hvrj7SSpuRlW5XnbzFerQhIdOxo/+r8wRZwSoq5vdic2JS/B6u5n18gU89TgJ0q06Cj9kMayV+KCIYXEu0/JB0fJKGFndm1nvOIfs3Uh2OP1LMv8+6yJQw7+WWeuzYskGLb6H+kF8AJNpo54VGCZiMGw2eTANyhctXFZ0TpZuOJFFv2QsaOHkRQt9MtXTXYV3LKh4hPl8lwt5gQJRD6oCa+cIKyTWlcI0247LaA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DM4PR12MB8557.namprd12.prod.outlook.com
 (2603:10b6:8:18b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 23:45:00 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 23:45:00 +0000
Date: Thu, 24 Sep 2026 20:44:57 -0300
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
Subject: Re: [PATCH 01/16] efi/libstub: Fix error unwind freeing fdt in
 allocate_new_fdt_and_exit_boot()
Message-ID: <20260924234457.GD9354@nvidia.com>
References: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
 <1-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
 <20260924154227.00001cbe@oss.qualcomm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924154227.00001cbe@oss.qualcomm.com>
X-ClientProxiedBy: SA9PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:806:20::35) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DM4PR12MB8557:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d87f676-dd23-47a7-f43c-08df1a95d8c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|4143699003|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	+GHYFjzfFhtiVupEtlEKlxObjMKptfk9wmE0azv3SRGH4JAKTbb2TVg5IBfpcz046QLZbClGE2KDKJvgEouV5NEH47ZchHohJIPBs5/9Zjlx6x9KrWF7u1RzXnK2k/ozrFhbDebQkksMKIZu5QPWAaIee9lO2ulABQkOfzv41y4itPoekVGEbU+dRjhIZlm9gTtHRmZIKBhPgBOaXjC7Btiut/1bjrb+Se/xOPUa7mlKVnpQm6REwqMKU/HbJ1CamcABH+igNVPWUoh7d33l4hXtWKMquwHhtEKxskyoccJc5L97zX2sXa8Vc/VRuZmEmLeegSLd4lR2DLJG71a0iX0MHMi3a7fSZKk7yKYLXtlJGdzLfmprX6dPYcRJ7QNerQEPUYC3hW01HSoIcB8xsqOwguA19avnzPtBmzD8DEWVNlFt7GEM9414RnWa4SmT++ZCuf0WsnLidW1RSxqZsdFHGAPf2Fwd4Duz7EAptpqgGuhckFSQ0U3D80qW2osyF1Y8SJZmds/44KFNiVYLZxFYt2f/mI8cmIbEVwDsaDp9pF6AbcZAVs/qRfwk8MZJmyauCugG4Iy9qnDRlTYskaEx9lbs6vwuTe/D2ZnBAKwiqwmhNFl9YZmDdkNPisE9YoX7kIpOnqTJxOXDCS3TfmyeuyrAF2SEau9m7YNxwSQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(4143699003)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GiP4uo81wIEbgVQyRjhtYHGFZOl5PkwNCbV9+UzlfLOUy1p71iC9poMQ+6yG?=
 =?us-ascii?Q?XEE6UQspoKJ/ZW1QSputOLGZPnZb6c19iN06FvcuDLLg8jHpa4+7/Jk3MPUG?=
 =?us-ascii?Q?Fjs8SRgEp0C56jqXrDAyw5EKtr91+e435UF0E1FJ4t5i5Padl0IczNqr54HB?=
 =?us-ascii?Q?+nMHpUM730vJ0NnegeuPRSRtBmOh/XEajPGXOUBu3zt8SUOevJs1DNcpgjh5?=
 =?us-ascii?Q?8yjFsdrrY2uiRCMr/S7HjAuNQ7eqv5jgsZ1hbNRP9B9mcPIm2RMfdLZI6NVx?=
 =?us-ascii?Q?7cwpsWqj5a9eDCUBJmb9b1LsHvbXUI94BzysPyeLgxp3Pwi6tqdwVm0OaU0l?=
 =?us-ascii?Q?7zeE8CI2XpM7U6WA5zYi+atObgg0+TYUCor0BfkpiOsQUmd9o20ntsMWMTYj?=
 =?us-ascii?Q?hWMSl/hF8MmIUevAnNsjBzvLTeN00VjoKLzvKKJOywRHFj0lqPiWZPVjZr9M?=
 =?us-ascii?Q?hTG8D/mI6FMBDLofCk3ACKiKbI1PJPjp/Bb9QCjaamxGQNG+RXN8DpLtBMgl?=
 =?us-ascii?Q?apwFLbeaHGsITE5K8Yd4IvtoN3AYWAhQ22v8WYfJm7xvgEYw+Sv2nLhJwV5d?=
 =?us-ascii?Q?JXjTTpqhaD6yC39rtm3/bGT7yiDYkdycfFUmJE4aeSOzIwpcDxhp3EXmLsdZ?=
 =?us-ascii?Q?VL1tL/5i8GIWwF+doHM0z4AeK7fAMzkm/veOOVwuEEEONGY8hYljhNeSmYUh?=
 =?us-ascii?Q?g47yg35lprz6+k5K1IrKianmnwIZQF0CS1HBGx9n4uqJC7cdWM13LAiLazzV?=
 =?us-ascii?Q?nN0+YbSJn250Fo1GXui63GfL2dv4YtH9i4ts/nYyvWBU+f6ziaRp5FZA0s4M?=
 =?us-ascii?Q?dOq/kCMPJPHYPCo94n1ENpmm6o64mx8FC2orx6yCZXG7BRVjXabBImVeJ2kd?=
 =?us-ascii?Q?9bMa6CorxgPsUFM4HI2O/pKnPbjVD7VurS8+0Z62lyYj9t/qK7RmtXsauzv5?=
 =?us-ascii?Q?QMBqKt8VEq521AP7br2w5ndi9cINwfGADGGaZNO6pZXKwCZpKac3nfxGuqTp?=
 =?us-ascii?Q?QfQYArMJjmVSwYvkFaUygDN0LyJt3E/5TsXIm6jsohbgC0le9z8/HEHJxll+?=
 =?us-ascii?Q?QhaYIdzk4ot5f6vm44XmNY8jn1CJ4UQgWwqLN2txNLiExrrlUgUK52Pqy7AP?=
 =?us-ascii?Q?kvl1A7/nQvOv1ZpDQN24W/sjaFiAhrTPuTS9tvDezA82O4jr+M6fTnIEJp3n?=
 =?us-ascii?Q?3arsT+YKHAWUjKuRO+cxl/fTdA9gbk7aIMttRS2qMy9OkSutDbZBchROovxY?=
 =?us-ascii?Q?hpRjGNEmBxqsYSxpO6IDCGypu8mtvsof97VqeVDXgrR3+SiHVkNbhRaZKY9v?=
 =?us-ascii?Q?p44HD3l4Kp6AR7ew74afzl8difle2VJa0dYf9+CsV4cbCrK6BJIJfT74v0nX?=
 =?us-ascii?Q?2wtz6914TaBoMktcui4C9GTOUlgz3qgTO8grLrJcwB2+aeYzLDvw6Ko90d86?=
 =?us-ascii?Q?UcWkdlsvI2rEA8PNQ8kKPaWOZi+BAWgj1k4y+oZ5jsvSw6yuVmm2fw/eiy/F?=
 =?us-ascii?Q?1hX9zildEzqiLETUiksNYujaMbOWnCrcS21ydTDy8E0SrvSh0U9roMivIhae?=
 =?us-ascii?Q?5fqkJRz+F/Zb8mIdS02Tj84o8KoEon+I7tkz30WjVb0y3rM2vcYFB6DZXD9B?=
 =?us-ascii?Q?UZ8ltObvbiAc4tB5t21ixAmxn35g4JT9F9Se/3F9Cvr6AK5yfEiQgXpzRYR4?=
 =?us-ascii?Q?DmzZ9iK1T7bBcTh195T51onNhTvgXilhIZ8HwpTx3r5mqlZ6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d87f676-dd23-47a7-f43c-08df1a95d8c2
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 23:44:59.9834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JzVv/eVfIheAONuPkNxn53OpwoCe8k5gRLLSEGzil7al9xnB4UJBX8eqMFKerW/K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8557

On Thu, Sep 24, 2026 at 03:42:27PM -0700, Jonathan Cameron wrote:
> On Thu, 24 Sep 2026 10:53:04 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > Sashiko says fdt_addr can point to either an allocated fdt or the fdt from
> > get_fdt() which is memory owned by FW.
> > 
> > Only the allocated fdt should be freed on the error unwind path. Use a
> > dedicated variable for the allocation's size so that the free does not get
> > confused.
> > 
> > Fixes: 4fc8e738ff3e ("efi: libstub: remove DT dependency from generic stub")
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/firmware/efi/libstub/fdt.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
> > index 23b3543d3041b0..5b2dd709d7b151 100644
> > --- a/drivers/firmware/efi/libstub/fdt.c
> > +++ b/drivers/firmware/efi/libstub/fdt.c
> > @@ -229,6 +229,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
> >  	u32 desc_ver;
> >  	efi_status_t status;
> >  	struct exit_boot_struct priv;
> > +	unsigned long fdt_size_allocated = 0;
> >  	unsigned long fdt_addr = 0;
> >  	unsigned long fdt_size = 0;
> >  
> > @@ -257,6 +258,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
> >  			efi_err("Failed to load device tree!\n");
> >  			goto fail;
> >  		}
> > +		fdt_size_allocated = fdt_size;
> Hmm. I argued with myself for a while on this.  Which one of fdt_size and fdt_size_allocate
> is the appropriate one to pass to the call?  In the end I didn't get a good answer so
> oh I guess this is as good as the other way around.

Huh. Functionally it does not matter, but looking at it again I will
change it to pass fdt_size_allocated since that chases down to the
actual allocation. Makes more sense to me like that.

@@ -253,13 +253,13 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
                if (strstr(cmdline_ptr, "dtb="))
                        efi_err("Ignoring DTB from command line.\n");
        } else {
-               status = efi_load_dtb(image, &fdt_addr, &fdt_size);
+               status = efi_load_dtb(image, &fdt_addr, &fdt_size_allocated);
 
                if (status != EFI_SUCCESS && status != EFI_NOT_READY) {
                        efi_err("Failed to load device tree!\n");
                        goto fail;
                }
-               fdt_size_allocated = fdt_size;
+               fdt_size = fdt_size_allocated;
        }

Thanks,
Jason
