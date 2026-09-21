Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013020.outbound.protection.outlook.com [52.101.83.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9E54534A8;
	Mon, 21 Sep 2026 08:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.20
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789980638; cv=fail; b=IAgx7tZeCeHNlFO/Z4DLKibEB1CB7UoycgrTszxIdOHYGPUGpFDQctwC72O49DtU1s4F18evfmCfAnmMRMCJTd102Ama5UcFrYKuz7sZjl2gyZa7GXV4nuXrbKCta/TQuC52zZyO2/xeDVMeva4UyaiiU6qAy9QeZcyKesZ5HQo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789980638; c=relaxed/simple;
	bh=9dMBFvoLh4bq7FadaeZTRfcJtFRaV45mvVvRMf0L4yI=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=u/iHM7ioFRB5AaC1Ii4LOXtuhZNpY7FfdMhUNITG/3Q0vZ7rc4LO9URzatyhRlw+6api7E4a298lY7Ow9cXkmQl0eNX/e79EGyJdNwUyNF28XP5WRV7s5WI63RloXbkBfxb2RsHsC/6P67tW8pfSUZiYliqAPNpcjANRpJGbSYA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jnDfn3MF; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jnDfn3MF; arc=fail smtp.client-ip=52.101.83.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jnDfn3MF";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jnDfn3MF"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=gLhoEf1gOcGgyuDA3Q/fKc9D5DsoND2g2lbDAJYY+3fZzGiFnjFZGZgIx72amFomcUADI3NFSzou9t5kALS8mwKfCe8ZisWFDYlsCqg66aK7rqah7LjOyHGHt3w6dSz7bKdtMWeiFKaiX9mmZpG78ji5IXFQ0aX6WTWvz7uhHibCUbDoiMPK0UyjBBb6OgpmNG+lqUtUWIjI86N2DjtxmlBApzq3kZzAfYTwGDX+jF5Vkc/ZMuiDEBSPhWOXlLvC+pzMAJoXqjoZBOwKgu5gaVBYo6LI5Ae7n8F6+G6ow1t1K9lAb6x1DCpANWQgShqUJuozHc6B4ecU0YPF4I3mzw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2AZuT1/OY/48+OQVf5Xy06C7nyJ28b5XEaqiFJ136wo=;
 b=ltcH/8xtodSzMEH+4JDKG/0mjO/kvM9cKR34dLibNGIVpjYJxXWzsv149amZMLX5xfxz9srjTsTYg79vGvHijLfSKIJB8w5HbzEjJL3SU/zsvOP6C7RweF2VqWmDa8521ooPlloYU8l6AYWoGORSOHS+neJVZvNi3lJcvIjEp4lBS5FQvbJ9rPtt8RA0999wBjyMHsmOHAfqoH9oe8aT11vMpkTT1tDDtD7bJrnE3FLKYK0X/HSd/NgyHwGOEpLyUyVCZ6UjHrH3zgkyczKXJjraQYN3hLEv7lp9J0TMdVs/iwawcnMRioqFxb4hKfqLJWzIn+C9FSuRZrL1fU2dkw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2AZuT1/OY/48+OQVf5Xy06C7nyJ28b5XEaqiFJ136wo=;
 b=jnDfn3MFLUgI9ZKXNmy1bTpHBnw9YlX/CX+V37RklZe26yiCu3vcv4qqBFQwMMhLZsZnqMpEvXfTtkAd3kFQrvNaO0/LEU2c47CqsZp8o6B4/p3MPWx9aV2qbwD1eE+vpeM+72auZvNlOM22n2WWsJ81Y07fBRxCjnhF57jRPIM=
Received: from AM9P192CA0004.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::9)
 by DB4PR08MB8078.eurprd08.prod.outlook.com (2603:10a6:10:386::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.13; Mon, 21 Sep
 2026 08:50:24 +0000
Received: from DB5PEPF00014B97.eurprd02.prod.outlook.com
 (2603:10a6:20b:21d:cafe::23) by AM9P192CA0004.outlook.office365.com
 (2603:10a6:20b:21d::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.16 via Frontend Transport; Mon,
 21 Sep 2026 08:50:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B97.mail.protection.outlook.com (10.167.8.235) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.8
 via Frontend Transport; Mon, 21 Sep 2026 08:50:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d2ttvMrhx8GksHNB20O8aAo9gPJzDfsF3XqLa8zeW8HWpSvLivS6D5IgRzl/+gg+oxNssKV7r/sPN1QLZtGoy8xdUwkZL6qlqEKephFKSE8TPkhm72jJtSsumXPgUY0ffN6bWndGTq4GbOduLQTRiGmY1mfGsr6HeMwzfER2zw9l6OFIlS5uE/o40EPO/QoB7xRQTSJwJASxYixBWcoFiXb/TDCptWlR/AAB6Q/DH8GlUS+TVFLvf5z07Ljdc/ry5d+BFfgyymCBGfUflrXZffLDCaEpYTXqIfx+L2II00lRbz7JoaZwxJLin+u4dR4Xf3K4Lt2NG4RQGka5Ju9zqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2AZuT1/OY/48+OQVf5Xy06C7nyJ28b5XEaqiFJ136wo=;
 b=ZZeCN+VJ93zH1z8NJdmRK+EM5RZ+yxyes7lW+SR6x2/J7+iONQ1OVi5RcZ+TCGnwczKqJ0yc2gDZgjV62V2tojCV9+SjYRFwmetN7AzGquwDXXBcKDeGOW1Apgk3h1pAkJYbV6fqG+0eWg/jbqG+p9TrNuRmN76Og58qZSWY6hQciFg/vXEi6n2J/7pOU/llXblPctt9zsehUSqbKu6ivNZtAQ9nFqcErsT9myKEyXZ8DygVstG0AX5e/EBw2/DHtWdaFzRUgjBeWOEUFJqiBGKfEtITY8ES5NnBtk169sic5Y1VWaf4ay5Gj+Wm6tJv81mSIYsvKhKEb7xgdfkG+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2AZuT1/OY/48+OQVf5Xy06C7nyJ28b5XEaqiFJ136wo=;
 b=jnDfn3MFLUgI9ZKXNmy1bTpHBnw9YlX/CX+V37RklZe26yiCu3vcv4qqBFQwMMhLZsZnqMpEvXfTtkAd3kFQrvNaO0/LEU2c47CqsZp8o6B4/p3MPWx9aV2qbwD1eE+vpeM+72auZvNlOM22n2WWsJ81Y07fBRxCjnhF57jRPIM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by AM8PR08MB6340.eurprd08.prod.outlook.com (2603:10a6:20b:368::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Mon, 21 Sep
 2026 08:49:49 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0451.004; Mon, 21 Sep 2026
 08:49:49 +0000
Message-ID: <de9380da-9b3b-4c60-9dfe-45775b3fb889@arm.com>
Date: Mon, 21 Sep 2026 09:49:47 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org
Subject: Re: [PATCH 2/6] arm64: use hw_pte_val for HW PTE atomics
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
 <20260914-pte0_arm-v1-2-bb53b663e396@arm.com>
 <f9a7cd29-8aa3-4436-a95e-999c03aad0d7@arm.com>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <f9a7cd29-8aa3-4436-a95e-999c03aad0d7@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0051.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::20) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|AM8PR08MB6340:EE_|DB5PEPF00014B97:EE_|DB4PR08MB8078:EE_
X-MS-Office365-Filtering-Correlation-Id: 422790ac-64b3-4742-e01c-08df17bd6003
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|7416014|1800799024|376014|366016|4143699003|10067099003|22082099003|18002099003|5023799004|11063799006|56012099006|921020;
X-Microsoft-Antispam-Message-Info-Original:
 I8eLGRGJjEtI14OAvgJptTvlmYAcUoaiSNlVosIiL9k5lMWEflrw/6t8qRqnXnzIU47itXwObqO+xXjTMVD2Tl78fMFFI8e+oymBcuwPc8b8PrPSt52pFl7xsJMCmAlT5DEFl32Yl+is5TH8V+LT1uoahbwwNeXNv+SGEr3KBGZsT9vCJqEQXG9fPo/3vdwiy+oNd7sVlp0lpOTcXhijpblVW8Hwa0Ypa+pnyA/UF/9ffgBNSFxdSldSlEa/ig8iWYNBvORqKpSlrwRwqk+FzNN+rc0XQWZaVrrYtEGQGZ1F1I+SYegcgWtSDwSt+oEv5FYdsnEcYqj/bKfcOSKH3jfy6ZURf1/IqLmHYgcV9cdQzblKdTTnsa7EEnvAtdAgVf5CB/k+1MWEdUwllfEDiKlj9hNz3QlaeR3YxDszsBHAYO0gSRHPPWHzMAszjsH/kLBm8W9Ab0WzupukHya4PsSYBnrigKxnfDJtAjQxbNOKsscrTb4Uz2XZBjw10mPe+v5W18emMdS99KGpCEAwKdPYTfct4sgWxpgJqSD6lMt17rKaS9KvQp1BJWJGcgwgeecFTy0wc7bjvimZ1lpuUNV3Kr++7d2iFHjJVBaws0BJCVPEVdMZlyuhMJmA46pAdxoohjvVrlKUSp2RDtN+5LkzjnPdkXgkEzcrPE0x50lrfzAXnXnF0TvYSxYrUpKvLyANhKnWQjGV+NZhVoPttQ==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(1800799024)(376014)(366016)(4143699003)(10067099003)(22082099003)(18002099003)(5023799004)(11063799006)(56012099006)(921020);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 UVl7EPdCvYfLSzTIbs/DXtoeqizo8m+T8MkIFLdkLFko7oHGBBgZzvLgezMNfRVZtk9EE4rrKyfjukUl80gtZzN3jAU/BQatdqUe5WVCwcy6VIPf+KNJibhDFX9G1cmaoVgMnm+aFcFKOfenqJwqMhh9x9qs+4WyPfHNYDBNg9og30n1hop7KoiPttZrYgVpp0RDutKikC7vEEuHzAjVQwcFQ8KVDqROYg6bNl2rT2YXX5m6JcuzmBLHhQNTJCVYhZ9mH9611bKKC7YqCRKoRXDhipUPMWDT5xRF/usu7eCWbUBXqpfPj9JDmHYtQwd6RabuaI4ia2IUTH74JjnyuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6340
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B97.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	60227b3b-9fd6-4569-761e-08df17bd4b2d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|1800799024|36860700016|35042699022|7416014|376014|23010399003|10067099003|56012099006|11063799006|5023799004|22082099003|18002099003|4143699003|921020;
X-Microsoft-Antispam-Message-Info:
	/tUQP6QjSdRM5o4j/St5UHywrj+H4dKNkf4NLHujlFQxIrj0S45tklYM1H18jHo+ccDodWe25dug5QAO6F/UqhA8fPOy/Xmx44c3h1U+DpAeKNgkBjM0HWUeUuMaGeW+UtAmONUqP9BeVtJwEjgP/f03dI3HXt56wawmIOLSA5RC8GgmKIZ7rfRsQs6g0cm49yZVYXdRtPJvjOu4hCyC2ihJUV6MtmXP4F1ZnjTYbzzcHU73L4MINAWVyZOSO77m9XWwiOytm95rAXICPS0GYyV2aXtgmMGiMnE2Z4B/QWLqKIDNXjdb5rr2NHFPSRdK7hJKlCdKlRIfviitrF9q5KwYhShrXStb5mwSOGCtWo+N6d0DRg0baSQo9rq/1CTz3NhLzr+xDNjmdCmca2w4cXkb3/bU+ImTG0wdnVw/vNH8srGbP1WO0MR594iGgRUyQgNY7ApV2t4TmkFez4/Q3lGuZoPnPoimQV9agL17C/AuqiwjuniXcwCLwFf/bv2mbVmwQGuRtxjbVcdUjDohmYUj8ntlnFjqWmHkItFSbaNxd6Q2nUchvHbV13Zp7I/9t8Oeo/Q7q737rXOfy9VkOlcK2J6L8MPZ8pOSfOSVIsahBaZPMZRjHGHMJDNZ1HvT2MRajxEr4QLyUHeZLeai23fUDq8DXMNI+3p91/dJEBiK6xVrSuLtpcrZcbhLjr0EgPaDB1lpF6IO9aaD4OFGj0bLpUpxHmk7cYYfX+J6ohSpFYwEEAP7yRSDQBekc92V
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(1800799024)(36860700016)(35042699022)(7416014)(376014)(23010399003)(10067099003)(56012099006)(11063799006)(5023799004)(22082099003)(18002099003)(4143699003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hH+RNZS3loZTceiyZ9QODzURDgqk4bazTl0Yry5JU0EQnwRxrWRvOiQrfHyaWnipCUF9yAAZZPdT2LGzwlQhtxTR1zraRwWMWphSe01l62eajAxrCYa33bQ4GRSWBE7j8OCNPLQPpjhumcpqWx2ADEvSRpVNAA7MUFy5E/X9ZjU/s3gXD1v9Xm3+1FW0/J5bI2N5Gb+aBeSnVx493m4F1QAHlPcqQzPuCAFSSTa2yoD5zG453McyfH0dTRlcsHKkbVGeUzMxify/MYu9plWKkvYcRycBsG9mahM1B0xr2jBmRp7yTADhi5QPF64eTgllZvhBG/vzgVAZNyMMp/dhiksXrQwxnGo5xo7Um+RLFnI5ITIs+yA5QRqWTY/kzwMavBPbMy+5pCefKsafyz9KHN1SGWL0KI1wPVgbSyScJi/BqMzVs11xOGvlNGXfkIHy
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 08:50:23.5936
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 422790ac-64b3-4742-e01c-08df17bd6003
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B97.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB8078

On 18/09/2026 4:55 pm, Ryan Roberts wrote:
> On 14/09/2026 14:51, Muhammad Usama Anjum wrote:
>> Add hw_pte_val() to preserve an lvalue for the HW PTE bits, so atomic
>> updates can take their address. pte_val() expects a SW PTE value and
>> cannot operate directly on a distinct hw_pte_t.
>>
>> With ARCH_HAS_HW_PTE_T, use pte_val() on the wrapper's __pte member;
>> otherwise, use pte_val() directly.
>>
>> The atomic operations and their ordering are unchanged.
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>>  arch/arm64/include/asm/pgtable.h | 10 +++++-----
>>  arch/arm64/mm/fault.c            |  6 +++---
>>  include/linux/pgtable_types.h    |  4 ++++
>>  3 files changed, 12 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index 652ce413be389..4768ec59de555 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -1303,7 +1303,7 @@ static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
>>  	do {
>>  		old_pte = pte;
>>  		pte = pte_mkold(pte);
>> -		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
>> +		pte_val(pte) = cmpxchg_relaxed(&hw_pte_val(*ptep),
>>  					       pte_val(old_pte), pte_val(pte));
>>  	} while (pte_val(pte) != pte_val(old_pte));
>>  
>> @@ -1346,7 +1346,7 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
>>  					       hw_pte_t *ptep,
>>  					       unsigned long pgsize)
>>  {
>> -	pte_t pte = __pte(xchg_relaxed(&pte_val(*ptep), 0));
>> +	pte_t pte = __pte(xchg_relaxed(&hw_pte_val(*ptep), 0));
>>  
>>  	switch (pgsize) {
>>  	case PAGE_SIZE:
>> @@ -1422,7 +1422,7 @@ static inline void ___ptep_set_wrprotect(struct mm_struct *mm,
>>  	do {
>>  		old_pte = pte;
>>  		pte = pte_wrprotect(pte);
>> -		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
>> +		pte_val(pte) = cmpxchg_relaxed(&hw_pte_val(*ptep),
>>  					       pte_val(old_pte), pte_val(pte));
>>  	} while (pte_val(pte) != pte_val(old_pte));
>>  }
>> @@ -1460,7 +1460,7 @@ static inline void __clear_young_dirty_pte(struct vm_area_struct *vma,
>>  		if (flags & CYDP_CLEAR_DIRTY)
>>  			pte = pte_mkclean(pte);
>>  
>> -		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
>> +		pte_val(pte) = cmpxchg_relaxed(&hw_pte_val(*ptep),
>>  					       pte_val(old_pte), pte_val(pte));
>>  	} while (pte_val(pte) != pte_val(old_pte));
>>  }
>> @@ -1830,7 +1830,7 @@ static inline bool ptep_try_set(hw_pte_t *ptep, pte_t new_pte)
>>  {
>>  	pteval_t old = 0;
>>  
>> -	if (!try_cmpxchg(&pte_val(*ptep), &old, pte_val(new_pte)))
>> +	if (!try_cmpxchg(&hw_pte_val(*ptep), &old, pte_val(new_pte)))
>>  		return false;
>>  
>>  	/*
>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>> index b77f4be88e3ea..7d6c30f27214e 100644
>> --- a/arch/arm64/mm/fault.c
>> +++ b/arch/arm64/mm/fault.c
>> @@ -225,8 +225,8 @@ int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
>>  	/*
>>  	 * Setting the flags must be done atomically to avoid racing with the
>>  	 * hardware update of the access/dirty state. The PTE_RDONLY bit must
>> -	 * be set to the most permissive (lowest value) of *ptep and entry
>> -	 * (calculated as: a & b == ~(~a | ~b)).
>> +	 * be set to the most permissive (lowest value) of the current PTE and
>> +	 * entry (calculated as: a & b == ~(~a | ~b)).
> 
> This seems like an unrelated and unecessary comment change?

I'm trying to replace *ptep with current PTE for consistency. I'll drop this
change.

> 
>>  	 */
>>  	pte_val(entry) ^= PTE_RDONLY;
>>  	pteval = pte_val(pte);
>> @@ -235,7 +235,7 @@ int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
>>  		pteval ^= PTE_RDONLY;
>>  		pteval |= pte_val(entry);
>>  		pteval ^= PTE_RDONLY;
>> -		pteval = cmpxchg_relaxed(&pte_val(*ptep), old_pteval, pteval);
>> +		pteval = cmpxchg_relaxed(&hw_pte_val(*ptep), old_pteval, pteval);
>>  	} while (pteval != old_pteval);
>>  
>>  	/*
>> diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
>> index d6c5a7548550b..ee4eace5c3e1c 100644
>> --- a/include/linux/pgtable_types.h
>> +++ b/include/linux/pgtable_types.h
>> @@ -9,9 +9,13 @@
>>  #ifdef CONFIG_ARCH_HAS_HW_PTE_T
>>  typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
>>  #define __pte_from_hw(pte)	((pte).__pte)
>> +
> 
> nit: why the newline here (and equivalent below)?

I'll drop the newlines.

> 
>> +#define hw_pte_val(x)  pte_val((x).__pte)
> 
> Wouldn't it be better to add these as part of the generic series? I know we
> prefer to add an api along with its first user, but in this case it seems odd,
> because you're effectively requiring that arm64 is the first merged arch to
> support this? You could also use the same argument to say that none of this
> should be merged until the commit where an arch turns on ARCH_HAS_HW_PTE_T.

Agreed. Thanks for explaining. I'll move the definition to the generic series.

> 
> Thanks,
> Ryan
> 
> 
>>  #else
>>  #define hw_pte_t pte_t
>>  #define __pte_from_hw(pte)	(pte)
>> +
>> +#define hw_pte_val(x)  pte_val(x)
>>  #endif
>>  
>>  #endif /* !__ASSEMBLY__ */
>>
> 


-- 
Thanks,
Usama
