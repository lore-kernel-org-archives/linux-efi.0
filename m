Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11022077.outbound.protection.outlook.com [52.101.126.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558E92848BE;
	Fri, 28 Aug 2026 08:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787905405; cv=fail; b=lvbqK3aOHl3u7npvpwFWJpdlJsyYJ8PHKUNWmaPdqi+EcmLBsNkcW+0ObnIDjTn9IrVSLTMcoVDGl90LSTwtA0hrH90ddCUlNFfqm+AI6XIJePpLq93JIklpFOMtdQ4bSV6zPom8lj2L16sg4U7of8Dmb42N81y6+cSZDnFEUtg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787905405; c=relaxed/simple;
	bh=CiPPPAm7OtgvhmObg/IOKJp5MM5PH3yZQuqIdyXXtik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mWZNkKm6cW0KfO7jJ+ORy3IoLy/kW2mxVrzRQSW7fWjrMW0wN4G2Y76kF3AF5rSQtlgmpZzx14vOH7VvAu8ErY1+iLJduH5hR+ffJWWEePwXzT7gEUCIoOIhgmcIV6+l4Bu/wmv5L6xOQcl7Tr6e2x7jZ1C6uV2D9Wxr6/yWWWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cixtech.com; spf=pass smtp.mailfrom=cixtech.com; arc=fail smtp.client-ip=52.101.126.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cixtech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cixtech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BdAfOYiUCyqLoTyyMK3GsZtOjIKc9UgPmucu9wTo8opj0Duc/tG9jqX5e/CRsg2fC3eafZhtzPKoJKVcv+LUfyGIU2YL3lCVj2l/T6+N/LiIyDTCdlj/rRX6b0exrO+qXCRzLu846/5EwoFclAT9AMgbJHWcpwr5Hy40h+jkJzxZd5Ugm/XGm0ghfzxTf2UR6IL0qtx75xGtwtYZH5aWG4Pt4+J2x1yWfpIWBcvLuThJthTheSuapBbsHBEPVF1F0/ryhSIpFyxKMy/15YLGfUxVvwhN8SbBu+Gpts1HZhTQ2MoCM0e14onwnWfLQtSyd82xveV10Zg/RLpv+iLVwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X/EaGOKB0xkSpfFrRufmb70DOEMHWLnnS6GZksjjGNI=;
 b=iqmPvdleGVh9B/nKYQuukijCYC5v/2GeNDxzM8MSMijPQcvFTZyY2yHrIiwDG9IU3A7C3Jo/sB1eZG5tNnEIa7l+dsiEigYC8sH088khzCXL5asKKX86WWCENpXRS2Lx62N15P2sSq3qRt9DK/jnU6ioaKVXVi6wsh1k016HYF7b4OO66fLoGHenj254jZjV5MDHYt3sYRiwgqD41uQhYlGCtZ5Hka+LJXbJkDXiASOne2WvR1v3/q/p0I/MsVYmp0fQh2FnnEEhUw02c3XxYKBN4awohM5jRNM0Hawo1ULtdVHgmHvGvbk3jPCtXA+I8JGkZ+/s1Of84Spfy6JaEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 222.71.101.198) smtp.rcpttodomain=cixtech.com smtp.mailfrom=cixtech.com;
 dmarc=bestguesspass action=none header.from=cixtech.com; dkim=none (message
 not signed); arc=none (0)
