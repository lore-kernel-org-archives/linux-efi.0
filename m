Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C73388899
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778661827; cv=none; b=iEOo9rY/zT/w5T9QLiUTw6wdgnAPReFVphcJS4SbmbhQNois02ZFwZvMhj0z/dvQXshBhgFxQNKnFbw/5/rJptHakGaZWMhclpmaU2oJhp+0hfsUq0tOUw/+cHKyl+yhyRxXKE4gq7MvWEgbtQ8xoG485TTuXF9mogbLnFeJFtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778661827; c=relaxed/simple;
	bh=zsnExNJxHb5CwPG/1WZiVXnXOtJfrgVhK0JTNumtgK0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CqGXPopTwOFALdcaKqgMNCpljtdDCmdfBNG+cZjuY99njQJ8fRJ+o0T1u5xW02jBT29cJtobqmCEsXKLbjDjp/sNTsCSqjXCDd1FVcYrhmVo9/J2KMDeuVUmUjLtvGV1VNwTxR/5HeqPIgPDMJwJyg5UnccjHgycTuRSxVKZrsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hwR7gbVU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OjMXX5Tu; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hwR7gbVU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OjMXX5Tu"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64D4pTfL2933374
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:43:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=3aWzzWqgV1S+DaS5mlIRnU
	gf5ktWPNv26+QnmRkT+ME=; b=hwR7gbVUoxjURX6qLYAEAxMb+yk0dRG5EZ51x/
	dcXzldklHMzJYhJvk3EqH3s3UdMsgBWSt8bQ9ZADjslw4ciyf9IToJhxJCNvySQi
	isOf3KapTjbRuUG2qXNi92TTYlZfiCKt8HbhpAYZldXTCt1V/P5Rc30lM3tlC066
	NPTZviIYlHcFof+2pKdHhaQ+7RxyGjgotNU5iScDn3Io6YLzFu/OSeZnKzUTV0MN
	e+gIvbaxU+7XeDYSAvdT1xKhTpu4Te2mtjam8/70wbwXtlAiKt+/UP3MaixxEv+j
	GwGWOkUKak7iiRwD8LhOPgUfIRnRsLEzdsAvtKVh+INJSa8g==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e4319vjdb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:43:42 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3662668b825so11281693a91.3
        for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 01:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778661821; x=1779266621; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3aWzzWqgV1S+DaS5mlIRnUgf5ktWPNv26+QnmRkT+ME=;
        b=OjMXX5Tuuq2Bdo+ir+qtziqbQFNH0+kG1SlzealebGIk6CtKNC8pHQzmqDLl3Mi3zN
         nuPJuGPyP6xXUJKWttZd6l83LxdHB1pdp2Woe0zhmxc0tQoOp6Z09qhKCvUaMyukk7KT
         TKiP4yZjkzwADUSkzlBC4D8b+T/SZgGAJiSopqk4aAjuLIaP6/CTH43mB0WaAYPYn18H
         ioZLAXXRVkI/8sGbow1P4WbUsSES544OJq+vecNpCpuhjx6DWmdILdUCOzMf3Ldpp+nu
         yA3NzvlNasfK/pSeqlIz1JTckdL3fDR3ruF9jlJtcXVCnABmxfSdc0b2Xc+8wrkcRKHA
         CkWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778661821; x=1779266621;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3aWzzWqgV1S+DaS5mlIRnUgf5ktWPNv26+QnmRkT+ME=;
        b=pYfOndWdx1mVzCj8AJEPC3Th6jcaUl4ZcR7NlSCijskUe1Q6Kr+EetTdE3xQRpg83W
         9cIbUYNLrRNATj8eN6eReseVqcGXSTgME4R9VTlI+zK/b+vMJCYxRxdfbyS+9/aso+A8
         qunspIvBfeuHk3OeNpo6BfLuF17SuZ1GqlGSCDrYVjcShLN/VHaTeOpPsdOUJD3Hg+it
         nwnwpC7REidk2d8Ir4KpWIon+DAD8QW51zi8BniFrDh6Yx3UN+J/BwIjoPUAyhgY4KFK
         64tA7LYTtO99vrPoMr3o7TvT867k08mwYFKxCPJKBM+06wm9YAblSD3c9+k56BFCT95n
         oE/w==
