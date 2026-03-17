Received: from PNZPR01CU001.outbound.protection.outlook.com (mail-centralindiaazolkn19011031.outbound.protection.outlook.com [52.103.68.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB683A0B29;
	Tue, 17 Mar 2026 09:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.68.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773741194; cv=fail; b=JX/1T+L+IVc2s7NNhO1b/wODggISGiVitccrzjGpbbLFlmRNRXE6JWZjbFOOphAdrCxgZn0TPRd4s9NKeIMVeBo11ThrKgGSA08ulAMXP+8okZzvd+L9Tf79+JcHZKSjdPxSvTNf1kD00S1TbEtA45k/+Nwcv3VOifZwAAdLt0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773741194; c=relaxed/simple;
	bh=Of/OEl5WRQoagPst4mU792hDdqKgqpRIh7Wb9F6yjpg=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y7+b1S89djn1B8fFP/dCEFBGOVmqFKlNsZ35rEZpGdE1We3sTMZfztRkgVyHefptuVbTF8NHAAjBq1nF5/+lGZczZBlGiJJoHDub34ZrcFNuEswiE3KM3SH4HL6INjsN3iMZ4/QBFKxmrBCdfJUXHg87sl7lVhS/wbp3US6ma8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=g1j8l6eZ; arc=fail smtp.client-ip=52.103.68.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="g1j8l6eZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yuPMJT4+Uos2OP7msX8tVZzVqotfYemK47D/vA3OGW9yaNF0WPrkndPuc7kAaReisdascCNhQQlLXLj4M79tjiLJmIXqJFwOyzV3Z41U8TfLVVvtrZF85AHwBkC0yAvVOAXMAABSdi74VEX1/j5qwnJF/fFYK3+SQ4Ma+sPfsgYxAQVvwL8wSBlNFbGX/VkR5EQzDLK4nM2bhnc2DyQpA8oX92XpiI443oVpBMgeL+u0SF45aXruKFxK9fiZokfmzrQavdWoeZ6jh5Z/EceYxwc1T7MiQ/FS+EaAUfkz4q5FnahCfbN3IQpwf2yAOjwb5uNv1nW4LaiAd0j5aj0fNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aFC9oLZBe/VERjik0ipWrkgUMjgkO4DzwhAk+9BvaFY=;
 b=gv8IPDGTgoz3C1rQ8cJBGKIlIBZLg78zvWPdLA0Ilv5xBnGEVKhfgRqEtyzMGC9O5fmYjSyd/dBHonlQJmoDJMy4WC8VAbemK48KUNmRgMQgT5YrmxbTEEU0DMVrKsTqaHlQathcRcjxhR1my4q6s5xKI3f7pMlPpnYk1+/nNXUf7lCxt3/5EvIxuEalQ7rAxXjiK8eiMWXpl8OQKPH3z0sx4F1tPRHoujH5zX8zIjLrSF0DgU5WGBpqZfUSHh82AriDEqnimB/AiZHWZQC+fEmkkszMwSMeINVlJE/nFi0oAK4qp+ewZxaQVoPVITOudyjRMM19R5hMHvaKF9X6gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aFC9oLZBe/VERjik0ipWrkgUMjgkO4DzwhAk+9BvaFY=;
 b=g1j8l6eZzfW7V5XXCtodtDNzULfwC2LLA9vimxo7bSs9rIjgPPiu7YPvKUqIqEkaUVcPsOZ60EvPMsjAaZjvl/3NsZhEK0S5BHdgY0x2ZGTeUYgztZM/iIzwA9k///7lGw3Y9B3vNdKZrMplLFp5iDIc4EXmBPPbxFUjLbHMixXHfGndbvPBK0+29oqr+PAUK6AJBY+nCR1k62B0ApemlxHlvWFUTWgiefkVUpYTX1hv5ki6xopejBzmWKxiwiwMOAPFZCfUC0+A978vBmq/CDaWiIbJeHQ4KvR+GCJd+Ep0UiSVie9on5YeRletAg4nUrcLzexJMWS1GM5ebSNKBw==
Received: from MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:19c::18) by PN4PR01MB10999.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:2f3::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.25; Tue, 17 Mar
 2026 09:53:03 +0000
Received: from MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::1fed:9b0b:69b:9295]) by MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::1fed:9b0b:69b:9295%6]) with mapi id 15.20.9700.024; Tue, 17 Mar 2026
 09:53:02 +0000
