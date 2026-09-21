Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013002.outbound.protection.outlook.com [52.101.83.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBA73546C6;
	Mon, 21 Sep 2026 09:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.2
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789984294; cv=fail; b=EALNN2PuRi0v1JoyXO+2s7k7QSMgbT6mjEJDov9zwWbvHF2jVbshCQxVjQ9ji7GSB9yiJboRAZ0qUDZDoD3k/efW2jw8gPoFIV19fbgwprf+nbMSlmQ/lVEbxgXcdzOjquP0D2877b2c6t+Gs67Xoux6hAdpSNibwe+H69mR+tQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789984294; c=relaxed/simple;
	bh=QU8NiC2pkPh9MV/SO6uh04Dn7QpE1hVjkNy2bTZbdY8=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mTGvrvHGPwvi0S7e+XwdLja2R1gCMzC/1YiGIcDZkG3aAwKwHlNpyJAAYbdUgJk4cS6L6AdEoN36dVVDoPzAVytxlfwT5H9mG4gpcje+14l69qvCWSlIdXmkRDU63SUaPfFKsEQf3hid9r7viEYfjVeiX11+3kHBZX6/B+ocUBg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kTQwTdUy; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kTQwTdUy; arc=fail smtp.client-ip=52.101.83.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kTQwTdUy";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kTQwTdUy"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Uvh5fZxFHWX61M7CgTZ5+i32Gh5JUgXRPYQ3GdNdq0WVzth1OqwykSt72vTp1e7gMQf/VUt2uv7jLmlgkBqCc3Hl1NgFiOGEgNLZE717sPjg7jiv0LFCtOffA0bcH8ycN39Oj/AJ2UuhfRCL34W4aYbzZLkhMMtNa7hBF116mVM2Iu1m7ZjsvaZGB1J4d2gH09kO9CZUMl3UL82hXGgrAjK/Rt7Nf+wiCYErayk9YYw6kgiQJozEAGhh/6WZf0XkcJQucGlBub8fCeZdJmpjFmwwnV8Mhq0NfyHdFr7ee2hsLbl+ipEYdsHCxb27aiuJJIILynVZ72D4fT3fW85zOw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=orKvpeqkKoM8WgynMkKmVpwIwgecSBthzT2hDgJ1qW4=;
 b=lUcNy9XhzRTCnj99BDaCK5858Yv2jWs+tWupnNhMYgM2xp3ocu9A5Kyg54oGTaEQpTdlawfXxJXk8k3baqUh5kmBh62HLRi5B/3z9G9c+901cyUqJKVKEr75yNkvFHaZRMeaDjmrB+AYO58bBAK9t/28fUITciY9IOU7nsBC7zunFFajmvPPCdhFJjAotLWLlbmPqi26Rh/ll8NOfV9hov5oyTZRhcZGoT7wu8Bbpc2DsE5rC2Ww3K5n+ah9tKWdFNroUaxzYfzDx6H0/qpoS8GLPtC9xljcuSTNISnbCFB0VZolDYAX2Wo7qm7Wfet/8VPlpsxrsYXO/7o5gtjkAQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=orKvpeqkKoM8WgynMkKmVpwIwgecSBthzT2hDgJ1qW4=;
 b=kTQwTdUyqNIDyIvZwpNamhpHKIv6LL7tqCtwMtJBzGHJ5ZPF7DkGoVDQzCyEZZQtUM0jagxe8qYeIwkZ7n8mAou1i0iG8RHolzZqcDSCQ4GQuNBL1maLz96NcAqMp+tHehZJTyoeto1fVj4bUTKfhFvmorVMck1fZbBy0u39yNA=
Received: from AM9P193CA0030.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::35)
 by DB3PR08MB8794.eurprd08.prod.outlook.com (2603:10a6:10:435::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 09:51:23 +0000
Received: from CPH1EPF00000530.eurprd05.prod.outlook.com
 (2603:10a6:20b:21e:cafe::8) by AM9P193CA0030.outlook.office365.com
 (2603:10a6:20b:21e::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.16 via Frontend Transport; Mon,
 21 Sep 2026 09:51:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 CPH1EPF00000530.mail.protection.outlook.com (10.167.241.171) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.8
 via Frontend Transport; Mon, 21 Sep 2026 09:51:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jgNGrj8+HHAnoVDs9t1KPVng2+bUd/mAWzl80z6t1J4sHy8e9lYsYwWWtjbpR0gwjClSmkj7hCmo/MR+7CkXIy7nlF4YXdllfamvL9SYNMqU3UdJW0yLcYwnQ64vjp7NZbgMKkyZj7gB0L7mZ1T4ioZHO2KhqFf7Sa2hGIjk34U8qaraIL3doEL+Uo0q3ZhtxfaSWPQGlqgObY3oP/xFLTWPv7alJG/85D41VRZQwQolcn0P7VAAQ8aC3pj17PtprMZPmh/I2drSR/fGzAGvOWEe5RNFw2Sn/iTJ+tXStxiIX7a0iI6I/oLwVw+3aKoN4D6bgfdClSvCM1w74oB+3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=orKvpeqkKoM8WgynMkKmVpwIwgecSBthzT2hDgJ1qW4=;
 b=P6LrWibkxRA+HPQ0EODtjniU1JMPeP+mSUDRp4S9lM8GqV6buu4G6qakOqpmWDyPlrafTp3/v6qF1jI+97L7e8rhiueW+CTC27/SPqNy/qYw0krueA8ELMZuMQptbWyhEAxifkG8cTg6JneumcWuknJqRUwXNurF6eFnHvdvTRuFuRhhDMlcP4qIvpaF5U1WGb/PeJgjoY2ZpfHKFmwigDTMU9XYGNyl3SLqV0ZOGCNCi9owXmoC7wdhvblAqo7pZMm1Ast5Zr9mLxxlq5x0uTvnLY6tcmvTQ3T6aImtzyjKKvmmYUc7/XlSefaYaXc887wSrHTemUpPkVW1qvkuuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=orKvpeqkKoM8WgynMkKmVpwIwgecSBthzT2hDgJ1qW4=;
 b=kTQwTdUyqNIDyIvZwpNamhpHKIv6LL7tqCtwMtJBzGHJ5ZPF7DkGoVDQzCyEZZQtUM0jagxe8qYeIwkZ7n8mAou1i0iG8RHolzZqcDSCQ4GQuNBL1maLz96NcAqMp+tHehZJTyoeto1fVj4bUTKfhFvmorVMck1fZbBy0u39yNA=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by DB5PR08MB10023.eurprd08.prod.outlook.com (2603:10a6:10:4a4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.13; Mon, 21 Sep
 2026 09:50:49 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0451.004; Mon, 21 Sep 2026
 09:50:49 +0000
Message-ID: <e044fdbc-a648-417d-9949-6e4e51040aa4@arm.com>
Date: Mon, 21 Sep 2026 10:50:47 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org
Subject: Re: [PATCH 3/6] arm64: convert between HW PTEs and SW PTE values
To: Ryan Roberts <ryan.roberts@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
References: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
 <20260914-pte0_arm-v1-3-bb53b663e396@arm.com>
 <86d4aea6-4272-427e-9229-295489e068d7@arm.com>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <86d4aea6-4272-427e-9229-295489e068d7@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0486.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:3dc::25) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|DB5PR08MB10023:EE_|CPH1EPF00000530:EE_|DB3PR08MB8794:EE_
X-MS-Office365-Filtering-Correlation-Id: 720387db-fb0c-4378-f160-08df17c5e4cf
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|921020|6133799003|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 l2SHpBKVaA5142jj8rwdMQjSTdYikj5Tts0ndkO0A7UuzzgTCw+2uRK2w5NiVcUrYJdHi4gT21kyDZXyzLLBFBusqaTGGZ1yv0X6llJ52+JaiEVLvrnslIl7bw25YQ6Da67sNUT/Ojr9sSTZ6Ddbg/Gp1sa0XjRbmvFh+2Cn281/2AX0E6/TWRdVLcMvTlpmefbQKZ6l/5IvF/DLet7xpqaWEPGhfyXKc/6rynhPJyafcqsCijiqklx1EARlT+8z7Ry/RZpdISZ56R7E5sFT9/8C/ouP6dOMobPReH5vhRUpcdyRcfWhvODXl0K8y6ulxXbPwzNKnm0NjZ/sqij9jNC97AFV0LpHpYKpggkLwpT7jaXN2PQ0y2UG38ABMsarXChojCTpv1BaLWtyUSHj+w3xIHE5TLKIB1gSQnH0wLepzbmBbYLY1dvbu+9qHoEJ5nAdZ5Meo+REqobDyFCIfUIqYoaDSxbmi0dX8DC/ahJEqXOYXILYs6bm+H9lfTmTX3BRxWYJeC79c3l0UZjP1GY/s4oB56U88OXL1L8XIJ3PR6qx6XTEJghPj6vNKCl8mVRrO4UMUDsU1u5xfLmewVs/lr0lYkWCm+S1Wijb+o8clddsV5FdTjMd6zTQuNzRa3c3J1CpH5O5yMpihuXbLAus76iNa5DpYSyrRmUMgIMcN/GM+KoR3hNH5JYBCIVeYpDISfGESI1s0HkqzdCmBQ==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(921020)(6133799003)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 e7Ov9zfLE8kyPWXOuaBNWWIs8nBhk0gXD6fUNj3xP9lXu8bz3z6FiHQ8pQumAULYLstrS9dp5n0Gf4KJvievn9WStFtkuoDUEN2gW7VYnATzsDHe7ekF5dJD5nMnHU3+6+5wjKIW7ngFgdvBb9GS6KA8YzIQANp5lsT97MzGy8xPXsPcgDqPDvR/kSp6J9L289WtOwzzzP0v4R8RA6/U83/b9NzSjG0Qff00qgcHDqXUmDYywIr8QJTQNYluuh7RB4WeVBYCzm9d8FVsjLy6wCkHuC88hasxBXho/TAgT24EAgdQh7hmI4i0WA4Ym05IgD3gbPdnBy+Qm5kFLkt9Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5PR08MB10023
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 CPH1EPF00000530.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	964fcc93-c640-4efe-dcfa-08df17c5d106
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|35042699022|1800799024|14060799003|82310400026|23010399003|36860700016|921020|18002099003|22082099003|56012099006|11063799006|4143699003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Xi3mT5C5Y6CldZPzDWTWgYHJdePUayXmPUosTqNNGTKzOWCo9gYYQubhFdyQVLLJRwdeNRWXLOMR4/dG2I1TlHf85d0tvo9tOfldbZjW+HZLR6logRdXQK+Bwn4Nt6lDlRTuYTg3+4Et0hIcntYbKiW3ZyrgzpTARvlCiX/QptPdwFhHr/QWBz1JSOJHxjYt/L+qPM53tV9KxyQW577Pe6clxITTdHiMNDV99w2PNCy9EdaqAyWArpviqQ3Pd2hKp1Ph3k3vR5KpNx3OXYOPqQEnWTeg7kF6vuG/ZhFnNPnkAqmz+ahF7FzGe0/9qkn7+AqP5qEvub4HDRZ8atLC9e2818QH9LJhUmzwhYh+zdEEXzDQ21yMmcF8GqJThPJ6npx6K7Qdx0ZB1L0df91rf9S7J2aQNjn0U37EOuWcSH8Ktks2QoSdzwxqyeT8lWXVQlGzukYMz1zKE9ZNSqKfjFwSxcQ0CGv/fJ7gZQ3xNYNTSh8zTc+imzz2F8ns3edzkwnc6RCl/JkY7W6tKjz7hftQVkRMVIokduFwMgVuz4b4KlsXclnRkt+Gb8pEvPdrt/fWz/w6JbWlMVxdt+HVWj0DxCfTHZ0bgyxvy5yHxsk2v3vpNjqe8VoaZPPVHe2isoXO5aN0SPG8UgehDMStLiEhB0FB3Z9DrHPZXIDxxKMWqaPLHvLqyXPJ+d+4+1ntdvSDwPMmFMeMjQCumsMMtHxUhgs4Djo3KBHPzi4Db6Gfork4qGZ5XuUmusM01rld
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(35042699022)(1800799024)(14060799003)(82310400026)(23010399003)(36860700016)(921020)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SKwJXYpbW7m2Q30QdVd2RsWZMCGBqsuigZdJD4aYuvkeSd59/0Q64OIlWdww4mlKWeDP5D28dk9s/v9WW2i4kGYO98EZTETsBUdMA/x3dalmT6MMJU4hBrr9VmvbnN8upYskiNh7GFbvEu0QNQLtWBD+qrxot6vGZ++jLiBABfXWyR0+9sAkUvUZhBdKJaxGDWJVIkCfJbCdI59T+yehcea97yVfbK4XufX7LNiscbdQKe6XVP0EpaP/5xvQ81JQ+kgX8CMMrXpiTudTROTbC3oqaYqddjsU1W2Ol78D1sgjY3zp6LAGS5Sd/ZXieIMG4U0Bgop9KiWJKPJv+f9Uq3WgZ93o8A9cJ2CvMQztlR0XBxqgiLzpZrxW3NiKq4UhDg4C/Cgg23Ergn2F31BUm3CyJ8qkbx4MBRuCwqboBQp+Q2lgYvOxeBhn+OB4B2kg
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 09:51:22.3351
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 720387db-fb0c-4378-f160-08df17c5e4cf
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CPH1EPF00000530.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB8794

On 21/09/2026 9:26 am, Ryan Roberts wrote:
> On 14/09/2026 14:51, Muhammad Usama Anjum wrote:
>> __ptep_get() returns a SW PTE value, and __set_pte_nosync() accepts one.
>> When HW PTEs use a distinct hw_pte_t, directly reading or writing *ptep
>> as a SW PTE value no longer satisfies those interfaces.
>>
>> Use __pte_from_hw after READ_ONCE() to obtain a SW PTE value and add
>> __hw_pte before WRITE_ONCE() to form an HW PTE.
>>
>> Define __hw_pte for both the wrapper and alias configurations so the
>> same accessor code works in either case.
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>>  arch/arm64/include/asm/pgtable.h | 4 ++--
>>  include/linux/pgtable_types.h    | 2 ++
>>  2 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index 4768ec59de555..67c4a6179e154 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -360,7 +360,7 @@ static inline pte_t pte_clear_uffd(pte_t pte)
>>  
>>  static inline void __set_pte_nosync(hw_pte_t *ptep, pte_t pte)
>>  {
>> -	WRITE_ONCE(*ptep, pte);
>> +	WRITE_ONCE(*ptep, __hw_pte(pte));
> 
> Would this work as an alternative? It removes the need for the new __hw_pte()
> helper. In future, converting a pte_t to a hw_pte_t won't be trivial so having a
> generic helper for it doesn't feel like a good fit.
> 
> 	WRITE_ONCE(hw_pte_val(*ptep), pte_val(pte));

Yeah, this would work. It removes the need for the generic conversion
helpers which is even better.

> 
> In general, I wonder if we should avoid defining both the __hw_pte() and
> __pte_from_hw() generic helpers. Conversion between sw and hw representations
> will become arch-specific in future and for arm64 that conversion will need
> extra information so it's can't just specialize these interfaces as they are.

Agreed.

> 
>>  }
>>  
>>  static inline void __set_pte_complete(pte_t pte)
>> @@ -381,7 +381,7 @@ static inline void __set_pte(hw_pte_t *ptep, pte_t pte)
>>  
>>  static inline pte_t __ptep_get(hw_pte_t *ptep)
>>  {
>> -	return READ_ONCE(*ptep);
>> +	return __pte_from_hw(READ_ONCE(*ptep));
> 
> 
> ...Corresponds with:
> 
> 	return __pte(READ_ONCE(hw_pte_val(*ptep)));

I'll update. 

> 
> Thanks,
> Ryan
> 
>>  }
>>  
>>  extern void __sync_icache_dcache(pte_t pteval);
>> diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
>> index ee4eace5c3e1c..b5862a16aa497 100644
>> --- a/include/linux/pgtable_types.h
>> +++ b/include/linux/pgtable_types.h
>> @@ -9,11 +9,13 @@
>>  #ifdef CONFIG_ARCH_HAS_HW_PTE_T
>>  typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
>>  #define __pte_from_hw(pte)	((pte).__pte)
>> +#define __hw_pte(pte)  ((hw_pte_t) { (pte) })
>>  
>>  #define hw_pte_val(x)  pte_val((x).__pte)
>>  #else
>>  #define hw_pte_t pte_t
>>  #define __pte_from_hw(pte)	(pte)
>> +#define __hw_pte(pte)  (pte)
>>  
>>  #define hw_pte_val(x)  pte_val(x)
>>  #endif
>>
> 


-- 
Thanks,
Usama