X-Forwarded-Encrypted: i=1; AFNElJ8fRdCFXPO04T7SjHHjEZrJJLs3hHVTOkAPDt7Yi1r2quVEYXTrL8JHrLV6SiGbevyXcZLwFVpzKyE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyq9NYhcUBnRxBNMVwCURO+p3UcIQFPYvpNLs9DbY+9SYekN16/
	dDFXTViOJyuaweXHn28oHjuP5xF1MTgog/iA5MHIUCWzE0XkCe0XoXNTs4bTtARcsOgvFp93DDc
	/kPyPkZK5bk6fGWUIqYPPUDOKAY4inGTVRy4o1L/SFv+za971ur42p2RCVM0R/eU=
X-Gm-Gg: Acq92OHWtXDJW8gc3qsMfBhcfYAJ1hz20BLP09j1XDf7R5BTMCH7LNgRiCcWlYfg8x4
	fCu3IYbKl7QRhhGM4vUeXHbpn6feeggvdbl+RC0ijUtVoI1pPiivAlJmMPBz2bFR6fH85lmVlfm
	FM2cHVl/FSYSqhc1luQxBUfrwZVv2lpCid1w6tvr8tUYKA/kBnjT8M3OxzQMVvDueo4/co82Pud
	itb0XGyYVqQ6oV4FJlYMbsx9WnlhbI7qxL3ielC1MCUFQebLkvFrv4W5roKuPjTixB97Cj5/afk
	hAV3HEarAt3mFb2q+xxQC2g8jikQRbFkinfbDGVeJmKTwNIEMSOcpj2W6VHOSw/OzzGI5qJci8G
	rEmrkykzTHuUQaykreezqI+sKDh9Zv9IzVaRMwJvWyk1U59H3YRgXW0ClzwuflLfS+3z+rbSKZM
	q8Qlp1anxrY+KmnwSpt/fEGwYoVZ5Nk6+SwKK8XyXWBgKvFw==
X-Received: by 2002:a17:90b:2ccb:b0:367:db13:aca6 with SMTP id 98e67ed59e1d1-368f7a26e42mr2102563a91.26.1778661820923;
        Wed, 13 May 2026 01:43:40 -0700 (PDT)
X-Received: by 2002:a17:90b:2ccb:b0:367:db13:aca6 with SMTP id 98e67ed59e1d1-368f7a26e42mr2102502a91.26.1778661820245;
        Wed, 13 May 2026 01:43:40 -0700 (PDT)
Received: from hu-himchau-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d2709bsm169158725ad.5.2026.05.13.01.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 01:43:39 -0700 (PDT)
From: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
To: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org,
        acpica-devel@lists.linux.dev, paul.walmsley@sifive.com,
        palmer@dabbelt.com, lenb@kernel.org, james.morse@arm.com,
        tony.luck@intel.com, ardb@kernel.org, conor@kernel.org,
        cleger@rivosinc.com, robert.moore@intel.com, sunilvl@oss.qualcomm.com,
        anup.patel@oss.qualcomm.com
Cc: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Subject: [PATCH v4 00/10] Add RAS support for RISC-V architecture
Date: Wed, 13 May 2026 14:13:15 +0530
Message-ID: <20260513084325.2176952-1-himanshu.chauhan@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDA4OSBTYWx0ZWRfX0OKdzT0h0EwO
 IWUUBYKieTV3MkUe/3DVFBzhU54C19HwRHGGLXa/TVLD5HUkn0Sfno5dKYbPka/yq6JFZ8klns0
 x5uKphaTu3tgZT3lQEMMlxafmv7JhdZ8m+1WJ8sXubsZmU1shBKqPBLNbLwZzCBjqI4FDr/hTEr
 rRqi7POK7UdTvq/f7vd21dLaiJuIv/i5BTSpO1dMAct80SH1OWHasucVDIVQ0FGBV4RVwYerM1t
 931XT0goSIncxiRRMOqUDYl8s7qmqAffvWuri9DopRRBb3TWJRLen8omDyGimFpK9M/10l/qr9M
 fxlWMSmJrcQ+gwQM4I7EI2Monhlq932Wvs8C792moNPxGPSHuyFRWS+UywnMPYfgn/12RjfZbRY
 07K4PYyFW41U9imec5pepwEq8Hz7VqvSaQy/LnvOpexJmlBZ+ULayZRJbGqViaz0M9mfpmJAZOV
 g6RjSNYo45OKsIFrIOw==
