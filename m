Received: from PNYPR01CU001.outbound.protection.outlook.com (mail-centralindiaazolkn19010005.outbound.protection.outlook.com [52.103.68.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2684A269B1C;
	Tue, 17 Mar 2026 09:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.68.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773740350; cv=fail; b=eVx5fPhr+mMqKUM2eDmX2fDrQm53Rj7/jVISwDyV5uLd1Z6RTNN+Rok1kBWproGmVsbAmjpByWwrtilNkMjk39mmp+mIgggmx7YLh3nnaYxzT3BubE6Qe6JzNnewQ1FE/4pshUdEvsgXTyA2Cj//b0vHo0ynarSD9iDrnPJ1lMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773740350; c=relaxed/simple;
	bh=L64u+5EsJjCC1SvaIKANFn3+kBgZlffxLL/1HAdWKr8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AIfhQedSw1rvxQj/goVosfij1qUj31Dz9t94Uxkh5U0vKKGI9+Nm5LV5KT/iMidMO52SqQW2hlA0Xle2JQnYxaVRVD6vh1myGSOePeQXp1dKSD0klFWTuLxnUC0iKUANpYndzuUJL3g8w/laizYlHXRMpIpwxcP/MnCEZCvCK4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=u4nxvSI3; arc=fail smtp.client-ip=52.103.68.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="u4nxvSI3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CMoagOk204SvbmLspURbiRBRnqjV5npIW+pVpR8GQPou6laxOE4SFHvauDCf+xYgAtEte1kt7r4rFMjhKZeOJdD1JyovTMOxG93TIENzxUqnJ/ixPFYcU8l3BxaB5UZQU+A9HRyD8lw2GdFWakcT04Zlpsfzm5qkw/Qb4rD/Yuh5ohe5F9+qA2hOSzSBXYufqPMqivrf6EimZImYNFCyBkZKC6Z+uhZaYTsOWTZ8RXBHPDxMa1j3K/Z6aohkOvhktL1Dj4TaY6scJPjeuqwzOJR1q5tmPYsVVL+TAZ6TI5lZneuXkNbyRMaG1PSh2uAhLPFS+9Y5DulZZ32OAB66Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L64u+5EsJjCC1SvaIKANFn3+kBgZlffxLL/1HAdWKr8=;
 b=X32lZog6k5q2Du/FI2O6Fh1I1H1P1Pb6r8lgdgg0f3NxRhH/jL28yOPDj4WIe/HO25VcdV/yW7tBMFOAMMW5sDuliLPSxMaYj26zJJ4Tx83T6xLQALmfeE7h/mvODXT13Ayo4IkW0uC89ZnX+fOGUow0ffCf7UHvLYUCycSVEBvmgPS00S0/0jm2yvmFyju3BOrqswedAhB+/KGwxjLHm6wzN2hx12KVOAqCqZZJjhBB1RKlDhp2WbYluxm5qx2v2iNsLDqvVmCwB1raFZPCHq16aIFB65PRk0vsKpyldEbNTRuBVPhtsANlKdsGCx19PWYJByVs1dMnev9J9aOM+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L64u+5EsJjCC1SvaIKANFn3+kBgZlffxLL/1HAdWKr8=;
 b=u4nxvSI3KEfFOH3h9F8KcLppkz992kHMQ+CzSAnh+HVnC75qN3xxCNtFc+R7uxTyX8lMFbT3ahaOdmDDse/MO+TeqgUNqueDT/uGmZeF+J+17D9q8D4QAwAxO7Zk/wE6vcoAbCXMqe3aTgsDZES/W2Zy6NyNwEegqBSIYHfutS1buxNbpx9Cxgcen0FD8vl21PBJsL1Ui/0+/ZPlSCUpp9rdhYmTZYf7zvxR7d2h9T8AogSu5sIXVXyh9Na9SSgcKSNYr4CP2BJ1JRtExOKh0yKrhQOg1XGSzAE3abvM8rEwjCEFamG9sDIlZlHJfw6WvLSuC7JZEZG47atnQj+Yfw==
Received: from MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:19c::18) by MAZPR01MB6438.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:71::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.27; Tue, 17 Mar
 2026 09:39:03 +0000
Received: from MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::1fed:9b0b:69b:9295]) by MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::1fed:9b0b:69b:9295%6]) with mapi id 15.20.9700.024; Tue, 17 Mar 2026
 09:39:02 +0000
