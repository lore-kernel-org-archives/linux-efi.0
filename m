Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A9C3E0C50
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 07:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790235451; cv=none; b=c4ixNTz2ButszE/tlhvcXse2Y6znP14y/xjd0Aqa1tp3WYOP+drphMRhEZjWBwqJT2qtg0O4+mMchUE0QYy9k2JeC9ZMy2U3h5ev8fthdRfQ4V2ub6rxKInp3vNCmx7mSJEdVmIxan2bOULILsLmDWN3lMBPaaAvEH4oPRoWsRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790235451; c=relaxed/simple;
	bh=F4YOZAyT9+v8BeHVzPq74zObDOFmFJurwkYTVqXLnB4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tbPSUJVntDt6W4RWg4wN7wQXsQwriPivttZfRvDdXdNzUIJvtSSVdGqpZ6K1Yaptm9RzKLrpOL7NHtIQoNh8KEXcls9qAlOAhAQy5hOftdPMyBfGtjJnmTrou73jyaO+MRdlmdJ2y2MzlL+HB8Sm4GZ41f0b/AC5YwYbwNPFNDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LNqk74+4; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EohMJ+uy; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LNqk74+4";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EohMJ+uy"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5eBmD2420912
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 07:37:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=1w+JvUxZEw++QK9Ap9uSoi
	au1BeWaNj5tUGjJMjv4GE=; b=LNqk74+4dX6OYzqukgQbkxoGDF9EAogd+Vog7G
	Oy8WOvhHAhroaNh2WSzDheNIlFVtHlT9G/L70F79XJ7gY1TLe7MPSzmExEolF2Bj
	dl64xnNyM2H/N1hgDNY1lWPvmZfhH0ez72qIxYNnbjvmgYQhoOAHYpPUN9Gp4LqI
	r3kS7BYhp9zSYry8RQ0PoW3v5IvHBYEt97rEbWfxNvge+F2FbyGwvn5LqVCTOn5u
	K6kUroWsXpUsgQ6bmom8jy5NDznWPLVKNr2HpZ4eglKIoZe01CVYIdTFWEABWFs9
	fM3SYGS7LLuMcN2ZC5yACZ7qa/op0CZeC4zMhG2jkmUuGFBQ==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvstuhad8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 07:37:29 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso3002812eec.1
        for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 00:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790235449; x=1790840249; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1w+JvUxZEw++QK9Ap9uSoiau1BeWaNj5tUGjJMjv4GE=;
        b=EohMJ+uyZcLfiLgGWTHd2/O9N8KqYIMu3HwujgbmZ/lHUzaEABBAqSvTri06qEF+KH
         yLA6A9FXFiXhF9RsjMSNbYz/LQnT7QrDlmbLSaELXWlQ+uGbZ+Je/xDPmZWoCG86CTv/
         TA66UPMbU165djXj2pHC3cVLOfDuBIzSTVmH5s73B9/QhDIMiK7NhThJzT+Q9tzgF63E
         GPr/qSV06sWwxyYPZnTJiu8apMd7+ubdt8pssYAKGbu6G1jdty0vIfgq1MzMXTxG/ISk
         enxKseJRzzoyXiqmb1zMNIVd1D2CdxW9yq/SUjOFEn54RbJj2iixV9KhwaCfRIp4oCHd
         kYJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790235449; x=1790840249;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1w+JvUxZEw++QK9Ap9uSoiau1BeWaNj5tUGjJMjv4GE=;
        b=ijZ+QuNe1G2fTHOI9KarRNkA6idg3XNdtJZFw3Mm+Lx1ajmTnz9DgZ6vGHwGwPpFwX
         ulgmdQIBZ1rA0a7qSG7OSq0ojVSy7E5sljx2QijUCiD7bnFqeLkRT0384vEFemaMqGbB
         /UPf20RrMi6wMrEvvJlRfAvRSkeRzx9NankBE0EQYnsxUQj1uBY2w+pCC+5gxM/hcOed
         1Q7utkIqOrupD2fP01dfVufsAXNeOdlBoVcQ3lmKF8tsldR2TIsxqHUsWd+ea+92kla9
         zcOuFm4TFHkQ8oYDjH9ev6sy9vcOBJ6oZGpz6xQayMFFHgZ7PmJ7UVO9AhSxvf7WqD2M
         dPcA==