X-Proofpoint-GUID: h-cKPTs5PxHW7qNNxVTiBlGTjGM3GoLO
X-Authority-Analysis: v=2.4 cv=bp98wkai c=1 sm=1 tr=0 ts=6a0439be cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=NEAV23lmAAAA:8 a=V1jnuoLLAAAA:20 a=VwQbUJbxAAAA:8 a=h0uksLzaAAAA:8
 a=dw0t6H4-AAAA:8 a=j7arexpxAAAA:20 a=WC7QRpXXAAAA:20 a=F-tpdftpAAAA:20
 a=hVMvMyeA2jgiXT6_RH4A:9 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22
 a=MSi_79tMYmZZG2gvAgS0:22 a=wVJa4CU9-Z26yuRAZDil:22 a=bA3UWDv6hWIuX7UZL3qL:22
X-Proofpoint-ORIG-GUID: h-cKPTs5PxHW7qNNxVTiBlGTjGM3GoLO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_05,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 clxscore=1011 bulkscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605050000 definitions=main-2605130089

RAS stands for Reliability, Availability and Serviceability.

This series implements the RAS support for RISC-V architecture using
RISC-V RERI specification. It is conformant to ACPI platform error
interfaces (APEI). It uses the highest priority Supervisor Software
Events (SSE)[2] to deliver the hardware error events to the kernel.
The SSE implementation has already been merged in OpenSBI. Clement
has sent a patch series for its implemenation in Linux kernel.[5]

The GHES driver framework is used as is with the following changes for RISC-V:
	1. Register each ghes entry with SSE layer. Ghes notification vector is SSE event.
	2. Add RISC-V specific entries for processor type and ISA string
	3. Add fixmap indices GHES SSE Low and High Priority to help map and read from
	   physical addresses present in GHES entry.
	4. Other changes to build/configure the RAS support

Changes in v4:
 - Rebased to Linux v7.1-rc3
 - Changed RISCV to RISC-V
 - RISCV32 and RISCV64 to RV32/RV32E and RV64 respectively
 - Raised a review request for patch "Introduce SSE in HEST notification types" in ACPICA
   https://github.com/acpica/acpica/pull/1170
   Keeping the patch here for complete functionality

Changes in v3:
 - Dropped RFC tag because the related ECRs are now approved [6][7][8][9]
 - Changes to be conformant with SSE v8 patches

Changes in v2:
 - Made changes to be conformant with SSE v7 patches
 - Fixed some bot warnings

How to Use:
----------
This RAS stack consists of Qemu[3], OpenSBI, EDK2[4], Linux kernel and devmem utility to inject and trigger
errors. Qemu [Ref.] has support to emulate RISC-V RERI. The RAS agent is implemented in OpenSBI which
creates CPER records. EDK2 generates HEST table and populates it with GHES entries with the help of
OpenSBI.

Qemu Command:
------------
<qemu-dir>/build/qemu-system-riscv64 \
    -s -accel tcg -m 4096 -smp 2 \
    -cpu rv64,smepmp=false \
    -serial mon:stdio \
    -d guest_errors -D ./qemu.log \
    -bios <opensbi-dir>/build/platform/generic/firmware/fw_dynamic.bin \
    -monitor telnet:127.0.0.1:55555,server,nowait \
    -device virtio-gpu-pci -full-screen \ 
    -device qemu-xhci \
    -device usb-kbd \
    -blockdev node-name=pflash0,driver=file,read-only=on,filename=<edk2-build-dir>/RiscVVirtQemu/RELEASE_GCC5/FV/RISCV_VIRT_CODE.fd \
    -blockdev node-name=pflash1,driver=file,filename=<edk2-build-dir>/RiscVVirtQemu/RELEASE_GCC5/FV/RISCV_VIRT_VARS.fd \
    -M virt,pflash0=pflash0,pflash1=pflash1,rpmi=true,reri=true,aia=aplic-imsic \
    -kernel <kernel image> \
    -initrd <rootfs image> \
    -append "root=/dev/ram rw console=ttyS0 earlycon=uart8250,mmio,0x10000000"

