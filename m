Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF1C409618;
	Mon, 15 Jun 2026 16:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539828; cv=none; b=UGRYvHW0/dSX3MBrmkmHxwdHSMYIOTMJ3wuIJ/R19qS5v75BIhlkJldDpOVOWboNHOmnJmT5JDjliijaPu+SdAF/fHXxpt7oGJuIsJjqTEAg76OfDCI7PK3UfmBcpDndEBGWV1IABdHo/LY2wVTIm3pILeQad5+/QYGMYMrORcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539828; c=relaxed/simple;
	bh=gRMBGazRMIJvujl+g/dwX6ABsY4B+xud2elh71dcWlU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=B4i+bDBhgJArZcOTJJU4C22eChCSIQ20Qy6oSz1i3bLBFqs8yP3PffJ2ukHT82NlA3byqNcwmji4BsnIpb6uQ9dYnWaVTGJllBEXFxorShqcXG8sbbtIHZMts/VrZ2roicAhs+LtmH0nX0vdN963ErMZuCFwMuk5DV1JPIkWZ4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kTk6lUK8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kTk6lUK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C1F1F000E9;
	Mon, 15 Jun 2026 16:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781539827;
	bh=49zVCGyfWoxZSOLI7DMtjjPuOtTCNuQTkO/o8EmuQmQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kTk6lUK8KO1uma2gVDJUTtHtMldV0PzHLwz8w0GtYzHCg0AGa4Drt8tl6zNI1uwZq
	 qJXWr+NPfuwjWVP2OZxhI8zhu+Hv6cbBRBD3T3y/FPoIKh88J1iD7ESne6glB3y8s+
	 +NX1Q3gbT8JHhyj6oJHh4nO79xueRFX3MJMveGJsAuGBCQMK2aq8zB++bO4Aggbubh
	 wJkA2MV3u1nhavDTAQSXpiOvt6LsueotIDisMVk28bdNd+vOTToPRskJ3ZYXnCJ4Lv
	 49kJNKDp4fArRNjV1GjJGNCRDWswZoECMb37Nj0YbI4R5tMF1Nz5ULes7Y6zjX5fYT
	 yGga41fa4LXJA==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 15 Jun 2026 18:09:01 +0200
Subject: [PATCH 05/19] arm64: define DPS root partition type UUID
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-discoverable-root_partitions-v1-5-39c78fac42e2@kernel.org>
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
In-Reply-To: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 linux-arm-kernel@lists.infradead.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1711; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=gRMBGazRMIJvujl+g/dwX6ABsY4B+xud2elh71dcWlU=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkGylenbdsReyviuUHNu1ceOk/OH+n7v2nrHIGJX/e7F
 2VJFmfVdkxkYRDjYrAUU2RZVs7JrdBR6B126K8lzBxWJpAh0iINDEDAwsCXm5hXaqRjpGeqbahn
 CGToGDFwcQrAVN+9xMiwZnOhza20osfqM7tX22Zkdk58P+l/tOysHs7Jp0oFsm/vZ/gfU7xThN+
 1WaHkef+VzPOcyzYsuvydRereFGbWGXZrq0JYAA==
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

DPS [1] assigns GPT partition type UUIDs to operating system partitions.
Root partitions use architecture-specific type UUIDs so the OS can
discover the intended root filesystem without relying on a root= cmdline
option.

Define DPS_ROOT_PARTITION_TYPE_UUID in asm/dps_root.h for arm64 and select
ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID.

[1] The Discoverable Partitions Specification (DPS)
Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification/

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 arch/arm64/Kconfig                | 1 +
 arch/arm64/include/asm/dps_root.h | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index fe60738e5943..190f8dde63b2 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -26,6 +26,7 @@ config ARM64
 	select ARCH_HAS_DEBUG_VM_PGTABLE
 	select ARCH_HAS_DMA_OPS if XEN
 	select ARCH_HAS_DMA_PREP_COHERENT
+	select ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID
 	select ARCH_HAS_ACPI_TABLE_UPGRADE if ACPI
 	select ARCH_HAS_FAST_MULTIPLIER
 	select ARCH_HAS_FORTIFY_SOURCE
diff --git a/arch/arm64/include/asm/dps_root.h b/arch/arm64/include/asm/dps_root.h
new file mode 100644
index 000000000000..7344f9a52343
--- /dev/null
+++ b/arch/arm64/include/asm/dps_root.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef _ASM_ARM64_DPS_ROOT_H
+#define _ASM_ARM64_DPS_ROOT_H
+
+#define DPS_ROOT_PARTITION_TYPE_UUID "b921b045-1df0-41c3-af44-4c6f280d3fae"
+
+#endif /* _ASM_ARM64_DPS_ROOT_H */

-- 
2.53.0

