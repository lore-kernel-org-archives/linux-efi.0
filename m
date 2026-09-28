Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6AF466B17;
	Mon, 28 Sep 2026 20:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.147.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790627833; cv=fail; b=E6YUB0PRnVq08TE4w1eKDo8z9GNLOFIWyBxWCqEF0GsY+/O3n4KDoTAq9cq2bADjmRFZ1c5wSh5iqPhnQBY7vWUxDduHoN5HKfwKJctZSyCGa/ysh4qauUoZNRQ4z+XVUG/D4+xL+WzcNpJLa18K4YdKiy5VrS+iEJ0yYs45MMY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790627833; c=relaxed/simple;
	bh=MdEkYYx2/d1b3RtJXaGOC/fQTDzSEV61nHldjzfw+zA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=p1P4gDO+zySUImXutqQfN5qMg9v1CyJ/Y+Xp4dpKokl4nZwO0Ypte7yR6tk+eXgbkY/3PBFQSq1cVId36KIh5YQzZgOc5A3QWxKm30oxI63vTzfo/M14/X7uG+5f8T2RvoMIWvPrdnqgJX7Q1xkZuIZj4+kaN2J5+7huWoXttNU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=juniper.net; spf=fail smtp.mailfrom=junipernetworks.onmicrosoft.com; dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b=JQ+LAAwN; dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b=WKVS1ubX; arc=fail smtp.client-ip=148.163.147.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=juniper.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=junipernetworks.onmicrosoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b="JQ+LAAwN";
	dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b="WKVS1ubX"
Received: from pps.filterd (m0148663.ppops.net [127.0.0.1])
	by mx0a-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SKTnlX2455697;
	Mon, 28 Sep 2026 20:36:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=jnprhpepp0429; bh=ywbijmLOpCkD6Hn7UA
	L30TPCLKqUyZkdruN7lh20n4c=; b=JQ+LAAwNg7OA3cilKTB6puLuQdsP9B7ieE
	b3My+6Mw+WztMnzgoNlIjI0g05B7eOrqxa/rD+iq149DMzWlQmEzrNSZR05Hjzw9
	TEFbz+Oc9VPA1jY3GWezqBNuyVee7VlrOKcjrE8r3eEPcSXZoWW1Nkg5XNHOgHJO
	IlU1i3QlawfMVppV+Qpw2GbdP8LYiFqzp3yrgPMaoy0B8V6rJp/xJa6AbKrq9IvF
	oSqhx3sy9BOYoFNxegvQO3re8IW8bKzMt9GzK0W9MZuFw+8Gho1k1PQMmF6aisrb
	fypuIAOibUmJanrjUfXSRHiARXYKQe1uPo/pmpv+74m08jQxKq7w==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011055.outbound.protection.outlook.com [52.101.62.55])
	by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 4gyvxda31t-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 20:36:46 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wJBry/t0oh+sU32B9vJYVRubTLWu03IKR0JujasMWT95d7FKFKeyEw8kNAl3WMs1YpAaESttedOE2BIv/Lc741vAzoVrALZtA9QmaGYyZ9IBpMt9Be5o+boO538wMROqjryIQf7GB/tkAc76EGboIyceuwU0maZPjckwaR+KlpN8SldY0FcTECEdB3Mcf8msWsAktUAwssJgtVnuiEEdHegWkDH75UrbL3VgHUCB/iixRVlPAF8dzE74ClDsp7ilZ7A1FLXUXv5zy5gv4OSzS/Bbtr6M+pdVqi+2HlysqZfeGH/pknmHDxM0bFrmvmmGSlqM4mRLbqzjWdY670TUWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=ywbijmLOpCkD6Hn7UAL30TPCLKqUyZkdruN7lh20n4c=;
 b=SRjInGDL88pI/rCBkffoPmKNJvZW7ZNWRAPq+Y6D0YS7kejykm82A0qiW2laRTdOjaZPtE+FTsCfsczICileyC8fcjj0Q6ZKyJeQpIggActhoKSOpe8avleP1/kIQrRvaB57CLnZmAXZvlr6ta4MfAja+YbBP9TKxLUKaSs2XN9tk9r37BD6BzmBRITVmcXYfV4BWkmZmkUJ73Uvoezw1WaoHHUMciUC158+lQD2myjppkWgNtqaLoLbTUpThMeqx3EGu6pSLtg6hD46nW7yf8EFAklyydRKVpCd3tqg+3oP6cyGndCjSWvyPhyD24vwfMxNuT+ZcJ63dCv+pRRJ9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 66.129.239.19) smtp.rcpttodomain=debian.org
 smtp.mailfrom=ebf951f79306.juniper.net; dmarc=fail (p=reject sp=reject
 pct=100) action=oreject header.from=juniper.net; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ywbijmLOpCkD6Hn7UAL30TPCLKqUyZkdruN7lh20n4c=;
 b=WKVS1ubXaumGftUgduwZNIZVT4D9XhbcP/hJl8caXgdme0ka/U8rJGPyDwmgz9QdtHawd3xGedpJSu2Ry0WMMPCFAWptf7AAlhzMoAkm7QXohVPYkJ2E9I4a+ScMfsWeCuQLsFsU/c0TbmWI2hdS1psNPfF250MHY6XTpFW/1Khd6jfr7i9L9kvTTggMbfscOiOiCV5gL5YhBz9QOqqO1by59eGT0ek1UuBLfcUoXAKf/YjWTCIljaHaLXb+FpJrBRyziaaFNHnzU+gW9B9LsbnfxIdXzzTCuE00syrDsC1r5ZNgLaecWkmuI6AR/5C5YHpzRXvWvreUkLcTSvgkZg==
