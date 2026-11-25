Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.195.97
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795624087;
	b=1TnaUdrMLyC8utGUnPgS6tkPES7wREhQrNij4Ll9DKleTyO3cURglyyoC7GCsAAopSLw
	 nWRuIwOWoPf/hyyFI6Xmwd2Q7S76I5T7FR1T/mzce5a53eRJTB7g1RuUGj2da4Po47zp+
	 pqLo2rxiRcA3HwtSawal44UnR1Pvi1uEA0E0/99o0vpabc6hND8QKxkb4qr1nTUZuEevP
	 DeI/Pxu7Ag2ra1iAjDXALO3I6ZZYz/1/YhIv7NRdUDXRDIGTb1QOG7W0L2csvmB0rhn8n
	 HFcK0rM7G4HlJswzlNM9wGGHrGyqpqjXiZhOBGILX5IAtvUCXwejFcfiw/iwO9oIbrg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624087;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 Content-Transfer-Encoding:Content-Type:Date:Message-Id:Subject:From:
	 To:Cc:X-Mailer:References:In-Reply-To:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=etV7w6McVU4IkyvSR1MbS3GvzqUUoDoXyhVUKvZEZQ0=;
	b=2y72EYTGb0aVku/C+OIT2ZvYQuC310iO5NArhjQigBZTmljfz1dvHyKWz2QzPoF5theD
	 ++NJdr4X4PtDIELwnIxmalvMq584OTfXHUs6JEoYr+M/3pEoh0lovDwwG4RjzrTWlQBHE
	 P2KE4yRjxeS2f5o3SBC9YG4Km7PXnp+5fNiP/cePU4cXaBe5ND770GuV1fnrmydu5pMXx
	 ir3waklloZB/DOCZvQa9NbPURy8IYm929YtiVTkIMlLvbD3Jc50BV40g5/EoExt3toLL8
	 7jKkKIv6o406gpAn8v35L+C6gNj2zJEH55Y3CC6ghZvbZ7rVuhpgIawNPokh8MQV71g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=garyguo.net;
	spf=pass smtp.mailfrom=garyguo.net;
	dkim=pass header.d=garyguo.net header.i=@garyguo.net header.a=rsa-sha256 header.s=selector1 header.b=tVRKWPxs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.195.97
Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020097.outbound.protection.outlook.com [52.101.195.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD81606A327;
	Wed, 25 Nov 2026 16:28:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5DD81606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=garyguo.net header.i=@garyguo.net header.a=rsa-sha256 header.s=selector1 header.b=tVRKWPxs
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ha1iZpZvU0UvAZlA0LGSw04MVNvqWTqomTPr1ZI8HiXBjMhmbQdjBX4AHTTPqBybf4X1nV2zT8bgsB8QcAcaEPeon+r4lv8GszAfqw4TZ1NYaVEgJ/DHmXjbSFn+p5M9tbbF8pvJMQp/vxfo1QRiYmisiKgEy9MxQCJhSlKY3lN93nT8y2ObMsTcfJqMDUHQOF1uUekRhzolidCcMXLMzk3nClkNjAUu2gMktGh27Lt7qODc4207WZUl4JfejbDNe3IiFHf1bHwzXFRRG9Xg/PDRmSkj37kw2czgojOJ5WDOKehFAYcN7dhcuHSFpoD04aiYs17OosYq5hTWExAgdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=etV7w6McVU4IkyvSR1MbS3GvzqUUoDoXyhVUKvZEZQ0=;
 b=iN4fTo/BIhIyALnk64XGac9fvKPMdKXwvhOZ+MsXEg0ytGbBg3t7mpts8oOIHr7bZzK4SL96gFvY9tY3a8wMYr3CnYyV0k8qaHJrrNYeDU3YTIejjRU4Mryg+leayu2EZVLpfxs/Hbm+OKhAz0nYZy279s24oPnXxjQMRUIpJ8PO+hfUq/FSKykfD9sI3zBI//WhmSM6PghJxGCFOGi+jLmrppZPQ4TWk7UkON21S0qR8TKG3U2SJjAMBjfYACEe0rafKuMy75L/fSyKLA/p1xkmmiVY1+uVTIQLeXKqY7xtjSmWYqdQ9wAerTeYhF1CfUGud71yy4v7+EszbvM9CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=etV7w6McVU4IkyvSR1MbS3GvzqUUoDoXyhVUKvZEZQ0=;
 b=tVRKWPxsYNS0b7XyHyEJiZxCMgHdb9DBwZwvTn8tfu0gm1XcqeisvaPh0IB4fnaIACSiojPJwkCPBLdh+uh0dWEPU9zDefg5ERQ3TADUVyMUTo1XGA2YPxEGnnIydZEhr3gR3G6mrSv1PLWOX7tFMOHrDKpJGzP5y7UQ2wOzfnU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1cb::9)
 by LO8P265MB7671.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:3ca::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.4; Wed, 25 Nov
 2026 16:28:04 +0000
