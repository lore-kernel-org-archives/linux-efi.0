Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9DAF48422E;
	Tue,  1 Sep 2026 16:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788281852; cv=none; b=LLtDWltkSORnzzRo6icQKkbyY15hMMTy0gRRcEtH1MOwOA6F2o6IRKe7r92b7v9437MQd0xtGebabhL2VZ1iBvwke2UrvOsjmpD+pnZt+F66EgRrGJBTDAMlqh6cpU7Kn9K1UTvPD9l9STk+vy+4KyQm+ZqAqAIxdHi1oe3utnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788281852; c=relaxed/simple;
	bh=zh44uNuqI1Wg57YvQp0F85qEQb95QStkvwdhh7x6kCs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q7QsTOvn3R1V+kkTWjOvUmN1U8SEjU5yznndTo55u8qRZ6JTTZU/x8eZVS4hEitTt8qwPMxONk2LTFZEyAWCF1FlA1Bej4Zp99elbc9f3XXS1BQOuDGojBhtuXZkQdCzsNdMb+uaTFAbfWP+WXP0eAp4Rtqsza6+6j5S4N3Jacw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=NcvYBHgV; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="NcvYBHgV"
Received: by linux.microsoft.com (Postfix, from userid 1130)
	id A29AE20B7166; Tue,  1 Sep 2026 09:56:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A29AE20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1788281814;
	bh=3Fz4IGBaimd1WXpp666Dao6Jwiv6GbJDuCPRL2reMBA=;
	h=From:To:Cc:Subject:Date:From;
	b=NcvYBHgVpwfRtmxgPdt//inLZdOo6vpUjZ0rXEMwgerezspwYpazwZzO8AxD3zzCP
	 DdpZpqJN9WT+hO8ENMtT7SnO/ossPv2ICb+hPjsh2OXo6YBpp2HINYpOzVG0HYog3z
	 XFMu0/ber+do3ULB3Mo7Ui8M9DFNUDNbfIJwmzgc=
From: Thara Gopinath <tgopinath@linux.microsoft.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	ardb@kernel.org,
	ilias.apalodimas@linaro.org
Cc: James.Bottomley@HansenPartnership.com,
	"longli@microsoft.com--cc=tzimmermann"@suse.de, javierm@redhat.com,
	lszubowi@redhat.com, francescopompo2@gmail.com,
	tgopinath@microsoft.com, x86@kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Thara Gopinath <tgopinath@linux.microsoft.com>
Subject: [RFC PATCH 00/12] Introduce LVBS support for Hyper-V guests
Date: Tue,  1 Sep 2026 09:55:14 -0700
Message-ID: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduction
=============
Microsoft Hyper-V implements Virtualization-Based Security (VBS) through
Virtual Secure Mode (VSM), which uses Virtual Trust Levels (VTLs) to
establish isolated execution environments enforced by the hypervisor. The
primary operating system executes in VTL0, while security-sensitive
components can execute in higher trust levels such as VTL1.

Linux Virtualization-Based Security (LVBS) extends this model to Linux
Hyper-V guests by introducing a secure kernel running in VTL1 alongside the
primary Linux kernel running in VTL0. The hypervisor enforces isolation
between the two trust levels, allowing security-sensitive functionality to
execute independently of the primary operating system.

This RFC series introduces the foundational infrastructure required to
support LVBS and boot a secure kernel in VTL1 from VTL0. Before any LVBS
service can exist, VTL0 has to stand VTL1 up, load the secure kernel and
boot all CPUs in VTL1.

This series intentionally focuses on establishing the VTL1 execution
environment and does not yet introduce higher-level LVBS services. Future
RFCs will build on this foundation by adding support for VTL0 to request
secure services from VTL1, attestation support, memory protection services,
and other security capabilities.

The goal of this RFC is to gather feedback on the overall LVBS
architecture, VTL1 boot model, processor bring-up sequence, and Linux
kernel integration before additional functionality is introduced.

Threat Model
=============
The security of the whole construction rests on the early boot path
being trusted. On a VSM-capable Hyper-V guest, the VTL0 kernel is
launched via Secure Boot, so the kernel image that enables VTL1
and loads the secure kernel is itself measured and signature-checked
before it runs. Enabling VTL1 and populating it from VTL0 during
early boot is therefore no weaker than Secure Boot itself: an attacker
who can subvert this stage can already subvert the kernel before VTL1
exists.

For the same reason, a Unified Kernel Image (UKI) is the preferred
delivery vehicle for LVBS. A UKI bundles the kernel, initrd,
cmdline, and (optionally) devicetree into a single PE binary that is
signed and verified as one unit by Secure Boot. This extends the
signature-verified boundary to cover the initrd, which is where the
secure kernel image is staged before VTL0 hands it to VTL1. Without
a UKI (or an equivalent measured-initrd scheme), an unsigned initrd
would be an obvious weak spot in the chain.

The series is based on hyperv-next (tag hyperv-next-signed-20260826) and
boot-tested on an x86_64 Hyper-V VTL0 guest with litebox [1] as the VTL1
secure kernel.

[1] https://github.com/microsoft/litebox

Comments and feedback are greatly appreciated.

Thara Gopinath (12):
  drivers: hv: Add HYPERV_VSM kconfig option
  drivers: hv: hv_common: Allocate Hyper-V output arg page when VSM is
    enabled
  drivers: hv: Reserve memory for VSM secure kernel during early boot
  firmware: efi: libstub: x86-stub: Enable VSM awareness in efi os
    indications variable
  include: hyperv: hvgdk_mini.h: Add VTL-specific structures and bits
  drivers: hv: Add VSM boot driver and enable VTL1 at the partition
    level
  drivers: hv: hv_vsm_boot: load secure kernel image from firmware
  arch: x86: hyperv: Build initial vCPU context for VTL1 secure kernel
  drivers: hv: hv_vsm_boot: Enable VTL1 on the boot processor
  arch: x86: hyperv: hv_vtl_vsm: Introduce vtlcall
  drivers: hv: hv_vsm_boot: Boot primary processor in VTL1
  drivers: hv: hv_vsm_boot: Boot secondary processors in VTL1

 arch/x86/hyperv/Makefile                |   1 +
 arch/x86/hyperv/hv_vtl_vsm.c            | 287 +++++++++++
 arch/x86/hyperv/mshv-asm-offsets.c      |   8 +
 arch/x86/hyperv/mshv_vtl_asm.S          |  75 +++
 arch/x86/include/asm/mshyperv.h         |   9 +
 drivers/firmware/efi/libstub/x86-stub.c |  57 +++
 drivers/hv/Kconfig                      |   9 +
 drivers/hv/Makefile                     |   3 +-
 drivers/hv/hv_common.c                  |   3 +-
 drivers/hv/hv_vsm.h                     |  19 +
 drivers/hv/hv_vsm_boot.c                | 630 ++++++++++++++++++++++++
 drivers/hv/hv_vsm_securekernel.c        | 188 +++++++
 include/hyperv/hvgdk_mini.h             |  46 ++
 include/hyperv/vsm.h                    |  43 ++
 14 files changed, 1376 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/hyperv/hv_vtl_vsm.c
 create mode 100644 drivers/hv/hv_vsm.h
 create mode 100644 drivers/hv/hv_vsm_boot.c
 create mode 100644 drivers/hv/hv_vsm_securekernel.c
 create mode 100644 include/hyperv/vsm.h


base-commit: be0cfab740e58b70047ef6e7e3d578f00ed5d258
-- 
2.34.1