Received: from PUVP216CA0015.KORP216.PROD.OUTLOOK.COM (2603:1096:301:16e::11)
 by TYQPR06MB8009.apcprd06.prod.outlook.com (2603:1096:405:2fe::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Fri, 28 Aug
 2026 08:23:18 +0000
Received: from TY2PEPF0000AB87.apcprd03.prod.outlook.com
 (2603:1096:301:16e:cafe::8b) by PUVP216CA0015.outlook.office365.com
 (2603:1096:301:16e::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.10 via Frontend Transport; Fri,
 28 Aug 2026 08:23:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 222.71.101.198)
 smtp.mailfrom=cixtech.com; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=cixtech.com;
Received-SPF: Pass (protection.outlook.com: domain of cixtech.com designates
 222.71.101.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=222.71.101.198; helo=smtprelay.cixcomputing.com; pr=C
Received: from smtprelay.cixcomputing.com (222.71.101.198) by
 TY2PEPF0000AB87.mail.protection.outlook.com (10.167.253.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Fri, 28 Aug 2026 08:23:17 +0000
Received: from JohnnyFan (unknown [172.21.64.24])
	by smtprelay.cixcomputing.com (Postfix) with ESMTPSA id 61507427CEE3;
	Fri, 28 Aug 2026 16:23:16 +0800 (CST)
Date: Fri, 28 Aug 2026 16:23:05 +0800
From: Johnny Fan <johnny.fan@cixtech.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-rtc@vger.kernel.org, Feng Tang <feng.tang@linux.alibaba.com>,
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
	cix-kernel-upstream <cix-kernel-upstream@cixtech.com>,
	Bob Zhang <bob.zhang@cixtech.com>, Jie Fu <jie.fu@cixtech.com>
Subject: Re: [PATCH] rtc: efi: restore alarm support with runtime capability
 probe
Message-ID: <apFFaaJr4xlcp4mo@JohnnyFan>
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
X-MS-TrafficTypeDiagnostic: TY2PEPF0000AB87:EE_|TYQPR06MB8009:EE_
X-MS-Office365-Filtering-Correlation-Id: 31915680-0af5-4f35-3bed-08df04dd9d17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|82310400026|1800799024|23010399003|10067099003|4143699003|6133799003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	7qDEnPd9vGeo6661llbrDWYxmms8mT/lVnjCqcKX0BaXl+o5iw1cs5AkUXYLt96H4JpL39av1mLK+BDCG3y8uelvksQsye3VzdG/nM+JxJAPB5AF3p9DT86cBADTtMJ20kb/bmuMNmKpA7JfYSBAB2LuQwhXi+gWfuac3x4r8zR4NdwnSFNfWG73O3X0r1U5s7zME+kUfjeavAtJTl/MuTUd3cpEoD0yIt9N2wcb/yQY43Uz2BU1J8fTxTimFvYo0Ubgk27ZyCtcL3ovmFIbpCF1LB3KbYeuLFCofjJdtMYZ2EJkq1LLO6NJtwGu+XHRrFZXafsuUTDzlbF+G/ro375zQFSbZxGxkEBVj4yxnWlhg+pj4Emp9ED0i1lCj0HIXKrwiYN5fojnRUW81vmvXUGyKLuoLe/h7v5m9onoyIX14BkC2tmpvNi0Qw70BfYEQspAk9Qy2G2l+c5AGlf+5F9TgMHQKe/EdkiPe0BXB15ycQlPgIZ13xyzTd5h1+rH1Ub2qjU0r+uB8XCqbyXe+UFMYx0SPYJ5rNBI21tOkNuY6K73c9B5NtTlTFs9Kb7tXpaXQ9C88KTQlzB6lAFW1JGhzYy//3jPPRKf57579a57WUBTQs7OEKOllblgtLoH1e6cBwOeTs0e5uih09/iN+CvAaQ8RhaX/DN6rzl1+CNG2bZkPB0spLryVr2T0znF76XYkjIk3OOfji2jfOp9cg==
X-Forefront-Antispam-Report:
	CIP:222.71.101.198;CTRY:CN;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:smtprelay.cixcomputing.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(82310400026)(1800799024)(23010399003)(10067099003)(4143699003)(6133799003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fh8GxBCT460lb2U1a48I5X3QiXee/F92s4rYTI0NeBcl8680ynQU80eK0NgJDbeBimWI5R8cr5eJSKWcjme75QXrKUYFOrWw7l66Ph8yM3naBxSxs8d3u0eEhioBkMRtD9Q+2wzKCc1ymY5aN92wjfCIb++ugiRZ5yuW2SB8kys2SNt1bCFWBteDzm0txiuCekQXOGuSMT21oHiA7PwcYihT3214LMZ+tQVPA0VE9/wos+w00qiqdblPLOVXISI7nG1riNmvwAUXYFHq9Kc0oFprbSTiOi8k5bKkZsmtmvls6Qi7F3kTO3w2c94uYRxKXApvshX+rbaeQ6ibGX7vE8D4c6wkZPjgriquYmIO5L2t41flAVeHw1/eTn9aCsMODszHt/v1BQbUWdqsOVDPzdSVdpBtz9DIGoreDI99Mao7GCJo1sCopvCYYeL3bem4
X-OriginatorOrg: cixtech.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2026 08:23:17.7155
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31915680-0af5-4f35-3bed-08df04dd9d17
X-MS-Exchange-CrossTenant-Id: 0409f77a-e53d-4d23-943e-ccade7cb4811
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=0409f77a-e53d-4d23-943e-ccade7cb4811;Ip=[222.71.101.198];Helo=[smtprelay.cixcomputing.com]
X-MS-Exchange-CrossTenant-AuthSource:
	TY2PEPF0000AB87.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYQPR06MB8009

On Fri, Aug 28, 2026 at 09:26:42AM +0200, Ard Biesheuvel wrote:
> Why does it need working alarm/wakeup support?
> 
> I'm not saying we shouldn't bring it back, but this deserves a bit of
> motivation, no?

Hi Ard,

Thanks for the review.

The reason is wakeup: on CIX platforms, the RTC is an I2C device
owned by firmware, and in the ACPI boot configuration the bus is
not exposed to the OS, so the EFI runtime services are the only
way Linux can program the RTC alarm at all. With it removed,
'rtcwake' fails for both suspend-to-RAM and power-off wakeup --
Linux simply has no other path to set an alarm on this platform.

It is also a cross-OS consistency thing: Windows programs the
same alarm through the same runtime services, so a shared
interface that is time-only on the Linux side is asymmetric.

I'll extend the commit message with this motivation in v2.

Thanks,
Johnny 
