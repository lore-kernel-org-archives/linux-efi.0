Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010063.outbound.protection.outlook.com [52.101.46.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A165E3EFD21;
	Fri,  2 Oct 2026 23:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790983927; cv=fail; b=sFArxBh7TVVy7M/SIXejcVmuliACljkUkiLXG40NhcYN+fQvpKz91mY8ZNGcZeok/eo0YtZwiuT7uEYLZmYXTZfTFlCUjAfLZq/4xeSh4hG9hGEw6+eOj1K5V7om4+dPEWHrjcVVTOXDDpsJjEcLy3TfMl5ve1tF2H/ZsrY01Tw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790983927; c=relaxed/simple;
	bh=1YWndwZd6UAn7EDOhAFd4lKNaSXRGkBzfdPLFNtdj14=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=RpqCZpXDFIdBwglHNNNRBT7ZYAgpUiU54vogUy2a3eBh83qrlBgNpkXf9GL0jB8fe7XOhZl/tBXZwDSA3F2U66zBcKi8tJM1zhKyzT0NJqRs1kZkAXPa5E1KcBOCe1u4YpKmmGeWlrzMTEmvfyD2XuohTZRFafcgx59Mx+9jKdw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dfsGXYZQ; arc=fail smtp.client-ip=52.101.46.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dfsGXYZQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f/X2mm6AQhRIkZCbPhUylGGqJF1G5ybApFJP9mHcG9O3h5z0t3zbtvsjL5C20330xwjGlwI4F4RFdhVTIxrXePmNDfZJLYx03pq/f02/p8VMo1nt+60RHe0/O1QPRYUC58bJ63Qv/VUGcRLwlaRYiKc62d2FzOf6jkUcotYjA50CfaEkaqilq5wco2RxW8uA+BAFs7kTZV7zIp/uwZou5Zz+X8RuV4JK5+B0o1xgyd/fxwgSCLi2bxA3jwjBXgvLBSoW7fTdxfXB0V42bZG0WEy7w0cN+joMCo7V7uTkFAF13tHAt2238xDCO5WjzRDmxhYblhJZu1rB3R8EXlcDbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fu/im1odMmWYXV/4MZtiJ4hvTeTQsvxsP/Ea6yDKND4=;
 b=g65l/71UDv54dvbP30rq30beOkwUj1ixGaf2ctdwqcW4Dm5/+UDux1lKIKDfi4dGyjopAH4W5bl2DHn94szQEAkq6hSc8E4OdIUxBCpu6WoouaRcu9cR2ALH3DNG9pz2cd+L/pM07/kUDzVuxAAzox8dprYXCRjBZkgVveKeV1CmZGA70SKEUyhDSP0zJE35docCS6DLd4m4h7m1ZbzhRpQY6cztSRnIYBHf9RazZYY6NA78a49MkjtJVnLuUSSSRsz4aE0SGvoOhYVjvHdzGo5kLz7GbZKXCUO2FNs3Uy/fERUDwHwGjM3mRCbp+1iX5MKp2iNusrCwEeRuEm6FjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fu/im1odMmWYXV/4MZtiJ4hvTeTQsvxsP/Ea6yDKND4=;
 b=dfsGXYZQAL72Sqf/Nq+bb7kOtpHN3lr5a2K+3jmXFtrF5eZeueneRMRChuaYozNChSIfrtc+ExQoAtUjA4gkKnuW5K6cTuQInxwxn56//i/LvlEaLNxlex/M1V4OEHHNn9Wpbhu2X8SghNyThyphh+VrwCLp+93hzmtDINyzgelf36jz0R0E2d4Zm8iILZOq0MXh4yaqBgNQdb2laHSuE650qEPlwzL2fSQDh0HqLErmlMrD1Dv6n+2tsdp3esBHqnbGPdhd/u6hPEu9rEi5Bg6Zji8NyThwBrfIxau/TruuzaCQdPm0TJ+f9dYprsCGeTMPjwy2jbBbllldrhzmWQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by PH7PR12MB5830.namprd12.prod.outlook.com
 (2603:10b6:510:1d5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Fri, 2 Oct
 2026 23:31:55 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0472.016; Fri, 2 Oct 2026
 23:31:55 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Simon Glass <sjg@chromium.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Nick Terrell <terrelln@fb.com>,
	Will Deacon <will@kernel.org>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	linux-integrity@vger.kernel.org,
	Palmer Dabbelt <palmer@rivosinc.com>,
	patches@lists.linux.dev,
	=?utf-8?q?Piotr_Kr=C3=B3l?= <piotr.krol@3mdeb.com>,
	Ross Philipson <ross.philipson@gmail.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Song Shuai <songshuaishuai@tinylab.org>
Subject: [PATCH v2 00/15] arm64: DRTM, boot portion
Date: Fri,  2 Oct 2026 20:31:37 -0300
Message-ID: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH8PR21CA0006.namprd21.prod.outlook.com
 (2603:10b6:510:2ce::18) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|PH7PR12MB5830:EE_
X-MS-Office365-Filtering-Correlation-Id: b16a4da3-997c-4ced-0d3c-08df20dd57fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|23010399003|376014|10067099003|11063799006|5023799004|6133799003|921020|3023799007|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	3hRbUCKpe1JGKP1EJuo+omTikBYenRHxKr3TKZcVXvhHPYR6ATpePDvtPXtwDuw1bk78oRziitAyyl98SeemoeNEls4qL/rpu+87boA0JBcicW9AK5GmLc7YKpLWlREPkESnc7wU5QPitdsL/l0ERoq7LH7kZG4HtiXhlbBXzv3g3SKFSQ29Bnz0gGLmzfzEmsqzN1RZaPsiHq+UlSSyVRIFHhxHH6NjMoMOFGkc4pVbLHSZuaeq555+6hK2eyL7tIowBe58gja9PXc9L3S79+2gDUVnno+2hM5IHBkss9JG26fVNLRPQWXAj3b42c5NqKT3O5WAstx75z+8WT+JKhvWh56UdSJgdWdbRUf7h4Ke3Fzzf9w9f9uB1ItX7DR0SY3/5pdn5RJv1THwvL1oPj92bGv/UhstdVZwu6Y7+AbHMgHcXJcXDSx5Gp0wfSR47Pj7Q+nvseG1gzpVwSsbdy6RGh1VVGyfmR5oFwJULWVl4rLDfhGpmhGjf0NMOhdIrQ1RRcBsjZJCSyrHsnbb0U3SILesnggvtkIyAcJDO3O73RzTC+PuSOGe5JfxTPtV6LRwhpjV+oezIbJ6kRlUf8Iv1JbYLiBFXa3GBYourm2ktQN1wOD7Qp5ZJoEduCYQJ7alr6SIPwA2ZCOeZE/7VoXAUi6HihQes7KQSVAZlq5IvipP7x2e0pSzuvB8HFuAGKiz+SXazokQMiYcoNB8wg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(23010399003)(376014)(10067099003)(11063799006)(5023799004)(6133799003)(921020)(3023799007)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L25iWEx1SEcvRTl6dnpRWGEzYnlkNERld3A1RGF0amZQTktTTlBiL2hxdUk4?=
 =?utf-8?B?ckdmMzJUZ1FMQnVXQjR0aFdYS3orYS9aeU5SZDVjSmU1T015eTYvVFA3WlEz?=
 =?utf-8?B?TUw2cUlyU1NaSjUzREx5RnBURVl0bjVjWlVyTjNmM0cxNWw2NEkxYWVZc3VV?=
 =?utf-8?B?ZzE2M0Q0aWxrNzBLbmxFZVBuWXRzYklEQjlWSlpvWG40Wjc2SkZndTBLV3VU?=
 =?utf-8?B?dFQvY3pxMGE3QXIwYmxnVnYrZjJIVWp1Ym44SWw5Y1dpWWFwZXJVOXUzY21w?=
 =?utf-8?B?alZIdElKY0lpV3k0dlMxSmN2MW1FU2hRU0EvU21GM0RxTDFLWGZGaFk3bUs4?=
 =?utf-8?B?aHRPYUpzK3Z6b2N5WGx5TW9ldHRrczREUzljSFB4OEVWU3prTG5XbEF1azNF?=
 =?utf-8?B?bitYRXZZcTYzelNlZGticEpzOWlESnRiSnFxZThBbkV3VXVFZngxSVVJNnVv?=
 =?utf-8?B?ckoxWC9kWW1QNEhuaVZYeldheGsyRHNldlRMMGk0bTR0Wjc5Z21ZTS9ySkNZ?=
 =?utf-8?B?MzArMjlNR3FpTmlLZmtudkFBdDFqR1BVMGFvaDRwdGtSTkM5cVhuc1ZlakNR?=
 =?utf-8?B?U0xPWHVQK05tK3kxMmtUV2pKUTVHWmhHT1lLcWJLaXh3dU1CZjByWWVKamQ4?=
 =?utf-8?B?UnVaKzR3UkZDK1Z3UmlZU1hVb1ZIRGcwMVM1ODVUYzU3Y0UxTGZ6dHRmaVpk?=
 =?utf-8?B?c0RuTm05eGU0Qm1qR09OTnBMZFQ2bzFNNFFrNmprcHpvdDBRbWtVUzQvcGJY?=
 =?utf-8?B?aW9FRjRJbUMwaXUrU082NG9KRjB2ZWFxb3NLYkdOQStyRGtscjkwaGtFSHdh?=
 =?utf-8?B?cmYwRlBscmZ5bzR2LzNZMVZvVlhYLzJ5c00zUk5Ha1lTa3NYSlpVSWpHTGt0?=
 =?utf-8?B?bXZFNlN6dUQ4UUtXTDBZNGNsQ1pXa0t3S1VaNTQxMkhTYmMxVkJSaFNYVklQ?=
 =?utf-8?B?dFBYaUhqc2lTRWpVaHhaRzc1bHFtVTRCQjIyNnRhK1lmUlpkakJURG5vNGdY?=
 =?utf-8?B?TWlQamV1YWEyK3E4MFI5TkduNjhIRWlDdUppb3ZGVE81TzNGL29FeXhaRk92?=
 =?utf-8?B?VFRiYXc0eGM0aWJzd1JMVTZoRWc2WFc2eGlHL0Q1b3NGMkgyMTFybTZlV3lC?=
 =?utf-8?B?NGdFdWVrUG9Sd0NMakh6T2N6VDFsQktVVStDQm5SNFhuclVXUG1leERKaEhP?=
 =?utf-8?B?LzJ5N3VtNUdHQkRjaE5KVXFRNno1aFRIRWVaVm5HUEp5ZHZsdTBOTm5ubVNF?=
 =?utf-8?B?anBMOVg3N3V1b3lHTWllY3crMTVnUVRLWXF1LzliYWJMWkViaGxDejBHc3lG?=
 =?utf-8?B?VGR2ZzRFMTNrZ2h5OEJhN1RrQWdBWng4MGxxM2tHcXJFaEVOOVhKN09aUFA3?=
 =?utf-8?B?MnJqcmg0MVM4VzExMUYxTDBmTi95ZHVWdzdqUXlrQ2R3bGY5VlNlU0VuRUh4?=
 =?utf-8?B?WW52VDRUMUZITVJyL1g3Ri8xQ3dtREs0UXNSRi9jelBTekFtdkpkSDBEdE41?=
 =?utf-8?B?YzBuaXNPaHN4a0ZqNENVRDhXYmt4U2dYSmJFdS9jNUxyVWk5ZUFZc2Z0YUE4?=
 =?utf-8?B?YVo1SVh0cHQrT1h6TUM3VjlDeGdtcm5xbElmMEdtcExranRSblZpbTVqdUpP?=
 =?utf-8?B?NHpZaGx3TDBvSnkzcFdjN0p5RHBpbk4ydjlWSkR2VVlRZzY4WTBOajhNRTg5?=
 =?utf-8?B?alg5Q0R5amNRVzZZZDg5dFhheEV1L0F2emxid2ovUWhZS1k0UlVOMXhwc0w3?=
 =?utf-8?B?VG80NEx2ZHk3WS9pMS9KaUdKQU5aUmwrNjBTQWp2SUNYd2R6eU9SQm90eU5P?=
 =?utf-8?B?blJmbUJyUHIrMVVFdjdlVmczYXNxK1BuM0xsUkxKbWVQeHNUOHNuWlhTVEdr?=
 =?utf-8?B?U0ZXOGNpcFVQZXQxaDJNQW92V1JtZ1dpeXh2UURvUmw4WXVldEZGcFQ4bW9I?=
 =?utf-8?B?WWpWSyt4aUpSMHlHM0x5SUpEL09rN3pkTzFuL1c5OGk1VGh3djlGSlFQMXY3?=
 =?utf-8?B?b3Fuano5ZHhadExGckt4Qjl1c1NnTzVBS29KWVZKZEswWnVCQmp3aFlqb1Fh?=
 =?utf-8?B?R1F3OWtpaDZXVWNrRzNNVjR5STlJb0xJSXdtZkUzeHNJemoveStSUER5dElG?=
 =?utf-8?B?UkZ3cE5uYnQ2bHhieEk5VGNkWWYyQXlGKzVFblZHWWVQbXEva25Ub0toTmxU?=
 =?utf-8?B?VXg3d1QyU002dlpiemRNTnRXT2NFSndJOTlReGNFd2laUlpoZ2FYanlEbHhF?=
 =?utf-8?B?Z1htdVZOWVgvaE11WnZGUjZvc0hvUGwva0dleDB3VU8wZlJSZDRUQU5QenZW?=
 =?utf-8?Q?KlaS8A2uhEXAlIzN3f?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b16a4da3-997c-4ced-0d3c-08df20dd57fd
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 23:31:54.7968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q/IlM+jGBVGDLgqat6Hmh8i+pSodhNjPc2DAg8FKXSQ0p6FfLgAQlmoagr78iRxo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5830

This is the first series for an implementation of ARM's DEN 0113
v1.4b Dynamic Root of Trust for Measurement (DRTM) launch protocol.
It is built on some generic changes to the EFI stubs that provide for
a simple, direct DRTM launch directly into vmlinux.

DRTM is a boot security technique that jumps into some platform trusted
environment prior to launching the OS. The trusted environment will
sanitize the CPU, block DMA, measure (SHA hash) the OS to a TPM, and then
jump into the OS. The security goal is to prevent tampering across the
launch: if the measurement says X, it should be impossible to tamper with
the boot such that the CPU is actually running Y. DRTM is a reaction to
the historically bad boot security in the UEFI world. It aims to make bugs
in UEFI/etc unimportant for OS security.

When I spoke to Catalin about this, he was interested in making the flow
cross arch. After looking at what AMD and Intel do, and how different the
kernel EFI flow is on x86, I have opted to do that from the perspective of
building some generic DRTM infrastructure for the arches using EFI_ZBOOT
and FDT. I've sketched out applying the same general ideas to x86 and it
works there too, but x86 is so different that not much is directly
re-used. I would argue the security/hardening work listed below is a more
important place to get commonality.

Several people have asked me about Trenchboot, which is the x86
out-of-tree DRTM implementation. In my view, ARM and Trenchboot have
converged on the same basic design. Both offer high-level functions to the
OS that don't leak out any platform-specific details. Trenchboot offers
these through an EFI mechanism from Grub, while ARM offers it through a
standardized FW based SMC API. Effectively Trenchboot is a reaction to x86
having primitives that are far too low level and far too complicated to
implement inside the EFI stub.

ARM does not suffer the same issues as x86. The EFI stub implementation
for ARM DRTM is only 400 lines in patch 16. This is because the standard
already offers a sufficient abstraction to the OS. There is no technical
reason to bounce back to Grub to hide complexity that doesn't even exist.

Further, due to how ARM has abstracted DRTM, we cannot hide the ARM
details from the post-launch Linux. The kernel must understand it is
inside an ARM-specific DLME, it must do the ARM specific ations, and it
must process the ARM-specific post-launch data structures that the FW
writes. All of the work in this series, and its followups would still be
needed if Grub was involved. There is also a sneaky ABI here, the choices
the stub makes during launch have to be matched by the vmlinux
accomodating them. Keeping this all in one source tree and one link with
no ABI is the right answer.

My hope is that this series will encourage other platforms, like RISCV, to
follow ARM's approach and not x86's. Further, I strongly suggest that the
x86 world standardize some EFI calls so the UEFI itself can provide the
platform specific DRTM implementation instead of involving Grub.

Broadly, ARM's abstraction does several key things for Linux:
 1) No TPM is required until after some ACPI is parsed. ARM has many
    different kinds of TPMs, so TPM without ACPI is hard.

 2) The launch uses a contiguous chunk of memory that can be
    perfectly overlaid on vmlinux, with space for the headers,
    measured section, unmeasured data, bss and trusted post-launch
    information. It is trivial to insert Linux into this scheme.

 3) The launch protocol is trivial. The launch directly measures a
    portion of vmlinux. About 50% of the stub code is just inspecting
    features and doing FW call compatibility work, not tricky DRTM
    things. Zero platform-specific code.

 4) The post-launch world isn't special. We don't need unique kernel
    patches to undo things that DRTM did. The normal drivers work in
    the normal way just fine.

