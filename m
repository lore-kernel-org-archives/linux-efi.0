Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29E0E48423A;
	Tue,  1 Sep 2026 16:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788281852; cv=none; b=vBPJTy//exInRlPfwpYN9X8ZEc4RUJGTnU/ROfUA6GQ+mAvHEgSJ15donbdU/wDI7RbEDoxPnEc47XKb1UVj/MHxtVdo8oXE7a9/b9wqLwjTmedWaU+b3KOEe2P6JfnfNcx5y83nZM3BWUza4pr2XNdPGjkynVO2DmsFo+Qy8cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788281852; c=relaxed/simple;
	bh=8zgXpZdNVn//9tbb2bdapPC5ryUwN+H5qsHCR4ob8Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOnrXW6BaX5QFFufV4LM+Vsl9AGsCrH8oLcHcspPd3y0VLJF5Lf/NbmTbD9LZX8IXVlm7Wut3qUwbzflqnyCO8R79HTGMTcHrpnEz5IkJ913mBO+qs+92jnLlL5IlMV0CkEtlvyQ8Ye/z7oVCjidTX0sNpvEShXnNKAlPGwTQBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=rjDaZCxy; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="rjDaZCxy"
Received: by linux.microsoft.com (Postfix, from userid 1130)
	id BD50E20B7129; Tue,  1 Sep 2026 09:56:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BD50E20B7129
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1788281814;
	bh=SDFmvrBzzsvWUwoeHWjK4dfGUsNJ6xbYPIoV56miAzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjDaZCxyN+xcNG6Dc9USNRZBdxcyhF+2KpoFV7HZnSKaQo2vPIYL2PZa2oKzQozhx
	 Q7czDurjmnaVFFmdFpZ7ExSS2Md4XMVGgz4Jf1ILkdaUWsuGFSJQIN30GGdpUT3uY8
	 aWXqsbSb+P910MuICL+aMPRT7NZxVbq/02BTsqMk=
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
Subject: [RFC PATCH 02/12] drivers: hv: hv_common: Allocate Hyper-V output arg page when VSM is enabled
Date: Tue,  1 Sep 2026 09:55:16 -0700
Message-ID: <20260901165647.3160413-3-tgopinath@linux.microsoft.com>
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

hv_output_page_exists() controls whether the per-CPU Hyper-V output
argument page is allocated at boot. This page is required for hypercalls
that return results via an output GPA, like HvCallGetVpRegisters.

The VSM drivers read VSM-specific VP registers (e.g. HvRegisterVsmVpStatus,
HvRegisterVsmCapabilities) via get_vp_registers(), which issues
HvCallGetVpRegisters and therefore depends on the output argument page
being present. Without it, those hypercalls fail and VSM initialization
cannot proceed.

Extend hv_output_page_exists() to return true when CONFIG_HYPERV_VSM is
enabled.

Signed-off-by: Thara Gopinath <tgopinath@linux.microsoft.com>
---
 drivers/hv/hv_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
index 31256cb22b39e..44f4a10984618 100644
--- a/drivers/hv/hv_common.c
+++ b/drivers/hv/hv_common.c
@@ -259,7 +259,8 @@ static void hv_kmsg_dump_register(void)
 
 static inline bool hv_output_page_exists(void)
 {
-	return hv_parent_partition() || IS_ENABLED(CONFIG_HYPERV_VTL_MODE);
+	return hv_parent_partition() || IS_ENABLED(CONFIG_HYPERV_VTL_MODE) ||
+		IS_ENABLED(CONFIG_HYPERV_VSM);
 }
 
 void __init hv_get_partition_id(void)
-- 
2.34.1