Message-ID:
 <MAUPR01MB11546F8AAA79A199DC1523C0EB841A@MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM>
Date: Tue, 17 Mar 2026 15:22:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] efi: Save Brightness using EFI on Macs
From: Aditya Garg <gargaditya08@live.com>
To: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>
Cc: Lukas Wunner <lukas@wunner.de>, Ard Biesheuvel <ardb@kernel.org>,
 Hans de Goede <hansg@kernel.org>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
 platform-driver-x86@vger.kernel.org
References: <20260316153407.1781-1-atharvatiwarilinuxdev@gmail.com>
 <20260316153407.1781-2-atharvatiwarilinuxdev@gmail.com>
 <9FF2FDB9-17D4-4B01-A872-F26BFF74C5CC@live.com>
Content-Language: en-US
In-Reply-To: <9FF2FDB9-17D4-4B01-A872-F26BFF74C5CC@live.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BMXPR01CA0073.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::13) To MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:19c::18)
X-Microsoft-Original-Message-ID:
 <f04ce7e3-8cb0-444f-a05a-91622106219a@live.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MAUPR01MB11546:EE_|PN4PR01MB10999:EE_
X-MS-Office365-Filtering-Correlation-Id: 10ea6b8f-7a60-4e27-1360-08de840afae2
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|19110799012|15080799012|8060799015|23021999003|5072599009|461199028|51005399006|25031999004|6090799003|10035399007|440099028|3412199025|11031999003|40105399003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dTdPMEltbmt6RkFOc2VpL1JSNzR4WDA2SmMwRDFiOFpDaDUxNXUyVzZLU3RS?=
 =?utf-8?B?eVZKeGU1eHlOR3BYNWFsK1lDQVBBcldiYTFsN3ppWHdGVnNYMUxsZUtEYXY2?=
 =?utf-8?B?RVhQbEt5aHU4ZzlhSFNhR3ZHaW4yWlZoTVRSRkFBR1N5NDh2NXF4RjVURUxS?=
 =?utf-8?B?aDhzVTVJMHlzdThRRmpjT0dxVE04ajg5NDU1NkZMbFJjMHhubVdvN0txT1Nm?=
 =?utf-8?B?NEMrMkZBeE83N3VrRGl0OHVlZjEyUGppRHhNRVRKd3VSS083UEN3VVpBNGxy?=
 =?utf-8?B?emczODFCbDlQYjc0R04xdDhHRDhveGJaa204R3RoT2wxY3ZvMWpIdEIrZzJB?=
 =?utf-8?B?clFrRzRrUzBuVFRjZUEvTGJoY09WeVdlMEVqMjVleEtQUUJZYSttOXE2TTEw?=
 =?utf-8?B?SDlxTStGNFdjL1NhcnJjVGJLL25WVzk3bVlwSDIzQi9kRDZpWUsxdmJxN25E?=
 =?utf-8?B?NXlKaHFyVndEZ1RLU2FkNStBdTJITlVSR0VoMlVQaEduVjVmNWxlb3hURERs?=
 =?utf-8?B?cXpHYmtlUmdxS2hLb0hXaTdrMjA5ZDl0Unlwcm9xd2xvSHNjdUFhOEQ5STlm?=
 =?utf-8?B?eHRCZ0FJVVp4VUwvVHZUbjBxaCsrVERQd2hoUlBGeTd1WjM4NmlXTDhON3FJ?=
 =?utf-8?B?WWx3dGZLaTZGOTJTd0tYak0zTGJiVnVIc2JKNkFSZ1FJek55TlFWTy9aL0s4?=
 =?utf-8?B?SnVzSHdYK1BFdi9mQWRYZGVJN3pPeHJlb3hRUlVnU1VveU02dExrR3BHdE1N?=
 =?utf-8?B?TGs4Vml3VkVKNjZobVIxd3FCajNSMG5QTTBhQU90VThrNGdVT29IdDZIZGxN?=
 =?utf-8?B?QmN3ZGIxamEyQnVuZmI1MEdOaEJYaXErZWg2N2V5Sk5mc2NmQlUySXBMemhF?=
 =?utf-8?B?R1BWdXY4L3dkRER3MTNGSW8vZjZkenhidEdBUEhZSFY3RlM2a2V4VXptSGRD?=
 =?utf-8?B?eDJaUnZCbjdzc3l5OHlIN1NyYXFpSkJGZVN5V1Q1YVk1dlRGRXFoRG9IcTEv?=
 =?utf-8?B?Y2xvWFdiRGRxd3FXdjgrQ3dvMG9TNXZPWVdPdDBCMjFYMkROalk0ekE3TVhS?=
 =?utf-8?B?YkZUL3o5cW13Uk9qVU9zY1VKYXBpM2orcFBIc3lLdGdyRVhKWk5hTXpKZ3No?=
 =?utf-8?B?NVdKSTR5aFgzU1VhdE9nc0d6ZDd4bHRPYTViSUs3THBYRktWb3NHdzdOQVlW?=
 =?utf-8?B?ZzZZSnYyM201UUZXVi95S1NIUmJaOWpsOU5zNk5DWlZIL2w5SDEzYTBnZVRa?=
 =?utf-8?B?VyszNU1wYk4rUjJ5QjBjMlJyaFJLeko2Q3B0NEt1STNtYXlScmZKb2piMGZK?=
 =?utf-8?B?eHlRbDFJbW5rblNFcFh1N3RUOTZxczRvTjArb0VWeGxBVXdWcnR0Y0d4ZFd3?=
 =?utf-8?B?TlMwblF1WElhNXc9PQ==?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WDh4YnMrKzNqczBmeE5KK0xhUU1vWGN5dVNuVFErVVVGRzI3WXdhQ0p1OVJ5?=
 =?utf-8?B?emF2K3QwZTc5OHFBOWt6aVhpTjcrNUtQVU1nay9LR3dBa0xsbU9QdnRRVVYv?=
 =?utf-8?B?ZmV1bWJUT1MvdVZWemQ0R2ZpbHFVR240WTF5WGxYdURaTDZOdVFkUUhQQ0Vr?=
 =?utf-8?B?R2NXN2o1N1JvdUp6WFl6MjJ6YjdydmNVZDdmYXNLVDNDcHVRdXgzeHNZeXZ6?=
 =?utf-8?B?NHdsN1gwbTlyd3J1N1ZDTU1lK0NObnRoaWYrd3A2aW9vT1pZNU5yNEFVbnEy?=
 =?utf-8?B?OVZyakNsTEwrS2hVeTFhbDRKNHZyT2FPRTZCenRrcmJ4NGlnOWhwdlkrTTRv?=
 =?utf-8?B?ODZnWjJCNG1vdGtDNTZpMVZRdlJtMVRoTWU2RGVjaGtHczBpM2I1aENBOHpR?=
 =?utf-8?B?RnJMcW8rQnU5VzMrZzdNOE1OakU3My82RkRibUM4a0JURGQwOERxL0drSHN6?=
 =?utf-8?B?T1JndXIxSmtKekoxZFV3bURtNndHaE9RaWRQbnU1Zit6d3R4czlrcUg2bElN?=
 =?utf-8?B?YXRlV01iWEVjYzFnK2orVU5lQVN0MTJmSUN1WGpOTlVDMHNuRFg5TFFvYVl0?=
 =?utf-8?B?Yms2bUdVZXFGTStCNCsyWHFUeldtcEhXa1Z0b2E2SmNLZis4ZkpUcEhJUHBL?=
 =?utf-8?B?Z01XbS8rWitkZEJxYVRTUGNZbmk3WTBMeWt6eHZHcGgzWk9MVlN5ZW9ET0hU?=
 =?utf-8?B?ZnRvWmR6Ym41Ukd6dVJkbXRISDJEc3lOMHpTN1FsV0NBY0JRSzdvekg2RzN3?=
 =?utf-8?B?VmtZOVREOVJ1NmFjOHlIVFBmckJnN21FcU9Bb1JKZmRJamhwVlNFVnYwdGdF?=
 =?utf-8?B?SUs3dnBkNWcreU40cHVmY3JlbGE4OVEwUEFScXphSzRsOFhCekVETHdFN1Q0?=
 =?utf-8?B?U0h3V29SSlp6VE4vc1RpL1BFM3FVa2RORWFTdWZnUWI0Y05iMFB6b3ZzcTJu?=
 =?utf-8?B?TGMzSzd1R2pBdGR5c1NvSk1CZEo5eDNWbTJRUVBXZ1hyTlZvUVlIZ0tLKzV1?=
 =?utf-8?B?bXRNNHptbzdqNmlzUC8rRk1tSEs0ZG00VCtiMnlXWEdKa283cEhLUDV6U3Ev?=
 =?utf-8?B?cDJVMSs2cVBCZ3M2U05MWTEvdXJDVzMzak5jRXMyS3NhNFRVSElROGFOeVRZ?=
 =?utf-8?B?b2pnMmVrZWRTOVFDYzEvaFBCV09PSXlMM2hhc1duMVU5bVdrR2hlb3VNYjJW?=
 =?utf-8?B?V1VDbDRnZGVQdzhvR2EyWjRwU3FmNVFtck1zVDB4S3RkUDVyY1dTWlh5TjNr?=
 =?utf-8?B?ZnpUV1IrU3B0RkRIQ3dOVjFZeU50cXg0SG5DY3lrZE5wRnZNcEcxaTh5Vkly?=
 =?utf-8?B?eHJGbCs4UDFLNlBSZWsxaWZBZUpFNFdlcFkweVl6ejV5NWIzRGtvQ1FmZ21R?=
 =?utf-8?B?UEU3MXpNdDhDMDkxcThKdFdFOVJSTVRrdnJaSVNtZ3k5WC9Lc21IL0l6MVRZ?=
 =?utf-8?B?UXpiNEZmdXZ0RmVDdllEWDRZSlRDTUVzL1oyR040VEZ2dUdoR2ozSWZFV25M?=
 =?utf-8?B?WjM4Q2JhZ2VXWENTVTJ6aU5oSXBlTzJ6RU14V3RtekZ3Z0xzNWZUdVRMbTlC?=
 =?utf-8?B?cXQrSDNUSnJoM3R2RUdrcUtKeGZWRHdtbTZNQUhJTXBwTTZRRTlZVDRORmJD?=
 =?utf-8?B?V0p0K3R5Y2FOVVBtMlg0ZE9SVFFMWXFMM2ltOG9UTnVDMVJkZEZIc284Y0d3?=
 =?utf-8?B?ZkZMcGxGV3VzTDZWbzRtTWlKMlpybWx3eXdKU1R2bjJ3RktCRjlKejBpZWJM?=
 =?utf-8?B?VmxDNTRzNGoxVEVjK2NZa1k5QTdISjdJYWd1S3QwR0NISGF3cGhybXRPSkxo?=
 =?utf-8?B?cnQ2aUFyZmhnOGJXSGRyWk1NQ2pnWGl6TlZrbWRXVmZ5Y2I4MjNPZ29wZUs3?=
 =?utf-8?B?cnhMMDVld00vbWc4NzZ1a0FENVlONzhkVDJHRGdHZlpXWE9uL0gyL3p3S3d6?=
 =?utf-8?Q?hvA31RZ9n1BCcCVFSmzE4QQA95/3nMEy?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-63b91.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ea6b8f-7a60-4e27-1360-08de840afae2
