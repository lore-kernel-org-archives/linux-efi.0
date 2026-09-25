Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D9747884D;
	Fri, 25 Sep 2026 11:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.143.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790336004; cv=fail; b=eK0De16h2buJqCU+gGVt9O2D2Z94747taP+lLITptjMOjuRXR13roFoUGRiBSvcs7F49aaBo1Ji1TNMEFnBQl5eSlZBR9FK0qXtJWIRhUivWhSpHkHAiM0TafLPewG+/Fmo9wZuV854RUIYJFagIB3JcTkZa74PaVjVVhseQBCo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790336004; c=relaxed/simple;
	bh=nBXoKLnt17eIe43Vz+zo4Or+kB+3bhJNhwWLI7fvvqM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GdAGBmwMu9Vq/jaS8dzhSd/FmrjPfZNowwQgDgN8ZTNTRteSdljWuz8oeJYJLvDPU0FrTaOxBM78JK57oxYTfSuQS0kDJDZ6VRqcv7C/DjW60NO5KzVlVXXjvodP93OBRaghX+7vxDpEa99we4gA+M/lobkgoIP5uo9Tfp7pnrk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=juniper.net; spf=fail smtp.mailfrom=junipernetworks.onmicrosoft.com; dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b=eRuvz8Mi; dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b=WBrmq+bM; arc=fail smtp.client-ip=148.163.143.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=juniper.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=junipernetworks.onmicrosoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b="eRuvz8Mi";
	dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b="WBrmq+bM"
Received: from pps.filterd (m0150245.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68PAuuuH240696;
	Fri, 25 Sep 2026 11:31:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=jnprhpepp0429; bh=zZymq5TzhDrpCyLnF6
	X0swQzRv7CLdAek1/svWTd+7w=; b=eRuvz8Mi76lpiLskm+/Sg2HKXTTrOQYM3V
	ddzO4VVyFKxc5M6jVyKppKAGtBYmseabD8Hgoqcc87A0eTP+bXEGs9iV13xgUMpe
	dJbN9H2BUWjQIgX+K65buih4y4KpAkBd6j2SL3l8PKHV0HrMJBTiFRJWWE1En3OX
	0kad/9p+30e6LUeJaEhqowITJrCoFYxEJmCls7c6vy7uqmeEHQroy40aT2G6+LyV
	T9LrBQa+4xC43fliWGoP2m7bHf7TtauUAT4Cbqik1wlcIVLcsjsEUlvJjZWczetF
	pPfqRhWmMFA+uNoLemoVTApJ9WXgAz4pX/I+O/PeJM3rDR5jp8AQ==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011048.outbound.protection.outlook.com [52.101.52.48])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4gwp3c9p63-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 25 Sep 2026 11:31:56 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A9vqyOoKgxu1pdnS/ShfRwd5qf6s1Juh+pA/h0Uy1ZB5OcRFjA+QApOjhLRvpkejaDTGicltbAWSC2g2vmDKYruVB67a69znDjo6Hww1IeDWXXRRht4Okta6pFcaok5znes2aHw46EgzMjb8IPxlrwrEIw3ve4hfdQBZqItxOrejKSeZuNvqzyl9mipkjyMXgSRDsrG1UTwN428BiTpv+CX6AGN2XewcBqbrXj1xdvilNmEDDPFh+2a0CdAyTBX/sXdjJX9FV6lTFsCNvS9iLERlqDd6SKm340K7Fb02XFw+PQLd09aQTXahK1fVzyid9l+d5up+TTOfuzM712NJWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=zZymq5TzhDrpCyLnF6X0swQzRv7CLdAek1/svWTd+7w=;
 b=hwMFZ9yELzS4D/w6ocmz60852z65DwK2o1GkkfvthQOycVeDZNHQC1JedXGkbRtNsgrjW/67yyle94wu7UOsRFjtYWqr2juiv2C0qzZTW4UXx+HEY/tS4dQ/Qvwjf+jw25wCfhB+21ukt8wY4NmDck/DgqLUgKzdep+6/wxqMpxqfV7KGJN69YG7mPchj0LKwdXB3bH/exTcYpXigMR60p+0FU/uwAUwSz0VyQ1SF/7GUnuWtHyKyFyD1J09gwk8Mnl0J7ST1b6WpIOQ2KxKFltPvFwzNR/NAwal34jve83B4bVT5er7MWuPrERdwWwiGLe60QKUFjarmrFKP8gfKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 66.129.239.19) smtp.rcpttodomain=debian.org
 smtp.mailfrom=ebf951f79306.juniper.net; dmarc=fail (p=reject sp=reject
 pct=100) action=oreject header.from=juniper.net; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zZymq5TzhDrpCyLnF6X0swQzRv7CLdAek1/svWTd+7w=;
 b=WBrmq+bMq//y3iOMs81RaNl0csgXT60cTZFxhR1SL0V43ST2cLUTNHWwf7chISG6zTldHzHEMcbpFAblv6785TfFQp/KJhJYFwOzbAhJeyLjwdLUoPV5sO+T15HboE8DTj4ChpDnkqWR6rhYaX5iH1VPN1VgsZdYEKd4SyTUCpu2L2HzBfSwjOIIraKq2Tc483HDNDXyMOnAyykPwhs9FCu1vyVgexlAtd4hNb33oZOF+o/fCPNy7TgGqI9hNNoA3zxKaHGdUNDlbO55K3K/YIOs+8lnyRLTzVh5e996+ccLRjwBQ6XRxnluu0n4u1O5DcOms7BhjknFlYzepSaaVA==
