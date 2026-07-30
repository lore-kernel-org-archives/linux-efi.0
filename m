Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CD239022A;
	Thu, 30 Jul 2026 06:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785392118; cv=fail; b=M89ursRe2M0n4M+N/+YyNQT+DGjEMPiMRgKTwdi+aC+J4UfTY2r3xvMG1TApAI1yRwEQ60d6nOWl9O8OmtHrrxRhE9n6E+ADWr5wRjnSPgqaQ628q2OfOI4CFdTNZYVbYdbGkF+PY2qV8Fx1T/CuqcBHlZDHMXBq7HZthj8W/Z8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785392118; c=relaxed/simple;
	bh=KteWqvLmCAZTXQJp9z8kltvbYgXfEjZa/IOWPNfOxhc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BuOrbIjfXfJdu2U2BZ2MlMJosFfm1n33bMpWVSQEPpvQOIxpPumoBJg4j95JEuj7kmtOobHSrwF48EElTbQvuuoubsZnphqIxE0iLOsDX593gF6o49ovZE+6HWm819i6NY+EKvy4tVM1HFknihjKAp7PMrmizaKee94oPA5mqNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R8zocT5S; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R8zocT5S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785392114; x=1816928114;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KteWqvLmCAZTXQJp9z8kltvbYgXfEjZa/IOWPNfOxhc=;
  b=R8zocT5SSiEJRozZ4DHYBc1ZHZkTGgpnaAbK+gqnp6BH9zI5ULPRNE2y
   dtisB7to9U7PULHNlzU48AJMnPJIEbAOPV1E1vfNtly74cM/WN6Xn08bw
   s3dJOmlW3vjbgsIP4Q9i+noANDFJSK6Ih39689gYnZF4SEteIcYyTgVgW
   dtl1E+rE9maZIPeY8ZUpnpOHyJreYCW4aDGo3vpTjAJ3x6MGTyPaJ/TNq
   VWll8c7hf+84+ls21xY9Jn1uEVkGfEf/sFvfJiNSBWrroORjv9+ix0CPn
   hPNk2kFw9Zpz/4aE5ZLCJ0ZHXouqCFs+x4EowTUlc7y4yAD1nXYBZy/aC
   w==;
X-CSE-ConnectionGUID: wZ+lnR+xQ9K3OVQ/vf3GKA==
X-CSE-MsgGUID: pNcaOr/RQRKQwQrARlgQ/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="73539648"
X-IronPort-AV: E=Sophos;i="6.25,194,1779174000"; 
   d="scan'208";a="73539648"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 23:15:07 -0700