X-MS-Exchange-CrossTenant-AuthSource: MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 09:53:02.8957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN4PR01MB10999



On 3/17/26 15:08, Aditya Garg wrote:
> 
> 
>> On 16 Mar 2026, at 9:03 PM, Atharva Tiwari <atharvatiwarilinuxdev@gmail.com> wrote:
>>
>> Currently when a Mac reboots, the brightness is not the same
>> as the previous boot instead its the same as the last time the
>> Mac booted macOS.
>>
>> We can fix this issue by saving the brightness level to the efivar
>> backlight-level.
>>
>> (tested on iMac20,1)
>>
>> Suggested-by: Lukas Wunner <lukas@wunner.de>
>> Signed-off-by: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>
>> ---
>> drivers/firmware/efi/Kconfig                  | 10 +++
>> drivers/firmware/efi/Makefile                 |  1 +
>> drivers/firmware/efi/apple-brightness.c       | 67 +++++++++++++++++++
>> .../linux/platform_data/apple-brightness.h    | 20 ++++++
>> 4 files changed, 98 insertions(+)
>> create mode 100644 drivers/firmware/efi/apple-brightness.c
>> create mode 100644 include/linux/platform_data/apple-brightness.h
> 
> I tested this patch on a MacBookPro16,1, which is a T2 Intel Mac, and the behaviour is very weird:
> 
> 1. macOS will never respect any brightness set by Linux
> 2. The Max brightness set by macOS is not the max brightness on Linux. I get these values on Linux:
> 
> aditya@MacBook:~$ efivar -p -n '7c436110-ab2a-4bbb-a880-fe41995c9f82-backlight-level'
> GUID: 7c436110-ab2a-4bbb-a880-fe41995c9f82
> Name: "backlight-level"
> Attributes:
> 	Non-Volatile
> 	Boot Service Access
> 	Runtime Service Access
> Value:
> 00000000  f1 02                                             |..              |
> 
> aditya@MacBook:~$ cat /sys/class/backlight/gmux_backlight/brightness
> 48238
> 
> 3. I set the Max brightness on Linux, and restarted. I get this:
> 
> aditya@MacBook:~$ efivar -p -n '7c436110-ab2a-4bbb-a880-fe41995c9f82-backlight-level'
> GUID: 7c436110-ab2a-4bbb-a880-fe41995c9f82
> Name: "backlight-level"
> Attributes:
> 	Non-Volatile
> 	Boot Service Access
> 	Runtime Service Access
> Value:
> 00000000  7a ff                                             |z.              |
> 
> aditya@MacBook:~$ cat /sys/class/backlight/gmux_backlight/brightness
> 65402
> 
> 
> 4. Finally, any attempt to reduce the brightness seems worthless as unless booted back to macOS, Linux always boots at max brightness, but the nvram variable is changed successfully:
> 
> aditya@MacBook:~$ efivar -p -n '7c436110-ab2a-4bbb-a880-fe41995c9f82-backlight-level'
> GUID: 7c436110-ab2a-4bbb-a880-fe41995c9f82
> Name: "backlight-level"
> Attributes:
> 	Non-Volatile
> 	Boot Service Access
> 	Runtime Service Access
> Value:
> 00000000  eb 41                                             |.A              |
> 
> aditya@MacBook:~$ cat /sys/class/backlight/gmux_backlight/brightness
> 65402
> 
> 
> Overall, it’s very inconsistent. Also, I’ve noticed Windows doesn't mess around with efivars, rather stores the brightness locally and implements it on every boot, something which systemd should do on Linux.
> 
> 

