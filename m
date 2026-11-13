Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.16
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794579031;
	b=VitQPFP7vBk6LMUEHeeYGFlH558S1ySN081yaVpx9kXrfNfBF6hpCXM3c9pGkxV0VHv0
	 RJbtfL/VtFoRU4DWqcUuFVH+iNTULiN2APNuCzen01H2+UQ1Hk+JJ4Z2Yx58ZS+ijSf9m
	 897NTlYJrO/MZtnbzEpE1awqNuTs/PG22b5kTdzFXDgdoL1B/f2koxgz212m9RVpq9BPK
	 8YlRmTMb/o0HldFcCTi2fb4RG3M79g2PSTsJ+wxnF3PeIPk6XbFueQCxAHc16knXE4pC9
	 GWfu95MWJdsUA0JvAdgXT6w4cmUzt7VbhH1JlWyX0fhwj6/boe5FKCf9FKV5wwIb7iA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794579031;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
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
	bh=x3wwPXrt4cSDIqDtFls/DzQIxtptmzOQVDnB5s4JEnU=;
	b=DGqkHcCwwFFFY0xDoH9jSnzAyLVMvZRogXG2JEZim5ckyB1MLQZvuLlz+lske3ch8Hx+
	 6BHUl3SdUXNa1Z3nmVkkj/P+gmL2pTdwkZvoBVpJd2va+QYAIBhn1kpIiAS0IA0kUizsS
	 0n5FVt42WvB4KbuVJ/I0R/bVDbn+nOnBPAw800RRKjDtTz6ErqlWpxH7SjQdndFP7Q/13
	 sLpdMbv7CCTnLfhfrBj4aqoiRwiAHx37a47UUXE1jweekhnaHB9Udr9ud3z/qoXUrSfls
	 iFyJsz37oGZFfPA4lPjIMf81loUTX10czfrZg94/wwPSOivjdRCJpTMemdo9kBLb4BQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=4xrJTb74;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.16
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012016.outbound.protection.outlook.com [52.101.43.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6143606A327;
	Fri, 13 Nov 2026 14:10:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6143606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=4xrJTb74
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ssBZg88uoJWRvgtcbCWmWLt3H4V+TYtNbJric67NWvRVtDp5FQXWFbKeCGu7X8TAfUfBbhUTFZibdO25siyEt+gVwhe0guFtg2uLwxCJMPkVdusks+5lMhqH6hW7rkUayZbI6k3hh9ZZVaI9giWzcZkAv4N3lE92A9e/MVoQ7WuC77a6JD3uLUFbjelFh+0XrfBakoZThQ9FQrEwXdYoxtzBoSUjGhNY2O9g0o00yZRSrQnAGHK+1ztRIDYJX/dBEibw5AvdLyr754KZhOXbGeoUxIi2SP+NzQidfCNGyZWtRBCPPwLSrsclIQ2L1ESoGHmgbD+0ethRSic7KX4XsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x3wwPXrt4cSDIqDtFls/DzQIxtptmzOQVDnB5s4JEnU=;
 b=atMayrEqXl+ODzUAXZxKJDVRlv5AEQBmnFi54qHob1OJVl0OJkc8+4Sp3FcpK4w+n0oy/LCVy7HDSA6suopynAHAUuCwjDSSYU91WGO0WziHHZR1oIOToWpW8nFIW+9rOoFECtPNXvfrg/kzDL86DCRgkKPmh+ipYM6dbNtXpmx5Un4GVPJqEgEKT1SxVTzdD/fYI5GCU5rUYDi2/c9mHjLZZ2SX2U2xLr7odrE6lg7hS6wY3rzmlzqLlYcy1OudZ14ImrhV+Lk9timYGPVPxKb9/TYPEE+l6P0zESxJsHdb3ohy5s9XE8I3WhqWIZU7JG6F0NX1I/A3ztf+CM21RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x3wwPXrt4cSDIqDtFls/DzQIxtptmzOQVDnB5s4JEnU=;
 b=4xrJTb74oimKLYdyR7QZrAR5slC4WZdTTrK/dqI1reYn6MnO5u/oqcxdX1I9hCihH16TYTsVpuevk4LA2we3KBrLA2YHU+mahwR7v6fN8aa6tnsd0ipg2HTUm3cs3TV5nQ5TTZiD8v7LpIlJ/cjDS9kWK9eje3JXf/8PkYOjVLQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB7771.namprd12.prod.outlook.com (2603:10b6:8:138::6) by
 CHBPR12MB252449.namprd12.prod.outlook.com (2603:10b6:610:33f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 14:10:28 +0000
Received: from DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c]) by DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c%4]) with mapi id 15.21.0592.012; Fri, 13 Nov 2026
 14:10:27 +0000
