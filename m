Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.160.110
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795529215;
	b=JJ4CiFkuttA3agvscBqt4ZPgmkGJSDerQC6uAIUzagqL1kBWymvJRIFOvcVdPbcHsEre
	 cr0mzmJZ9LVmhdBxoKua4OpIB0waU3HMJmuGSmjD0SrhmFox12xCd4MxMy4E7ixyPhxAD
	 WZTnanSVhJhx6HviT+iUPxvvZv8UZDCVlegZqEN4u1bx7xYQHPUhSFjWdL7XWeaeB0Bxs
	 QMwjnsGJ5i0gsKZNtX6CFIbf2lTauX8LNzaS0Rox2Kc7cF8xK/gnxg6Nq3MQxgqkSEoCf
	 njVmY8xvIe6+39g121lILkcuGbP48yEvb4CC3zGITEMoEBHwtXVNjlipdBsADSyOVqQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795529215;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=uAZyIjIYSxUKllcewpoHABXS4mX8F9Jyc32ESP8v5Es=;
	b=R//Ja6oms30vdEzxycHsbA0hezheIXiorONzetF13FV/7csNRXRqYDNKsoR5cZYQKER2
	 R8F2PqDeOp4oMC42869Coqm75xJ1sJYLcmQm0Cvc4azSxO4k8RnsulRW9ICwNuhmxhqc6
	 MbA3YCF+fbRlcqV2HQ0jRjm4X0nBY274RZ2hJ5JG1erkfBJSMsMdju6QUbiKknxHT3txQ
	 yfDUWLOaXC/gNv+NE9j5oo9Bi0kSECI0Tz8kiyJMCje3CtRx0no1jEw/AYDUKXPdmBLZM
	 vLN4gNyIh8Lg3gAUSYhg2RXA2VCsAgtDBA3gbXF7H82rYITxLQTcenEcQGaXb3Nq4gQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wenske.fr;
	spf=pass smtp.mailfrom=wenske.fr;
	dkim=pass header.d=wenske.fr header.i=@wenske.fr header.a=rsa-sha256 header.s=selector1 header.b=dOmdpNGj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.160.110
