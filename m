Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D7136EABE;
	Mon,  5 Oct 2026 23:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.143.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791242643; cv=fail; b=kRLvH95rwshMOs+jhI8oZXG6PzAuAysbfCs9MDYFOBIlZMHING9Jnzkx5rNKa/vkfSeVP5IBYKwVsxWDkD1tkXnpSPt8v0D9r1Q7CrUls3L/eU9Mz8ioOpUcf82xPjVJ2RwXYqovFNaq73vT/jZrJ/S4shv9zyAfu9HGtICAaBA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791242643; c=relaxed/simple;
	bh=QywAPUOzDwHMD8bUzTHuv7nwBnIVy1A3GDvkKKFKdsg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AriiEmLBCbT/s17LFZba2xf5h6kotIsCG9ZPUkwstAkYfrmI6buP4Jn8RPAR1n74Dufo4Be/+ucKI6Oen5BjXSWQ7pbOTuDaKmasqZxenSJ0azJLy4hepxnD6mEepqDWjV5F6uG4MLOrYSx42p+DMjDZJn4ruiRrMtDbBupAq8w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=juniper.net; spf=fail smtp.mailfrom=junipernetworks.onmicrosoft.com; dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b=sEVVs1tV; dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b=KOiBvjxR; arc=fail smtp.client-ip=148.163.143.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=juniper.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=junipernetworks.onmicrosoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b="sEVVs1tV";
	dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b="KOiBvjxR"
Received: from pps.filterd (m0150245.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 695HKSaB2657381;
	Mon, 5 Oct 2026 23:23:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=jnprhpepp0429; bh=eeFTVoU45gIGgUSBCp
	5mW0U7GgDopVr4VjGF95o2SH8=; b=sEVVs1tVnGTz22/EUvoeG3e9slg60NHEYh
	jtirbYqqCn54C7hoZvlxpgN0zhCpu2Drfv4oF2wraxjn3Mn6PmbqxUQhJYpfPYVF
	xTzl79xqwytF7/VSB4acvLuBCg7ggXIi6uNerngk3c7j28oN5MS8qlHaJXkrvKXU
	6uPBf29PS/QbcPVXomlVkGMx2PqBLdL5hwLTbhyQYi77g7nznHoREKi2gTO2hJXE
	7dxnWhuUvfDPCHl1WNG3pzYRAAaqv61SOm3RodZhHEn3cIPhJgNDSr9pkr7QaC1M
	9iRTQ30jXsa8ZSx7EYiC/J1za/PEbcLSrnsQuHfp7dTHRwPEmmqg==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012064.outbound.protection.outlook.com [52.101.48.64])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4h4etteeqr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 05 Oct 2026 23:22:59 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iHUmh0qcqCuJRA/UH16smtLpS2ovaIpNjruaeJcXTXQovSyKNMS7qoL7jwqZJX7anmadFk+JjEH9eSI4JGNdeXNvalUNW/qCUnNls1hJPdIMrfDr+WGVc3+F16G1gs+ufojcGTwdv60Uua1ZHyhhqOMJ6HAY4rn3bz77m+7uuov6UKB+fHb+ufMjPqxxWpakxCPY2lBUg5vHKfX58TGXR4j327i6JB6AT2Sp16ePsRDpabCkrQx9eGowvFtzK+lAdUdE4zDFMoa8DOP3iO7vGid0SsoIJ2GVYm8wKdWNDnNoWeJ8LwhkLeMsBOOnIYmQe6VU9dUTfQGfCPc2a7/feg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=eeFTVoU45gIGgUSBCp5mW0U7GgDopVr4VjGF95o2SH8=;
 b=unJBJ75IT19EmiwbMPuRIqSksAvB8RlFWF6oAmeG03XaFZo/HBEOKX/fBa0380xIenrB+6bLJnoxC0XIlV2UG1SJJVYqc6xYYv0N9DcwN/0ANy/c72VKd5Mx+3E2MByHFr4iVhPgtE2fMz4qzhN/HSzSc1sFL/qF6TiTEBvmei/c5Et+pE/GhwkweKEoDd4sKgSkE6cajcXpGZzZAka4wZmvvoe9a4NmxP9ZtzjoYxFFt/GfdL2Bs9+2ikNE7rCt8zIlNsTHX9BgGmwq67Zod1WzL2lv2n6XSYg4CvKj+968vaVkd5e+Dt3YYDmbxyLagnzW6RN4i2t5LggLhtBTtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 66.129.239.19) smtp.rcpttodomain=debian.org
 smtp.mailfrom=ebf951f79306.juniper.net; dmarc=fail (p=reject sp=reject
 pct=100) action=oreject header.from=juniper.net; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eeFTVoU45gIGgUSBCp5mW0U7GgDopVr4VjGF95o2SH8=;
 b=KOiBvjxR00k1n5D0pooeMvG8fRZkfV+RQeKGoUZR2sZxpFd1PNIm8MVgm7FfIm8h7oGDaEoMUrX1LXF+IoBWrt3sivEwXDmr74eGHCcXUYlR/4jbhdA9n2lSAlNmTaSNlXjub8hUlp8uUxHuaDdpA0294Nb+tSj59yR3yATmcWSGxSvcman0rl5Geoix4ZvAS5uv2X7bZEqVqFSWilR7gN2WPT0MEgBL4sVvhSbXzu5eWNZZIbuBvIEkbvfR04Bx7Br71TKWvQ+Dr/ubfl2d1B4CxrSge4snFphOP04JZ59Taj52xhsft0F928nvn2mfKHzNq35xsg1fdoW6m66DdQ==