Error Injection & Triggering:
----------------------------
devmem 0x4010040 32 0x2a1
devmem 0x4010048 32 0x9001404
devmem 0x4010044 8 1

The above commands injects a TLB error on CPU 0.

Sample Output (CPU 0):
---------------------
[   34.370282] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
[   34.371375] {1}[Hardware Error]: event severity: recoverable
[   34.372149] {1}[Hardware Error]:  Error 0, type: recoverable
[   34.372756] {1}[Hardware Error]:   section_type: general processor error
[   34.373357] {1}[Hardware Error]:   processor_type: 3, RISCV
[   34.373806] {1}[Hardware Error]:   processor_isa: 6, RISCV64
[   34.374294] {1}[Hardware Error]:   error_type: 0x02
[   34.374845] {1}[Hardware Error]:   TLB error
[   34.375448] {1}[Hardware Error]:   operation: 1, data read
[   34.376100] {1}[Hardware Error]:   target_address: 0x0000000000000000

References:
----------
[1] [RERI Specification          ]: https://github.com/riscv-non-isa/riscv-ras-eri/releases/download/v1.0/riscv-reri.pdf
[2] [Chap-19 SSE RISC-V SBI v3.0 ]: https://github.com/riscv-non-isa/riscv-sbi-doc/releases/download/v3.0/riscv-sbi.pdf
[3] [Qemu source (RERI Support)  ]: https://github.com/ventanamicro/qemu.git (branch: dev-upstream)
[4] [EDK2                        ]: https://github.com/ventanamicro/edk2.git (branch: dev-upstream)
[5] [SSE Kernel Patches (v8)     ]: https://lore.kernel.org/all/20251105082639.342973-1-cleger@rivosinc.com/
[6] [ACPI ECR for HEST changes   ]: https://mantis.uefi.org/mantis/view.php?id=2522
[7] [RISC-V CPER Table ECR       ]: https://mantis.uefi.org/mantis/view.php?id=2551
[8] [RISC-V CPER Proposed Changes]:
	[PART 1] https://docs.google.com/document/d/1-Dd-T_QIUqjq3muyjfK8IUeXWr9QWkFAkFyzweXQL30/edit?tab=t.0
	[PART 2] https://docs.google.com/document/d/13y8kQqbVtCAPCMI4oJ80MtcUS5FL4xuO914NmfCi5vI/edit?tab=t.0
[9] [RISC-V APEI Proposed Changes]: https://docs.google.com/document/d/18rxA6JTyFTelEj0aiKdSFzxPgwyHyThj8EP8lXqWZdY/edit?tab=t.0

Himanshu Chauhan (10):
  riscv: Define ioremap_cache for RISC-V
  riscv: Define arch_apei_get_mem_attribute for RISC-V
  acpi: Introduce SSE in HEST notification types
  riscv: Add fixmap indices for GHES IRQ and SSE contexts
  riscv: conditionally compile GHES NMI spool function
  riscv: Add functions to register ghes having SSE notification
  riscv: Add RISC-V entries in processor type and ISA strings
  riscv: Introduce HEST SSE notification handlers
  riscv: Select HAVE_ACPI_APEI required for RAS
  riscv: Enable APEI GHES driver in defconfig

 arch/riscv/Kconfig                     |   1 +
 arch/riscv/configs/defconfig           |   3 +
 arch/riscv/include/asm/acpi.h          |  16 +++
 arch/riscv/include/asm/fixmap.h        |   8 ++
 arch/riscv/include/asm/io.h            |   3 +
 arch/riscv/kernel/acpi.c               |  12 ++
 drivers/acpi/apei/Kconfig              |   5 +
 drivers/acpi/apei/ghes.c               | 101 +++++++++++++++--
 drivers/firmware/efi/cper.c            |   3 +
 drivers/firmware/riscv/riscv_sbi_sse.c | 146 +++++++++++++++++++++++++
 include/acpi/actbl1.h                  |   3 +-
 include/linux/riscv_sbi_sse.h          |  16 +++
 12 files changed, 305 insertions(+), 12 deletions(-)

-- 
2.43.0

