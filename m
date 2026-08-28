Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11023139.outbound.protection.outlook.com [52.101.127.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329443E95B3;
	Fri, 28 Aug 2026 08:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787905968; cv=fail; b=jnt7i8YzFt5cA1niWoQaNlETCTz16X0uCJ5qEvbj+Uyj6bKSLsnkonSlXQCurRtui8r6NhX6uh5vyAi0CPCyXrt+pyrugTf6YhnRxq+jEJ7fobE34/IjnWyYLeTIl8HvIxZcuGOxbFDRR0cdLljWS2xT9JMfBIOWH1vhPZj+aNs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787905968; c=relaxed/simple;
	bh=O91QhIwxJLVtfP4OmIAhh6fUM70BFCoagYQEVYuxTSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KlsU3PxTxchfgqhypTkOaQX7qDmUYjYMtodG9BcuZo3qxg6WLGVCnJCp0o3z3KuruWU6rTJNnGj/b/Po9GRGojwj1Tnqvz9wwGofneetKwJwYeTDEfIBWu2iR2yNbudnjeXLv9EyepttBOyvPoE8yzzj50+ZBIW7Jq5GBtUsPfM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cixtech.com; spf=pass smtp.mailfrom=cixtech.com; arc=fail smtp.client-ip=52.101.127.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cixtech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cixtech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=taS/QKDFqXckZxhrvvIeFKEKyhcd8HceR6nmmG8+8vEGZUtGTMwii64T6vQHPx9M6JVaUfAgNYiK/c0vkYlgE825E+BdGRC0jjpDCqs/ZbaNif7RMUGWMB/rvKIdjztrXud2jlZmHnhKpRH9rZO4O2Kt+5lFPdLTj2+JCrxrV1gYs0Oqb6g39iVW1JnpwCDh/Cm3HN5X98Y8Xm73p6kZ5v7Pb/aRMGeSW7/rMnlEbHHqVG31GrIIW4F9658ilLE+nLtRlwret0AEaEbK8eFpTswJeRyFNuadhamjpiqBkfiwrfvG8mtNZi9uZj1eZSVgJ9+sQ2a+xxEKUx2UOKbpEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O91QhIwxJLVtfP4OmIAhh6fUM70BFCoagYQEVYuxTSs=;
 b=Fo0CtufZbWU0IumNHiIr6lTwqcVTmhbll5QY7kKoXSC4H0dslgeN7UbyRdEcHVp7Y1Puo4ikzT4PJY8tZezxg+oczBlYvVrOPlZouQTDIKByjDtQjAUAJmr0oAuXAUSwq52Xcs/s1T1tyyR1UqWV4p9PxmbX8c4hv9bKXQbUqkF+RdjsIJOwmKLhdEpKtDWjT4FONLlvlYJ+Dgu8xpjL3cb+U0psnXAI9kuegV9n/9ndYHy7pEgn5Y9sHj1WEMNXCSQ0e0wqx/MS5OnSRMSeEXFv+wLJZ7MqNdcO98uwlEj4rTMIJDbdgC7RnBNr2BBIWwc+LZ6imImjWQ3Qs+vCkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 222.71.101.198) smtp.rcpttodomain=bootlin.com smtp.mailfrom=cixtech.com;
 dmarc=bestguesspass action=none header.from=cixtech.com; dkim=none (message
 not signed); arc=none (0)