From: Aditya Garg <gargaditya08@live.com>
To: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>
CC: Lukas Wunner <lukas@wunner.de>, Ard Biesheuvel <ardb@kernel.org>, Hans de
 Goede <hansg@kernel.org>, =?utf-8?B?SWxwbyBKw6RydmluZW4=?=
	<ilpo.jarvinen@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org"
	<linux-efi@vger.kernel.org>, "platform-driver-x86@vger.kernel.org"
	<platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] efi: Save Brightness using EFI on Macs
Thread-Topic: [PATCH v4 1/2] efi: Save Brightness using EFI on Macs
Thread-Index: AQHctfHjCufMSGihhEyd3va7QX/g7w==
Date: Tue, 17 Mar 2026 09:39:02 +0000
Message-ID: <9FF2FDB9-17D4-4B01-A872-F26BFF74C5CC@live.com>
References: <20260316153407.1781-1-atharvatiwarilinuxdev@gmail.com>
 <20260316153407.1781-2-atharvatiwarilinuxdev@gmail.com>
In-Reply-To: <20260316153407.1781-2-atharvatiwarilinuxdev@gmail.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MAUPR01MB11546:EE_|MAZPR01MB6438:EE_
x-ms-office365-filtering-correlation-id: 6859efff-5699-4a5f-dac8-08de8409064a
x-microsoft-antispam:
 BCL:0;ARA:14566002|25031999004|461199028|15080799012|31061999003|8022599003|19110799012|8060799015|8062599012|440099028|3412199025|102099032|11031999003;
