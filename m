Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA43353A6B;
	Tue,  6 Oct 2026 08:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.143.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791276245; cv=fail; b=TMVj4P8dj4/WiW45PzpWH8w7aJ2k/EeIEPkSiuhuBqbMpSAwao/RXHmrupOwllJCSj5NeGY5t4iL8o3FYd8VvsVIcy7eH7e9UAueY0X0D7IyJyFe2xurlDUbIXiyYj89sWQutQux9995sR0ci80WLge533L8gFqtZpjLt1rWNuY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791276245; c=relaxed/simple;
	bh=0M00IJzf+LUazCnnSbCNCN14kp4IfgCejd9kUucSFfQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bRXai1NZezw1GQNlr8auDrrmulmgAyS2D4yIaa+miwLuJUm3+kmsZuKwdmfTD4qgihQVrzs38KPYzSKnRyGmVpV6ECcXVRVT7/lTnJ3/sYbcl81/TJiPRGOxyLq0o1H/npWKH5e/sSTeNpQWfar2qJlEO5XMlNzPGbWmskmOhQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=juniper.net; spf=fail smtp.mailfrom=junipernetworks.onmicrosoft.com; dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b=1L/1X4EN; dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b=r44ySSyA; arc=fail smtp.client-ip=148.163.143.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=juniper.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=junipernetworks.onmicrosoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b="1L/1X4EN";
	dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b="r44ySSyA"
Received: from pps.filterd (m0134423.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6966dHVw3348829;
	Tue, 6 Oct 2026 08:42:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=jnprhpepp0429;
	 bh=YBjBgg5lJ/MSQCFerbG8H/+RNIlSkg6D3rsrQ8jqt90=; b=1L/1X4ENNrjy
	w7+YTdUscNnpH1v876jShUiR/OuJuVzglUhxzBYy87/Dy+/BQbydZsVm9yhUVRPW
	q/WNZ0k2M1aqDhrNUy2J5dL5nHapYwnwNkaBEl7gY1+SNVuXwXT6Pme8JeNvWCh7
	fE9gHpcesshASq17QeSXMdttlL+BDzbSq87zSbxM4P3fdOZVJNVb1MD2gPKT3TiS
	0MLVs/5MeCyuSRlYdSu1WmdpdjIjSc0B9+MHA6oiShDyfcFhR3P5OfHr5FdR2fkB
	d+HKqWO2k979nv0zIP9i+C0PlEyzmX1s0wV/lSQYptZK5qOehIXRY9u/YvfZKpGB
	7XBVaCSKNQ==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010037.outbound.protection.outlook.com [52.101.201.37])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4h4t65u6q1-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 06 Oct 2026 08:42:09 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ncg7EJjAdFQ9FGkUbwKf6WZ8GBKya9YLwH/TWIidG5wWXZBxeXgNGKDiW13rB8B/xPbPUiZyFa3TCdUjQ8vbGnXK8gUKUfQ4mND+p8fNVpoxZL6SCyEVbnNxe8o1ynYkgJqz/mTFSgIbvaxa0fdO5eBirCxSFdFRK1SIwno8PTyia+ZbtGjLMdPS62DAyvX/4NjpQDJSQx0V25JF3y+z4e55JBCSB2Vb2ACq5UCDtO0+XgO1oUB62E4lZSBHx0T3PqP2KE6j6qLOx9huq0OCmBn49zKHw9AR1MWcwDvJBwpuxRDZ+udiDr6iYszvk+E/waSPpoqFGni4gYLL1OgSNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=YBjBgg5lJ/MSQCFerbG8H/+RNIlSkg6D3rsrQ8jqt90=;
 b=j4XHV5ceOTqSpAi+cxz6ujp5RZZwxYfzgpy9fWZ68XjSddw5BMRrpcIg0dafyHmTHC0/wBkjO/yxVrNmII409gsGXZ1gnMbD/6IFFSdb26xuzSrn0/WqYbm1ZroxY+9M9pGKYG/78CMlGdyCA5xU2YXYSBhPGvBY94ltN8ZjqHhr9UFlejlrG8yg4T0kZ78Gn9H7kqJlR590WamZRngutjM+JOXP4vckEmEAqTNg7DJhybR70Uv/qNiuzTtVgryNRmlOtXxXcisPKZy3VLb6WOvWrL4EacpKOq7d5QENA/tFtFVdmJar7Jds4RLwqntCUfyu2jxIBaqEZocDoDD1iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 66.129.239.19) smtp.rcpttodomain=debian.org
 smtp.mailfrom=ebf951f79306.juniper.net; dmarc=temperror action=none
 header.from=juniper.net; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YBjBgg5lJ/MSQCFerbG8H/+RNIlSkg6D3rsrQ8jqt90=;
 b=r44ySSyAnCPXghsdA806rldR1yQkm71QSw8/9HUmoas91XfJ8bwYZ2XsbNkY9EGLx0KfuNLSTs2UDgJbM/CqLeyfYBSWy4/jhxwWyPqMn0IN/HmZ2lxjHaJ7P9q6R/0fML6Pa1JRkhrzKWqZR8Zy3iI4m5AW2e9Qg4aY0AzG+k/D7Q+5VRO0OQALGCgAsc4QjJWPGu7LJEjhDqtk0YqwHAH/e//7fhJUTRBZxz269q+f6WNH/xoH88vrC/htAaBTk+SAdRvN40wOYmEhVVuGCBSLZSkCqE+J3gfdNMVw3wxFchOCeX8hGZfeXXOLVEPw5h6pSoU0iKUQAJ45DVsHWw==