This series is enough to perform the launch and get a working kernel
inside a Dynamic Launch Measured Environment (DLME). There are several
following security-focused topics/series that aim to further prevent
attackers in the unmeasured world from compromising the measured
kernel. Much of this list comes from internal security research at NVIDIA
on securing Linux post-DRTM.

 - The kernel command line needs to be measured, without any "early tpm"
   for Linux.

 - ARM's DRTM protocol for verifying the address map needs to be implemented

 - ARM's protocol for checking the "TCB" ACPI needs to be implemented

 - Non-TCB ACPI needs to be deferred until the TPM is discovered and
   then the tables are measured into the TPM

 - Initrd/Initramfs measurement by Linux before using it

 - Exposing the DRTM launches TCG audit log to userspace

 - TPM locality handling

 - Non-EFI boot, particularly kexec

 - FDT security

 - KASLR RNG security

These topics all largely require different maintainers and different
cross-arch solutions. Post-launch kernel defense against an adversarial
boot is a complicated topic with several different threat models people
are interested in. It has alot of overlap with the Confidential Computing
need to deal with an adversarial host.

This series is arranged to try to build re-usable things that any
arch can use to implement DRTM:
 - A technique to communicate the link layout to the zboot stub based
   on ARM's code_size trick
 - New general linker sections/etc to move mutable data out of the
   measured range
 - Cross-arch symbols __drtm_measured_start/end that allow a user
   tool to compute the measurement hash from the vmlinux itself.
   Because of the mutable values this isn't just all of vmlinux.
 - CONFIG_EFI_DRTM and general EFI stub arch hooks to plug into for
   EFI ZBOOT and FDT arches
 - Shared drtm= kernel command-line processing