X-Forwarded-Encrypted: i=1; AKwUvBw6UuYWFnWxOmNcn2cTk/gT23vlq565/fr8iCR4AMFcjgifbrkEsyQkyTPAkGnLn25qhvA+ZoDTRmo=@vger.kernel.org
X-Gm-Message-State: AFuF++liFRcgxd68g5rTgwWD73ybXCjET++c0QhelBuTBeX0alA2TtKm
	I6eDQTZgc4KaFlOgIEUu88o9Jz8RnfAI4+OIl/MhAwLRSfBPG8h1aXSukchdypy+xyZqZjNf+sw
	5NqUUDfYPdBQK6ZP6ucqyCjqqmQaK54GVDofOUIAf20wUclkmavjRa3g0N6Mc5Yk=
X-Gm-Gg: AYBFou3qbyK83CGwWFeT416gf5hTndOYFgMTOgmwXamwKqabPwfxTTDbY8hBhmIa3mM
	X1NHCU3H4a5F9jBGtHFDtfheMr8ijt7xONuwm2KH3MdliL5LFh6feX5kN4ZQqKWeQU0rYzMfHoQ
	/V0z3mwehJh5kT128uSwfKyEwtGWlx6aW9cd2IP+OPuDP1myOQL9SNZhXn4sMJihqwz/FZ2kdmn
	N2hdrNh3BjoPn5Dw/Wfkwc7YXSRp3npiRNGPlSPHewKhDFBAKsm4s42ilAMsN/OqshccmdFotJo
	DaZ8luLcqzcFrTzDjtTha/kRMnvmpN6OPYuTRVsZMs4w4X2LwjqrTudv2rbjlYeFkUVFq+c1TgR
	cr9/HhSpB3DjihPq/QidotC7BOLl481DI/b3FYKL6TP1BfOQhqmJ5/34fbcNa9MXLMLqieixZT3
	AyuqU1/oon3FWIHUta8m4882+g
X-Received: by 2002:a05:693c:8087:b0:33b:f062:a674 with SMTP id 5a478bee46e88-34000643243mr1469595eec.21.1790235447236;
        Thu, 24 Sep 2026 00:37:27 -0700 (PDT)
X-Received: by 2002:a05:693c:8087:b0:33b:f062:a674 with SMTP id 5a478bee46e88-34000643243mr1469548eec.21.1790235446486;
        Thu, 24 Sep 2026 00:37:26 -0700 (PDT)
Received: from hu-himchau-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e95c7cfd9sm12120680eec.5.2026.09.24.00.37.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 00:37:26 -0700 (PDT)
From: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
To: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org
Cc: acpica-devel@lists.linux.dev, anup.patel@oss.qualcomm.com, ardb@kernel.org,
        conor@kernel.org, james.morse@arm.com, lenb@kernel.org,
        palmer@dabbelt.com, paul.walmsley@sifive.com, robert.moore@intel.com,
        sunilvl@oss.qualcomm.com, tony.luck@intel.com,
        zhangzhanpeng.jasper@bytedance.com,
        Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Subject: [PATCH v5 0/9] Add RAS support for RISC-V architecture
Date: Thu, 24 Sep 2026 13:07:05 +0530
Message-ID: <20260924073714.1650588-1-himanshu.chauhan@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAzMiBTYWx0ZWRfXzhAiUEzySBgU
 nB6OxUn5sKcvU+4LN7Kuy+kFpJpt9co110RxQYB9SaGDnNYE+5RJjeS2lLH0w7NBzgfTu7qszGb
 EVVWoEJKghUZ+edgZ5CtIf9UPKSUhAA=
X-Proofpoint-ORIG-GUID: ErAFW0wbx3BATGf8CMBF9liYviU7uqSv
X-Proofpoint-GUID: ErAFW0wbx3BATGf8CMBF9liYviU7uqSv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAzMiBTYWx0ZWRfX43onb8+6Vp4S
 OfOayEQQzzvpoSGD0iJA2lt8qM/08q4r/acC2WxBzP9EBeNrHywuRti8J/Vknt4xAJSt/YfrXJD
 bEUUwsElVG1q+HEqWhd7Oz5Nb0sv36uNlltuXFdjFQcs733eQBgp24iB4fkJkUiqCnQ8yBPR/zc
 EOU+81oKULyBKW8Spp2zTdUkUtwolmQ7n24vgm5T/jlhwntJqWUt93hkQmxMNJzoui3f5qVLlG/
 WQsLwq5CsJW8zh6Qbd1Q3Je2n3hVzP2Fp2ntWV7eLGzlbaeOzMbJ3cAYQEKoruUjAjUEwpcmLTp
 yNPY7rkl9Nw98Eq7akDPyf1hKBaQfOX34pr06ESBDRUV2d39r5WYEhUxw26t+6orypShwCWVKWs
 62wAwHn+onZ75bwICPZ+ylOi+0eOUr39nW0Tw/z4mPqKxzSPBAmh9aD59yfabsqBwydLhkY2fXo
 VkH9pIBZvDSLbPqFGIg==
