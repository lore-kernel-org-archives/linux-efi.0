Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE06440A3D;
	Thu, 13 Aug 2026 08:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786608762; cv=fail; b=f6Xfy8SX8DLFEEHTPuuuQZ12brvMckS7whv8MjRHSiiQdVw1yNMKZ2eV1Zv6OwXQIEZrZh/KDgBP1ey4i7XxUv6li2ZEcK1k6/Rl/iAZE20drCzO+c6oLk0CDdD46HxB08zi3hyy3tJuc4PFwLOwTriWEbp/HppNUWQpdwLEaFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786608762; c=relaxed/simple;
	bh=GOtHYHykARmqiS8XT6002H7tgOaZnoTkx0GNTNP5w5c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WPqunEYKk5zKGiTy6R0qadPwHT/e6tkne4pq4eWTI0yPrGSFJBfkon2dEpo6ydjNjVlEMbPUSABkyHngQGntiGPCE6Thu1z5sIfR9e2mN+Of8ZKk5U3j8JUEZwJNZaPiRdQCGLo0sSdMW+wakc+VitB+CFC8UekwExwQT7kQ66A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lde/Md1V; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lde/Md1V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786608758; x=1818144758;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GOtHYHykARmqiS8XT6002H7tgOaZnoTkx0GNTNP5w5c=;
  b=lde/Md1VbtSd7zyoqBDYE1jOgRXyycaFNmCb6bjpQ0WxA9iZWsgOkb8P
   jLcBakEO64i2manpxFOs1/V2qc+proOOfFJJJjunu/DCnA3Cb9DeRrDNS
   tp2OFYH1nSjG6zxufhv7jwnlDZeHWn4s6L4hxR2mSF8w7op55kSR9W6CX
   VD2N6ynPkiOtqIXp3Hpf78NUGOirVZ2iOQOvIXjRU6lAFocUOghzr2tg1
   Xj6DVSKbjnmi4rZ3rhkj1E5xy2DRGLxvVX4k9JZslBQo+Z+mB4VdIxlnh
   HRr8iSlchZU0cvSbCYTPsu7DRzFNbll5B9WAD1td0IROAWkVnhccX2maZ
   A==;
X-CSE-ConnectionGUID: 0SYiaUaATU2RBf8AmTAQhA==
X-CSE-MsgGUID: y0hfwcAARn22rqyzW6/B4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11873"; a="87393346"
X-IronPort-AV: E=Sophos;i="6.25,221,1779174000"; 
   d="scan'208";a="87393346"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 01:12:25 -0700
