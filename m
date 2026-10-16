Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012011.outbound.protection.outlook.com [52.101.53.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0252851AEDF;
	Fri, 16 Oct 2026 16:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792169508; cv=fail; b=MN9vt//Qp5vwrl/UasB4DubJDvOnWCoHuzkzEb/5+tf9LSilW7gVuQ9FvbEmdBU6v1v3h8T+pTOtDkltDRtx+tKF0EfjYxfqynb1kIAqd95p3j0e9grGqvifPOgblzJUOqNepFR0B/Bl+Wt17r+CNx2ROpVul8GxmH4KVox2eNU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792169508; c=relaxed/simple;
	bh=YvQ9Y5c9qdFPi0iVIBa1skOQ85/XKXlzBGn2HOQIMw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HbUBtYZ9WytVbaKP5y7x7PY2xQclPJeO2evrpZ/PPSgSMlnfM4QiBToBGyo9diHCxw9eNNaZdQH1pCkQ8KoItO8NiCBVJZcd3bu/QuKJS/qyp+3ptibQdeC514RvWmfOISR9Sg1cIpC4VN9j0K7HkQKj5PV53jPnhD/4yoRtjz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FkpaHwTu; arc=fail smtp.client-ip=52.101.53.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FkpaHwTu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QyLl1OMq3kHztAkshuhAQWYmh2RNqyaanrQywWyH5tvQzsqE9ozZ529173PSidDWRKK/Na4CnXbRdC1NiVUJBilruVm7ex1S4+P8QuSsFjU3O1Xb18Ce5ImIlcBWcxnKFgI0ZsWhDxY+5cSmsWh1W4RYVpoub52JZulfH3/TxjcfX9goxo92xDM0cTBP1OInufnN7KaMY9OZeFeEE6AjxzCpEvqN4HVietsgHwGpo5kb+cai6m8sf0UGuXN/HoSyQew1qvfG99QXmnAPKID02+UVUCtGtmiRQJWfDZL/v0ivhMa4kUc7Pp3YQJMZhEcbh7MiP2mY6hmVBqifnXHUqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qJW8AKNKZvmeX2LjshLcL0LMhAvgplepmTkSU1c2zdk=;
 b=nUlYG0cwVQD4VgU12e4tCAT1JdqaR9mIM0LXqBKAbVIojxGc6DaynLpn/pem4EdVPDPiDXlHlqZ5PgOnfb1Vj7hLC4cDz99OK23Gj9Aczw9v/TNKZfdDnO5C176Exk6lwlzXNDV/KOPMSihN4PXHvc2hrs0lIihlCs1WVRAhkipDKc+jazTMLRsGkTQijFngepS9oaOQ8ZMgGHHccsFVLKaVlhcA0sm7dcbKx+SfGc4Zk2GZXpDENOgrRiqYl6uBRDyat7RGB7zeVgdtxwOEgPtD3kAMPMtZZLIGE761Wcj4Wmk5nyIKXRb14/H5V0CbPfSOZh7qePbWypnqycq/zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qJW8AKNKZvmeX2LjshLcL0LMhAvgplepmTkSU1c2zdk=;
 b=FkpaHwTuqyIQY9INp0xvPs9BEEM6s1xYguC+mrl4w2T7d7El9TB9fWQzgfktFkyxzz/45b1neXrOKYLEfCsip/CN7SzCvuWid2stS0sZ6tOVfjU7yEfshjtFk+HrVR67RpQLcvm+Yz84trLMXXq4dg0nBeWU8KG1QAMrkmu0XZzuaJjT3BDV4PFNQGQdqm2PrHUVisMAp1iM3cMZ4fHUpkSfha+9Sx8Slk3XRNWo3urX4YmjNHK6aVIrrsbLN+VoVtGuPH33i+1MvSXzek5XncU59kljqEpeB0w2CNG2FMtRq6Gsn0alfjLc84wvGitDWTnKBmTC0ThyfPjsIYn1NQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CH2PR12MB4165.namprd12.prod.outlook.com
 (2603:10b6:610:a4::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Fri, 16 Oct
 2026 16:51:37 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 16:51:36 +0000
Date: Fri, 16 Oct 2026 13:51:35 -0300
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
Subject: Re: [PATCH v2 00/15] arm64: DRTM, boot portion
Message-ID: <20261016165135.GA494690@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
X-ClientProxiedBy: CH0PR04CA0103.namprd04.prod.outlook.com
 (2603:10b6:610:75::18) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CH2PR12MB4165:EE_
X-MS-Office365-Filtering-Correlation-Id: ea142555-71bd-458e-adb9-08df2ba5be0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|921020|56012099006|11063799006|261009223027099003|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	ZP0hwSp6bKc9SiyHxM11NKN9afTWQHyeu4RZGNwQ0InoHvIAzayReBkYG3DYcYQR121ujdQUJYAl9ZnA7MWrnJC6/LQhSAFu+AZFehdWWT+YmJwtggff6AfXfy1LhnxKg9JZpXzccAFURF3nm9+48mKvYc6+CFqBYugSZFeJf+tzRqW892Ps0r9VpLIiLlAUofv0sVvWZue4nAxkGGDuMuO5PckPpJtrpLFaVpf1PM4z8a7+WJvIHDYOPKMHk7HcNfbnkDXB1JPljaknVEXL184N+XcGidmLXYd4ihT40dgtYD1Y8f0PbDrTLWL9fOnjfmgukDi352cqTqh/xziNyS6Fvc3QwPnIQbbZF+yPQD1/CrCF9JNpkF/i1oq2wlEswM3ZNEpKhjUEbutnY/RMTSRNuEUeCNn1syIlipwl/5q1QcF1V6H1T3IFaZsdOaJtgSkcFwbnI90FE3xZF+0wxCZRNMo5Ij65yFsVT43E1E1Y8DxEwincP23lokWiQ3lMfc3i0bfdnwBjeqL8RhINLg3LnCNTHi/ro1xCwvitYP4gbnwN802htuBfL2rXmniL6BCTTwmHT1NxDNC7ohMzIylgLn9MfsisRXesMTseCg8GdQM0S9W4dQq8BnhU+zetNpugemeSYcRj/WYA78/mxPZqAlO+eXXeUM4ehLwnGIZiM5VJ110L8sB/ilQKHwcYtGgLDEko8baB4swzDrl+Bw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(921020)(56012099006)(11063799006)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CRr2urvtZQQW0el4TaKPlzpsM7qQ6zht3ROIPwFl4mJh0C5n0TcLwpNVtdr+?=
 =?us-ascii?Q?EnVmCjyV/EXnXuysxRgoQFTeOdr0h9oEPUp+vrJK5WH/RR3HhQPBn+unVo3U?=
 =?us-ascii?Q?JuFbjGzAlAj45tkUi5Nh2eaxToLVA7/LDIqVHESgrUFiYXkMFHfOlXEV6au3?=
 =?us-ascii?Q?ZJdZkjGus9Fp2tJOcQuNu/MSIL5Rr+GWlK1xo71AUPKRp3mTt8m/Zsklm71i?=
 =?us-ascii?Q?+Y9npcORITk3/Bc3l4dhPZ5EL1rsc6xlEToWwD6yhOh9m7NBM68IFm9Xxkn/?=
 =?us-ascii?Q?hGlh3REa2nLuKeYW3Xt/AYwTYNAhszYeh3Tx062rWTyQ5pZgQys2awZQ/c2D?=
 =?us-ascii?Q?YOs3z3T7pLX8HKDPPm3fQ4iYM6+58y8E5t61/3JsHGMN9xqyHZtfL31Wyq3a?=
 =?us-ascii?Q?eRLDl1XO+LtJhF24D8yi34PKTZVu5EXlbkPvwKyStthR+1N3VaY0/rd/oCkD?=
 =?us-ascii?Q?Zs+8nSnf7+mAwrDBjEv4zTtgbCtQG0pqXgxNONB1RsrR+1cv4LGzSlDPDkaX?=
 =?us-ascii?Q?oYhZTkm9WkOP1/X0NmV3LrVs2DjoAEh220RoV7t3I9Jv/RIFJRTeu7z/WbGp?=
 =?us-ascii?Q?VTFIyqV9IZ3CxOFAd8cTsyME7zipKG7FsNPLCa8njzMsIgg+Bz8yErajkOzj?=
 =?us-ascii?Q?ZNIjgwMJgUtgOMSA25PO4AMjs2Ad8UstJrFI3ywOctkWz/H0T/EPQtooM4Po?=
 =?us-ascii?Q?hOdvtbaLm0tCJPX7ECdczz98gIKBAKQ7Z1Vr0peBTryN42I1mnCN1G3uWPHr?=
 =?us-ascii?Q?/q3xpMKSwcdAFplstmFbW0e3Z+73CPPhez+EihRof/c4ZlYpkp2QtOK6uI7T?=
 =?us-ascii?Q?4jm3vFrreQUhBz9q6n/3x2ThKMTUqZbwvI/vdGT7Jc8AHo4++uG44R7qM8aa?=
 =?us-ascii?Q?mlyn9Q6ADG28iICh8mOosWZrBeT0hN+7+wVJAvH9ty46ZhBMurmzQ7xz840W?=
 =?us-ascii?Q?rqKNnPj1HA96fngywGxcpQoY5V9M20p2wg4URpA+mGMKUkFwYofzkjR44Axb?=
 =?us-ascii?Q?sEk8szFsr1/up4L3UtY5AFwCDgUvkMyWb3nM6JyHz/Y11Xg8RaIcA1+K5NbE?=
 =?us-ascii?Q?uxJSyD5tkAUxA/ap1Y0mCL52e9V4DHQem2Zdc9VMHe5Mvx9yopsmYmeSCqux?=
 =?us-ascii?Q?npFmcaLV4bS46vbs7xssJhF38BTI5DChubBZx/x9wNGiM4tIlzBKB02Tqa+Z?=
 =?us-ascii?Q?NHA5vVQjLJrHIUFOXNYuhgoL9fly+K3erzOiAIIGLOxCrhHJdCohbQQGK9E4?=
 =?us-ascii?Q?xnQ9O03SbF5LzzSVNyZNsUF5fAoO2n27cBTSPtDuMW8mhXdFcQvVIVA/xlwy?=
 =?us-ascii?Q?gkaWgMKI3xD2YiZYsVQWBmi+PwwYj4+W9xPnTT2t7z7hypnt2+G50BWJCedn?=
 =?us-ascii?Q?Ce1Hahhx9/IK31N2VA0lCMdL6GDS8siGH97OL2BmSQE9j1HC51+Zqbttv/GL?=
 =?us-ascii?Q?Pb8jgNFu7rpNZxYcz+c6ztDkth5P0u/ChIkC4fALc9F78J6Fo1/6N7qfiTUm?=
 =?us-ascii?Q?ZJYD1wzaPJoboeZeoc7ldzPmCjBdiscDN0FkaIo1ZXKyzyZaDtJKYtlF//4u?=
 =?us-ascii?Q?FfX07l1Fc9u7WJCkT5v0LQtfotZbo0YsdVv6DOrbc7l+KFBvoEr9nfTaVE7J?=
 =?us-ascii?Q?anH9fzB8ViiZTax0rGdkba7bJwkBYmxbOPjhxQ8NAvjaTFjim/MS8J4zwlNo?=
 =?us-ascii?Q?+ndhBrLcspafwjasUUCKeh+oYYul7A2e1piWak9FGc8scBm3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea142555-71bd-458e-adb9-08df2ba5be0f
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 16:51:36.9408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qn31JklQuX28XUrAIp3ZERIY76HXSg8dzOfIdeWr/9OTY8VoUk3Yil2/DoMcymP8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4165

On Fri, Oct 02, 2026 at 08:31:37PM -0300, Jason Gunthorpe wrote:
>  - Non-EFI boot, particularly kexec

At least the kexec issue seems like it has a good solution, Ard
created a way for kexec to use the EFI entry point, and we've shown
now that this series plus Ard's work can kexec directly into a UKI and
DRTM into the successor kernel. Pretty amazing.

There is a thread here:

 https://lore.kernel.org/r/5236ef55-28b4-4331-8c7d-a6d112aa185f@app.fastmail.com

Based on this, I think a clean picture for x86 is coming into focus
now.

I recommend that the x86 side create a "EFI helper", this would be a
dedicated project and include something similar to the EFI package
with GUID and the trampolines. As a dedicated github with as its own
upstream it doesn't require any help from the grub community.

The general boot flow would have this helper provide functions to the
Linux stub, like has already been sketched out with the EFI package
guid scheme.

The helper would implement something very similar to ARM's DRTM spec,
with the same kind of DLME layout and so on. This will give us a very
strong cross-arch alignment and help create a basis for any furture
industry work on DRTM.

I feel like this is not a hard job with some AI assistance. If this is
still unlcear I may be able to help show it with more details.

That doesn't change anything about this series. I think anyone who can
implement a sane protocol natively should just do so in the built in
EFI stub. The external helper is more because x86 has so many tricky
platform details, needs more ACPI parsing, external binary blob
firmware and so on.

Regards,
Jason
