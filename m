Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3584E34B1A3;
	Wed, 16 Sep 2026 18:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789582603; cv=fail; b=se5cRMhOL0y4ucofas3tkFh8kC+KXdA0lozYvmYnI0pHexqChRPhXLCQV84Gh7+ELn0O3W8nQvCya9nU3TdAb97kLV0DXz4v/1Ek1vb19SrHSnISSBpV992xI63N3wVxDbOMu00LfaUvH4D7M4kE4ly7TBEuPrztGiHXglzV7ss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789582603; c=relaxed/simple;
	bh=FaK/QT5VYyB+3mvUzTTTnBNZs7WVGH0ux3baAqSWMxQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JqUAQ+PqNgAl4lOo91qcvKhkeFJ3LoJPJcojvbXVbgU7qHpscJJ2znb1jbm2FFNI+lrlfyw9G6ph9NKDVuBkcre+cbbTwaWpvqf0OKIMYqldbbmBN7UeeVjAJh5tcoiP2h2ns+9LL2FX9Oh5vnXxoPmpM3Xdp08OmJMOHF0ukcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kevEjDMO; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kevEjDMO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789582599; x=1821118599;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FaK/QT5VYyB+3mvUzTTTnBNZs7WVGH0ux3baAqSWMxQ=;
  b=kevEjDMOpsuKos9Y1Cc4+KUxcLLqnTPFWBYSa1jOVMDNFWV78mxPdMBn
   U/qV8MGLdk/AexoaBmvSkuIemLduKwdbLQkVzh/O1N3tnyin0s4lXnx9N
   AefHegK/gOsI5FEAs0DptBk3eiJ6BM7s/nb4zh0qqNO5Bwz00WwO9Ndjo
   Klo0+JnN4vUtYLH3rRUYc9OyuXqo4zbW+fcijEh9uXtienVwDNf1VIuW5
   Zau447/M8m6xF3DD54t7yhmab9DyptK6QUcLYE4L+sRHvc2oU3+wcO/5g
   whjn3MEcEiuS7o5P6Uikxe+hJE7aEIUqS4yjRp3nGD1PQUzmcAR4UnK0X
   A==;