x-microsoft-antispam-message-info:
 /yGhKVWAbN3El/PRngcYvL+w/BFupihqW9JS+++kb9Dw59k5k1Uel3LzwA+aH66zUQuK23WS8RaSbPLKKFNSnf7zjYn9x1XdTWScBUM3aZaQ7k4umXXQmmfVP+u2eRXaKxt/dzX58tJIBveY1gWmj4vYsQ1UgP6wNYvhZJ0e3lg15zsivuBu8JeAJmZ/4K7C6c14uQ6K76UNpOzSaK1HCpEYh4auxUdbi5XIjte1rbFx8rrQSmTjfj+X3QX7FJ/r42Y7l8jHGZtlVbS2pJdv0gPN6hLShVpj7v5ExoI2lRQbKrPnCP10NSNCs710HAYygVTdXzxibBelTyivMb+b5J6q8irIO9nVFW88bHcuFl5a1czmCiomQuB2dTkwp7CyEn/k1Xl3sul+IpJGdvCJH0cVMELmIqep2Tt77NZ04EvXinicWYF0xY1EOALeJETZJ880EcU03e7E+4Dv7zLwq5OQJNSe18e9YIHXR20SGiyCxyQEIfd1YRgPnQnKP0RoplgHmviXf+7XaAWuEOHHFAiQuJxT5b+3KRROcCXE9JvI6b97juh/27EPQay2pcQ+sVf4L8U1glrVxmDXTb76ny4ca618E9DAwpvSYxOqSnGnLDvP6h8WAvXVxYKMIoLBhC/VAIR9/nomGjXm0TER1zseTAHCtoA9O7c3Bfmz78aV1DoQM4qwuexD40dNIqsrBjDGX241N6zKj/M4HpI737mbcRkPfawKa2poB43tbQp46eFzXicpbzhGwJmhRTd243nfol0MT4YUw9dSSYsp6bzJWNlc6WrAdyCjBPdfV/ezP4tj1CMBP7GMU+XvYdzTA2auMANFcfDiEpkJZ6yEw/BoxLK+mo9c7jqCMGBs2SO65nUZ9Pdpajs2vu4sZjVGFd3NpUiOzwvMhkrqZ31GgzWJg7Y0jPhcgXEkymwxA8Ol6vglAeDzPj+D1KqdAzRc
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Rk5jT2NETUloYWUxdmJhbXVtbW8wZ1YxWVdBRDBRd0ZBU0JpTWtKcWVDLzhw?=
 =?utf-8?B?bTZIVGdyQ21VMFM3dmZNQktRekxCY294NWR3RDc2dnllSHJzOE9xTEE4VWVa?=
 =?utf-8?B?WldmdFFDb0FFTW9xWEJWUDVDZ09JeVRWZCtKMEpJNldVMHFIRXdDa25JeFdR?=
 =?utf-8?B?OVpnQ1Z3MWcxZEtxcHJpLzc2QWdNY3lQVk1QcmdBSnNicFFNUHNVUmNSZkky?=
 =?utf-8?B?bE5sZDBGSjFJSW5KWURuTjJRTHkvUzI5TVVRdk14STVtTDF2ZVFhMk9lMkJJ?=
 =?utf-8?B?Zkl5MTRUMEthZk04NGYyakllYXdDazRTeVhXTkpheHpkSzExSFpaRG9JNlFM?=
 =?utf-8?B?c0NXUGVhcHdsenBwTEdQK2dJZWdLWXMyZSsyTGtwTlk5UU5qdnlaZEF6aUJn?=
 =?utf-8?B?eW5iZ3B5QXlxT0lWbjRjakM5QTJ6TTIzS2ZyRUczbW9zYTY0WWN4TGc5N0x6?=
 =?utf-8?B?V0NxbjNSWXVXUndXbTJtQ3luSEhjNU1hWVNOUmZkb0J2Tjg0K2ZwVm9XbFI2?=
 =?utf-8?B?QXFPSUlXWXhmNXRzc1RFd2tYRm5sQVlIcS91VTQ5RUphUi9yWElZYWladmRZ?=
 =?utf-8?B?TjYyRHJjZXlBeWJmUWZDLzcrMm95MW8veTVETitCaUNrbm1MV1lEQUs2b08w?=
 =?utf-8?B?c3FsMWZlWkUrbjQ0Q05ycWh3Q0NVeEUrOS9MRUMyNUFkcnA0K2RCY21Xbkhl?=
 =?utf-8?B?NFVxaGhNYjNSY3dYbHlyU0dKYS8xa042cEVUeGdCSHlHMm9SWXJoVEgveC9I?=
 =?utf-8?B?NGxSZk9GbEJrZjE3M1dhUTlxN1RyNXg3ZGVYeTRhSWlOYzRnQjJEQ2JLZVBF?=
 =?utf-8?B?VUg1bEVsdVhOK29Ra01BMDE2OWVRQXliN3BpOVR1ekJkaElkMlNsOXBRVHpF?=
 =?utf-8?B?RzgvQTQwQkV6TUJKUW9YemNlSFpzRWRPTHBXM0NGR2JITHRFQS84dzJrWEpW?=
 =?utf-8?B?ZTM3cnY5Uytxd3BpK2lpVkY0b0dzcDVGUld1THhuZWpQU3dwWjJqY2plQUZU?=
 =?utf-8?B?NjlMaG5CZ0VKSUJZcW9IdHVVWmhvZjVxenI2SzBIM1E1eC9VZCt2VHZhUGVC?=
 =?utf-8?B?MW5TLzBGcWtaRVBGbTFFYllDQWtwaDJYUkhoSlNZV0YvSU8rUWlmbU9xU21O?=
 =?utf-8?B?TmpvRXNLVm5YeStkeUN0TTQ2K2tMY0ZoT0tLQTRwazNnNllJc1VxMmtXQk0r?=
 =?utf-8?B?QmN4RkpjbWxEVi9tc3MwU3hSWHZQQ0RQNC9mcmV4SzlOK2lZaEIzeVFvZEZ0?=
 =?utf-8?B?MktXZHI5czVtSmFyZTNDanlCMFUybjhNa0U3cTdHVG5hdHhnSFZXZGxqbjc5?=
 =?utf-8?B?aVdRTVZwL0t6cGwrcU84eDhLcGhUNXBvdnd3UXgxV1RWai9IQmFLd096V2hJ?=
 =?utf-8?B?MFJlUFZMSmxCK1F0Y3lmSWtBQjBEMXRnbDZSNXFFd0FWY3AyVEp4aGNPUXBN?=
 =?utf-8?B?dFhEb2k3UTZCZmpzWnp5d3Zsb2tpYmhDRVRoZ0NQTUNUb2dXZ3NQNHVvc2hp?=
 =?utf-8?B?M2hlcEZmMHhXSTE2YTI0MEF2Q3NnMHIvU1VOUld1YlRuT3RaK3MyVzJpNlJk?=
 =?utf-8?B?akw4bjRuVmhsZHFYN3ZPYXpVY3QvamdHNllvc005TFZCYzMzYXQ3RVUzNDRB?=
 =?utf-8?B?VmpzT1BON1NLdnVxcjBacFh5NU5QV1hudXlUREEwR2NHZVFVQlN0Y0dyaWt4?=
 =?utf-8?B?U3RDZjNKT0pGemZoZnlRRzl3TXFJNVY1ZDRzVXlqK2JnSTR5OVNPOVdzcmZV?=
 =?utf-8?B?YTc4VGNOWllVWWFwOEc5Ry9SWmpkK3R5OVJOQTRPbHVxSmF5N0hOOGVJYXRk?=
 =?utf-8?B?YWVlMVcyM1NsbEdkUUhGcDcvaUl3R1FNWjRjYklOd29JeFFpNFZ1M1dxcUI4?=
 =?utf-8?B?ZkxjMER2RnNNZmF3NnQvS0R0Y3o0WGc0MldQWEVHT2lBY3VMSi81T0ppdzJP?=
 =?utf-8?Q?1MP+eVFlPpo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9A4D2D3A51E6964D80537510EFFABD1F@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-63b91.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 6859efff-5699-4a5f-dac8-08de8409064a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2026 09:39:02.8230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MAZPR01MB6438

