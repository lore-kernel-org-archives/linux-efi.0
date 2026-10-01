Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AA83655FC;
	Thu,  1 Oct 2026 01:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.147.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790817694; cv=fail; b=kH1j/V1mfO0Pgu81MebnnURP3XPb/fJRqlR+4HD0bHSzLLbKNCqwIC+YfGjbLGe3D7KLn9VZibThcTH5Et27lDsTMjV5zS85YFI1Mw2S5ru5f5g/UpUPYaN0zCQnUfVxAxIrTNWAV+r1MPnSiZ9BnpSAdkHNhixeZuSCjOMcXVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790817694; c=relaxed/simple;
	bh=nVPjTq5VTrr264IXiomrsgzA73YevZMEelzAZe/RjSo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V+wGrnhu0uBeSyUOZG05AsA+qTz4OiZFBSi7loTW7+77UIs7swCRH3wqpHunP2vvH9ivSguB/xwW/SmomwbkvvpB3dEC6HkFQQQqrfBeN5PR5qPmjHEDh5473rnlxiewBrGOrQSHFfgGa+AgXy2ZAVjlCZkDb5NGGAS9iOzp2wo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=juniper.net; spf=fail smtp.mailfrom=junipernetworks.onmicrosoft.com; dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b=XAvs7L8k; dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b=AKZdK0qY; arc=fail smtp.client-ip=148.163.147.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=juniper.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=junipernetworks.onmicrosoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b="XAvs7L8k";
	dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b="AKZdK0qY"
Received: from pps.filterd (m0134421.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6910oVNB1860400;
	Thu, 1 Oct 2026 01:20:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=jnprhpepp0429;
	 bh=VHL6UmsGmT0HZPR/4KSjhSreaHw4t/XWFUSTSAJUBOk=; b=XAvs7L8kQ25F
	SN3ivJWyAC05aMa98rNkB+mP6k76T77te0tcJXiox5t67DSu0c0OCNIYZarQxrx6
	9iD23zbFTP9doew9A9Cd+bzfWUDprSmGaCtqzE8pJjB19aI1U3mUbU6kkYCpMNzR
	arHPCrOcJidAGBn+W9mUxE3s9nA4aucLQa55k/zldzMELiWM/gaQjSNypOg0hr3a
	TSDYaPAkfx9cIUtJeEjv1klXC/RUqEIC59/RU8Auf+ilxYJvOiwC925+0cI5Bj0+
	iJ1d/gXFbxQ40Gzb542Ke96NpKPxAvoz2MLoGDE0E7ng+cyyJZkss43Equ7shoAX
	Iv8nhg2BTw==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012003.outbound.protection.outlook.com [40.107.200.3])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4h1a7y2p3y-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 01:20:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n1A6LqATO6A0a3uMj3yG+wovfYmv9+Fq1qUPis1H/93f78JZc21PhCEokYVS0NLPd+HLXuSD1SwyaF2pu18ZbU2izZ8BhYMBIv9JyKSl71GZNRRZSq2PgBQ+bcu52VPSFHrnynA3xXOTER4Xc6ErUeErReP3cKSgOnqiIAnOHhyFa1EyQbLbgZqQ6keqnct5RYVOrynHCCMe3TjVAXTDdv5IpMa6p1c8/DWNDN9oa9lwySAV59CitbIZZL4sgYGNOtxr6OUVzYgh97TUXrNHMvjU8Gw31kY2Vjdl5/pWK/fnv86xfPtholh+cwCbDQkG7wqgipb8PCh/NDZ8Jc+0pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=VHL6UmsGmT0HZPR/4KSjhSreaHw4t/XWFUSTSAJUBOk=;
 b=qwJjaLzZNwUa4UHD6s6w3z/7QUjfbGCJIy4CTZeTe5LIlVpA+BAIfnPDSfNSN6BqCQ2ukB02IaL6PT2YCOtJt+L4PWOXGHKrpIIiz32tgh4TCL0HKqcFMa0gL1KmdiUNu3lUdi1IhxECGFC6hij54bz8H/5t+0tILuxfyPKd6uGw+ezvctrAnK45dc8f1XrPurh+3oGnXUrSD/lR8LNZjFs/EzpU9ANAHqYlmReNBo2JTox8aJlzVq8UZQ1KRw9MTg/CNX6uCn8vbJKeqZtegnq0AN7ia/fj6T6ru1wuLgKoiiATQVaFzgT+1kzbDAOKWqK0kryDVUyrsrK355bEZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 66.129.239.19) smtp.rcpttodomain=debian.org
 smtp.mailfrom=ebf951f79306.juniper.net; dmarc=fail (p=reject sp=reject
 pct=100) action=oreject header.from=juniper.net; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHL6UmsGmT0HZPR/4KSjhSreaHw4t/XWFUSTSAJUBOk=;
 b=AKZdK0qY5WSb/DdG9EhsV8ZaHjV+2wa2st2F3wcBCVE4csZobv0sY3ldZaUokI33eZeRFWwm4SRL2CK51wsgqcpApH7Ti89xHsv3GCF3ZA8qXyu/DZBDGR/Re8povH267uPtnyqwKeSwXvRv+WMpndR5Lfba4KH3b46CiVxhQhBEj2gtbs5ODwWSWQR+jZaZeWYP60QVMIc/W1F3grvhvQrj5+wRexAPlptp48iY4c1swA1CSlql2mu06ZhfxcAffU7EZOi9TfwSeorcQpjF/xHYiC75nQI8osZPd4dxDst+r0HgmJK2CCU7KfxCsFPgu/vq2LgpiFekiJ1J2byTFQ==
