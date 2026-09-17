Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E024AEBD8;
	Thu, 17 Sep 2026 23:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789689161; cv=fail; b=MYhxr+hefT3y2mb8TEbOR0P6j3ggcThzetmx9v8LSh9xpyqQ+ByTmRI+6374hrYfOwK5MNwpAXV8okREPrKKV+pDholLstGjj3u1aUlTPJhsaJ0qYa5D9jq8y7HDUcfHAk7LMTtV28Mw8y9q7Sci3fWYHSbbhTTnPnmQPQRa8EI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789689161; c=relaxed/simple;
	bh=1mDPeNvB/rZz4CSZkePfTU6hDjCCfeyxSdjJokojv/g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=slK81HVixymN5w/BfgBG5ymDMUDdoLimvt2n9DvjKY78MbSDPOrXW0t4ZbpaLdWW0hhIa4QXtfvKJIu5b4H1C4uEgJwQSEZnk+GBeX5yJTvzAavm267C4aQSqFT6ml8eSzsCwx9ihfDNsT2e9qjXQGRfyB9+FahiE6bZuvq5lvo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j8OwanVT; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j8OwanVT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789689159; x=1821225159;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1mDPeNvB/rZz4CSZkePfTU6hDjCCfeyxSdjJokojv/g=;
  b=j8OwanVT/W98ikRctUHZssZ6OwyfO1qysUTIuikhW0TdbaPjE5ZmIg4L
   8FW2NEnoxGcJMm67D1Bn53Goczb+POkg2v/Tt93uZSqnA4l3zEWP6AmnD
   k8gWEqfW6VemZ+2dOhr226o3nXLuQtA499m88X7sb2z4cziP+AR8Kr+DW
   C9HuStZ1gqUmKEs5ltfuHQBBTUcisGHLtrp1qyT26VTq80qLYFV1hGBjv
   7yyzcTPzretpeCs/dOIBG29EUx+11iPzYm9vxa7tq1XD0gCtR3vdLR/Sv
   p+SPBPSrrr4V9yg1J16l2QGQ7eNFs6hwDMqvEwMOXbzPjgqrxSWZivzuR
   Q==;