X-Authority-Analysis: v=2.4 cv=cKp1IVeN c=1 sm=1 tr=0 ts=6ab4d339 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=NEAV23lmAAAA:8 a=V1jnuoLLAAAA:20 a=VwQbUJbxAAAA:8 a=h0uksLzaAAAA:8
 a=968KyxNXAAAA:8 a=dw0t6H4-AAAA:8 a=j7arexpxAAAA:20 a=WC7QRpXXAAAA:20
 a=F-tpdftpAAAA:20 a=5RlsHsUcgChCSPQ6cREA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22 a=MSi_79tMYmZZG2gvAgS0:22 a=wVJa4CU9-Z26yuRAZDil:22
 a=bA3UWDv6hWIuX7UZL3qL:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 impostorscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 clxscore=1011 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240032

RAS stands for Reliability, Availability and Serviceability.

This series implements the RAS support for RISC-V architecture using
RISC-V RERI specification. It is conformant to ACPI platform error
interfaces (APEI). It uses the highest priority Supervisor Software
Events (SSE)[2] to deliver the hardware error events to the kernel.
The SSE implementation has already been merged in OpenSBI. Clement/Zhanpeng Zhang
have sent a patch series for its implemenation in Linux kernel.[6]

The GHES driver framework is used as is with the following changes for RISC-V:
	1. Register each ghes entry with SSE layer. Ghes notification vector is SSE event.
	2. Add RISC-V specific entries for processor type and ISA string
	3. Add fixmap indices GHES SSE Low and High Priority to help map and read from
	   physical addresses present in GHES entry.
	4. Other changes to build/configure the RAS support

Changes in v5:
 - Rebased to 7.3-rc3
 - Based on SSE v10 Patch series
 - Notificate type patch is generated from acpica gen-patch.sh script since the review request in v4 is now merged.
 - Since 7bfd21e828504, takes care of conditionally compiling ghes_in_nmi_spool_from_list, 5th patch in v4 is dropped.
 - Moved from kzalloc to kzalloc_obj for sse event allocation

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
[6] [SSE Kernel Patches (v10)    ]: https://lore.kernel.org/all/cover.1789974241.git.zhangzhanpeng.jasper@bytedance.com/
[7] [ACPI ECR for HEST changes   ]: https://mantis.uefi.org/mantis/view.php?id=2522
[8] [RISC-V CPER Table ECR       ]: https://mantis.uefi.org/mantis/view.php?id=2551
[9] [RISC-V CPER Proposed Changes]:
	[PART 1] https://docs.google.com/document/d/1-Dd-T_QIUqjq3muyjfK8IUeXWr9QWkFAkFyzweXQL30/edit?tab=t.0
	[PART 2] https://docs.google.com/document/d/13y8kQqbVtCAPCMI4oJ80MtcUS5FL4xuO914NmfCi5vI/edit?tab=t.0
[10] [RISC-V APEI Proposed Changes]: https://docs.google.com/document/d/18rxA6JTyFTelEj0aiKdSFzxPgwyHyThj8EP8lXqWZdY/edit?tab=t.0

Himanshu Chauhan (9):
  riscv: Define ioremap_cache for RISC-V
  riscv: Define arch_apei_get_mem_attribute for RISC-V
  Introduce a new HEST notification type for RISC-V SSE events.
  riscv: Add fixmap indices for GHES IRQ and SSE contexts
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
 drivers/acpi/apei/ghes.c               |  99 +++++++++++++++--
 drivers/firmware/efi/cper.c            |   3 +
 drivers/firmware/riscv/riscv_sbi_sse.c | 146 +++++++++++++++++++++++++
 include/acpi/actbl1.h                  |   3 +-
 include/linux/riscv_sbi_sse.h          |  16 +++
 12 files changed, 303 insertions(+), 12 deletions(-)

-- 
2.43.0

