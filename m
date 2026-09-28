Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D5434B40F;
	Mon, 28 Sep 2026 20:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.147.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790626969; cv=fail; b=nwHj7gWoktBsvC+yVxScmgpaDWnyNwnZRBceMuD9QYrMDzNO2lMTapuBKek75/czAe/dsVeS6qx3nrZgNwnb1QoiNergryEeUDVuCH2Cit933iWQvkAnUu+YDV0OHDBBeHSvf7goAaMegq/JwJexgMYGGwTf3gPDioZdDWNhBrk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790626969; c=relaxed/simple;
	bh=MAKA9E12dRIo5RC6MN7exBB3i8jqpl8gO3hyOVcCWM8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YHBIKYUDOwS89TPnaghot7NFDe/6ye+iVpL8cAI1Yv2t9q+Qx6fBlP9GoecooIZZkK2GKKVjAUfcTXUCptOpCId/dSZ/oQlfW5bqF091g/9hxcPKTjKZSiD2RjAe2LL6OnW0Fe7SLuUrZ+N7rOJScmMlvoVDJe+8BHtrbXPvnnU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=juniper.net; spf=fail smtp.mailfrom=junipernetworks.onmicrosoft.com; dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b=abh4RIxb; dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b=PvCvGFiz; arc=fail smtp.client-ip=148.163.147.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=juniper.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=junipernetworks.onmicrosoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b="abh4RIxb";
	dkim=pass (2048-bit key) header.d=juniper.net header.i=@juniper.net header.b="PvCvGFiz"
Received: from pps.filterd (m0150241.ppops.net [127.0.0.1])
	by mx0a-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SIuUqY2284744;
	Mon, 28 Sep 2026 20:21:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=jnprhpepp0429;
	 bh=1sHp6dk0VMwrxGrx+Gk1giN9rGk7oFPjP8DVFUk0Q+Q=; b=abh4RIxbGL2s
	kA0sa9gA3PFrnXNavb0e35/1cjrvTgOR+mmAAvEayYYnfykq62C1jw+9twdrqJ+3
	gW3b8SO2qzCYi9XxrpUdHk81dO+IkiSRO+SG9TMt+9OaY3D+FdvGBU4wEipBRnhV
	GU/JM3VG80OycPUYGgbERwB2oY+GohcF20uIxUG3TwIkfMjnBDt8HPh+GZ3pCpwb
	f3RniQUknJGPneq0dorfu8eH+1HhB0RMswV3dM1wwAz9CTkRyKg3klQ6cO5y0ZCR
	dfzZhnAbhQpMxPstY28QSQYjj5/sMVOyWVQPacWSR24n8b2KpmXUuzkIXfUQmbIf
	tUUhsm15wQ==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012030.outbound.protection.outlook.com [52.101.53.30])
	by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 4gywy6s0r3-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 20:21:32 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fgjhoJFTlk5YjT+Q8elUqmRSHEddO3kJl1PTQjsy4BjiobEOWWbKuYcGTXoeaG7lPlYpQur1gI5BB3dZLn4r4LvLeYB29a1MdFykLLKKmfczvMd/aEWU/QYm9JvY9CotY8DYrKUdl9g+cXw4r/VSe8ImYLgdFtowQZVYC3ADCpIif5lz0iX7xMtFoOI/OkCA96KZtw+4FYfn8bCNPKTUEswmrsJLj7didqBNb65jS/Xf/oQ3TRrU0DIXTXtfDliHdFaPOuJzn1c5p6fDySG9/6yyzJcYWj/UEafXDPM4cyA+BqA8vKV0yrgGHBy8JVDRQiE6mzpsCmLkdYshKtRv/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=1sHp6dk0VMwrxGrx+Gk1giN9rGk7oFPjP8DVFUk0Q+Q=;
 b=mIUat63rtD0ncxd21Sk4HnkD+7xbJI4nM0kro2aucYvYYIVvumGem2bo1tg3vA4pacmMxp6dGsd1E3BQfaSWSCx15OqEFZNhQuDSb8kBeMsy9YFcASZzTvwSvqxiroEuNY8ycUXdluTjP1NqlEgSRknJGd4H+qfQaHC1ugsTj9n/oPVrlsDoiWHUUJLs8RkoKaldzHri6VqOBzUG7is8obogWawT0BEk1P9+vcUUtQZy5rlSulqafqC2Y14dp45yGCqk4Qcgiqx5e7hVmPhxu64Rvn9h2E4odQZL0UvLHa3rcZhJTmeHLkXhE8wW/AxGXszPvjZukOWBTsZbbnjBTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 66.129.239.19) smtp.rcpttodomain=debian.org
 smtp.mailfrom=ebf951f79306.juniper.net; dmarc=fail (p=reject sp=reject
 pct=100) action=oreject header.from=juniper.net; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1sHp6dk0VMwrxGrx+Gk1giN9rGk7oFPjP8DVFUk0Q+Q=;
 b=PvCvGFizgInp8JG8o/YdWgtp5Hg4w7LP52VMfOvcOARfrYfsDeLBKJKKLRkog0dSMh0WnjT0BtcdwLrqnup0SK5vdsC9s5NR5Nzv1k6TB6Vq5BR1FWKBVLq7053sIFxj7pagnNDp1Iw2whDxpVGX8KW8GEmSWkdg6DccztNomSdi13auc+DvdrSKW/62UQS6if2jAvDvNaq8YJSLjwVY/vaOopym4Fmrqf29B1v8mU07m34WZWH6TTgjaEv4wCyiHi/TT6cDuabf+q2/GZ6337pWXHghPBpJlHpvLhER1wPUJmp5/TSgSu8cCQN7tyzENGEprsHhPQQr/4pWNhsFzQ==
