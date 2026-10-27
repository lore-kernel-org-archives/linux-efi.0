Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793114564;
	b=xBYlwEYbDGFbWljeHKmWNaDp4U2LviKcbeXiwG0FOPwkXKSxDmBUslMKwdwyRhpD2WZH
	 CiNaOkEI/tNDXMCnh54+Ki8dryvE6rVqGEY7pNnFDtiQibpwbSnbU6uW+ca1uq7tG6hj4
	 rGdVo9STYOvbF71pJcxO0F/gDhRZVpftz53nBHVMYhMzEYD/GKcFq9LnoBNYKxRVxlvlp
	 fSdJi5gHHGhxZYCR0ykKc6AoAEP2jM2gyxNiYC2DLcsYuscYDjm5YcBaKVIoE86DWk7Fh
	 NcoqOUDwgYKmHwMJOr6gadJXyocrNzfi/Fdn8OavLpjAWMVBVDlKEmvtMfaS4kuLn2w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793114564;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
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
	bh=ov+uIYxKRlS4tyHwlxVw/W0Jy93UkxYNyEYxhxcExPw=;
	b=HCAdNp/1AbfNmLeWOF9kS5lNtsjQIWUr6OIGCIJLgzufg2vKSWl2G4qVwxafeI1pjc/S
	 GeXCJXO8fsmg9vCryz9sjEbQdw7CDoB37u2MQo5R5gcH3ocns9HUGLFD1sEDXBnME8qXo
	 AQZ7FrI4v5JP2o+d9w1P9Bike27YS29Sf4lw3SJARQlF/7++p1YTleuBruJ2XpeLEQG6Y
	 MuuhtOIlz51kGRDmo+qtgN0oH8VIArOT/jO9NWRItC7eBWGaxucF0uJ6Oe1iIp4ut7XOy
	 oHSnCf2VaFX7mziibgg+aoqNrsvzFDZcMvqwvcY4+fDLxXPSHsHX9VG7QTmvH674+EQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=hlP5ucYl;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.50
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010050.outbound.protection.outlook.com [52.101.193.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFA4606A31A;
	Tue, 27 Oct 2026 15:22:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FFA4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=hlP5ucYl
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aLaEKgGb4nXMfJtXe9lBYwdQNo13ioD/LDFbF3LDl6CQAMWK4fvbnSLJorjg44NDdU5vMT7ZWcaHX4O7pF6qYsaL7L6K8HUvePDluasobCaxS4vR1vl5rt8bxtlD+ulsNB9D6mwq7tCGvw+5f9+8x6RrITWbF9c4ZQE/NDXv52TO8mMQ2RXlTJa/+a8vEXFQWOOBMwWYQwR6lBiJgvctb3Jl/fLaEABsI7/gCvJykhmJXv5NjG6x156Ej7veXt0ZNsfJNFRjXpI9Z5nfPE/70q+JTEs/UeY5hDTqJX6T0bwCJzVdEVhT0CfV55spoVwnqF5HjS5Uvq8IVNDbnYkkVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ov+uIYxKRlS4tyHwlxVw/W0Jy93UkxYNyEYxhxcExPw=;
 b=nDYOZoiIf6XgSzPdXPzadBxveQKOOlQgsPobE3b7RrBc+KrEVE4LPJZsTsQ/RsvDGJIHVjYqvb2lhRRThqUGFaI3aVfe0JJG94YiiETNFLL2djCdReQCdwGslikKXpb31xRYSoMYb1F2o14JHzD/5egIFyPngSDyy+EraXqyyboxwauyVdzxQus/S7x9Axx0sqM/v0QQDESCmh//N1raXcG/j1x/mvseVP/XjbZL/MfeqCE4JOEknM1swhkGhy6+SpS0gMIx/pLmSlj7xzk2FSJ5iXcWJq5hmP5eI+W8A5ldBGfAG7BBI7y/ZJgpUlC9LyqXULSCtq1TOcBywY5xaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ov+uIYxKRlS4tyHwlxVw/W0Jy93UkxYNyEYxhxcExPw=;
 b=hlP5ucYlf8bG5tQc8aw+AY7NeLVBcvjwacgOfQNl3WhQuY2fZEsq1bcHBHyQ6XFFoo9DrRB0AMc9ZxCE18OHcFcGdTh3FLoEmozffU40++NrRhmijVG5wz7cqRbWjN+/qb/sPf+i2n1S4WoIIGOFzsigrPsNu2Jsw3Mr+aucqBMwgRbWy9NvVQWVsMihp7b9J5IimIZ53clDKXt/TDGfeuH70aehnN7pm1O9C2yAK9ntLrUx/IhGvbeVDmrpssGZgAh8HXxKJpmqRyyQWWWsvohR5vCwD/6GE2KBNILxvASB6mnYW1YByzRdGnWU9q/E2/lSUorwout7hooQl2hsvg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by MN2PR12MB4424.namprd12.prod.outlook.com
 (2603:10b6:208:26a::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 15:22:40 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 15:22:40 +0000
Date: Tue, 27 Oct 2026 12:22:38 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
	Ard Biesheuvel <ardb@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, David Sterba <dsterba@suse.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Simon Glass <sjg@chromium.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Nick Terrell <terrelln@fb.com>, Will Deacon <will@kernel.org>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	linux-integrity@vger.kernel.org,
	Palmer Dabbelt <palmer@rivosinc.com>, patches@lists.linux.dev,
	Piotr =?utf-8?B?S3LDs2w=?= <piotr.krol@3mdeb.com>,
	Ross Philipson <ross.philipson@gmail.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Song Shuai <songshuaishuai@tinylab.org>
Subject: Re: [PATCH v2 08/15] efi/libstub: Have efi_kaslr_relocate_kernel()
 handle extra_size
Message-ID: <20261027152238.GA2418472@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
 <8-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
 <20261021100622.00007ae5@oss.qualcomm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021100622.00007ae5@oss.qualcomm.com>
X-ClientProxiedBy: YT1PR01CA0094.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::33) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|MN2PR12MB4424:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b44f077-42da-4850-eae6-08df343e2380
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|261026140227099003|4143699003|11063799006|56012099006|261026121527099003|261021121427099003|261022105027099003|261022075727099003|261009223027099003|261022115727099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	XBgydWvB75vDZW7ogVTqRl+D4bxjnugDFNr783TYPMPKl2cwp438PZE1dOVoUNZ/YIKDt6H9RCjvXVBfwMPWCw5+Rn6Z6Z7WtBjHRj4sNp8f0Dv6xS23tAP9c3GUq3i5EpfOXG+8V2pxRvjo28z0VuHWHVYySTdE5/aJTF5RfFSDV5mXe6zaVv3fyOq203fA0dEu3WAaZjrlAIRPHVEZXbO3g1zV2rSMaMSqeTTykNWKaaHQZ5Q+T1JnnIiXX90NpH3Ms6JC3hTzY5/BhPz8trgk7pDGS+R4onVALsjjMGdw90VGCXMXKPvNqtej//gD2ivO4xUfFnxow03ilrjeYseNAb2mcREfRxawVVCiB+e7dzk/Y4TrUGM4BaR0BicXS2Zs5R3C+m+E46PCCLORoY5tWsZYrI2UuYkYHnvIn6y9m8uKE6cvJ8VdWNzNypYXrkg7pp5RMHDllkJEfBO7RurgXLtP3FXrE/WYFO+5GPtHYUdBm2JH8z8piRn2QbVv3WQnIxlfmmBygx+Neg+8Z/D38a3J/DmVjasL4uyfFuqwXL5Fm5YVSaFWh/6VphFfMf+ieHCXEeQ/KMMx5VXDL3+e976/F4819Y2BUi+in4fLaAPYEtEajy7UvhFoZuszPFiTaEdE8TspWCXkNFD0QtCITf/QSDYNvQWpa2iEHKA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(261026140227099003)(4143699003)(11063799006)(56012099006)(261026121527099003)(261021121427099003)(261022105027099003)(261022075727099003)(261009223027099003)(261022115727099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kSDVw74HBnftF/CikeMQjkauzSk3OEVDCE5PV7X8Rr5vv1CkD7ApOYavjIzU?=
 =?us-ascii?Q?wo6wPgfsjogPuJQvFnpkztv0Km/0VZQjDx5A++W287oLV9ZpiNh67p1uGwkM?=
 =?us-ascii?Q?mIjMw7DYNRDDlflpFe/Yqsa0zKIt2MkFOpzOjJUs0yvlAxoL9zwk6Q//sZ+G?=
 =?us-ascii?Q?V8FWHB0kFK17mfP3V9NQ70uWMNLP6ZAwldln+BJ1ag4EGqgC/6qnxQ6t4hrh?=
 =?us-ascii?Q?lgF1/tR+SzVhQF63PSJBz+BrTcjFlx2OguOcicjKyc/9w0kkGi5kBkxZ9GHB?=
 =?us-ascii?Q?tWvFWGkWxQ0Hm+n/FaoVR86vd2ZxDXXJDkC/3mHv/TslYlfW77D82bjAZYjS?=
 =?us-ascii?Q?g6tqhfmXTQocuLHgc9OKkXyHsoPrVD51HO0xAM+t2gpk97pvlC87T+FbqjTB?=
 =?us-ascii?Q?CqdwMLT+5edoHihKKiWfZfGR2AY4+7+5FxUKQOb7D6mriSIy4LoSk/3IvbK6?=
 =?us-ascii?Q?HU4aCCi/WCVOUoptqQSWT6YHsJjDbWEvvMhuqPFf1rqg8RNnGc5nX+HCUCXQ?=
 =?us-ascii?Q?TdI7cgiqmtAJfv85+LuJJBNgw106y2ITc+oDA6YeofmRHl8xy/V/VpZM5T2W?=
 =?us-ascii?Q?A0RDoDHfyIooPpHM/1C8A4ZwplP/81vUOwdtj6z/QzLmVAPPfiiSGXE5h6bn?=
 =?us-ascii?Q?fZEUC4ss3LXSAbBa6Az6c2Ac5KDgZN9ceFkBOU6AV9HZjxBRYQyq7gmWhCaD?=
 =?us-ascii?Q?qoGqPY21qPLWLMvOlj/oAhOqNyXNTfUlSpyjf0G8337pbb5v89Yg1O6YSmG7?=
 =?us-ascii?Q?ANkPXlwq3rZZpa9Vz7v5eU0jiFCjXHNabSOlfFqCHHgR2zJHBdIJqnEHuSxE?=
 =?us-ascii?Q?AlSGmB15AiW3xqtesK0xy9zxCgOV5FmQRiQ96NaEsN9OLew0NFB8DjohG7oA?=
 =?us-ascii?Q?sbyNh/zlZTH/pZ9rAsznyEeysTpphJoVhy7HUhm39hm/u5sZGUkiF7KvIBE+?=
 =?us-ascii?Q?TRJ8wjGkQ+aEfl75s2p2BapIAKO/T7DvCx9lKNLWr+d+OWYOZgAjtNbzVZuD?=
 =?us-ascii?Q?GaQuPQubzagUIEubLbo+kWDJgU6s62NE2z/7u1Q9dEIbb3FJR3ks9bCSsxw6?=
 =?us-ascii?Q?Rdbhs+aJZde83nC9gAY5XC8KL6BtOhxr0XFChluZq3pPsTFXQLkkem66kKVb?=
 =?us-ascii?Q?cmf4TOgrl+/o/I1HDBdFkUVWZEhpKocFW+Xo58IA/XUgauWgI0QXX+4t6zYs?=
 =?us-ascii?Q?OzeW1jOB9ETg5b1NnBKs6WoWUs5/P/fKJv7EMDgH6NB3JjvNCZRCJHzFZ5Vv?=
 =?us-ascii?Q?hTSfmEDzTtMJQRAgPLzUbK561w48PxlSpPOReF/LbLHxZYkRIIcvRh7ZYEi6?=
 =?us-ascii?Q?E5TVeGcrTgPWHaR6rW5fz7NaRZcQYnWHON+Hs5KTyBzT7W1lZTuW/+XVxunr?=
 =?us-ascii?Q?FGp4xT+OJU0puQzIYgv8d6Twn5l8V6PA08M0HKy+8pVpdMSo8BciFC7NSnPE?=
 =?us-ascii?Q?5kdBFn6c7w2+YIk0CfT7qIP0/ka+08I0WgJAXGvqJ76Q5f5Bx05zelH/C/PQ?=
 =?us-ascii?Q?pjROfh/wAivklrzrur1ro9uCcZ/QeJfgEj2U8wbLfXmQmRE3fR4WlzeS483A?=
 =?us-ascii?Q?zRpObG/invtUR9fN3asOnPVj1WZzfWzPhnWWJNffa1seM0kEgW7d5DN6GsNs?=
 =?us-ascii?Q?3LM4fdTkI/EcqsN6aZpWq39ZXIKktrrOFxlSH9Nfc5rjX/Qq4vNvP7ITGeOE?=
 =?us-ascii?Q?gtzwjF5rG+HQHaJkL4yzbCy/VdlMuZ/G+zXf5Y4pWjtUysHn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b44f077-42da-4850-eae6-08df343e2380
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 15:22:39.9906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 780O6B0wxnsvJGinZvPLW9qrtsDMZ50Wad4sAmrAhXALJyleociAUR0W8BtohHzW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4424

On Wed, Oct 21, 2026 at 10:06:22AM -0700, Jonathan Cameron wrote:

> > @@ -125,16 +164,29 @@ efi_status_t efi_kaslr_relocate_kernel(unsigned long *image_addr,
> >  	}
> >  
> >  	if (status != EFI_SUCCESS) {
> > -		if (!check_image_region(*image_addr, kernel_memsize)) {
> > +		bool image_region_ok =
> > +			check_image_region(*image_addr, kernel_memsize);
> > +
> > +		if (!image_region_ok) {
> 
> Why this change?  I don't particularly mind but seems to be churn that isn't
> necessarily needed.

Ah, I had something else here once, I put it back

> >  			efi_err("FIRMWARE BUG: Image BSS overlaps adjacent EFI memory region\n");
> >  		} else if (IS_ALIGNED(*image_addr, min_kimg_align) &&
> > -			   (unsigned long)_end < EFI_ALLOC_LIMIT) {
> > -			/*
> > -			 * Just execute from wherever we were loaded by the
> > -			 * UEFI PE/COFF loader if the placement is suitable.
> > -			 */
> > -			*reserve_size = 0;
> > -			return EFI_SUCCESS;
> > +			   (unsigned long)_end + extra_size < EFI_ALLOC_LIMIT) {
> > +			if (!extra_size) {
> > +				/*
> > +				 * Just execute from wherever we were loaded by
> > +				 * the UEFI PE/COFF loader if the placement is
> > +				 * suitable.
> > +				 */
> > +				*reserve_size = 0;
> > +				return EFI_SUCCESS;
> > +			}
> > +
> > +			status = allocate_image_tail(*image_addr,
> > +						     kernel_memsize, extra_size,
> > +						     reserve_addr,
> > +						     reserve_size);
> 
> I'd move reserve_size up a line to group it with reserve_addr.

As long as nobody minds the 81 cols that creates..

Thanks,
Jason