Received: from SI2PR06CA0012.apcprd06.prod.outlook.com (2603:1096:4:186::13)
 by JH0PR06MB7108.apcprd06.prod.outlook.com (2603:1096:990:9d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Fri, 28 Aug
 2026 08:32:41 +0000
Received: from SG2PEPF000B66CF.apcprd03.prod.outlook.com
 (2603:1096:4:186:cafe::2) by SI2PR06CA0012.outlook.office365.com
 (2603:1096:4:186::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.10 via Frontend Transport; Fri,
 28 Aug 2026 08:32:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 222.71.101.198)
 smtp.mailfrom=cixtech.com; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=cixtech.com;
Received-SPF: Pass (protection.outlook.com: domain of cixtech.com designates
 222.71.101.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=222.71.101.198; helo=smtprelay.cixcomputing.com; pr=C
Received: from smtprelay.cixcomputing.com (222.71.101.198) by
 SG2PEPF000B66CF.mail.protection.outlook.com (10.167.240.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.3 via Frontend Transport; Fri, 28 Aug 2026 08:32:38 +0000
Received: from JohnnyFan (unknown [172.21.64.24])
	by smtprelay.cixcomputing.com (Postfix) with ESMTPSA id 66C5B427CEE1;
	Fri, 28 Aug 2026 16:32:37 +0800 (CST)
Date: Fri, 28 Aug 2026 16:32:33 +0800
From: Johnny Fan <johnny.fan@cixtech.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>,
	linux-rtc@vger.kernel.org, Feng Tang <feng.tang@linux.alibaba.com>,
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
	cix-kernel-upstream@cixtech.com, bob.zhang@cixtech.com,
	jie.fu@cixtech.com
Subject: Re: [PATCH] rtc: efi: restore alarm support with runtime capability
 probe
Message-ID: <apFHoVVdhJsmBXDR@JohnnyFan>
References: <20260828031519.2749354-1-johnny.fan@cixtech.com>
 <549999fa-4b1a-4f53-872a-9036a377f8cf@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <549999fa-4b1a-4f53-872a-9036a377f8cf@app.fastmail.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SG2PEPF000B66CF:EE_|JH0PR06MB7108:EE_
X-MS-Office365-Filtering-Correlation-Id: 5988c0d0-70b0-4f46-3cd6-08df04deeb7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|82310400026|36860700016|1800799024|10067099003|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	9v+16Jw09vI7E37he+m7UJO91Yrl+xL71h5UmVTnEJydSJCtK+eKN5RwyY9JnR2B4loupi9F6z8x8eQR2TmslDXe52eBMo/1YkuL/CvPhjeun51CbrF/xA7n0/9Y0xI0EsnB3bn53DliFsjw8yrj+H7/9COt5E6SK8kUV1w7NLMM9GehoW4C0/ftu+JrtLVsoibeSa88HpKoqw+LXTzGeRIiWR+wHfK/fQQHqBiyGVxUdTEiw7jSO4jUXk2sQK2Zk9G17JFh90BPCC21KYVhOkdmuOUpVMiaeP2LC3uiOV3UyRG444YNNkGAWWkXT3JohV4bU3Fwl/7sPfivhkznjZdyTkQdhJ6b4JKK6wXwEbDPTlr+yHEVOc6uUKB98ZvKnzBs2p2vsBRnaBqKzOypD+Wpevj+OHP9H7z4gqYMTD2CzzlvW+GJqSzlBQ+Z8nkKfr++27EYDV3H3TfRw8IOsTkyFZDpMPivIfjQ5Vb9jh12JP03y97vdpUXq6GczMUCFXm5FcP/7O7zt1NqFm4++aRctwsnrjvcXbBCOC4tujzt+I4Cyr4ME76kcqNEZ3JbUTxuGMz0jQ9nm65J6vcSWhugDe2av94a0QitlOE3v6ZTSZDikhiuFUPKhOyTdbF53lFi7E2bgEC7yc+eayQ8VHwun1kgO6KgQRFzqAT+DxQ7eyqxqLNzDZcfiFw4Dnkc7uxdYI0mCvBTX6JjE6CQJg==
X-Forefront-Antispam-Report:
	CIP:222.71.101.198;CTRY:CN;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:smtprelay.cixcomputing.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(82310400026)(36860700016)(1800799024)(10067099003)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hsDJiXaYplUbhOOmBKjluhg9gePd1MkZfPs12MTqxZATgzzZiW6QNPrXbkYea44Nh6pTgFxQablMXC3++/sSrqx00z7YMHTAEzldr+7N3adoQjiRB6zaWPS4TqZboViFiwYXxMxO7gL86+fyKzEgfI1EqTLGlqmjNyp3q3nW0niZ7NsRd4x+crgEVrEaeFQeu7aHtfUrr6nvOaj8opFk6oNefbR0lLIkLjFjj6QjyWfVqEeaS1yTZDeHUZ58IugptiAAFDdsik9Q+uv5yI1Wzv4VQ7tt6eCLuRHrxmN6Vp9Y38d+vxHnFtYtO/IOnUTzCqSn5QRVzZDYClKcezGaf8y3vikXEu8Dczk9IfzmL3KoW51cThpuNDaLqJKVJ4ESty7buXKdDzX640shdgMkOUfuObNFDdhv/dAlcLpK0XIwyswKwAUHRY3rAU5rB3t3
X-OriginatorOrg: cixtech.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2026 08:32:38.7899
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5988c0d0-70b0-4f46-3cd6-08df04deeb7a
X-MS-Exchange-CrossTenant-Id: 0409f77a-e53d-4d23-943e-ccade7cb4811
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=0409f77a-e53d-4d23-943e-ccade7cb4811;Ip=[222.71.101.198];Helo=[smtprelay.cixcomputing.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SG2PEPF000B66CF.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR06MB7108

On Fri, Aug 28, 2026 at 09:26:42AM +0200, Ard Biesheuvel wrote:
Hi Ard,

One additional data point: this is not a hypothetical requirement
-- multiple CIX customers have explicitly requested RTC wakeup
support (both suspend-to-RAM and power-off wakeup) on these
platforms, which is part of why we are motivated to restore the
alarm functionality rather than work around it.

Thanks,
Johnny
