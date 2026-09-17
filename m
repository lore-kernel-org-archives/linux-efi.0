Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96100443E3F;
	Thu, 17 Sep 2026 07:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.143.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789629430; cv=fail; b=BYMvzOMyKSBg1m7juF1A8vd5dzaBgcfRmIlyW0lx7mVbzUJdD0FQUmqSBGESq6KLxsM9ATC1Bc82/SdbYoJ+3xXrSySreqdF+MXmwvEkV6Q4afdj9pQl/gqNrSjZgt48fA2UZ/8iAUJnLkl7bJlyKwxmOn4904qU3GiJv0rOCN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789629430; c=relaxed/simple;
	bh=u7+Yv9eKmUByJCfwzVtjJcuW2JDcjUMIEl7JC08M3a8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WRRIDoOIkhjb4shOhkaaiOitp8fzXkf7WDyIu0SoIhGj77viKVx9QEI9kTYGvuQY3WBuYm3CYjh+RRj18PSKuzez1yof41JG+bcFM5ney3bf3suvjp6PDFHFK2J8mFfks4S7As6oKCnMwWVFHnEvRZ8RwWmUM9gNMqT4HcDJZZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=juniper.net; spf=fail smtp.mailfrom=junipernetworks.onmicrosoft.com; dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b=0ERSYqxx; dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b=eyuSVyH6; arc=fail smtp.client-ip=148.163.143.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=juniper.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=junipernetworks.onmicrosoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b="0ERSYqxx";
	dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b="eyuSVyH6"
Received: from pps.filterd (m0150244.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H6Hpin4035767;
	Thu, 17 Sep 2026 07:16:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=jnprhpepp0429; bh=sfMhjQ1XsRxfxR7Xtt
	mqqI79Gjky1dPE4X6ePXIXHbY=; b=0ERSYqxxmZ52O+l9r/pjUdxGkNu1zX8vnH
	xj/dCFWjTymUU12balWChUwwtp/9LBKT8Dr48ye1ql7PRnOmeRoZiJVtrvq+vQmx
	uL4TVoXsU9U0D3jgqHtETTd+0WH/fU133CN4bNqpjuzm0bbsXX6jti9BoyhMziFh
	iDkC2E+hieocnPvgAG0e1O1bRsx0BSAYjwxUi0h07mr0yCDY6UddqxmnFzXAqDhI
	gDv0U7+8GsWKgHLAuNUqCQh2vj/UZyo0T3NW9hisYR3qpeBl/eKqdoYMXKS7a2ER
	5O/WmPID8EGOnCHsoZX56jC6KGiYNAj3S1eD6N2THtGbAOktlA3Q==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012036.outbound.protection.outlook.com [40.93.195.36])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4gratkgqke-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 17 Sep 2026 07:16:11 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G5uWJEtWPKwn1dfnN8DqWvxaQkJUXi5LorMbQvA+Fl4+3AH/w8ZoMoZjZH7u7hEltAorF2p2mkPIFynz1CJf0zXTQ8LDJf4+7pxojcCftdPjGsVxcKQK/dOP9rA8SeQrs8oVraI14tbJE2xDDGON3qt+/ndSwhCVBNIsz9IpJk5IdzoFXQy/kzpuhZYhbuRR2FVnSXpswqBEnOwbRDvYXJmLVpSaOjCpH7BmBHNi8PsSXyrDkaixuMICWP+dm0wXpFHQZVF3EhK4rIdAwmG7tefL57eQeBEcPP2lpuZzKb6swVUSFNtErFpizBWnq5eZxMTd15r3OdMAgZABb68oOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=sfMhjQ1XsRxfxR7XttmqqI79Gjky1dPE4X6ePXIXHbY=;
 b=sXB6i1nKIi2nCDfDA8F0fd3mUZu9tlaDcr6TOon/+SNjd3R3dGzEhdkihs0MPJO3AFTb2SLyNBz8Hvyc3rCsWqwRild9OHwqZjzyOo5d9W3U211T0+eHs3kJvZwRmGlY6CDRV3lcyPf8W8UCpFmg4J4zyyNHgzAuyivPjOaG1CF19c0ylpUxsvoAsz4MAt7hYT3TQCmN0bjys44UWvAt9zQ+PWZfjaeisWxUwFOAPv8WgdBrduudJCJTfYH/rWzsB755AK1yMuaUwz71SrnwRR2Z46WyFa2NMaybG+cGVnqJxBn1ASUnxzffSmtW9DdRfO5ZCAVeYeEiwApkQCV9aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 66.129.239.19) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=ebf951f79306.juniper.net; dmarc=temperror action=none
 header.from=juniper.net; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sfMhjQ1XsRxfxR7XttmqqI79Gjky1dPE4X6ePXIXHbY=;
 b=eyuSVyH6DTtsslInJMrZ59vo1lUx5+cADPOC7HjwKeFw5gMC9jh1krEChLQvao9UIxPAbpq3mCN8crvOYDzEPdv25MaUPtrYcTuj3itwrcz+FXr5IvZFRBhHQa4j5nHFdhP47bNgUB9a2P4DWwtoCvowe7wh17fP9HstURLzAQ8+UarxcvoqM370xeHyMWgrUASxmdeOLTCIHT20mo7FOCLgtviYHMtjdHL9rKCLFMnJa9gITmEw4Ud4QQYh7TXIVlvuz3vP34+MqaCw1IUykqf3/uk2OFc5Pvm1jvWAmAdbMgf6jnSwhkkD5yjta2sfpLF6feSpMsqCuaLCAn0qCw==
