Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012019.outbound.protection.outlook.com [52.101.53.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B585372686;
	Thu, 24 Sep 2026 13:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790258024; cv=fail; b=MNdW7fjwESP/c2Fhg0O3G8BRQNuB0/Kda34A/VJeLoyvCHCb6pdwlROz/Mez8FnjrQmrLa/MC/Leb/BgT+ZAgMnnSLSiyS9lXUyqVIPYbDdQD/rk3uqK25wHtUgfpHX5FYELFLCahMnzHMnhK+6f5o/x3vUT7cKau4H4hg7NV8s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790258024; c=relaxed/simple;
	bh=X7Fi+8V/dvzaufUp0phVK9GCvF8FPG0+rKw/CqDFUPI=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=u7PUq2fssadYAVMM+Gx5QlSnmtdayGW7QSCMx1jcy/LKME2KOKvSk7j4+MD5xjwjZrV1DT6y8Z+cwxTjIbDabsLwf+FMKnaOEm+bG2Xh1BVB2QLiwaP9GqhtXHPKuIPaorQgeiAL7P08e69zPL22SQ9nqWPcULNwGycvD8yYAFg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JqUSUCbM; arc=fail smtp.client-ip=52.101.53.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JqUSUCbM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UliXYvkyzXh1p8GZvh31MUPz2rg84H+HaSjFbO6k0Jynk/VPaFW2MW7vIwUGjZes2dUNmMLHrTfbWJHi5LnlJNXHX/wOPBLGIZqAQyp8/bzo0Z6ajRif24o/wLK6O7WCGoV52d46DF+AkU6+Rd7PF54h1rrDoE7L//jbvKfLKDB8N70FXW57bW7c/YajzE0MX+TnL/A8xvivyGcsw+Cd64BQ3ysv6v3ExFViStCjBKowoBDACdazgSJ2cWmxbIgaoJKKfztcuNaAdTIIRp5WefHtauCODI24Y0nW4PiQDBRFyiWZU3YXj23qgP+o3nF102m0p0O3YiReV3W2UurVyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wzws0qGLenQnEJFbHNahrE9N0Ea3UaiOXFfzL1TNy9c=;
 b=cIFEejMxfibZNt8MADhXXywpVfNoBqV8L3uadZIlBosh71lW6SGWSjUYLVt7I1pJ2L9GyPap1Yj3TAVJdvQAkYCwXNVo512owwxb5eMw94Go6xOMm83ZsYEmK2DWet+AJSswbAtWLegXGi/bZ7TXUu01Jdgnhqy7TXNLpp2kX2wMzssBuFrlPya4gSShqoq4Yh6f8tW8/1i6JvuK49O4qxdH7fOUV1pfXX6dpHytVaBlE5GAKqswm3S5xCxFPo1raZ8SORUTWXPYeGW4QesBy6qHZ7xxJB/L9qHJs36Vs/64L9yD/KQmEPC+nOEeum0Nox+yEiPTLItL6yid4xwTyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wzws0qGLenQnEJFbHNahrE9N0Ea3UaiOXFfzL1TNy9c=;
 b=JqUSUCbMOLA0Yh3tc4Vc4U67hdmJPE6ypBR0LCIwwfsqeglp4PuDcY9cXWX8ZUrTaYuTWY+IO+AUOV/InghnWd+wZc6dCFHgIXUseYDxrJmrOcCALL5ppP3OxdZDwIlAdxncYYQ1VsUuVtd2iRvLpmRlGi2a2mjhJFf4lg9ud+XqCJuSYvaoGg6q0NhHcn3llXqPmDx/rnqNgJMzhcoabWRzVHZ/JQlDZn7iOe4+j4NNvsGdtHrcF2Jzv7UHcElggU/dtmzqsNkfuWmopnGp/7z1ouzgwY1lFk5RFqYJYrEX9dY3u+7NFnei6N0oSAK/8zs0sFoN+ZfZsZtyZyWRRQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH7PR12MB7186.namprd12.prod.outlook.com
 (2603:10b6:510:202::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 13:53:36 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 13:53:36 +0000
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
	linux-integrity@vger.kernel.org,
	Palmer Dabbelt <palmer@rivosinc.com>,
	patches@lists.linux.dev,
	Ross Philipson <ross.philipson@gmail.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Song Shuai <songshuaishuai@tinylab.org>
Subject: [PATCH 00/16] arm64: DRTM, boot portion
Date: Thu, 24 Sep 2026 10:53:03 -0300
Message-ID: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:510:174::12) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH7PR12MB7186:EE_
X-MS-Office365-Filtering-Correlation-Id: 617ce688-0ce1-4d79-4de4-08df1a43338e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|921020|10067099003|56012099006|11063799006|5023799004|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	qFImkeFBlh3cg2R++0iXSPsmP4gaCIHms70Dklp9oSrDm1E7nGFUUD6YP7K55ayUUM4PrEsCHTMinOpwhD7WxaO/8wc2bI4wP9+2FccBQCSJkZ/61eoYczQbwEzx4mnpTId2T/+bI0vaMSPR0/3xtWG1hfaZx9RX4XqkNwC/RPJxgZIjrOYWRxKTmDz4MdpjVRpnptZHlnjhUX+BqkGKW28tALd1knQm0E74eBcAG4OxWHMF7sIl3++jlldqM61wso4JsXUHofTY0f7a7Dg/Bv9fZT4U0Hk7raQJAUjmFJVg8xe5ohc4hxb8Gh/6IW+kVbclGLPTJpQtpbFaeG5B6g/j4VlwGWyE4YI6kQ6vPlHM5KZecCCu8Hr/o8mMS71acoyC52Kd4VFZ45ZsW4bTPPz1G2tPtB11wfjdtEDEZhxWVN+RhL2Es4GdKl+OhmgwytAoyaISej4nBzgdnZ+rFYNt8Pj3NzmsIMBIvSJcEI1MMSAy3N+EjWnEOhvXR5v/h46oa78AS2jcAIW/Rg5F/NIBaCd/hJwTis4YcMx5RdncSevCZOISucc8KoyP/aSBE7ijcclJT0Fdl6l0lYUl59NyfHqYb2/dS9qGBN9TcYSLLHLY7GKy8tjkFKsjApm9jCE+sdWe1w++zHURqrNyMKFb+jy5GKDUkIma2XP70dPmbgRJJ9kcWX88J10zyhU9k0Cx2UjcTxDE7CvV5ZgmLw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(921020)(10067099003)(56012099006)(11063799006)(5023799004)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?t8DKFTLbrv43RGWLpcBYhbzKVd7JDZiKxPIkCuQ+4vbfdvTkms7r+bMV8DXT?=
 =?us-ascii?Q?RODd4Vf12Kc1HJiJh3qX0Yz3uymP+fZOLpzSQjn171zzv2QS4CnU5tfy/gnk?=
 =?us-ascii?Q?gWmzddDhl55CTGdcZ/lLsQa7g6mqNme8ggCNmPqMBQRXjydnQP83ygIwwhg+?=
 =?us-ascii?Q?HkQaKbh/inuOr4cpk6EkR3QtSAZEauVNJjhnNkCOs0BLNcxEFtnVECgpDZZP?=
 =?us-ascii?Q?1WBEM4plvEsq978Dhc/i+DXThUFp920h+lCHHeMuXT6fQl5EUU2iOJEWqkYP?=
 =?us-ascii?Q?XXJbcxOVSJsB2FplDISOaGqZtj25iJgxV3uk7m7MmB42IbL0wVjIjQA4ymP2?=
 =?us-ascii?Q?yZrhLJKm5Qz9JwayMJiF9ZOWRBeoJJgi6cNiCJQUBE46UuA9/SDc/el0ama0?=
 =?us-ascii?Q?N0hougdQhqY4oVSaOUhyJF7mgnI99GQEPcXtqRTHI31ArQEGxzzHilDHipoY?=
 =?us-ascii?Q?KElB7+azHz18TtbFw1iGU1++hMp6ja+QqbitECqK4jH+jB4K/LKx/H0TiEJe?=
 =?us-ascii?Q?kR8LCWDNy7ujpLgdpBMFqM15S3MMR5rQ3Dn/pwtA+ivK/Qw0qtTxFfOP5OCW?=
 =?us-ascii?Q?UahOn2wCspJxrOvQhrMySh6Hxg9y2yK5Do4i4RiI/NTz2EsR83BkqcDQbWgz?=
 =?us-ascii?Q?8Az5MkTHfLLW9P8XWEn44Vr8pvAU6oHzqXyNNjRvmFdiZ0uQCNtutH5TE1sN?=
 =?us-ascii?Q?ghugfaF9O/iRTUiCkLAjyrBQuma1vtvulO+4Vh+mdvKRQOU7LKRFnFM8BgMt?=
 =?us-ascii?Q?yZmIWYCacGo/5/5rTtHA//Z5mjaP93A1PDQtBM9Z2cyfbu1UwdixHhjAAbmi?=
 =?us-ascii?Q?2DCbMAih93OYVclEJhHNNWxdJvI8F2T65k8lqdj51PzGsOOsRW4/TGNFPC6/?=
 =?us-ascii?Q?C/m1G5n3A9qHpn05QxGf20HGsEq4BcR8ZJsUaSQUgRrJcNorai7nZMj/+3og?=
 =?us-ascii?Q?V5w74zSCGnsAiYAmp71VwUGojrnBQPfxrdpOYBDyD/JFAiAM6h3/t8eh/tdF?=
 =?us-ascii?Q?z3k4P9dJbmeyDxNUjWQq2swoNf2OD3DPPU3/A7FMt32IaymRy3gHTBd07D66?=
 =?us-ascii?Q?qv3ufbDu9NSgVE4/wsltcwRyF/Xjy2pxPBWyV+Y+l4BvGlbB2YpDtw7mmIp4?=
 =?us-ascii?Q?IfSPkBcuGTe2VXgtNnlhQuZO+337jJtYAwQFe/mHRJLvtIURJe5Zm2x1vUEW?=
 =?us-ascii?Q?dM20EhbPGtiL5HmLF1P4HOcIss3+yCsVle407dFXveMgPr/MUpQgXc+Ebj0E?=
 =?us-ascii?Q?cLIK4a6RTplk19/a2lYzcKwsitk2QOhR2ICYtZs5qPXq2vYmPivOZzWmI0N+?=
 =?us-ascii?Q?XUuHbWosthwsmgpGylKWYypHKOqwqh4IpfmfhySWB98klXvSBRaD3v6Owk5e?=
 =?us-ascii?Q?jBncwrUxpme7lOd14/tWFdRJRCWjy8py122rKh/Z2IKZTTouND2HoGbQACwQ?=
 =?us-ascii?Q?Y7k93krteo3/6P6sptfWzjtf+GfPlYBe2sm4LTCZfIGs3fKdSGyBDBhaSjrx?=
 =?us-ascii?Q?lsjHOVHsX3ZmTQiJl3yoz6zz/To+BwRUNiRNG+E+rgwFYjhmaQPDi31Wo4cp?=
 =?us-ascii?Q?jXuv4K/0jGmTpjnFibk/turKn/cCaT9mbi2kl9Mhg/BzSPDNeYsDtkiPtjGl?=
 =?us-ascii?Q?QXE412RABF7T2FOC9wq/e+PmxgKArdUgxu5yqsGq0u1ohaBt4Z/VkKIS27l2?=
 =?us-ascii?Q?3Jw9RGE2/iUudUfxGRjXrqUUSh6O7pyqBPIdKroEMPCdpaKi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 617ce688-0ce1-4d79-4de4-08df1a43338e
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 13:53:24.2323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3psN4vP7FoomnhTBGukjFKzT9utxm20Hj3E1RkeMMEJZMDUOY6+J/++Sqe3ZSKGf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7186

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

NVIDIA has several real HW platforms this works with, I'll get more HW
testing as the review progresses.

This is on github: https://github.com/jgunthorpe/linux/commits/arm64_drtm

I've fed it to a local Sashiko and am satisfied the remaining remarks are
not applicable, and fixed several of the previously existing bugs it
found.

Jason Gunthorpe (16):
  efi/libstub: Fix error unwind freeing fdt in
    allocate_new_fdt_and_exit_boot()
  efi/riscv: libstub: Don't set image_size in handle_kernel_image()
  efi/libstub: Free cmdline_ptr in efi_pe_entry
  vmlinux.lds: Move DATA_LE32() from arm64 to the common linker script
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
 arch/arm64/include/asm/drtm.h                 | 215 +++++++++
 arch/arm64/include/asm/image.h                |  21 +
 arch/arm64/kernel/Makefile                    |   1 +
 arch/arm64/kernel/drtm.c                      |  49 +++
 arch/arm64/kernel/head.S                      |  83 ++++
 arch/arm64/kernel/image-vars.h                |   8 +-
 arch/arm64/kernel/image.h                     |  14 -
 arch/arm64/kernel/vmlinux.lds.S               |  76 +++-
 drivers/firmware/efi/Kconfig                  |  33 ++
 drivers/firmware/efi/efi-init.c               |   2 +-
 drivers/firmware/efi/libstub/Makefile         |  11 +
 drivers/firmware/efi/libstub/Makefile.zboot   |  11 +-
 drivers/firmware/efi/libstub/arm64-drtm.c     | 414 ++++++++++++++++++
 drivers/firmware/efi/libstub/arm64-stub.c     |   6 +-
 drivers/firmware/efi/libstub/arm64.c          |   4 +-
 drivers/firmware/efi/libstub/efi-stub-entry.c |   6 +-
 .../firmware/efi/libstub/efi-stub-helper.c    |  34 ++
 drivers/firmware/efi/libstub/efistub.h        |  65 +++
 drivers/firmware/efi/libstub/fdt.c            |  12 +-
 drivers/firmware/efi/libstub/kaslr.c          |  72 ++-
 drivers/firmware/efi/libstub/riscv-stub.c     |   6 +-
 .../efi/libstub/zboot-decompress-gzip.c       |   2 -
 .../efi/libstub/zboot-decompress-zstd.c       |   2 -
 drivers/firmware/efi/libstub/zboot.c          |  26 +-
 drivers/firmware/efi/libstub/zboot.lds        |  10 +-
 include/asm-generic/vmlinux.lds.h             |  57 +++
 include/linux/efi.h                           |  12 +
 30 files changed, 1221 insertions(+), 63 deletions(-)
 create mode 100644 arch/arm64/include/asm/drtm.h
 create mode 100644 arch/arm64/kernel/drtm.c
 create mode 100644 drivers/firmware/efi/libstub/arm64-drtm.c


base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
2.43.0

