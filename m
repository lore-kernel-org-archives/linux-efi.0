Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD9F4BE434;
	Thu, 24 Sep 2026 23:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790292616; cv=fail; b=TOxhSxy2T1XBFuMAKizO5MnRmB5k/najYRKFUwCui/qrvG1n0OQmpt93kibSgKIwRnFKonzQbTs7YzcJS+ZIVLLk7D3YXCYNFDqeqawg1CGrWUqdWTXi085CR6dvxX+BcShsMkkOfz1DsZNn/5AA0KTobSt0SI/LiQuQD0avwro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790292616; c=relaxed/simple;
	bh=i71VTjJ2n2IZsUD3yziK4hxjpXJbHMwDeTtgSXv6gOc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q/ewxlCE7WFq9/Z54vvSuGqxkr8v6jz3OuqFdfCM5aWF0JIq8gF7Mn2nm1iWn+M3Y3GOt4uCfdeIGfWrqThxTBEaXw8XJiNEl5Ba2pHP+HrYyZkukQI6+QM5NO9VKoqdQhusq4/UupSYqhJMdKJxA/9dcfUBvhUzl1eTnkpYf5c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zu0R9IFm; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zu0R9IFm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790292615; x=1821828615;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=i71VTjJ2n2IZsUD3yziK4hxjpXJbHMwDeTtgSXv6gOc=;
  b=Zu0R9IFmQdbSj1sV1QzG3GAv7jJx/eUWqGMJP1D4r/D8fTza+eDxBlKZ
   QL1VO3HBoLfmbcucA2GSAocJ6SFE7JA/AJjOh9Qk/S5183pS0y/dEEpUF
   bZeDcNJMbmxROKSNofoZ0UHbK7YAwh7isp9L0jadac5/QTpTthHLRTFv1
   xsfizV4RDMyBGCZQbsCV4hV9Xl9CrUoY2DgG7beUpz+pdSFjr2PsAVKl/
   JFvM1W7sRJq/p4gyF2Uwn59gRCgTyPC0flK3261uSr7XvJC3ZoGql0MTG
   E3YqZZxzGSigPwRLpJdGp/Eoks83eO335jABctSyp57uc4MeZDhC0Xnbt
   A==;