X-CSE-ConnectionGUID: AkS37d+iSZ6U2JhgWmQkHw==
X-CSE-MsgGUID: GGRribs7RHaFFXgOixGKsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,221,1779174000"; 
   d="scan'208";a="267724965"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 01:12:24 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 13 Aug 2026 01:12:24 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 13 Aug 2026 01:12:24 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.23) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 13 Aug 2026 01:12:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E/7/Y0W8/iUqvY3EFjqqeVsC57r22fAJCrWkzqPjH24hgkCV3u3XKr6v8CPU+kOBsWdVeAeT3Umot21XEz9+bUUMyyua+AjMQsS4Jtcf1mkNlC6Uw+zaNiVZAexl5Vtpo2pkPHQu19Pxvi3aKLtv0EhLAaSlBITCVLF9Mh4SytqsBPDIj00nr1Ghc+rdcukyhL5PelVWuirLqvRMrBmG8j9dcM1TpUxl78+qF/8GpTucpYLA302ckhxRpm5SPzo54Y5tW//3qdbtsIdeQAj2rWhZutzuzNs72CMi96nD8XWnVDKoVR2Z5+w1jtNYu4bI5Kkl3J97tm+Wuo9AmuR6IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GOtHYHykARmqiS8XT6002H7tgOaZnoTkx0GNTNP5w5c=;
 b=SmiYHbUXyOoqS1deeXsPXQHiuESvaWZWF/mUczCtWTc7SoMDKf/eVWmkcKPh8/h+jkuSXb3d/oeFVIHDjBnJJnVz8RZ/nLg7VLSm0zmNrLe5UbWChLQ2gROcaZACXLG4SULIZesAO/2bmw5UVpvWKLDrUQmlPb/4rr8Me5kLSzRysq2w6u2rjrXgl0If9t3pQ/IrOCEht5+u+dvUGGJjv/E39svZWimAef4A06jUqWIQS6fjIVgVjHNH9n8NDG5x/SrOJuLDIS4uQCKArhHXa9yJIqb6I0mZcgZWUCh96ncdGOE4e1Pib+BHEuDGgvCGE6J2mJCFUn5+jUH5hgZP2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB8134.namprd11.prod.outlook.com (2603:10b6:8:15a::9) by
 PH7PR11MB5818.namprd11.prod.outlook.com (2603:10b6:510:132::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Thu, 13 Aug
 2026 08:12:14 +0000
Received: from DS0PR11MB8134.namprd11.prod.outlook.com
 ([fe80::d95d:cb19:df8f:1610]) by DS0PR11MB8134.namprd11.prod.outlook.com
 ([fe80::d95d:cb19:df8f:1610%6]) with mapi id 15.21.0315.014; Thu, 13 Aug 2026
 08:12:13 +0000
From: "Chang, Junxiao" <junxiao.chang@intel.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Ard Biesheuvel
	<ardb@kernel.org>
CC: Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	"linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mefi: add dynamic control interface for EFI runtime
 services
Thread-Topic: [PATCH] mefi: add dynamic control interface for EFI runtime
 services
Thread-Index: AQHdGm23/jQpztcApUCiO3umY/A0pbaanIuAgAEka6A=
Date: Thu, 13 Aug 2026 08:12:12 +0000
Message-ID: <DS0PR11MB81346214862A469357C036EFECDB2@DS0PR11MB8134.namprd11.prod.outlook.com>
References: <20260704003341.3923900-1-junxiao.chang@intel.com>
 <d107385f-1c58-4aa0-beac-7d536d064600@app.fastmail.com>
 <20260812144147.0Dahmj4w@linutronix.de>
In-Reply-To: <20260812144147.0Dahmj4w@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB8134:EE_|PH7PR11MB5818:EE_
x-ms-office365-filtering-correlation-id: 58edc018-8c39-4d86-50a9-08def9129495
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|38070700021|11063799006|4143699003|56012099006|3023799007|10067099003|18002099003|22082099003;
x-microsoft-antispam-message-info: N7QcCHZRN4aHnnH37L6rp8mCI7NO6XhSpmDevFBIrQgqjoyiCIykRYZicNf/wYrhNZlFqbUC7ozoEYYZ5qY1Ow2KTMQWF5EqgrJabcIliU+1dnpUaHDD3wgyw4CzbW63K+3k9/iDeao6Y3J6YcN1VL/VuUm/DwzPfdmhUG6ARhFlBNL5oMFSwB2OnUp+rovtYG8Q/U/9euTzI8/2sCfrqXTEBXQ4UmTZ9eX02HOwgBDF6LC3FLxfV+r2Vqnp3wa1Gx7hYMYzS1p7bvZEgHJH7fzz+C5ieQkmUsakGalINyfYGa90LmfYh1lR7WIQhvyYUBkEM2nJC3enNDvgi9w8AHgLYk7m9cFzQ+OMsOITBHpFn7+NHWVaM4dUql3D393+bvLaW0edPkCFrHdhivkP2ZOjW+TtmIISGvKnvNAan9NBLBxTn0F/E2665KZR6NQ955IIdRZhgtZkM4SF9N4JVkaXCSQRWA+SUPaMPO+ATpgGObaeherBp9qzMVn7+Mw3AL75LGqa9NBW5pruaDsLBnsVo3Zob+tCffHCHk8EcwSG0vZlEumazxzJMb7epaugaujIBlKud8z24p2wTB6peVyYdwbsRPO1QOnVrGgNJ9VHw4AqGJT63l8kKS7wiXEhAdR5Srp1zN3tIm+4YVgIvODAY+i5zCoeo/3gMpT6Lh4nr3vPIHXBS+jP1DxEOOOE/R9HfndR92XUV7erbreS+qyYZBFelJcliG6ewUOKSAs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8134.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(38070700021)(11063799006)(4143699003)(56012099006)(3023799007)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eTFGcXV6dTRzbmJwTDViSnp0WXdaYUlKZjF4Qm9EajIvK0N4ekh2TTRGcGI0?=
 =?utf-8?B?RERqcjUvYmdjVGZ6RXlGK1lsSmVtczZ4bS9rcTFDU1poRWxaWm9kc0tVR1N0?=
 =?utf-8?B?dWtZczVreTBMeGVrOWJZNXo3S0o1bzVuUG05MG92dGNDaXcyZ2U1TTJsQkwv?=
 =?utf-8?B?L3E0UzZoOXpmaTVxdklqN3BzUnBDZkY5LzMyeG9PN0IrU2VoT1NEcm83bGtm?=
 =?utf-8?B?RUlwQ0VnZ0RPMm00QW85YzhJdWdkekN5WERuakJLRVZKcER0d2dIVERza2R1?=
 =?utf-8?B?MHpkQ0Z6cWFmWmRuWldIM0dzUGV5WFhMWGtlMnlpS3hZS2RmM3g2enpubzQx?=
 =?utf-8?B?YnI3WFQvdXVoUXMreURJdWpsOWFIV0l1eURXenlYK21oN0Vzak9VUDd2TXZC?=
 =?utf-8?B?MzB6R2p6RE85c3QzV1B3d1JSVXBsQlNvNEVCRTUxdzQ1MERVTEs3bmZBMzVF?=
 =?utf-8?B?cHhSN1JiRDYzY0NIa2M4M1RNL2tUaVdCS0VMSVVtRWdOS0QrM1FRRVBBYlBh?=
 =?utf-8?B?M3Z4cHU4Z3k2cFdlR3NyL3B5d1JYRi9janhWSXBrWkNLNnRSS2ZWMHdwUHgz?=
 =?utf-8?B?ckg5Qy8wNnZENDB6ZHhpT3NnWXNmajQ4TC84elNrYjRHN0ZqOVlVNXBPV2ll?=
 =?utf-8?B?M2tmUnZoVk5pc1g3K3V3VWxabVlCM0YzOURpSHdWWWhUUmZGOFhBc3VnNFo2?=
 =?utf-8?B?cE9yankvRGkyOHp3T2o1TkdUMnBpQ2hOTHZxYy9RODhNbEduK1c4bGNqeFNr?=
 =?utf-8?B?a0M4a05UWURHUUdzTk1MalBFeDV5eENXTkhyU215UFd6WC9nZnlxaWVJRFRB?=
 =?utf-8?B?bWNmYWQ1YmtvV0FTZ1E3dkhHcDNRVmVPYnFNbDNRalVYTEJDRDRwZFFybnJQ?=
 =?utf-8?B?S205ckdrVGNEQW1Hem1aMzJiamVzMUxDb1U1cEpEYlJlY1FvQ2FNZWtiMUtN?=
 =?utf-8?B?am5DenpIdk91ZmhvQkZzQlFUdUxwL1hwTmduU0J2UmpDWTNWNTBheEY1S0RL?=
 =?utf-8?B?OU94MWhqQWhnbHlpdytyQitLYVpLWHNQMHhNR0RlRCtWTTZiM0U3azlZNm12?=
 =?utf-8?B?RGlDTVN3aUNVajR3U1BPbXlmM2M5eWMrTTArUmhINzJXSWhDVnl5dGxKNzAw?=
 =?utf-8?B?ZFh0WjdHMkM0UWplTTV5TXZaeUdvNzE4S3dYcmVyNVZoQS9pQmNFZFVOaHdz?=
 =?utf-8?B?Qjk5ampCd0pPdzV3aFRqdURLK0IyQjJjR2xIa01ETnJsMnZDZmtxZHlqZnZq?=
 =?utf-8?B?VUdhRnJzeWdCVnZrMHJCVVpGR2VEQnBTaVR3UG1kblF5cEpUVlRObXQzWGV6?=
 =?utf-8?B?bUY3dGNMUzZ1Y0lvNlZXS2tOb3dyc28xU1QxOUhLdDVYSVA2WURldHhydHZq?=
 =?utf-8?B?dlBPOEpnbkZiZFIxNmtVcXc2MUUvM1NnWnJ0QVlMMEFtQXdnVG9UUkdLdlhK?=
 =?utf-8?B?Qmx0OWtpeXNDMTBjUFVaWkc1QVc1QW9TbitTYlRaTGV3Z0pBT3EzbmRTRmpq?=
 =?utf-8?B?eUlOOFlYU0VjU1NDMGJnVE41RHlHM29tT0tiNll1V1hnQXh1NWp0eW5yMW8z?=
 =?utf-8?B?N3h6a2IrcFBqRWJFVjM5dmdVYnhqblVCOWxsY0lHWFBmS3VxaWx2aHJpcC9X?=
 =?utf-8?B?aXdFYWlwYjZYdnJJdHlZYTk2RmdsNHd5ek5laE41SXlxN2lKakZKN1RnTHJ3?=
 =?utf-8?B?c3NRU3NEV2dOdEI4ZDk0OVc5S045Mkw3OXNBQzlpcEtkaGlHeXpXOE8wNlFo?=
 =?utf-8?B?N2EyS0VFWWRSOXdla2RBaUFSQkVJbWcvblhsNGRDK25JVHpqTzZUclBXakRh?=
 =?utf-8?B?aWwwYkV0eUl6L3RQU1p2NjRrZnJkMUJFNURJMEtxR2c5Tkp5SWRaWno4Nm4w?=
 =?utf-8?B?MVYyRDJ3SDJTU3pRK2lFVnVqUjl3Qy9POUtWeFU0ZHoweGJUOHpzU0VJTDZV?=
 =?utf-8?B?NUxhM3JXRUhDZGtGd2FRN1kzQmRKZnRPdFkyL2dlVWZySmJNcmY3NEhKNWFO?=
 =?utf-8?B?RXZWWHgyeEZUZzYrWTU1ek14blBLUnFldmU4ZjJUVzFtTVhYN01vdkdzSHlk?=
 =?utf-8?B?TE9DelljUmI4Uy9JMXE1dWg1UXN5Z3ZOaVdyazI0T3orRndZQkpOeVNhSUM3?=
 =?utf-8?B?dHNsSzJtS0dXVjBUY1duQ1VBeElkRVFVM1lNWlJsdXZES2RkdXRDK0lUejJC?=
 =?utf-8?B?YXNaVGdGdVp4blZhYlk5aW85UnJ6ZFJ5WmVJdE1tZko4eHNBaXE3dHdhTUtu?=
 =?utf-8?B?S1RYSzQxeWFmc0tmZk1XMkF5dlBreGNsUlJ3SjArNWN5UXl1Qzc4ejFLM0hE?=
 =?utf-8?B?RzNnenp3Rzg3UmJWNmNLMk5MaUIrZVhvSm04NVhZakVPVnBZMWNIQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: A5I5Rn0FZMTGi7x1OHy2rYreBmfMlJWsCNwbbivUa7/VSeLtINeC1o7wHkN274syoehxtOP8QLaw2G4vOiRpCFf6VQw5GP6tbsFhnIL4zO2Q8ctu7sexdoeZrLCIj0h0EM/wA5652KcFK4at9vB7ZAhF45mBpuwR65hSbNVNPWH4oMI1RGsD9zcQRDjbp6AecxG45PHcsw0jBESarbU0FQv2Si2HHfgpzamuu0lDyvxD2420BitrG7T8mdgGGZ5eSVqo9y+tb3W04jHBkbDzU8AhoWKzpbQvQ63lcz2QTOOvvVErBDbWUzW/9D6rwBAL5zVPJAnWuxGwOtKxeKljWA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8134.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58edc018-8c39-4d86-50a9-08def9129495
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2026 08:12:13.0418
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O9hQvoQESM5wY5Mag4R1acOA1bpTxFOGBAplSLWOQ4EM6Cja3EAUcdF02tpEK/iJ5DGcbwKcmapao8m2ButJog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5818
X-OriginatorOrg: intel.com

DQo+RnJvbTogU2ViYXN0aWFuIEFuZHJ6ZWogU2lld2lvciA8YmlnZWFzeUBsaW51dHJvbml4LmRl
Pg0KPk9uIDIwMjYtMDctMjMgMDg6Mzc6MjMgWyswMjAwXSwgQXJkIEJpZXNoZXV2ZWwgd3JvdGU6
DQo+PiAoY2MgU2ViYXN0aWFuKQ0KPlRoYW5rcy4NCj4NCj4+IE9uIFNhdCwgNCBKdWwgMjAyNiwg
YXQgMDI6MzMsIEp1bnhpYW8gQ2hhbmcgd3JvdGU6DQo+PiA+IGIvRG9jdW1lbnRhdGlvbi9hZG1p
bi1ndWlkZS9rZXJuZWwtcGFyYW1ldGVycy50eHQNCj4+DQo+PiBJJ2QgcHJlZmVyIG5vdCB0byBh
ZGQgYSBjb21tYW5kIGxpbmUgb3B0aW9uIGZvciB0aGlzLiBJZiB0aGUgc3lzZnMNCj4+IGNvbnRy
b2wgaXMgdXNlZnVsLCB3ZSBjYW4gZW5hYmxlIGl0IHVuY29uZGl0aW9uYWxseSwgb3IgZGVwZW5k
IG9uIFBSRUVNUFRfUlQuDQo+DQo+SWYgd2UgZG8gdGhpcyBlbmFibGUvIGRpc2FibGUgYXQgcnVu
dGltZSwgY291bGQgd2UgbmFtZSBpZiAicnVudGltZV9lbmFibGUiIG9yDQo+ImVuYWJsZWQiIGlu
c3RlYWQgImR5bmFtaWNfZW5hYmxlIj8NClN1cmUsIEkgd2lsbCB1cGRhdGUgaXQuDQoNCj5XZSBj
b3VsZCBhbHNvIGhhdmUgdGhlID1ub3J1bnRpbWUgb3B0aW9uIGFzIGFuIGluaXRpYWwgb2ZmIHN3
aXRjaCB3aGljaCBjb3VsZCBiZQ0KPm92ZXJ3cml0dGVuIGF0IHJ1bnRpbWUgdG8gZW5hYmxlIGl0
IHRlbXBvcmFyeS4NCj5UaGlzIHByb2JhYmx5IGJlbmVmaXRzIG9ubHkgZWZpdmFycyBzaW5jZSBl
dmVyeXRoaW5nIGVsc2UgKGxpa2UgZWZpLXJ0YykgcmVtYWlucyBub24tDQo+ZnVuY3Rpb25hbCBv
ciBicm9rZW4gKGlmIGVuYWJsZWQvIGRpc2FibGVkIGF0IHJ1bnRpbWUpLg0KSXQgc2VlbXMgdGhh
dCBpdCBuZWVkcyBhIGJpZyBjaGFuZ2UgdG8gaW1wbGVtZW50IGl0LiBNYXliZSBpdCBjb3VsZCBi
ZSBpbXBsZW1lbnRlZCBpbiBhIHNlcGFyYXRlIGNoYW5nZSBpbiBmdXR1cmU/DQoNCj4NCj5XZSBo
YXZlIHRoaXMgdGhpbmcgd2hlcmUgdGhlIGVmaS1ydW50aW1lIHdvcmtxdWV1ZSBjYW4gYmUgbGlt
aXRlZCB0byBhIGNlcnRhaW4NCj5DUFUgaW4gY2FzZSBpdCBoZWxwcy4gQnV0IHRoZW4gSSBsZWFy
bmVkIHRoZW4gY2VydGFpbiBFRkkgdmVyc2lvbnMgZG8gYmxvY2sgYWxsIG90aGVyDQo+Q1BVcyB3
aGlsZSB0aGUgb25lIENQVSBpcyBwZXJmb3JtaW5nIGEgRUZJIGludm9jYXRpb27igKYNClllcy4g
SXQgY291bGQgaW50cm9kdWNlIDJtcyBkZWxheSBmb3IgYWxsIENQVXMuDQoNCg==
