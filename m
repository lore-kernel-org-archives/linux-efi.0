Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795605661;
	b=QlilEXIWVaB1xcpUAdm8fQvBLOEhzP1e00mJmIMT50rsfHvi8Layz98xO+vSvxEsKV8u
	 Ch6Sq3gLSXygH67fUhcyKzs+YSFgAMj6alQUiFA+GnaYuY2SyC1cQmNcMQp4PwYx0Bpa3
	 KfsA+yR+IevwZMwVKRNudT73my9+cGdAqmQvPC9/NIYIj99yQHT1AujgUxAiUGt5tG+b3
	 MW62QXhWdUfspBIq3ifu9Q1S3Ke/2DJq5RNvdTMSZczxqthKBVoUO/LFShA7MLhQiTffW
	 ZS/Skt/nCtfxzy/p1h/lQFjNNMwDRJGVB+QLJ4LjA6u9pyNNUGnN0a169vo16R8+X7Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795605661;
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
	bh=QWyBaBycKU/JGZa+pgwyGtDxup/qkTO57rEfc8xSAls=;
	b=F9Xb+YOYJElCGdhJ5jAsE4IqJoXxq7qfIKN5idIbECwnYA9DlOoiFfarxrupXH6Llz9s
	 Z18DrM+QZcT9fAQMS4zxtAj6yglPoOH6WXxfPW1s7vC2kW+kSGo2lFvH+hiG3I3m18n+I
	 3YWa8+727NZpzEz1AI0o90gEsunyL1bqZikolU+98VJj3TL+QwdMfYvN8vFA2UZ/5IfY9
	 h27Kr3iDU4zJapmJqBdi9QsOWIqTxP3oCRX/Hdbw5531IgwR5OXFWqTdS8uyZytTmvh8s
	 wtyGRkpDJ41aTf3p97lGvF3zZ1jqB38IKOqX7PpuaxoPz6msKKXssE/krZ3X6eUZh0Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=ibvj9uhf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.30
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012030.outbound.protection.outlook.com [52.101.53.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA67B606A321;
	Wed, 25 Nov 2026 11:21:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA67B606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=ibvj9uhf
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OIdgcHQT6VQTSSpGCPvXoxmUUa29dv9w+PsCHuWvSvZuY2tFHKom7nOoMUbFNz0rZE7/Vxqey8VOebCQ5xx6zWdH2eX9LeXptuftQ8Khbrm5oeLH1Jv0qS8ZM/F6mCuFNqBBla1OaqV9HU/5mp4jbt1pUzXko52hiw9oSuYhMUhgMl6ApaY2C8/A/CQ8VJTpItn+orgNRs3735woR6RBZYWBbVix7kU0w/q84euvYKSLiBe3HE+i3nhD1cifpchI2yo069SJerZzEvOUaINzwKodP/5yoT7liGdsq6LZnRhadPG8ZJzo+w79e8ShyXlxfOldEaEX2gHhyrDZj/7tGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QWyBaBycKU/JGZa+pgwyGtDxup/qkTO57rEfc8xSAls=;
 b=xu9M6Fv81dYejvYUGZ6/kaX9fPYeYNABWpHs1Z5DxfsZVbOh+2P9LEXIztAmdd+rarZ/Bg+ziCBe+x4XsobSF3BkVxjtKqJjSPziasfvUoUJ+ZVObvNjoILkGp0oZroiBGg/mLx1r8w2yvg0E1EllJthz8PM1bJXPEzx2bY3qbabyHcUPTYqRl/RVDUbs6qqtQNx36dbbIQiTElZjIjpbD1NsT8WiYfrtBnU8CxsVKVQxPT0iNwjOSeCKXT7yfk6d/ekAloQ7JFBlnJJGfko9Q47ZThz+Y+wzaFkt0npQaonw27LWocP5kzGwIZ04w+OuTCMkQo/YLAonE3YcUfUIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QWyBaBycKU/JGZa+pgwyGtDxup/qkTO57rEfc8xSAls=;
 b=ibvj9uhfWuWMBylxRj6n2OAh6pZqvjSbePp/pZW3NlxmtjANm6tOgSDGQ3S5q4Y+oUyqdUjy5UIdPRCUc40QIjkQhx8PB+jkIrJ8D65ogtoB38YEGHLkrBHNapV9ls5rOPnSoO3nJbDY5xBqFEfBor/dCcXEBNpmfLy87jovQ0Q=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB7771.namprd12.prod.outlook.com (2603:10b6:8:138::6) by
 IA1PR12MB6388.namprd12.prod.outlook.com (2603:10b6:208:388::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.6; Wed, 25 Nov 2026 11:20:58 +0000
Received: from DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c]) by DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c%4]) with mapi id 15.21.0639.011; Wed, 25 Nov 2026
 11:20:57 +0000