Received: from CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM
 ([fe80::55f6:f98b:7fad:c6e3]) by CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM
 ([fe80::55f6:f98b:7fad:c6e3%2]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 16:28:04 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 25 Nov 2026 16:28:02 +0000
Message-Id: <DN4FM3TBOJ9T.2QOOL77P5HETO@garyguo.net>
Subject: Re: [RFC PATCH v2 00/30] unwind: Minimal DWARF CFI unwinding for
 user and kernel space
From: "Gary Guo" <gary@garyguo.net>
To: "Ian Rogers" <irogers@google.com>, <linux-kernel@vger.kernel.org>,
 <linux-trace-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Cc: <jpoimboe@kernel.org>, <rostedt@goodmis.org>, <peterz@infradead.org>,
 <mingo@redhat.com>, <tglx@kernel.org>, <bp@alien8.de>,
 <dave.hansen@linux.intel.com>, <x86@kernel.org>, <catalin.marinas@arm.com>,
 <will@kernel.org>, <mark.rutland@arm.com>,
 <linux-arm-kernel@lists.infradead.org>, <pjw@kernel.org>,
 <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>,
 <linux-riscv@lists.infradead.org>, <acme@kernel.org>,
 <namhyung@kernel.org>, <linux-perf-users@vger.kernel.org>,
 <mhiramat@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
 <andrii@kernel.org>, <bpf@vger.kernel.org>, <nathan@kernel.org>,
 <llvm@lists.linux.dev>, <nsc@kernel.org>, <linux-kbuild@vger.kernel.org>,
 <ojeda@kernel.org>, <rust-for-linux@vger.kernel.org>, <ardb@kernel.org>,
 <linux-efi@vger.kernel.org>, <maz@kernel.org>, <oupton@kernel.org>,
 <kvmarm@lists.linux.dev>, <shuah@kernel.org>,
 <linux-kselftest@vger.kernel.org>, <indu.bhagat@oracle.com>,
 <jremus@linux.ibm.com>, <wnliu@google.com>, <dylanbhatch@google.com>
X-Mailer: aerc 0.22.0
References: <20261125061523.1540234-1-irogers@google.com>
In-Reply-To: <20261125061523.1540234-1-irogers@google.com>
X-ClientProxiedBy: LO4P265CA0261.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::14) To CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:400:1cb::9)
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP265MB6051:EE_|LO8P265MB7671:EE_
X-MS-Office365-Filtering-Correlation-Id: 93a54ba0-c3e9-4a79-2c32-08df4b111461
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|23010399003|376014|10070799003|366016|261009223027099003|18002099003|22082099003|56012099006|261028144727099003|261022113327099003|261022075727099003|261022105027099003|261026140227099003|261026121527099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	4pEqPffHiIuHgwKDpWn0vgwlvV+li/4UKkd8XhWfSs6FiCqlSZHm2qMrxAN33Ao0pjeuZcanPTs4urwLEn+8+iYXhvEUSwjI8pAX8njmDkmwzkkCjRRHj3KB1dsJGO/pHe9koiI1f2bzgkz1HdMYzNQw0rCs+MO7KZT3NL9YdW9OACcKcn7jc5TWBPsWHu/OLhCmA42tv2vw2lKajqHmfzf3xHE9G2f4S0no2poSPJbePyp7TNUvkj1t4ytj2qzz5Pscgnfp1kMMdoMRV3eEVc7Cl/oSiXgABtF4kIuDUxtthnGaRrWs9Z1e2DzR19XjuoBmw1X0I47LWZk2bxm4YPfibFqsWjGx5ucRCTWKz/vX936zj4WH2RQ8tcOPKFAOSlbYBtgUbdlFFgji3uPQfq2ZtXp43b/aGJgkgBfwsztggidzqoaXkjFjTw2RF6ZIkRcC54Z9xm31YjS3uD1IfXHBQs3ovWiCH2SPoSu98NRXnZQLRRLbWNEnz/gVBUdt5xJac34a0FplOngbLaSQyUR8Hf8EbhxzgLg1nPc1YWAzPkCEVkW7Yn0hPHJL64eeIDIksvRg4080GTawHF5IqsQ9W6f1oBW2mixJRu+7NVa7SCyfKxxykLiYz6TLJoh/OlqBeM539LNfXhw7NXP24l3n7T6Qmf1StckpPG/fey0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(23010399003)(376014)(10070799003)(366016)(261009223027099003)(18002099003)(22082099003)(56012099006)(261028144727099003)(261022113327099003)(261022075727099003)(261022105027099003)(261026140227099003)(261026121527099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NVczU2p1NUxqVzg1QlRxN0JiSjUwN1g5a0Z0WUxoS3BvMUxZTE1OMStnd0Z5?=
 =?utf-8?B?Z1RtaWFaZjNJMWxHRmR5QS90MkpFSUMxL2w5TVh5YU9kSWpxeVc5ZHlXVG5m?=
 =?utf-8?B?M2tMU1RRT0ZRR3hocEtiWWU3QlVFWGp3K1VLaXRRZmx4OGNhOFBOY295OFdO?=
 =?utf-8?B?MStlZkdFUG5jVnprTVhQTU5uZjdRR2JOQlBiN2tvYytucEZFN0UvTTdCNCty?=
 =?utf-8?B?Y2tsVFFQWnprbXN3bXJMSFNEZ2ErdC9haFJNWlkyS0kvdXRqWXQ1MTlBNUI0?=
 =?utf-8?B?UVdZL2d5VmRRS2cxSGYxcHI0dVU4NTVuVE45Z1lpQTNjMkZvSndNSU9ZdWdO?=
 =?utf-8?B?VUZ1QjF2U21uMlhPS3BmTXBxaERnK0hxa3R4Q0MvQ29KbGQrTWxVY2kzc0gz?=
 =?utf-8?B?VGN0Z1dwa092dG05ei9uSkF1Ky9mQko1UUlzSlIvdnRuRFJqUkVqdVF4ZFk2?=
 =?utf-8?B?cnBPZ1c3ZjBJM0J3UUFpdVFCUERTb2Uya1Y3YzlNWlc0R3kyUnJjd01TWi8v?=
 =?utf-8?B?TzVSMUo2aFZZKzRCdDlBY045RUx1WUpIY05ETUt4U2dTcUI3R0lvUmVCeS8r?=
 =?utf-8?B?ZXpTQVVIa3gxTzFnUUtDZmc2K3JYSXN0cEN3VEFGdVlObmZvYmFVMDBuc0hB?=
 =?utf-8?B?cHBkcFh5dnNlOUN5eWxTcGhWOHJSeXc4YlcvdDRJZHM5NEdlMlE3YlZCQ3Vt?=
 =?utf-8?B?Tjc4a2paUnJFR005MW1CR0tZeHlOeTdhRG83K1JhS2FMOURPa0pFbG44VHBU?=
 =?utf-8?B?akRPZ3FVcmd6d2RhM0FpSlpsWkFEb25nYVpaUG5zV3M5ZHNZbEVzSkJtbXFO?=
 =?utf-8?B?aGNoTE4xdlI1RndlRDYvZ3ZTbjZtMnN2cktmeFd5ZVN6NkJ3U2o4UFFHU1F3?=
 =?utf-8?B?MCtkWDBxcWxoZ3Y2dVQ0MXVEblZGN1NUWW1aS09sV28xTmJrOGpYZCtaMnEz?=
 =?utf-8?B?WmQ3SVM3VDR4L2RadXBqZWUwQ21RQ1d5QTNCaUdoZ09RSm5MYWg2N3d1dDNx?=
 =?utf-8?B?TzJCZnJoaWw1dUxJRjE1UG1PNUw4VWtqQmxHQXdkSGc1ZGREcThIUjV3YWZE?=
 =?utf-8?B?OWtVcUxLVGdnM3hiMmJDdHhCSjNpVVUwV0JTMmFkUTB6aG00akRGS0cvT2pR?=
 =?utf-8?B?VW5WV21uckJkWENOVUZwSlZpNUJyU3ZtWXMwR3cvTHBuSGJvK2Y2YmR1Qnhp?=
 =?utf-8?B?SWUraGYwaXFxc1FRVGNTdXlLWnh6ZE81V044NGc0dC95UEFmTms1ZzB1cHVs?=
 =?utf-8?B?QlVaOFkyZDFPajJpcEFBQitZRzlEOFNiYW4vTTNKaTgzdXZWR0lMRC9ZbUxP?=
 =?utf-8?B?dHlTZUpOMDk2V1ZGL0FUYVVJTFFPQ3ZUKzFxKzF1ZU9Kak15Z0JrRTIyOEFK?=
 =?utf-8?B?MGN5ejd4TXBkYmpFR3dCcFZ1ZXlSNjQ3cVlibStza0h1SGdaYzMxbFBGQnk3?=
 =?utf-8?B?c3pQNnoveXVYalczdktCUjdldUJQdllodjMwbXhnd1l3YXhpRHpRdXRXQkNh?=
 =?utf-8?B?bEthSUlkWGxsTWI3SnFFakZJQ2gxR3JUOFNlckhqRXlIdDVHdlFsVXVESVB1?=
 =?utf-8?B?N2ZTamNPSWlEZzhEV25Hc2Y0LzRYWVZxRXRoN1F3cjcvbTlPak9OSHNvZElB?=
 =?utf-8?B?dkRSVnJTRysxRmJ1U1E0Ty9ROUozZFlaZzJNUk5wajBPNm1RaURLRG5ZQWhp?=
 =?utf-8?B?WXVhRThnQmZTQnBzc1dTNmpHaUgwWGZuQ01TMklsRmdQNGdVczI3V3dxNTk3?=
 =?utf-8?B?Q1M1UDZSVzBEOEJjK1l6enFHQmdQOTV5WXdLd2R6MUVnNnAzTnlhcTV2TXBG?=
 =?utf-8?B?eDVZbXBGMXo1a1UrWVZXSjU2Q0NCRjI5ZzFTV0lWZ2F4TkFCQnJGZWZpNDMv?=
 =?utf-8?B?VU5OMDVKZ0M0eU9IWWlTcS9RNzBkV0k2aUtIT0RVQ1VscTRialRudjdGSXEr?=
 =?utf-8?B?V1VobW9WRndjV0pVYXJqRXlueEpVelc3SVM3aGdFQzdMNzQwaVNjWEpMTlhp?=
 =?utf-8?B?Z2xtSmZkNis5V3VCY09GOVRaQ05md1EwbW9neGVpdjdRWmNJck5rVURGRDU0?=
 =?utf-8?B?U1hma2UvdlJvcVJLbTNBbHdzcjNuSXNhZkh3QUxLd1FYQitYOUxVTlRWeEUw?=
 =?utf-8?B?VGxaRGZFd2xMelcxMUFVdS8rdllEZFYwbDEwK2ZwNVpTWEp1UmxtQVJrYXpK?=
 =?utf-8?B?dlJIRVYzTC92Tm93N1Bzc202OCtvQjN5eTB0U2FQRkpHTTd0QTl3Rjl3UmxT?=
 =?utf-8?B?M1pHM3l2cDVwUUFwVkdJUnh0Wnk3aVJUVFZSekZqeGphbzRRWWNhR3A1ZlNo?=
 =?utf-8?B?TC80b1E2Tll0VmhZV1VzaVBTRnZjcGUrZTZEVDBHUzF2OWtISmFxQT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 93a54ba0-c3e9-4a79-2c32-08df4b111461
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 16:28:03.9540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zfLPUsOGfR/d8B9Jc7ISsOR1doPTigyD8v8xZJajv77s4IRWJaS+Ul7s/UjjTU/DZ1mNYwogycPZR6w7HBNHBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO8P265MB7671

On Wed Nov 25, 2026 at 6:14 AM GMT, Ian Rogers wrote:
> Overview
> =3D=3D=3D=3D=3D=3D=3D=3D
>
> This RFC v2 series introduces Minimal DWARF Call Frame Information (CFI)
> stack unwinding in the Linux kernel for both user-space deferred
> callchains (unwind_user / PERF_RECORD_CALLCHAIN_DEFERRED) and
> kernel-space stack traces (stacktrace.h / HAVE_RELIABLE_STACKTRACE)
> across x86-64, ARM64, and RISC-V, paired with an optional standalone C
> build-time .eh_frame minifier (scripts/min_eh_frame.c).
>
> It enables reliable stack unwinding across kernel and user-space
> binaries compiled with or without frame pointers (-fomit-frame-pointer),
> without introducing duplicate .sframe sections in user-space ELF files
> or requiring new compiler, assembler, or dynamic-loader formats.
>

Hi Ian,

I'm a big fan of using DWARF. I haven't got the time to look into the detai=
ls,
but minifying the info so only IP/CFA is kept sounds like a reasonable appr=
oach.

A quick question: how do you plan to get this working on 32-bit ARM which h=
as
its own EHABI?

Best,
Gary
