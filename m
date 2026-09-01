Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9E8748422F;
	Tue,  1 Sep 2026 16:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788281852; cv=none; b=hW/3nnLiChiGFbf33qkbUwrMjaRHMKa+F+PZTbLQ5vXfgIPJFd0x9pN3g1WysAmo5S7iW+twAKxe+khlQxjW76Ucmt/oWqotlMKMSvLcFBxyHFaDcTyzY9Jpa6hU6MezzJNehThkvNV3Fq4R7SVMcgxSgiAokPdpdQLI6scV2ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788281852; c=relaxed/simple;
	bh=BYLNSpftBMqiAsSmrofow/DtQEm1FVYqb+nofRHTU0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzX0g5dYF9mYqKcuNEe+0vfKNQagwCiae4cIHpKlaOefuNXGfmtvHyBpA6nKHdQhjCF5hEQZVNHhPKJ4TdOSTeDKm7jldq0l63Dpv9WRWfrA+Yqu7v0y2gylMENZltzmcf8OnSIf0Eizj5M1OTIGODBRPZol5yCdi0VMvJpMmwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=ByuK+gb5; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="ByuK+gb5"
Received: by linux.microsoft.com (Postfix, from userid 1130)
	id B049220B7128; Tue,  1 Sep 2026 09:56:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B049220B7128
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1788281814;
	bh=pq3olvd2U6K9Wem0Ry+RFBQUO82EsXIj9NKtu2tnT/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ByuK+gb5R6+Yu1yunYrmlM2ifm0fOym4YVQQvwo/SeSNZMCjDpGIcAKg9ZN1qw3qV
	 hHuuIg2KUU1rzKgbVPtiNfFgQe5sBu/3Pw0GyjVsh5ypIeJf+WUN9R/8YgQizAJd36
	 sIeTfmow7t8EW9ZXC0XSwsL6Am6QiwL2q9X7tm/I=
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
Subject: [RFC PATCH 01/12] drivers: hv: Add HYPERV_VSM kconfig option
Date: Tue,  1 Sep 2026 09:55:15 -0700
Message-ID: <20260901165647.3160413-2-tgopinath@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
References: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce CONFIG_HYPERV_VSM, the top-level switch that gates
VTL0-side support for Microsoft Hyper-V's Virtual Secure Mode (VSM).
Enabling it lets the VTL0 kernel load a small secure kernel into
VTL1 and stand up the VTL0<->VTL1 interfaces needed to request
VSM services.

Depends on HYPERV and on X86_64 which is the only architecture currently
implemented.

Signed-off-by: Thara Gopinath <tgopinath@linux.microsoft.com>
---
 drivers/hv/Kconfig | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
index aa11bcefddf2c..a325fc61be604 100644
--- a/drivers/hv/Kconfig
+++ b/drivers/hv/Kconfig
@@ -40,6 +40,15 @@ config HYPERV_VTL_MODE
 
 	  If unsure, say N
 
+config HYPERV_VSM
+	bool "Microsoft Hyper-V VSM driver"
+	depends on HYPERV && X86_64
+	help
+	  Select this option to enable Hyper-V Virtual Secure Mode.
+	  Enabling this option will load a secure kernel in VTL1 and
+	  establish an interface between VTL0 and VTL1 to request for
+	  VSM services.
+
 config HYPERV_TIMER
 	def_bool HYPERV && X86
 
-- 
2.34.1