Received: from SJ0PR03CA0102.namprd03.prod.outlook.com (2603:10b6:a03:333::17)
 by PH0PR05MB9939.namprd05.prod.outlook.com (2603:10b6:510:29f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Mon, 28 Sep
 2026 20:21:28 +0000
Received: from CO1PEPF00012E5F.namprd05.prod.outlook.com
 (2603:10b6:a03:333:cafe::13) by SJ0PR03CA0102.outlook.office365.com
 (2603:10b6:a03:333::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.15 via Frontend Transport; Mon,
 28 Sep 2026 20:21:28 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=none (sender IP
 is 66.129.239.19) smtp.mailfrom=ebf951f79306.juniper.net; dkim=none (message
 not signed) header.d=none;dmarc=fail action=oreject header.from=juniper.net;
Received-SPF: None (protection.outlook.com: ebf951f79306.juniper.net does not
 designate permitted sender hosts)
Received: from juniper.net (66.129.239.19) by
 CO1PEPF00012E5F.mail.protection.outlook.com (10.167.249.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Mon, 28 Sep 2026 20:21:27 +0000
Received: from p-exchbe-eqx-04.jnpr.net (10.104.9.87) by
 p-exchfe-eqx-04.jnpr.net (10.104.9.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 28 Sep 2026 13:21:27 -0700
Received: from p-exchbe-eqx-03.jnpr.net (10.104.9.86) by
 p-exchbe-eqx-04.jnpr.net (10.104.9.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 28 Sep 2026 13:21:26 -0700
Received: from ebf951f79306.juniper.net (10.104.20.6) by
 p-exchbe-eqx-03.jnpr.net (10.104.9.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 28 Sep 2026 13:21:26 -0700
Received: by ebf951f79306.juniper.net (Postfix, from userid 14867)
	id A854213308F2; Mon, 28 Sep 2026 13:21:26 -0700 (PDT)
From: Prashant Singh <singhpra@juniper.net>
To: <ardb@kernel.org>, <jk@ozlabs.org>
CC: Prashant Singh <singhpra@juniper.net>,
        Sebastian Andrzej Siewior
	<bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        "Steven
 Rostedt" <rostedt@goodmis.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan
	<skhan@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Luis
 Claudio R . Goncalves" <lgoncalv@redhat.com>,
        Steve McIntyre
	<93sam@debian.org>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-rt-devel@lists.linux.dev>
Subject: Re: [PATCH v3] efivarfs: add nostatfs mount option to skip QueryVariableInfo()
Date: Mon, 28 Sep 2026 13:21:11 -0700
Message-ID: <20260928202111.70491-1-singhpra@juniper.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <17ae71e4-c044-4354-938e-3e8021615e6d@app.fastmail.com>
References: <20260925113145.7396-1-singhpra@juniper.net> <17ae71e4-c044-4354-938e-3e8021615e6d@app.fastmail.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E5F:EE_|PH0PR05MB9939:EE_
X-MS-Office365-Filtering-Correlation-Id: ee23aa62-016b-42cb-7347-08df1d9e1360
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35950700016|376014|1800799024|7416014|82310400026|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ef5+X6vE13zBFof+heeGlb95Fatl8Ubun9E62AieUhva5sKyI7BTz6nonyoXJ/t+nXb1p19j1tCBp0JNT+Qnw5A3dUJtXXIi7gSTU89s7fvTTvscWk7cUkrd+Q5OXlQ/EX73AlBqwiFHxUCS3H/4oUGpxrdalINaY6N0aobgxIC+wbYGWD3FqMw4XpuOczli/gM3Y+u8Lad7ekDzJVvbRBiTyI4/tY4WWaXIuzhEW14v3XVX9YtL1oC417eEmJhl8WWbhaRgiZkMBYOrILOkXoSV4ChdnQYAQOiEzaz5Zm3dQUO0JKYu9wiuvB7JohYxiH+Fa8f8J6FyfSDx8miKeJUakBfTt8NWVOQbGUKkfUSFuxoPJ9qSbH9aIq5tSkxmxVWq6z4x4M6/72e3AQMfsNvB+ZedBDye0l9VgKqEAX410o1+P221Sb0Qme8xb0dIVs7A6LxiYqijdFVo69rcoLkJhMkBWXy2ZKZbLl2QI9i6PlTsvMkFusZypDCYb1sUXLV8p5++7WXB5h03G1B95Q4ZTnaDRMTLSL3xz+cVAfOV/2VvkfN0iybYhHonZAMmRip09YiTDSn8HPzuGRoUMZ2nfovHV7N5eJntNdRQ7IpwFHXr0d8R3ShaBs4hJaz5eny6jPQlJEWP2ty75PIjuvUeuwgx3X/ugce2+JvDKjrN9/skDik4UQNpmhI0P/RROfnP0dyO/43rnU4foBX8+Q==
X-Forefront-Antispam-Report:
	CIP:66.129.239.19;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:juniper.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35950700016)(376014)(1800799024)(7416014)(82310400026)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LsfhsnJX13OWswdRPYUdsugFZuCGffbIGWiZHW/nzLte5Q/uccOBuFCLfOZ6iCY7m0Gdk4HEwYrRrZ+BA/ykCRMcK/brXr36Qsv0GWKSNCEPGJTRtavCoRWrEjMaSqqvojNSsuekHf51W5kX7e47mR3nGx/udITpfcX/LUmDi7EVL9IU94zBgOlxJSZGKslpxgDNZS1JrzeyEUHwLrQ6vpMAtYW8jvs8iPJI1zXM3Q+xfjmcicJMeeCzcWSZdNW4XGJYmyQeQv72b5qoUxRe/9Aicgmo06E0vhRYMV/FR0EWi3dnr0vWQL/uflm3sBmNRbPlMZ96m4p4XpJNfTR5uHEfR/I8oAI1qyZctgPJzw+Fo74KhS/0xhRNAYCZtP1peyctEvAYxJ5W/p0M/HBIxwcR7DChDWE7g7Asi+ze5u1UEaYGD7LoD4WrLWvh13vv
X-Exchange-RoutingPolicyChecked:
	gqnMp1+g7WE+VMbzd8epPBW1C776EgCD2ejSupcZBDgPYAT9cDp6+AGJw4VYk4x7v0/Iiut2+EjnjOphvS0jJcF9Dmq3ZGcUg4Im6XODm8jtIdsZ7PeSOaM4mSAI/FEOfpZl9Ha14kdOwMDYdFtnAgtzpWgg97nNVXmoW5/Ixo+EUvYSNDVIU8zHM6yOlWbhknJTgNXXDu0sS2jLx34WhiT+Ai/CKpaeuklHgeCNX12JCirhP1w1vPJbJrgB0Eggved2nQqF0vxKMlBSbTv1yed5OOPUZhNUPGCQYkGktogiNHyfrDpf3wBH8Fd1aksVPYScjOqCIA0CVDcns4175Q==
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2026 20:21:27.6461
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee23aa62-016b-42cb-7347-08df1d9e1360
X-MS-Exchange-CrossTenant-Id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bea78b3c-4cdb-4130-854a-1d193232e5f4;Ip=[66.129.239.19];Helo=[juniper.net]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E5F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR05MB9939
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA4MCBTYWx0ZWRfXxnAw+M1sSH21
 tkbsXz1M912VJE7nGls9XvYKvvay5h4PgvDqv1U+NeqBANytScnKRXSlNNoibP55ReO41mtE2X7
 UdhpevqsYPeu088NBFtRlTc6i33jefVxyJ0PfPJjGV36av4ehB2sVoEk2nEhcc6wIwJHHTqjfQe
 ZppsvDXdOAdYtRzoQlwep8EhaITdKPURL7bB/qGReCpgARqKjZMSMe7CqSxo1Dthphss8RizvZg
 CFqoW/uBUe046nFmC2VajNmqhj2VcNlQ5NZwqzKCR5dGr7nVOf3j/Rc/gH+n/8IJ6DPfuLCgj6J
 rZA15JpYAsAD/gRLOIZK4hTIcr7V++62bNmyI3jM40g+Xua2yaOpTs7RCyuqPABm67yxF41FEdT
 gfjXVwX68nfPj1QdYzbgxvfL7rOpH/X+hR5jMCCP9w0EEmqTPSfJP4RGKC9mqrlr38wbHcgZByW
 85Rr6KdiVXJGcO2hyFA==
X-Authority-Analysis: v=2.4 cv=cPZ1IVeN c=1 sm=1 tr=0 ts=6abacc4c cx=c_pps
 a=bYEXqv4PBJnnT5HxTb2zpg==:117 a=SKdRtqzh2DBFgDMvUaaGnA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=f7IdgyKtn90A:10 a=rhJc5-LppCAA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gQcMVamqm3wCPoSYhaRC:22 a=_ZmgHqWwjZUDpi_pur5s:22 a=4phcSvNbi574vPAfy4cA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA4MCBTYWx0ZWRfX0032Ai5O4d0v
 R8xmB3erdI83nSLcGMC2+hR+r1hodPRsItUGj+vAGxte6WcmGSQQm2YIQdzWHYOhH0q7/iWxAm3
 1umEu4b7Aw8ad5ul7Z/vdmUkcrTGEFI=
X-Proofpoint-ORIG-GUID: t7FRO7Rx90DctX-aiDSu-OSZSbrI4HGo
X-Proofpoint-GUID: t7FRO7Rx90DctX-aiDSu-OSZSbrI4HGo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_05,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: orgsafe
X-Proofpoint-Spam-Details: rule=outbound_safe policy=outbound score=0
 spamscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 clxscore=1015 bulkscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=orgsafe scancount=1 engine=8.22.0-2609040000
 definitions=main-2609280080

Hi Ard,

Thanks for the review. v4 addresses all three points:

On Fri, 25 Sep 2026, at 14:14, Ard Biesheuvel wrote:
> > - Read/write nostatfs with READ_ONCE()/WRITE_ONCE(): statfs() reads it
> >   without s_umount while remount can update it.
>
> Why? There is no memory ordering or tearing issue here, but only a
> fundamental race where a remount and a statfs() might occur at the
> same time.

That's right -- a concurrent remount and statfs() is the only case, and
it's benign (no ordering or tearing for a bool). I've dropped that
changelog bullet. I kept READ_ONCE()/WRITE_ONCE() only to mark the
intentional unlocked access for KCSAN, but I'm happy to drop them if you'd
prefer.

> > +	if (opts->nostatfs)
> > +		seq_puts(m, ",nostatfs");
> > +	else if (IS_ENABLED(CONFIG_PREEMPT_RT))
> > +		seq_puts(m, ",statfs");
>
> Please drop this else branch - it should be sufficient for the 'nostatfs'
> to disappear from the mount options to understand what is going on.

Dropped in v4. Only ",nostatfs" is shown; its absence means reporting is on.

> > +	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
> > +		sfi->mount_opts.uid = old->mount_opts.uid;
> > +		sfi->mount_opts.gid = old->mount_opts.gid;
>
> Why do we need this? Does remount otherwise forget its options? Does this
> mean that before this patch, remounting with only a different gid would
> reset the uid specified at mount time to the default? If so, please fix
> that in a separate (preceding) patch.

No reset bug. efivarfs_reconfigure() only writes nostatfs back to the live
sb, never uid/gid, so a remount leaves uid/gid at their mount-time values
(verified on a PREEMPT_RT box: uid=1000 survives "remount,gid=2000", gid
ignored). The uid/gid copies were therefore dead code -- removed. The
branch now only preserves nostatfs, the one option remount can actually
change.

Thanks,
Prashant
