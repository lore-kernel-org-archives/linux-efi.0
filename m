Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5BC3112DA;
	Wed, 30 Sep 2026 01:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.143.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790732181; cv=fail; b=gQUcpyGkXmF3h8f7GMC1TVuMgFfA62o7tUmFkMMO5VQxNn3cq3iukIcdnpOBU9DOX4UZFdRsHwFNiKpWdhIAWpgSqqpzX0KWUgCAKYAAH0Hoa4PTAq7QVGDxv5TY8BwvEHBQV5wIM8n8O0h86wU05WE2HESnxz9qkapkE4w4IOw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790732181; c=relaxed/simple;
	bh=TrltmFtYt4jiIRTR2bXONwsYpeomELusTIme4eEvCi8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D5hCkWZkMyydWmtaWaNiuROjs261v/a8o2TuLfVocH0q2Sr2UqjC7GHD3EPoTlzE7F+jqB92fvcdUe6mX9DVghhkkVLKn2MK0FaiGUtkJbb0XSz6qvd294Nf+FqS9RRSAhnZU2XXcw+7mxHLRPsHglaJ9T/3jOY23PLAoYqJirk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=juniper.net; spf=fail smtp.mailfrom=junipernetworks.onmicrosoft.com; dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b=X0OiR52j; dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b=g2/CuQoa; arc=fail smtp.client-ip=148.163.143.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=juniper.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=junipernetworks.onmicrosoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b="X0OiR52j";
	dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b="g2/CuQoa"
Received: from pps.filterd (m0148664.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TNRlcE2698599;
	Wed, 30 Sep 2026 01:35:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=jnprhpepp0429;
	 bh=gqyDof4uQvMz6LwmzVlGHnkktuuDkqtVbFgw8EOB/Do=; b=X0OiR52j7lCY
	7EH8OLaxB3FEX5LgkzgBdu/zAIE5T9AFvB//e8Hs1ARkQv3alSgX5soHLHagztcz
	sX4VUGKUSJmU0VCY/L09waqDY7jBiZzHpObOimts3MZRVsqGrWx8tJmeTjnYauWj
	3bdP5Ny8LccTPfP2DeJs9oyVeYG45220dOFScTIGEoyux2ud60dlQOECQa1YyqQq
	aEfsdtmxkf2mupwEHy+OSgS+j9Hp5YGmAFu03M7BAnp5pOJAwp8IY8YdLgo7DZZy
	u2IrKNB0KblHRWLGQW7nZ+2Oymb0WZWgxtqdYH3LHJYgdvElXon6PXAVPCZRjJXq
	ShSJHWNLqw==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012013.outbound.protection.outlook.com [40.93.195.13])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4h0je3vpeb-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 01:35:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iXeXZ0c5Oy9nw/Xd71QuTtonW5NwD5GYVhxq6aZa0ZusvI/ZrhElQ9eh5/e/oIiUXK0oizyOxJiZzzyIHOFWdzy9OYHZ3KrRynXDnBeOzSdlW3shuiFf4XnV5+tKUgr2nTnYH1HS/jJPv77I9T6IcyYqARx+qAuQUCKqx31a9sBtKK2CFA24et1llhofXElKUPC0b6zYaWuIBRyUTOSUyXjc5NBlt7gHq0xp2KKEhiq9sEjidbJ80RS15VwosO2Srz8u42jcyJhyb38g62/LJIqDjCwIReW4N+C6mycyxMC/fTrsrsY+YUneZuZOCr1WQIBPJZKRaZaSwf0iQF7NUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=gqyDof4uQvMz6LwmzVlGHnkktuuDkqtVbFgw8EOB/Do=;
 b=Iso4az3vKBlNp5B6+7NwyNU5rvFxvAuO9lFGXcMQwAiLtVLAd17PIixfYsntRoR/faJAYvwH8w9yvcWokwoAIFdSUK5bssGXLVUw0hRjMckeJuFRy4Xs+sn2FNt67Fi7ny0aPmO+DJ7gE7vtrTId5SdCSIDANO8wghXYELIbQfIElVb8RHbSKraK8qYUaclla42veNogivQCXcgE744s+BXaLuqdFKcQdO5Ydd9g6oIdWzEfqu30m1h8E6hrE+j1TmgRY8DXtC2+PA4G9bKDp2b6ZIPEmh85c/o66GxyU14F2lX5vaGzx6+zFdXumUPmfkeMB5Ze4zAXUuxsXCxlJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 66.129.239.19) smtp.rcpttodomain=debian.org
 smtp.mailfrom=ebf951f79306.juniper.net; dmarc=fail (p=reject sp=reject
 pct=100) action=oreject header.from=juniper.net; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gqyDof4uQvMz6LwmzVlGHnkktuuDkqtVbFgw8EOB/Do=;
 b=g2/CuQoam3AUErfdRgqTWrwmcOLta6IZNPROXa6SPM7XHZ7FRcSQ7bFf1FsWQTDPrkrf8tYgh6G7a6c5pTP+fjacMjMN9whNpswGmzmOLt5tBiHEtMIsLNDimYj7gHwsPRLyoSHF8g7DWwiQYyauGj62Snojo3lxhmF93IKJ2kYueTwP34qCWnZOPLcRRR2pMvRyMDZ2UC/waC6p0GlitJBQU2L3ZVcLb+Tr97lBTCAU5iUy/ud9rCuKAE+72tNe2kGzBwYfJtUVwSz2OCeUO5c2rjtixBHSeHqI2cz6fss4TtPIbx4Mu3J8Wq6FoXiLcPAVH3vB8Mk9RLkCabuNNA==