Received: from MN0P222CA0026.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:531::31)
 by PH7PR05MB9154.namprd05.prod.outlook.com (2603:10b6:510:1f6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Thu, 17 Sep
 2026 07:16:05 +0000
Received: from BN2PEPF000044AA.namprd04.prod.outlook.com
 (2603:10b6:208:531:cafe::58) by MN0P222CA0026.outlook.office365.com
 (2603:10b6:208:531::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Thu,
 17 Sep 2026 07:16:04 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 66.129.239.19) smtp.mailfrom=ebf951f79306.juniper.net; dkim=none (message not
 signed) header.d=none;dmarc=temperror action=none header.from=juniper.net;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of ebf951f79306.juniper.net: DNS Timeout)
Received: from juniper.net (66.129.239.19) by
 BN2PEPF000044AA.mail.protection.outlook.com (10.167.243.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 17 Sep 2026 07:16:03 +0000
Received: from p-exchbe-eqx-04.jnpr.net (10.104.9.87) by
 p-exchfe-eqx-04.jnpr.net (10.104.9.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 17 Sep 2026 00:16:03 -0700
Received: from p-exchbe-eqx-04.jnpr.net (10.104.9.87) by
 p-exchbe-eqx-04.jnpr.net (10.104.9.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 17 Sep 2026 00:16:03 -0700
Received: from ebf951f79306.juniper.net (10.104.20.6) by
 p-exchbe-eqx-04.jnpr.net (10.104.9.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 17 Sep 2026 00:16:03 -0700
Received: by ebf951f79306.juniper.net (Postfix, from userid 14867)
	id 01C028CF1EE; Thu, 17 Sep 2026 00:16:02 -0700 (PDT)
From: Prashant Singh <singhpra@juniper.net>
To: <jk@ozlabs.org>, <ardb@kernel.org>
CC: <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <corbet@lwn.net>, <linux-doc@vger.kernel.org>,
        Prashant Singh
	<singhpra@juniper.net>
Subject: [PATCH] efivarfs: avoid slow QueryVariableInfo() in statfs()
Date: Thu, 17 Sep 2026 00:16:00 -0700
Message-ID: <20260917071600.5587-1-singhpra@juniper.net>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AA:EE_|PH7PR05MB9154:EE_
X-MS-Office365-Filtering-Correlation-Id: 85b11fb6-f59b-4de8-139c-08df148b88ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35950700016|376014|1800799024|11063799006|56012099006|10067099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	ppq2BAf1isHXvUq6H8PvDk8LJtcPnCqkSIjHpaz/az9lsEjklIQryUp+tyZt+xv2wE0ze2H/CbwgNispcWwtjZivr4Q+M5sDNO93dRMJY6x7lRnbzRyjoQ22QYcFKxoi4ngUWnhVIeyDZ4+f8lr0MwnAxSDLi5vZZP0go9zfhWFcmhIVdCua0+wYM1D4AS8f1BdLRFkMMxIiZFM7LzgwMPaTmekeO8fNTibrwzJidEVGIkCK23uzkm6J7O5dJRzjvp0ZYvth5++FAmEmju8QKIQI2P26dp1vfYY+df+E8SmgKKmp5zHijwZhYulWyrq1av6JpqJhWWRIXyZQhNgrMR8dd/qZac7s6smExLquY2MauJ31VigtiYFHmSm+6odMRXK85rNDXngoxW52pruKkHBRNs1OhZpYYdYk54zNbo6EPitg+U8KK+cK6fU+IQ9YpFbcl9RLKteoPFXAsUgFAFcZjD2QEUyMDIFIUM+cGFxm/KBJXuGkSkgN+eFxWB73O4l6kpDzTkSD3gAWY8VUMQZpZkK0KwWLcbhxWZkp2u1AByBv165U1JFqJ7G+IMqnKyR5lOdLys+RHbaURKooubKyFrfnYxQSh86iacPCIJCh0kOzhj7t+6/gQPLBR2XpjPZjYn8qtY3NVk9ZmDZBSunMHMtrLHidk6x3zp29nXuNAfdzCpUw4zYXAhRYquQCCGZpPwXskWuC9l4izFGREw==
X-Forefront-Antispam-Report:
	CIP:66.129.239.19;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:juniper.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35950700016)(376014)(1800799024)(11063799006)(56012099006)(10067099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NC7JEDsCP7wL3AlkVmIfq6hjijKZya7m0vIF535lFuP65UDAXLrCsioV4rOqC1HeTmuWSKlmFNueilZCgPGWK7e8yBHMKRRpatKerTLnGmJmili7M0eGvnQtam15m3uwWIRFQuXatByQyeYBeO+VoiWOJmzN6mJcDqa9wxmuI8kG4x+cPVE0QQpT3Ol4CbHaiPCGEU1A4ykkSJjrcnC+soOIeL7aH5LNhHjoCua3n+euESdURlHY+p3HQmq7yUMSuZwt4ZA8g3do9tjaz8jFmwpXxUoPbho2190z667DXlTjlrgAOzK69fUS6NLRg6qziNIgu++/OHqGG2zbLjET1eAotrRjrMAJQNBQDSXZO5DZ81YTwaV/5P6MTiEiPGig0HCLdUFRTH6fjThWqu16dwvTcuSZSsyXb2BpJwNfPNlYge6gk0VKEbw66FjO7+X8
X-Exchange-RoutingPolicyChecked:
	eaS89BWhCKdXdiIkMwFLbo1eILu6cniDIau9SR3CdRf/8qGm1J2Vv8bpCwnYfBvlJH2HDMPp/6XfQa4yOZcadszviz7+bNpNoF1CGAHzTwRCo61ypea3qJVVMlP+z3bX5Wp/Sp9XJF0hbzp9FN91TOlIhauqIcdn8OemGzfM1qiNQFGGMwANn/Y3PXo+T8Y9yax0jMWqOC9lyBkbTWyJ4dSqRHD7rHPM5eKJMzI+/CzoVm1hJjgLVzWWz5OdRivDQQILCyA0BHeVmEO3+P3vW7ggDpk4yOL2Pmp0gYOiCLqqjA1vmAaRqaSLYsRgHxn4+m0Cvd+xooYDS8T8lw2s/g==
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 07:16:03.8666
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85b11fb6-f59b-4de8-139c-08df148b88ea
X-MS-Exchange-CrossTenant-Id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bea78b3c-4cdb-4130-854a-1d193232e5f4;Ip=[66.129.239.19];Helo=[juniper.net]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR05MB9154
X-Proofpoint-ORIG-GUID: _gUTYIoUd6gy8D-utm0gRk9eHzPUcIvk
X-Authority-Analysis: v=2.4 cv=Mf75KJ/f c=1 sm=1 tr=0 ts=6aab93bb cx=c_pps
 a=1PMvcOD3Mx+UKTR1GZf1Bw==:117 a=SKdRtqzh2DBFgDMvUaaGnA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=f7IdgyKtn90A:10 a=rhJc5-LppCAA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gQcMVamqm3wCPoSYhaRC:22 a=k7r4yCLl9DVLXMiQTbtC:22 a=OUXY8nFuAAAA:8
 a=rCguw8SgujSS4CoPRXEA:9 a=cAcMbU7R10T-QSRYIcO_:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDA5NyBTYWx0ZWRfXxhFQfh941Npv
 ulYd1nxTY89Je6eEJdGHSshBMEVrvgvdZ1VWp/HFNGFDjuL5lCwyNCOGoHDyvkgbJmOXlNkm19c
 MVlHtO1zrfoMfVh4yZIOHIed94U7vj4mbtE/KcXMkffHSYynpGOd6u+StsCpvkZvEoes8rdBiFE
 66oZRI7+E5lMyXvdZ8zKdZIV3S8UPVrpzqDtukWR2xRg0QntDXB+QMwZBuv481C49o0gaZ+iamZ
 Z4VPi8fPtO+hC9DAB9uZ6i7td0O47Xvq6AylNw91EKy85CKGMCi0k883/QUHt5Ws3ekXD/MyU7c
 VoK4GJXqcWGf00fnN7A5PLRYYMK4Wpm4KylJQHFchQHwjVwpKIawKEwm2dMRyFgsMKzbpRSWaeP
 6s3nXybqQA4bdi4RksxPma5gDMfEPrGeXRNNJ0zUeInRZ91fWKQTzq7+Vri88/txwCTvrK4OgbG
 MnNnI27g+H1/Ul3ZEOg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDA5NyBTYWx0ZWRfX1bXfTH221sph
 sSKNbDSMH5hqq44WeivDs+erNXBofqRpoCwL5Lo0Wwbxv0ciO49g98Z0qN/PC8kFUtkwXBm+Eib
 TCSlYeAeNeWrSPIPcvHG9ZB0+MLFiUE=
X-Proofpoint-GUID: _gUTYIoUd6gy8D-utm0gRk9eHzPUcIvk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-17_01,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: orgsafe
X-Proofpoint-Spam-Details: rule=outbound_safe policy=outbound score=0
 bulkscore=0 impostorscore=0 spamscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 clxscore=1011 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=orgsafe scancount=1 engine=8.22.0-2609040000
 definitions=main-2609170097

QueryVariableInfo() is an EFI runtime service that, on some platforms,
takes tens of milliseconds and runs with preemption disabled, freezing
the CPU that services it for the whole call. efivarfs_statfs() issued
this call on every statfs(2) (e.g. every "df"), which produced large
latency spikes for unrelated latency-sensitive workloads pinned to the
same CPU.

Commit b2326338dc68 ("efivarfs: Rate limit statfs() handler") already
bounds the firmware call to twice per second. That helps against a
statfs() flood, but on a real-time / dataplane system even the residual
2 calls/s x ~40ms = up to ~80ms/s of preempt-disabled CPU time is
unacceptable: any unprivileged process (or a periodic monitoring "df")
can still inject ~40ms stalls into a co-located latency-sensitive task.

Cache the reported capacity instead of querying firmware from the
statfs() hot path:

  - The cache is primed once at mount time so df has valid numbers.
  - When fs.efivarfs.statfs_refresh is set (default 1, preserving the
    current rate-limited behaviour), statfs() refreshes the cache in the
    same rate-limited way.
  - Latency-sensitive systems can set fs.efivarfs.statfs_refresh to 0 so
    statfs() never calls firmware; the cache is then kept up to date only
    by mount and explicit fs.efivarfs.force_refresh writes.
  - fs.efivarfs.force_refresh is a write-only knob that forces an
    immediate synchronous re-query on demand.

On a hard query failure (a status other than EFI_SUCCESS or
EFI_UNSUPPORTED) the last known-good cached value is retained rather than
overwritten, so a transient firmware error does not zero out the
reported capacity.

Measured on an Intel Xeon E5-2628L v4 (6.12 kernel), per statfs(2) on the
efivarfs mount:

  # fs.efivarfs.statfs_refresh = 1 (firmware call on the hot path)
  $ strace -T -e trace=statfs df 2>&1 | grep -i efivars
  statfs("/sys/firmware/efi/efivars", {...}) = 0 <0.062993>
  statfs("/sys/firmware/efi/efivars", {...}) = 0 <0.064343>

  # after: sysctl fs.efivarfs.statfs_refresh=0 (served from cache)
  $ strace -T -e trace=statfs df 2>&1 | grep -i efivars
  statfs("/sys/firmware/efi/efivars", {...}) = 0 <0.000009>

  # in a tight df loop with refresh=1, rate-limited hits show the cache
  # (sub-ms) interleaved with the ~63ms firmware calls:
  statfs(...) = 0 <0.063705>
  statfs(...) = 0 <0.000429>
  statfs(...) = 0 <0.000079>

force_refresh picks up an intervening variable write on demand without
re-enabling the hot-path call:

  $ df -h | grep efivars
  efivarfs   88K  54K  30K  65% /sys/firmware/efi/efivars
  $ sysctl -w fs.efivarfs.force_refresh=1
  $ df -h | grep efivars
  efivarfs   88K  55K  29K  66% /sys/firmware/efi/efivars

Signed-off-by: Prashant Singh <singhpra@juniper.net>
---
An alternative would be to expose statfs_refresh as an efivarfs mount
option instead of a global sysctl (per-mount, no new sysctl ABI, and a
remount could re-prime the cache in place of force_refresh). I went with
the sysctl for a live runtime toggle and because the variable store /
cache are inherently global, but I'm happy to respin as a mount option
if that's preferred.

 Documentation/admin-guide/sysctl/fs.rst |  24 +++++
 fs/efivarfs/super.c                     | 132 +++++++++++++++++++-----
 2 files changed, 128 insertions(+), 28 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/fs.rst b/Documentation/admin-guide/sysctl/fs.rst
index 9b7f65c3efd8..4b6683b6791c 100644
--- a/Documentation/admin-guide/sysctl/fs.rst
+++ b/Documentation/admin-guide/sysctl/fs.rst
@@ -76,6 +76,30 @@ they help speeding up rejection of non-existing files provided
 by the users.
 
 
+efivarfs
+--------
+
+These entries appear under ``/proc/sys/fs/efivarfs`` and control how
+``statfs(2)`` on an efivarfs mount reports the EFI variable-store
+capacity. The capacity is obtained from the ``QueryVariableInfo()`` EFI
+runtime service, which on some x86 platforms can take tens of
+milliseconds. To avoid this cost on the ``statfs(2)`` hot path the
+reported capacity is cached; these knobs control how the cache is
+refreshed.
+
+``statfs_refresh`` (default 1)
+  When set to 1, ``statfs(2)`` refreshes the cached capacity by calling
+  the firmware, rate-limited to a few calls every couple of seconds.
+  When set to 0, ``statfs(2)`` never calls firmware and always serves the
+  cached value; the cache is then updated only at mount time and by
+  ``force_refresh``. Set this to 0 on latency-sensitive systems.
+
+``force_refresh`` (write-only)
+  Writing any value forces an immediate, synchronous re-query of the
+  firmware to update the cache. Useful to pick up capacity changes when
+  ``statfs_refresh`` is 0. The written value is ignored.
+
+
 file-max & file-nr
 ------------------
 
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 8d33f11db2a1..1e7e81766c28 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -19,6 +19,7 @@
 #include <linux/notifier.h>
 #include <linux/printk.h>
 #include <linux/namei.h>
+#include <linux/sysctl.h>
 
 #include "internal.h"
 #include "../internal.h"
@@ -77,44 +78,71 @@ static int efivarfs_show_options(struct seq_file *m, struct dentry *root)
 	return 0;
 }
 
-static int efivarfs_statfs(struct dentry *dentry, struct kstatfs *buf)
+/*
+ * Cached EFI variable-store capacity: QueryVariableInfo() is costly on some
+ * firmware, so statfs() serves this cache instead of calling firmware.
+ */
+static DEFINE_SPINLOCK(efivarfs_cap_lock);
+static u64 efivarfs_cap_storage;
+static u64 efivarfs_cap_remaining;
+
+/*
+ * fs.efivarfs.statfs_refresh (default 1): when set, statfs() refreshes the
+ * cached capacity, rate-limited. Set to 0 on latency-sensitive systems so
+ * statfs() never calls firmware; the cache is then updated only at mount and by
+ * fs.efivarfs.force_refresh.
+ */
+static int efivarfs_statfs_refresh = 1;
+
+static void efivarfs_query_capacity(void)
 {
 	const u32 attr = EFI_VARIABLE_NON_VOLATILE |
 			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
 			 EFI_VARIABLE_RUNTIME_ACCESS;
-	u64 storage_space, remaining_space, max_variable_size;
-	u64 id = huge_encode_dev(dentry->d_sb->s_dev);
+	u64 storage_space = 0, remaining_space = 0, max_variable_size;
 	efi_status_t status;
 
-	/* Some UEFI firmware does not implement QueryVariableInfo() */
-	storage_space = remaining_space = 0;
-	if (efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO)) {
+	if (!efivar_is_available() ||
+	    !efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO))
+		return;
+
+	status = efivar_query_variable_info(attr, &storage_space,
+					    &remaining_space, &max_variable_size);
+	if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED) {
+		pr_warn_ratelimited("query_variable_info() failed: 0x%lx\n", status);
+		return;
+	}
+
+	spin_lock(&efivarfs_cap_lock);
+	efivarfs_cap_storage = storage_space;
+	efivarfs_cap_remaining = remaining_space;
+	spin_unlock(&efivarfs_cap_lock);
+}
+
+static int efivarfs_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	u64 id = huge_encode_dev(dentry->d_sb->s_dev);
+	u64 storage_space, remaining_space;
+
+	/*
+	 * Refresh the cached capacity (rate-limited) unless statfs_refresh is
+	 * disabled, in which case statfs() serves the cache without ever calling
+	 * the expensive QueryVariableInfo() firmware service.
+	 */
+	if (READ_ONCE(efivarfs_statfs_refresh)) {
 		static DEFINE_RATELIMIT_STATE(_rs, 2 * HZ, 5);
-		static u64 storage, remaining;
-		static DEFINE_SPINLOCK(lock);
 
-		if (!__ratelimit(&_rs)) {
+		if (__ratelimit(&_rs))
+			efivarfs_query_capacity();
+		else
 			ratelimit_set_flags(&_rs, RATELIMIT_MSG_ON_RELEASE);
-
-			spin_lock(&lock);
-			storage_space = storage;
-			remaining_space = remaining;
-			spin_unlock(&lock);
-		} else {
-			status = efivar_query_variable_info(attr, &storage_space,
-							    &remaining_space,
-							    &max_variable_size);
-			if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED)
-				pr_warn("query_variable_info() failed: 0x%lx\n",
-					status);
-
-			spin_lock(&lock);
-			storage = storage_space;
-			remaining = remaining_space;
-			spin_unlock(&lock);
-		}
 	}
 