X-CSE-ConnectionGUID: mOGKFEPpThGqi7zUPe5Dgg==
X-CSE-MsgGUID: lALF2Qw2SOeiOYMQDky4iA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,194,1779174000"; 
   d="scan'208";a="259633071"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 23:15:06 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 29 Jul 2026 23:15:05 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Wed, 29 Jul 2026 23:15:05 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.25) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 29 Jul 2026 23:15:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H9KF5jbeGmp2+nuImIChAbLxQeW6sK9FHB+ErQOVhADazpjhkBaXhf/gpNbyjo9UCCaphOJfLnXK5NEIxXba2U/LbgRKpZzrdaeNlHmhhHRUMBCHQ83XXi6/AQ2frqOg8D0VnW2Rabw+Vv/SYKcPmZC2fHFaGP1217/TOb15pOtj7m012BgZNToWmn4TDRoxAu7jW1/jhZTrpcq23MQ310ozTOLlo1211Hs50MoCn6OgAZ2qVdilk/5E1dYCGfz7todsMISLiISHqiWhgqiwMs60XzvqyOmISEMhvTXpkEKYh7xu31BoZX3fJMNAS0zZQjlRTuxroNfNrw2B6heBKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b2m/MhPF9c/yifFjQC7P8dOj48ZCyJJuHtWyCB+pPxs=;
 b=VZv2U1GIlaZllQcPrqi6JugCy4VWI/nBEoOotkGCEo9B8uiCOCekoy1bOk7R3Mx0IhoKRMP2R3CoEMrNeZo4B0i3t4Svnr/RTCXhE2STLoZnw3lEfOJEke9UBHvxenyrOtP89kW3EV9pvHG25T6TPvMVn73JuK++BvtQDDxTlm3WxSP+js345yfiWj5/pBYk1NqeFyS2OQ/UkmLl8F5lexhtbA0wPycJ8oKzLzc0qNvG4/77KupRyyZvikuTtliqqIGoFn6fzNzqlFz0NjOaaPV3yP/1DxG89Nqd0i/uFfiIEddi2w8pP4m6wk+cy3Znywfp7uzx1q00Ev1OVu3deQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB8134.namprd11.prod.outlook.com (2603:10b6:8:15a::9) by
 SN7PR11MB7465.namprd11.prod.outlook.com (2603:10b6:806:34e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Thu, 30 Jul
 2026 06:14:56 +0000
Received: from DS0PR11MB8134.namprd11.prod.outlook.com
 ([fe80::d95d:cb19:df8f:1610]) by DS0PR11MB8134.namprd11.prod.outlook.com
 ([fe80::d95d:cb19:df8f:1610%6]) with mapi id 15.21.0270.012; Thu, 30 Jul 2026
 06:14:56 +0000
From: "Chang, Junxiao" <junxiao.chang@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, "linux-efi@vger.kernel.org"
	<linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: RE: [PATCH] mefi: add dynamic control interface for EFI runtime
 services
Thread-Topic: [PATCH] mefi: add dynamic control interface for EFI runtime
 services
Thread-Index: AQHdGm23/jQpztcApUCiO3umY/A0pbaFnq/w
Date: Thu, 30 Jul 2026 06:14:56 +0000
Message-ID: <DS0PR11MB813414CE40CBBE6A38386D96ECC92@DS0PR11MB8134.namprd11.prod.outlook.com>
References: <20260704003341.3923900-1-junxiao.chang@intel.com>
 <d107385f-1c58-4aa0-beac-7d536d064600@app.fastmail.com>
In-Reply-To: <d107385f-1c58-4aa0-beac-7d536d064600@app.fastmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB8134:EE_|SN7PR11MB7465:EE_
x-ms-office365-filtering-correlation-id: 1bb1530f-0aca-4ab3-91a4-08deee01e0a2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|38070700021|11063799006|4143699003|56012099006|10067099003|22082099003|18002099003;
x-microsoft-antispam-message-info: dGOwqqB1Nmgb6hObpm0AAn5pHVaKufyGgc3AzZ+ra2n8SomA3ca9KSIT/6BhVCR6KPt2qkmHPdvfNvl1P1Ns/04cMZG8crVrFNqHG+DY1lNCHN7jhyrrsEGsfzEbFbJ87y3R68WiP84dQut9tDQsYac017wbnAnE552LfRp/VWAEjHyy/5gWIk8xBNPT0vRH8VcWGvpO+tJGoqTD59DqwVs89pxTIepJMQ0drgeILinVEBCi76YzPraNuZwOX8v5kmfLyPBR1JzQncsw35U7MMCNDaaH0SBJehXh0Xzvlu2olBszWZBJ8Cx59w7NaiV8akalEuoV/hszynkEw/eXjI1pwusOfOxkg2Y7G6W1ng6JP8VKb+zhyw8+PceLFKGlmS+ba94OaV93y7yBxBo2DMgLEvRkHPvaN+dQEJf2bHaK/sjCXANQMewKQgOpBQTp7AI9oBiNVGUvE+3Tul/dWh/buBWbe9pZwfqwKGrzxQ4jM0XwaBIfiRqabgEY0US3G6Dv60m00068FlP/ckhY9Tbii3eSc1OMUYDsjqE8Iaf+wzKVvIZbxYhyyje6CIo1GXAyKHCLLwzpOyi0zdtLoIRc15fJQ+rWevbWz8TVlaME3d1qWrFXqmGfjL+Y5pQOyhkctaHu5N8WTwOqxfoGr9kReLyHSJRWutnuxID9a6AfDgTB6WNW9D1JpCxxmqFBYu45HQU1L04NUIwlZh/T4G9Cz3BFVLIHm5nvfT0VbGg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8134.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(38070700021)(11063799006)(4143699003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pL+PCowo+Rg8F5a8bP3rXZfL0SljmMPHqxQGdDn7RX0VtjK+aFwwVjEFRM1O?=
 =?us-ascii?Q?lrJf2mp81ZwU9yniayB5fw5TXVxZjEnBByBmU8ccN7Diq0NfBYTlMQclfgK6?=
 =?us-ascii?Q?8TwSL59puncdrzl+MeTncue2gm2iv3Fakxdp7g9DD09u5zKp0HRUZrMTZlmy?=
 =?us-ascii?Q?8KdDFIjxAJO9SExTunDLyQ7fGD2NBjaveV84/Nm9uQP+hqUlYc96FzTcfjhD?=
 =?us-ascii?Q?iTgDVU6oit6ePVcl5l/At4rX1ZcyU3i7ymAhRQwWTlTemQ4mLlu+7PwDU+M7?=
 =?us-ascii?Q?Vl3pzKGzy1g8xwIIEC0FVKZo0AJ9Ad09ZWuGkA661tsLMMLQGf1fXLapggl1?=
 =?us-ascii?Q?V/Rrfsl9gupscoNXDbTIvwhGP2SEg+WpJDClygwLptqC9xar0knZXBSFMPh6?=
 =?us-ascii?Q?LIQnfNZpkzuykIi0VfFpB+o1TgNZvymgRJCCJscrjLg/dBLjezQyvoe3S2tS?=
 =?us-ascii?Q?+CF2ejNCE46EGNBeRFAD1yejN30xluXzVHEwxhU3oegWf4zzwmtWeVEwMGW4?=
 =?us-ascii?Q?UXRgyq1aMOtXiqhEkL7DRzzu5hjHw3MjUbWHGT3/jjfa7JUsgaZOM2MZMEBv?=
 =?us-ascii?Q?uqCrkle/UFQkBCeAF+nnlmHzeWRzsw0NJUxgPTO3J2z6pZlZyw7QvvRT7YPc?=
 =?us-ascii?Q?qZ2q+G95ZWzODKXWb4I8HvTQ7vf/LSaWSTcXv4HoA/qoqkSlxXr3XiyeDvNJ?=
 =?us-ascii?Q?XwytzcvDfLHzSBBWWRzcLxRkyqPn+Fnl4ZzCmRIx94QbI/srapnAtjcE9ogW?=
 =?us-ascii?Q?9ZUsFFn25FF1ps0fI1Rjh/gpcb/EB3A3SHf1wLF8H6LYTR3CB4KlIbNVptAH?=
 =?us-ascii?Q?HoBa0oO7yXWABpABLYnnTlA9SG6hn0L1dASbPrlyK7z9+s5jGfRDz4YzFynx?=
 =?us-ascii?Q?K7iCM7PNKXfH7QL2ipToubYW1AFs1Z+lP+tt5z0EzKmRAcNY8gjs3DjlveKq?=
 =?us-ascii?Q?xZHebvdK2pJkRNoDCukJbbVafjjVq6o6YF8ok2HAWGAQHLkmTAgzc0aMb5ai?=
 =?us-ascii?Q?vKyf4Buy5KuxkDTTYXVm89Pcj/CkyHaA74MX2zIIID5Aw0Autl8V1k+nZxYs?=
 =?us-ascii?Q?daRf2GMftPQRXGrVhhFIBBDD4WuQK7S85hj6PXdKV6B1/Hm1mD1V10OH67Ue?=
 =?us-ascii?Q?sg1h5gI3IfynwUdLYqPePYKnp8BejkeNwtoW3u/ToYdEbZKUUvzXs8QsvA4D?=
 =?us-ascii?Q?bYoCN77Qrvw08qTvKhqDc1jQKcXz02lMiiFLVGdYqCqCDblnU2QTWyg9Ir97?=
 =?us-ascii?Q?Z0bwcZZPihn6O5xAWi6Y06R+obQv8RprFZoYgf9SHxXgcvX3Uz8guPw02pNy?=
 =?us-ascii?Q?I1Ydgw37d92ZtayUimBmJC+rnc70+pG/zuDguJxC34VIJyYVEiKa6S3MPAqg?=
 =?us-ascii?Q?IKbafbeOBDC7x4SyMc1FfRfg3p5b+tZRh4dv3GUbdCyUSu5lQEYwX8LkrHNK?=
 =?us-ascii?Q?OhcWfhNSXl2Vz4glPT+UdMf/bhEeggvdGqHFEe/cgja1KPFPEIhJp0q/0Tb/?=
 =?us-ascii?Q?V1Z6QENrsmKj6XWrTiaCOeFCgOJ68tT/XNfYFne4UbpGXes3N9M+egZA3xrK?=
 =?us-ascii?Q?OHPCmLOWiMozXN2xlG5buMibfEdsZK6ds5uz7h7DCmS50m3iPC/6pqsdmBwH?=
 =?us-ascii?Q?cv9lLOIl8yMo1KeW0B3JtKzRyjdl5Xnr7BzvNAZNVngHuRNnsYEYOCkrZxdd?=
 =?us-ascii?Q?SeWchtIqHyumcPs4jsUgpGQPldaFEm+k4gCNL+ySrRyRkcjspFCKzwHIFTpD?=
 =?us-ascii?Q?FSbAQ7+5WA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: FsQN0yqLeWvDMj9xD1FL83hdsgPw7tHpekPxdTEdq7XMqpwNP2hrpE40slnEN4q2lJIMQSgM1apOykYbpegPrxH8So52/jhlo77ZRwWz+FO48FhDl8Vs9oymIlgbHP+j0XFlp4tQfaXVhZsEb178ZIKYDrBX+aSw5iytGwu2GFpFazeoi7AtQs4pXtZ9KpYgy5yFcuqEH8iE7EdDTsdSv8c6N0t+QAzJnV6aiuBFwXf1A2iLtAXYkcebgvofg8hXu4f3OZ73dReLV76/L8al2UnrYCBfzWlh4FhIgsuEse1U/WtuZqlE2/iKSJjv0DLgsnIFN+0hqDUCAAWcvDFR9w==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8134.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bb1530f-0aca-4ab3-91a4-08deee01e0a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2026 06:14:56.3683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QCkk46R48IOpkmvAuROPUfOwi4PWgHRVwY3SXomk5hvnXVOXpU0PrWTBAOvvNxJXIjeng8bp59v+/MLw8tx2dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7465
X-OriginatorOrg: intel.com

Ard Biesheuvel wrote:
>Subject: Re: [PATCH] mefi: add dynamic control interface for EFI runtime s=
ervices
>
>(cc Sebastian)
>
>On Sat, 4 Jul 2026, at 02:33, Junxiao Chang wrote:
>> Add an interface to dynamically enable or disable EFI runtime services
>
>I'd prefer not to add a command line option for this. If the sysfs control=
 is useful,
>we can enable it unconditionally, or depend on PREEMPT_RT.
I will remove cmdline option and make it depend on PREEMPT_RT. Usually EFI =
runtime service takes 100us to 2ms, it is ok for non-rt case, but it is a h=
igh latency for RT.

>
>> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
>> +		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
>
>This is racy, no?
Is it ok to change it with locking "efi_runtime_lock"?

>
>> --
>> 2.43.0