Received: from BY3PR05CA0047.namprd05.prod.outlook.com (2603:10b6:a03:39b::22)
 by DS3PR05MB998685.namprd05.prod.outlook.com (2603:10b6:8:38f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 11:31:51 +0000
Received: from SJ1PEPF00002319.namprd03.prod.outlook.com
 (2603:10b6:a03:39b:cafe::92) by BY3PR05CA0047.outlook.office365.com
 (2603:10b6:a03:39b::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.17 via Frontend Transport; Fri,
 25 Sep 2026 11:31:51 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=none (sender IP
 is 66.129.239.19) smtp.mailfrom=ebf951f79306.juniper.net; dkim=none (message
 not signed) header.d=none;dmarc=fail action=oreject header.from=juniper.net;
Received-SPF: None (protection.outlook.com: ebf951f79306.juniper.net does not
 designate permitted sender hosts)
Received: from juniper.net (66.129.239.19) by
 SJ1PEPF00002319.mail.protection.outlook.com (10.167.242.229) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 25 Sep 2026 11:31:50 +0000
Received: from p-exchbe-eqx-04.jnpr.net (10.104.9.87) by
 p-exchfe-eqx-04.jnpr.net (10.104.9.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 25 Sep 2026 04:31:49 -0700
Received: from ebf951f79306.juniper.net (10.104.20.6) by
 p-exchbe-eqx-04.jnpr.net (10.104.9.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 25 Sep 2026 04:31:49 -0700
Received: by ebf951f79306.juniper.net (Postfix, from userid 14867)
	id D7D1813308C6; Fri, 25 Sep 2026 04:31:48 -0700 (PDT)
From: Prashant Singh <singhpra@juniper.net>
To: Ard Biesheuvel <ardb@kernel.org>, Jeremy Kerr <jk@ozlabs.org>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams
	<clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jonathan Corbet
	<corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Randy Dunlap
	<rdunlap@infradead.org>,
        "Luis Claudio R . Goncalves" <lgoncalv@redhat.com>,
        Steve McIntyre <93sam@debian.org>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-rt-devel@lists.linux.dev>,
        Prashant Singh <singhpra@juniper.net>
Subject: [PATCH v3] efivarfs: add nostatfs mount option to skip QueryVariableInfo()
Date: Fri, 25 Sep 2026 04:31:45 -0700
Message-ID: <20260925113145.7396-1-singhpra@juniper.net>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002319:EE_|DS3PR05MB998685:EE_
X-MS-Office365-Filtering-Correlation-Id: 75791662-3214-414b-8199-08df1af89754
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|35950700016|376014|7416014|10067099003|3023799007|6133799003|56012099006|18002099003|11063799006|13003099007;
X-Microsoft-Antispam-Message-Info:
	1mFaCWuiU98nRh4/cyy5qpMauajqAjb93XiTUTFQLArfAx5Um/uDADsq8kMix2g+GUJK67EV2sUqEeIsGNVCFDWhyHLQJ0WLM05AEyyaD1/kjI8K6qbkdHDByG3EHxYNsepS3HAQwE+OjXHBKcIENyWYUKmVA4mZIViOLSLmli9CnWWbpzbj87PL7agC1NwUg5Wxy1fsLDzaldusGugTScHhzOzCM4Z2hZgcSRFdIc71GJH3doPIRpagBAA5h+cNoNFYIqYKtIU3+a9bMQeeUoPy8HIUAgITLhh0QYvfEodIQrvBzyz36jgM/Tn0gI6HLbu9Fmq8LIr3TJf62Snne4D8YUdaMcwOpXvGmEbRx77FVLYZI98GXGOeazHbCJlIcBOPw/n6vY73gu9gpvwicMvdIB0mtHvn7+086yOhNu+CeV36sPiWEx2DsSTRVbCvGcWXLkVOITNflZOk5ccXVsra+/CTMjvKBAKuIefwDpcZXBebY3G0Q34pwU1u+okS58iIMivIbemkm7Y/XQyaimSFrHeAdulS/6AX3n0fjmL1bnGVUWatduCr0hE1G2F+6VCOATDMSqQ5J556XM/vmDGxOSQXhyYJPI04oSeHwHrfVh78W/hgmCwvqDR0d5G6H3kZkjmYYyNC7CyxmMs69L4Pl/1BZvb2ZKPUkBW0skeqQv2bfKmiNgtLaAbMMGcXth3i2PbVwHydKU/tJlPGnw==
X-Forefront-Antispam-Report:
	CIP:66.129.239.19;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:juniper.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(35950700016)(376014)(7416014)(10067099003)(3023799007)(6133799003)(56012099006)(18002099003)(11063799006)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	G8RVHq33MFFRrVAOy3KlHwjEpk8e5f++B5jM+THDZmatipB8wY5k9shFeak5c9SM1fRKkI1SEOgi5DhifytIspbK4VStNMSqPhPzP2npaFtM8TZb0cNsQEZxU9dAKk+0JieEtdcQKj4BJCkbz+usqzeJz1bZqGvNpcEgC/9uoPxSBr5mgyKirEY9WjwWQpFThMCwFYdr9SlKPh/iLIXjqxpjyNs7mAeUmj7J8WiFRUfFNeCTWRV66vk86LjSO0+9JJmCxWKqTOiIBv010dOGFikmflzxl/PchAqZHnJRzFkmrXfkRaCqMlDe/dS5djVuUqroJLN9fXNmWaAbg0WlLKcoKc2PbDFMxzRvdAby5iE4BwdfpvXe+/GtBL0jjXa7sR1Z7ONRfwRtKbmQe0wTp3dss+ZEZ48I9whhADe+t3DEyHHV1SFw5wYg/nwyS0V6
X-Exchange-RoutingPolicyChecked:
	lclpuFMSYsU+mw/omgurQZ6zJ0j5tL0ehfweUH7XmTGaNWwgn63semzlrZOWOJ/c7yPcN8dTY4BEPkcthV2lnXO3nmpb3GuEVBfdEiOTtRyim708ndT36APUr4TvM0E7x5Z52vIxmS9WVUo1XknNMuEitiBszSTZqTjFyl47I6XjR1UpGp7vvdO7M8E7hHtqriE6KuBT9Wx5lqJ9ZIDots9TOolfG5Ynr/UsLkqxkvOVVR3s2tGOmDgaI3W+3LI8tZB4sTvmXYvFzBVVAV1hrpTboo4FiU90VclMVZTKeHYHnmzT2Pc0chH6XQ20kCUDbOOe4fFWHuLaHhE78vYk2A==
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 11:31:50.2853
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75791662-3214-414b-8199-08df1af89754
X-MS-Exchange-CrossTenant-Id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bea78b3c-4cdb-4130-854a-1d193232e5f4;Ip=[66.129.239.19];Helo=[juniper.net]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002319.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR05MB998685
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA0NSBTYWx0ZWRfX2K5Yda34Gdlw
 JhWbuDPeoDZRofyLeMlzOswOzc7eSTJBI+4Aotu8ejeq2cjFMAodKQ1axM2EC0PGgA0yeGGXw5h
 al4+FkhwaVm0MQNdz3VTApR8VKPd4rg=
X-Proofpoint-GUID: iX8ND4eHBE49cN7L-OW6PjMqUPdPKcWp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA0NSBTYWx0ZWRfX8Ic6ep9DnyGg
 8fkp4mxFwWj34zHn8fMQfqiNgnYKsHVb4cTUP/8TEwg3/NdWJIaWLiP57dOSAQjBZkfhRi8mppK
 mik9dQIPLiHJRzNB6FlhGdyJ4wyXymcyoXHRAb/yIK3sahe9+o9q7M5vkC3dfMhm6yRX/AYz7bX
 RxvBF176IIBFIdLMXOijr9UvvyCCPKEPuWcaTIkXxhMu2PgCYYUswKk5/cIpQSkuHlILP8STxyi
 RZUUjtyyo0WtRm7BR7oud8SlmbjpR4r3fbX3QOzry7fg+eBzomRNShUqlo8VFfbmQ7Z5wjPoH/j
 aHoSLCRlJqmwhZEsHh2pqSFiIj9qXvfoM1Qsalt7nz6iIfQk4hb8hTD4i9upz9tppJyjAVtDgPj
 JIK3Qf/RudT+pH4kb7BAZiBp2S8VRgeS3am07CSUym8Bg6divnUTT3CBZEcBJGifDcefAIiq8Nh
 EkaXixzIM/a6btEIyEw==
X-Authority-Analysis: v=2.4 cv=V5/oQuni c=1 sm=1 tr=0 ts=6ab65bac cx=c_pps
 a=SWHM+P2JNiUeaYpOZLdr7w==:117 a=SKdRtqzh2DBFgDMvUaaGnA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=f7IdgyKtn90A:10 a=rhJc5-LppCAA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gQcMVamqm3wCPoSYhaRC:22 a=6XKncaru_qjgLvANlS_8:22 a=VwQbUJbxAAAA:8
 a=OUXY8nFuAAAA:8 a=JrPZwpGjJBhuogoWf-EA:9 a=cAcMbU7R10T-QSRYIcO_:22
X-Proofpoint-ORIG-GUID: iX8ND4eHBE49cN7L-OW6PjMqUPdPKcWp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: orgsafe
X-Proofpoint-Spam-Details: rule=outbound_safe policy=outbound score=0
 adultscore=0 phishscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 clxscore=1011 spamscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=orgsafe scancount=1 engine=8.22.0-2609040000
 definitions=main-2609250045

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
- Read/write nostatfs with READ_ONCE()/WRITE_ONCE(): statfs() reads it
  without s_umount while remount can update it.
- Add PREEMPT_RT + remount test data to the commit message.

Changes since v1:
- Replace the sysctl with a mount option named "nostatfs", per review
  (Ard Biesheuvel).

v1: https://lore.kernel.org/all/20260917071600.5587-1-singhpra@juniper.net/
v2: https://lore.kernel.org/all/20260919044124.8268-1-singhpra@juniper.net/

 Documentation/filesystems/efivarfs.rst | 16 +++++++++
 fs/efivarfs/internal.h                 |  1 +
 fs/efivarfs/super.c                    | 46 +++++++++++++++++++++++---
 3 files changed, 58 insertions(+), 5 deletions(-)

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
index 8d33f11db2a1..d2e1f31a72d1 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -74,6 +74,15 @@ static int efivarfs_show_options(struct seq_file *m, struct dentry *root)
 	if (!gid_eq(opts->gid, GLOBAL_ROOT_GID))
 		seq_printf(m, ",gid=%u",
 				from_kgid_munged(&init_user_ns, opts->gid));
+	/*
+	 * Always show nostatfs (it makes statfs() report zero capacity, which
+	 * is otherwise surprising); only show statfs where it is not the
+	 * default, i.e. on PREEMPT_RT.
+	 */
+	if (opts->nostatfs)
+		seq_puts(m, ",nostatfs");
+	else if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		seq_puts(m, ",statfs");
 	return 0;
 }
 
@@ -82,13 +91,19 @@ static int efivarfs_statfs(struct dentry *dentry, struct kstatfs *buf)
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
@@ -323,12 +338,13 @@ static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
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
 
@@ -350,6 +366,9 @@ static int efivarfs_parse_param(struct fs_context *fc, struct fs_parameter *para
 	case Opt_gid:
 		opts->gid = result.gid;
 		break;
+	case Opt_statfs:
+		opts->nostatfs = result.negated;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -402,11 +421,17 @@ static int efivarfs_get_tree(struct fs_context *fc)
 
 static int efivarfs_reconfigure(struct fs_context *fc)
 {
+	struct efivarfs_fs_info *sfi = fc->root->d_sb->s_fs_info;
+	struct efivarfs_fs_info *new_sfi = fc->s_fs_info;
+
 	if (!efivar_supports_writes() && !(fc->sb_flags & SB_RDONLY)) {
 		pr_err("Firmware does not support SetVariableRT. Can not remount with rw\n");
 		return -EINVAL;
 	}
 
+	/* statfs() reads nostatfs locklessly (no s_umount); pair with WRITE_ONCE. */
+	WRITE_ONCE(sfi->mount_opts.nostatfs, new_sfi->mount_opts.nostatfs);
+
 	return 0;
 }
 
@@ -524,8 +549,19 @@ static int efivarfs_init_fs_context(struct fs_context *fc)
 	if (!sfi)
 		return -ENOMEM;
 
-	sfi->mount_opts.uid = GLOBAL_ROOT_UID;
-	sfi->mount_opts.gid = GLOBAL_ROOT_GID;
+	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
+		/* Preserve options not respecified on remount. */
+		struct efivarfs_fs_info *old = fc->root->d_sb->s_fs_info;
+
+		sfi->mount_opts.uid = old->mount_opts.uid;
+		sfi->mount_opts.gid = old->mount_opts.gid;
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