For x86, it does set some user-visible expectations like how to compute a
hash for vmlinux and the drtm= parameter. IMHO, these are key areas to get
cross-arch alignment on so the user tooling, like a systemd UKI, can use
DRTM easily.

I have a slop'd up qemu that implements the SMC protocol which is very
useful for testing:
  https://github.com/jgunthorpe/qemu/commits/arm64_drtm

NVIDIA has several real HW platforms this works with, I've been able to
see that one of them works now, and someone else tested it on a different
simulator. I'll get more HW testing as the review progresses.

This is on github: https://github.com/jgunthorpe/linux/commits/arm64_drtm

I've fed it to a local Sashiko and am satisfied the remaining remarks are
not applicable, and fixed several of the previously existing bugs it
found.

v2:
 - Swap ftd_size_allocated to be inited by efi_load_dtb
 - Move the __free
 - Use a 64 bit for efi_image_info_offset because 0-day found a randconfig
   that triggered the linker assertions for 32 bit. Clarify some of the
   var names around this flow so they are less similar
 - Fixup some issue with linker script compatability on binutils, I was
   using lld
 - Drop the le64, everything is u64
 - Adjust whitespace
 - Fix efibss placement in zboot.lds, binutils pointed out it is made
   allocated and should not be in bss
 - Significantly revise the header file with the DEN0113 definitions
 - Support v1.0 implementations and issue a revision 1 TPM parameters
   unless revision 2 is really required
 - Review the upstream sashiko notes and reject all of them talking about
   not having enough hardening, the patch plan for security progression
   is explained in the cover leter