+	spin_lock(&efivarfs_cap_lock);
+	storage_space = efivarfs_cap_storage;
+	remaining_space = efivarfs_cap_remaining;
+	spin_unlock(&efivarfs_cap_lock);
+
 	/*
 	 * This is not a normal filesystem, so no point in pretending it has a block
 	 * size; we declare f_bsize to 1, so that we can then report the exact value
@@ -392,6 +420,9 @@ static int efivarfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (err)
 		return err;
 
+	/* Prime the capacity cache once at mount so df has valid numbers. */
+	efivarfs_query_capacity();
+
 	return efivar_init(efivarfs_callback, sb, true);
 }
 
@@ -552,13 +583,58 @@ static struct file_system_type efivarfs_type = {
 	.fs_flags = FS_POWER_FREEZE,
 };
 
+static int efivarfs_force_refresh;
+
+static int efivarfs_force_refresh_handler(const struct ctl_table *table, int write,
+					  void *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret = proc_dointvec(table, write, buffer, lenp, ppos);
+
+	/* The written value is irrelevant; any write triggers a re-query. */
+	if (!ret && write)
+		efivarfs_query_capacity();
+	return ret;
+}
+
+static const struct ctl_table efivarfs_sysctls[] = {
+	{
+		.procname	= "statfs_refresh",
+		.data		= &efivarfs_statfs_refresh,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "force_refresh",
+		.data		= &efivarfs_force_refresh,
+		.maxlen		= sizeof(int),
+		.mode		= 0200,
+		.proc_handler	= efivarfs_force_refresh_handler,
+	},
+};
+
+static struct ctl_table_header *efivarfs_sysctl_header;
+
 static __init int efivarfs_init(void)
 {
-	return register_filesystem(&efivarfs_type);
+	int err = register_filesystem(&efivarfs_type);
+
+	if (err)
+		return err;
+
+	efivarfs_sysctl_header = register_sysctl("fs/efivarfs", efivarfs_sysctls);
+	if (!efivarfs_sysctl_header)
+		pr_warn("efivarfs: unable to register sysctls\n");
+
+	return 0;
 }
 
 static __exit void efivarfs_exit(void)
 {
+	if (efivarfs_sysctl_header)
+		unregister_sysctl_table(efivarfs_sysctl_header);
 	unregister_filesystem(&efivarfs_type);
 }
 
-- 
2.34.1

base-commit: 9b87fdc9af2fbfcdb5c24a64139685ef80f6573f
