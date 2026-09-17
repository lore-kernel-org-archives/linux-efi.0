Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABA84E0B95;
	Thu, 17 Sep 2026 16:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.147.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663895; cv=fail; b=D3BygKkyATKVh6iLENthbRt9u/vaLbPi2ixmOlxuTbLp0qjawiHAH/J1cSnEiSn/WrtogkEu3yeCy6GqGNXrcOH2LzNs764TWnFWsq2a49sopQvMXKPbWoHXL3uc6m67hGsEz0I9waptYDxreDRLWfkSvSqTW24TWronr542KaM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663895; c=relaxed/simple;
	bh=CXL+P3qpw8p8LK0alTEOBCNbxPkFwDnmlm+opVcxmSg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tl1kobNTIbneKDwUUca7nmZJOlYgdypB3oHFqL043E5NFS7h0wH+Kxh8oWq4/OnVf8SINCp2PBMxDXGW92EnLygnk4imOz9KrmU60u/+fEZvpBUxrfifi/ZFuq1zUkZ4zh9mnUsZhLkMJKWvzKrT1s/46WWuOnmPwZJCe0zgUSE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=juniper.net; spf=fail smtp.mailfrom=junipernetworks.onmicrosoft.com; dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b=RYy410f0; dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b=afKMJyyT; arc=fail smtp.client-ip=148.163.147.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=juniper.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=junipernetworks.onmicrosoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b="RYy410f0";
	dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b="afKMJyyT"
Received: from pps.filterd (m0150241.ppops.net [127.0.0.1])
	by mx0a-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68HDfMwk1170780;
	Thu, 17 Sep 2026 16:50:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=jnprhpepp0429;
	 bh=HjCJJcwC1hEJEkQYPCWEVsQqjYGpmBbhOfB7iN9kogA=; b=RYy410f0XXl3
	mtiXWh6c8H4XWYPFwcikpqHnH3A5G5l8UGaCIAbflEy0nnQPzPA5DSAyc1KvalE/
	wnEJUjBL8z+u2PTRYvavZ+xs86HDM+iKoQU4JMC1vlwVBqgtMNJTg/0gU2hHhTxz
	rY4gS3ewrGuPLYcMPFU9FcAbSd2wiho3y/UxTrVCGsFRyLjkfHKcd2+xL4UgojU4
	CgL+ihk4wpSLCcMjGPQoqwvoy2BjwkRWVgT6yfg2P8JJ0u0C2rRL5QpIZ4DPlhTz
	iZ4rBCvoRbR1vCxBzYFXMhmEAsdte2ylg4Anliqnvj7+VxjAdUP3KVfmN04LWgtK
	/wfgs1xbXA==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011036.outbound.protection.outlook.com [52.101.57.36])
	by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 4grggkkxq4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 17 Sep 2026 16:50:45 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GzTc9+Gn322SnLJzrCFrI346U9bqMDzrrUYEhE5ABaiKvy6EsxPSlfz/JnuT+Oirs2gDi8rrrHT7UKgKa41PP13Kh0T85jtmm9981KDQCTWyw7Fb/osd5IDGwCK3v5nKcZsD6ouNTiJ1EO7b8GNVAYfn175g45FHDA3laoEwr7mhu2Xs8UQb02yLzRprwmlLPFRxT/vISp6azHbSiInBOdnDIIKGybg1j4OCrJecHpFgTK/eswhnm5blgupItYkn4g08FhQuNX96Aa2en9swGinah7w80wZhaCrrVTSzjAeDBgGXpyTGF43CdyEHRcBO/9DSjfkLk/22QrZdlH7bNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=HjCJJcwC1hEJEkQYPCWEVsQqjYGpmBbhOfB7iN9kogA=;
 b=Wsl++2bY00pkivEhs1YeKbln8+rPJI1S+0Ye7rftt4bbOjqa4fmKpb/5xyLVWae/Dgknu/oXlgJ9MtLULxD8rHByGdlbMugNY/et3cECWbNyqG+Ygm6sYapWbmxCL5QXLuJvSfAV77hGePMlGgEI7OJyMsIVQ97xvgmdtMm/vjUzPCUUqYYbo/X3PvVO2OTF9qvB6p7uzhKAzFF8dqgiubx3tZCDT3rKNcEPIMTrmfiA7tRoXZwYVM9LIlhiIMjlMcJ3uUkCGk9zdVsPuTd0QhoT8n2sNlYABVzBJb6jsDeFFM8Mmv05NktSdBTBLgMEEhzdcA88Y0/e/nLqGEKQPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 66.129.239.19) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=ebf951f79306.juniper.net; dmarc=fail (p=reject sp=reject
 pct=100) action=oreject header.from=juniper.net; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HjCJJcwC1hEJEkQYPCWEVsQqjYGpmBbhOfB7iN9kogA=;
 b=afKMJyyTHPxpJa4ub2gYoYAdlctEEAqnIMgvEtv/io7N5ADuCuNKHQOlXZF6v76fVha7t+pF541vZmxjqgIiMtvvt9udnHNQgZrkv2fcYk4Tf1vDxOvnIaMVaQarHsarhfKEnbxJN2fBFGP2/5rQtZ28fQDuswMJpTNiE9hXmo9hwsKULGRu53QL1svshwLXojdRYIK5uTGXs+6Kd/qQCrjHd/nI73cAArkgT5Z8LLEvJhe787Vj5vx5DEaLz/ASxc+xNJPApFFbqRQ3hwKoJUNqeXnGqGeXJto4zJB7zTehEiQPSCV2gZrgCu2AukQI0a5cYkd7pr1kZqcc+Bm4NA==