X-CSE-ConnectionGUID: msB2DzEcTvGRvXosITFZ/Q==
X-CSE-MsgGUID: m2+lfz3zTieyawUPhR+sDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="101739103"
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="101739103"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 16:30:14 -0700
X-CSE-ConnectionGUID: rdp7DNJHQwmdjFUPygKBQw==
X-CSE-MsgGUID: wT9h6MtuQ0uD+j37g3Ir/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="312096120"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 16:30:13 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 16:30:13 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 16:30:13 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.10) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 16:30:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FJ+cEOfS1uL+Ib1porWEpZk9kSyGakRq6b2VDXc4DEBAXnk9OVK/bBPjV9x/rXsNVsoI7gat1WklD6cLqyrTXplFJl0mjbx8etkQd86Q0A6TnOXtVzCm0P3+zyhUqu96OUCmLpyBsXhRMssZREZz6VtkFQAHCHTasnS79HYYcdJ5yYmuiMuySf68mrIAZAl7JP8o3lVe8F6uGF63lrXxU7Cuwxv54gkN+l8tIjv4gIGUAXmwJagcM7BMzkUy+EeWWMqxUeSaL1p1cAosUHPt8tai+ImCOxWNtJs//dolr1SEb/N6eaVGHwofXlXDMLslUkAs5mhqOuxui/5az/lMDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i71VTjJ2n2IZsUD3yziK4hxjpXJbHMwDeTtgSXv6gOc=;
 b=HPai4QVLWh5N9cP3Yl+AQNLmtmw74f/c+K9soa2NOqEwwuInUnzXa5jeWgWOR2LWRFQoPkpfnpqUc1RcN6imFMioURtmud+T6pRLm++aulQioF6JUVq4MAXHN0hyxRJTXmzA9lBYKUuGrzNBPtHVi8noM/MKRF3StLEFQPZbDpHxiXbfSVSsGAcJRdevSQaBRTRvHn1y6+t6aV+6r9NlMQeNb0p9SBpB2J8W4N93bhdHkSb9LmcpbVbtzasu+VyAHorb5S5ueXCs+ki1AmEHPLPHLPpa31RxYORY6a83yYvVDBDZcan9jgZLbKdrrVGf9sWojfsmXoOOdWmK53MFtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6771.namprd11.prod.outlook.com (2603:10b6:510:1b5::20)
 by MW3PR11MB4668.namprd11.prod.outlook.com (2603:10b6:303:54::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.22; Thu, 24 Sep
 2026 23:30:10 +0000
Received: from PH7PR11MB6771.namprd11.prod.outlook.com
 ([fe80::effa:162e:c9c9:a1b4]) by PH7PR11MB6771.namprd11.prod.outlook.com
 ([fe80::effa:162e:c9c9:a1b4%4]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 23:30:10 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kas@kernel.org" <kas@kernel.org>, "ardb@kernel.org" <ardb@kernel.org>
CC: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de"
	<bp@alien8.de>
Subject: Re: [PATCH 0/3] Move memory acceptance x86 arch code into EFI stub
Thread-Topic: [PATCH 0/3] Move memory acceptance x86 arch code into EFI stub
Thread-Index: AQHdRVw1VWonJZOLp0OnmPorD0Fzo7bRhEcAgAFDBgCAAFMLAIAAgSgAgAA2+gCAAFh3AIAIG7OAgAFjXwCAAMSLgA==
Date: Thu, 24 Sep 2026 23:30:10 +0000
Message-ID: <fe5b400e19742ae3666cd7b3e4bd22164024293f.camel@intel.com>
References: <20260914183745.37538-5-ardb@kernel.org>
	 <af17c380c43912ce34c228e328b3937343ce2019.camel@intel.com>
	 <aqvrUeIfpE4D-Ol0@thinkstation>
	 <27b267cdaed0c46146de4af2db8362b61e0b08a3.camel@intel.com>
	 <aqyd+rhamNei92Nz@yzhao56-desk.sh.intel.com>
	 <aqzMGEVpDRPUyPUA@yzhao56-desk.sh.intel.com>
	 <aq0VWfqv2_SgOvV9@thinkstation>
	 <b9ff9e11-d7da-4e34-9744-e3adcc786276@app.fastmail.com>
	 <arUNjv0rSaAM2xmk@thinkstation>
In-Reply-To: <arUNjv0rSaAM2xmk@thinkstation>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB6771:EE_|MW3PR11MB4668:EE_
x-ms-office365-filtering-correlation-id: 29dc73c6-61e6-4548-52cb-08df1a93c675
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|10067099003|3023799007|6133799003|22082099003|4143699003|56012099006|11063799006|5023799004|18002099003|38070700021;
x-microsoft-antispam-message-info: 5Ssd0GAyp3hnf3CaYDs78b/pAnRkw8fu2YlsZvVPc9+uZwZpu7o+7sYUJnA+9EwrUi6gD/F63XhkmKQMwgMuRTRHE4WQyulGFs2BP/4ErdLuPvO5k0lH4e57IbqI+IfPx1xivGfsYxft/QRLVNghuhJZvANLxKD15zyRnKJTPfnwpJIYd+zb9FP0lwpL2Jsvh3J80HpXO/jqzReCy67lCbCdmQqa4Dpr9y4qsch/IustpOyh9i9g+qa2AR6KdfE1hHXlnwDu0kn3MYFjgDnSqQnLhFsw8ILiQln+99KlUdIcN+eVPlfplZxBoaunLytrm24cXn6A9umoGbiJV7iPntPImAC3bSB+YvJfVcQJkyV0geNhAQOwO4J8AYMoPm8qxoKt9zytZkm3U1DOkCpYEEskiiS8FtZwSxN085B6slKmbXkOc6FrJwAsZkwSDLzZLsu/Blf1iXWsD1f1VNYrjhNQduhccs2Js5HOHYtyXC1j5eCNq9vYZJsr9AmbFsnDqqUK1Y0bZfnXqxgIc/df9vaqS3gHpulF88OLO8Cl+ROPDqbCwzPPS1QcCd1o1y0gSsZtgJuStFK4OhjtgBHslJiNbCZJWBSQVADjP2cCw7y52CnoXd404/LAjKJQKgrG8Xn9q+28TSTuLbFHyFswgwhEbwETpNK/KC6BndrAteDmOt28Tqh8YPcui+Yu65Ryvj4uWlV7+VQphX1SiATtKYTKQcC24FSI0tzhzS829Uo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(10067099003)(3023799007)(6133799003)(22082099003)(4143699003)(56012099006)(11063799006)(5023799004)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VlJBOENad3YveDUwejhBTjVRbnVHUHFHY0NhQnUwV0NhcDBZYUFJUnNNK2li?=
 =?utf-8?B?TGpNbXJ3NURtUEJUSFVsbTQ4K0M1dS9XZUNNTmVBZWNDZHBYNWYxejdJOXlR?=
 =?utf-8?B?NStTb3liS3FYNGNYY0g1QWNvU0F0NUdTYlFUQlA0Ymx5b05rSklUT3VDeU5S?=
 =?utf-8?B?UWg0aHJITldMN3RGUUdEeVRiTkYwOTUvdmRTMVZ0amgzUGo3TFQrVE50TUhX?=
 =?utf-8?B?OU5MSVBweVoyaHJaUlpsaDhDL2xwZkdMSHdqQVNvK05yNFNPaGdZcXVpcUJL?=
 =?utf-8?B?NHZZeUlXczI4OFN6ZkRQbHM4WnRvemxrUXpYSWNGSWRXdmcyVkNlWThSanZQ?=
 =?utf-8?B?endyb0tzOWpmcUkyeUtJdUxuZHdBQytBQ0cwUGNpeVV1Z0hTU2NENWhDL3lC?=
 =?utf-8?B?dG5qeitJQzZxQWtpSlVFcVRMdzJmNjRpMGlLcndTQUZNMEJVcGVKZXdCUWpW?=
 =?utf-8?B?WnRwMWZtWXM3Y1FzZkVFMzREL3pFaXliWklxN3BXN1V2RS90N2VMckd2OC9s?=
 =?utf-8?B?R1UvaTdKeFNFbFZvR0JhV1ozUHB2b0lIb2QxZ0JGL2VKcEt1cGpCRklWY1Zm?=
 =?utf-8?B?T0pydUduTjlMM1FyMFV6TTF1all1L0F5amFQR3VFOG9QK3VSZU5aVkFzeEdt?=
 =?utf-8?B?SjJJQzhOQUVLcE5SZjFQVWZpc0NaNUJ2bVYyMTUzYnpGTnpJNENSemFHWVI4?=
 =?utf-8?B?L0FLSFdsZnlXSVZNb3E0eHFVYytMV1V1WWUwblQzMGRwajlGU25mcDFDeWN3?=
 =?utf-8?B?cGJDRWwxN1E2MjVhNzY5NXdNMjg2c3ZDTkpkV01Gbi9yTzRHUkJrTk94Lzhv?=
 =?utf-8?B?RUdsK1Ryc0xEUyt2OVJmRG5jL2c0Vjl3WWVlQ1NOalZoclN0MVJlLzZSSTBO?=
 =?utf-8?B?a1lqMElCbVd2bTU4ZHNWRXp5akdGT1NxRk5vRmxCekxWbXAwanh1Nml0MWpM?=
 =?utf-8?B?WXZKOFVxR0tkTFpxbHBQOEp1RVAwaDlTSkwwYU1VOGlnbTFEMi84dFN2K1Rl?=
 =?utf-8?B?czNxWG1SQVArcXhrVm1kbExoN1JqSFp6aUJ2UkdFdnk2aVUyb05maUlyWmw3?=
 =?utf-8?B?d3BUTXdRZG1hclZIb0M4Q1FOL2xaM0FKRlh2bEpralVvTjJMRUluSTJnSDRo?=
 =?utf-8?B?cGJvQlRtdTVxZXdhajNPMGtEYXdmNUpTaVNoaCtrcnd2dmxaaVFSSnh0Z0dk?=
 =?utf-8?B?aHU5ZVNIWGVsTmE0VWJJWGxaVmZXYXRaQUVta3BPYm1RdzRaakhZTkdZZi9i?=
 =?utf-8?B?VitXYlQvMitTbmUybDlsQ2RSYjgxQ1Z5amd3RXdyRWdzUkhxNHNFM3VHTVNt?=
 =?utf-8?B?dDUybmNZK2NvdkdSRzVhTzdjOE1qU1NDZ043K2RuWHlJOHNLY1B3cVduL25i?=
 =?utf-8?B?Q0NDaDVjT3hpanlZNDBVRm10ZVFFeGtUbWVFdzBwa2dYYWFSM2haNlJ5OWR2?=
 =?utf-8?B?VklWNHhHWFNGRWxaWkkwN3dVSERKUVJEYVVEMnQwQTJvZXd3RHhoQW9SR2l6?=
 =?utf-8?B?ZTFhRjNONWdBK3h5UXAyTWNsc1p5Z2FYMXRRR1A1aGxvU2hnd0FzVE04MDlZ?=
 =?utf-8?B?Zk0zaEZVcU1qeVhxMy9lM0tzZFBXNjA5L2dJZC9iNllZdGV2VzZpditCaXF0?=
 =?utf-8?B?NytNN3AzbGRENzBCNGZ4ZkROTEh0dGgvVjBERS9nUGdRVy82TkpYQzRiWCt2?=
 =?utf-8?B?b3dRclRPZ3RuSjIrU002NE5CK0FuRkt6RVNkbnI2RGEvZTgrenF3enJubUdp?=
 =?utf-8?B?bW1XSVQ3WU5DalJLZ1NPVTk5WVZDOEwxZk5sS0lmK203c29DVHlJcEI2Nm9P?=
 =?utf-8?B?aWlJanNqN0lXZlpZbVE3c0VxYTcrTC9XUDRQSEtGS01MRXAwVU5PWS9obnd5?=
 =?utf-8?B?RWhWdm1hNkxnTVJpOUQzdEd3V3kzNVA1YXR2T3QySnRiSDBVcXFxTm5yd1N4?=
 =?utf-8?B?bUk5STZYVHhOb1pWaE5yelFjaVVjdE1BM0ZyM3RyWjF6ZU8xRGY5NmlETXJm?=
 =?utf-8?B?dEhlUUZVWnY1dGx3bkxubXh0R3hFa2xBZVQ1cVpqeVRJalkvWjFBbkZseUg4?=
 =?utf-8?B?a0x0eXFtMGZIKzdVUStrSU41bC9USG9MNnYrMkdEcm0zV2pwdDdzNUQzVlMv?=
 =?utf-8?B?ZEorZW4wcXYveHVmYTQ0cjduYUZSMlNHTHRWUTMyeEd1c3hOMjJkb1JjWXMr?=
 =?utf-8?B?QUFKc0ZXME1wOWZ3YkhrbUtONWtRRUxXUzZjTTN4elFiUTNXR2pvajVIemtK?=
 =?utf-8?B?ajdXZTFvMmlHblh4TUNVckl4dXl4QmdpNVRFbHBna1ZOUk52V2hKbVBrTXhl?=
 =?utf-8?B?MWJzc1JYdlc0TUhHMU9jSFRzQXBCNmNmMFJ5WkdZdHBJS1BTeUZqeE5LME5E?=
 =?utf-8?Q?XE8fOdg1dyoPz4KI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C7D83A95CDB1554896F77C03D9224EB2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: XzqQ6569a1JITYZDTz1Bml0h9aApXovrsfRgb568RBlPuEB/RLDX6lxbr11GkeNT+VtxHK5zXnN+7Ylj5pcp0lstvoSt+Kjj2eLNPqlcATzc3x0IhhKwVAgiX3cyR/BnfYzHpd5CmiDWBAJBSYErPeQMgYG5eETtqu2tyDB6iqF9ap94f91muUjI9zC2lIpR39+FI7JGgl53OUVG55Op6D370j16a6NWTcaC0qylm0FqNGpfgn/RqYPsc0Duf3TjJYW2ucD/hP6hfk7nUu5362BPWog1oEQVWpQ8j8hezvEmQ+rW84hzmcgfyqKMSQxQHKMfJq31yB+QweBfdPhkbg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29dc73c6-61e6-4548-52cb-08df1a93c675
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2026 23:30:10.1682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j/GU8LGMxCEgPxpa3JeD5yBTfb0E3UZULiP1L18qVudzfkwsBivmq9Uk2xRkfQNHLq4LMkQQcOwSAy7+tsNWJfjr3b2OthBSZwBlH1NzSTM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4668
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI2LTA5LTI0IGF0IDEyOjQ2ICswMTAwLCBLaXJ5bCBTaHV0c2VtYXUgd3JvdGU6
DQo+ID4gSXMgdGhlcmUgYW55IHdheSB3ZSBjb3VsZCBtYWtlIHNvbWUgcHJvZ3Jlc3MgaGVyZT8N
Cj4gPiANCj4gPiBVbHRpbWF0ZWx5LCB0aGUgdGhpbmcgSSBhbSBhZnRlciBpcyB0byBnZXQgcmlk
IG9mIHRoZSBjYWxsIGZyb20gdGhlDQo+ID4gZGVjb21wcmVzc29yIHRvIEVGSSBzdHViJ3Mgc25w
cmludGYoKSwgd2hpY2ggSSB3YW50IHRvIHJlbW92ZS4gRm9yDQo+ID4gdGhlIHRpbWUgYmVpbmcs
IEkgYW0gbW9yZSB0aGFuIGhhcHB5IGxlYXZpbmcgdGhlIG1lbW9yeSBhY2NlcHRhbmNlIHdoZXJl
DQo+ID4gaXQgaXMsIGFuZCBqdXN0IGRyb3BwaW5nIHRoZSBjYWxsIHRvIHNucHJpbnRmKCkuDQo+
IA0KPiBQbGVhc2UgZ28gYWhlYWQgd2l0aCB0aGUgbW92ZS4gUmljaydzIHF1ZXN0aW9ucyBhcmUg
YWJvdXQgd2hhdA0KPiB0ZHhfYWNjZXB0X21lbW9yeSgpIHNob3VsZCByZXR1cm4sIG5vdCBhYm91
dCB3aGVyZSB0aGUgY2FsbGVyIGxpdmVzLA0KPiBhbmQgY2FuIGJlIHNvcnRlZCBvdXQgc2VwYXJh
dGVseS4NCg0KWWVwLiBJIHRyaWVkIHRvIGRvIGEgcXVpY2sgc21va2UgdGVzdCBhbmQgZ290IGEg
c2ltaWxhciBidWlsZCBlcnJvciBhcyBCb3Jpcy4gSQ0KZ3Vlc3MgeW91IHdpbGwgc2VuZCBhIG5l
dyByZXZpc2lvbj8NCg0KbGQ6IHdhcm5pbmc6IG9ycGhhbiBzZWN0aW9uIGAuYWx0aW5zdHJ1Y3Rp
b25zJyBmcm9tDQpgZHJpdmVycy9maXJtd2FyZS9lZmkvbGlic3R1Yi94ODYtc3R1Yi5zdHViLm8n
IGJlaW5nIHBsYWNlZCBpbiBzZWN0aW9uDQpgLmFsdGluc3RydWN0aW9ucycNCmxkOiB3YXJuaW5n
OiBvcnBoYW4gc2VjdGlvbiBgLmFsdGluc3RyX3JlcGxhY2VtZW50JyBmcm9tDQpgZHJpdmVycy9m
aXJtd2FyZS9lZmkvbGlic3R1Yi94ODYtc3R1Yi5zdHViLm8nIGJlaW5nIHBsYWNlZCBpbiBzZWN0
aW9uDQpgLmFsdGluc3RyX3JlcGxhY2VtZW50Jw0KbGQ6IFVuZXhwZWN0ZWQgR09UL1BMVCBlbnRy
aWVzIGRldGVjdGVkIQ0KbGQ6IFVuZXhwZWN0ZWQgcnVuLXRpbWUgcHJvY2VkdXJlIGxpbmthZ2Vz
IGRldGVjdGVkIQ0KbGQ6IFVuZXhwZWN0ZWQgcnVuLXRpbWUgcmVsb2NhdGlvbnMgKC5yZWxhKSBk
ZXRlY3RlZCENCmxkOiBhcmNoL3g4Ni9ib290L2NvbXByZXNzZWQvdGR4LXNoYXJlZC5vOiBpbiBm
dW5jdGlvbiBgdGR4X3BhbmljLmNvbGQnOg0KdGR4LXNoYXJlZC5jOigudGV4dC51bmxpa2VseSsw
eGMpOiB1bmRlZmluZWQgcmVmZXJlbmNlIHRvIGBfX2ZvcnRpZnlfcGFuaWMnDQpsZDogdGR4LXNo
YXJlZC5jOigudGV4dC51bmxpa2VseSsweDFlKTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBgX19m
b3J0aWZ5X3BhbmljJw0KbGQ6IGRyaXZlcnMvZmlybXdhcmUvZWZpL2xpYnN0dWIveDg2LXN0dWIu
c3R1Yi5vOiBpbiBmdW5jdGlvbg0KYGFyY2hfYWNjZXB0X21lbW9yeSc6DQp4ODYtc3R1Yi5jOigu
dGV4dCsweDE3ZjUpOiB1bmRlZmluZWQgcmVmZXJlbmNlIHRvIGBwdl9vcHMnDQpsZDogZHJpdmVy
cy9maXJtd2FyZS9lZmkvbGlic3R1Yi94ODYtc3R1Yi5zdHViLm86KC5hbHRpbnN0cl9yZXBsYWNl
bWVudCsweDEpOg0KdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBgQlVHX2Z1bmMnDQpsZDogYXJjaC94
ODYvYm9vdC9jb21wcmVzc2VkL3ZtbGludXg6IGhpZGRlbiBzeW1ib2wgYF9fU0NLX19XQVJOX3Ry
YXAnIGlzbid0DQpkZWZpbmVkDQpsZDogZmluYWwgbGluayBmYWlsZWQ6IGJhZCB2YWx1ZQ0KDQoN
Cg==
