Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECE4217723;
	Fri, 25 Sep 2026 01:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.147.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790300793; cv=fail; b=JqVaF+nKqbQFQL5fLtmAXPO7xT19rlUXPASfRpz30y7P6+p/iEUEbOhClkdZjro9Gq6BQ37e5CkA9GhEFJnPTqBiKt6iCOA5QXbLFwrcE1otRN6smE5cIjY4OpVaXp9kg6A2+r7t3oTlyPpP352bI8zknvFXLyuO8+CjRae1Bj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790300793; c=relaxed/simple;
	bh=Ao1Gglpou/488gq56Y0j1JsHikuOZp5bdwusXNvTUEM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kol/HcJ/yzqMOMyYEmPmMi+BdSPoXrecwmIQT3mogtYjdcOWyC386hRmSl+UHLywhu3rRwVSKzBtIiKmOXN1hyrGUjO2e25KBMe8fF8nmcC+F78z7JJ0DRIZ8GxkzIm90Uv2Khn6McP/h5pfJGhpRLHeFhu7BN4WjbJ30q/Itv4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=juniper.net; spf=fail smtp.mailfrom=junipernetworks.onmicrosoft.com; dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b=Nj76OJn5; dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b=Cv3MzBAL; arc=fail smtp.client-ip=148.163.147.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=juniper.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=junipernetworks.onmicrosoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b="Nj76OJn5";
	dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b="Cv3MzBAL"
Received: from pps.filterd (m0134422.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68ONWKjx1416411;
	Fri, 25 Sep 2026 01:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=jnprhpepp0429;
	 bh=Ao1Gglpou/488gq56Y0j1JsHikuOZp5bdwusXNvTUEM=; b=Nj76OJn5hthK
	giwn36neiEGId+NSbzmHHGNDvC91zOd2fcY7dfp1kO3L0ED/qIBOH1bszINDlVvb
	sqST8vDzy12Mhya6tZ78rZRHgf1eWQmXOpoJkP1+gbH3QkxiKt9NHvvMqJrzrcG7
	WV+t/dTY+akcmyU8CEbFdhRvUMCENYw1a64l6zzWigJ7VNnD6lhCRQqXvvVOGbn2
	rGmmro3qr/Os+Qjuj0pZQb1YViFPTDdzroVOv8Ozq3gTRY3irRSBJZYSpoXHY+/9
	JQtk7MGy/mAoVl3oHqXx5aAV0lFYNybALbCoh6+hLeabYtMDyNiVVdAgCf7EaKuJ
	e5IzM+Gpbg==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012050.outbound.protection.outlook.com [52.101.48.50])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4gwcv4sq71-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 25 Sep 2026 01:45:31 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RoORNIo4r5suD9IoahGFIK6MAZgnVPqXDhELrk9addzqEGYaVL22UF06Kdz71/4OhRVeJ4vYy7FzoUHc6joxWYF+wUHp4YhtX6+xQMkciGRGzmIHKruZwL3jkJQrCBaDoO0LGp7leDFbn2skxx99GvFVdYL5Akdg4zPRSKSp2EqO7FoslijsEoAnWeUGteH9FH2YnoJuavQ9WM79Bfr7ZnkMOTdJYmBU3dwMfv4auMSPycUSKtwPjne0jpdRtaCjDmikE4M7wfCDaNaLTgOqED1hAwgoNf/FcdGW6pm4PSd0Sm0/YL2DWIwJY/omy7JONNS20ZyRy9Z61mR50EG0Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=Ao1Gglpou/488gq56Y0j1JsHikuOZp5bdwusXNvTUEM=;
 b=de5mNTPEPWyxVkW3RMv46PMEYAAHSHrU4t9pxhsrEvkvBOP2pQlYLD0mJx/Cgo5qf2R4AxXy6ib0x7lgKrfqdy88CNyl4XsekjX4/R67vO88OUsPHYlQFsyXr72Axv9nxSdylU/EdNM7CRHUBGYXiY+3AOQq0hU3LQFQ/ELjEvbmGNTJEc8V7fVqpXHrrzsAiYGft+RcOVpuYTFawhudqHz9UmN3LpvXwvEJ/5VocNJdoQvesfQuBkG8Ol3gf9gQ4Deqa+uIqv2jH6bbg7LVYIWbyXbGyuMEkCoQhk9tCrCw6L5INkdGc8uWU7uP759trwzQefsNuz76J4UlA7HVxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 66.129.239.19) smtp.rcpttodomain=debian.org
 smtp.mailfrom=ebf951f79306.juniper.net; dmarc=fail (p=reject sp=reject
 pct=100) action=oreject header.from=juniper.net; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ao1Gglpou/488gq56Y0j1JsHikuOZp5bdwusXNvTUEM=;
 b=Cv3MzBALPHxAJn9pvBAezhaMVodMSDgMOiuiqGJh47xCCaeYUr3SQwhPlr5U+03B1b7gwbTdZjcHAgCDfDsc+9C3MYEH7J/MtDTq0XWRzX8JxwiVDzOaC2MacjddaOdyVKV5fAle8uCRhw22QRcLsxsikz7z51opowR8MQ+mnMKFKvfXx7ZhZtqYA5RCjrRQSKZJcF8CRIKPD+LbYuH7TcLCqUaGhfwJJyjFu+ZsLaOwHMZ/Ys6pfbOyUFHIs0ZHGkk+1PgKoDD7M7yobNXwjAk4cdsP0d0AurN7oI+OCaZuwUgvaVBU9RS6phHn+KYzgGtybvIoKFjJAXMuL3o4xg==
