Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013016.outbound.protection.outlook.com [40.107.162.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9545C44C65C;
	Mon, 21 Sep 2026 08:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.16
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789978874; cv=fail; b=PPC2q1cslOFar9JWBtoWlp5jpJde7jDILQwALIwVb53RBKo//R1fYwbsRIf2KC/Bizp/A2z6d46ffnVP7fW4bdhOSsfCj5TUApHo6ZmvV+dxovvV/TnP1RmnIDUNaPipNaWUBShRsdR/rsxla8quQ4lrR547NlLWhxJ53ZOaaaY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789978874; c=relaxed/simple;
	bh=XtQV/DuAkPmGocldfO+GjUxHDw+hlzRX7tJ4MKxzqTA=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rJttHj2CgbZv1Jwv6ZdbX1pNRJsck9VnPP6ATi9kTOABhpaViWgDlxuZFjO2hf4qd20ADDeLHeR4o+FjtWKRsYhb2cpn8w/3CL1Dk02BoVeo8yxzCwR8xXpy+LqexBvVjLaoH2hQInXppj6Nh4pKSLz2e7GaReG8WM+dGnuxS/Y=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CGiIbquc; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CGiIbquc; arc=fail smtp.client-ip=40.107.162.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CGiIbquc";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CGiIbquc"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=UpSyNFSjT+v8XEbtt8FXzzPLKm7OxupuwJ8MPpzsA6ZjLoJsCQUQET5OQ7N1p/eFDfq5jAYcDNSTcJaURh5kWTL3AYHCNiE8UxkWIftDt8bKJhP1Lf3wbMC/dKQW0FfWHBJMQoy/lbNLtC8MO+K8Kq5bvp6BlIF4kO5ot9a37BAZXGu+Ix1zZii7bNHQtfahEegZah7Gew+URhOhARKKE9rt2mjVzTGFnQa26gkIKLpxFus3ldgXgjnCfKu3MbLA5i+HxCVm83qPXQmOjgkDbLuUJZH8LTSAGRN8IzetE8XlQ8VDvgVpOx+XyEJlRxzng3Fx5WEhHWdzzCTfIlxT4w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ld4fsMz1PO8JnEw6xikYFppedSByCuu1Yc2yb2bxJeQ=;
 b=rjxmj9JumJP9nK/c9P+89ia43N0ozzEcWQoYp0P8y6S2pB+TLVmLpRyepY3lFCf0brvKaHppb91YqZT98jAEJHjqN4Rss9EQpMRM6AM6KNUOCtHdxXE3ium0yx1cqa2gWCrD/WEXeP9WNH3NeXapYGeDFPmGmPdBe3hN54MvFJUcrKVemKVI/8aUrwlfhJO6s3QU1ILA2Z7fYv11bYGHlULZJr4625EhZ7Mx42OyUvU8IcjG6STT+hHL2ODbCWTMu3UbW/R12K4J6keSIRf81gX7olVBWYWPGvR3MZPTNieYpCpI/IJhclXu2fPw6emxy6L9yIvkns+enlri95dcbw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ld4fsMz1PO8JnEw6xikYFppedSByCuu1Yc2yb2bxJeQ=;
 b=CGiIbqucZGLnCan5r1n0wD+C+gr4RMT8NWxER+l5qtT1Mdzc+M+3fGi/kRDcSYosS29t8z6eyimi6UzMi5WpRKSSUMd9A0cucU86R7ecbiDAIDjx3LZfWGHfZewyeNOejEwZgjXmUTmubUvGKOKXyNVQ38T6T6BVPbgLxDxTkeo=
Received: from DU2PR04CA0283.eurprd04.prod.outlook.com (2603:10a6:10:28c::18)
 by DB4PR08MB9381.eurprd08.prod.outlook.com (2603:10a6:10:3f3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.9; Mon, 21 Sep
 2026 08:21:03 +0000
Received: from MAD0EPF000008B5.eurprd04.prod.outlook.com
 (2603:10a6:10:28c:cafe::af) by DU2PR04CA0283.outlook.office365.com
 (2603:10a6:10:28c::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.16 via Frontend Transport; Mon,
 21 Sep 2026 08:21:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MAD0EPF000008B5.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.8
 via Frontend Transport; Mon, 21 Sep 2026 08:21:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uQWBz4hTRD3YVPabsUL22mzyhbtpkuPl1QzuaLCkdK+fPeVDr+FmOYjrzFC/qR+TmfnC23bzaNjDRxbae+jVkI5/9FC7eDtvPqMCLXPLeydKOEfGdU3wrzXuvmD7VzscHjoNUZ+R66AWfZncRL/a0N7+v80teaO0SAVbG1Yf1sKYxe0mgDROC4QfpWJW5nK5pa0LoEYjJ7lTbHWAn3yFk5fVh5ns4IIeJgI/m/zcR2fAlwJJJXYDt7M5iydv0pEZYYLAWH4Wf6smE61IxgFv1SUFFzt32w1VIZAIjCFlRTdQtIuC+nvzSMcKb3I7fLJ4dfB4LTPh3nVg2y+8f8lxHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ld4fsMz1PO8JnEw6xikYFppedSByCuu1Yc2yb2bxJeQ=;
 b=VoSo8rPLwAW3XRLMhxidcklf9JIza9DMqe/8Yiqq/Hv9YkKJTrcBaAEgiU4LWF3S0VKK/ne1Jd3c/dtDJ0IWVi/9OBkokAEA55jDa8l3DfMP6yULyrlejAFccWOVn+C0TvRcAyyyxSWVABvFhWSZYCPEaP0/OrAhvFnxn+gCWRNVwA/ZTKHasdQjGbgw43CpFf9X8G3td+4iAwoPKBStbiwisuk8aOnbzo3C2i8cYLoGiHYcxWdlx2JhhZ2B2/zJPp/priaNGr6s/0f6vh3MMR1zK4fhrx/nVyRfxyDZcqjCvWcJelx6PN2VJG2HT2VeF/Sa9Ypp2nQ8Y2zeEFGgcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ld4fsMz1PO8JnEw6xikYFppedSByCuu1Yc2yb2bxJeQ=;
 b=CGiIbqucZGLnCan5r1n0wD+C+gr4RMT8NWxER+l5qtT1Mdzc+M+3fGi/kRDcSYosS29t8z6eyimi6UzMi5WpRKSSUMd9A0cucU86R7ecbiDAIDjx3LZfWGHfZewyeNOejEwZgjXmUTmubUvGKOKXyNVQ38T6T6BVPbgLxDxTkeo=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by AM8PR08MB5747.eurprd08.prod.outlook.com (2603:10a6:20b:1c7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.13; Mon, 21 Sep
 2026 08:20:29 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0451.004; Mon, 21 Sep 2026
 08:20:29 +0000
Message-ID: <0217ddbc-71b0-4263-9e2a-3218644d08d9@arm.com>
Date: Mon, 21 Sep 2026 09:20:25 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org
Subject: Re: [PATCH 1/6] arm64: use hw_pte_t for HW PTE pointers
To: Ryan Roberts <ryan.roberts@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
References: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
 <20260914-pte0_arm-v1-1-bb53b663e396@arm.com>
 <3e3e8b33-cf24-4b09-a64c-f9b2bbe604e7@arm.com>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <3e3e8b33-cf24-4b09-a64c-f9b2bbe604e7@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0493.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:3da::18) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|AM8PR08MB5747:EE_|MAD0EPF000008B5:EE_|DB4PR08MB9381:EE_
X-MS-Office365-Filtering-Correlation-Id: ef8ee380-971e-4e07-2c8b-08df17b94663
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|7416014|366016|23010399003|921020|10067099003|4143699003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 m1us37DFPzoeQ/HVPJU6UAaU2tJdVi0MGD4AIEWd6bzJFgE4C6fO1XGbt5yjeVqbx5H6b2MCDRoA7goQv21P/HGVVKFWexOmfWM4QPsAWzuns8Gw+TgVhIOs2Qb/DJgxpjeXV7T+QKmft+aTq6b38nwoE1Zx19pwZZch48gwb4NDOmRtjBkjHhbVzAX0/9Xu91enSaruSgFn1SR24ct1LcZuOEgPRacySNX4M/VDLRPjgxjdfvO6gA1WU8DrOjqu9txHo3kG2kYg/iwsOlUD9OOKahLoo6Bcz22EaAFJbaizhW0CUOmiuYeZ3QLHKqKCmobdXO1sDUaSPVV0rrdOTXjDI60fiXvR5O3qysb6RouVRZKPfZLGycSvK3tyPA3M+SZySf1kKiSJuLSne5IJ/n/0EUgZdKj4YPvfF10X1K5PAFQswGN+NBEaW+UwCGcPAXUz09ItC90H5DGbSqHPmkynKnU8OoFduDYvJWupzf+lneFtiQqUG/cR1YDjZRs3tgpRtOhXzVmpWGFjJ04brKPsM2ZwyKoVyKesQDvsNEiSfl6kNX51PvwLUE1J8kGufw+7bRGwSBfxrVfkp+/fq7n8srbDFhOdfMP5/yhZYxgzw3wGQyJr9fq/Dg1xUs0F7XqxwduIUyX+/ulC+SQzN+hAWEjVUfQDDtM0pqDjrsn9DMWk2P/P+PzPo2G9i9oGCaDssFhGGwrMjM9xPjSFNw==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(23010399003)(921020)(10067099003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 GlJrKnAzx8JlUACYS+uQ4gRP1QiOq2tYdPoZgjpy2/qWKy9go0UipiiCcfjkGEXb88e+L3z0RMDyqUMTlYWsir1Jf6KGkUKXdgTxd/UHdPsSMctQWb/krsKUudtmTdi5eB523QMOxoE1T2TZHx7F53C7CxIQaFJm6Y2CGIYj0DFRsCqe3EvFZ/mvpGcgGmGF9MUObHq6azNR6EjJYC0rHew6SG4cKzxoZJsRoEE/w8I+gs5PREUpbw3kR862kOqudffBRX4rUSDKxpZzxS2aZcIBgKu6o7sugp/PYs66QambACYo6Pec1HG+Mj8OYOJN+XhDBuaAn8l+1SazeDMjiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5747
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MAD0EPF000008B5.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d308279e-aaae-4905-279e-08df17b93107
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|7416014|35042699022|14060799003|23010399003|36860700016|921020|10067099003|4143699003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	HzJGdZthiJBl//yl/LYBH5culPLbUrv9d5R4PQPeolmAP2ijICAaMLCKUlwvtVFoAvEnFfrSZuYVBcGthh6PA3wrCQjmfXDnEwitA/zZn9emBR7Wo8pbMcTdmbTP3hxxzWP/tbzyBDmYq+yTTV4jQyXxpjfvksTsIwd20arbC78wIshttuQ0EE8tSzD8tv14qct0pQIOAMhL7ycRFAR+r0h+kj7NnOjBx3hWH+TzR3IocYUUXrjkbmoaA2axv5tB3CkBV9RtZm6B42ME4dhb/WZx+Ap2F/sEAmsosKz9p0ACGZ9Ggp2CoE0z5qRiDIF4FbsR/zvo9791RchwVv6/wwayMoI/Se/MFxJoRWrZoS5KscKta6OzN5VMdXYwGiHx+tNMnzToSdrPmpdFp1ApowzWgzGdiedl78Yg2AaCGcwqdxLjm8Qkz3+5uM6TMvhzlsQHRMoU+Mpsi6qQAh50EFb3FKRSoXHeZEc2kPQr/o6DP+9iZB/jTBJZfuw5/J89fKrtq8Kdns6zsZLO/Kb8Ic+37QSOhfIpoz26pl3vXA0t8vxElEznpxgYQ41Y1TAxVloyrCZplvVSxzB/sPv5MWOdrmW8FLRmhsKbG6BGSlQiyMTtjFqPRSMwU6g+Ucwyoc6fC2SdmC2ErUja2kYe42UtOCZNTmzy3zaCuGYifwmUH3TykqAr86NzOwV9uuBPEXEhwZQOul6pCwXG012Hg/FB9O0Z3pO5dEWkESmIuIpCDuiwtsJQgaXlNPgbUARX
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(7416014)(35042699022)(14060799003)(23010399003)(36860700016)(921020)(10067099003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cCDoKjITV8HVOk+RwUKu8UDFy5QgaLAKBd7kBnh92cMiwxq3cHM9JYUtaIq26zmCy/4mGl9utuVpPmW+TZA57TeeKEWp57ERBXfkJAWSHS2mAchjxOoRAnOiVW5po4xCTRmJSIWgtqTSCA3ggrcDvnG2rtyAtgRrUQa4R3jWxieFHKRvgMaBeLppwMkOFPHOJnLWI18xGyXuwHKJuxR8BDpJ+w3FirqRWGM718qnFPF4287j68NDtzrIVUo3zmHzZzuLWnN6GoUOdCCAgSJV1zia59sums6haUEDADjsEu3O/QUL5oQfl8VVT9AqFayo38NxJYk1nUzS1RYrHu5QoMp5NVv+rR68pxL2f8ABINr0u0pP/RcwftawLyBF/kO+4ar5SFIbi09XFhGBFyXeNrKdoAI7EZCDJOBlciTi7mwkIdCo9OAp59RAduFHP1eH
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 08:21:02.5525
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef8ee380-971e-4e07-2c8b-08df17b94663
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MAD0EPF000008B5.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB9381

On 21/09/2026 8:59 am, Ryan Roberts wrote:
> On 14/09/2026 14:51, Muhammad Usama Anjum wrote:
>> With pte_t * used for HW PTE pointers, the compiler cannot distinguish
>> them from SW PTE value pointers. The generic HW PTE interfaces already
>> use hw_pte_t *, so arm64 HW PTE pointers must use that type before
>> ARCH_HAS_HW_PTE_T can make it distinct.
>>
>> Convert HW PTE pointers to hw_pte_t *, retaining pte_t for SW PTE
>> values. Helpers shared with PMD and PUD operations keep explicit casts
>> because this series does not introduce distinct entry types for those
>> levels.
>>
>> arm64 still uses the hw_pte_t alias in this patch. The new pointer
>> spelling therefore denotes the same type until the final opt-in.
>>
>> Include linux/pgtable_types.h in pi.h to make hw_pte_t visible.
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>>  arch/arm64/include/asm/hugetlb.h  |  19 ++---
>>  arch/arm64/include/asm/pgalloc.h  |   2 +-
>>  arch/arm64/include/asm/pgtable.h  | 143 ++++++++++++++++++++------------------
>>  arch/arm64/include/asm/vmalloc.h  |   2 +-
>>  arch/arm64/kernel/efi.c           |   3 +-
>>  arch/arm64/kernel/pi/map_kernel.c |   4 +-
>>  arch/arm64/kernel/pi/map_range.c  |   9 +--
>>  arch/arm64/kernel/pi/pi.h         |   3 +-
>>  arch/arm64/mm/contpte.c           |  49 +++++++------
>>  arch/arm64/mm/fault.c             |   5 +-
>>  arch/arm64/mm/fixmap.c            |   6 +-
>>  arch/arm64/mm/hugetlbpage.c       |  48 +++++++------
>>  arch/arm64/mm/kasan_init.c        |   4 +-
>>  arch/arm64/mm/mmu.c               |  46 +++++++-----
>>  arch/arm64/mm/pageattr.c          |   4 +-
>>  arch/arm64/mm/trans_pgd.c         |   4 +-
>>  16 files changed, 190 insertions(+), 161 deletions(-)
>>
> 
> [...]
> 
>> diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
>> index f66a0016dd02d..237a9136bc73b 100644
>> --- a/arch/arm64/mm/fixmap.c
>> +++ b/arch/arm64/mm/fixmap.c
>> @@ -35,7 +35,7 @@ static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __bss_pgtbl;
>>  static pmd_t bm_pmd[PTRS_PER_PMD] __bss_pgtbl __maybe_unused;
>>  static pud_t bm_pud[PTRS_PER_PUD] __bss_pgtbl __maybe_unused;
>>  
>> -static inline pte_t *fixmap_pte(unsigned long addr)
>> +static inline hw_pte_t *fixmap_pte(unsigned long addr)
>>  {
>>  	return &bm_pte[BM_PTE_TABLE_IDX(addr)][pte_index(addr)];
> 
> How does this work, given you haven't yet converted bm_pte? You're returning a
> pte_t* where you need a hw_pte_t*. Either the compiler is implicitly converting
> (which would defeat the whole purpose of this series) or this patch doesn't
> compile until you convert bm_pte later on (which I suspect is more likely).

At this point, hw_pte_t is still a preprocessor alias for pte_t:

    #define hw_pte_t pte_t

After preprocessing, both expressions therefore have type pte_t *; no
implicit pointer conversion is involved.

Patch 6/6 then selects ARCH_HAS_HW_PTE_T, replacing the alias with the
distinct wrapper type. This ordering keeps every intermediate patch
type-correct and enables compiler enforcement only after the pointers and
storage have both been converted.

> 
>>  }
>> @@ -43,7 +43,7 @@ static inline pte_t *fixmap_pte(unsigned long addr)
>>  static void __init early_fixmap_init_pte(pmd_t *pmdp, unsigned long addr)
>>  {
>>  	pmd_t pmd = READ_ONCE(*pmdp);
>> -	pte_t *ptep;
>> +	hw_pte_t *ptep;
>>  
>>  	if (pmd_none(pmd)) {
>>  		ptep = bm_pte[BM_PTE_TABLE_IDX(addr)];
> 
> Same problem here?

The same applies here.

-- 
Thanks,
Usama