X-CSE-ConnectionGUID: qC8rgo6NSqWk5hce4FNpow==
X-CSE-MsgGUID: KRFRzY1UQMWq+A1ZmftY9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="90295128"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="90295128"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 16:52:39 -0700
X-CSE-ConnectionGUID: 0oAdGZgNR8qzJaXrKzs/UQ==
X-CSE-MsgGUID: WY4PtWu2TVWLHascLwVLmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="270386387"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 16:52:39 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 17 Sep 2026 16:52:38 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 17 Sep 2026 16:52:38 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.14)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 17 Sep 2026 16:52:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cUttftSkt5RIBLaU4uE7o8Y2Wz81nXzwrR8W01NlEGlnjlFoJ4yvVAyJLDXSHBWI9d+dtEVb1A+LbMTORfVEODwEqsYk7wlr7xETp/tk9rW0bSPdxcka/2KHjGEGgeJ7Zrk8p13BwOF4myDf5wfuZPJy/+sBvLMpAwIpv67QVOE5gCpHRz2D9a5+gPsPvQ0JzRWZX/0LEM57Lj/OL8EqeUo9gyIFavyo/6CS4ueXqpnaPiu3QEspSzS7aOsDSJk9muW8YZc9MKTuRmQvIVn8e29IALE+ABr+V6US6NYV26f1IiSrE7wudcWIXRS8+B816N0uVS3awIN9Un1fm4/qeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1mDPeNvB/rZz4CSZkePfTU6hDjCCfeyxSdjJokojv/g=;
 b=Wf86qsMyL2pHnni778MrHx92Bb2SBlXpxpQU78ZZQAv2bqDkvaygmyj5VZ2u1E8Ij3ngTsVUMwAfBFQc08KSB/RtG9IdFM0H/0jAR4je2NGImIKB6F87yH9skcrGFGhBZryUaK7VMuuC5m0myEA+gMcs9m3fE7xJ9jyOu+krmZdGS1DzPOPPgNoAtvlMr+lTt36S7ddgeyo3ndbl4YXQiS63hXeo84KsyajkNnMHUz+KA4O/AcTYDmQALHTLr8moH6smKKcT6BmlXdodt8H8tjLEsPXqZNOBx7mhGl2G9gU2sNGGZ+WeIi6VSicjmYfc7Ti+SjiqSXmqMalx14nZpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6771.namprd11.prod.outlook.com (2603:10b6:510:1b5::20)
 by MW4PR11MB7150.namprd11.prod.outlook.com (2603:10b6:303:213::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Thu, 17 Sep
 2026 23:52:35 +0000
Received: from PH7PR11MB6771.namprd11.prod.outlook.com
 ([fe80::effa:162e:c9c9:a1b4]) by PH7PR11MB6771.namprd11.prod.outlook.com
 ([fe80::effa:162e:c9c9:a1b4%4]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 23:52:35 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kas@kernel.org" <kas@kernel.org>, "ardb@kernel.org" <ardb@kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH 0/3] Move memory acceptance x86 arch code into EFI stub
Thread-Topic: [PATCH 0/3] Move memory acceptance x86 arch code into EFI stub
Thread-Index: AQHdRVw1VWonJZOLp0OnmPorD0Fzo7bRhEcAgAFDBgCAAFMLAIAAUQ2AgAAJGgA=
Date: Thu, 17 Sep 2026 23:52:35 +0000
Message-ID: <33dcb4c259dc5ce35dea3be3e4ac67d88c58279f.camel@intel.com>
References: <20260914183745.37538-5-ardb@kernel.org>
	 <af17c380c43912ce34c228e328b3937343ce2019.camel@intel.com>
	 <aqvrUeIfpE4D-Ol0@thinkstation>
	 <27b267cdaed0c46146de4af2db8362b61e0b08a3.camel@intel.com>
	 <0fce97e4-3c3d-4b25-aa50-b88a003fd033@app.fastmail.com>
In-Reply-To: <0fce97e4-3c3d-4b25-aa50-b88a003fd033@app.fastmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB6771:EE_|MW4PR11MB7150:EE_
x-ms-office365-filtering-correlation-id: 1a4e46a3-0e09-4bf9-dfd4-08df1516bf3e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|38070700021|10067099003|56012099006|11063799006|22082099003|18002099003|4143699003;
x-microsoft-antispam-message-info: 5WYFRGNHf4hLruEBCAg3xWR9gYHIoGPdAM6nIbeEJPSyGqWsAFoPQ/ETUdJX1SuuNoEZl4U3SxtnnUmwkXWiiUHaMgbvM41GwpyAxcm6Wlu1QMP/lGmhnm7h8+JWREWWIVFyDAquV9CymLiMTcyYbUnFOQm0YnpuoPXDMtAnUidv3fXlFDJ6M2LVvxk1OZyJ7VGOzD7q2cmkubZgEySuefZODD9OYA27m1+/n4SDLvMgkzXTEBsl5IeeKShntPK9QAWUb/h1gGyniBH1liy98SkK2ttE5+tA8I+53mDmwy7UhsJsss91IeYmdLQwif20JBrIv0oS4RQ2vJz3XrMr32uQrOfSIFIb/dlCGjXcrDSnfprEaHbUGhP5CbYzwdqD0mg6jyF46lbJY46XAMfMzP6/pishmr58hx42qoyOzUUkqaZyVJU2S2jzYQXHTjKBBieSgcr1lj7tws1msrlwnXnGiIym1vpftJL+6LiLrpXrCwaBbxqS/ZM/sNoogYS//8RZFtz85bqD1OCbqkFpwsddEn/saJa6HAD9KsXyiZlPQoGpR3QaskLNJ09TjakUCF5ceDso8m5kboH/1SisKhbg5n54r2+CL35WOHy0ynxlIA1aOvJAjK+Ln1epnpFVGQa+26RB5D0/3zVBjkVvTREeZ7dnljz84+z4bn6sRta7R4FEAXNlkvLXYOg/MPzO3NudYRDhxfwSCkSvXIzgQjtn6B+ZDHcceC+BD0a/Z7I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(38070700021)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003)(4143699003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bkU0TmM4NVh3UEN3ZzBTSGtIWnhZeGdYWFNvRVV1UjBMOVZQYlR2Y2dYbWRV?=
 =?utf-8?B?WS9tWjU1U2JycWQ4L3dzWC83cWNQSkVZTzFnMUN5MkY2Z3pZS1FiTTdYQmc0?=
 =?utf-8?B?UEpQbDNJYnpORXlrTkU3N04zQjc3emNQUzlHYjlrdFh1RTdnNlFQOUdWV3h1?=
 =?utf-8?B?eWR3QVBzS3JXRVZWQkFuWkhWTkR1eXI4bVpyVTRvMkcvWnVQTTdTdHJkdTVm?=
 =?utf-8?B?SFFRRnVWd0ZXbktlVzBvYkZxVDVPYjVPZTh2WWtwVDlGNUJVN0ZSenJTTDVU?=
 =?utf-8?B?TDcxVGZ2NDRCS2dKT2liSmFmbXBpaEVyYnV6Rk10a0Q0NWJuN1dJaWR2RHpL?=
 =?utf-8?B?SEpqamYrRUVidTE1V3dhRy93NmMxdFhWRzRCNURybTRMOVFIU1VxSGs0OGRX?=
 =?utf-8?B?dks3OEFybzRXbHJubnZONC81RnFicExPWUM4U0RReUl2NEh5Sm1RUkhpY2Np?=
 =?utf-8?B?ZlNJRDF1cHQvKzZ0b3YxL3Q1am4zU2N1T1hlOWhZbC8xRURFMGIveVZOaGk0?=
 =?utf-8?B?WVpRMzZRNWhXWHROd1drdWRKNExqd2U4czZwbGRPM2xvQUVZQ2p1NkdUNm1F?=
 =?utf-8?B?WnpXVzk2THgzbkdHRjlIbnNxdzQ0SWV5TVpIa29HbHNzUVFyYzZOU0FBaEph?=
 =?utf-8?B?SnBmb1YrNlV4NG96ZmRuYU5qUFZLSkIwZVRTN3BxdlN1cThMamVFWVNSY0pu?=
 =?utf-8?B?UDFwWHF2Y1hyaHlzcUdRRG1ZRlFsbWt6b05XNU5vSTBFUGp1TzZXY0x4dVky?=
 =?utf-8?B?K1NZWW9xRFhVZC9VeUtUbXIyZHpXRCtnMlkwTW9EcVl3QUc0U1FsMjBYSlc5?=
 =?utf-8?B?SzNyZGVyRHpsMkVLK2xoVExUdDlWb1JmWTYwQzZmM0tCaVFSTHM0ZUZHOVVD?=
 =?utf-8?B?VnJCWnlyUzAzQnhlV0VTUlFwN1A5ZVhqbmJiSXc4WG5VQzR2ck8wSmhpRmh3?=
 =?utf-8?B?RGJqOW02N0NLUVdXSVl4aHQ5NFFJcXQwTWVxNHZKOW11akVTZDBWMFBEOC9r?=
 =?utf-8?B?dEhUeTVwdXdQSDFaYThkYUN4S2IrL2J0N1hmYm1KK0FvdGFxSUdVcmR3Z1JS?=
 =?utf-8?B?Y0ZpYmVsVkRETUFZSmI3b0ZsQjJoc2tZTmRuMHZRaE9tY0c3ckM5ZGFlZHFu?=
 =?utf-8?B?KzJ0Z1FEUmNXRlJzbnhmMXc1bk1rc2E4OTk4L0ZJSHJGc1BPeGt2bElGT2dn?=
 =?utf-8?B?c09KeWlqRXBaRkcwelFnVkh3TzRjM3ZvUXdOcWZBdFJsWDl2QkVPSnVUSE4z?=
 =?utf-8?B?MDJqODk0c2s4bDliNlM4WUNFSnE0Z0VQMk80TWZlUVRxbjVZQnJzWXhhNlg3?=
 =?utf-8?B?Z3pwZW1mS0tvTFRmUWJVdS9SVWRFU0lOL0hhbU4yN2hpUjlMSy9sMm45QkFH?=
 =?utf-8?B?UXBIVWc4QkcwR0d3Q09aNk51YmtQUlJ5bllFbytNR1libzZRSFpBNW80dFhJ?=
 =?utf-8?B?YzFUN2k0V2pGWnkyS2o0VHhFY3hqSjJJK3o5Z0pJWnZMVFBvVlcvY1oweGYr?=
 =?utf-8?B?elpyT2VTRUt4My9RMTFzM2tvWXpzNmVUWHBIbjRlaUxOY0pseENySlUxV3Nh?=
 =?utf-8?B?MWFuMnRNKzdYSnJiMHNjZUhaWEFDek4ySThZSjI4aUhWS0tnRWsvbGJPWDVO?=
 =?utf-8?B?UmFLelhhaFkvMmh0RmZTVldRN3Q4cURjdGhTR3FOQnowNXpTSTNvTUZBOGhG?=
 =?utf-8?B?b0VEK1BJeVZWbDI2aU5GcUxXY2w1VVlyWmUwcExpamtiMFlaeEpVNzdyT09M?=
 =?utf-8?B?L2Nvc3VldWozZXRXZjRVNVlkT3JYZzQ0RWlrVVF3MUJnZy8xVVBKL2JUcUZ6?=
 =?utf-8?B?L1ZKVForYmdwQmtUSXJYcFg4SzNXWDIxTXNYMkJvZ1ZJUnI3RVd6TVZmT1l2?=
 =?utf-8?B?SWxMU0tKZkthbEVTeG9GbU9aZ1hzQlhwdTdCSXNlYWZDS21ieTJSczBNbm1w?=
 =?utf-8?B?R1UySHUwS3U5T1FsVFY3QURpYkhibkFNaTQwdVhJUktrMEdOYS85aXcyVVJ0?=
 =?utf-8?B?OWpRcmRjeXNiclVHMFJSbWpMOXZEZlhwVXdhNEgzd1B2NmFXVlVJRU9HTmFY?=
 =?utf-8?B?MnhwME1HY241dkFMaXVJR0ZOdUhvLzVYSGN3R2VPbFExbk5Lalc1cHBmL2Ey?=
 =?utf-8?B?RUJRR3RsanlTOFlVdWJhUkpVTXBzYTM1aVI4dTJVWktZVXd5TTVRZ3lHQWRD?=
 =?utf-8?B?WTdHTWdvZjdXWFh4dFlBNkJsdXZvcHdLN0dYMXo4NCt3L0k1QmtUWDZzdTlY?=
 =?utf-8?B?UUtXaS9OV0NVWDdISnlQY3AxbzVncFlnT2JzdjQ1S1FnZnd0YXZIRjVCQTN0?=
 =?utf-8?B?NndMNUtiNlQ2NFhpdnBRR09IMUZTWVdKQU9HNVU5MEF1U1lHZ3dDd1Z5eWM0?=
 =?utf-8?Q?55EIwTJCU6swa7Fo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5BE9334633262F4F8DFA93119C564ECF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: z2/Baibegy3ew8zi6yH+1Ui9+d17d/7s7bIz8Z6GEvlym/n7eiPiS6NdQuH19bx9wTVptJc/8pg7dWsU9J9xIpgwG/9JCT9wHFkzUDagbpZ1YjRibXq9i2Lu8ZphCxpMOh9XfOYmCrE3BxTypYj7bnNbB0hwA5h9YeMn0yO5DO0iuZxIV8iqZtxT9XgNthgw/82err16F3FN4xNMR3uqQbksV1gOkQr9uuBXkSw8Z3K6iBzRlHJlBhizuThqqPaWDnKTXy3x9oMGAtHbUHvg1KiownRrGVhptaUPw/DlLNnAUU67tH4tRcbvYS/dZJkFQU2frYp5baasdrwL0YXGxw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a4e46a3-0e09-4bf9-dfd4-08df1516bf3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2026 23:52:35.1303
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UlJIZO/3n5qLflO3SFRamfl6H+9CsV3i41NAHRGYJhbp7zXDdEWoyFMcafUkNG3bH/CjZbiB0PpJ6aLCQ5t1H558jzuMz7qp9Nb9Eaa35UI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7150
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI2LTA5LTE4IGF0IDAxOjE5ICswMjAwLCBBcmQgQmllc2hldXZlbCB3cm90ZToN
Cj4gVGhlIG1lbW9yeSBhY2NlcHRhbmNlIG9jY3VycyBhZnRlciBFeGl0Qm9vdFNlcnZpY2VzKCks
IGFuZCBzbyB0aGVyZSBpcyBsaXR0bGUgdGhlDQo+IEVGSSBzdHViIGNhbiBkbyBhdCB0aGlzIHBv
aW50IGV4Y2VwdCBtYXliZSBzZXQgYSB2YXJpYWJsZSB3aXRoIGFuIGVycm9yIG1lc3NhZ2UNCj4g
YW5kIHJlc2V0IHRoZSBzeXN0ZW0uIElmIHRoYXQgaXMgYmV0dGVyIHRoYW4gYSBwYW5pYygpLCB0
aGlzIGlzIHNvbWV0aGluZyB3ZSBjYW4NCj4gY29uc2lkZXIuDQo+IA0KPiBIb3dldmVyLCBJJ2Qg
bGlrZSB0byBhdm9pZCBnb2luZyBvZmYgaW50byB0aGUgd2VlZHMgaGVyZSB3aXRoIHNvbWV0aGlu
ZyB0aGF0IHdhcw0KPiBpbnRlbmRlZCB0byBzaW1wbHkgbW92ZSBzb21lIGxvZ2ljIGZyb20gb25l
IHBsYWNlIHRvIHRoZSBvdGhlci4gVGhlIGN1cnJlbnQgY29kZQ0KPiBwcmludHMgYW4gZXJyb3Ig
dG8gdGhlIFVBUlQgSS9PIHBvcnQgKHJhdGhlciB0aGFuIHRoZSBQViBjb25zb2xlIFREWCB1c2Vz
IHdoZW4NCj4gcnVubmluZyBpbiB0aGUgZGVjb21wcmVzc29yKSBhbmQgdGhlbiBsb29wcyBmb3Jl
dmVyLiBJcyB0aGF0IHNvbWV0aGluZyB3ZSBjb3VsZA0KPiByZXRhaW4gZm9yIHRoaXMgc2VyaWVz
LCBhbmQgdGhlbiBjb250aW51ZSB0aGUgYWJvdmUgZGlzY3Vzc2lvbiBpbiB0aGUgY29udGV4dCBv
Zg0KPiBhIHNlcGFyYXRlIHNlcmllcyBiYXNlZCBvbiB0b3Agb2YgdGhhdD8NCg0KVWhoLCB5ZWEu
IEkgZ3Vlc3MgSSBkb24ndCBzZWUgYSBzdHJvbmcgcmVhc29uLiBUaGlzIGRlZmluaXRlbHkgaGFz
IHNvbWUgYXNwZWN0cw0KdW5yZWxhdGVkIHRvIHJlbW92aW5nIHBhbmljKCkgZnJvbSB0aGF0IEVG
SSBzdHViLiBJIHRob3VnaHQgd2UgbWlnaHQgZmluZCBhbg0KYWx0ZXJuYXRpdmUgc2ltcGxlciBz
b2x1dGlvbiBxdWlja2x5Lg0K