Received: from PAUP264CU001.outbound.protection.outlook.com (mail-francecentralazon11021110.outbound.protection.outlook.com [40.107.160.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CE360A380A;
	Tue, 24 Nov 2026 14:06:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66CE360A380A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wenske.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wenske.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wenske.fr header.i=@wenske.fr header.a=rsa-sha256 header.s=selector1 header.b=dOmdpNGj
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qj2zb3uHv+XYxVQk2XE1veKj/3E4aF7Gmd8Isrjcj3SacXU45F8VgrJ2wBp8yzFPuY6eGd/XB0dg/SZ9DgtIf147vb52sHu845aK3yZrYHCwpacYCC2vVAVdIosyKB1R7jKGSM+BZT4OFTklWQWeeIy0GDyUVo9FrrCloDVvoIkyKQtGqv5wj7wLDoeQXF+d4nAtJ93ZzqbvHnhdfYLRGVnb5eEEjDk3LEmb/8psFvFEIf1TPYYNPKWGnZBpwUaD2qo1faKRbGLegIZYBXlCnAbSKTBhZEIcZHssL3jyKQvQ/3ElgZNJmhGAt8JS30Sg3TQoz2Gfs2viKvwUq7HiIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uAZyIjIYSxUKllcewpoHABXS4mX8F9Jyc32ESP8v5Es=;
 b=VEnLBGE+tX3HsEpk+Ed9CeVLUzwIWJKjmXKQyarZcr7DERAZOfh0hjOlhhcFTXlSA7NJ3H8t33BIzQkr4ltpAxdpj38LM9HdYh8b0t+6DPRrUGI2SeRwOXOSWhO3ugx0vdPUxPWUDfbfm54GgrySCBD0t91rSkEApWcDRvXVoZdxHYk3W1U9PAWLbokJgUKvHm6Nlsl+h5zCc/aicmWurASXHvQi11pzrXlzaJ3Nz7e1Nos/hxOAhCNaNk8dRWxsSzpWrfLHIlzUWpum7CHe4m/BafRkGvFmcp+Lobwh3wDOS9ARLjfc+akp01AqJFeWgMYFsI7wJ9G+sD412W2R0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 82.65.107.217) smtp.rcpttodomain=gentoo.org smtp.mailfrom=wenske.fr;
 dmarc=fail (p=quarantine sp=quarantine pct=100) action=quarantine
 header.from=wenske.fr; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wenske.fr;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uAZyIjIYSxUKllcewpoHABXS4mX8F9Jyc32ESP8v5Es=;
 b=dOmdpNGjSx2fwcAPU0V9qnUfw1uPRQu5JdKYSGT7ivPsZo0uLfHLN8Yv1DaJ6WaM8IXEq3i7GL2IBhHl62Fo/gvjsP4w9oq84/ZJ0iBNII/6xJLZZlrX9gnoW6TKz19C2eiIDG8jct9TasvSTBvDgDfpDZE0ITqZnnNHP9qQSIzdkWtv5zAj5opbYbhCrgKrTHr6FlOG4mCMm9A48AR5vjD+Xyd888tB8dnC6/KXPQx7zWiplarwuU7OikWAXz1rtxC3bnGzTp14fz1/SHIl6kXsQUNHQE4XZq/b7WQM0aPUpiRkENyLxPqGTGx+rQTdF7A7WqpF4DK+0i1HBDnvug==
Received: from PA7P264CA0262.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:375::13)
 by PA3PPFADE62A42B.FRAP264.PROD.OUTLOOK.COM (2603:10a6:108:1::67b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Tue, 24 Nov
 2026 14:06:49 +0000
Received: from PA2PEPF00019230.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:375:cafe::51) by PA7P264CA0262.outlook.office365.com
 (2603:10a6:102:375::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.15 via Frontend Transport; Tue,
 24 Nov 2026 14:06:49 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=fail (sender IP
 is 82.65.107.217) smtp.mailfrom=wenske.fr; dkim=none (message not signed)
 header.d=none;dmarc=fail action=quarantine header.from=wenske.fr;
Received-SPF: Fail (protection.outlook.com: domain of wenske.fr does not
 designate 82.65.107.217 as permitted sender) receiver=protection.outlook.com;
 client-ip=82.65.107.217; helo=lgs.sw-servers.net;
Received: from lgs.sw-servers.net (82.65.107.217) by
 PA2PEPF00019230.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.3
 via Frontend Transport; Tue, 24 Nov 2026 14:06:49 +0000
Received: from zephy.int.sw-servers.net (zephy.int.sw-servers.net [10.1.2.3])
	by lgs.sw-servers.net (Postfix) with ESMTPS id 77BD232D;
	Tue, 24 Nov 2026 15:06:49 +0100 (CET)
Received: by zephy.int.sw-servers.net (Postfix, from userid 1000)
	id 59B8010B2C3; Tue, 24 Nov 2026 15:06:49 +0100 (CET)
From: Sebastien WENSKE <sebastien@wenske.fr>
To: Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org
Cc: swenske@veepee.com,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 James Le Cuirot <chewi@gentoo.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] efi/libstub: Allocate the INITRD table in ACPI reclaim memory
Date: Tue, 24 Nov 2026 15:06:41 +0100
Message-ID: <20261124140640.0f627d7e212c@wenske.fr>
In-Reply-To: <37c38d1e-03cc-44ae-b617-d45fbf80acc5@app.fastmail.com>
References: <20261012133712.618913-1-sebastien@wenske.fr>
 <37c38d1e-03cc-44ae-b617-d45fbf80acc5@app.fastmail.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA2PEPF00019230:EE_|PA3PPFADE62A42B:EE_