Received: from BN9PR03CA0665.namprd03.prod.outlook.com (2603:10b6:408:10e::10)
 by DS0PR05MB9054.namprd05.prod.outlook.com (2603:10b6:8:ce::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Thu, 1 Oct
 2026 01:20:16 +0000
Received: from BL6PEPF00020E62.namprd04.prod.outlook.com
 (2603:10b6:408:10e:cafe::2e) by BN9PR03CA0665.outlook.office365.com
 (2603:10b6:408:10e::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.15 via Frontend Transport; Thu, 1
 Oct 2026 01:20:16 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=none (sender IP
 is 66.129.239.19) smtp.mailfrom=ebf951f79306.juniper.net; dkim=none (message
 not signed) header.d=none;dmarc=fail action=oreject header.from=juniper.net;
Received-SPF: None (protection.outlook.com: ebf951f79306.juniper.net does not
 designate permitted sender hosts)
Received: from juniper.net (66.129.239.19) by
 BL6PEPF00020E62.mail.protection.outlook.com (10.167.249.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Thu, 1 Oct 2026 01:20:16 +0000
Received: from p-exchbe-eqx-04.jnpr.net (10.104.9.87) by
 p-exchfe-eqx-04.jnpr.net (10.104.9.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 30 Sep 2026 18:20:15 -0700
Received: from p-exchbe-eqx-04.jnpr.net (10.104.9.87) by
 p-exchbe-eqx-04.jnpr.net (10.104.9.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 30 Sep 2026 18:20:15 -0700
Received: from ebf951f79306.juniper.net (10.104.20.6) by
 p-exchbe-eqx-04.jnpr.net (10.104.9.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 30 Sep 2026 18:20:15 -0700
Received: by ebf951f79306.juniper.net (Postfix, from userid 14867)
	id 67EA91444BA9; Wed, 30 Sep 2026 18:20:15 -0700 (PDT)
From: Prashant Singh <singhpra@juniper.net>
To: <bigeasy@linutronix.de>
CC: <ardb@kernel.org>, <jk@ozlabs.org>, <clrkwllms@kernel.org>,
        <rostedt@goodmis.org>, <corbet@lwn.net>, <skhan@linuxfoundation.org>,
        <rdunlap@infradead.org>, <lgoncalv@redhat.com>, <93sam@debian.org>,
        <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>
Subject: Re: [PATCH v4] efivarfs: add nostatfs mount option to skip QueryVariableInfo()
Date: Wed, 30 Sep 2026 18:20:11 -0700
Message-ID: <20261001012011.30525-1-singhpra@juniper.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930063217.eWGJ_JpZ@linutronix.de>
References: <20260928203445.72318-1-singhpra@juniper.net>  <20260929074312.v3jT8uel@linutronix.de>  <59d5452c-42b1-4784-a593-5e549a2a0f12@app.fastmail.com>  <20260929151401.doOQX7D0@linutronix.de>  <20260930013500.10273-1-singhpra@juniper.net>  <20260930063217.eWGJ_JpZ@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E62:EE_|DS0PR05MB9054:EE_
X-MS-Office365-Filtering-Correlation-Id: e766820c-ce6a-4008-5ce3-08df1f5a26be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35950700016|7416014|1800799024|82310400026|22082099003|18002099003|4143699003|6133799003|10067099003|56012099006|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	CyvgfQ1pN6BtlScIK4v7xC9qX+IjzqhNBxvsT3YfrBtLPHxEhULCprRMjJvvFCA+pcx1aDeXRsDVSx6HwJ6O6ZRpnxMkikvdPFC7BzXkndg2rQY/9g8Jm1EBKvYZZ5EKUmURSbR5uq4p/dnSJNclR8Bjr2IFWtjg4hFnjWk4MA5GkLfcLKvFtq8mZ8wSLGzmy+GianvyJoNLdyQfT3NjFgQ8if/sw6/9HGf/SO7tDQvHJvLRS8+E6Ilrev749d1O39ab6YGAWdeiZeZRda5mEoD7uAqhpF8xOpwx0RPDL/dgWeZJYG6bhjqSWvaGunyL4FQ2W0NpeqAfPclF4xrY85Z02zjkkuXDAR6TgvYFJtC5opouXfZ/SdQAjbmXrGGguER10gkmLIHwSdwdjyzMtxE/7h9oJc281MlhKrbAjbJwQ/1Jek4N3zJ3CHhemQV6HwDe40VXLda38biHTv9ho06OI5sHdgCGdfbXshDIA8UrK4mA6l696drjnYN23eZsiqks5ehoZbf7YV7Z220gKvXWrqMONrS21+jA4NvjJUm/G2+8A0Tafl2WJapOwZZdFardQsfUG2UPcmXW37X31aTvqKS05YDlvXWbRNxBlYcwr4BKlvRb9ls78RzvYghRvb6l/8Niqc+eTE+Yh2vcGM/f7EeR7J9tHp+s0x0I+hdcUdsqLD/8zknDOYqkNo3fdoaAhDQ6HstCha+GHQZwWg==
X-Forefront-Antispam-Report:
	CIP:66.129.239.19;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:juniper.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35950700016)(7416014)(1800799024)(82310400026)(22082099003)(18002099003)(4143699003)(6133799003)(10067099003)(56012099006)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9XHv26lfUdwUI2wueOW3olF5XnLMx1/HLx/WspvrqbNSxgQiqvNOWML8+9vmjGxksV9cSBtPbSPeL2RmVYYiltAtvYl+4iQZ8A7Zj7Ry0PBK801/4rzcux0o1GuuoambWi3ESnLekq7hOfmNF5FsnAmnZIBIRiB6k3nVL5LibVvOC1gkT9E+kBs1zL37BZm+ErJQY0lVO3TqAIgBstP+mwc6YsCTUb4lIkfwYDvfnoBP2nJ8+hLwCvo3Ho33+DV35QXcav+IsxGyeRN7CjskhnBOQeW6VkTHBCpfgE7agrSIEGs1aeLuFu/zNBzxKbFPYTK62HPs2Byxq4njsZ8E1XoD/wGBiHoza1MOt7gE5qtd31r8SgoUzkLjYPwrdH5GUMH4qxT9oAYI1OAb1PRsJ6PYHm8BnOtWR38UCUCBMHULwv9SaEt81suCFVIXKuKo
X-Exchange-RoutingPolicyChecked:
	fpmJVNk6Yc1wkp7ddDODsUdIBtyCNtSPOg8CHikqe+yiaJwG10/MPnp6I+HBlbn0K+BQ+oGlfZOmvEL2p4SFOIMw04GwHiaT9mlLR3LwzOR2tmkrFH3suF5skrEU6FFNTyGv3cZ9e4R/SBYMRhA3X06sO/rBzgHqciKTtXUVejoCRgdVE1wdE+HP8JZnznCJ+K21EVcC0+tUIEWQszO0MphlzcbdCov89x8MerBeUZh8cEhCPco+2kj/4PkpT5eDQ/zi5ZzK2FIpsg666nP56TawlU5enNVRnX8UdwhdpBF2NHY+u6z9pO/eBJ8phIkH0O4UPn7xg9YFYdN13ZYQWA==
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 01:20:16.5996
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e766820c-ce6a-4008-5ce3-08df1f5a26be
X-MS-Exchange-CrossTenant-Id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bea78b3c-4cdb-4130-854a-1d193232e5f4;Ip=[66.129.239.19];Helo=[juniper.net]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E62.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR05MB9054
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDAwNCBTYWx0ZWRfXzSkPTKvaFQI8
 90WGnRcuxBzzMl8vlRdHJb8DRKAbI1eIp7aC7Zviy+J6sq9DDGswDaJkFspwvPfAdpzh6Rzj+kx
 8+5kc3CmXHrSMslXeKFBYHxJZRdX85ccFn7Q75U1snh+S4Kr9SlzHE8GLvbfw3d+KA4kUq6pHx6
 OjUkqxQDjvOYklGdgxCMLvbfWrFjE/ef58N5/qGBU7IZ7yUTxXwD289UcSVdJq0StAzKmr3sLyE
 UTr2ubkeHRdQaoHuwLNjP+V/8B0UtulxhQzbo1XuY2zGoUHvGilq6dx4i+PJs2831D9CRoT0dXw
 T0geqgubEpYnkLGUFlY4q7//byxJPAgTKagPJ9QyOnDxExB1ZEANOlLFe/YMbdQHPerAsnYQVPG
 cBKcsWEHdXEe1KQHonPv8g/gbkssWRH29sh/qGl2l/RavgAaXDsrxKRfB9NbSeSiCPl36+NqqxY
 4rvtynD0R8lnoX56qHg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDAwNCBTYWx0ZWRfX0cD0wlAQT3AP
 3b9pNiWFe4T0WN+k4owlpwWbhxkOZT8Z/Vwzhmcp4Z1p8FsIr3D5pN8HFSuEdZr4jhjnxy3Rr8p
 jMJkzS7m6PsbVgGPDHB7Y0iTEIMzzNc=
X-Authority-Analysis: v=2.4 cv=We2Z+EhX c=1 sm=1 tr=0 ts=6abdb556 cx=c_pps
 a=QsHTWkejXhsF4jLr7vu2uQ==:117 a=SKdRtqzh2DBFgDMvUaaGnA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10
 a=f7IdgyKtn90A:10 a=rhJc5-LppCAA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gQcMVamqm3wCPoSYhaRC:22 a=ay80y3fxfMS_JZZz1qJy:22 a=28hbXIuJbkYIf9WHxNwA:9
X-Proofpoint-ORIG-GUID: 9aPCytUNlSVI5tmOzuYq7yM81GnKANQt
X-Proofpoint-GUID: 9aPCytUNlSVI5tmOzuYq7yM81GnKANQt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: orgsafe
X-Proofpoint-Spam-Details: rule=outbound_safe policy=outbound score=0
 suspectscore=0 clxscore=1015 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=orgsafe scancount=1 engine=8.22.0-2609040000
 definitions=main-2610010004

Thanks Ard and Sebastian for the comments.=0D
=0D
>Yeah you can trim it a bit but git commit log space is cheap and=0D
>only people that care about the patch will read it anyway.=0D
=0D
Will do.=0D
=0D
>As for the docs and code comment changes themselves, please make=0D
>those a bit more to the point. People can go and find the commit=0D
>that introduced/updated them to know more about the background.=0D
=0D
Will do.=0D
=0D
>>                        used/ available. Disabling it skips the EFI runti=
me=0D
>>                        service call, which might block the CPU for a few=
 milliseconds,=0D
>=0D
>might block all CPUs for a few milliseconds.=0D
>=0D
>>                        reporting 0 for used and capacity. Enabled by def=
ault on=0D
>=0D
>Instead, report 0/0 for used/available.=0D
=0D
Will take care of this.=0D
=0D
>AFAICT, that would potentially leave KCSAN instrumentation on the reboot=0D
>path, which might trigger and interfere with the reboot. So instead,=0D
>I'd like to put this in efi_reboot_required if we can. If it is needed=0D
>in more places to address an actual KCSAN splat, I don't mind. If it is=0D
>just to make Sashiko happy, then we shouldn't bother.=0D
=0D
Could you please clarify what you mean by efi_reboot_required here? nostatf=
s=0D
is only read in efivarfs_statfs(), efivarfs_show_options() and=0D
efivarfs_init_fs_context(), none of which run on the reboot path, so I'm=0D
not sure how it would apply.=0D
=0D
On the annotation itself: an internal review flagged a potential KCSAN=0D
data race rather than an observed splat -- statfs() can run concurrently=0D
with a remount updating the flag, so it is a genuine (benign) concurrent=0D
access. I ran concurrent statfs/remount loops on separate CPUs under=0D
KCSAN and didn't trigger a report in a bounded run, which could be=0D
expected given KCSAN samples accesses, so it doesn't disprove the race.=0D
Since KCSAN only needs one side of the pair marked, data_race() on the=0D
write covers both readers and the reads stay plain. I'm happy to drop it=0D
entirely if you'd prefer to keep the benign race unannotated.=0D
=0D
>Please keep this description _here_ where you have it. Once this is=0D
>merged, you could send another patch, extending the documentation with=0D
>the statfs option (I think the workqueue change is in).=0D
=0D
Sure -- I'll keep it in Documentation/filesystems/efivarfs.rst for now=0D
and send a follow-up extending Documentation/core-api/real-time/hardware.rs=
t=0D
once this is merged.=0D
=0D
>You still have the problem that someone reading the variable leads to=0D
>the same problem but this requires a privileged user. And if I am not=0D
>mistaken, someone sent patches to have efi-runtime runtime disabled/=0D
>enabled.=0D
=0D
Agreed -- the variable-read path is the same, but needs a privileged=0D
user unlike the unprivileged statfs()/df trigger.=0D
=0D
Thanks,=0D
Prashant=0D