Received: from SJ0PR05CA0071.namprd05.prod.outlook.com (2603:10b6:a03:332::16)
 by BY1PR05MB10798.namprd05.prod.outlook.com (2603:10b6:a03:5a5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 01:45:29 +0000
Received: from SJ5PEPF000001EF.namprd05.prod.outlook.com
 (2603:10b6:a03:332:cafe::55) by SJ0PR05CA0071.outlook.office365.com
 (2603:10b6:a03:332::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.7 via Frontend Transport; Fri, 25
 Sep 2026 01:45:29 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=none (sender IP
 is 66.129.239.19) smtp.mailfrom=ebf951f79306.juniper.net; dkim=none (message
 not signed) header.d=none;dmarc=fail action=oreject header.from=juniper.net;
Received-SPF: None (protection.outlook.com: ebf951f79306.juniper.net does not
 designate permitted sender hosts)
Received: from juniper.net (66.129.239.19) by
 SJ5PEPF000001EF.mail.protection.outlook.com (10.167.242.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 25 Sep 2026 01:45:29 +0000
Received: from p-exchfe-eqx-03.jnpr.net (10.104.9.50) by
 p-exchfe-eqx-04.jnpr.net (10.104.9.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 24 Sep 2026 18:45:28 -0700
Received: from p-exchbe-eqx-04.jnpr.net (10.104.9.87) by
 p-exchfe-eqx-03.jnpr.net (10.104.9.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 24 Sep 2026 18:45:28 -0700
Received: from ebf951f79306.juniper.net (10.104.20.6) by
 p-exchbe-eqx-04.jnpr.net (10.104.9.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 24 Sep 2026 18:45:28 -0700
Received: by ebf951f79306.juniper.net (Postfix, from userid 14867)
	id 5693414C5E35; Thu, 24 Sep 2026 18:45:28 -0700 (PDT)
From: Prashant Singh <singhpra@juniper.net>
To: Ard Biesheuvel <ardb@kernel.org>,
        "Luis Claudio R . Goncalves"
	<lgoncalv@redhat.com>,
        Steve McIntyre <93sam@debian.org>, Jeremy Kerr
	<jk@ozlabs.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Clark
 Williams" <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
CC: <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Jonathan
 Corbet" <corbet@lwn.net>, <linux-doc@vger.kernel.org>,
        <linux-rt-devel@lists.linux.dev>
Subject: Re: [PATCH v2] efivarfs: add nostatfs mount option to skip QueryVariableInfo()
Date: Thu, 24 Sep 2026 18:45:28 -0700
Message-ID: <20260925014528.2015-1-singhpra@juniper.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <0d23d4f2-b5b8-47c3-a676-f6ec72ecf45d@app.fastmail.com>
References: <20260919044124.8268-1-singhpra@juniper.net> <arUD_p0Vn4qyBH_e@redhat.com> <20260924111913.GN3447081@tack.einval.com> <arULLk3ERQmADDBU@redhat.com> <0d23d4f2-b5b8-47c3-a676-f6ec72ecf45d@app.fastmail.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EF:EE_|BY1PR05MB10798:EE_
X-MS-Office365-Filtering-Correlation-Id: ba955147-7417-408d-8f60-08df1aa6adae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35950700016|7416014|376014|82310400026|3023799007|10067099003|56012099006|4143699003|18002099003|11063799006|22082099003|10063799003;
X-Microsoft-Antispam-Message-Info:
	En1dnzF5rNrsPhSn/y3Tl+STqqoerIgXICScvwLSrJY8XDLYoHdNbIwupkIi8CJrv45nZ5qsW4DD/PqzjgUtG8qYXj2dxem88jAaZppPqREXAX7bR4mcQeoNvyjJatKO3B57gGTuMr28M7Ud2dKPbRtr8ihhl4By1/QdSipaNaalSpbjytx9ZRYtksCL7RmfaHY25iY6z7lGPy2mwlCzN6ogRRJIci5CD88jeFfJ3ct2BJ79rMs6CpOk3sXnX4lt+HJVNueWvTdBNL7J7g5Ra+ZfJmgw15UAQ/PZKVnGujXKj+LJsOGXnW32IymFs0biar1rwkMHINz8N8jl4V58T+EfS6gypvnMT5fkP2jggbnxDypSOoTj28XmT/ztq4KjhPqN8PEb0v9z4PAyk6B6lCuxOn2aM8achvrSDNM7CQqKbTDkBERFyxTSPB9k6g2nzKINV9uIJJq78sOtLipfYNN1c8LBjzT+maha7c1c7sbME2ICL63D4FLkzxQnW+O/7VOjfGxtbuu29ZVlaBrgNA0/mN3MsoLLAM3CohF5Rrc7fN4h6O4Fetjlr/j1r+JlBjTWete6T7ISs9kxqDPwt5hp/yo+umX5scrH3dlO8MyZzgXPeS3yLcZu0Ih7VyMeQZeOpZb7BNZgTsc+62yUYDhbm/l7pXB2T/iM6+KRU+prTUVxUXtmxgT/BLibpnwR0j+TPRJ/vUaAQapvSNs+Zw==
X-Forefront-Antispam-Report:
	CIP:66.129.239.19;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:juniper.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35950700016)(7416014)(376014)(82310400026)(3023799007)(10067099003)(56012099006)(4143699003)(18002099003)(11063799006)(22082099003)(10063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3gPSPbGp19nR/MdkTHyVU4YNzUq2VxMpXE+WGLYa8OVmKgfSURXSm4XPxiNBBw5Hy79wVl9Xg7KDJJ+G0BLtDfyj07u0xH+ILHl01/gfD5LOdmgPr0UcQg0/7IP8hSYnTsw/XkMBwmJM8ytXJqtiKetPA6f4qtSTAwYvPojqjXv3d5Nhb6JgQxtEeQwqmTztMheXxqICZW/QLxT38d2q3SVWIgLUhXcFM0+d/lOPuggflsT4bhTv9DRwSHWxHoHZ71DpuJiRHqhBIKHvBre2ZOA/JZctCuYdQWKVx6mI8pISJ+Uzk2ivsTSdJftHbjJHYdF8eXxBjBMvG0UH/xgQku06XpYpVBrNmus/qfEIWlAg3NTNw4/jyNtWZU/haxbhcr9cb9A59j/ZskpBHqvPdst64NSpMAFrG5DLIIf3FqWG8hS9fBi/swIiBT5o3hdb
X-Exchange-RoutingPolicyChecked:
	d1WObdxHUOfgtzcgnIPoFaMKyRTTDHLSj9gnvlVIrgIGvXH9YMNhvUAqIhJWyWHm8n8WWb8k0qUxmD5xz8MLpkkHyDjZEA9e08bXJWzYe4+J96UB8I+FsgCokOgMdJ8OEytmKZqoMoNq0fnKA2GDwfd2SRL7MWJd0AUuGdn3iGCsdT9Ma3Mb85F5ejylX3FubbRchbwGokUbDP8IGaChdLG7zxXApwSf6TbSvUnN5slEN9tL8IHbyPOS1sZBUkLMj1bC6W2+rZnwEJHLpaNOgwzouMT54Pb1oKSQbNHFzNvZjbbzTRvh8Zb/nSXkEqZZvOIrSN5N52i7RxUIb5xgfA==
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 01:45:29.0544
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba955147-7417-408d-8f60-08df1aa6adae
X-MS-Exchange-CrossTenant-Id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bea78b3c-4cdb-4130-854a-1d193232e5f4;Ip=[66.129.239.19];Helo=[juniper.net]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR05MB10798
X-Proofpoint-GUID: msJ4d6X67M5cGGLXimtXdV3EAGJ_I5Nl
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDAwNiBTYWx0ZWRfXx5FuEVbe6By2
 W1sF5jaNGoVVnW9s8oF+45cXtZrMjw7mhTVPnSrHTZD3qBurZ6IEDID9nRmZgWLV8FjMDIIdNAk
 hBKk1kSvnU8GvHMi44BUFv73h3Zre+k=
X-Proofpoint-ORIG-GUID: msJ4d6X67M5cGGLXimtXdV3EAGJ_I5Nl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDAwNiBTYWx0ZWRfX2Vylo+r89v5E
 jPfcTnUj2wo29fJiw+D/QPVfhc2pnquTThGSvJFKTz1Tua3r/FdbYlS7t33MCzyA5uMGGJ6U6nq
 FAGMzN+u9C+Y4d1oV1sbnI3QYxfEBwUVzoYqiQpgbH/4HhkBuncRU8kkNLLn/V6wzWfq1h0qrCG
 X9vQe7Io5mRtiULwXtGWl0htqcJMpSTjsR8gvX0PSEjH/PdIZ2IqlcdibrVeBjg6Wx0WKQt+kvp
 aogUBZcMQzzrPT85dqEm4aNQZPdUrhoOLZWg3DWBmK/gRkRF76s4l/EJZ/vyViKBqAwNdPqaVKF
 TepnsACMNkv42LIU3l8ke7hbAssKitGBc6WSXso87kSCdvTz5d+YPkZp6Ux86JQLkhWKW+K34b+
 3ix41V9FsWZdiyZQGD9N5NEnlHl/pF8dS+X166Bqa+wO4sdbKbEDltEoOuIRmI4mIUMtehP3uX4
 eBWS3K1bgewsVSSoagQ==
X-Authority-Analysis: v=2.4 cv=Zrl4uN7G c=1 sm=1 tr=0 ts=6ab5d23b cx=c_pps
 a=XY6iRpq9SnwSJlsx6znn0w==:117 a=SKdRtqzh2DBFgDMvUaaGnA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=f7IdgyKtn90A:10 a=rhJc5-LppCAA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gQcMVamqm3wCPoSYhaRC:22 a=ModqzXLkJJ0tFyq98apW:22 a=MYBQy2Gi1v7x4d3D7x0A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_06,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: orgsafe
X-Proofpoint-Spam-Details: rule=outbound_safe policy=outbound score=0
 spamscore=0 priorityscore=1501 clxscore=1011 lowpriorityscore=0 adultscore=0
 impostorscore=0 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=orgsafe scancount=1 engine=8.22.0-2609040000
 definitions=main-2609250006

On Thu, 24 Sep 2026, at 13:59, Ard Biesheuvel wrote:
> On Thu, 24 Sep 2026, at 13:36, Luis Claudio R. Goncalves wrote:
>> In this case, corroborating with Sashiko findings, it is necessary to
>> have a way to override that default in kernels with PREEMPT_RT enabled.
>> To be used where this is required for firmware updates.
>
> Indeed.

Agreed -- and thanks Luis and Steve for catching the fwupd impact.

For v3 I'll make the option a negatable flag: "nostatfs" skips
QueryVariableInfo() (and remains the default on PREEMPT_RT), while
"statfs" forces reporting back on. So on an RT kernel, mounting efivarfs
with -o statfs restores the free-space reporting that fwupd needs for
KEK/DB/DBX updates, while the default still avoids the preempt-disabled
firmware call.

I'll send v3 with that change shortly.

Thanks,
Prashant