v1: https://patch.msgid.link/r/0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com

Cc: Piotr Król <piotr.krol@3mdeb.com>
Cc: Ross Philipson <ross.philipson@gmail.com>
Cc: linux-integrity@vger.kernel.org
Cc: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (15):
  efi/libstub: Fix error unwind freeing fdt in
    allocate_new_fdt_and_exit_boot()
  efi/riscv: libstub: Don't set image_size in handle_kernel_image()
  efi/libstub: Free cmdline_ptr in efi_pe_entry
  efi/libstub: Add a general way to get symbols from the vmlinux into
    zboot
  arm64/efi: Use CONFIG_EFI_STUB_IMAGE_INFO for code_size
  efi/zboot: Lift efi_cache_sync_image() from efi_zboot_decompress()
  efi/libstub: Add generic arch callbacks for DRTM
  efi/libstub: Have efi_kaslr_relocate_kernel() handle extra_size
  efi: Add a __efi_data_handoff section annotation
  efi/libstub: Put the stub's writable data in unique sections for DRTM
  arm64: drtm: Add macro definitions for DEN0113
  arm64: drtm: Update the linker script for EFI_STUB_DRTM
  arm64: drtm: Add drtm_entry point to head.S
  arm64: drtm: Call UNPROTECT_MEMORY
  efi/arm64: Implement ARM64 DRTM in the stub

 .../admin-guide/kernel-parameters.txt         |  12 +
 arch/arm64/Kconfig                            |  17 +
 arch/arm64/boot/Makefile                      |   3 -
 arch/arm64/include/asm/drtm.h                 | 324 +++++++++++++
 arch/arm64/include/asm/image.h                |  21 +
 arch/arm64/kernel/Makefile                    |   1 +
 arch/arm64/kernel/drtm.c                      |  49 ++
 arch/arm64/kernel/head.S                      |  83 ++++
 arch/arm64/kernel/image-vars.h                |   8 +-
 arch/arm64/kernel/vmlinux.lds.S               |  76 +++-
 drivers/firmware/efi/Kconfig                  |  33 ++
 drivers/firmware/efi/efi-init.c               |   2 +-
 drivers/firmware/efi/libstub/Makefile         |  11 +
 drivers/firmware/efi/libstub/Makefile.zboot   |  11 +-
 drivers/firmware/efi/libstub/arm64-drtm.c     | 426 ++++++++++++++++++
 drivers/firmware/efi/libstub/arm64-stub.c     |   6 +-
 drivers/firmware/efi/libstub/arm64.c          |   4 +-
 drivers/firmware/efi/libstub/efi-stub-entry.c |   6 +-
 .../firmware/efi/libstub/efi-stub-helper.c    |  34 ++
 drivers/firmware/efi/libstub/efistub.h        |  65 +++
 drivers/firmware/efi/libstub/fdt.c            |  14 +-
 drivers/firmware/efi/libstub/kaslr.c          |  72 ++-
 drivers/firmware/efi/libstub/riscv-stub.c     |   6 +-
 .../efi/libstub/zboot-decompress-gzip.c       |   2 -
 .../efi/libstub/zboot-decompress-zstd.c       |   2 -
 drivers/firmware/efi/libstub/zboot.c          |  25 +-
 drivers/firmware/efi/libstub/zboot.lds        |  10 +-
 include/asm-generic/vmlinux.lds.h             |  38 ++
 include/linux/efi.h                           |  12 +
 29 files changed, 1323 insertions(+), 50 deletions(-)
 create mode 100644 arch/arm64/include/asm/drtm.h
 create mode 100644 arch/arm64/kernel/drtm.c
 create mode 100644 drivers/firmware/efi/libstub/arm64-drtm.c


base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
2.43.0

