Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazolkn19013092.outbound.protection.outlook.com [52.103.20.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2B73F0AB8;
	Tue, 22 Sep 2026 12:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.20.92
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790080147; cv=fail; b=Q9CAYlztbQSmrdtTrQJG04pg4MjfRSOQo5f63n8gv5+L8gHSAgYRwPYZMOPXM7fkHarDF7RZ042J4VNzzpYlzpV/TBfIItjrkvjDG+hLFScC1fH3x9jLIhD8NU4ipNf16/Ig+etRa7Jq+7j2EqL/PPQkP8Y9tMHvFN4nAueE/JE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790080147; c=relaxed/simple;
	bh=WGhuF7CCJrdD1xW3hM2yO3LwiCvTovFux3LbvEaaQS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QVMR4l+1KiswYm0+DpWm08uUq2xMZm0yy8Z2H6TTHMzUtPLR2791XlLbTSQ77dh/AwIXgPRaq+LUB7LXbv5eFHlyCkKPDNZ2H48juHHsgfwhh7RQwsx1/U6wv88Srmu57oRA+2cS3Yy2rWLVTSqJGnMw7RL8GLc3k99p8EdKmc8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.it; spf=pass smtp.mailfrom=outlook.it; dkim=pass (2048-bit key) header.d=OUTLOOK.IT header.i=@OUTLOOK.IT header.b=JP35+9kl; arc=fail smtp.client-ip=52.103.20.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=OUTLOOK.IT header.i=@OUTLOOK.IT header.b="JP35+9kl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wp2AHBa200nKZ9DIwT7wuw/8KhJStQvGFppPORo+ccx/HNBJ0x4srIslgU9JdwG8SXjwtAeg46JRXnNPTLZJRdgSKWYPFaFln4jPvOWV1+/Xk91HK9fmnTwS+KqE2mcQZloqfRA5AH7TWC/wG3lQ9OBNMLzUFg+DGs6BWnfLQAzeRWKf4thgEutZM1IyohT7uT5mU67e1dxL5STDPp1CldaEbuuay8/ysZP4SaokNtSrME1Qj2TjBxPEXTLr9J1xAT0Km0vOdqsvQWzL32ZH+tw11QOmS+Df1YYprw0SMagOd0Iav5duxxE38Sv7lcVMA+JhmupsKDwUUPZkwFvU6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WGhuF7CCJrdD1xW3hM2yO3LwiCvTovFux3LbvEaaQS0=;
 b=ILaDS8l6WZVQ7zUU+yZCYw7Yf0hmmSF+hGRZm3Umqea2x/5WHqpbBSs59xahIDp0nGEMHK8++3IKC8eMiiipF5bzko2Ot4aamT7krJggXqr8EteZlAy15H6jYxFp07xv1IxLfAEOVdrCsdGDwD6UO4JYnTg+xRLJgfJaVzEcrbBPkvzsUt1XF1cvJ1iusRvgDZS6KGWg2zfzQEGP6ValdJf2a4E3fvDgbFrIJrnF/xyzISRyp5usk5GqyB5k58NQYbNPe2t25/FwaB14y0OQRwoNJ6CF8nZJSm77YfDwdfORaLR5erL55uPFqspGXOr5TNDiKcB4Ui6nJ41O/+0Slw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=OUTLOOK.IT;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WGhuF7CCJrdD1xW3hM2yO3LwiCvTovFux3LbvEaaQS0=;
 b=JP35+9klh1bynioyKhnYo5xkiwTYc8yzX6t2n7mqG1rGUk45DEyuK6IZmhtdWLNF5ji+ZcATqaiKFpvP0uGyhPgIdC498RtLeYP/LPgFyI/nndmtedp9ycpSaMN8iTws2R/EtO8nmxxMyuBPB3As4l6qmMXr+bk9gIc2bDpOp4TuSa6AqECZlpnMK3ZFk8C4aVw/ygCkZVHXikiF3X4nn3d0/3n9jo5JDILlt6sq0R4bQqHkOHaKC13b7OtpDZJBiobbBuICOUY219cF4pmjvR23Z2xdoy1wnPN4ls6NI8GhbOX44B1JMqwa0PN84G79sCtncDevudxa6wghw82oZQ==
Received: from SN6PR19MB2303.namprd19.prod.outlook.com (2603:10b6:805:56::19)
 by MW3PR19MB4329.namprd19.prod.outlook.com (2603:10b6:303:4f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 12:27:01 +0000
Received: from SN6PR19MB2303.namprd19.prod.outlook.com
 ([fe80::805c:7f80:c69f:876a]) by SN6PR19MB2303.namprd19.prod.outlook.com
 ([fe80::805c:7f80:c69f:876a%5]) with mapi id 15.21.0451.012; Tue, 22 Sep 2026
 12:27:01 +0000
From: Marco Giunta <marco_giunta@outlook.it>
To: rafael@kernel.org
Cc: linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-sound@vger.kernel.org,
	perex@perex.cz,
	platform-driver-x86@vger.kernel.org,
	tiwai@suse.com,
	Marco Giunta <marco_giunta@outlook.it>
Subject: Re: [PATCH v1 11/17] ALSA: hda: aw88399: Switch to use acpi_bus_get_primary_device()
Date: Tue, 22 Sep 2026 14:26:47 +0200
Message-ID:
 <SN6PR19MB23030375FC66A5E8F4296C9AFC832@SN6PR19MB2303.namprd19.prod.outlook.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <2568518.jE0xQCEvom@rafael.j.wysocki>
References: <2568518.jE0xQCEvom@rafael.j.wysocki>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0033.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::20) To SN6PR19MB2303.namprd19.prod.outlook.com
 (2603:10b6:805:56::19)
X-Microsoft-Original-Message-ID:
 <20260922122647.21518-1-marco_giunta@outlook.it>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR19MB2303:EE_|MW3PR19MB4329:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fe0b0eb-8d24-4224-19a4-08df18a4ccce
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|25010399006|55001999006|41001999006|24021099003|8022599003|19110799012|15080799012|23021999003|5072599009|8060799015|12091999003|31101999003|2607281247196008|3071699003|440099028|3412199025|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rcLCBO8HS5dA/K0sfFiqOV3uJvv0hfwHRWeQVvLjX2reI74nt/5KZx8sTHUi?=
 =?us-ascii?Q?n/62mpv8V9g2E3pmBP0Nqi0yCz8PnsLpUiTxRenbdSEpHjwdFfp4EZ6CviPW?=
 =?us-ascii?Q?fhsGcyG56igTFgasLLnOon1rDTEmDHn5FnMxtvq3l7sKIJs6JBHW3XYF2WL1?=
 =?us-ascii?Q?hUIs/5eLzrrLRmF9iaK6pyK56PC5f2TYN2MHSg1PbcXitlaiil81zbY69VCW?=
 =?us-ascii?Q?RWUyHW6MboJu495EHIfA5izs8jZ6VFozVxxnqxnCqR1oCPXUFK/W20YcOLrZ?=
 =?us-ascii?Q?WJ7gtRKOLPGYOPOl5ip+72SBMqNxadwtVNNZKPy4a/4ZkeU34fXof7jq9jjt?=
 =?us-ascii?Q?qb5spOci422AsHKCh66VrzaXXSsY51S1Hei6gFDJXtLLIJt+M84nyGEkQiet?=
 =?us-ascii?Q?MCuFM0R1MeKyJAqY1oDtyhXlxV+kr7hSOcLBaRckKEm2MNHhohvEZoOEQMSF?=
 =?us-ascii?Q?Q9W8bUOOJarrI+S14TsaYP2hzQlJOFAyUP8BBPX5KdQItdqgA9l5cEaB8z7g?=
 =?us-ascii?Q?XQ2gvCb+qj3VlCEuN8PnDlDXCwIG8gwmPUs97OLG3g/bVoZdCTxh6G0I+4ty?=
 =?us-ascii?Q?Mz90nzfhBYUCDgXgNwk4l2HZ1L8Hi9YQ1ZsQ71KWXjC/o/kSiXnqNpIXbxF4?=
 =?us-ascii?Q?JU+0DnNTLKZ685/RFVsB8cB3w93LklnC52KB7rumDH0n5I37EOuZkY3k2+An?=
 =?us-ascii?Q?7OGA+YyOgFrRlvSEKw7LMYnvJ1A7RAIYqt4KZQo5pdFlJGXICx0skPBlAuRh?=
 =?us-ascii?Q?X8DDwKBYx7x9HrgoqlchUHzSAbZnLUUMDQ7L657on/Nv5bYs6pxhv/Dtv1jk?=
 =?us-ascii?Q?S5lpdNjL4v7H+/915AZItFXqk17YEGX+KVLLgTDdlQdg0XBLlCUamBnKRy60?=
 =?us-ascii?Q?xDdV3aTgK6rkwJSDbGJfPeodnsMpYOR+NCj6nYhsCxJY+LItkB5ZrPRqLuoN?=
 =?us-ascii?Q?3sZDHWItd6CVThBDUeQl1/B1WNqlRl6HjUT1GP0enL68epY3fhCBod40Is2R?=
 =?us-ascii?Q?NcE2/RpQ3ttdPk0mRK6EINI4a1mjXlq06qPfgmw+Duh59yw0Jv0pDS0zteHD?=
 =?us-ascii?Q?Hie+W/N04lKpnXSr3O3zrAsjtfC7NA=3D=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rZwEDOhBaJWkNt87YHY0pcx/D5j+hF6TwfF3cf84rFEWjhCfuCyiNkTZObWq?=
 =?us-ascii?Q?6PobSg6rEmb44ksbZ2r0TjlWDqptCGE5G2vBD81yPv7pS/dT9xuGnte6u/MY?=
 =?us-ascii?Q?/r125T9rBMMBHafQgGwDRgYGVohOyoDWB+PvwZeAaU1RsCo7keIvXZ/mMSAV?=
 =?us-ascii?Q?t0EyCpOdW2ksYBCrA+WjiGpdwWH7mEPmRlYk33O0nXfbtjgPyCuOsEdMC4QK?=
 =?us-ascii?Q?k+iKScYxvwtvEvPcLsitVSSgBSLJxCqdMKQW9BbjPr57r5SzXSkf5qi1u7LH?=
 =?us-ascii?Q?1LG6XR8PsezHZWYhRxSQuS/QVpaGFZ1upCm1iZGQ/B2OOKF2DrlzBkrDKpFJ?=
 =?us-ascii?Q?66dzjCzzL5qtrzAxQ2hMqPhmA90CHWtUPht/pNFj5Iav8eg0niBzMAbrOexK?=
 =?us-ascii?Q?Fl+19sg4P6KiIT4AYdhViz9GdEXJpoacf3rvoefeUSu10ck5QEKlfgkUJ1uI?=
 =?us-ascii?Q?S0Dqic35ko8R3k5vNxk7s8oIrSCoBBEaEAOtY4HaiLQbzwRQovS0TnXCNymN?=
 =?us-ascii?Q?0dMEijOWkvWM/o4UnA83uK9P62s6BAIEZUkCy8suhhlqnxPjAQFpHt8D8iaJ?=
 =?us-ascii?Q?XYpi5DnDc85Fd1sHwgann/PM7oEPQqPoA65CyeMQ6mwCb7We3qQGZmluCB73?=
 =?us-ascii?Q?EepiwMcdg6oO8HsygaSF6mZazYw1VZnTwfRf1fbVX/yvJa6PvMhRAUuMrzJ0?=
 =?us-ascii?Q?NCeZgp/C2XwbIWGvOqmpzEQQE5SlXNemcclgAeccst7ImlS6akj+v2GkoA0q?=
 =?us-ascii?Q?zifxL+x6M5YnhReV51f7vagN/ibMM/Eo/j5xf48syvd7kyqeRAPUpjOfydI2?=
 =?us-ascii?Q?Vq6v4B4OKMc7SDtcHLoC3hhysktEDfHpSqULfxVF19wkOfwuhNsWwALhZIVe?=
 =?us-ascii?Q?2M6dAFfh4olkMWP5ggxOwywLfGTHPzhe0ZX5Jj0i1qhgQ2uIZu/8Fi3pPIkD?=
 =?us-ascii?Q?IpmuDGpPxwK90keXkkmDUBAP7govrxniIu7dHzvYkNwgPW4lBhfqZE1BEU5V?=
 =?us-ascii?Q?vWYq6Takl1m8mgqpdlB9AV+joJ9dMDAhzgpl8NEsUKybVvIQpjlgNBRbJBbq?=
 =?us-ascii?Q?fe5DNfOpZPw0wfQms3h6WX1vbry356+emJVLlpLY8pJHR0BRLOH6UOXRN5/p?=
 =?us-ascii?Q?eGUGD9u8KShPILlnFL7wmyBIezN0+XkQx8hu7TiCc9wb7fw96tsFuLzTAmYT?=
 =?us-ascii?Q?5a+ACWF7gmJt/9Vo7icuF24iVxu+LZKljgs12KJfiE/4fTPgfcR7z+U+hnHw?=
 =?us-ascii?Q?xsqziWVODxwoN5wiTJCLJPNuTu/JbkWkyDVggZETrjVCvAObs/3Ib9s0X3qu?=
 =?us-ascii?Q?51AsdtY0db7hi+CpM+g3rBr/tp8Qws+YY63AnZJrWKUOlWTvD3uuL0A+lnMs?=
 =?us-ascii?Q?neMmlFwlqtdqI4caJqGi/lAmL6kt?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-990eb.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fe0b0eb-8d24-4224-19a4-08df18a4ccce
X-MS-Exchange-CrossTenant-AuthSource: SN6PR19MB2303.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 12:27:01.2660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR19MB4329

> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
>
> Replace acpi_get_first_physical_node() that is slated for removal
> with acpi_bus_get_primary_device() that takes a reference to the
> device it is about to return.
>
> This addresses a potential use-after-free that may occur if the
> device returned by acpi_get_first_physical_node() is removed right
> after dropping its ACPI companion's physical_node_lock in that
> function.

Acked-by: Marco Giunta <marco_giunta@outlook.it>