Message-ID: <9c41e38b-bdd5-4434-9e8e-72e76df94780@amd.com>
Date: Fri, 13 Nov 2026 15:10:21 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86/unaccepted_memory: Do not accept ranges that are
 no longer E820 RAM
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, linux-efi@vger.kernel.org, Pankaj.gupta.linux@gmail.com,
 stable@vger.kernel.org
References: <20261113105554.199912-1-pankaj.gupta@amd.com>
 <avcIhKCXFo8Pn01U@thinkstation>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <avcIhKCXFo8Pn01U@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0238.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e9::17) To DS0PR12MB7771.namprd12.prod.outlook.com
 (2603:10b6:8:138::6)
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
X-MS-TrafficTypeDiagnostic: DS0PR12MB7771:EE_|CHBPR12MB252449:EE_
X-MS-Office365-Filtering-Correlation-Id: b9f82a97-b289-454c-f90e-08df418fde0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|18002099003|22082099003|6133799003|5023799004|11063799006|56012099006|10067099003|4143699003|261102123227099003|261026121527099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	n03ApzRwlTBR1K5uxsse/bWRJ/gPNIXoH0HYexSw7LM4wa34oejX2yYM85eTzX9lvUxScp3DFBTWuRwvg5ARaGmm0wtuMIrI2pCK9CA60Yf3Klv/kQfLI1fv4NEqex8EpbfzDXCjygixhau9ncs4ifyjdu5ySmSYDw85LGxAjb7NnvqXWXHw96QU+u+YqcGuSoDLHGhd/gFs+ayTG5pEJaEZ1RdNRkciyHD3uIQWlomIPhUlCfsThiDp3pDoiOWfugNpcxXtxKBVmfpAqZcat3cABH+NQein/Tc8OH5pD4I1cyNl7hCyuew+qqBjnb2tOde0UbQzj4CH0tQR87r2D5KX30zoQJduWskNvS3SY5HPU5waM8bqH+5NcQk83N6PZjICXnQYTTfw8PU0m8OGEsEVLx38RKcorTkkYQKKVfQdNrrvqweHtuG83+iI1NvJJL9wbdRtZPZ78NPR6VKjrTOe3obZ7yNGhLNO9HlfYt8KlUmCy//JAxPwGyymwXMW8t7UcVXumNhIN6Kn5+xLR5d5jn7OxDtRSPL/euqGd1BHfyNGKzt9Me9zvMXMky9M1OJ6B1zh9nD71LPZWHD7ohekfX19LSU7JsW3X8GSK1gQFXYjheWKfX/DSs9nnSJniT/ZoQfySdsuVGg+joRhq2RIhEkOae3lE25+4ZTm4WI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7771.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(18002099003)(22082099003)(6133799003)(5023799004)(11063799006)(56012099006)(10067099003)(4143699003)(261102123227099003)(261026121527099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OTIwdWMzTUFvSnkrTUhmRjhtYkx6Z1ZhWUpEcEVFbmpZR1Rhc0tHdDhFVGlz?=
 =?utf-8?B?anBQOUp5ZURkMlVwWDBFZWUvTnNnTVZ2a3hiT1orbGEvMUFlYkpXQ3RHZjRD?=
 =?utf-8?B?bkNVSVNjbXdNMzB5VU03blZBMU9acXRUa1I5YXN6bmJFOWY0RklmY1JTRm45?=
 =?utf-8?B?SzYvaGxzNUhXK3JlMkRodGVEYm9TaSt2clM0bEw1NHJrb3JKMVRiMU1qZm5E?=
 =?utf-8?B?bUpMRVVsTnpDV3NTV2l6bitEd0RMY3I5VDR1UlYxcjBIVFJQa0FiWSs0WkJ4?=
 =?utf-8?B?QkVZRGN6ZGN0MVE2dU9Nd1NSOXplRGhHQTN1ZHd4U3RCaVBpSlkrNXBUWUdl?=
 =?utf-8?B?OHFTNldyS2ZSRHRnZGhNMi94RGNtbEV3SGY1L1QreTBkRzRkTnZIbVlBaFV6?=
 =?utf-8?B?YU9EOU85VXBoWm9lWURhdmxKbk1ZOXVMQW5hV1BDdmdqenJaZzZsK1JxcGd4?=
 =?utf-8?B?eFh3TmdhREUwNjVBOTllQXo1eXpLdTdYWUY1OHZVNkd3ZDNKTGxjand6R2Ju?=
 =?utf-8?B?RUlobzVTaGV3OVBtS1U2dVd6OVcrQ1ZwZ2xQK2JYVlpWVWNhMy9QZ0FGY0dT?=
 =?utf-8?B?RUhEUjhDeEI4dnBpUks3bmFtdDFYUzRCaHEySk1VUTByVTJ1THFwVXVhTlNs?=
 =?utf-8?B?MFRpbUtvc2llbFk0V2g0V0lHQk1ZZFJWQUc3eGJJUWp1T1ZxRXZwNTVnTjdi?=
 =?utf-8?B?RG1HUVFKYjlndzN6bS85M2dVT2YxNHc5cmx5bjhFbzRUczFDdFYvYlZFL1RO?=
 =?utf-8?B?ZTl5RmljUVEzTHFiTjVZTTloVDByV2pMcE1RQjBqWUNxRkRNU2pGdUo3Szcw?=
 =?utf-8?B?dlZEOGdYY0xyRExWYWRQLzNHbit5RDc4WGdUWTdBM2NrS2lHTmJFTWJybE4v?=
 =?utf-8?B?eVlxTUM4VVU2TzcwVk9adUtOUDBZQllJQ2xFYWU5TzJ0aW9jazQ2aHRnaWJZ?=
 =?utf-8?B?L3JQbU13aUQxV09yZ1lUejU0RWpZODVOcEttdG1wNnJMVS93NmRDSER3bXB6?=
 =?utf-8?B?bnV5NFluUk9Pd084bE5DUm94UmkvNVFKVEZZWWUxTk9LMzRaOVR2elZsTWh4?=
 =?utf-8?B?RGYyVGp2Ty8yM0ExY0J1MXFGVnNsdzVmNlp5REp0R2pUQndaQlNWSVpEYzBN?=
 =?utf-8?B?b1ZQMlRTT2ppbFdHUWpsSjd6SEt2RWlaNXlMOG93Tm5Wbjk4TUg1dC82WXR3?=
 =?utf-8?B?VHZET0QzaW5LdjgzUER1MWVOMWVrQk9GTTBqdVFVcG1XRWtRQUFmRjcxMTNN?=
 =?utf-8?B?WjN3Y0pmK2pVelZXd0hUbE9ISEo5dEtJSHBRNDA2S1kyZDhkSFpZM09tNkJK?=
 =?utf-8?B?ZW40QVordEYzd0ZYbTBQS0lVNkpIWW0zd0VqRWVPMlV4ZkFQc2pPMHlmWThV?=
 =?utf-8?B?SE14WENpMjRGeFF3S2ttWXorS05UeEtZT3NqZmVoRUNjdmU5MlBjODdlQnJE?=
 =?utf-8?B?RHVkcDJCT3p2cG40L3pKN2c2OEtFdXQzSVdSVnNubjFDamlUZFJNYzFBZmJ6?=
 =?utf-8?B?dXhJOEROd2UvdEE3TFFiUm85MUtHampWS3M5aGVoZlFIb1ljeWR4YmFjd1BR?=
 =?utf-8?B?dU9iTHhHRCs2cEFsV1k5cG95QnpNM1lONnhXNDJLV3V2SmlxcFB2bC9JVENw?=
 =?utf-8?B?R2tqc2RVcGZIb29FSmxlc2RUNlJ1akI5b3M2T29GWEs4TC95RWU0RU1rQlAv?=
 =?utf-8?B?TCthZDFkRTdid0FCM3NYcVhwVDdtVkZhM0RBNzVRZ0p6bHZFazF2b1p5aGlV?=
 =?utf-8?B?dElCUUxNeXFRZnJrSmEzbzE4M0w0SHVzZjR0dWlwM2UrNDB2NWtQMDRhYnNV?=
 =?utf-8?B?MU5QZFBHRmtyYzU0ckVsZzF1NlA0M0VQVW00UU5jWFUvVnRNZ1pHVW51V0hQ?=
 =?utf-8?B?NlhmZks0WGdXZFNid0NzcjhKZGF3M3Judm0yNzJyejRvQ2l0aXU0ZnZGaEN0?=
 =?utf-8?B?RnlYNUZSeDAremZLZ0ptdlJqWFNGU244M2MvbUtDOENuZjhXSVJXaTBZR3RI?=
 =?utf-8?B?RkRMMkJva2VRZjJ3VXlob2o4TXppZjU5RERXZXlzemZvZ2pPcXBrZmZ3QUxi?=
 =?utf-8?B?U2w1NXdvZzV1RjlEamRLQUVEOWtsWEVwYnZFZDhSTUlxclpEL0JpZy9hYmdy?=
 =?utf-8?B?N3BzalpYVGtXZGQyOE1GOUZQZHNkYkFFRXVTaW5yTFhURU1ndXJTMUJXMEVs?=
 =?utf-8?B?WTQ1Uzg4SWlQdkxlSUdsY2E3NW92eXpjSU9zZDdJbSs1ampRYnFoOGxwSVkx?=
 =?utf-8?B?ai8yTldnVmNDaWYwWU8wRlVBSUpxWUxyRnJGTXJwYUlHK1NUamRRUGFSaTVS?=
 =?utf-8?Q?jyygnE5lt/vqDhESY/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9f82a97-b289-454c-f90e-08df418fde0d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7771.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 14:10:27.5768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KgjmfHCexUebH+jHSZwdNs0/FPQ71Bf6nATS9hQV/6kwNeI9+3tbTFsUi00UNUkz3OQPO96zsGfloTX+ASd3bA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHBPR12MB252449

>> Accept only whole pages of E820 RAM, and clear the bitmap bits only for the
>> units in which memory was accepted.
> A bit in the bitmap covers the whole unit. If the hole doesn't start and
> end on a unit boundary, the unit at its edge is only partly accepted, but
> its bit gets cleared. The rest of the unit stays unaccepted and nothing
> records it.

Right.

>
> This kernel never touches the hole, but the next one can. memmap= and mem=
> only edit e820_table. kexec_file_load() hands the next kernel
> e820_table_kexec, which is copied before the command line is parsed and
> still has the hole as RAM. The next kernel finds RAM with a clear bit and
> uses it. memmap=1M$0x1fff00000, then kexec into a kernel without it.
>
> On TDX this is new. tdx_accept_memory() works on physical addresses, so
> today the hole is accepted together with the rest of the unit and the
> bitmap stays correct. Only SNP needs the direct mapping.

o.k.

>
> A unit cannot be half accepted. Given that, should we go with what Ard
> suggested and refuse memmap= holes in unaccepted memory instead?

Sure, I will go with Ard's suggestion and drop this patch. I will send 
the series that
refuses memmap= holes in confidential guests instead.

Thanks for looking!
Pankaj

