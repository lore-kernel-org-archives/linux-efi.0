Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795197143;
	b=omsZh/2c5dC5lsbtQfVlS8sRh4zT7njX/UHvuOqbWwvHxk+qoI7DKCA5z2p0BR/uCg+d
	 /msX9gGElKs4Xd978/oep1DNHOUWxxlTgxK8TfsAaczDQZiQssROmn5E45FBgH2X9L7oX
	 OCXsXfE9LMXd/EsI7E6b/24ZWDCETXYt9VThjBNOpJ+2wKDGI39XDZO6kjII8+jqBVx5l
	 jod3bpvXVUaMR8gKtjYWXFf1pfpmIIPZGQ8DDvGAfFo3y/hIBENFr/4k+0bWszHI2IRTf
	 Iy2ir6avZ2jJtDwG3x+5m2Crs+5oNAr4r0pMTHiXXIo90GHUG3qcDuC7IgC1ppDAmgQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795197143;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:In-Reply-To:References:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=LnEx0WsQf20srwNNDhRJC1m0YAtShj7rCKT4UNJlIc0=;
	b=eIUBjn8xzwqubHZ708EbMgM8Sup7WhYBi1bX6sV18a5sePSSxbPHiMz8QiyS2ObdBqCP
	 Mc8sC5UP4dunavwWk4yCgK0ep6CZt2bXr3z/EoG2T55FkTOtss72TM9aJutosftXfbN3q
	 wuEpVOkN3tNkE5SDH/Iu3tkbo+LYS8bJKlKKFZxEPyKOHwcYKaat22q0BmwM5tg6nP6ij
	 cPWskt9bAlp8OLWMYnvZKNv1YrwEcGyIXY4ovAJPdkZ5z1sZSjmw0I9Rq95TJ/o63o7eG
	 PdVOY2KEOtk/UxDD2t/n3EhwQTdvwlA1vkPBnL+Ma3e2RxNEoOfBfsx4AkuSUvGihZA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AzytQ5Eu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.28
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011028.outbound.protection.outlook.com [40.93.194.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E9260A260D;
	Fri, 20 Nov 2026 17:52:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48E9260A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AzytQ5Eu
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n/qOTzK4umavjUCIMxKZDgXsuKM5kne7mDMF4JbguPtCiWQC+Us4FyrLp3IYA/OQ5p2/s/oGVAHqR5qmDXKdtulZfwiBLavPYO3Z4ZkPHoh7pPG1H9hCOvATAlvXR21gVOgnWZgEGWJFwd6bAmSgNLpWuY3UfFJoXw9joIKvAEWfVW7TutHIj4P+IpCjp6dL9FH16rPnoaJMaDIYisUxl6ZwU0sxDZtztRX5kaDuKT6Xx9Gmyvzha9N95VFC1QzUZMZOHHXnCitDB9MJQoBw47kz7I1IJklvBZuG0ziXuvmlFmUTSk+GWlvEPBPkceLjfHLZsgpZHQ+/D+HVempaig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LnEx0WsQf20srwNNDhRJC1m0YAtShj7rCKT4UNJlIc0=;
 b=Ir/I5TbOqeyoJEYB9LMAm2LxQAYrmy+2WMpt8lsVP/zOznHFziMHuqMjXTDOn/uueV8F/h732foNEVv26a39KVV+AVTffQxn9H5whAWz8mzI/uHkZdJDUw88TI5zRXSYcEnQXHPAlsgEEHLQxIoOl+VTyiAmc/KvcWvUdUXsdwz1Uf2LAljogMH3wlSMWEpJrVyeQcl24aq1SGhKmXocS+Tv5R/RhpxN+oCecVKWOZSB5x2g/aE8x/p4QiGwEs1ya5Ij4MhUrq7J1dUwXeafRQzVcZDl0TiqGg/4pp3jFmC7bW1FpoLg2IjluFDiixNrkB8+FxMTkmlcBv4J6+DHbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LnEx0WsQf20srwNNDhRJC1m0YAtShj7rCKT4UNJlIc0=;
 b=AzytQ5EueW2SFrYJYOkT5Qm32c6gP3k2IoVl23DO8OdatlRRXx1Cmc5mRr942WnITn+NGgl4slZCH6JtTxVOFo+gAopqs1zUsFqLzOrMt0wzcbShv7Z/GB/2iEDkDjjA5V6BEpXaPRits2BGOMVEJsB2F2ClSJCh5jeT9ptti2igcZgeYKW+rZ7CVlCezMU9/3GVRCKBQ1Z9FiYdLd7yCV1sauh/la/aIoIzVrn+445I8qEYEokV+iKNkzzIgtOB4K63P1gl7TThlhAFA+zIUK/9JeIYrcVqYy2Ta8coKnKMAeLvHF54fqg8kaVJ4jQ6Kcz5HRI4bcyghoOhUDISDg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA1PR12MB6329.namprd12.prod.outlook.com
 (2603:10b6:208:3e5::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Fri, 20 Nov
 2026 17:52:13 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 17:52:13 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Justin Stitt <justinstitt@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	llvm@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>
Cc: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	linux-integrity@vger.kernel.org,
	patches@lists.linux.dev,
	=?utf-8?q?Piotr_Kr=C3=B3l?= <piotr.krol@3mdeb.com>,
	Ross Philipson <ross.philipson@gmail.com>
Subject: [PATCH v3 07/11] arm64: drtm: Update the linker script for EFI_STUB_DRTM
Date: Fri, 20 Nov 2026 13:52:00 -0400
Message-ID: <7-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0730.namprd03.prod.outlook.com
 (2603:10b6:408:110::15) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA1PR12MB6329:EE_
X-MS-Office365-Filtering-Correlation-Id: 6168f0be-23b2-41ee-7743-08df472efea6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|18002099003|22082099003|261009223027099003|3023799007|11063799006|261022115727099003|56012099006|921020|261102123227099003|261028144727099003|261026140227099003|261026121527099003|261021121427099003|261021123027099003|261022105027099003|261022075727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	4pKAL1BHQlof3lEnalH6b1L26HlBZx21genk6G8HIu8FP7P3OBrSAj/5fu0zI7jQQ2s/gEPZ6m4qb1mi1gVQyPcCRUlGu6YTMe+Zda9/is2lccLcSZrscqMHyAJEnDeIy8gDP6tePwyT6x1J4gw/3E4jsP2PKOeCnZdva6ucsQ1W6UTLSOr4/l26/1yYd3CAknHExo2XOi1Hp0lTjnRAbZBg3jtttUPxQkhX5iUOotOo9gXJa62XHi+59zgBJ4B6Y6hiB2BgTMwYc2HIka0LaxDuunFcceUmSQUZ3XruLZhUod0Znfq0xWllC2L6iv+YiFazHPP8rrPJNIkrHR4MMUmXhbU07Z2B3F/qxgKPtGU2R1ffcZMcANBZWtHt/WJDrHEhYbsz85BbujAnmECpvJPDw3NxxogKSk5rR9sMixGryyjWNdl8zFw/0YTdYVNdaF9YjQ0hNaCTfaHxvPiWnttCsNfychavOJL3bf8BqR5OipAoa/LzT5P3QiEgV0obMND6ycli9Z9bixZlqjysaEky7u4Xs/EWCad0+koAaEz8fOGBiWURvSG6yHOcO4U7lQRrd9P7KJ4++W9Ovn2dQ6UsZwd6fgkNWGzMjpbFnSqBIsMzc79tFhLkDgkwbxB99m/rFujEKJnzHJ8xceOI/024Nw2Nlv2oiIsqAFFjM78NX6na2xQTd39N9M9ZpWppM+y6aQcp9y6iH1BPOcC+gA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(18002099003)(22082099003)(261009223027099003)(3023799007)(11063799006)(261022115727099003)(56012099006)(921020)(261102123227099003)(261028144727099003)(261026140227099003)(261026121527099003)(261021121427099003)(261021123027099003)(261022105027099003)(261022075727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9RP9Ao5EvfUi+3BBL2Q6o4ccl0q8Zmmj6RFzm0viPk9Xkp/q9pDOBgkjGssj?=
 =?us-ascii?Q?Oy2YoMh1O6bKq5BzZqKHVOXIbfVgGopJBJHnSn5XvFW1F2AlO7IsHsj0DxMD?=
 =?us-ascii?Q?GHO9nHxlHUP42Yf0Wz14C6d/dlUfAJ5mmawLlrB8Rek3TPazJlCc4SmnW0ll?=
 =?us-ascii?Q?lD4VQsUEqnelteiynrdeL9LcmIh4rky73lIo/BpZTVaGOAhxgrQ8jyMxzJLi?=
 =?us-ascii?Q?OjTkNetqa1WA1qiLvMy9nve83bdupYRK5X+Vmf6c91aEBVLn/sdiOw4zH88R?=
 =?us-ascii?Q?c2ntGooN0chEKWicIaJIeElmDdGYf8GSZLo9OBXEYtBv46HlZytHTqmhDJmM?=
 =?us-ascii?Q?WVYA/mX0T9nl9QJ5NsSKLjeWeq/++irTows0Y+PUppimzt/KVInYlcl8gH9G?=
 =?us-ascii?Q?Nx1/5NTvDDEa6qWhjceeblPUtmsWLj7P6QQSES7K0RH3EM7h+ozL0rDklCTR?=
 =?us-ascii?Q?NarjCTSVeQEaUt4rias6mzUJSK6dCFVQ/MEPW20ZYq3RXVQuHkmBnzUlbM29?=
 =?us-ascii?Q?Lr2VBb+pmFtfFcZdb+tUCC+XAbQo3tE8+2JdGuOcBfQdJLb1e/DB1X5kMMw3?=
 =?us-ascii?Q?UuQUx/CxOVVFBIGWuP/DrQhFf5YVNEknI+AVLU2+pinGNBvY9s5MwAq8naND?=
 =?us-ascii?Q?3/DNdprjrYFR0cZe4P0573Dxr/NappTqyVmGkRm0eV7gyfQQALsvzBMLb0PJ?=
 =?us-ascii?Q?KBY7EeWx7WPHsVxlVSUSQwMYy6skRkDQv4+CDvmGZdErRgNOTUop/a6p4K6w?=
 =?us-ascii?Q?brUsSVpuhi4WaSApvHlgaC2L3GLrIJvCuoZM79pZrpKx6mXjV31/Ptpd0isw?=
 =?us-ascii?Q?wbPcAd4dBlJJz49iLXDnoNBP7b8UuJaSrsJ6ZD5gH73DoYEa/ZF++Mtp8OTR?=
 =?us-ascii?Q?EEw5E5CpUobmxUubXNUjOmYU92drqX5Naaq0kUD+kMtLw0W+kOVm0hzU5nV6?=
 =?us-ascii?Q?8g+jX8V4ChYZIz9idjvr1ABO8tWKvyoeR1mIRSMNyrBZoZi3gcZ5ZX8B0eWu?=
 =?us-ascii?Q?14CJ9fZaz22aNdoBe9+Pbc4M85YYZ25RLyxnLvassWwDmSnwdnugaSz5A+ke?=
 =?us-ascii?Q?jbqli09NXjWnRW8KzaR4MsBlLne+JZvuzIsrNk4R+xIysXeX6EllO6WUzwa/?=
 =?us-ascii?Q?Z4LiVhn6x2UFjlwhdLo0W/LeKysY1ppHJOzyvj9c8VT3gOeIEoZnErPTx8Vd?=
 =?us-ascii?Q?D3UCKNEQw2rTNPbB1Hs7RIvm7WK9En9ZNG2CVTQzsEIsvEdQKqtVSzTVVMle?=
 =?us-ascii?Q?kqbLzlKTQui1QjCg0ibhKca31F27qqRiT1NDlmb9vOpYOmD0wBOyS8Fhw/y6?=
 =?us-ascii?Q?19OnSovJ4VT1nuz8V4/BvLMk2iF64l4pcrMcCZ1CcMFmYho+zPTIpP1mxf/j?=
 =?us-ascii?Q?GQKDkjD/WtZt7j4QXJqaGoSyfBpMTobzNtSAPrznjXDuO9+I0za1f0w8BEwX?=
 =?us-ascii?Q?ZNJ8ku79k/raddirf9XftzFDcobiEsLqwzMq7Y0eWhEMuesnnoneud+YlsE1?=
 =?us-ascii?Q?CcEA5H68bmAq3ycYBiTPH8LxUpEvv2cmHdVbzNGobDm+e7Ublrb4vNUlLirz?=
 =?us-ascii?Q?K3g4uopyww3VUzOjMJ28GK+9HGQtxZzbha7HpT+MBLdXvZHLn30j4c4yM9YL?=
 =?us-ascii?Q?Qgp1XVco6LDplMJN8icbwVOi3H7YkY+rAlriHrWBkV5fi2QZCPGBBSrjwNvH?=
 =?us-ascii?Q?e2UY3EHnoGwZvwCGfrMU3epJ2wQnMcBLUh4BkpnX7/4Ixndn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6168f0be-23b2-41ee-7743-08df472efea6
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 17:52:07.7984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N5OInsQjQQr7xSVuJ1JL201QDnsXpMSr/MO4Ll/1VHXbXmAaBi8/IUqOFKpGevCs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6329

Implement the link layout that CONFIG_EFI_STUB_DRTM requires. This maps
vmlinux into the Dynamic Launch Measured Environment (DLME) defined by the
spec.

Broadly, Image fits into the spec defined DLME region memory layout in
this order:
 - Program headers and padding up to _stext. EFI can write to these while
   loading the stub so they do not have a stable measurement.
 - All the boot-time immutable data, including .text, .data, .init
   and so on (measured)
 - Data written by the EFI stub
 - .bss, padding and other 0'd data up to _end
 - The "DLME Data" written by the launch process. This is a datastructure
   the post launch kernel will parse to get trusted information about th
   launch.

New linker symbols are added to mark these areas and their offsets are
placed into the efi_image_info so both stubs can get them.

The spec's design of the DLME was intended to fit a typical OS image like
this, with two areas that are unmeasured and an inner measured region.

Linux zeroes the unmeasured area of .bss/etc after the DRTM launch so it
also reaches a known value. The DLME data is written by the launch and is
trusted. The EFI stub data is either ignored or will have to be sanitized.

Add a section for the unmeasured data before the PECOFF padding. This is
an allocated section so it is zero'd in the image and is only 64 bytes in
my builds. There is a high chance it gets absorbed into the padding
region.

The post-launch kernel will have to reserve the "DLME Data" before
starting the allocator since it falls outside the linker map. This will
happen in the first series to consume this data.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 arch/arm64/kernel/vmlinux.lds.S           | 59 ++++++++++++++++++++++-
 drivers/firmware/efi/libstub/efistub.h    | 20 ++++++++
 drivers/firmware/efi/libstub/image_info.S |  5 ++
 3 files changed, 83 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 1869b44ae19095..f4e9fd90cd1b12 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -190,10 +190,24 @@ SECTIONS
 
 	.head.text : {
 		_text = .;
+#ifdef CONFIG_ARM64_DRTM
+		/* DEN0113 R314010: The DLME region must start at a 4KB aligned address. */
+		ASSERT((_text & (SZ_4K - 1)) == 0,
+		       "DLME region is not 4 KiB aligned");
+#endif
 		HEAD_TEXT
 	}
 	.text : ALIGN(SEGMENT_ALIGN) {	/* Real text segment		*/
 		_stext = .;		/* Text and read-only data	*/
+#ifdef CONFIG_ARM64_DRTM
+		__drtm_measured_start = _stext;
+		/*
+		 * DEN0113 R314020: The DLME image must start at a 4KB aligned
+		 * address. This happens always because SEGMENT_ALIGN is big.
+		 */
+		ASSERT((__drtm_measured_start & (SZ_4K - 1)) == 0,
+		       "DLME measured start is not 4 KiB aligned");
+#endif
 			IRQENTRY_TEXT
 			SOFTIRQENTRY_TEXT
 			ENTRY_TEXT
@@ -352,6 +366,44 @@ SECTIONS
 		__mmuoff_data_end = .;
 	}
 
+	/*
+	 * DRTM layout for DEN0113 as it relates to the link layout, refer
+	 * to Figure 8 in 1.4b. In that language:
+	 *  "Free Space 1" is the PE header and padding between _text and
+	 *        __drtm_measured_start (_stext)
+	 *  "DLME Image" is from __drtm_measured_start to __drtm_measured_end
+	 *  "Free Space 2" is kernel efi data/bss/etc till __drtm_dlme_start
+	 *  "DLME Data" is a memory sized "Minimum Size of DLME data"
+	 *        and is retained after boot for use by the kernel
+	 *
+	 * Thus, the DRTM_PARAMETERS follow from that:
+	 *   DLME Region Address = _text's PA ie the start of Image
+	 *   DLME Region Size = DLME Data Offset + "Minimum Size of DLME data"
+	 *   DLME Image Start Offset = __drtm_measured_start - _text
+	 *   DLME Image Size = __drtm_measured_end - __drtm_measured_start
+	 *   DLME Data Offset = __drtm_dlme_start - _text
+	 *   Normal World DCE region address = PA of __drtm_dlme_start +
+	 *                                  "Minimum Size of DLME data"
+	 *
+	 * The EFI stub will place any optional "Normal World DCE" region
+	 * immediately after the "DLME data". It is only used internally by the
+	 * FW during the launch and has no effect on the link layout.
+	 */
+#ifdef CONFIG_ARM64_DRTM
+	__drtm_measured_end = .;
+
+	/*
+	 * Writable EFI stub state. When DRTM is being used the stub's mutable
+	 * data cannot reside in the normal .init.data because that section
+	 * will be measured.
+	 */
+	.unmeasured.data : {
+		*(.unmeasured.data)
+		*(.init.efidata .init.efidata.*)
+		*(.init.efibss .init.efibss.*)
+	}
+#endif
+
 	PECOFF_EDATA_PADDING
 	__pecoff_data_rawsize = ABSOLUTE(. - __initdata_begin);
 	_edata = .;
@@ -374,10 +426,15 @@ SECTIONS
 
 	. += SZ_4K;		/* stack for the early C runtime */
 	early_init_stack = .;
-
 	. = ALIGN(SEGMENT_ALIGN);
 	__pecoff_data_size = ABSOLUTE(. - __initdata_begin);
 	_end = .;
+#ifdef CONFIG_ARM64_DRTM
+	/* DEN0113 R314030: The DLME data must start at a 4KB aligned address. */
+	__drtm_dlme_start = .;
+	ASSERT((__drtm_dlme_start & (SZ_4K - 1)) == 0,
+	       "DLME data is not 4 KiB aligned")
+#endif
 	__pi__end = .;
 
 	STABS_DEBUG
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index e404f29693c51c..154d2aefe6505f 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1179,6 +1179,10 @@ struct efi_image_info {
 	s32	_end_offset;
 	s32	entry_offset;
 	s32	sysfb_primary_display_offset;
+#ifdef CONFIG_ARM64_DRTM
+	s32	__drtm_measured_start_offset;
+	s32	__drtm_measured_end_offset;
+#endif
 };
 
 /*
@@ -1223,6 +1227,22 @@ void *efistub_kernel_entry(const struct efi_image_info *image_info)
 	return offset_to_ptr(&image_info->entry_offset);
 }
 
+#ifdef CONFIG_EFI_STUB_DRTM
+static inline unsigned long
+efistub_drtm_measured_offset(const struct efi_image_info *image_info)
+{
+	return image_info->__drtm_measured_start_offset -
+	       image_info->_text_offset;
+}
+
+static inline unsigned long
+efistub_drtm_measured_size(const struct efi_image_info *image_info)
+{
+	return image_info->__drtm_measured_end_offset -
+	       image_info->__drtm_measured_start_offset;
+}
+#endif
+
 efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
 			     const struct efi_image_info *image_info,
 			     char *cmdline_ptr);
diff --git a/drivers/firmware/efi/libstub/image_info.S b/drivers/firmware/efi/libstub/image_info.S
index 587a3eaff1c363..065bbfdf8fabad 100644
--- a/drivers/firmware/efi/libstub/image_info.S
+++ b/drivers/firmware/efi/libstub/image_info.S
@@ -17,3 +17,8 @@ __efistub_efistub_image_info:
 #else
 	.long	0
 #endif
+
+#ifdef CONFIG_EFI_STUB_DRTM
+	.long	__drtm_measured_start - 0b
+	.long	__drtm_measured_end - 0b
+#endif
-- 
2.43.0

