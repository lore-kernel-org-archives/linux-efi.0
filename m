Received: from esa9.hc1455-7.c3s2.iphmx.com (esa9.hc1455-7.c3s2.iphmx.com [139.138.36.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A88A37186F;
	Fri, 10 Jul 2026 06:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.36.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783664668; cv=none; b=dteTXd42EtQ/ggO+cZZYybq3cdcbA3njZYtllIaTgfTBIPWxzu1Qy+k8IOecABOfsagwlWrZyb/EEWYxwqSt+k45qc9Hy39eJNpRCSCs+qDFBims85c4WoEXBo4ju8lQRej/IhKjP2apuNxeR/xLV8lUr8EvA9828ObTg80Nz1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783664668; c=relaxed/simple;
	bh=HFnS/IroUgrD3Efyx//OAMn0jrlTbDHdOHhqt9ZqYx4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FCN9FkVe1miFR79uEzduNWVtnEaFgYxR7am3h9H6OLkVpyeUl8Ls4rNtFpxXBNarYr13DcxrF+e0wJ9vqVF2OZFkxdHAAGSuIZmkTXKDJE/L3Dd9+OPei3bB7so9qYST3cMb4ml84ikQQgniyugmswiBnkJaTs91AdmZOWC5mAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=GiSIlRnM; arc=none smtp.client-ip=139.138.36.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="GiSIlRnM"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1783664666; x=1815200666;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HFnS/IroUgrD3Efyx//OAMn0jrlTbDHdOHhqt9ZqYx4=;
  b=GiSIlRnMMhHWeaFY/VHwTlEXj3F0lDq4M1fmw92+l7xO60nJAMp+kCPI
   zDd0eQjNE5TcJ1oUkUKJXt+gxQNfPw2xgQaZIWembqANbWYTiWSVvqGXQ
   3EyxejOHsTfmS8p5J9XGrmrfMWRkAPFvn1VA5PiHqTYvVTKZCNW2ivSKD
   YviCOXUUCVJkm1nDVFyoxGfmB2jMMnTfIZ79vojpB4ZK31Fpp61uea/5I
   WkqXLa5diVE97FUtJIKXIXrGo55LJLyomcestm5jjaFM88YFckPiu7OgU
   7U46WlOCQat9TIwBjRX5Qiotlbef69pp5mYv/imn8FkzGVjR5m2wsWU5s
   Q==;
X-CSE-ConnectionGUID: POcJ7gvtQTCyue1+O4rclA==
X-CSE-MsgGUID: L2iczwXKRSad85vIC+qcVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="234349836"
X-IronPort-AV: E=Sophos;i="6.25,154,1779116400"; 
   d="scan'208";a="234349836"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa9.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 15:23:15 +0900
Received: from az2uksmgm1.o.css.fujitsu.com (unknown [10.151.22.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id D8D5AC00359;
	Fri, 10 Jul 2026 06:23:14 +0000 (UTC)
Received: from az2nlsmom2.o.css.fujitsu.com (unknown [10.150.26.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 8FA1396847F;
	Fri, 10 Jul 2026 06:23:14 +0000 (UTC)
Received: from whale.soft.fujitsu.com (unknown [10.125.16.33])
	by az2nlsmom2.o.css.fujitsu.com (Postfix) with ESMTP id 1B9FF18021A7;
	Fri, 10 Jul 2026 06:23:07 +0000 (UTC)
From: Koki Iwata <iwata.koki@fujitsu.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>,
	Matthew Garrett <matthew.garrett@nebula.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Borislav Petkov <bp@alien8.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Marco Elver <elver@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Li RongQing <lirongqing@baidu.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Matt Fleming <mfleming@cloudflare.com>,
	linux-doc@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	iwata.koki@fujitsu.com
Subject: [PATCH RESEND] Documentation: admin-guide: fix a doc for efi_no_storage_paranoia the "5KB" instead of the "50%"
Date: Fri, 10 Jul 2026 15:22:44 +0900
Message-ID: <20260710062306.1204206-1-iwata.koki@fujitsu.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Iwata Koki <iwata.koki@fujitsu.com>

The documentation for 'efi_no_storage_paranoia' incorrectly states
the kernel cannot use "more than 50%" of the EFI variable storage.

This percentage-based explanation has been outdated since commit
f8b8404337de ("Modify UEFI anti-bricking code") introduced a fixed 5KB
minimum reserve threshold (EFI_MIN_RESERVE) in
arch/x86/platform/efi/quirks.c. At that time, the documentation was not
updated to reflect this change.

Update the documentation to reflect the "5KB" instead of the "50%".

Fixes: f8b8404337de ("Modify UEFI anti-bricking code")
Signed-off-by: Koki Iwata <iwata.koki@fujitsu.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index b5493a7f8f22..3f75969a679b 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1614,10 +1614,17 @@ Kernel parameters
 			on all PCI bridges while in the EFI boot stub
 
 	efi_no_storage_paranoia [EFI,X86,EARLY]
-			Using this parameter you can use more than 50% of
-			your efi variable storage. Use this parameter only if
-			you are really sure that your UEFI does sane gc and
-			fulfills the spec otherwise your board may brick.
+			The kernel reserves 5KB of EFI variable storage for
+			safety, because some UEFI implementation may fail to
+			boot if there's insufficient space in the EFI variable
+			storage.
+
+			Using this parameter, you can use the 5KB reservation
+			in the EFI variable storage.
+
+			However, Use this parameter only if you are really
+			sure that your UEFI does sane gc and fulfills the spec
+			otherwise your board may brick.
 
 	efivar_ssdt=	[EFI; X86] Name of an EFI variable that contains an SSDT
 			that is to be dynamically loaded by Linux. If there are
-- 
2.52.0

