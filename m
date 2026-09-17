Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178481714AA;
	Thu, 17 Sep 2026 18:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789669808; cv=fail; b=mF2z8rIOw1XqEbkjxW9bvwzfMnlOMbKhGhhVhJxjpC/zI3RnLlsL40vamwAUAZBRlRZTPEaI3zYjMQwlj/P6m4oJAEHx7hi7nxu7Y390UyAjOPOwLz5/LSOtzqc/UD0xX4wx5sKkPiPitnLMZmS22jKWdgZI9xT5atg21Wk9fDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789669808; c=relaxed/simple;
	bh=0Tql4Oy0UAbRyLTvdsU2Cye21I8A8ZeDf1dirb2OSL4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T4zlASYGjlSt/2vfSuqvxR22bCQp0ePMbeGkBQdJ+WN96X0TEO63RdwcNkqZpRTNZ7peg69HYm1jZ3HTryx8VXFV5zz73Eaf5FNyz80+nOPi8E1YhFhux7Zj5i4cRCl9MUGiMOPaeXIerqfONggH078XR1iYJjtVOEDEu0kEdtk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gMfo/1sY; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gMfo/1sY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789669806; x=1821205806;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0Tql4Oy0UAbRyLTvdsU2Cye21I8A8ZeDf1dirb2OSL4=;
  b=gMfo/1sYy0F2Mo3AetVyXmwQIgXGslGWbVvR0zkd75ikb1XLJNIIvi8L
   TSy97QVNgEkVkN5GwtmUp4csqG1RcqMnz8XgQ0ReVwVTMva6WAb8rNryq
   pSTkSuY1DVXXVJGpZq8+1qWIqatkHc5uKfXWgx2FOOP+WGszencT1S+gu
   yBli1SUwYKmit3XNxbJzy1KPbHYBmAEwaa152jbqBweC/kLy+uWNTw0ZP
   ygwOgntC/VOYjw4PmxVIsA3S18rka77Jg1ZjBIGt6kg/Cpkp0+mVa4hxx
   yd5Wt5rKgdLZtSLIbgetHazkmnNzPglMKG+bM+GxOvv64mKwYIsh8dNwa
   Q==;