Received: from BN9PR03CA0898.namprd03.prod.outlook.com (2603:10b6:408:13c::33)
 by DS3PR05MB817070.namprd05.prod.outlook.com (2603:10b6:8:546::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Mon, 28 Sep
 2026 20:36:43 +0000
Received: from BN6PEPF00000072.namprd03.prod.outlook.com
 (2603:10b6:408:13c:cafe::2) by BN9PR03CA0898.outlook.office365.com
 (2603:10b6:408:13c::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.23 via Frontend Transport; Mon,
 28 Sep 2026 20:36:43 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=none (sender IP
 is 66.129.239.19) smtp.mailfrom=ebf951f79306.juniper.net; dkim=none (message
 not signed) header.d=none;dmarc=fail action=oreject header.from=juniper.net;
Received-SPF: None (protection.outlook.com: ebf951f79306.juniper.net does not
 designate permitted sender hosts)
Received: from juniper.net (66.129.239.19) by
 BN6PEPF00000072.mail.protection.outlook.com (10.167.248.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Mon, 28 Sep 2026 20:36:42 +0000
Received: from p-exchfe-eqx-03.jnpr.net (10.104.9.50) by
 p-exchfe-eqx-04.jnpr.net (10.104.9.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 28 Sep 2026 13:36:41 -0700
Received: from p-exchbe-eqx-03.jnpr.net (10.104.9.86) by
 p-exchfe-eqx-03.jnpr.net (10.104.9.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 28 Sep 2026 13:36:41 -0700
Received: from ebf951f79306.juniper.net (10.104.20.6) by
 p-exchbe-eqx-03.jnpr.net (10.104.9.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 28 Sep 2026 13:36:41 -0700
Received: by ebf951f79306.juniper.net (Postfix, from userid 14867)
	id E2B3B13308F2; Mon, 28 Sep 2026 13:36:40 -0700 (PDT)
From: Prashant Singh <singhpra@juniper.net>
To: <ardb@kernel.org>, <jk@ozlabs.org>
CC: <bigeasy@linutronix.de>, <clrkwllms@kernel.org>, <rostedt@goodmis.org>,
        <corbet@lwn.net>, <skhan@linuxfoundation.org>, <rdunlap@infradead.org>,
        <lgoncalv@redhat.com>, <93sam@debian.org>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-rt-devel@lists.linux.dev>,
        Prashant Singh <singhpra@juniper.net>
Subject: [PATCH v4] efivarfs: add nostatfs mount option to skip QueryVariableInfo()
Date: Mon, 28 Sep 2026 13:34:45 -0700
Message-ID: <20260928203445.72318-1-singhpra@juniper.net>
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
X-MS-TrafficTypeDiagnostic: BN6PEPF00000072:EE_|DS3PR05MB817070:EE_
X-MS-Office365-Filtering-Correlation-Id: 047c1f77-feed-423d-876f-08df1da03486
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35950700016|7416014|1800799024|376014|10067099003|11063799006|6133799003|3023799007|18002099003|56012099006|13003099007;
X-Microsoft-Antispam-Message-Info:
	wvrdqvFBZ1r2z8cKMaj8wbAJNfNJ/JzbI2vx4+hzJH++MQZvWvHJL9q9h6HjL5k49TQK9xuQsovf7NE6FSE9ERfgmNy6rm4wt36L9qD8fF/veOiMZk0UbbLqmh6MerFeRo9/2FSqpRDVWh5pi8VXYL8MbErNJCwM1WY3D9DNMRmhwZCG/Zl5il57cchml5+Ei0/0cIDhaCTF5WAMTLuxe59cRx9Nb5pPk3r3t3EVZ4/RcwctShv3Hd3iA4IV8JvFUBA0oIJ7c8F9Wh4WNTWGhEvN2JJHKhnCuSvOn8UQUALWIxvtF3f4/xaY3VJmmviZF53ibavS4dIcXymTOuyYxqkr3dMnb2Fn40gYli2KT4X2mjb9n9IR9MU4udCSmmtpAyJUJrT1GaGCnVT5eiKNATvH4F7DawgZHJGyUdo6SnvaJ6r57NQ78yRQZzqAS20vK+N3ImBv/t3khQ9o+mGb6E4kpf2NqBD8G4yx36Ge3OUPr3qjFgsA2th5obeN5P1/Pp/+TARMzqDqE9LsZCN/x6Lc1IkM4tewmrZTHaq7Zg4k+nm+YW1CaqGMveFcVm13SlPXJQaISSjtD/jzPjL6FCTucKkmD1Kak3tCf+Q4AJwfcaHjkhpQ9QK7zDL01rwZB4OQ1Rco2MOUcIC4qXbiIjNjlms0hWaLu4yKceCJ2PVjSDhGpybx1qHEzudoZEmp2AGVhGrapwPdZPWoa3Rjlw==
X-Forefront-Antispam-Report:
	CIP:66.129.239.19;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:juniper.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35950700016)(7416014)(1800799024)(376014)(10067099003)(11063799006)(6133799003)(3023799007)(18002099003)(56012099006)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jFrrIcsrhRaZRd3q77ftbfjdvZrRB7+gRax89Fg0fdi/gZ58IkODiHyoArgm4iYfO1juWmLyhbTcnxeBTMzqhpDbYcKivNBIU4xlMwZ2Eo++UkJbAviJFwrkpG+hgYe9myMM4PVYMSy7CYk92boZg+Ky2wmVgjTT2wKLGK4RvQNGlqoqxVldgvgbBge/xiPEAYscUSzro9MthaaqgIMWmQ2+89gtRQ5i6TxcltqCdfVekdbd2iOGT6vNk5wRBUq2JqangRp3LT3/Tuh+RZK/yMHFF17yDkYRDVEb0FcjPAU6ZmZ9w0QgdZ5HtN0CvCq2cauNhoKhDnKaVZTxETuLeuAy8YiI61XvNLXmE66HwELWDzB4p7fT3i4hRNMSVG/GqD3XbOa68sgIFMdMCoOrY63YAKw97zxklgcXouNXIfSjVz3JAqDELco6/5r/97I8
X-Exchange-RoutingPolicyChecked:
	wS3U+bfhki/pnqhrRJihpa9UsUt5yCnBHiZH6gFVE4DOzp47fziZoPkWjOqWixqTIItIQMeAFJXij1Rl89AaeeKPYTymXgF5hVUCZXKKZo2zVK+a7mHJydwapRVnBuzq5QKdvCf5Tk5+Wwq1kmTRFXRPa392aZKz/QHHUS9pMzieAiY9NEf4quoML4JJokk/NCEiLzSuFec1fv6K8gHL1Z40zCrZXMIdHWUZIsgp68cNA3cvDAWHod3roY47SeZ5n9P0vTm7yN03POs7NpcgvVvWxqExJPDWqiDKmXu/JHoq+jJoVhszS3coohCfHpIwjfsNNi5EsqHuitRVaYNVoA==
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2026 20:36:42.1795
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 047c1f77-feed-423d-876f-08df1da03486
X-MS-Exchange-CrossTenant-Id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bea78b3c-4cdb-4130-854a-1d193232e5f4;Ip=[66.129.239.19];Helo=[juniper.net]
X-MS-Exchange-CrossTenant-AuthSource:
	BN6PEPF00000072.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR05MB817070
X-Authority-Analysis: v=2.4 cv=DJcacCNb c=1 sm=1 tr=0 ts=6abacfde cx=c_pps
 a=3V8RUmgbnuIO8ORuzDaQ6A==:117 a=SKdRtqzh2DBFgDMvUaaGnA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=f7IdgyKtn90A:10 a=rhJc5-LppCAA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gQcMVamqm3wCPoSYhaRC:22 a=6_mrDcixewTG61oOsKN3:22 a=VwQbUJbxAAAA:8
 a=OUXY8nFuAAAA:8 a=JrPZwpGjJBhuogoWf-EA:9 a=cAcMbU7R10T-QSRYIcO_:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA4MSBTYWx0ZWRfX1a8ydV9Plp1M
 tkyOiSyrpZKCw1aa6Rq/YHVMTJJqTGFf86FHfvkwBr+59ZujVAMnw8qrsJUpPoWb7WH7b6cg7Vb
 qsbLpY5WIz/pVW2qMS980VyKhwDRKB8=
X-Proofpoint-ORIG-GUID: oE9XyOfUQaQqrLSLRyfyrupmAKuIriHm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA4MSBTYWx0ZWRfX/qVtkolJv//r
 dOBTDILDseGQ+Zbvlu0joh0NuV1rH/F1XdUSzhX9zhADoOovULWSqE1zvjtN9uM9BL5MT+0WdQt
 UwxmSKLukvi0J8AcDzZfl1OEggJinYK7GVlAzoylbeZC7pnrThv4lWdjZxSKKouySwD/HN0QQhy
 Sf65fXrb5oT+HhitOMMett0PBSGJpfKeEwoh0096tr165YCfB5mRn9qR9C8N2ZXc+5UE5D9lYt8
 0aYt6lFvqExisT8cEIsV/T6GaW3bo3F2wjFQnGS+kC/7OAijZ7K6T9fcJkMWoDn2QPhSznmHv3s
 VhxPLWo5mIA2gwIVPg/dXAYT+GJh/9BLfQ3VcsPNlVUe8T4MDTHT3mQCV0wisAr+FIRVTakNLeE
 k2OYjLHwxF6Qud2ldmJnrcVGyvETWUwvUWuAkauKFpmccme1JhmYRB0gGE5VnskI2ASZyagIwPq
 mIC+068RNJDxT0/MH3w==
X-Proofpoint-GUID: oE9XyOfUQaQqrLSLRyfyrupmAKuIriHm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_05,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: orgsafe
X-Proofpoint-Spam-Details: rule=outbound_safe policy=outbound score=0
 clxscore=1015 bulkscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 adultscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=orgsafe scancount=1 engine=8.22.0-2609040000
 definitions=main-2609280081

QueryVariableInfo() is an EFI runtime service that, on some firmware,
takes tens of milliseconds and runs with preemption disabled, stalling
the CPU that services it. efivarfs_statfs() calls it (rate-limited since
commit b2326338dc68 ("efivarfs: Rate limit statfs() handler")) to report
the variable-store used/available capacity, so any statfs(2) -- e.g.
every "df" -- can inject that stall into unrelated latency-sensitive
workloads on the same CPU.

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

Tested on an Intel Xeon E5-2628L v4, 6.12 kernel, via
"strace -T -e trace=statfs df" on the efivarfs mount.

Cost of the firmware call (CONFIG_PREEMPT_RT not set, so reporting is
enabled by default). Default mount calls QueryVariableInfo() and returns
the real store capacity, ~66-129 ms per call:

  statfs("/sys/firmware/efi/efivars", {f_type=EFIVARFS_MAGIC,
      f_bsize=1, f_blocks=90024, f_bfree=33387, f_bavail=28267, ...})
      = 0 <0.129124>

With -o nostatfs the firmware call is skipped, capacity reported as
zero, ~11 us per call:

  statfs("/sys/firmware/efi/efivars", {f_type=EFIVARFS_MAGIC,
      f_bsize=1, f_blocks=0, f_bfree=0, f_bavail=0, ...}) = 0 <0.000011>

PREEMPT_RT default and live remount toggle (CONFIG_PREEMPT_RT=y). The
boot-time mount defaults to nostatfs (mount shows nostatfs); no firmware
call, capacity zero:

  statfs(... f_blocks=0, f_bfree=0, f_bavail=0, ...) = 0 <0.000018>

Enabling reporting in place with "mount -o remount,statfs" (mount now
shows statfs) takes the ~70 ms firmware call and returns the real
capacity, without unmounting:

  statfs(... f_blocks=90024, f_bfree=30315, f_bavail=25195, ...)
      = 0 <0.070293>

Disabling it again with "mount -o remount,nostatfs" returns to the fast,
zero-capacity path:

  statfs(... f_blocks=0, f_bfree=0, f_bavail=0, ...) = 0 <0.000014>

An unrelated remount that does not respecify the option preserves it: a
"mount -o remount,rw" after "remount,statfs" leaves the mount showing
statfs.

Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Prashant Singh <singhpra@juniper.net>
---
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

 Documentation/filesystems/efivarfs.rst | 16 +++++++++++
 fs/efivarfs/internal.h                 |  1 +
 fs/efivarfs/super.c                    | 38 ++++++++++++++++++++++----
 3 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/efivarfs.rst b/Documentation/filesystems/efivarfs.rst
index f646c3f0980f..cd81ee84115b 100644
--- a/Documentation/filesystems/efivarfs.rst
+++ b/Documentation/filesystems/efivarfs.rst
@@ -37,6 +37,22 @@ accidentally.
           |4_bytes_of_attributes + efivar_data|
           +-----------------------------------+
 
+Mount options
+=============
+
+statfs / nostatfs
+      Control whether ``statfs(2)`` reports the variable-store used/available
+      capacity. Obtaining it requires the ``QueryVariableInfo()`` EFI runtime
+      service, which on some firmware takes tens of milliseconds and runs with
+      preemption disabled, stalling the calling CPU. With ``nostatfs`` the call
+      is skipped and ``statfs(2)`` reports zero. The default is to report,
+      except on ``CONFIG_PREEMPT_RT`` where it defaults to ``nostatfs``; pass
+      ``statfs`` there to force reporting back on (e.g. for tools such as fwupd
+      that need the free space for firmware updates). The option can also be
+      flipped on a live mount with ``mount -o remount,statfs`` /
+      ``mount -o remount,nostatfs``, so reporting can be enabled only for the
+      duration of a firmware update without unmounting efivarfs.
+
 *See also:*
 
 - Documentation/admin-guide/acpi/ssdt-overlays.rst
diff --git a/fs/efivarfs/internal.h b/fs/efivarfs/internal.h
index f913b6824289..0cb053884b4b 100644
--- a/fs/efivarfs/internal.h
+++ b/fs/efivarfs/internal.h
@@ -11,6 +11,7 @@
 struct efivarfs_mount_opts {
 	kuid_t uid;
 	kgid_t gid;
+	bool nostatfs;		/* skip QueryVariableInfo() in statfs() */
 };
 
 struct efivarfs_fs_info {
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 8d33f11db2a1..efeada6e314f 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -74,6 +74,9 @@ static int efivarfs_show_options(struct seq_file *m, struct dentry *root)
 	if (!gid_eq(opts->gid, GLOBAL_ROOT_GID))
 		seq_printf(m, ",gid=%u",
 				from_kgid_munged(&init_user_ns, opts->gid));
+	/* Absence of nostatfs means statfs() reports real capacity. */
+	if (opts->nostatfs)
+		seq_puts(m, ",nostatfs");
 	return 0;
 }
 
@@ -82,13 +85,19 @@ static int efivarfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	const u32 attr = EFI_VARIABLE_NON_VOLATILE |
 			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
 			 EFI_VARIABLE_RUNTIME_ACCESS;
+	struct efivarfs_fs_info *sfi = dentry->d_sb->s_fs_info;
 	u64 storage_space, remaining_space, max_variable_size;
 	u64 id = huge_encode_dev(dentry->d_sb->s_dev);
 	efi_status_t status;
 
-	/* Some UEFI firmware does not implement QueryVariableInfo() */
+	/*
+	 * Some UEFI firmware does not implement QueryVariableInfo(); the
+	 * nostatfs mount option also disables this (preempt-disabled,
+	 * potentially slow) call entirely, reporting zero used/available.
+	 */
 	storage_space = remaining_space = 0;
-	if (efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO)) {
+	if (!READ_ONCE(sfi->mount_opts.nostatfs) &&
+	    efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO)) {
 		static DEFINE_RATELIMIT_STATE(_rs, 2 * HZ, 5);
 		static u64 storage, remaining;
 		static DEFINE_SPINLOCK(lock);
@@ -323,12 +332,13 @@ static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
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
 
@@ -350,6 +360,9 @@ static int efivarfs_parse_param(struct fs_context *fc, struct fs_parameter *para
 	case Opt_gid:
 		opts->gid = result.gid;
 		break;
+	case Opt_statfs:
+		opts->nostatfs = result.negated;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -402,11 +415,17 @@ static int efivarfs_get_tree(struct fs_context *fc)
 
 static int efivarfs_reconfigure(struct fs_context *fc)
 {
+	struct efivarfs_fs_info *sfi = fc->root->d_sb->s_fs_info;
+	struct efivarfs_fs_info *new_sfi = fc->s_fs_info;
+
 	if (!efivar_supports_writes() && !(fc->sb_flags & SB_RDONLY)) {
 		pr_err("Firmware does not support SetVariableRT. Can not remount with rw\n");
 		return -EINVAL;
 	}
 
+	/* statfs() reads nostatfs without s_umount; mark the concurrent update. */
+	WRITE_ONCE(sfi->mount_opts.nostatfs, new_sfi->mount_opts.nostatfs);
+
 	return 0;
 }
 
@@ -524,8 +543,17 @@ static int efivarfs_init_fs_context(struct fs_context *fc)
 	if (!sfi)
 		return -ENOMEM;
 
-	sfi->mount_opts.uid = GLOBAL_ROOT_UID;
-	sfi->mount_opts.gid = GLOBAL_ROOT_GID;
+	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
+		/* nostatfs is writable via remount; keep it if not respecified. */
+		struct efivarfs_fs_info *old = fc->root->d_sb->s_fs_info;
+
+		sfi->mount_opts.nostatfs = READ_ONCE(old->mount_opts.nostatfs);
+	} else {
+		sfi->mount_opts.uid = GLOBAL_ROOT_UID;
+		sfi->mount_opts.gid = GLOBAL_ROOT_GID;
+		/* QueryVariableInfo() stalls the CPU; default nostatfs on PREEMPT_RT. */
+		sfi->mount_opts.nostatfs = IS_ENABLED(CONFIG_PREEMPT_RT);
+	}
 
 	fc->s_fs_info = sfi;
 	fc->ops = &efivarfs_context_ops;

base-commit: 9b87fdc9af2fbfcdb5c24a64139685ef80f6573f
-- 
2.34.1

