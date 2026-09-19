Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FE0547043;
	Sat, 19 Sep 2026 04:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.147.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789792939; cv=fail; b=qrAWBfVY/0sOtdeCdmiLheooXOOFQE78LBO6bpytBJbiYQ5ZOPOBHqD4BrCAVA7agkkXaF/7FCZSfbW4hX2B7xpcMHhKfuJJBpxZqzaF/NX5zHixX5uLgcyVMdhxz6XGYQy8miWT8lFFL2tewQ80q/WgbtVxv9YHXvaBaJ5CpOY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789792939; c=relaxed/simple;
	bh=JmaHAeiaQYMDDEeqn6C+An8Mxk8gc7KnuOLRfF4ShYw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mk7l+wA853/bHUHCnbepciI6oPDn6Vm42vwsTNMcwjH4r30eayHJveqiTVflYi2G1PHhNBbiuJ0qAPs+p+0WzN8b+Yh4LkMCGOoTi+yLifUNN2A4dXWzdMl58hG1iXTpeGpEatVOYLYqd8L62cYGG2BHQZbnwAsA3E/rCxsExzs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=juniper.net; spf=fail smtp.mailfrom=junipernetworks.onmicrosoft.com; dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b=m2O2cV2L; dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b=Rz3veKAm; arc=fail smtp.client-ip=148.163.147.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=juniper.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=junipernetworks.onmicrosoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b="m2O2cV2L";
	dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b="Rz3veKAm"
Received: from pps.filterd (m0150242.ppops.net [127.0.0.1])
	by mx0a-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68J43x3Q2771432;
	Sat, 19 Sep 2026 04:41:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=jnprhpepp0429; bh=ESI5RugOao+AnPUjhP
	QdTlvat6VY8+VphsfZX0ieG6Y=; b=m2O2cV2LbGQP9FAY7nK96KfVvnukkytylY
	WDaB5lZ6nGM3JVylEHLcdL7ooTjSAW931H+qxTVKFOvc2z5F/cEAwbi2ocV3wWYn
	oF+Lp6cOwsMKha6U67n81OoLJbDPPFp6U5SKLuZFeumDu+vR2ilZ0ouCX5OQYqRg
	SBzwxck3nFk1hONEZLNzZX1Of68EOXlGN5b4+mCQA7SSUeHnNDpaD3aueVdjex04
	mNKmmZ6LSoTCUPI8rRFSxT23yJCxnabkvJDXfsg9dfELmif5J9/KaQk22021rSn3
	HRn1it9YaUU6ZddDapofGJX2i1bPYuEfSclmJ4QVaZK6jb/vWSJQ==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010059.outbound.protection.outlook.com [52.101.85.59])
	by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 4gsk1u87ej-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 04:41:37 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zVA6HWuEciGBoUkIa8Slu7m2ATWtyKq64c5poPfCil6t1uMTcW521mnuvBBt07xK3eGQX7a3jTIuzloihaCEH+EBRxzbxu7aM9IfyA+EUX1EFaH73Rii8DXFwZgg4pQV71Tk7K9vMJbDoxxTIidLKF1P3SbP9OokgEHUt/CVSl2CPitVeGo1SXSXeGmGhmwkl1nHLCWAGp9+IqxZHC7r8vYqUxvZoP29YvP+ZKwCSCbJIZ268W3LeRe56n4GLOyMDuNkr5lQWXMUuIWAbeV5sx1UDKNf0MpGWj8Y5vKD9CHQ567OVf/TdFw8VbyeqaRQdlwwals9nrpYKKlklAehtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=ESI5RugOao+AnPUjhPQdTlvat6VY8+VphsfZX0ieG6Y=;
 b=IzQ6xrp9mtGXLrjwD8JeXj/1CrlzKXNUO4fcB6rKii0pWdsoA+yDwdYeRguV3Qrr39wpyl1tOqpjTDR+VMwLHHJn2OP3xZZUWhfAtlNd7YTT3k55QEotdvRRCvfqpd0C93ybrYUqW3loR2dv8ZC7cxUQH7a/nVWevxbPlAmJJtGyN+gklZ79hQKDmRfiVVBBq67sNqt2/ULzEtxtwaWrh9Fpu5/2FxJI/3r1bmwsWf1fTMZGIse4q90Aeu82w4QuXgRDUqFPerFIX3v9uYhnvBt5/uziWU6k6KNxa0TradzFEdPa/PeRFyTJeKB2njQNuGrLAHNm7+X4FzlzvzWD0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 66.129.239.19) smtp.rcpttodomain=goodmis.org
 smtp.mailfrom=ebf951f79306.juniper.net; dmarc=fail (p=reject sp=reject
 pct=100) action=oreject header.from=juniper.net; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESI5RugOao+AnPUjhPQdTlvat6VY8+VphsfZX0ieG6Y=;
 b=Rz3veKAmHplQbTygtc5lQXUtLZcMZBzK6JF9do1iE8MydH55Ds/SPmDg8pc9J/Et01DgAGWFuikNF8gixTb2tsPlme1CX456X+PiYBJ3PxjHM2mihElO7/h1ABX+6pZroM25KiSFg8LXGCz7RIBw1UxHpuBbGuzP8xSKeFBZHBdAR1LammrWR3b1AvCylfiQjEvhvCQuE9t1jHNujHiJ3kUIWmj4d+GKX8LHSlBVJJCqbC1L0yv6PNiZtpbejLNEX4v0EduPRwPsUHgrzS0NwPLi0CkF8mvZg+lGOExeLDFXLiN3m0YPPRQ0S++0NCtfdHiKK1OaLD0+KK0DIr/jLg==