X-CSE-ConnectionGUID: a8Wd5DBCQ36S4C6XAQLQsw==
X-CSE-MsgGUID: 4rvi7HKESEaYHqBhBNEueg==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="89809767"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="89809767"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 11:16:34 -0700
X-CSE-ConnectionGUID: uuOm88YrRyeY71EdDtBQrw==
X-CSE-MsgGUID: jk4/Z3KZRaWFEXV4pCQvkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="271634399"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 11:16:34 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 16 Sep 2026 11:16:33 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 16 Sep 2026 11:16:33 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.4) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 16 Sep 2026 11:16:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YxB0hCjZNOFlH/Jy0yzTk4Vztl0jS2vMLIYSHin6iaNKytiRRVQrwVN+EkqzXXjrzcQVzhi++5esWCgUHq3KFsOSVEvGqfVfo4FvvqZIWNrm0+YSMsiPexHLxAcUDdHdAj/OLhvfgxlEiXV5kNRVfAtF5wffsi3aLYZXZ/jsFGpSHjs91bbRzbjCxnZ3b+xM0mLtvHmZF6ebflvIdXysLB9nqTMBaGfZUovBMouMBNESwo51UhmD0uxKgPdKc58Jq+8juhtRZLJ34I4tXr6WyR9FljdA6UkZiyahe2aIUz3dy9xHPz059Y4D4fJfUSE9xxi6IXB9DynkvX4mXvvPaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FaK/QT5VYyB+3mvUzTTTnBNZs7WVGH0ux3baAqSWMxQ=;
 b=dL9+RfOI9mmB3qxGr707N2AhXnvrGyPxW44gVizN3NrojrSlXI0oWmhYqh94ZeRtqRD9nr9mVToMXnWivCy/KaANhyWiZ34TftPUadprp3L8h8jn6wikjm5CF7VlpMhbwm5U4gmi4O5OKYLTmqu32c85MuZH2xbBQA3X5V+TqWYGbAwZ1QVN0tTnpi2iPr0fufgjgADmgxp7rJbC2DLiBhX47z7W4yxQWDWnjIeezZRvipZzyJz408+WbTw0SGbqxSs48byWMAGdFcrdt+BeuB3pXFcYAf0dc+3NPwuCMEvPbH8glsHJf6LpUzmFp8jJGlULcKGraJDs3W2l/wkl3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6771.namprd11.prod.outlook.com (2603:10b6:510:1b5::20)
 by SA3PR11MB7463.namprd11.prod.outlook.com (2603:10b6:806:304::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Wed, 16 Sep
 2026 18:16:30 +0000
Received: from PH7PR11MB6771.namprd11.prod.outlook.com
 ([fe80::effa:162e:c9c9:a1b4]) by PH7PR11MB6771.namprd11.prod.outlook.com
 ([fe80::effa:162e:c9c9:a1b4%4]) with mapi id 15.21.0406.007; Wed, 16 Sep 2026
 18:16:30 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "ardb@kernel.org"
	<ardb@kernel.org>
CC: "kas@kernel.org" <kas@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH 0/3] Move memory acceptance x86 arch code into EFI stub
Thread-Topic: [PATCH 0/3] Move memory acceptance x86 arch code into EFI stub
Thread-Index: AQHdRVw1VWonJZOLp0OnmPorD0Fzo7bRhEcA
Date: Wed, 16 Sep 2026 18:16:30 +0000
Message-ID: <af17c380c43912ce34c228e328b3937343ce2019.camel@intel.com>
References: <20260914183745.37538-5-ardb@kernel.org>
In-Reply-To: <20260914183745.37538-5-ardb@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB6771:EE_|SA3PR11MB7463:EE_
x-ms-office365-filtering-correlation-id: da90e1e9-ee30-4acc-5edc-08df141ea1b5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|38070700021|11063799006|56012099006|10067099003|22082099003|18002099003|6133799003;
x-microsoft-antispam-message-info: dds7DKJ2TwuBGvQTC+fIvOOKAeIHsk4AEtJFtypy1TC7+WvD5jj5MTZemynsLfqZhVUnDJu9vBSka0hhzamq0G6j+bZz4irSJgwBtDCP9v8k3PvCMHEd/bDDbM1x/shh1YvbXy4jVB6Zwx3Bf+looxzc6r53dOwZ5DPY1YhJBfSsCh1tACzP8/e1B51XQkWh/3cdGJacCy0wKDYQ0kdrcaAJX27gutbBCC+pF+vERmmPpeWoSa+BmlJtz5RPplu0wneP/lvGlcPtSxTx8aIlvYHBkkvBU7GmaTBzbC1WEFJ0iIk8YhAUszT6DP7BGgB6k9NszRDOczEGqyQwKf3b8c4BU3AEDQcFtPXix6JSCKFavYb3XxVaVFFRZpCfegDoapzzH/2ljdJ/EZfMrCz7HjE242ggSPb+wjcpHkCVvxgNazJbrPtY5PjbwYEUAg+mgk1pOVJoETeQDL7tM6SKSG1vO5dh4YsXAw6kCO4d/l5KD99OIByQ+RjAnUE4J5QqsPHce6nDMMQ6XXv5SinbQtaWcY3+1ri+toMBeGYywFpCjZjQYEXEvD4dfreX/K9KXyiZVQkIALrTMwzNL2j9Y/A+5zSvtETY/KsQhdauuRD9P73UtWlEP6TYIc6S2VSzjeOFdfU+sUnNXVM+t6s5BRgbpxRWQvB3Dvw2zeRfDE/2oIh8cVGjg+t6ODliY3i8Li4AyEmhvhfX9n52x/yf5w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(38070700021)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U09INnFQQkMzeUdWSkR6VGVncUZjQ3lJV1N3Y2k5ZVEySkF5aFVxS0d4TGdD?=
 =?utf-8?B?RDRURVpvMDNmSDRHR1BKRXVmSVNWZmRwMlZCV0RSV0tqQ0tOT1R3YXM0dmlN?=
 =?utf-8?B?MVA4VjZiTXZzQW80bHlrVVp0djA5TGhYRVdDZit3SG5yeWJCZ3c0ZXl2UERr?=
 =?utf-8?B?MXdmQkJEZVhsRFMwUW5JZFd1R0JYSnFyR01vQm1rVXYzaW05a0tjbExHcjl6?=
 =?utf-8?B?TC9BWTh0WGMwL1BtUHpjTndPelhJUDNzMmRhamdVYXFJK1dxUzhEc25qVndI?=
 =?utf-8?B?dGJiUmZxdEFJWlhva0ltS3Fyb3pmekoybTUzVFBLamF0YUJLUENwZ1AydXZX?=
 =?utf-8?B?OVR1c0JZUmJ2eWVLekwyYWhLdWVOL2xuR0ZyVmNRcVdrN0xYK2JzTGxhQTVS?=
 =?utf-8?B?UUUxZ1hNTm1FZFIwSkJ4azFlcTVmUGJZbmVnQWFJWUxteW1wYm9Dek1jbm9v?=
 =?utf-8?B?cU5US2dsSzNaYmdJenptenIvc29HMlVlMWFha0RydFd0a0ZQUHNITVVyaElU?=
 =?utf-8?B?emNlKzAvZVJKWkVQUFhHdzhIUk16c1pOeTRyUU5Yb0hDQi9NUSs5dzNRSm45?=
 =?utf-8?B?bTJPdTgxN3VXZGdyUXlZbXJnYTFZMW9XeW9CRUxEMG1WWjM5ekZaMjdkOTgx?=
 =?utf-8?B?Sko5YlVneWloTzEyY0kwMHM1Z2FPeHFudmczdnVVS3BwMnNndWNNZ3FVUGRt?=
 =?utf-8?B?R2lRc1BLRHZKQ0ZDbXhNVzk3amVweVd6bjNpazM0Y0p3Zktock5oWnZTM2t6?=
 =?utf-8?B?b2N0UW5Ob2VIWWJSUnlYNmozeHBjYVJYK2lQQytYaGthQWp1Qm91VHk0WENs?=
 =?utf-8?B?OG9iM25lZndyZ3c2Tk5FNU5Hd0E1dWdsTUpMSFpLTS9qcm45Nko5RDRXRTlh?=
 =?utf-8?B?MlRMeFJIc2lKdnMxaDh0MmFCclFvUk5RNGpFRE1WVVA5VkN2Rm5ydXpyajBW?=
 =?utf-8?B?T0JERlJHUU9HTjRGOTVGcGZDdEJ2Qk5QYWw2T2dRaVZXTTRDOGJGZjV0a1A4?=
 =?utf-8?B?U0FYYXhQa3cwc3VWckprVlFxWkNFZ2F6Q0ZBa05yOG9xNnlianRjYTR1a2Z3?=
 =?utf-8?B?Y0FlUERuWUxXbXRHM1VXR0szRFhpekgxMXIzcWl3dTE1TFhWSEhWN01Dbys4?=
 =?utf-8?B?UytNSFRFeFJoeko4S3p3Sk9zZTVlNEpobEVXaVM0LzFibFlmY0YxK0gxakVJ?=
 =?utf-8?B?NTNseTdiSU9kS0dDcm96d1NUaUljODRuZ3hJVHgxUlNUbHFqK1hraVBQZWRq?=
 =?utf-8?B?RERpM2VJTys2QzEyRCtBNHh2ZXRyaXJsQVNEM08xY0xRMVdIbVJkRnRpdEVI?=
 =?utf-8?B?ck1wZitCVXFSY0FJem83QUQ5bkZYam5NZDFwa1RZVFhzT2NxWThCc2NOVGZw?=
 =?utf-8?B?NTZiSHNZMjMwZmo5TTUvMERUY0kvQzZVbDh6aFpwMHlOME1aVCs2dUpxeTFX?=
 =?utf-8?B?dXZ1UWUxampCaCt3QWluVWgvblZTRlNqNkl1TE5DS0tSY1NQQmIwd3Y0SFdj?=
 =?utf-8?B?aWNoZWRvdHlPbTlybGNrYS9LVTJsV2F2NHhxengrVWRoRmdJOFB6UHpXd0tH?=
 =?utf-8?B?VGNYVXgweEc5RW5ER2VRRkM2MU9OWXdIVWlGZVJ4OC96MGpoWDNTbk9lckpa?=
 =?utf-8?B?TmVwUW5hdE54eXRqb2hKRjdYbkl0L0Z2YWNsSWZ6a1FoMkR1RXJoUEwrbWJN?=
 =?utf-8?B?RkIrMXRCb1A1UUQvNG1BTVp4WkhITXRULzJyMXFKa242V3N5bG9ETUUrQi9q?=
 =?utf-8?B?Zy9vc1FQMHlUaEE2UUFMcUZockhSYlBNZ0dWMm9GdE1rWjhUeTJFNUNjZURQ?=
 =?utf-8?B?K2s4QXFyQUhRL2FjcVBvRjNzaGI2QWlMNjZ2NWRyTktUSjV4eksxS2lWQXQz?=
 =?utf-8?B?VUpDUGN3UDZCL1BzZHFaR3pHZzRSTmJNdzU1UmNjSzlkYmsvaTEwUllKNVNi?=
 =?utf-8?B?eEVYY0k1aDFXbEM4UC9MTHNSd1ZFbTBTekxIYlRFOTBRZ2o2WVY3QXZwVTVN?=
 =?utf-8?B?Y3RnN0wvZlYrR0dtMlJucDNjc252TmgyaTNoa1RqMmxmSGNEZ2tGMTg0SHgy?=
 =?utf-8?B?Z2JrYnVIU2cvL1JseTZiS0lxWkNsaWp2MlJEbng2a2VQR0ZBMmEvL0dzWnFN?=
 =?utf-8?B?c2ExWmNXNjJsZXFIRHE3WG9OUFZyN2ZtbUpZTjViRHJSU0tQR0tJQnpwekt4?=
 =?utf-8?B?ZW9ueksrWmszSDhpaUd0OFlKdDEwT0pYWjNTVTBCSXhnSkw0bkZJZllkL21o?=
 =?utf-8?B?YkFDd2RjQ0I0QytvazYzV3NCSU8vZWRqbjVLRGFNeWt6RGQyaUo1OHQ1NVhl?=
 =?utf-8?B?bHVrRG9rWTVRMEt6MGlUVTZIeFpJRldGTWtVQUorK1FFdk11U3FPWW40aTAx?=
 =?utf-8?Q?eT+fwoDGZpMGWQxE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1FE5B4E734226147B01E95D3CAEE38EF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: NI6h2pf/bFjJF+t65Uc/3DAhUY0GOBplVAY64bk4Xseb3MoyOSs5JN3iXY/PvFtT2J13uM5WVtTh5gbpk3DJlwKNHp0c4x0K0XI1Pp8OGjwA2KD6N3rua/LFs0nAiLIB3MdyBi9T0aHFC1CkfS1hgmGCVd5LgAk5tfi3V+kKve2gFHXGnsF9YVa2ENZ4bnRMpu20Fn6jDgK1qYi+WjOnLoKa7j4Ija7z7zrGsgX5jSDWGQqXm20HtSUdu6DVQffwERUQyWEnMOxg+Zr/uoAjP0Ld+SevF6tm9/5wq/b1MwJb2TG1+OroXQUa9KGmmPQ7+xMafQtpCznviENYP2P8Tg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da90e1e9-ee30-4acc-5edc-08df141ea1b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2026 18:16:30.4393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3I/ZguGof3Ju/5sQmIgb5djwttnRsrEfgAeuj1z0Dppi5QilBMBDylU9ucG4MPrxj7ns4PFNletR7ourA7eHobnKnokMrs9bhMmQf9uyBRM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7463