Received: from BN9PR03CA0502.namprd03.prod.outlook.com (2603:10b6:408:130::27)
 by BLAPR05MB7473.namprd05.prod.outlook.com (2603:10b6:208:293::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 23:22:55 +0000
Received: from BN3PEPF0000B073.namprd04.prod.outlook.com
 (2603:10b6:408:130:cafe::32) by BN9PR03CA0502.outlook.office365.com
 (2603:10b6:408:130::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Mon, 5
 Oct 2026 23:22:55 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=none (sender IP
 is 66.129.239.19) smtp.mailfrom=ebf951f79306.juniper.net; dkim=none (message
 not signed) header.d=none;dmarc=fail action=oreject header.from=juniper.net;
Received-SPF: None (protection.outlook.com: ebf951f79306.juniper.net does not
 designate permitted sender hosts)
Received: from juniper.net (66.129.239.19) by
 BN3PEPF0000B073.mail.protection.outlook.com (10.167.243.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.14 via Frontend Transport; Mon, 5 Oct 2026 23:22:54 +0000
Received: from p-exchbe-eqx-04.jnpr.net (10.104.9.87) by
 p-exchfe-eqx-04.jnpr.net (10.104.9.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 5 Oct 2026 16:22:53 -0700
Received: from p-exchbe-eqx-03.jnpr.net (10.104.9.86) by
 p-exchbe-eqx-04.jnpr.net (10.104.9.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 5 Oct 2026 16:22:53 -0700
Received: from ebf951f79306.juniper.net (10.104.20.6) by
 p-exchbe-eqx-03.jnpr.net (10.104.9.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 5 Oct 2026 16:22:53 -0700
Received: by ebf951f79306.juniper.net (Postfix, from userid 14867)
	id D7FB21526799; Mon,  5 Oct 2026 16:22:52 -0700 (PDT)
From: Prashant Singh <singhpra@juniper.net>
To: Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>,
        "Sebastian
 Andrzej Siewior" <bigeasy@linutronix.de>
CC: Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt
	<rostedt@goodmis.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan
	<skhan@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Luis
 Claudio R . Goncalves" <lgoncalv@redhat.com>,
        Steve McIntyre
	<93sam@debian.org>, <joaoanandalima@gmail.com>,
        <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>,
        Prashant Singh <singhpra@juniper.net>
Subject: [PATCH v5] efivarfs: add nostatfs mount option to skip QueryVariableInfo()
Date: Mon, 5 Oct 2026 16:22:50 -0700
Message-ID: <20261005232250.2620-1-singhpra@juniper.net>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B073:EE_|BLAPR05MB7473:EE_
X-MS-Office365-Filtering-Correlation-Id: 28f52025-73c3-4ac9-1192-08df23379584
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|35950700016|1800799024|6133799003|10067099003|18002099003|13003099007|3023799007|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	9l5NqtfYkNDL/c9VEvAAl0rNnqK9WCzROJsMa422Sh5zms7IWCfPg6B9zcF5zMu8zlf4Vun2A8yuzr6WXg/RSwDvmP2vk/ZsMop3hEtuNDv0uDTrZqdO9YT4W/k1zKvgPMNoJgoxwBsCnXwUj2JTY6OsTQnKE2RE08EjSLrEDRV87mku6+6GXbT1UQhh7OGVCGMuX0EOLp/pqd1BVwqu6B2FLvItveOqnTS8P9DMLOsLnmo08u05mftwPoAjSpUwGUB/OKtanb/w4dxotKR8Izd8L5yhP5wxIh5sbpNZ22fpIKcKMAGavvMeW6W4Pmpjg0Lizo14//MeDSVvq+miv7a3Hae3hCMk85y5C5WaASmYjEhSB30PZqmNTlRoevINjNgYpVeu5tx124YOJIdwiDFE00VrMOVbTcpdbOBA+Mzbkv5CsB/5+cgXB/s05llsSF+nwqL/Hch7n44awOUn0MCs8CIPStKVcywIlb8ALTpe/xtzEz1cXIjJE+SGYDtCk2Bp1Cg0XUKy+9xo034xNiGr5Baczkettxl2yGcLrFCY84dM6pV9MeYqwQ2DshPQCSFV8nfhyBH5teVfauZPcNYMvzkwTdXh+l/pc6OVhZBFSdDHLWWDrYDmc3KJTIFnXWuWWc4U3xifa34fYN2pu7Ob1YT2ERnCAkFmtpP3iv8HSbYjmwKFDpOYqaoGp8Fxue7D3NGG9RR9G0RgX6mJFA==
X-Forefront-Antispam-Report:
	CIP:66.129.239.19;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:juniper.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(35950700016)(1800799024)(6133799003)(10067099003)(18002099003)(13003099007)(3023799007)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4TXbCxLzihafHWHGG5FYucGpg9bFa1pww8S1Gck65XEr/Sr2ZL/eZpQNv/M1iMBfqHIju2TMu02i3yMF97ouvKHwWpKKHyPrndSxXmKnZv/UlGEoZB730GCLBiTnVkt7x9lzFTO9T7Yb8bx1J8NwpE8Ii5CHEyv+GXJLpKQw/dVajHWt0D/GLio9+Q3DRhYdkBcIR/VkUVQLH6pTos/zQ/v2W4ar6SRMTpQxDWL/ri7UIIbUSSDEMKkvTfd+2rTjf1yDfemjM46/qNCex5IGFbHVW8LUhQah6abs07RMh9Mwz4BiEnTOGHmGEt2F7YIUxkL4+llZPRlN2HX6N7/9aesOHOI0biwdsp9jt5bEz/l0w0+FG4qvkcX1IirGxAsDIoO2Tqd17M+NFESetLNIr5lEPBIJuUIBStssbgn3J9aFuIule4ocqwmn8F+7iVy9
X-Exchange-RoutingPolicyChecked:
	DQd28KXntQwurZw8t8Ag4963cRfOa4DCJRm3V2DyX+W0Z1eVTjovvqr6mYz5vZCUnWVl05ehZfoaQluvYvc1BXyWoPf5BQFqqxfYM/Hf67xmugbyy9W3V3V4WxREcejW46gFPYcRjToVmNWK0cgPDbh5Yg853bXxDEtchEeCJUcvOCGNI+nnCQAsL1fzwIa6b7Qm9+H1Y5PX2Y5m8rzIEwzRbJem2qz+v3SVFpTpwmcLX0HaLQRJ0jQf32hu0greJRYYphchfmtciNj/kGIaGVGjcXZ9Q6uGG274gx8Au1taXfrtdpernR24ECPgwp08rsdX4Qxenj8IVF9SNThQxg==
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 23:22:54.7221
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28f52025-73c3-4ac9-1192-08df23379584
X-MS-Exchange-CrossTenant-Id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bea78b3c-4cdb-4130-854a-1d193232e5f4;Ip=[66.129.239.19];Helo=[juniper.net]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B073.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR05MB7473
X-Proofpoint-ORIG-GUID: uyBl15ImgubBnn96mDcjnSz6Bd5ZGdb9
X-Authority-Analysis: v=2.4 cv=AoR7T+9P c=1 sm=1 tr=0 ts=6ac43154 cx=c_pps
 a=bXuiN9e40kCijJrvSl1c5A==:117 a=SKdRtqzh2DBFgDMvUaaGnA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10
 a=f7IdgyKtn90A:10 a=rhJc5-LppCAA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gQcMVamqm3wCPoSYhaRC:22 a=6XKncaru_qjgLvANlS_8:22 a=VwQbUJbxAAAA:8
 a=OUXY8nFuAAAA:8 a=XH8aumhe1OORxCPE0jEA:9 a=cAcMbU7R10T-QSRYIcO_:22
X-Proofpoint-GUID: uyBl15ImgubBnn96mDcjnSz6Bd5ZGdb9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA1MDA5MiBTYWx0ZWRfX0+LuyTSfZTF2
 0VBdJ1IDMR0DUudHbIUHBQ8OjMTi73rg9LNsTFMeOkCtqnczIl82SSyKBxJAH9ww7guq4jkZPm0
 KOQCZOMEP5a6cCL5EqmVFQ+1VSJ1VPsukkACIk1CUqPRRsgwU8/BG+kCRqy9legY8/wbxFlqDxr
 Z/vuBioshKMx/k2nR9bbjiVZEX11r773NjmYLFuqIVWMr63GTP2JnMMh3cs0iFBaZ0y4jQTkDcm
 Nn+Zh3hTJvN6TiKBaD1/kGkmMtj+En1wPK6mDpxusTgSyfanqXCVexL+NKEJblkuvyDntl2PbB1
 rX5KCMx//Qtj/7gBQ2A8CGud1pM+9+y0RTXLR//dWOgAC1w/CBOiAnmN2xseNdeS596e/jaiX+A
 aE1/FvabHD9w0035Gip4kkUY8OfErvZmJlt8suzU84nnIt865JiH9+IPS4HjN1TIaeBTie8wczp
 slvD6y/Kgy0jcFQanOw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA1MDA5MiBTYWx0ZWRfX79eqaKrqvpGb
 qzJlgsOu/54I9sDXPExWavTh7p5sdwyGNueQ08/HkrVbHS5/t99BvX1YcU46RkVdVlk35jBCfWk
 7TN4QUNRuu2BTzytCN+av3qVKbzGg4c=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-05_05,2026-10-05_01,2025-10-01_01
X-Proofpoint-Spam-Reason: orgsafe
X-Proofpoint-Spam-Details: rule=outbound_safe policy=outbound score=0
 impostorscore=0 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 clxscore=1011 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=orgsafe scancount=1 engine=8.22.0-2609040000
 definitions=main-2610050092

QueryVariableInfo() is an EFI runtime service that, on some firmware,
takes tens of milliseconds and runs with preemption disabled, stalling
the CPU that services it (and, on firmware that services it via SMM, all
CPUs). efivarfs_statfs() calls it (rate-limited since commit b2326338dc68
("efivarfs: Rate limit statfs() handler")) to report the variable-store
used/available capacity, so any statfs(2) -- e.g. every "df" -- can
inject that stall into unrelated latency-sensitive workloads.

Add a negatable "nostatfs" mount option: with nostatfs, statfs(2) skips
QueryVariableInfo() and reports zero used/available; with statfs it
reports the capacity as before. It defaults to nostatfs on
CONFIG_PREEMPT_RT so real-time kernels do not take the stall out of the
box, but statfs can be passed there to force reporting back on -- e.g.
for tools such as fwupd that need the efivars free space to update Secure
Boot key databases.

The option can also be toggled on a live mount via remount, so reporting
can be enabled only for the duration of a firmware update without
unmounting the boot-time efivarfs mount:

  mount -o remount,statfs   /sys/firmware/efi/efivars   # reporting on
  mount -o remount,nostatfs /sys/firmware/efi/efivars   # reporting off

A remount that does not specify statfs/nostatfs keeps the current setting.

Tested on an Intel Xeon E5-2628L v4, 6.12 kernel: a default statfs(2)
takes ~66 ms (the firmware call), versus ~11 us with nostatfs.

Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Prashant Singh <singhpra@juniper.net>
---

Changes since v4:
- Trim the commit message: drop the per-call strace dumps, keep the
  preemption-disabled rationale (Ard, Sebastian).
- Replace the inconsistent READ_ONCE/WRITE_ONCE on nostatfs with a single
  data_race() on the reconfigure write; the lockless reads stay plain
  (Ard, Sebastian).
- Minor doc/comment cleanups.

Changes since v3:
- Drop the show_options "statfs" branch; the absence of "nostatfs" now
  indicates reporting is on (Ard Biesheuvel).
- Drop the uid/gid copies on the remount path; efivarfs_reconfigure()
  applies only nostatfs, so they were dead code (Ard Biesheuvel).

Changes since v2:
- Make the flag negatable (fsparam_flag_no): "statfs" forces reporting
  back on, "nostatfs" skips QueryVariableInfo(). Default stays nostatfs
  on PREEMPT_RT. This lets fwupd get the efivars free space it needs for
  Secure Boot key (KEK/DB/DBX) updates on an RT kernel by mounting with
  -o statfs (Luis Claudio R. Goncalves, Steve McIntyre).
- Support toggling the option on a live mount via remount, so reporting
  can be enabled just for a firmware update without unmounting efivarfs
  (Sebastian Andrzej Siewior). Options not respecified on remount are
  preserved.
- Add PREEMPT_RT + remount test data to the commit message.

Changes since v1:
- Replace the sysctl with a mount option named "nostatfs", per review
  (Ard Biesheuvel).

v1: https://lore.kernel.org/all/20260917071600.5587-1-singhpra@juniper.net/
v2: https://lore.kernel.org/all/20260919044124.8268-1-singhpra@juniper.net/
v3: https://lore.kernel.org/all/20260925113145.7396-1-singhpra@juniper.net/
v4: https://lore.kernel.org/all/20260928203445.72318-1-singhpra@juniper.net/
 Documentation/filesystems/efivarfs.rst | 12 +++++++++
 fs/efivarfs/internal.h                 |  1 +
 fs/efivarfs/super.c                    | 36 ++++++++++++++++++++++----
 3 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/efivarfs.rst b/Documentation/filesystems/efivarfs.rst
index f646c3f0980f..23164464ca2b 100644
--- a/Documentation/filesystems/efivarfs.rst
+++ b/Documentation/filesystems/efivarfs.rst
@@ -37,6 +37,18 @@ accidentally.
           |4_bytes_of_attributes + efivar_data|
           +-----------------------------------+
 
+Mount options
+=============
+
+==========  ==================================================================
+(no)statfs  Control whether ``statfs(2)`` reports the variable-store
+            used/available. Disabling it skips the ``QueryVariableInfo()``
+            EFI runtime service call, which might block all CPUs for a few
+            milliseconds, and reports 0/0 for used/available instead.
+            Defaults to ``statfs``, except on ``CONFIG_PREEMPT_RT`` where
+            it defaults to ``nostatfs``.
+==========  ==================================================================
+
 *See also:*
 
 - Documentation/admin-guide/acpi/ssdt-overlays.rst
diff --git a/fs/efivarfs/internal.h b/fs/efivarfs/internal.h
index f913b6824289..f5c1a25be996 100644
--- a/fs/efivarfs/internal.h
+++ b/fs/efivarfs/internal.h
@@ -11,6 +11,7 @@
 struct efivarfs_mount_opts {
 	kuid_t uid;
 	kgid_t gid;
+	bool nostatfs;
 };
 
 struct efivarfs_fs_info {
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 8d33f11db2a1..12746ced6dc6 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -74,6 +74,8 @@ static int efivarfs_show_options(struct seq_file *m, struct dentry *root)
 	if (!gid_eq(opts->gid, GLOBAL_ROOT_GID))
 		seq_printf(m, ",gid=%u",
 				from_kgid_munged(&init_user_ns, opts->gid));
+	if (opts->nostatfs)
+		seq_puts(m, ",nostatfs");
 	return 0;
 }
 
@@ -82,13 +84,18 @@ static int efivarfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	const u32 attr = EFI_VARIABLE_NON_VOLATILE |
 			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
 			 EFI_VARIABLE_RUNTIME_ACCESS;
+	struct efivarfs_fs_info *sfi = dentry->d_sb->s_fs_info;
 	u64 storage_space, remaining_space, max_variable_size;
 	u64 id = huge_encode_dev(dentry->d_sb->s_dev);
 	efi_status_t status;
 
-	/* Some UEFI firmware does not implement QueryVariableInfo() */
+	/*
+	 * With nostatfs, or on firmware that does not implement
+	 * QueryVariableInfo(), report zero used/available.
+	 */
 	storage_space = remaining_space = 0;
-	if (efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO)) {
+	if (!sfi->mount_opts.nostatfs &&
+	    efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO)) {
 		static DEFINE_RATELIMIT_STATE(_rs, 2 * HZ, 5);
 		static u64 storage, remaining;
 		static DEFINE_SPINLOCK(lock);
@@ -323,12 +330,13 @@ static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
 }
 
 enum {
-	Opt_uid, Opt_gid,
+	Opt_uid, Opt_gid, Opt_statfs,
 };
 
 static const struct fs_parameter_spec efivarfs_parameters[] = {
 	fsparam_uid("uid", Opt_uid),
 	fsparam_gid("gid", Opt_gid),
+	fsparam_flag_no("statfs", Opt_statfs),
 	{},
 };
 
@@ -350,6 +358,9 @@ static int efivarfs_parse_param(struct fs_context *fc, struct fs_parameter *para
 	case Opt_gid:
 		opts->gid = result.gid;
 		break;
+	case Opt_statfs:
+		opts->nostatfs = result.negated;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -402,11 +413,17 @@ static int efivarfs_get_tree(struct fs_context *fc)
 
 static int efivarfs_reconfigure(struct fs_context *fc)
 {
+	struct efivarfs_fs_info *sfi = fc->root->d_sb->s_fs_info;
+	struct efivarfs_fs_info *new_sfi = fc->s_fs_info;
+
 	if (!efivar_supports_writes() && !(fc->sb_flags & SB_RDONLY)) {
 		pr_err("Firmware does not support SetVariableRT. Can not remount with rw\n");
 		return -EINVAL;
 	}
 
+	/* statfs()/show_options() read nostatfs locklessly; benign race. */
+	data_race(sfi->mount_opts.nostatfs = new_sfi->mount_opts.nostatfs);
+
 	return 0;
 }
 
@@ -524,8 +541,17 @@ static int efivarfs_init_fs_context(struct fs_context *fc)
 	if (!sfi)
 		return -ENOMEM;
 
-	sfi->mount_opts.uid = GLOBAL_ROOT_UID;
-	sfi->mount_opts.gid = GLOBAL_ROOT_GID;
+	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
+		/* nostatfs is writable via remount; keep it if not respecified. */
+		struct efivarfs_fs_info *old = fc->root->d_sb->s_fs_info;
+
+		sfi->mount_opts.nostatfs = old->mount_opts.nostatfs;
+	} else {
+		sfi->mount_opts.uid = GLOBAL_ROOT_UID;
+		sfi->mount_opts.gid = GLOBAL_ROOT_GID;
+		/* QueryVariableInfo() stalls the CPU; default nostatfs on PREEMPT_RT. */
+		sfi->mount_opts.nostatfs = IS_ENABLED(CONFIG_PREEMPT_RT);
+	}
 
 	fc->s_fs_info = sfi;
 	fc->ops = &efivarfs_context_ops;
-- 
2.34.1