Received: from SA9PR13CA0177.namprd13.prod.outlook.com (2603:10b6:806:28::32)
 by SN7PR05MB7533.namprd05.prod.outlook.com (2603:10b6:806:102::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Sat, 19 Sep
 2026 04:41:33 +0000
Received: from SN1PEPF00036F41.namprd05.prod.outlook.com
 (2603:10b6:806:28:cafe::a8) by SA9PR13CA0177.outlook.office365.com
 (2603:10b6:806:28::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.8 via Frontend Transport; Sat, 19
 Sep 2026 04:41:33 +0000
X-MS-Exchange-Authentication-Results: spf=none (sender IP is 66.129.239.19)
 smtp.mailfrom=ebf951f79306.juniper.net; dkim=none (message not signed)
 header.d=none;dmarc=fail action=oreject header.from=juniper.net;
Received-SPF: None (protection.outlook.com: ebf951f79306.juniper.net does not
 designate permitted sender hosts)
Received: from juniper.net (66.129.239.19) by
 SN1PEPF00036F41.mail.protection.outlook.com (10.167.248.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Sat, 19 Sep 2026 04:41:32 +0000
Received: from p-exchfe-eqx-03.jnpr.net (10.104.9.50) by
 p-exchfe-eqx-04.jnpr.net (10.104.9.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 18 Sep 2026 21:41:32 -0700
Received: from p-exchbe-eqx-03.jnpr.net (10.104.9.86) by
 p-exchfe-eqx-03.jnpr.net (10.104.9.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 18 Sep 2026 21:41:32 -0700
Received: from ebf951f79306.juniper.net (10.104.20.6) by
 p-exchbe-eqx-03.jnpr.net (10.104.9.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 18 Sep 2026 21:41:32 -0700
Received: by ebf951f79306.juniper.net (Postfix, from userid 14867)
	id D10031111BBA; Fri, 18 Sep 2026 21:41:31 -0700 (PDT)
From: Prashant Singh <singhpra@juniper.net>
To: Ard Biesheuvel <ardb@kernel.org>, Jeremy Kerr <jk@ozlabs.org>
CC: <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Jonathan
 Corbet" <corbet@lwn.net>, <linux-doc@vger.kernel.org>,
        "Sebastian Andrzej
 Siewior" <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, <linux-rt-devel@lists.linux.dev>,
        Prashant Singh <singhpra@juniper.net>
Subject: [PATCH v2] efivarfs: add nostatfs mount option to skip QueryVariableInfo()
Date: Fri, 18 Sep 2026 21:41:24 -0700
Message-ID: <20260919044124.8268-1-singhpra@juniper.net>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F41:EE_|SN7PR05MB7533:EE_
X-MS-Office365-Filtering-Correlation-Id: df1c40ca-96c3-427a-8d7b-08df160847c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35950700016|1800799024|7416014|376014|13003099007|11063799006|10067099003|56012099006|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	KfYEx9oHVvVWB14+B4gkeDwJTZn3orOTILeHccu6zZQvJ57TCX18A30In2MSuyhbdIMSboH0m5LoDzjciL3xN2igZaWApeSCPgXg7fiLyjdwKQKcynDCASo4Mo3zdv+GwZE1tL1bBlu6ST/dikL2CN47N+ZOWI7L4e5eP8LiEkItIzHhJxy+vbLxR02inu0W6vKqQdU41arMZ8/YHpc/Yv/tdYwz7bIydZX8Lkh1933NAYo+rLc28kqRxTYHnUC/JloVSERFM6dRRWu7DVuiWyei6xon6DnzfsOQgVhHcWyYPWzJWu8DZirCpFyBeqv8axRuIvhbXXTbv0zj/6i9j1qjNtf/DA7B2CWMAnhaMY8VWfkBcI9eOtpJGT6z3CTxU1KmGyYkyZTSH4LNQiX4xZ4rITMjP3MKCbCTVCcrAaHKk5cyTtuL70AAvoNYPfAF7itg3qridH7/xcMQFzzKo7FkEqZACj/i+Paqlw+Skifna73J8Zn8c/bw19vJc/mVNRMlEkf18sS9quHZ+8YKxPMHhh/bEIod18k2CuA4oWK8jTtCba6FgDmRFEyyYr2rRg5YRDRK3XsXxdcEaj+goUDh0L5Ca1/mRuSiy06iDO4LTxULqoofYBfmzfxKI/RwwwavC/CFTaA0LDcauDneOBBzU9VHSoE4hxIzbc/HYmmj+U/wcR4I3Y1BAkMuhXK4+zmh34ltHwyVXP23xF4/fQ==
X-Forefront-Antispam-Report:
	CIP:66.129.239.19;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:juniper.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35950700016)(1800799024)(7416014)(376014)(13003099007)(11063799006)(10067099003)(56012099006)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Z0O893yfIIXdohqJgyEWU3nKnrvTX38MuTUlPkryx7fgwD9EJ9cDAKUybmeZDu4UBUD+SU+O+rGMfZCSCsNmEpJ5uy1K0huzc8Wi60j/CmTsR0PVruJYOtU2uqAj9stFUa3HPieYJf/asLMPqoXCCrKQDoRDVhA6zB1WzQeEJg8KoRQn2rgM7/TUTrWm6R8QGGcPxAMzc+hbsp9yVl9vzTkIYmYbwY40MrxogEWnbb1CT4qt/RJVp50Bc3+sVYBoHdA1n8W7M0kY/quWYi0sbcLtqddyc8/9W2leGUKCDXLE9NS0B83zEhGwf8oEJ2MFqXJLGq+1Zpx6bFGpx6xgmSc7zTrDCNvGeGx7GrpeSC/GhvtIRfe8ro+Te0XlJB8BV5Nd7q6NMV/f4z710k3B9/2+g5GrYNSdb5AFF/o2RWu0cFyqh2RkHj1hj49VvlY3
X-Exchange-RoutingPolicyChecked:
	WHDVbimauLjBL8TIZFeE57ZZExQqhChLe40iSu8Gd+yINypmukbE/v9NjheEpC/MKwfhnaG+5DmNLsrPdBx7TDOGIZRIxSx5XYJASAV0LqN3HEzGqzWm5JO5CSJw/VLPLnjfgjtKaEabEsm3qa2GkGqxEIdtL9XfNi8ERKbOkPSPcrn8KnSSQQ5xpiVN0rRkwc1oC+rMAf41EWlvTdZvi/1De8oqbuTpU/rd8S44OBiMIhQuvOdBjixW5iPIfbKCZdDEh3hl2+cAQsBotnJUaZ6ZEggrBNrv0A0GbeVAGtvNVcDf/0FtFNmqKpyhE4meAWDVkMtlDmkA4Q3iCSkgCw==
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2026 04:41:32.9001
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df1c40ca-96c3-427a-8d7b-08df160847c8
X-MS-Exchange-CrossTenant-Id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bea78b3c-4cdb-4130-854a-1d193232e5f4;Ip=[66.129.239.19];Helo=[juniper.net]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F41.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR05MB7533
X-Proofpoint-ORIG-GUID: rKS8whXSH4RWQnKuXJa0GAsVayNPAlDd
X-Authority-Analysis: v=2.4 cv=cpIOAF4i c=1 sm=1 tr=0 ts=6aae1281 cx=c_pps
 a=333l4QiDdYhx7c8CB7C9lg==:117 a=SKdRtqzh2DBFgDMvUaaGnA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=f7IdgyKtn90A:10 a=rhJc5-LppCAA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gQcMVamqm3wCPoSYhaRC:22 a=J0OTuHAx6l5K1fCpvPfz:22 a=VwQbUJbxAAAA:8
 a=OUXY8nFuAAAA:8 a=EvKlYhCeC0pf8kTkCpQA:9 a=cAcMbU7R10T-QSRYIcO_:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDA2MyBTYWx0ZWRfXyc0/lwVPZ+dc
 HJiEPNRTdEfabjyRERtxjEfSYZn8lZIcLzzM0DBCBAK36LBCV/QA5Kv6bbASw3X5sCLGTNlZ7Hp
 hIye7bkEYuFhzdELl27aLDB5ZCPl+Gc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDA2MyBTYWx0ZWRfX2JbjNeU7Fkux
 p9xhiV+D2lNDQkL8YWYcUj2dp1dRSyexQrcw5YQjaRWqQbKubDHyABSKFJbW9BQlLr9zjJEFE6G
 0TlWO1oQBxeDesFzu94yxdsIUjiNNa/QL2/Kvpd9w60EzsLbqHeyMcev7OtACNXC0SeWLmjbHcP
 c+in6VXIF2ZqkmmstSMnDR4U7Ugwgc2VR/wAbJg1mnCq5g4agTQtHoL4MWmTDux83wVhfEhiuZh
 2dcqZto6KKWG6x5vcXE1lZuZtT8ORNE03SY4z2ZoCXMp23VFH8Ir1J2p5IAJorE30+t01tOcjFq
 JpSliVtOUTKXUMMqVsLETCQFCJxGCT2V2jbsTuIVnfsyRsSzepj5mfxRY5l35algfjW1/JoW+4D
 KMedFK1Is0jixVwGgJZdUePniXUrbdCqFWdG6ztSqnqXJxE7ZBmEKafo/1MrJP9ye9nnyZLu/pd
 av3t8kO2UAYxYgCUFRA==
X-Proofpoint-GUID: rKS8whXSH4RWQnKuXJa0GAsVayNPAlDd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-19_01,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: orgsafe
X-Proofpoint-Spam-Details: rule=outbound_safe policy=outbound score=0
 impostorscore=0 adultscore=0 priorityscore=1501 suspectscore=0 phishscore=0
 spamscore=0 clxscore=1011 bulkscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=orgsafe scancount=1 engine=8.22.0-2609040000
 definitions=main-2609190063

QueryVariableInfo() is an EFI runtime service that, on some firmware,
takes tens of milliseconds and runs with preemption disabled, stalling
the CPU that services it. efivarfs_statfs() calls it (rate-limited since
commit b2326338dc68 ("efivarfs: Rate limit statfs() handler")) to report
the variable-store used/available capacity, so any statfs(2) -- e.g.
every "df" -- can inject that stall into unrelated latency-sensitive
workloads on the same CPU.

Add a "nostatfs" mount option: when set, statfs(2) skips
QueryVariableInfo() entirely and reports zero used/available. It is set
by default on CONFIG_PREEMPT_RT so real-time kernels do not take the
stall out of the box.

Tested on an Intel Xeon E5-2628L v4, 6.12 kernel with CONFIG_PREEMPT_RT
not set (so reporting defaults to enabled and nostatfs must be passed
explicitly), via "strace -T -e trace=statfs df" on the efivarfs mount.

Default mount: statfs() calls QueryVariableInfo() and returns the real
store capacity, ~66-129 ms per call:

  statfs("/sys/firmware/efi/efivars", {f_type=EFIVARFS_MAGIC,
      f_bsize=1, f_blocks=90024, f_bfree=33387, f_bavail=28267, ...})
      = 0 <0.129124>

With -o nostatfs: no firmware call, capacity reported as zero, ~11 us per
call:

  statfs("/sys/firmware/efi/efivars", {f_type=EFIVARFS_MAGIC,
      f_bsize=1, f_blocks=0, f_bfree=0, f_bavail=0, ...}) = 0 <0.000011>

Signed-off-by: Prashant Singh <singhpra@juniper.net>
---
Changes since v1:
  - Per review, dropped the fs.efivarfs sysctl / cached-capacity approach
    entirely; instead add a simple "nostatfs" mount option that skips
    QueryVariableInfo() in statfs() and reports zero, set by default on
    CONFIG_PREEMPT_RT.

v1: https://lore.kernel.org/all/20260917071600.5587-1-singhpra@juniper.net/

 Documentation/filesystems/efivarfs.rst | 10 ++++++++++
 fs/efivarfs/internal.h                 |  1 +
 fs/efivarfs/super.c                    | 20 +++++++++++++++++---
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/efivarfs.rst b/Documentation/filesystems/efivarfs.rst
index f646c3f0980f..3ead638c796a 100644
--- a/Documentation/filesystems/efivarfs.rst
+++ b/Documentation/filesystems/efivarfs.rst
@@ -37,6 +37,16 @@ accidentally.
           |4_bytes_of_attributes + efivar_data|
           +-----------------------------------+
 
+Mount options
+=============
+
+nostatfs
+      Do not report the variable-store used/available capacity in
+      ``statfs(2)``; report zero instead. Obtaining the capacity requires the
+      ``QueryVariableInfo()`` EFI runtime service, which on some firmware takes
+      tens of milliseconds and runs with preemption disabled, stalling the
+      calling CPU. This option is set by default on ``CONFIG_PREEMPT_RT``.
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
index 8d33f11db2a1..fbdaa4915d30 100644
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
 
@@ -82,13 +84,19 @@ static int efivarfs_statfs(struct dentry *dentry, struct kstatfs *buf)
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
+	if (!sfi->mount_opts.nostatfs &&
+	    efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO)) {
 		static DEFINE_RATELIMIT_STATE(_rs, 2 * HZ, 5);
 		static u64 storage, remaining;
 		static DEFINE_SPINLOCK(lock);
@@ -323,12 +331,13 @@ static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
 }
 
 enum {
-	Opt_uid, Opt_gid,
+	Opt_uid, Opt_gid, Opt_nostatfs,
 };
 
 static const struct fs_parameter_spec efivarfs_parameters[] = {
 	fsparam_uid("uid", Opt_uid),
 	fsparam_gid("gid", Opt_gid),
+	fsparam_flag("nostatfs", Opt_nostatfs),
 	{},
 };
 
@@ -350,6 +359,9 @@ static int efivarfs_parse_param(struct fs_context *fc, struct fs_parameter *para
 	case Opt_gid:
 		opts->gid = result.gid;
 		break;
+	case Opt_nostatfs:
+		opts->nostatfs = true;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -526,6 +538,8 @@ static int efivarfs_init_fs_context(struct fs_context *fc)
 
 	sfi->mount_opts.uid = GLOBAL_ROOT_UID;
 	sfi->mount_opts.gid = GLOBAL_ROOT_GID;
+	/* QueryVariableInfo() stalls the CPU; default nostatfs on PREEMPT_RT. */
+	sfi->mount_opts.nostatfs = IS_ENABLED(CONFIG_PREEMPT_RT);
 
 	fc->s_fs_info = sfi;
 	fc->ops = &efivarfs_context_ops;

base-commit: 9b87fdc9af2fbfcdb5c24a64139685ef80f6573f
-- 
2.34.1

