Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795195777;
	b=02vmVbXnFWrX0YOqHcWb38EgfNiXK+r057KyykZMzNfAt1f/ppQtRSM/4B0xCNC0vFyC
	 UD5rqpV0C/SjjxHc5FK7dMPCJOhdvpOVDbo4Nmiu/EnCS6N0mr9wEvuua5GRlr/+J3dJ5
	 ErCZLHWWIVZ79qpL55DqrwA7FGPlKtd8PSxLJw3V+eVb5WBBrYibeVQvgRgszY9l2AxpL
	 CfwYBpLGYryUbo6eWswByxxZIMPdo9YbiQk59JTp+Dj+XtbEYLps5QevbG2pGxT6NwLaI
	 7Qp7mjqBCbXjox2QKLsgxabwrvSyt7/zdHdlbKZQsAQv9oljFFa0g0Y1C9B8ALrgDEQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795195777;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Content-Type:
	 Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:References:
	 Date:Message-Id:X-Mailer:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Bjrk+6+HHB+i+mxXa5/gIwoaNJia7LvozlJppRUXfwE=;
	b=qPy8sKTyGV2TByGGROWU9JGd6MP3LzO3QG6qts7K7Offb9qVl6tSHdXvHDQdbAEEBjRb
	 C9/D0WyJ8e3bRlo5Kz5vbtnQEpnQsC1vdwkMhIwla+Bjm8sr7Kx/qU1cEii4wTGO46aIi
	 EEcQOY/Q7n1PbJZJMGVMcW2HpjdrTXreLSD7zfIh+MlQJPlTi52fTLYMTicUaf0q8So1L
	 lVckZmp9+Qckq5A0RheuviM2TzSjtzHo6u+0uXKtrr3374McvFQX2tCChkZF9zL+RHhhs
	 AJQ9CkwXKHsJX/1EghPMwXK0df/zLlEJ789MEbXIz6jMVPgPYO7544iNC56Cs1u5+7A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qjYEkRJs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.48
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013048.outbound.protection.outlook.com [40.93.196.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AEFC60A2620
	for <linux-efi@vger.kernel.org>; Fri, 20 Nov 2026 17:29:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8AEFC60A2620
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qjYEkRJs
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N3E4g7Jxw3UaUNcfjztU63AmEEwOaCoLq1jhOHADVcdkuIXS5WThMW3W3UwXmdvXVYf1mZp6lOOLma1CFPrP6hdK4qb6QJnyPQC3hjDevyZSKxdeYSfLiAAwCqvEZ5EojvbKi0jRALtO2fzt88GMBYULeTekweKRUpztPxGWmYfUogfHazBwu7DaYMQAClS4QWgBKU9NbQi5oeBFKRte4XUgV8H4O0reSxTUBBd+HAbLMeph0W2vzD1vnjKkLJTbwmHWsTZ1yGfLC13FmmBr/FFduRed/59M1KaRuP0kJfloFRqIl0wgT2WszwuO+g3L/2l43y0KOb7fcZ1Y95NtfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bjrk+6+HHB+i+mxXa5/gIwoaNJia7LvozlJppRUXfwE=;
 b=aqNxxI3U5IZEYObZhd5v3EWcF5QzUQILzZBmANVgSXTlHbS8Vcd6+Cu9xvsdUCtVLC3y+asVIdjXyTRrx9AJCTXo9i11Oy+Z2QgQn8G8A3opynXetLZTk5AySvJpMrJCPS25/x/lDsnNDW6l5ERouGlkRmTRT3tfNyk1KAEW/f1NDuxwiPBc3G988VPyyzqF5gqYyWGhvXWv5W7uO0FAgPVGkwdNwUQ96QeHvHYx09PhQC8/8aZVj+SXTRyiTIZS+LyN8BBAmJpinHBd3aRqf0geXwg+txAU7BuArSsd2m5M5oa6eYjlGjNqr+awo5027jdF5rSSWafjhvelXf6TOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bjrk+6+HHB+i+mxXa5/gIwoaNJia7LvozlJppRUXfwE=;
 b=qjYEkRJsVf2cyFSx1CGLVsmXZo9y3QxhEKXSp5ZpDXiIMgffJxVqALvZUeUUlanHacbjtWPfeYoIerj4+cZUTjQ9kzmFFTAsJLy+RM34OJ8nAlGlvsy7x3f75I+u3KqeOC7k/B4pqug/Fgq9u5ddKvgsvbchWPOccPW8EREYeqiv5ow3S/YXCUmCfSO22c87Jv+MkdrpKjV7+q9srClp1wEfWEePyyc3CSl73lxH02ZdPWE3QDwzUD5UW8Wq7lNio9b3WhNO6rrKRjrmwHrGEc140kDUgqpdw7yoccvoZKb+0sszH0ZbccM81sqKKtFEfwgvT6P4n8o+oPX10mx+AA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SJ1PR12MB6099.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 20 Nov
 2026 17:29:29 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 17:29:29 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 11/19] efi/libstub: Drop reserve_addr/_size params
 from handle_kernel_image()
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, 
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
In-Reply-To: <20261118182105.1633603-32-ardb+git@google.com>
References: <20261118182105.1633603-21-ardb+git@google.com>
 <20261118182105.1633603-32-ardb+git@google.com>