Message-ID: <7a7e0452-7cd7-4d43-ad78-f907f62b8bc2@amd.com>
Date: Wed, 25 Nov 2026 12:20:52 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/3] x86/e820: Ignore memmap= and mem= in confidential
 guests
To: Dave Hansen <dave.hansen@intel.com>, Ard Biesheuvel <ardb@kernel.org>,
 Mike Rapoport <rppt@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org,
 Pankaj.gupta.linux@gmail.com
References: <20261124133241.221719-1-pankaj.gupta@amd.com>
 <e08f2321-749e-40f6-9ed4-3dba8e1625ba@intel.com>
 <awWzrkLxfQ2_ODKe@kernel.org>
 <2dd40d0d-2e1f-4a7f-ba65-2cceccd82028@intel.com>
 <awW31hUpXuujSAXA@kernel.org>
 <c0e82936-9436-45e4-a8b6-07bdaa9680df@app.fastmail.com>
 <96be8f5a-8f65-48ff-8263-1d5d5f706354@intel.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <96be8f5a-8f65-48ff-8263-1d5d5f706354@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0419.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::18) To DS0PR12MB7771.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS0PR12MB7771:EE_|IA1PR12MB6388:EE_
X-MS-Office365-Filtering-Correlation-Id: e79237e6-cb89-4366-75cf-08df4ae62d6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|18002099003|22082099003|56012099006|11063799006|5023799004|4143699003|261021121427099003|261102123227099003|261026121527099003|10067099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	xBJ/wCoQRiePhL3O64ZRZgUjYCjkwOwE8schCKYcbKpt5HEoHqMagmr6DCzkRY7bS8H9DyMCYLt8hy6SWzLDQ4QW+C65A/Jmq4TGdAHK6naJmbXxAW3U6PZQ2oIbduaJCZtZaW9hh+Kr61LTKFM9B0TLtxvbJGpqIlhoWpW+7thgGo243QdAITZIUln384BQdqda1ZYaKj3/xsTyQhBsVdKEdLw4DGBvrAxBetchh9N62PXA9sJVkNqchORlXCiEmOjH6JNT5MFogZdfmfOP47hIpCQASx4k4GEAgG7eDZz4TEG73IDqiP/0AMt06j9rd8MIAG4XsvuOMHlcd9FB08jGGe+HFXopyAWHXCKG8TaRKjAikM08hSvkOEsZ8E4rMZWMIiLKh9bTwem20XX0CGnaxNLLx0jg+NT8FmTIOZzFRMsH2VzASPpbsNM8R0p917obyOiBi0HFO3vgYiATwPsp1aLMwiWtLYR+RSJ8l2V6F3j0jphpanH3oqaguqMobuoL4dP1MoqQGOu3nl9qw+AXTJnpefV+cQt3DRL64biI+c2dxY8sQgbTAoCTB4uheos7oahfNkVdjyx7IjiyITc2UgVwV90bLMIhPSLONLRSdIJ+28guLbX/amsXn6WEgBQQxub5e4wRnKZx5FqgC3RzcIabCPViWlaUSiO3V6M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7771.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(18002099003)(22082099003)(56012099006)(11063799006)(5023799004)(4143699003)(261021121427099003)(261102123227099003)(261026121527099003)(10067099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1FjL3ExSkhWTWl0YWhKQiticnAwUW5xYjRZa1JPM3A2eDNJUVpwSGJlRGlE?=
 =?utf-8?B?WHVJd25leE80QXJQdGhZMDZzSjhkQllWT3ZuYk5LWmdkRFl4MU5INmRUYVQ3?=
 =?utf-8?B?TDA1WFAvMkpWeVlDc0w4bXYxYnVvdmVINDVHbCtxNGZXRVIxeXpsQ2RsNFBE?=
 =?utf-8?B?VGVHK0pGa1hRMmVrVFNNQmNZRWx0dkt5Y2FyS0cydEJRcXVaTGdpYUt6WXh0?=
 =?utf-8?B?MFRUeXAxQWRLek5GOXArQ0ZXTnpMblNGb0d0Vmo1QzZmeE41T1ByaE8zb1Fp?=
 =?utf-8?B?cGNzVEVjU2lRWXJlNUlkQ1hRWWFXRHBPanN4cEZ1UnRiSzBZOVZ5TDBTKy91?=
 =?utf-8?B?RytOenFBNjFBNUgwOXB2UVVyd2ZEb3RxaGsyY0J4SkdRSk1odWwyUUF5OGJJ?=
 =?utf-8?B?c2M1YW4vclZVaE9Yd0QrVmt4ZVhmYm9PbWhidWlYalNza1QvNUxrQ1JpWjVZ?=
 =?utf-8?B?OEViaU96NGRYbzRKYUdDKzVwemlmM0JhQWE1ZVNvTjNxdHd4Qnc0RlVIRXNY?=
 =?utf-8?B?Y0YyMU5yNmxpT29uRHRtQ2N3MWhhUUZlb0hBMTdxNEs1NlR6Z1Yrekg1cllR?=
 =?utf-8?B?Y2lJSExDQ1NoNVo4T2poTkVEeEFhcG5HNGR3bkJ3NTJUSitPZCtvMkdYT3Rk?=
 =?utf-8?B?YUhQbkhCeGZDQUNTM0VpUDJYSldnblVZSS9PSWVHTHVjYm5IQlZHYkdnY0ww?=
 =?utf-8?B?TVJMakZxSmQ5alRUbXhNdFpKcktFRHhaeWNjY1NUQ2FZYk1sbUtGdVBjTzg3?=
 =?utf-8?B?RUQxL2ZvNVcxcnNKeXdzYWxSUFVsSyt5Q0dIcHVURzVFMzJQWVZ4UnRCVVcy?=
 =?utf-8?B?bW1UTEN5S0VmaStTdllkRFFVNGZFbVlzVGVvUXp3WkZzcE5PdU1ib2RsSklv?=
 =?utf-8?B?azM1aituazQvMUlPaUF0RVQyQTRPd3g1aGxiY0JUTGl0WmVmTGZ5UWVVenZQ?=
 =?utf-8?B?QlpQVG1WQTVvcWp2bmNYd3E0Y3NWSFp2S2hOOUlPUFhRQ1RMUWsyYmsxZEEr?=
 =?utf-8?B?OENlNWJobm41c25kbndGM0lUZUtuNlFoWm0wZnYrVGJxNUZKUzAvaVFBeU1t?=
 =?utf-8?B?VnoxNFFKNVFHSGZJdEJYWTVTMHNFR204Z0VlYXZ3SFNtTy9vN08vaFBkaGl0?=
 =?utf-8?B?ZFlEeSt0dWV1ODgxVFBBL21wR2JvSUlRYW1VWTJ5NEl4OVdSUWcvN2xJU0JM?=
 =?utf-8?B?MU00Qjh3ZlZXWFB6R3FmdC8xb0RJMnBUVEkvYWh5RWErSFVkaFd6L2JwRWlN?=
 =?utf-8?B?dU11UUhYSEtJK1g2R3RuZDA5MG00cHU0SmJYQWlXZ2xBWGwydk9vR29CSEZj?=
 =?utf-8?B?TzdkMS9ScEdjSW9vcVlBbVp4Vjd4UlJONnY5d25XMjdzRzhaaEFsZUdoRUUw?=
 =?utf-8?B?ZnY0ZGdOb0I2SW1Vd3JpS3JFRUMrYzRXaEhOMjh0RzhDWWttMmdRUkJiTmVL?=
 =?utf-8?B?SUswT2NDTWI1bmxzV3ovajlXc2dQMFRUMXNhSDYzV0pEOENkSjczVGFyTzRQ?=
 =?utf-8?B?K1l2SGVxTHJ2bmh6QnNEL0pRN3UzbnJLbVdURGZmLzlUeDl0bFl2T3VQeVlL?=
 =?utf-8?B?Q1lKYjNRTURsbHU2MUFnekQzdnA2NTBFUEVXMDBaV01veWVMMlRVaHAxWXVs?=
 =?utf-8?B?R3dzR1o3NC9xY1Z3TU14NVN6NjkrdEhRRWRDd3QwdTFSWkQ5azM4WXFvTDlm?=
 =?utf-8?B?Q3JQdnh4NnR3STVvcU1zQWpKTXFmY0FaeG5xWkhRVzJlbG1IZUJ3ckZLK3Zk?=
 =?utf-8?B?Tm93RGlZM09lMkFpSTIyaVB1TDN1eFVuVmxSNk45UFgyZHNNdjI5SlJWelJU?=
 =?utf-8?B?bE9qamUrL3hnYzdBVVo4Q1RkV3F2RHJGVDQvQzRWczlTenIzS0s1dGtRc1Ju?=
 =?utf-8?B?S3BORUZxWjR1cXAyR3RCN3ovMkJ5cG96YUJmVmxpd29hV3NtRFJGU21RMFh4?=
 =?utf-8?B?SWRvSW4yV0Q2WGQvbnVvVjBvS3JROGUwZ2oyclNFbGQ1UlNtaDc3cG9HQjF3?=
 =?utf-8?B?a0UxUTFLdFJ5QW9YU2VER1gxbEQyNXpVMjhKQXJOSGxBUjlabUZtakltcWZJ?=
 =?utf-8?B?RFZDL2dNSGx6cEoycm90MTBzZGYvaTZZaHE4UHVsaFBVYVpzV3FDbCtrQUdI?=
 =?utf-8?B?QThsS0RkQ3E2Ui9jdlIyTFdtUk5yL21lRXBaaExLaStUMFMwRnpRb0MyVG5s?=
 =?utf-8?B?OXMzSklZUXhrS3h4YmQ2OGsxMko2L1IyK0RvaVlNK3ZibWxqaVJpTTF6ZVM4?=
 =?utf-8?B?dTJiRDV0OXhWNkk1Z3V4aTRDcVQ1VjZRdUhqQVRsczdSZkg5ZGJPaERUNS9l?=
 =?utf-8?Q?N7ehObFLGs4Ruh/nsC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e79237e6-cb89-4366-75cf-08df4ae62d6f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7771.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 11:20:57.6488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z2sQaBQm/iAGm1NnBumj++X1uGQO012q14JHtHfdCsjfsPl+zuWzjIRGcPjuQPixyF7xAlXi+j4MUh/Eb1YtZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6388

Hi Dave,

>>> They shouldn't but you can't guarantee that.
>>>
>>> But I don't mind letting them crash if they do 🙂
>>>
>> I'm fine with either approach (i.e. disallowing it or doing nothing
>> at all), as long as we don't pretend that this is something that is
>> expected to work.
> Yeah, it's not supposed to work. I'd rather document "don't poke the
> sharp stick in your eye" versus trying to make the stick less sharp.
I understand your point.  Ideally I would prefer that the guest does not
crash, so this makes me a bit uncomfortable.

However, fixing it would add complexity for something that is not
expected to be used in production. I will send a patch to document this
behavior.

Thanks,

Pankaj