X-CSE-ConnectionGUID: BwJQt2RpQruNWMkU5CDCXg==
X-CSE-MsgGUID: +XtXViXiTfOZ3TDfR3K2Bg==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="100720374"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="100720374"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 11:30:05 -0700
X-CSE-ConnectionGUID: eE1CrD/oSuWIpXkTTg5hkw==
X-CSE-MsgGUID: 9fe+ZKc5S4emCbz4y9W2dg==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 11:30:05 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 17 Sep 2026 11:30:05 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 17 Sep 2026 11:30:05 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.24)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 17 Sep 2026 11:30:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FqqvsWtyJT6eWIOzvbRMOZGtZY6t+7e0CzqFkjkJeqqLJYb0h25hOxqUdKd6t2kqmXrnf9EatNJpB8UiVSl8HU2aq9EtbMvE0+k6cyrRSIVST3raOUwHCj2fTZvYHVVOFbNNjT8Ri/e6RxNs3T1OC/0HW+Vw8KDy2/x1MYYy+YN3Qkpz0m6QCbS48RxFVF5yOo/B4nQEwkdcy5JZ6Y06HrEInYUkFAyxoaDRFawYlx84TQige7AW6hEZqlzkMRST2TQdk3PtT0YL34brUCCFTPCIhvPPfmOoTeCA4lDS0Ke9ZBUMCqOdW/wdY7YAuwwkqFbOtqsNQK5T1OUFXcq2zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Tql4Oy0UAbRyLTvdsU2Cye21I8A8ZeDf1dirb2OSL4=;
 b=cePJABtrt/7jm6JN3hMGsHN6yEJSOzoVABv+05SVY6pLGuoT1I4T9GeG0VK3pptu/f6gEl9BnkIx2DUJ9MEXQwl0A0RQpbAiUfgJOFkmEtF9zZ4B+flg+ZlCTdt+YzX/qv4OCm6SAI7lw9HzAd5YAxmDAL0Qeo8y+GCPVRKfczTLSibCqrdm2JwCKYw8Xl1oI34G/m/+TrsbKa8/eVTjFcFXTEXe9WBo2vqSknuwCwIjGwvUMLsaWNNz80yQgwLxN6aJ5pu5DgJFBmepIn7vn11I/Nx+phEwztTLx5taQCHXX+VzCzZbaTBtMcHFfpktLJz8K9u/dwby/qefAPAUsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN7PR11MB6776.namprd11.prod.outlook.com (2603:10b6:806:263::21)
 by IA3PPF7DA1589B2.namprd11.prod.outlook.com (2603:10b6:20f:fc04::c8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.12; Thu, 17 Sep
 2026 18:29:56 +0000
Received: from SN7PR11MB6776.namprd11.prod.outlook.com
 ([fe80::9c32:5b6b:3a48:dfa1]) by SN7PR11MB6776.namprd11.prod.outlook.com
 ([fe80::9c32:5b6b:3a48:dfa1%4]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 18:29:55 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kas@kernel.org" <kas@kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "ardb@kernel.org"
	<ardb@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH 0/3] Move memory acceptance x86 arch code into EFI stub
Thread-Topic: [PATCH 0/3] Move memory acceptance x86 arch code into EFI stub
Thread-Index: AQHdRVw1VWonJZOLp0OnmPorD0Fzo7bRhEcAgAFDBgCAAFMLAA==
Date: Thu, 17 Sep 2026 18:29:55 +0000
Message-ID: <27b267cdaed0c46146de4af2db8362b61e0b08a3.camel@intel.com>
References: <20260914183745.37538-5-ardb@kernel.org>
	 <af17c380c43912ce34c228e328b3937343ce2019.camel@intel.com>
	 <aqvrUeIfpE4D-Ol0@thinkstation>
In-Reply-To: <aqvrUeIfpE4D-Ol0@thinkstation>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR11MB6776:EE_|IA3PPF7DA1589B2:EE_
x-ms-office365-filtering-correlation-id: f187c950-ce90-40b8-c6da-08df14e9ac08
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|10067099003|56012099006|22082099003|18002099003|11063799006|4143699003|38070700021;
x-microsoft-antispam-message-info: EgTcQktFwtpx66WPlSik6i3uZXY+rFp7pnNwrTDv3S+oqH8IFYhLxowHuoBCUW56iI0eYfncCiuPCeNyHiukqQowj0sYiRfOnoKeGW2c0k3o/Mpdk0r+YcqFDpncDsIAOadSSzNYhOEiV12cJSgmL7sv8dWvrbe+Hx+jpUcwJDxwrcQsxsbnY9cnTXLE0cbaNH9inyM+gFNr8OiShF0UeK6aNdZ837m9Aw5i1EgyBIuRDXN4g/tHfyUpQHuP+rAvrA48me2PBR8xTp7UqefeUdsc+20iYF/cyoKVpnb3mRfVe2W9Ex7QeaZkW/SACDMESy7L36cbWk4th3PxCzKRTZWqGQunnYJJf7rA2AKoeQjSKUjuccYFPHedXXdpqK/aPh8HI3VZHuqBDD3KZOFyVHQaatEPASfzOWdk85tmEqrqn1/aIbV6bew/1zzkJFhLPdqKJCviTxeS4TvKPzjcKQJbabaYRDKLkWsszNdYfUtFhzV8KwjOAfIJ3KaljROy0HPSptU7pEzAIdLR0ROqS5nknSwXcBCc2PehiJ5kK6MuESFy06TcgOgfXsohiuyuEm/kKNpaUO9j1O53N1KEWTj9Sp9rsMkPLMpcknRlM3+t9QPwmVMmmEpBnkJrmPvAxrYB/g3E4ZMRN7/+NdDWoWZuGCd+Tfud968StmCyQK+3a11CqhgUgwGw/Ao2oRo4ydJQTCDsQHneKb/ang456Ic4r4qKe3P+Vk0zSzwwNuM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB6776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(10067099003)(56012099006)(22082099003)(18002099003)(11063799006)(4143699003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cTVRbTFHL0Nsc1F0b0Z6ZzdsbkFyelI4L0wxUFhtRUlsL001ZVA5MWFBTnMv?=
 =?utf-8?B?VzRNRVFnWTd3bnNsUzU5cjZvOGJJVzZIS0RrRWRFTGRyeFhRNmVJUjFBWkVh?=
 =?utf-8?B?SU9rYVRSZWViTmVEeG85bGdMSTNKa2FUK1pSd1dXbjhISXlKMjU3U2Fwb0wv?=
 =?utf-8?B?MUp6Z2U3OW5Tb0d4OUlINVBMMHVRWFlBYzc2UldFSEJoajBlcnZ1ekN5ZjUw?=
 =?utf-8?B?WDI3VXFHODF1UlZPMzBxMFRibm9MNUxiOEFOM2J2aFpGSGhxN1F0clBRNFRs?=
 =?utf-8?B?VnBkdTZJUGRHZnRGR2ZnZUJMbDViM3VCZXBYcDRrQW51TEs5cWFvZjhPWXZF?=
 =?utf-8?B?aE51WHhTaytyTVAxLzVNQkRJK0xPOG5Zd2ZoU1l6RzJBM2Rqb1lnOURRdmQr?=
 =?utf-8?B?U0ZTOTZTUXM0aHdWL05GQmxyWmtJdEduY0pCL0pyRkVZNlJ0Wlg4RmR5cDk5?=
 =?utf-8?B?OHNtSjZXb2J4SHVXMWFhSUpQUXYwUFA3ZlBRd0taaFA0bDB0RWZIdm5YRmxE?=
 =?utf-8?B?amFFSCt0VHNyTXphMVJpWVdnREFUQlpEZnVxV25kT0ZMSVV3U3M1Skd1WVhJ?=
 =?utf-8?B?UVgrRXQ4ck9MaFFCbERzRFZqYzFybXJVWXlXR2dxSENDMWplNTVmVTYyS2pF?=
 =?utf-8?B?TVNsT0xpWXl3VGxVQzNWLzM5MDdOemo1UkNpTWo0ejJ2bU1kZXU3NWlabFA5?=
 =?utf-8?B?QnVCaHdnVTBGQWxha2FYbncydGt5UDBSQ3dFckZrUCtuWTQ0N1pTemU4QWNB?=
 =?utf-8?B?UXFrSVlrYWtXU25kVlVVWXhFQlNadjc0UE9tR05XRmcrRjZRODVxeEhCUFhZ?=
 =?utf-8?B?bHZENzUwa2VNclJlZVJuOGtnUzQzb2lDQm1lQXVZUEo1ZFk1SjU2U2NDdFNU?=
 =?utf-8?B?cjdPbHdXN2w0NEpEOUYxSjczdk5jQmFNOXY0NU1KR0JBUSt5ZzRwcFIzalIv?=
 =?utf-8?B?aXNPWVhiWVBxditCbDF5OEFxSnZnWUQvaGxCcW94eVRhYlFUSzhJcFkrenVa?=
 =?utf-8?B?NWtLZGlaSndwMTRUblFCc3Q1MW9KOGJ1U0VnQ3hCUGJDRXZremVZVlI4Mnor?=
 =?utf-8?B?Rk8wRmh6SFk0bTRJMFVsVTNaK1VQZEl4eE4xM2pPajdtR3F2bUx5N0E0L29y?=
 =?utf-8?B?a2RXa0FuQnM4b2UvV0ZxWnFTOVYzM1pyY3RNQmZ4VmpjOHdIV2N5YW1vVW53?=
 =?utf-8?B?MkJXY3FTOE5QK3dobGZSbG8wR0hqRTh1ZEJ6UWRncEZZUUFrdjNPN2VkSC9v?=
 =?utf-8?B?bUhqejg5VkJPUlNibURPT3U4bCtKSCtlUXFUemN5UVpyNEdBUVI5cnJWdjZk?=
 =?utf-8?B?eUdFbktGTHh2eituRmw2azZvNXQ5ZzFDdUhlaTVwOVd0Q2hMZUh4dzdaWFNU?=
 =?utf-8?B?cHl6ZDVQNnk0ZzBFdzdqSmlqaWw1ZjJMb3pVKytjSDhJa3Fxb2t2aE95aW55?=
 =?utf-8?B?QVVKbEZMOTlFQzFLZ2k4ZklZM0dlT2JBZjI2R0tMbzRJSDdZMHJuWXBIQldW?=
 =?utf-8?B?RlBFWVNmazMzL2RSRU94SjYvNk52OUpLNzQ1aURpNEFjWURLNlhvMGtETFpL?=
 =?utf-8?B?ZXFFMDU3cHFTVzZVcnpuNmNvTjZJeUhab3hLakFadmtGRVJuT3NGdVM2K3g5?=
 =?utf-8?B?c2lGVU9YaHNhRGxSa3ZPRG51dXlZbm0wNFVVTXRXZmsxT1dHUW1UL3QyQnFR?=
 =?utf-8?B?SzArZ1BJazM4cUFwYXp3dzNqTVlWMzFEcVAzeTRQcWhNODFsME44MkMyZTJY?=
 =?utf-8?B?UzN5T3lwOXBaTW9PQi83VFFacWpPKzgvdkE3eFpQOWlKRnZtNkZCZ3NZdStB?=
 =?utf-8?B?Uk5EVkZvRklDN21ha2JTMUljQkpuMTRENDZXaHRZdW9vV09oTHp5V2wwN2hW?=
 =?utf-8?B?TjRsQUxRbXIvbHJIZlpGMjVoNnZaZWExNXdwMHFyMUhwZllGNUYzdVVOT0dF?=
 =?utf-8?B?YWx5Slkwc2pETFpvZ2ZzOUVTUGp1OXNNZ0VoMU1XN1ZIMWdOTmlWYlVCSEhO?=
 =?utf-8?B?TjhOc0RtT3ZveXlHbml4dDduRXZZR0hERGtZUWJwYXd3T1NPa2w3RWV3a0xK?=
 =?utf-8?B?UzI4azQvMElZL3B4TDA4Wm4yaE44dGtPRXNObHNtZWlNdDBFOTUxZnMxbDZH?=
 =?utf-8?B?a2dWSWlOMEdaVWdZSk5JRENES1k0UXl6TFNleU9vcFh2Q2dGSW5maUFEOGNw?=
 =?utf-8?B?ZzU1dUxmdWRMbEFHeWFzVUplUGd2L2w2dnZOc1hPZHd4MlVES1dpYW1rSlVC?=
 =?utf-8?B?Q3VHaUlnWFk5NmFHZlU3bnM0V3dkcUlpMHpqYldxMXQ2MkFmZWJNMEM4ZWJN?=
 =?utf-8?B?WWVuQ2NhT0FjYUFzSXpOZFlGdGo3QldxNnhVaU42cDVzYVJ1ZU1KSjVIc1Nj?=
 =?utf-8?Q?PX0xRrRg3OXN+HVI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4FF8C75B4522974D9231D9BBB17E3939@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: QJ/DUw065ZxI4/HqrHZ+lWyiLywBYSe6y8dhPk088uy0xHgxQhXoLUFdhc48vTCTQMpgokhltORz/6U52RYQTEA6wK2ayEZGReF8aZ2dy6C8+t4bE1kKFSsg4qEQGjLaHbiI5xrds4bZ10n4Da7f2jjzUkZ3e7JPEUt92E06o3a/FTZQUL0+XD2A8vS58EolzrvHXrp4dyEDspZSuTWl5oZNtcnKlRlbGD1ytkfbBeU4aRjpJytqBu2LYUn4KJTLyHOZBeVscqo567NqF3oBL7I1/sjYwLISCwEmEyZwvnd4ofiNXweWDN/ZhJnwEbwQpqKiYYKQ/kUU5WjW4NmAHw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB6776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f187c950-ce90-40b8-c6da-08df14e9ac08
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2026 18:29:55.6000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U1ztauW7O2aExs6RMYbPSsXIF9mwbsi8Y3FDdLtryTVPgkeK01ht7C9s2IcA/D0Eiuc8nr4AWS7/Fn31/dzcjSjzuTjzg5UB2zmsMU4QtNs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PPF7DA1589B2
X-OriginatorOrg: intel.com

K1lhbiANCg0KT24gVGh1LCAyMDI2LTA5LTE3IGF0IDE0OjMyICswMTAwLCBLaXJ5bCBTaHV0c2Vt
YXUgd3JvdGU6DQo+ID4gSSBndWVzcyB0aGUgY2FsbGVyIGNvdWxkIGNhcmUgYWJvdXQgVERYX1BB
R0VfQUxSRUFEWV9BQ0NFUFRFRCBlcnJvcnMuIEJ1dA0KPiA+IFNOUA0KPiA+IGRvZXNuJ3QgZG8g
YW55dGhpbmcgZm9yIHRoaXMgY2FzZS4gSXQgc2VlbXMgbGlrZSBwYXJ0IG9mIHRoZSBwcm9ibGVt
IGlzIHRoYXQNCj4gPiB3ZQ0KPiA+IGFyZSBwYXNzaW5nIGVycm9ycyBiYWNrIHRoYXQgdGhlIGNh
bGxlciBjYW4ndCBmZWFzaWJseSBoYW5kbGUuDQo+IA0KPiBNYXliZS4gSSBkb24ndCB1bmRlcnN0
YW5kIFNOUCBtb2RlbCBhbmQgd2h5IHRoZXkgZG9uJ3QgY2FyZSBhYm91dCBlcnJvcnMNCj4gaGVy
ZS4NCj4gDQo+IERvIHlvdSBoYXZlIGEgcHJvcG9zYWwgaGVyZT8NCg0KWWFuIHBvaW50ZWQgb3V0
IHRoYXQgZnV0dXJlIFREWCBtb2R1bGVzIHdpbGwgbm90IHRha2UgYW4gUy1FUFQgZW50cnkgbG9j
ayBvbg0KYWNjZXB0aW5nIGEgTlAgUy1FUFQgZW50cnkuIEhvd2V2ZXIsIEkgdGhpbmsgdGhpcyB3
b24ndCBwcmV2ZW50IGd1ZXN0IGNhdXNlZA0KYnVzeXMgb24gcmUtYWNjZXB0IGF0dGVtcHRzPw0K
DQoNCkhlcmUgaXMgYSBzdHJhd21hbiBwcm9wb3NhbC4gUGxlYXNlIGNvbnNpZGVyIGNyaXRpY2Fs
bHkuDQoNClREWF9QQUdFX0FMUkVBRFlfQUNDRVBURUQ6IFplcm8gbWVtb3J5IHRoYXQgd2FzIHJl
LWFjY2VwdGVkIGFuZCB0cmVhdCBpdCBhcyBhDQpzdWNjZXNzLg0KDQpURFhfT1BFUkFORF9CVVNZ
IGhvc3QgY29udGVudGlvbjogTG9vcCBhbmQgYmxhbWUgdGhlIGhvc3QgZm9yIGFueSBpbmZpbml0
ZQ0KbG9vcHMuIEl0IGNhbiBiZSBub3QgdW5saWtlIGlmIHRoZSBob3N0IHphcCdzIHRoZSBFUFQg
YW5kIHRoZSBndWVzdCBnZXRzIHN0dWNrDQpvbiBpbmZpbml0ZSBFUFQgdmlvbGF0aW9ucy4gRXhj
ZXB0IHRoYXQgdGhlIGhvc3QgZG9lcyBub3QgZ2V0IGFueSBub3RpZmljYXRpb24NCm9mIHRoZSB0
cm91YmxlIGl0IGlzIGNhdXNpbmcuLi4gU29tZSBzb3J0IG9mIFREWCBhcmNoIGNoYW5nZSB0byBu
b3RpZnkgdGhlIGhvc3QNCm9mIGhlYXZ5IGd1ZXN0LWhvc3QgY29udGVudGlvbiBjb3VsZCBiZSB3
b3JrZWQgb24gaW4gdGhlIGJhY2tncm91bmQ/DQoNClREWF9PUEVSQU5EX0JVU1kgZ3Vlc3QgY29u
dGVudGlvbjogUlcgbG9jayBhcm91bmQgYWNjZXB0LiBOb3JtYWxseSB0YWtlIHRoZSBsb2NrDQpm
b3IgcmVhZCwgYW5kIGEgc2luZ2xlIGZhbGxiYWNrIGF0dGVtcHQgdGFrZXMgdGhlIGxvY2sgZm9y
IHdyaXRlLg0KDQpUaGVuIEkgdGhpbmsgYWxsIGVycm9ycyBhY2NlcHQoKSB3b3VsZCB3YW50IHRv
IHJldHVybiB0byB0aGUgY2FsbGVycyBhcmUNCmhhbmRsZWQuDQoNClRoZSBvbmx5IHRoaW5nIEkn
bSBub3Qgc3VyZSBhYm91dCBpcyBURFhfUEFHRV9BTFJFQURZX0FDQ0VQVEVELiBTb21lIGNhbGxl
cnMgbWF5DQp3YW50IGEgd2FybmluZyBvbiB0aGF0IGNhc2UuIEkgdGhpbmsgYSB3YXJuaW5nIGlz
IG1vcmUgaW4gbGluZSB3aXRoIHdoYXQgd2UgaGF2ZQ0KZG9uZSBpbiBzaW1pbGFyIHNpdHVhdGlv
bnMsIHJhdGhlciB0aGFuIHBhbmljLiBCdXQgYSB3YXJtaW5nIHdvdWxkIHRocm93IG9mZiB0aGUN
CkVGSSBzdHViIGNhbGxlcnMgYXBwYXJlbnRseS4NCg==