Date: Fri, 20 Nov 2026 13:29:22 -0400
Message-Id: <179519576291.392094.219056149366423269.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: BL0PR01CA0012.prod.exchangelabs.com (2603:10b6:208:71::16)
 To CHBPR12MB731189.namprd12.prod.outlook.com (2603:10b6:610:33d::12)
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|SJ1PR12MB6099:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c8f4d26-5198-4655-57ee-08df472bd3bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|4143699003|11063799006|261102123227099003|261022075727099003|261021121427099003|261022115727099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	3r/Gvr8hGkXne9y3E8YkfKwsiZRZw2sgRWfFBgDVtaAN/Veu3yBssPgKQ2PfutEKlCtN1swd073zKxTov4L14dkUzyQwL3gPcNX22Mg5Rfj6TgxK6OvsWLszMrx2nmnoyV44PqrVMsZzK6Sg1uJMOc48knyuBNy6x1AwFsBZewIPXl9rB3daT59TNh4GEn8/evHJhVHwdOEsJhXpJ0JLbgu9y4qBrqwgafazrGxprH0qqrEUuqHnH8VRmZIk9osMXURtd9IhPDjk6idyYTPk7fe2egqVD3NFfg9X66kNeHUYo54z0GicWL9SziG02jvdq630uYWjvA27BlXAhQQNyyUJOoNEpeZk7a1A8I2R8ky0z1qbtL85DKE995PsDZD4tqy9kcrRb5/wy9PHWiIimjs0Plw17IXFGNs8f+6hmiR5+aGEnFXMnHPO5uBUeBFi2eO/TlNDZ+UmIAHUtDXe8rxM7I1bZurDhlv1y/lPpVFMHIgPE5FHsw+A3WUq5rqJTwyS5A6OWm37chZQ32+MSit5aMDGOcdoaWk7K3BDkQmCWUUAlTNNfIYlWwd4xxuODGBiq05uNLarLBSmGEwO9YHZ3KmhPWX9BqGp3+D8kIYJh0BeVPbOmZ30SEfeJEeFVqFV3pXdbXroleC0rEZgLJ9RxXzoWspRb6qaqna3ZYI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(4143699003)(11063799006)(261102123227099003)(261022075727099003)(261021121427099003)(261022115727099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WTRNQUVPNk40dXBvRkVEdit2YXhNbyt3bHlBZDhJZHRiMXk1aFpWa29uQWEz?=
 =?utf-8?B?SkltSnFBOHU0OGdxZEw3eFVTVlRFbDFyZGRSaWxMV3hSTXBjVDBWZXpXVERT?=
 =?utf-8?B?aE4wVlRmc2N2bUlDNjM3UjdSWHdFSGliN0d0U2xQRGc4SEFiZm5pM1ROZ0Rs?=
 =?utf-8?B?RWJJem9PcWtHMnorUnV5Skl4SnMzNUt0cmxDNzVodGduNDNtSDR0Yk9zdjVL?=
 =?utf-8?B?YzVPVXlaZW5oV3UrYTE0SUR3NDJmL3hCS0FSWDRrQWV3Znp1OW1YOU90bVgz?=
 =?utf-8?B?clh0dzlGSWZnVURZcXRtUThHV2F1NnpSZm1FUW1tcG02aUxtUEZJelZCeFd1?=
 =?utf-8?B?STRBZ2FTSWhhRE9nTituOEV3U2FFOGNocHBVNXRKMVRTMTlpT21zb2R1aWJV?=
 =?utf-8?B?c28xcXZuOVlsY0xSRjBQV0d6YU9QYmdwL2FCcFI1TmtOdXE3TjNIbkZRZlVS?=
 =?utf-8?B?VmZDYUd6Ky9VaVBhNWh5SDBDdTRTTmRNMXVSMUhzcWswR1REc2dWWW9jME1U?=
 =?utf-8?B?cURyV0hOa1d4ZXFGQkhnQm1vcFlhbUlFRGJZTTIrZG5vazZLMTZJWVNIY29m?=
 =?utf-8?B?cVNqd01NUW41aHpKT2VjU0c1ZXpNQ1ZLdE1aZzlmQ1hOTGVlR0RFVmZidHZQ?=
 =?utf-8?B?RS9OOC9ta0JidmhxUlhYZ0poaURMSi8yL3ZueURlMFNlVk9kTC9SaTZlZkl3?=
 =?utf-8?B?S1N2aFY5MUJlbXh5ODAwMWxnenROR2RBZTlJL3lvTGRGL3E0VHg3cHI5WHdn?=
 =?utf-8?B?bWY3SXhQbGo1R1VYcXlueWFvYi85Y3phb3lBblFqbkU3cXRWS3dtQ3BJT3VE?=
 =?utf-8?B?anZJSUpHQ1M0WjJHLzc4Z1dBQ2FTNThtOXowQVM0dUFIL3BzeHhXVDArT0g3?=
 =?utf-8?B?Q1V4MndMU3llT3VEZkUzZTYzN2lVOXNGWE1WVG5yVG0raGFHUVVSRmcrczJS?=
 =?utf-8?B?MDJENEtSVkxWMWlCTDhwNjJjeC9VUU1WRWVNd1RkZTRScTRjTTNPYWNwWWo4?=
 =?utf-8?B?cWpsOXdxY2Zsbm9ITktRUmpoOGdEZUI1UVhZNEZUZFZSSFp3eCtIc2FNYS9x?=
 =?utf-8?B?VzFqa1lPVDNSWEZQVmRya3E3ckR6cC9EUngzRFl1SnUraWN1ZTRMd3ZuR1Bw?=
 =?utf-8?B?UUlmM2lHK2hkZjVqUnR0ZERyT0EvMlA1b3BpejFCSG45b0RnTkZBaXJQaVRM?=
 =?utf-8?B?NGQ4dUlxbHJTUlhaamt1Y2I5aEFYb1pGa3NxQUZBdkZaQkxVVEZmY2NuV3Zs?=
 =?utf-8?B?OW5WMHk5MVBUMVUzbnNTYzhVaHpOK2R3QnltVkh0RTFpMmtkc0tvdVlrK0FX?=
 =?utf-8?B?MkozTEkwVlY1YUZDNDUvS0l4Vnh1WWZnSWlyWmZpRGpUY2ZBL3NualdmK3kv?=
 =?utf-8?B?L2F6TkJPbnh6V2pHWGdvRkdoeHhRdGQ2QXl2Vk5vbWg2b2V3YVJaOWtTVi92?=
 =?utf-8?B?bGNDSzFFSUNHcUovLzdiSER6cmtEL3RGN2pDcWV6WWJqL2RKbWR5Q0tHOGNi?=
 =?utf-8?B?OTVPaUFXS2NqTGxxcHM3bHh0Ykp5VWFVMThKZGtTd1V4ak9xNmsxbmdNbTZS?=
 =?utf-8?B?YlFCcGdsTUtCY1Q1MWNoZU0veW0vd1RxTGoxZW9SeHF1MHF1a1hMMFVJZlM5?=
 =?utf-8?B?NkNINDZrRmlEMEZscU9jSmdSNmdBbHZEbDdNWmdOOHpOSmY2VUtHNFB2M1FH?=
 =?utf-8?B?eG9YSHp4RHoweGt5SFc5VnUrMzBwbkUvYmZ5U3JGRU41ZCtvdWFDTk1PYmhy?=
 =?utf-8?B?R2lpZjJJeG5BbTdjYzVKNHk2dWsxaDB0SHdSQTdPOW0vRzlkaWpET3pCbHNt?=
 =?utf-8?B?NldELzRhcTJIUVF6UjY5ZG50eEV0di94YzVFeUlmSlNXZm02Q0Q0d2dBSG9D?=
 =?utf-8?B?bGp5eTgrT0JZTmFmMlNHb01BTzhyQ0ZZZEtqcXhKTFptYitxcjh4UnpWMW0v?=
 =?utf-8?B?ZVJOaU4wVzJqb0o2bE5IVXNEaW9ZTGxtSWljRXp0dGxaZ2pKSWhLNFJNTnU5?=
 =?utf-8?B?VmVkdXFxcG9LdmhPeWFMU3FyYkhRZWZLV3ZFaFFVb2RSNWxCbFlhV21IbGd0?=
 =?utf-8?B?encvaGZsUmw2cDhzN0NmWSttNTJLQ1lyeVhjZ21uM0Nwd0ZhVXJTNHFsS0w0?=
 =?utf-8?B?VU12ejdIZXZHVUJybHpRRndhb2gza0x5aTRYNzdyZGwwT0ZnbVZ0Ujlialpa?=
 =?utf-8?B?SS9jSnQ5M253NTZmd0VOWlFRR1FnWE1BNkRNeW9MNzdWQ2ptd2FndDEyOVZO?=
 =?utf-8?B?RTlSVitLN1E1YjdrZ3M0SkNTT2RBVERsY0VPMmVrbmpOVW05MlBvWVFHNDdV?=
 =?utf-8?Q?eE9p+ge47rfQgHeWcH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c8f4d26-5198-4655-57ee-08df472bd3bd
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 17:29:27.6337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kUac+11llgp6R9zGz2YzM+KSl/DAQOOBwofTafk/+akpBsVkgktH5ajaGOeNZNkI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6099

On Wed, 18 Nov 2026 19:21:17 +0100, Ard Biesheuvel <ardb+git@google.com> wrote:
> The reserve_addr and reserve_size variable pointers passed to
> handle_kernel_image() are no longer used, so drop them from the caller
> and from the prototype.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
