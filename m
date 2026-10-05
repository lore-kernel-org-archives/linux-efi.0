Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D35737F735;
	Mon,  5 Oct 2026 23:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.143.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791243362; cv=fail; b=Wd3W1UHJGtsWp05fTHYhRjXqyZkVMSIQhzwxe6/o5roKZrVAKjh6IRzFa9VYOmZaO+v77mVSxXB1ZksE+AAMsHm3n/vvuvZAjbugijHGZR97Nb5vH6JslBRy/wpiHkZduj2SsWyAY3sdnlPrZ1EhUWFk51OT/gAZX9crjUDlBEs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791243362; c=relaxed/simple;
	bh=8/tEN7PRIkKmWJje5Ehqrjv3yQ5rS+IT1L5dsKBt1pQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fZFoM+udgI3OOtWpRjg4rul/Q+/L9fOB6+mi5E4A2Dv8S9cml4APnzmF8d5/aJfQTdab2bq05gb+fHeTxHuaY9rSeW1LQNxq0ohtdc8+pBS3OmZ24bj0msvZXUdA33a+V9Uscf0iNnFOnDBqPQqIqSYs8tQJdr2l6+Ddv5MyPBY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=juniper.net; spf=fail smtp.mailfrom=junipernetworks.onmicrosoft.com; dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b=0UUxyETC; dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b=Qwxgie70; arc=fail smtp.client-ip=148.163.143.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=juniper.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=junipernetworks.onmicrosoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b="0UUxyETC";
	dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b="Qwxgie70"
Received: from pps.filterd (m0134424.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 695L25qH3423629;
	Mon, 5 Oct 2026 23:35:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=jnprhpepp0429;
	 bh=ETSMSqnPmIL152q5IMgnx6Ra3EN5nC+EEXGpiRWnfIo=; b=0UUxyETCRfU3
	2lVhSkAUGYTRLzXOJK+U9lHKmR2y7220JB8yK55Ln1gvaGJgwcdQ+H1LH8CYVa9m
	0RAScZH3y9pcvFFmuzIGrFbv1p/0bCXAxbfke+aXCPQ4ViOFnkVS9XtmUQAnj802
	isJoWoyIZ/DcT82HpuwbzpLqhgVER1dF3BHBaHM6UCIZUHDymIGK2TVCY4Ork5Jo
	SSveqcWpDFmVS2qpO0DJvOpNsxfLE0GSuQ1UuyRodNjWHSPvaGEQpZG9MbEod6Wn
	LQPjdBN8O2EqG0lECh/cpILKFlb+rcTqFFmzWrv0CatGwetbZrIEFBTGRv7DFQIl
	CjmToRWpfg==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010044.outbound.protection.outlook.com [52.101.56.44])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4h4jtdapgn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 05 Oct 2026 23:35:31 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y2DaPCO5faN3pP2ZAAGbvDfN1qROOYWuMPtmUl/KL3MmZKlfZcXBx8hhujNsdQbmSorH32yBjRdZnxF3QZ2pMiKdwOqJ8GH/31c7q8HpLXrzQTe481MS1K9qflf/ShYwfrHbceXa8T+H3hkOA+2WNDCJZ+9nMgdqNlFo2Vn9J5DpIKhD904nFBionl2TaOuKHDexJULGznQk/9R7MLqW2eYndjZrCZK6VdpSptMq0DLkA5oE/6TugWDTn0T4Bjrm9CblneD/R0BKZ+Qtet80eAHZ3mY4mOMhGTXy2z+Ez3FbiBXIYwiKmunWsrWcoOI9d98Zo4Q8fITAwztV8o0Luw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=ETSMSqnPmIL152q5IMgnx6Ra3EN5nC+EEXGpiRWnfIo=;
 b=HhuXYbZdV57evi52JbNGqcGpiKpStmPpGwpfD0EfF/M/Zehbvp8uoS+xBn3Gq6hTW7TX3DA6t1FiWHC0364yb0wK9EVIBdoEkDu8mZ7Tb4S9m727fwo6kbJRlqyxTrtJxTZFoX17xGw+0qm0LjS1YTXB1nM9tRF8vxOQwTfAbkRAorxC4QjbeRwr8P/DRukcHmxCFSIKRmCPD+fNLLQp4K6WtzkpnwZ/gu9vx/PIiriL6jn6QyWgY+fZQFpBoqePJ/nVPpdwZ6IxaJm1LB6pkXxGzgJ+SQZaYBHCVq0ukorjNsKZ9kzTzWlfQCcQpTjiLqkqCNhyqRbDpK7V2XYxdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 66.129.239.19) smtp.rcpttodomain=debian.org
 smtp.mailfrom=ebf951f79306.juniper.net; dmarc=fail (p=reject sp=reject
 pct=100) action=oreject header.from=juniper.net; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ETSMSqnPmIL152q5IMgnx6Ra3EN5nC+EEXGpiRWnfIo=;
 b=Qwxgie70uSR9asZCjkEM21SExN6va0jcCiMppX/srhB21s27WevWblucCsoL7Hhb4mnM8aipNdh3u1R/Iex+Em0w1us6Pi1stxkSLdTsEFM2dJWOTNRiXRDSy5sGIZRLS+rRAT/dszvJCPWSY+kMECRC7hXtHVAY+X6eK46Z7iTiXPUaKYNQTdxEKGVzkxiqMa0Ho4xlcvW2cVPDzu3/1HCX2I4eZCgI5gusYqbtAF+2mMlKzY5KAqFS4MPrpvsoNXDkmL9QY5Ghlc1gllh3G4vXb/WjgeiVx+5fptsYAhDio1+3/3L07tPUbt1u2ittUrexurfZWzrZX95IikecBg==