Received: from BL1P223CA0006.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:2c4::11)
 by MW4PR05MB8796.namprd05.prod.outlook.com (2603:10b6:303:12f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Thu, 17 Sep
 2026 16:50:40 +0000
Received: from BN1PEPF00018545.namprd05.prod.outlook.com
 (2603:10b6:208:2c4:cafe::39) by BL1P223CA0006.outlook.office365.com
 (2603:10b6:208:2c4::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Thu, 17
 Sep 2026 16:50:40 +0000
X-MS-Exchange-Authentication-Results: spf=none (sender IP is 66.129.239.19)
 smtp.mailfrom=ebf951f79306.juniper.net; dkim=none (message not signed)
 header.d=none;dmarc=fail action=oreject header.from=juniper.net;
Received-SPF: None (protection.outlook.com: ebf951f79306.juniper.net does not
 designate permitted sender hosts)
Received: from juniper.net (66.129.239.19) by
 BN1PEPF00018545.mail.protection.outlook.com (10.167.248.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 17 Sep 2026 16:50:38 +0000
Received: from p-exchfe-eqx-03.jnpr.net (10.104.9.50) by
 p-exchfe-eqx-04.jnpr.net (10.104.9.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 17 Sep 2026 09:50:35 -0700
Received: from p-exchbe-eqx-03.jnpr.net (10.104.9.86) by
 p-exchfe-eqx-03.jnpr.net (10.104.9.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 17 Sep 2026 09:50:35 -0700
Received: from ebf951f79306.juniper.net (10.104.20.6) by
 p-exchbe-eqx-03.jnpr.net (10.104.9.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 17 Sep 2026 09:50:35 -0700
Received: by ebf951f79306.juniper.net (Postfix, from userid 14867)
	id 2D8F48CF257; Thu, 17 Sep 2026 09:50:35 -0700 (PDT)
From: Prashant Singh <singhpra@juniper.net>
To: Ard Biesheuvel <ardb@kernel.org>, Jeremy Kerr <jk@ozlabs.org>
CC: <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Jonathan
 Corbet" <corbet@lwn.net>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] efivarfs: avoid slow QueryVariableInfo() in statfs()
Date: Thu, 17 Sep 2026 09:50:35 -0700
Message-ID: <20260917165035.15187-1-singhpra@juniper.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <60d0b7a5-cc1f-4841-b4f2-754e1b921794@app.fastmail.com>
References: <20260917071600.5587-1-singhpra@juniper.net> <60d0b7a5-cc1f-4841-b4f2-754e1b921794@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00018545:EE_|MW4PR05MB8796:EE_
X-MS-Office365-Filtering-Correlation-Id: 07abe786-c6fb-4b59-924b-08df14dbcd74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|35950700016|376014|10067099003|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Ii+h4WBMUubsvVqVByE6aKCSSm6hCaXZykbJn7w0+x2MnQzQMZE1mN5OfJ5/I6dhpRSVeFjH7oS+q33xTj43rspBujuRjIc33apZYbtNWbr39OiwJTS8G9QskB08Oz1yK2fe8TQMYqfVws3Zu8R+HHpIKr+6KVx3widX8zZ2u6kyaQYS20wT6hIsOQ8ngZMieiXYHoyrGRzNPEPVIHT9hNBUjFy5uAvxW4hq9m8NBghKejmvWEUoLALOYpB9wCj0XcyafQtg2BgdUhPSVg4xexuo8iaJporzr1ZiiZ1a5f75kmMf0p712SBdTb5nNaRR30b0d90OQ0MhGMTg/MsFKHx0tT+BxKvHqr0wfAaX/jrMXL0dbSI32fQxjk/YqMrvBG6ZLS/s5h3C7DIeU3uGxWBISMwLY8Wcmd6jfRnQXZYKxuOiqeWoeA4SV7LZ88BpJmk2xe9xadNoHBfdU7wpu+ZsMWIqrGrBVQJ6fsAhmfpbxQf2rkQbqhWA3rjUoTXxIBAMXt8jS5v63SL39kcqgq758joYNWQPn8zGYBCgzxBzj27SEymtJXjdr1DmMkkDJunhp97YzeKRi8Ue5MdfaI7d9s/j9gF/oDvqWD+YEBj5O0sYH8LPCY4dpGMmSYMs3dXRSCPYy4i2HrrmcadJYmodjQVIOHpcm8A10Qj8VEKDzzwUH4p6mCH68KmO3C0ByOukqyWjTy0mrD68ufi5eQ==
X-Forefront-Antispam-Report:
	CIP:66.129.239.19;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:juniper.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(35950700016)(376014)(10067099003)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	voHMZGOCtSbC9xS5zyDJbL1uHbxeufIYaPt6KjRRwrKTZDeCBGLOZZng92sBeHGiAxv8C7WqiVyrOrY9YG/84DY8bR66nvsxcVEcf6hvhROgq5U6HELH0atEZvU7IH/IgNHzOkm75uEtBmMB6v9nnBL/BAqk3T7q/is5KYKjkhMsYeJP4mp72iF+OwBVIsiOjE5ziEqtaykxJtNhXdgFyLvGIQ3ktkwyfLWF+5037IGnAf2lKwROXSuoQiDq0LwUSuQN19tyZUHb+oGtZZHQI3FWwAQoKDYrSKAKFF0jo0Yg3uIA1NHThpa0y54UVHfcHP5NWUYuRf7u8x0uyFxfdYqDNzrTVEbQqF0QBFA87zOmkh4LkWOprYU9+6cyGNJMn3IioaCqIXZjltVQBWHFJKjO9WVCiBQoNFn1yniNcmVwN4e9o8tz+lIC2Sff04cP
X-Exchange-RoutingPolicyChecked:
	xFbrxBh9+dyJyWJt9a8FgesPPX0cLPauNRoGpFNV3gr+GxZ3a2OGzGY5qzPzbagq2Mg96v8p/pJ/vbE40midW4GSXVl1l6M/y/2owYEZFAJvj+pC5x2omnLP3gNONpIshI4o/uEMhqvzhh/KcnvRMvZP/KsrCAJGjqEijuBVx2LZx2MBNA8jC+BE+snqZFCWtxIG/Kg7CMHF+ipiiGbM4upW4qVIRpD7G9TKT+CrKoAWEnADUW5JlFgvkA07il0u29UJxra+mKN0/Z2Uoq04E/i1jhTHAaC/DqaWYF7H50Axl78ef1ETCIcOTsmFc8/BhqqNPcsSUrUa7cfB0XWPUQ==
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 16:50:38.5966
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07abe786-c6fb-4b59-924b-08df14dbcd74
X-MS-Exchange-CrossTenant-Id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bea78b3c-4cdb-4130-854a-1d193232e5f4;Ip=[66.129.239.19];Helo=[juniper.net]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018545.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR05MB8796
X-Proofpoint-GUID: 8sRsVQZ_ubsei8REBcLREEroY2Vy_I_l
X-Proofpoint-ORIG-GUID: 8sRsVQZ_ubsei8REBcLREEroY2Vy_I_l
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDI0MCBTYWx0ZWRfX9NBRL/nYUwAz
 EfPPcx5KXxxha5oMOpfs5ep2hIgxDyO43ko4ZvCi7s/+zWmBCcj/qcsXpxsuEMfJo8hIEgm6Rti
 HFTYOfHF5WFK63+sT4HGmQ2Ag9S+M7g=
X-Authority-Analysis: v=2.4 cv=NM9AaE6g c=1 sm=1 tr=0 ts=6aac1a65 cx=c_pps
 a=9qX6K/GtqWsr64T/c6OOlw==:117 a=SKdRtqzh2DBFgDMvUaaGnA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=f7IdgyKtn90A:10 a=rhJc5-LppCAA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gQcMVamqm3wCPoSYhaRC:22 a=_ZmgHqWwjZUDpi_pur5s:22 a=Bv228XLCOkDi5kGiu3cA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDI0MCBTYWx0ZWRfX4ahmaa3WLnU+
 3BzgbEYVFOZqXk1fm5pTuZ6HROAENiZpjoJ0amt0ElxtDmA44xqVfqn7gaGFBB1T7DT8/o8Ave9
 PAClRfxOfHP1qg9DnTP7boDWO9q14lUZZVNPRVjR/IAIWzF5V73U31J0vxGQd6GYqKZBiz6ueju
 JUt0XRU3fg47plsSxCbNhCU07D5ahoXCP+aUhATNAvK3vU/GdGKTU6ihKdhoonS1kS4ksMeI8WD
 1MlZTKKiRp2xP1U5avxd7HO2eVKWWwshBfS0sFL3aNCL+roLoWL/y08F0y3v7FmiT72dDYi6Syf
 wGQLIlJYdyg9dmjbSD4fV56HptM9/c0uZ1Dm497DKgsNLg231tLr+eEyWYl/vPg0qKJYsRvICUA
 v9HGLlsa1FVoOTNuRVynmKOnyi90yjXaEYdqS2NKFsShoQJ7MczKJPQCkU6COpy2pVg+8bifc9r
 4bqLxTipZxDh1+YUWYg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-17_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: orgsafe
X-Proofpoint-Spam-Details: rule=outbound_safe policy=outbound score=0
 adultscore=0 impostorscore=0 suspectscore=0 clxscore=1015 phishscore=0
 spamscore=0 priorityscore=1501 bulkscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=orgsafe scancount=1 engine=8.22.0-2609040000
 definitions=main-2609170240

On Thu, 17 Sep 2026, at 10:36, Ard Biesheuvel wrote:
> Could we instead introduce a mount option that disables used/available
> reporting entirely? Feel free to set the default to 'disabled' when
> CONFIG_PREEMPT_RT is set.

Will do. I'll add a bool mount option (e.g. statfs_capacity) that, when
disabled, skips QueryVariableInfo() in statfs() and reports 0
used/available, defaulting to disabled under CONFIG_PREEMPT_RT.

If you'd rather df still show numbers without the per-statfs firmware
call, I could instead prime the value once at mount and serve that
(stale but non-zero) as a "cached" mode -- i.e. a tri-state option:

  statfs_capacity=live|cached|off
    live   - current behaviour: rate-limited QueryVariableInfo() on statfs()
    cached - prime once at mount, serve the static value (no per-statfs call)
    off    - report 0 used/available (no firmware call at all)

  default: live on non-RT, off on CONFIG_PREEMPT_RT

Happy either way.

Thanks,
Prashant
