Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BA03D525A;
	Tue, 20 Jan 2026 23:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768952974; cv=none; b=gbi3ubKIDjwuUNfcSsf3Fcis2+01zPDmodhAJtb8eHA735olBhXoOcvLITNVp91osI2DaLfRFMBXSaJ6pqCjIdN8dLRIsbysG+jIAWe/MYMeFY0WSwuY0l/1dsrkKlBMIrhm2WxZ4dUmODUCE9bzNROFwSSP1hVeFJqRKpSMFbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768952974; c=relaxed/simple;
	bh=F4QJ3WvMDWE16j+X+GducOqTky6ih2sSzMkgSXdr24c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mt+j4OysjyrVixKtLOv36qT9RxAVZt+X0yAFD4RsxN21im4q9G/cdTiZ4Ce8xj8JCPEJWTO02ToGb07tXJg4orha3spuRMDFuUjTs+zHJUEFl/WmzaqA0mtDdSFysAVzh1vK2ZcCr2GXeYMtfS7evec3ERAP3ktQ7IA4j0Rp1XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kFpXSEdq; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kFpXSEdq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768952973; x=1800488973;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F4QJ3WvMDWE16j+X+GducOqTky6ih2sSzMkgSXdr24c=;
  b=kFpXSEdqm9bVSmyjqJU7HcTn/YVwneeeBs6nJalHU5PDxghVCBXYtMTa
   gmzZ1GttxylDXknScR5EiSFVtHerx+35oy7sA8kC1q3Z/IGmQ11ds27o3
   u46AkSIyLdIGWUpXYa8zFbcnGDY1zZU3GYhgPPmHcIaDZJOCEZbFASYxl
   1O6XJW2uPSAmzMwuSB4av+OY+Pq0zGoYd1PisJ0LYO44ZDa3W06dsOvDz
   q7NQzU77Q7J66HRkNQz455PK8/r4/srri0Drd9strR/t0xI9jNhfxc6vH
   xN9W+ADux8m1wNSGKY/urlCR5hqWtwb8VJaixN84p47e3pUtpZIgY2G0q
   Q==;
X-CSE-ConnectionGUID: Gg46wg7sQfSJ1faMeu37kA==
X-CSE-MsgGUID: d2vddlUjSM28+mOBngqRRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="87752966"
X-IronPort-AV: E=Sophos;i="6.21,241,1763452800"; 
   d="scan'208";a="87752966"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 15:49:33 -0800
X-CSE-ConnectionGUID: nnc9YeFtTwGv1Cu1SVVhwg==
X-CSE-MsgGUID: R6WS9gguSeybXth9pKSv9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,241,1763452800"; 
   d="scan'208";a="236932650"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by orviesa002.jf.intel.com with ESMTP; 20 Jan 2026 15:49:31 -0800
From: Sohil Mehta <sohil.mehta@intel.com>
To: x86@kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: "H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Kirill A . Shutemov" <kas@kernel.org>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Tony Luck <tony.luck@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: [PATCH v2 3/3] x86/cpu: Remove LASS restriction on EFI
Date: Tue, 20 Jan 2026 15:47:30 -0800
Message-ID: <20260120234730.2215498-4-sohil.mehta@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260120234730.2215498-1-sohil.mehta@intel.com>
References: <20260120234730.2215498-1-sohil.mehta@intel.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The initial LASS enabling has been deferred to much later during boot,
and EFI runtime services now run with LASS temporarily disabled. This
removes LASS from the path of all EFI services.

Remove the LASS restriction on EFI config, as the two can now coexist.

Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
---
v2:
 - No change
---
 arch/x86/kernel/cpu/common.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cefd0722e6cc..5833849f0b52 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -415,14 +415,9 @@ static __always_inline void setup_lass(struct cpuinfo_x86 *c)
 	 * Legacy vsyscall page access causes a #GP when LASS is active.
 	 * Disable LASS because the #GP handler doesn't support vsyscall
 	 * emulation.
-	 *
-	 * Also disable LASS when running under EFI, as some runtime and
-	 * boot services rely on 1:1 mappings in the lower half.
 	 */
-	if (IS_ENABLED(CONFIG_X86_VSYSCALL_EMULATION) ||
-	    IS_ENABLED(CONFIG_EFI)) {
+	if (IS_ENABLED(CONFIG_X86_VSYSCALL_EMULATION))
 		setup_clear_cpu_cap(X86_FEATURE_LASS);
-	}
 }
 
 static int enable_lass(unsigned int cpu)
-- 
2.43.0