I've done another test as well:

1. I booted into macOS, and set a normal brightness, not too low, not 
too high.
2. I booted back to Linux. The brightness was consistent. These are the 
values:

aditya@MacBook:~$ efivar -p -n 
'7c436110-ab2a-4bbb-a880-fe41995c9f82-backlight-level'
GUID: 7c436110-ab2a-4bbb-a880-fe41995c9f82
Name: "backlight-level"
Attributes:
	Non-Volatile
	Boot Service Access
	Runtime Service Access
Value:
00000000  92 00                                             |.. 
     |

aditya@MacBook:~$ cat /sys/class/backlight/gmux_backlight/brightness
7792

This is the journalctl of that boot: https://termbin.com/p0vf

3. I slightly modified the brightness and restarted. Upon a restart, the 
brightness was max again:

aditya@MacBook:~$ efivar -p -n 
'7c436110-ab2a-4bbb-a880-fe41995c9f82-backlight-level'
GUID: 7c436110-ab2a-4bbb-a880-fe41995c9f82
Name: "backlight-level"
Attributes:
	Non-Volatile
	Boot Service Access
	Runtime Service Access
Value:
00000000  51 3a                                             |Q: 
     |

aditya@MacBook:~$ cat /sys/class/backlight/gmux_backlight/brightness
63589

This is the journalctl of that boot: https://termbin.com/1z9r

