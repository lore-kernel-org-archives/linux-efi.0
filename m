Received: from www345.your-server.de (www345.your-server.de [78.46.144.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD1F1E7C18;
	Thu, 25 Jun 2026 17:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.46.144.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782409068; cv=none; b=VXPH0lHeJoTpjKgQO3f0qbJQo/MCUZKKWyJclyois99i3uAT1xflMAagKN6yVeydxed0HG6maGHP6vlNoqMrf1AZiXjm/2iYfvgcWXggQCnLXcLJ4HqMOV37VUaaFSnm1gmP6TwKjlYO3kQ+xRURv5TF0+Kd09itJHEkjoxKMA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782409068; c=relaxed/simple;
	bh=ytqu8V8dbYLdG4Ekloe3e2TJqIhDemmAqSzNR2GXpgU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y+8pvynHkoyeR0Six5rneQYrVMhURBeylSX4JXJ/APJYjwaFyRXH0PXcxLgG4QMyvFh3t4KpBIRhjIs0/9ER4Y0LNJTPYgFqDFYlZLlkSgmWzsoLvxbAYxkvB+Mu8hPzXKZLBu8fHK7g2ssW2RempkiqPSNYZOu2RnGlgtlyZYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tti0.net; spf=pass smtp.mailfrom=tti0.net; dkim=pass (2048-bit key) header.d=tti0.net header.i=@tti0.net header.b=RDTcxNpZ; arc=none smtp.client-ip=78.46.144.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tti0.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tti0.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tti0.net header.i=@tti0.net header.b="RDTcxNpZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tti0.net;
	s=default2601; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:
	Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References;
	bh=yIzt0fmhxg0NIzVSuppKs0YdrAQS3wyZ9hAh87rsox4=; b=RDTcxNpZPgEjLuYPMqdWv3CxUw
	IRkLCkx50OwrpumrFdbkq1LqGWJOYW74HxoT8kq3CKHu9zUN+JPfy1sDYdc6E2KhjbLYa7KQI1Noj
	/kuLRadxPodLQn7QbVvDv2YtJ99cNZ4g0OWTyhKG96zKyZ4Qpg0MNst8oQIjqL/clyWE1BaDX9IQG
	5nyLrXerTgby1V0fhrgn0oG4PE1sKS+m+rBXpKqatpva1h+uC/8Hg5KV9PRfPWr+kfgxdiWQk9E+q
	TKRb0Wmk8IidB8Vpdcebu5R6clCJFWDQuDrR5QWwGODbfOKKYsgqGcQKvZ6hBg1ddiT6s70wD3c9T
	vO1dkJCg==;
Received: from sslproxy06.your-server.de ([78.46.172.3])
	by www345.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <theodore@tti0.net>)
	id 1wcncv-000PAc-0H;
	Thu, 25 Jun 2026 19:12:33 +0200
Received: from localhost ([127.0.0.1])
	by sslproxy06.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <theodore@tti0.net>)
	id 1wcncu-000Fa5-27;
	Thu, 25 Jun 2026 19:12:32 +0200
From: Theodore Tucker <theodore@tti0.net>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org,
	gpiccoli@igalia.com,
	tony.luck@intel.com,
	kees@kernel.org,
	ilias.apalodimas@linaro.org,
	ardb@kernel.org,
	Theodore Tucker <theodore@tti0.net>
Subject: [PATCH] efi: Make EFI_VARS_PSTORE depend on EFIVAR_FS
Date: Thu, 25 Jun 2026 18:12:14 +0100
Message-ID: <20260625171214.8058-1-theodore@tti0.net>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: Clear (ClamAV 1.4.3/28042/Thu Jun 25 08:27:10 2026)

The efivars backend to pstore will not register if the efivarfs is
not available. The efivars sysfs interface was removed in Linux 6.0,
meaning efivarfs is now the only way pstore can write into EFI
variables. Making the dependency on the efivarfs explicit removes
a stumbling block when configuring a kernel with pstore.

Signed-off-by: Theodore Tucker <theodore@tti0.net>
---
 drivers/firmware/efi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 29e0729299f5..8dfd21e7a8e4 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -9,7 +9,7 @@ config EFI_ESRT
 
 config EFI_VARS_PSTORE
 	tristate "Register efivars backend for pstore"
-	depends on PSTORE
+	depends on PSTORE && EFIVAR_FS
 	select UCS2_STRING
 	default y
 	help
-- 
2.47.3