Received: from CH0P223CA0020.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:116::10)
 by DS6PR05MB434985.namprd05.prod.outlook.com (2603:10b6:8:46a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Tue, 6 Oct
 2026 08:42:02 +0000
Received: from CH2PEPF0000013F.namprd02.prod.outlook.com
 (2603:10b6:610:116:cafe::a5) by CH0P223CA0020.outlook.office365.com
 (2603:10b6:610:116::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Tue, 6
 Oct 2026 08:42:02 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=temperror
 (sender IP is 66.129.239.19) smtp.mailfrom=ebf951f79306.juniper.net;
 dkim=none (message not signed) header.d=none;dmarc=temperror action=none
 header.from=juniper.net;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of ebf951f79306.juniper.net: DNS Timeout)
Received: from juniper.net (66.129.239.19) by
 CH2PEPF0000013F.mail.protection.outlook.com (10.167.244.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.14 via Frontend Transport; Tue, 6 Oct 2026 08:42:00 +0000
Received: from p-exchbe-eqx-04.jnpr.net (10.104.9.87) by
 p-exchfe-eqx-04.jnpr.net (10.104.9.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 6 Oct 2026 01:42:00 -0700
Received: from ebf951f79306.juniper.net (10.104.20.6) by
 p-exchbe-eqx-04.jnpr.net (10.104.9.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 6 Oct 2026 01:42:00 -0700
Received: by ebf951f79306.juniper.net (Postfix, from userid 14867)
	id EA3FD152679C; Tue,  6 Oct 2026 01:41:59 -0700 (PDT)
From: Prashant Singh <singhpra@juniper.net>
To: Ard Biesheuvel <ardb@kernel.org>, Jeremy Kerr <jk@ozlabs.org>,
        "Sebastian
 Andrzej Siewior" <bigeasy@linutronix.de>
CC: Prashant Singh <singhpra@juniper.net>,
        Clark Williams
	<clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jonathan Corbet
	<corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Randy Dunlap
	<rdunlap@infradead.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
        Steve McIntyre <93sam@debian.org>, <joaoanandalima@gmail.com>,
        <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>
Subject: Re: [PATCH v5] efivarfs: add nostatfs mount option to skip QueryVariableInfo()
Date: Tue, 6 Oct 2026 01:41:58 -0700
Message-ID: <20261006084158.11523-1-singhpra@juniper.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <fd8750f7-a30c-4b60-9254-395858bc9aca@app.fastmail.com>
References: <20261005232250.2620-1-singhpra@juniper.net> <fd8750f7-a30c-4b60-9254-395858bc9aca@app.fastmail.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013F:EE_|DS6PR05MB434985:EE_
X-MS-Office365-Filtering-Correlation-Id: 68dc7fae-e5be-40fa-af67-08df2385b091
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|35950700016|1800799024|18002099003|22082099003|10067099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	0HHIi2+q2SVkVlyBkCBIRzyVPF8/WLD1dwZS0hSdGF9RekwCMtag5cqpia9DD6WFF1DjvC1pNtV4NjBorrynpGPN5/7dccIvomcl1nD1GITHRzQQ4AZKAfAGLeiZRZsnWGMKAT9g71S5Im9mA/NbUNzAz2ptQhLenG/LDAet4Meq14LzTv0eWAwJClQ2Av9G9kq+epNyk3G8iB6LF8KF5RcLlWApJZhEpvOKQOcnwqtSx6lsLCXVYuQhkvfTnSCBlWkM6/3xyEP9CV7blFgGS+WWInxGBMqmMC66xZ0/KxyW2KpX0pSK6CQQ/bIzNIfex+5Zyu7O6bLIwWFXAFIcimXZxwir/2VlmXYrKSptdipqWMY3MtdJo4U0DNWH8uJViHvr9nkZwipQWCkaOoI63ZAX9jdMA1nmaymmE8Uxyto5+LtSWEVnSpc1h83tXRcTCB3U4YN8cnnfTTZPABCTO8O6CYgGxQtt/oYxfW2LokIwWFe1fzU2m6HvGfqHLHoGJLVCOsEpQLMqnre5m2bDELnT952PzAtpvjzaL2zjcoBhv2HgFEBej5wSVZuqPuNYsgAk5bSto2EEsYk1ISXDEQ3OIA5BYMXjs+rw5RE6Qpi7z69eiPBsXrDTGzlwa/H/Zn66CiVfjKInfopJFcxCoqbb28oEpCrBsvQnmqQTn4yyzoOSL9dMkm/7HeTZ47ossx/nTy6ZXpF+zWFIyIpWhA==
X-Forefront-Antispam-Report:
	CIP:66.129.239.19;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:juniper.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(35950700016)(1800799024)(18002099003)(22082099003)(10067099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hVn1U0KZdM5T+DD7g5URU22yva86uJxsMPzMEsk6m7Omv69FHsElQBbrZzyTxt2UM3odQ+2RFc4Mprh53OclkoB0SWkmOncuNXQes3gDInh0eMtzJ8ZHR4+YynKTCWWOV7KQu6fzTaz1kRdzcBXCmNJeZ6zdr3IT3hTNcODBkpa1vNKDiUzGyfLDb3u8NADCMt/lSku+yU0vfTyWjq3eUprBdgn3F+LUJT00Zt+D7XqYvYtAnwmkQdrZ/Y1tCV3rjfXc5w2bBqWh4LTX9ElLgQ/5kOJDE67wKuPD3jo7Laj6Bm07jYrQwIGGFO7+hBaUN9LJtShnV22JkLof6Qz5+Lm2rNbtLh6p29ZvYVU4aJcALd744hgBb3oqJT/yGDmwsyUsTzE6EF5/bn5X+jlyDfoJM3IrPFO0KOKNle6YGF/JPrviwpm6mrDd6HvFtCb3
X-Exchange-RoutingPolicyChecked:
	InF3YwzZV3jhTG4bq/IR+bktHsej/o9eAR7xmuEKISSAlWPJXu4/vWfPbRGuGrahjYvwRWN6UhWMB+vFFEUlGy9FSiQecXjYoXEh6czDB7xrZ6F2BgczrMJKJ/SSOMupYYKSerIRdwoJMjXj1iK52QjzYqqzwYRX85Hjt94Dv6ISNwYzEi0nS17HPubGRvVLOykGW/JKRxY+Kznou+6+PNeLf9mrXdIWbxN4a83iyRZ1FxJ732J+Kew1XGQGh12c4InSM/+UCfuXVUkvPy0QN6joxE9rK/P7tlqcpStjcWNojJtWIlc81LB/Hnp5aqi49EirY6iifD/HX0+5m6rY3g==
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2026 08:42:00.8868
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68dc7fae-e5be-40fa-af67-08df2385b091
X-MS-Exchange-CrossTenant-Id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bea78b3c-4cdb-4130-854a-1d193232e5f4;Ip=[66.129.239.19];Helo=[juniper.net]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR05MB434985
X-Proofpoint-GUID: FCA4Ubc0HQolFAruznWMHtnZ4G5H06o_
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA2MDAzNCBTYWx0ZWRfX1kHnbFsUONyI
 h28AZ+OM+gUldGulj9G8OqcvHH5feozir0TT0dWqyVvg3V1STUyDKpDj2eGIF6e1yz3mO6ahnKW
 np7PkWfBM3vNLweD+SUTEbj/X1m/ZAQ=
X-Proofpoint-ORIG-GUID: FCA4Ubc0HQolFAruznWMHtnZ4G5H06o_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA2MDAzNCBTYWx0ZWRfX/7cnnzioLMy6
 Tl3KLOC6vu9VuX4Wh/msaPyik1sJHqjzcPrCIFHu/cvEQ5rLRbs7XWRTjGMaRNZzlF9zyQchKxl
 jbz4I+GaO3mOZy7YcLstWhVICRrCzT628+BUPYzbrahfYhPjdF477Eb5AdpOrwq38kU/12sf78j
 G8lCoWhDbY/euF6fDpykdq2Az7TbX7fZh1n0iBEYdtd1wx+g1FHWhEo4fCe7Kp+yeYVsKWz1uK7
 JnlVcBouZ8Lr78iQZ8J2rZ5ilMsC/En8zEuAR32kLjj94Je0iUS57C10OS28XwfJFJDsKxHk4DK
 duISXWf8PxWsjUQRQlKqIVefyeiLvTcL9DRkYINo40eLTFclMstdYGPB1HtDAbFgsZkf6GOzbh1
 oiGVEKJb9dVvZEzjBqaZORcVwWeza9knL4EF4HcJnhcMbd2suIzJQZu3YkU/REbYHyAQg4v4xDl
 KsQ97cguvjbbnOh5YMg==
X-Authority-Analysis: v=2.4 cv=Y7ptIReN c=1 sm=1 tr=0 ts=6ac4b461 cx=c_pps
 a=fIWvqWWOoOps8dVAlNTpGg==:117 a=SKdRtqzh2DBFgDMvUaaGnA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10
 a=f7IdgyKtn90A:10 a=rhJc5-LppCAA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gQcMVamqm3wCPoSYhaRC:22 a=g3u0LPWLDYfGfufhFw6-:22 a=hmfSGiSs7xPFuiQWvfIA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-06_02,2026-10-05_01,2025-10-01_01
X-Proofpoint-Spam-Reason: orgsafe
X-Proofpoint-Spam-Details: rule=outbound_safe policy=outbound score=0
 impostorscore=0 clxscore=1015 adultscore=0 phishscore=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=orgsafe scancount=1 engine=8.22.0-2609040000
 definitions=main-2610060034

On Tue, 06 Oct 2026 09:09:33 +0200, Ard Biesheuvel wrote:
> So what happens with uid=/gid= in this case. Do they get reset to the
> default or not? And before this patch?

Preserved, not reset to the GLOBAL_ROOT default -- and unchanged from
before this patch.

efivarfs_reconfigure() applies only nostatfs to the live superblock; it
never touches uid/gid. uid/gid are parsed in efivarfs_parse_param() and
stamped onto inodes at creation in efivarfs_get_inode() (inode->i_uid/i_gid
= opts->uid/gid); reconfigure() has never re-applied them, so they are
effectively mount-time-only. A uid=/gid= given on remount lands in the
throwaway reconfigure fs_context and is ignored -- the live inodes and
show_options keep the original mount values.

Before this patch efivarfs_reconfigure() only had the ro/rw guard
(efivar_supports_writes()) and never applied uid/gid, so there is no
behavioural change; the patch only adds the nostatfs line.

Verified on 6.12 (Xeon), identical on a stock 6.12 without the patch:
  mount -o uid=1000,gid=1000   -> uid=1000,gid=1000  (opts + inode owner)
  mount -o remount             -> still 1000:1000     (preserved)
  mount -o remount,uid=2000    -> still 1000:1000     (ignored)

Thanks,
Prashant