DQoNCj4gT24gMTYgTWFyIDIwMjYsIGF0IDk6MDPigK9QTSwgQXRoYXJ2YSBUaXdhcmkgPGF0aGFy
dmF0aXdhcmlsaW51eGRldkBnbWFpbC5jb20+IHdyb3RlOg0KPiANCj4gQ3VycmVudGx5IHdoZW4g
YSBNYWMgcmVib290cywgdGhlIGJyaWdodG5lc3MgaXMgbm90IHRoZSBzYW1lDQo+IGFzIHRoZSBw
cmV2aW91cyBib290IGluc3RlYWQgaXRzIHRoZSBzYW1lIGFzIHRoZSBsYXN0IHRpbWUgdGhlDQo+
IE1hYyBib290ZWQgbWFjT1MuDQo+IA0KPiBXZSBjYW4gZml4IHRoaXMgaXNzdWUgYnkgc2F2aW5n
IHRoZSBicmlnaHRuZXNzIGxldmVsIHRvIHRoZSBlZml2YXINCj4gYmFja2xpZ2h0LWxldmVsLg0K
PiANCj4gKHRlc3RlZCBvbiBpTWFjMjAsMSkNCj4gDQo+IFN1Z2dlc3RlZC1ieTogTHVrYXMgV3Vu
bmVyIDxsdWthc0B3dW5uZXIuZGU+DQo+IFNpZ25lZC1vZmYtYnk6IEF0aGFydmEgVGl3YXJpIDxh
dGhhcnZhdGl3YXJpbGludXhkZXZAZ21haWwuY29tPg0KPiAtLS0NCj4gZHJpdmVycy9maXJtd2Fy
ZS9lZmkvS2NvbmZpZyAgICAgICAgICAgICAgICAgIHwgMTAgKysrDQo+IGRyaXZlcnMvZmlybXdh
cmUvZWZpL01ha2VmaWxlICAgICAgICAgICAgICAgICB8ICAxICsNCj4gZHJpdmVycy9maXJtd2Fy
ZS9lZmkvYXBwbGUtYnJpZ2h0bmVzcy5jICAgICAgIHwgNjcgKysrKysrKysrKysrKysrKysrKw0K
PiAuLi4vbGludXgvcGxhdGZvcm1fZGF0YS9hcHBsZS1icmlnaHRuZXNzLmggICAgfCAyMCArKysr
KysNCj4gNCBmaWxlcyBjaGFuZ2VkLCA5OCBpbnNlcnRpb25zKCspDQo+IGNyZWF0ZSBtb2RlIDEw
MDY0NCBkcml2ZXJzL2Zpcm13YXJlL2VmaS9hcHBsZS1icmlnaHRuZXNzLmMNCj4gY3JlYXRlIG1v
ZGUgMTAwNjQ0IGluY2x1ZGUvbGludXgvcGxhdGZvcm1fZGF0YS9hcHBsZS1icmlnaHRuZXNzLmgN
Cg0KSSB0ZXN0ZWQgdGhpcyBwYXRjaCBvbiBhIE1hY0Jvb2tQcm8xNiwxLCB3aGljaCBpcyBhIFQy
IEludGVsIE1hYywgYW5kIHRoZSBiZWhhdmlvdXIgaXMgdmVyeSB3ZWlyZDoNCg0KMS4gbWFjT1Mg
d2lsbCBuZXZlciByZXNwZWN0IGFueSBicmlnaHRuZXNzIHNldCBieSBMaW51eA0KMi4gVGhlIE1h
eCBicmlnaHRuZXNzIHNldCBieSBtYWNPUyBpcyBub3QgdGhlIG1heCBicmlnaHRuZXNzIG9uIExp
bnV4LiBJIGdldCB0aGVzZSB2YWx1ZXMgb24gTGludXg6DQoNCmFkaXR5YUBNYWNCb29rOn4kIGVm
aXZhciAtcCAtbiAnN2M0MzYxMTAtYWIyYS00YmJiLWE4ODAtZmU0MTk5NWM5ZjgyLWJhY2tsaWdo
dC1sZXZlbCcNCkdVSUQ6IDdjNDM2MTEwLWFiMmEtNGJiYi1hODgwLWZlNDE5OTVjOWY4Mg0KTmFt
ZTogImJhY2tsaWdodC1sZXZlbCINCkF0dHJpYnV0ZXM6DQoJTm9uLVZvbGF0aWxlDQoJQm9vdCBT
ZXJ2aWNlIEFjY2Vzcw0KCVJ1bnRpbWUgU2VydmljZSBBY2Nlc3MNClZhbHVlOg0KMDAwMDAwMDAg
IGYxIDAyICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfC4uICAg
ICAgICAgICAgICB8DQoNCmFkaXR5YUBNYWNCb29rOn4kIGNhdCAvc3lzL2NsYXNzL2JhY2tsaWdo
dC9nbXV4X2JhY2tsaWdodC9icmlnaHRuZXNzDQo0ODIzOA0KDQozLiBJIHNldCB0aGUgTWF4IGJy
aWdodG5lc3Mgb24gTGludXgsIGFuZCByZXN0YXJ0ZWQuIEkgZ2V0IHRoaXM6DQoNCmFkaXR5YUBN
YWNCb29rOn4kIGVmaXZhciAtcCAtbiAnN2M0MzYxMTAtYWIyYS00YmJiLWE4ODAtZmU0MTk5NWM5
ZjgyLWJhY2tsaWdodC1sZXZlbCcNCkdVSUQ6IDdjNDM2MTEwLWFiMmEtNGJiYi1hODgwLWZlNDE5
OTVjOWY4Mg0KTmFtZTogImJhY2tsaWdodC1sZXZlbCINCkF0dHJpYnV0ZXM6DQoJTm9uLVZvbGF0
aWxlDQoJQm9vdCBTZXJ2aWNlIEFjY2Vzcw0KCVJ1bnRpbWUgU2VydmljZSBBY2Nlc3MNClZhbHVl
Og0KMDAwMDAwMDAgIDdhIGZmICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgfHouICAgICAgICAgICAgICB8DQoNCmFkaXR5YUBNYWNCb29rOn4kIGNhdCAvc3lzL2Ns
YXNzL2JhY2tsaWdodC9nbXV4X2JhY2tsaWdodC9icmlnaHRuZXNzDQo2NTQwMg0KDQoNCjQuIEZp
bmFsbHksIGFueSBhdHRlbXB0IHRvIHJlZHVjZSB0aGUgYnJpZ2h0bmVzcyBzZWVtcyB3b3J0aGxl
c3MgYXMgdW5sZXNzIGJvb3RlZCBiYWNrIHRvIG1hY09TLCBMaW51eCBhbHdheXMgYm9vdHMgYXQg
bWF4IGJyaWdodG5lc3MsIGJ1dCB0aGUgbnZyYW0gdmFyaWFibGUgaXMgY2hhbmdlZCBzdWNjZXNz
ZnVsbHk6DQoNCmFkaXR5YUBNYWNCb29rOn4kIGVmaXZhciAtcCAtbiAnN2M0MzYxMTAtYWIyYS00
YmJiLWE4ODAtZmU0MTk5NWM5ZjgyLWJhY2tsaWdodC1sZXZlbCcNCkdVSUQ6IDdjNDM2MTEwLWFi
MmEtNGJiYi1hODgwLWZlNDE5OTVjOWY4Mg0KTmFtZTogImJhY2tsaWdodC1sZXZlbCINCkF0dHJp
YnV0ZXM6DQoJTm9uLVZvbGF0aWxlDQoJQm9vdCBTZXJ2aWNlIEFjY2Vzcw0KCVJ1bnRpbWUgU2Vy
dmljZSBBY2Nlc3MNClZhbHVlOg0KMDAwMDAwMDAgIGViIDQxICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgfC5BICAgICAgICAgICAgICB8DQoNCmFkaXR5YUBNYWNC
b29rOn4kIGNhdCAvc3lzL2NsYXNzL2JhY2tsaWdodC9nbXV4X2JhY2tsaWdodC9icmlnaHRuZXNz
DQo2NTQwMg0KDQoNCk92ZXJhbGwsIGl04oCZcyB2ZXJ5IGluY29uc2lzdGVudC4gQWxzbywgSeKA
mXZlIG5vdGljZWQgV2luZG93cyBkb2Vzbid0IG1lc3MgYXJvdW5kIHdpdGggZWZpdmFycywgcmF0
aGVyIHN0b3JlcyB0aGUgYnJpZ2h0bmVzcyBsb2NhbGx5IGFuZCBpbXBsZW1lbnRzIGl0IG9uIGV2
ZXJ5IGJvb3QsIHNvbWV0aGluZyB3aGljaCBzeXN0ZW1kIHNob3VsZCBkbyBvbiBMaW51eC4NCg0K
DQo=