Received: from BN9PR03CA0219.namprd03.prod.outlook.com (2603:10b6:408:f8::14)
 by MN6PR05MB10210.namprd05.prod.outlook.com (2603:10b6:208:46d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.25; Wed, 30 Sep
 2026 01:35:05 +0000
Received: from BN3PEPF0000B077.namprd04.prod.outlook.com
 (2603:10b6:408:f8:cafe::25) by BN9PR03CA0219.outlook.office365.com
 (2603:10b6:408:f8::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.23 via Frontend Transport; Wed,
 30 Sep 2026 01:35:05 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=none (sender IP
 is 66.129.239.19) smtp.mailfrom=ebf951f79306.juniper.net; dkim=none (message
 not signed) header.d=none;dmarc=fail action=oreject header.from=juniper.net;
Received-SPF: None (protection.outlook.com: ebf951f79306.juniper.net does not
 designate permitted sender hosts)
Received: from juniper.net (66.129.239.19) by
 BN3PEPF0000B077.mail.protection.outlook.com (10.167.243.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 01:35:03 +0000
Received: from p-exchbe-eqx-04.jnpr.net (10.104.9.87) by
 p-exchfe-eqx-04.jnpr.net (10.104.9.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 29 Sep 2026 18:35:02 -0700
Received: from ebf951f79306.juniper.net (10.104.20.6) by
 p-exchbe-eqx-04.jnpr.net (10.104.9.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 29 Sep 2026 18:35:02 -0700
Received: by ebf951f79306.juniper.net (Postfix, from userid 14867)
	id ADCF11444B7D; Tue, 29 Sep 2026 18:35:02 -0700 (PDT)
From: Prashant Singh <singhpra@juniper.net>
To: <bigeasy@linutronix.de>
CC: <ardb@kernel.org>, <jk@ozlabs.org>, <clrkwllms@kernel.org>,
        <rostedt@goodmis.org>, <corbet@lwn.net>, <skhan@linuxfoundation.org>,
        <rdunlap@infradead.org>, <lgoncalv@redhat.com>, <93sam@debian.org>,
        <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>,
        Prashant Singh
	<singhpra@juniper.net>
Subject: Re: [PATCH v4] efivarfs: add nostatfs mount option to skip QueryVariableInfo()
Date: Tue, 29 Sep 2026 18:35:00 -0700
Message-ID: <20260930013500.10273-1-singhpra@juniper.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260929151401.doOQX7D0@linutronix.de>
References: <20260928203445.72318-1-singhpra@juniper.net> <20260929074312.v3jT8uel@linutronix.de> <59d5452c-42b1-4784-a593-5e549a2a0f12@app.fastmail.com> <20260929151401.doOQX7D0@linutronix.de>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B077:EE_|MN6PR05MB10210:EE_
X-MS-Office365-Filtering-Correlation-Id: 557ac903-0f1a-4a02-d99f-08df1e930d16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35950700016|376014|82310400026|7416014|1800799024|10067099003|56012099006|11063799006|4143699003|22082099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	Ru/wb0zRgdfHm1GLL5NaibXyVmulcuu1bLQuxy0Tu/8je4wnrt3Q0vbeLhxEmX25KM0B+t7GNG5bftd5VFeNeX/syfgGC0m926898lqjz9/z6V4VHQ7tsRPrpb2QqOff9B7epmW/frwbdcuBTR3LE17ChrcdjgoC18OtjObJGZq2sIgHMXulBnoWwTZvnrMXWpIc4ETavXn4HZq6JqOozWwc9C3ezOzANpCH+c3zUi3Oxyi3VVAiFWLbX8ET8fDDwvBt0cwDumltnRlxIZc/5qRedxh72BHBH73fICpRSVFOEE8sOALQd7zsZs1mX2bOOiOdn53wSjVtg8Srmp20pqs2kkAgVosJxLPpSdq7vQ7GIszyBILwkkWmjgvCiDJ65FUyPI44f5uAIViEaSjLrbIi9I/0dzxkx6+jE091HOz1LhiXWmB95JgU5wnlQ059ZX+cIdatdCBsMcAf5xKcWgftPRU/GHommftcSARDjgjkwEGiZSYc1BzzepRqFo0VsFnoQUqgCdjJpXUtCd3PSx/eB56lu2r4sHNaeW4SWQBU/ecsOXP1kYIVm3hIHyfkSq8nPVdsqYuHVV4jnT7VnZXOyoDuxso3MhAZTJUYgSy1mtrLQavoxHJtGpAlDfrOcjbDkEuzrAK1AYkYaC/gmqACUgl0FBiJii4PzLbNjkfFEN/bPO6vD718G3NuFEjdIiCWBdRnU0l/5Gtk6r+OFQ==
X-Forefront-Antispam-Report:
	CIP:66.129.239.19;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:juniper.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35950700016)(376014)(82310400026)(7416014)(1800799024)(10067099003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qWjRTpZkvAUDpWpzJC+HdupPJyAD4JGX4YNj62nxUHFdPt7KiNtUDoxdl+kpGKFYXqDh3S/K8K4XQkyhPs298o9Sx5CabquccLnaLpzrf+Ma7atAXQ8CgC8UZpRp0PtAtyuvU+iQkFMaS1N+danHZmii7DagzD0Xn6j0feJZBN/6W3ShMztEI0TLSHIBfm/UDMBqyNA0ipvL9MLmy+k0AqfgkN0uozjqBDPcqif52fyYLJ9k6kLBFd81Jdb8/NErpQCQMFmF2UH86jPFk8Di6uZoFlhz6ISWlgQqpwUkodQQcysGHHxL1p3Y8F6ELq1e0fWSX31HcMWZSx46x00RVyYiLVjmoGVMR9sjZK18nyVoKoKx+j/c3wcRe/H8AALz8yfx8r/m0SnQqUo8YEVTEjxm38ff5OtKpFFEPe8yME7lNpVvmMT9RtCH2Y4g9b8n
X-Exchange-RoutingPolicyChecked:
	vHylOJ1pNqv7lpoaK6FU6d2XFyi90tJ1Vr8/sBEj/ZWWgfoqVA9vjHj9atNw6H00UBEW2f8jItQ3BfZ2lz8FrobZMtA+O03d8AvQ//cRTICQgfo2fPobjJfKUeNLmiMo4wAn6ZRwHV7MvJ1W4Ezj5Gmxk+noUPW41iuLQ5xWmUynhxSpwngl7qmfGSvS7Thj2qREPANrHAZM+5VZ2Pn72lLwh6EA9uvUhIYE59JXK8rE6MuSoUoLPQPjDTxij6A1lb5bdbCeZhEbVzS6y/HuxnNNmYHmGz6pmOEnE70YqgFEBtVgtbymLaSNLCFfseKfc0MVZlAIAxOnxnlalmtlkw==
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 01:35:03.7217
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 557ac903-0f1a-4a02-d99f-08df1e930d16
X-MS-Exchange-CrossTenant-Id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bea78b3c-4cdb-4130-854a-1d193232e5f4;Ip=[66.129.239.19];Helo=[juniper.net]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B077.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR05MB10210
X-Authority-Analysis: v=2.4 cv=H9tOUOYi c=1 sm=1 tr=0 ts=6abc674b cx=c_pps
 a=mi0BVYrBcfLCPOxFm7cYqw==:117 a=SKdRtqzh2DBFgDMvUaaGnA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=f7IdgyKtn90A:10 a=rhJc5-LppCAA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gQcMVamqm3wCPoSYhaRC:22 a=NCWKwCw8Xy9Og0ibBRsL:22 a=VwQbUJbxAAAA:8
 a=OUXY8nFuAAAA:8 a=V-E1HRFuWMMkLzhyDk4A:9 a=cAcMbU7R10T-QSRYIcO_:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDAwNSBTYWx0ZWRfX+Z3CTGhO9yEM
 eDnMnqXoug3q+g4BsRijVSnSyYsbaLVe3xGiUANIG2PJjeelhBSMhjR/dgf86d6VD/ZLa1d10o2
 5hasrqCDs1s92MknfA9ULYxz6S/uC7bFffC03+kGxpHJh4sjQ3RyxPHu+qgiW459DbuWZWwilj0
 is6QYR1l3wHRigLLIJiOFp0poG8jyNv9muKE2rcWluZb1VOF/CHAwJMAhBoKMwB9L6WbKPoJXHP
 O4iWd3McnpiF/3D6X42BjQqwzP2CYEGHMnDAxUJh8+DO6I3QrCbnzBeO/9QMgBZ0FTgOB2ibMAo
 thHpL9I2DHYrQx8fY2ZMcPvolrdlHkGCptEnp6UnCF/mjYAjmzbwWXRJty3hkyu+8GTpbWh1D+6
 zjn0aPDgURZk77SNS59zDs7/Bnj3VQPAM03m25LWckcUUJ+XBd6DcNlqXZJx0BWBkiZ7044tW7/
 rqtXCf004H+/DBPvKbw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDAwNSBTYWx0ZWRfX/miDV9qYI2Aj
 BM4d9Xd0Xet73jUm5F8tRCqdXnfbUYvzxIxYHy4H22iMpQMHgQfgmTPLA0uDCjA6ps+HazTwleR
 bcA/50tDQwRs6aIrtwEodNYSBcZSY4E=
X-Proofpoint-GUID: fyFz1czmHUa6E1wy98L6SbC_rKpDNlvz
X-Proofpoint-ORIG-GUID: fyFz1czmHUa6E1wy98L6SbC_rKpDNlvz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_05,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: orgsafe
X-Proofpoint-Spam-Details: rule=outbound_safe policy=outbound score=0
 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0 bulkscore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=orgsafe scancount=1 engine=8.22.0-2609040000
 definitions=main-2609300005

Thanks Ard and Sebastian for the comments.

>Please don't respond to questions by respinning the patch without
>having any discussion at all.

Noted, and apologies for sending v4 without first finalizing the v3
discussion.

>I asked you an honest question, and it seems Sashiko spotted an
>issue here too.
>Is there a problem with how the current code deals with uid and gid
>on a remount?

No, I checked and did not find a problem. I mentioned this in my
response to your query on v3:
https://lore.kernel.org/all/20260925113145.7396-1-singhpra@juniper.net/

>This until the end looks extremely verbose.

I can drop the strace data from the commit message if that reads
cleaner; I had included it to highlight the issue.

>could this be, I don't know something smaller not including the
>commandline where I would expect that people know how to use it.
>
>===================     =========================================================
>(no)statfs              Control whether ``statfs(2)`` reports the variable-store
>                        used/ available. Disabling it skips the EFI runtime
>                        service call, which might block the CPU for a few milliseconds,
>                        reporting 0 for used and capacity. Enabled by default on
>                        PREEMPT_RT.
>===================     =========================================================
>
>It might make sense to add this knob to Documentation/core-api/real-time/hardware.rst.

Thanks, I will use this wording and move it to
Documentation/core-api/real-time/hardware.rst.

>Here and below you add a comment to every change you make. What about
>focusing on the important parts, that deserve an explanation why a
>change has been made. For instance why nostatfs has the READ_ONCE/
>WRITE_ONCE accessors and sometimes it does not.

Apologies, that was a miss on my part, and I saw that sashiko-bot
flagged it too. I wanted to gather any additional comments before
addressing it.

>Yeah the most severe issue is that entering SMM requires a rendez-vous
>of all the cores, and so whether preemption is enabled or not is
>actually kind of irrelevant, given that all the other cores just
>disappear.

Yes, I observed the same behavior. I was not sure whether this is
x86-specific, so I refrained from mentioning it in the commit log.

>Right. So if anything, there could be a data_race() in one place
>instead inconsistent READ/ WRITE once as we have it now.

I would use data_race() on the write for nostatfs. Please let me know
if the below looks OK:

    /* nostatfs is read locklessly by statfs()/show_options(); the racy update is benign. */
    data_race(sfi->mount_opts.nostatfs = new_sfi->mount_opts.nostatfs);

Thanks,
Prashant