X-OriginatorOrg: intel.com

S2lyeWwsIA0KDQpPbiBNb24sIDIwMjYtMDktMTQgYXQgMjA6MzcgKzAyMDAsIEFyZCBCaWVzaGV1
dmVsIHdyb3RlOg0KPiBUaGlzIGlzIGEgZm9sbG93LXVwIHRvIFswXS4NCj4gDQo+IE1vdmUgYXJj
aF9hY2NlcHRfbWVtb3J5KCksIHdoaWNoIGlzIG9ubHkgY2FsbGVkIGJ5IHRoZSBFRkkgc3R1YiBh
bmQNCj4gbmV2ZXIgYnkgdGhlIGRlY29tcHJlc3NvciBvbiBhIG5vbi1FRkkgYm9vdCwgaW50byB0
aGUgRUZJIHN0dWIsIGFuZA0KPiBhdm9pZCByZWx5aW5nIGRpcmVjdGx5IG9uIGRlY29tcHJlc3Nv
ciBBUElzIHN1Y2ggYXMgZXJyb3IoKS4NCj4gDQo+IEluc3RlYWQsIGNhbGwgdGR4X3BhbmljKCkg
b24gYSBmYWlsdXJlIHRvIGFjY2VwdCBtZW1vcnkgaW4gYSBURFggZ3Vlc3QuDQoNClRoZSBUREcg
YWNjZXB0IGNhbGwgY2FuIHJldHVybjoNCg0KVERYX09QRVJBTkRfSU5WQUxJRCAtIFRoYXQgd291
bGQgYmUgYSBidWcgaW4gTGludXggVERYIGNvZGUsIHdlIGRvbid0IG5lZWQgdG8NCnBhc3MgaXQg
dG8gdGhlIGNhbGxlci4gUHJvYmFibHkgZG9uJ3QgbmVlZCB0byBoYW5kbGUgaXQuDQpURFhfUEFH
RV9BTFJFQURZX0FDQ0VQVEVEIC0gUG90ZW50aWFsIHNlY3VyaXR5IHNlbnNpdGl2ZSBlcnJvciB0
aGF0IGlzIHRoZQ0KZ3Vlc3RzIGZhdWx0Lg0KVERYX1BBR0VfU0laRV9NSVNNQVRDSCAtIEFscmVh
ZHkgaGFuZGxlZC4gU29ydCBvZi4gTm90IHN1cmUgaWYgaXQgaXMgcm9idXN0IHRvDQpTLUVQVCBw
YWdlIHNpemUgY2hhbmdlcz8NClREWF9TVUNDRVNTIC0gQWxyZWFkeSBoYW5kbGVkDQpURFhfT1BF
UkFORF9CVVNZIC0gQ2FuIGhhcHBlbiBmcm9tIHRyYW5zaWVudCBob3N0IHNpZGUgUy1FUFQgbG9j
a2luZy4gT3IgaXQNCmNvdWxkIGJlIHRoZSBndWVzdCdzIGZhdWx0IGlmIHRoZXkgYXJlIGFjY2Vw
dGluZyB0aGUgc2FtZSBwYWdlIGZyb20gZGlmZmVyZW50DQp2Q1BVcyBhdCB0aGUgc2FtZSB0aW1l
LCBzbyB0aGUgZ3Vlc3QgY2FzZSBpcyBzaW1pbGFyIHRvDQpURFhfUEFHRV9BTFJFQURZX0FDQ0VQ
VEVELg0KDQpJIGd1ZXNzIHRoZSBjYWxsZXIgY291bGQgY2FyZSBhYm91dCBURFhfUEFHRV9BTFJF
QURZX0FDQ0VQVEVEIGVycm9ycy4gQnV0IFNOUA0KZG9lc24ndCBkbyBhbnl0aGluZyBmb3IgdGhp
cyBjYXNlLiBJdCBzZWVtcyBsaWtlIHBhcnQgb2YgdGhlIHByb2JsZW0gaXMgdGhhdCB3ZQ0KYXJl
IHBhc3NpbmcgZXJyb3JzIGJhY2sgdGhhdCB0aGUgY2FsbGVyIGNhbid0IGZlYXNpYmx5IGhhbmRs
ZS4NCg==