Received: from SJ0PR03CA0025.namprd03.prod.outlook.com (2603:10b6:a03:33a::30)
 by BY1PR05MB10798.namprd05.prod.outlook.com (2603:10b6:a03:5a5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 23:35:27 +0000
Received: from SJ1PEPF00002315.namprd03.prod.outlook.com
 (2603:10b6:a03:33a:cafe::47) by SJ0PR03CA0025.outlook.office365.com
 (2603:10b6:a03:33a::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Mon, 5
 Oct 2026 23:35:27 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=none (sender IP
 is 66.129.239.19) smtp.mailfrom=ebf951f79306.juniper.net; dkim=none (message
 not signed) header.d=none;dmarc=fail action=oreject header.from=juniper.net;
Received-SPF: None (protection.outlook.com: ebf951f79306.juniper.net does not
 designate permitted sender hosts)
Received: from juniper.net (66.129.239.19) by
 SJ1PEPF00002315.mail.protection.outlook.com (10.167.242.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.14 via Frontend Transport; Mon, 5 Oct 2026 23:35:27 +0000
Received: from p-exchbe-eqx-04.jnpr.net (10.104.9.87) by
 p-exchfe-eqx-04.jnpr.net (10.104.9.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 5 Oct 2026 16:35:27 -0700
Received: from p-exchbe-eqx-04.jnpr.net (10.104.9.87) by
 p-exchbe-eqx-04.jnpr.net (10.104.9.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 5 Oct 2026 16:35:26 -0700
Received: from ebf951f79306.juniper.net (10.104.20.6) by
 p-exchbe-eqx-04.jnpr.net (10.104.9.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 5 Oct 2026 16:35:26 -0700
Received: by ebf951f79306.juniper.net (Postfix, from userid 14867)
	id 55E85152679C; Mon,  5 Oct 2026 16:35:26 -0700 (PDT)
From: Prashant Singh <singhpra@juniper.net>
To: MaeeFilho FL <joaoanandalima@gmail.com>
CC: Prashant Singh <singhpra@juniper.net>, Ard Biesheuvel <ardb@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jeremy Kerr
	<jk@ozlabs.org>, Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt
	<rostedt@goodmis.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan
	<skhan@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Luis
 Claudio R. Goncalves" <lgoncalv@redhat.com>,
        Steve McIntyre
	<93sam@debian.org>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-rt-devel@lists.linux.dev>
Subject: Re: [PATCH v4] efivarfs: add nostatfs mount option to skip QueryVariableInfo()
Date: Mon, 5 Oct 2026 16:35:24 -0700
Message-ID: <20261005233524.3022-1-singhpra@juniper.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAFA5sMdHPz-H1EOw3y4RFjHMO9_ZmyV45SwvqF7wh8E4spKujg@mail.gmail.com>
References: <CAFA5sMdHPz-H1EOw3y4RFjHMO9_ZmyV45SwvqF7wh8E4spKujg@mail.gmail.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002315:EE_|BY1PR05MB10798:EE_
X-MS-Office365-Filtering-Correlation-Id: b472414d-a658-4200-2ff4-08df233955f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35950700016|1800799024|7416014|376014|6133799003|18002099003|10067099003|22082099003|3023799007|13003099007|56012099006|5023799004|11063799006;
X-Microsoft-Antispam-Message-Info:
	Ir9B8AMiybpkkr4qfYHgbtxatBxJwVHT42Ni+LKqvj2XOFkhjHkvKRgctdKk9k9U7v7JsxKYF/Ia5odwp9BBbbYPcPeW6sYNP+5+C6qdyLkgXEYIqkWhoijUtW6WErFpqy8ramZJ6T5Sy7ZJ2RBdJwA1WuAt2tZA1sJ7nwKWYibrMcG0yT9D5OdXuZyunO4K5XASjr/qBD3M/AgAuQdib6RdGsbHgWEVPSXOgJZo6Z34UwGRzy6vknCYwIwUIuv5B2J5kiqLDG6GfKgh+qIsWlFP3chSZgrlYyua/BI+UkS1ndsSZ383AJO6pL5psUM4a3uRcbp9MB31c6c7mZ9C7cICohUDS5/M/4MdDylHIIQChuG3zXEB7yY05faC7qTYaM0L8QGP8M4Sae700lH2ZcFZdX3kJAAIqqvS0i+wCBwZZvogC2P8CklWgywXMVgyN6Yc49cLX9GMal7RTjNksa+EAcZdHs0qWD1xFidI2ltVzsSgsYgd64kVBEGDffSll50OhrnjacT2Zu40hntdM9E1YZ+Us4cwxu6/RaJmMUq8kvF20cbRCWom4PUAx13Ik1IvuYVUBC/nyO7sNGTnqrqH8TLu5ZHjUDDGY+TRart/a+dzRcRlBpEOXv0V9nDbe/sDraiw6OShJaBynzZbYDmIxL29/4jh5M/QiDiZW3BkDPQcv0LcoAtz4g7WsK8MR8eYFmCjPHPY3wuEEb7hZw==
X-Forefront-Antispam-Report:
	CIP:66.129.239.19;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:juniper.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35950700016)(1800799024)(7416014)(376014)(6133799003)(18002099003)(10067099003)(22082099003)(3023799007)(13003099007)(56012099006)(5023799004)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	X3J2+LwLo/VT9+KndujxgYf9hxHdumdQ+PCziInNc8FZvwXxGOV4zRqdcDmO1OIIbLGoPnrObAy5IhLTgcpnggSAVywscFzwldoE2GfdOe2/ee+qN12N7iO/fL/3ms6zO7GAOrQdf0O3XUgyEjT+kfOBfB/stwX/krhipmivV45EFAqmuVmH9I0dkVTb1cTs6QeTXCz8OzEcz5aBTSRMo+lu5ZZBwVYHVooE1fu6TSv9HlYjGl50CkDQtSBvH/kUYuPSLfrIhpiByDYAor+9jWfb14IZjQZuZNns8AQ9ExFGUpAGDiQSnqMSiETS027UCd1JvHHYPAMQS7L4ruBstNIGzrrby7h8ksF7tGeQcLPooafSklU0TBlzjaxfgobEtixNKvvDvOKqmTugxKFQu9P+vEdgNHkh+6Zirn8CXAZM6uEw0nNxJ9qUp3kXkJPi
X-Exchange-RoutingPolicyChecked:
	zcfKloEUC8ouZ+EaCGl8qx5hMJuFgnAHAN1y0eUhdpRFYZkFcqqmgExT7rFp+S1EVJ27Zh36DmMmMTQletOCMPr62ymZQA9EIC3/EHxEB8TfW1UFTGdqMyOfk/QTDzZQMC1dfdJ5IE+fFXIoFhxPu9pxRoDXjxtWSUpEOhu0HiSXCKONbyTXWG6p7yIvzcILNtpmFAeu0oBAOp67nZIE91FZca92u9oE1PuRcCR8Ixmw1kKUapba+5u1xpR52iZMd/F9OESO2OYppc3wZZuuCQlP2SO8Kf+v9IZ8568zfCFC/mgfuPEE+AttyJ4eiQvRCDUVX6Zgk33qB9Cwb7Y+rg==
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 23:35:27.2117
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b472414d-a658-4200-2ff4-08df233955f7
X-MS-Exchange-CrossTenant-Id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bea78b3c-4cdb-4130-854a-1d193232e5f4;Ip=[66.129.239.19];Helo=[juniper.net]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002315.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR05MB10798
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA1MDA5MiBTYWx0ZWRfX389n7EPGJjz1
 754ALCOdMcKFG8A6epfY8bkABbRsp7EsU/4EEh6fxdwUEKXZFClIIeMvB27yK7eRqNT2CmVEWMX
 a0vrvahC2JxxGRkeMv9iBstQKwbfS+c=
X-Proofpoint-GUID: XgbfJ1Fm8E7XxjlCSPtLout-OwxBw02Z
X-Authority-Analysis: v=2.4 cv=AM6lcTYI c=1 sm=1 tr=0 ts=6ac43443 cx=c_pps
 a=wV2zXAf6sYQQ4uINbIt3+g==:117 a=SKdRtqzh2DBFgDMvUaaGnA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10
 a=f7IdgyKtn90A:10 a=rhJc5-LppCAA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gQcMVamqm3wCPoSYhaRC:22 a=3haJ9R1Aw3gUfsUHDaCR:22 a=VwQbUJbxAAAA:8
 a=OUXY8nFuAAAA:8 a=LsB0FKVtz1UnEB54oekA:9 a=cAcMbU7R10T-QSRYIcO_:22
X-Proofpoint-ORIG-GUID: XgbfJ1Fm8E7XxjlCSPtLout-OwxBw02Z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA1MDA5MiBTYWx0ZWRfXxH3vYPhvkdej
 78nOUvW3qXrIeSWK2zFjBqx+QL1no2L1WQ768XKcvfvld5oOryqy1kT6XFqnJ6OWGUduIVY3uup
 yv8Vj4QIbhH7QQ/bp1EGMXWL6olERf+LDfQwet+Cq4Ul1HTfLdLYihVj84f+xOrDOa9NSo8oEtZ
 v3EzdRaHS7SV2tzsMQxKcxXUKG3Bedqzz7J1bnj9mBXE8hJ/0ubxi9L9VKkDk8G5O8nSmeHmLvY
 GyYJ8Ni8StbtvFYO4Tmp4B4lOYHprJ/2CnNBTsxAoMgvlygiD8AbGsFEl52i50y/2OqiWqI9OH3
 D9nI8OobtZdO3jQ889IDmtV47Is5V2b5Shdjqd/lcsWFmLnOVHIPH0nWZqToytpipi4dA6gpupx
 VV4OxveL92WKPi0wRZSoYd+G7zd8Nmnb6cN74AL4nd+9Lzei2U71QsiJ1gRPQTPYz+qR20tWR0A
 /ybx+IqNZCMx8TmDbyg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-05_05,2026-10-05_01,2025-10-01_01
X-Proofpoint-Spam-Reason: orgsafe
X-Proofpoint-Spam-Details: rule=outbound_safe policy=outbound score=0
 priorityscore=1501 suspectscore=0 adultscore=0 impostorscore=0 bulkscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=orgsafe scancount=1 engine=8.22.0-2609040000
 definitions=main-2610050092

On Sun, Oct 04, 2026 at 11:43:25AM -0300, MaeeFilho FL wrote:
> For the final v5 patch spin, keeping the commit log focused on the
> preemption-disabled context and dropping the verbose raw strace outputs
> as suggested makes the patch documentation extremely tight and industrial
> grade.

Thanks, Joao. Done in v5: the commit log now keeps only the
preemption-disabled rationale and the raw strace dumps are gone.

> No, let's keep it as you suggest.

Done -- kept as-is in v5.

v5 is posted here:
  https://lore.kernel.org/all/20261005232250.2620-1-singhpra@juniper.net/

Thanks,
Prashant