X-MS-Office365-Filtering-Correlation-Id: 88015a63-dce8-4efa-5ffa-08df4a342efa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|1800799024|376014|260925021911599003|260925022911599003|260925021311599003|10067099003|56012099006|5023799004|261026140227099003|4143699003|261021121427099003|261022105027099003|261022075727099003|261102123227099003|261028144727099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	W9E3ObsSffmNdXlc+LiaiZw/V5/83lFtRDcsFxx1h75+hCNISMAKzmL6tjNTwqzndVs+f9W1VbYQQCG9yP1SXtInt8QzH7UwSny5/6dKgnYYIm1MkYI9YvpypczJ9x9DdhxevOEKPSuR+Yus5QuvNH377ehQsjtYYtvL7LOA9gLC3n7my6CdTD/nJxX8Dny1qsYRLpq00oPrc/x1lJVXlQRBeJkJxmS97j5uV7cyhQG2DbG3YyXDOUVjNmj9oIEiUXveA2hNvBsBJjZicSvYE3s0NieP/A4p7HlmWRjMqYwcpFMCq3xjb1vv5sz8dM8BOKjWI4vhAPpX3k4oJgvQEqn00pIHfcOPRF9ltlvLtFSQgiBvwseNorQ/W/Lnu8a0Og03WyNV0rOXQmKZh3IUItueQuSkmupnLVfPgwifhGbxi9XykWoetcEhTE6Nmhg9V7xAk8Cbm7Vz5EwvhNdciMK0xzsrRuojYVJP14x9SuNoNa5QV4kBVrghOOIwacq4EoE5kRINg88o7xdV3CIqMB4yQJYbCq/9XjnlRUMjrZWbFQDCwXQcorBNQiQmmq+YNiFI1PK3Whz7mj5ojpPvQ3LmQdbn/8B7vhlBr+DBSq8OT5SUpwiSdQlAD07t0u4n3yZAiWzK/CMByz7a97C6Dg==
X-Forefront-Antispam-Report:
	CIP:82.65.107.217;CTRY:FR;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lgs.sw-servers.net;PTR:lgs.sw-servers.net;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(1800799024)(376014)(260925021911599003)(260925022911599003)(260925021311599003)(10067099003)(56012099006)(5023799004)(261026140227099003)(4143699003)(261021121427099003)(261022105027099003)(261022075727099003)(261102123227099003)(261028144727099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tMOpfCS3V/QqIv53Y732yLMiNzNLAi32jHyMvTLNmfyUAPqgQn7EsKFN8TSJxLM5Ix0ajbsc3WmA5OA5ZOBKL/tnjcs90G3sVG4l6UWJOUNIdYeE144O1oXqbHPVh5u6vMF0035/Jk9a9uth6pGq2sd7kaG2BFJYeyZxy3YJaYemKVCSzFOitLttzhOsTav+C7mca7Hw1/vNEtqc2GjAAqySECguJOfJUPxF3kw5BnbEZ2XMLfwunEemCBsE3tPoDtOTEQG2iy3IgsfTVXwJT7kSnSfBEOXaU3pTcbQJBlwKH1ZfLHasTwWTvz6/1I9zNHRis4nN3cC2bEp5mVadKesBeixFvlNrvjbxEn0EJZCCm7REU/yDGmAigK203+eV7tFz8OKeJRIiI6wdaiVcHzIGnyZpzx7xHQnDohlbG9mACPp2eLTRZYX3lzqVYtuR
X-OriginatorOrg: wenske.fr
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 14:06:49.6331
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 88015a63-dce8-4efa-5ffa-08df4a342efa
X-MS-Exchange-CrossTenant-Id: ff4ca3b8-6c54-4519-8b0b-9389fb15cdbb
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=ff4ca3b8-6c54-4519-8b0b-9389fb15cdbb;Ip=[82.65.107.217];Helo=[lgs.sw-servers.net]
X-MS-Exchange-CrossTenant-AuthSource: PA2PEPF00019230.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA3PPFADE62A42B

On Tue, 24 Nov 2026, at 12:38, Ard Biesheuvel wrote:
> There was a report recently about EFI_ACPI_RECLAIM_MEMORY being
> problematic in combination with hibernate, as those regions tends
> to move around.
>
> Can you try this fix instead please?
>
> https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git/commit/?h=urgent&id=6863183e8b65e833f8140e20d526282a725e040e

Hello Ard,

It works, thanks - please consider my patch withdrawn.

Tested on x86_64 under QEMU/KVM (q35, SMM) with Debian's OVMF
2025.02, both the plain and the Secure Boot capable builds (no keys
enrolled), the kernel booted as a systemd-stub UKI (initrd through the
LINUX_EFI_INITRD_MEDIA_GUID device path), then kexec'd twice in a row
with kexec_file_load() and an initrd:

- v7.2.10, the setup of my report: without any patch the kexec'd
  kernel oopses in tcp_parse_options+0xe7 again, 16 bytes of its text
  zeroed at the stale table's address (0x1d4bcf98). With your patch
  both kexec'd kernels log

    efi: ... (MEMATTR=0x1d4b9018 unusable) (INITRD=0x1d4bcf98 unusable)

  and run normally.

- v7.3.6, with a debug print before the wipe: without a fix the
  kexec'd kernels read what looks like their own text at the table's
  address (e.g. base 0x74fb894800000002 size 0x7400000208b73b26) and
  clear it, without any visible failure this time. With your patch the
  table is disregarded and the wipe never runs - also with the flash
  locked to SMM (-global driver=cfi.pflash01,property=secure,value=on).

- v6.18.65: applies, both kexecs fine.

Tested-by: Sebastien WENSKE <sebastien@wenske.fr>

Thanks,
Sebastien
