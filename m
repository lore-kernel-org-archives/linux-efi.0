Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72346470136;
	Fri, 21 Aug 2026 10:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787306824; cv=none; b=UVc5HKd+2yfEEnd0RoGJ6yS6Tt1/1WVM98CkYTvVrdjs9Eu6DIBdzPdqplMysunfXydp6DAlulDRDPVuir1OqXwbZgDvq8lE6Py3Qj4S5PZHojisVJiYLBSfE9BGJxJnMOpCpww3Xy2BTH36VXWi9K3sckPOrSvVAfuvJIy7St8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787306824; c=relaxed/simple;
	bh=C5EuuwpNY5nvk98hyZjVmVyrfx8vi+SqUwzV/WPLKts=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=g4wTz+XzPQrKTa82/ZZh9ofxWkFJrZtnSS0HvVeTFpPHCiZTwjtfUUGG9bkdW8SUj7LaQUPTQAGprkBNCa9FKxhOTFsyZGxrQrR+WtP4U7VQxb4sLf9SV5WECwHB5gHmGqka5jyJlik+zM+REmk1YcRGvRgtvfMi4wkrWcAbgGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=AXjvKfsH; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="AXjvKfsH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=TWUgrg2oyif/z+3LRHUgpEMONMbKe31piyu+fjgyTPk=; b=AXjvKfsHRrlUy/85X/g+r0/wvs
	5DG0fiowafk/zPk/acmEyRjV/KlM0elacpnox/ob9oO4uYc9hMcPv65xjjvaFX+BlCwGv4qjSHfgG
	QcKUnWafqX86nz5TtczUQiiYj23FMHpWyQULqnrjQJvyhk4ZWA71Hf4AUds80tndb9SS7qe9gyZTk
	9ItsYoDjdbWfEV4gW4oUlvYJVx5ApWYXPWULFzErttrczEy4ireCV+JE0+nzLA3keuSuw7jGV0Cth
	pMjviVHvQXA4yoh85zKSWLYNr0IFNNaCQW4+x0sc4r8ZEHyNrU4L19EHSL8UT+7Wv1tr7wENCmoaJ
	yfLn94gQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wxM93-00BGBj-1G;
	Fri, 21 Aug 2026 10:06:41 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 21 Aug 2026 03:06:04 -0700
Subject: [PATCH v2 4/6] efi/libstub: install the poisoned-memory table from
 the stub
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-hwpoison-kho-v2-4-5743791e48e6@debian.org>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
In-Reply-To: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, kas@kernel.org, riel@surriel.com, 
 kexec@lists.infradead.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=1559; i=leitao@debian.org;
 h=from:subject:message-id; bh=C5EuuwpNY5nvk98hyZjVmVyrfx8vi+SqUwzV/WPLKts=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqiCMaDftorVUDCaUHLSwpSUmd8hWjXyWY4oOXI
 ryUjhDKDbGJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaogjGgAKCRA1o5Of/Hh3
 bRrvD/9HZjdZmiXO+WacXh65YCVhn2MyGUVpEgcGoMQfmso15ErjMO93KJzMYBcz8nP2MoN3RQT
 ExgpjFq5TgjmMtn6kixUuJeMoNauEYJURdhfoxEFOmtKvceN6vGs8Gv+dMV4ioklRcWhcUBvKd+
 UkLqi1X/Cjy1Iba0aIUSsQhpx6ZH7NEB6JfksmbevOOgarNY50zL/QQr3o6AlhTJyFPeA2L0vkr
 Gr79L6/Q/sJR5gVU+95frI7uXA76JqMFzfm1nue7jylyEVig7bMPuY2i1trHbvLhFtcL4u9sWcU
 M+J6cQy/zzEFdmPZJZHT1zWLAUMOj/oy+hH1Nxbf8HHsG38KOiaTNrU3gJNWrusKEY98hGkHZoX
 0gSH62z9uJiEzmecV6xmgHINCQ2CeVuEtTxZYnKaR/j9UQeO+Rs3sXHT9lbyOgup0buRbfjMpc1
 BXH9RqFXPREaI493li88NNGxGP6LqZpxlG/NNMAWHgGItNzGd0/fPcI13VSt0gbKNIhOAH7MFdb
 d1QpHTrRQ/HS2o0RvLmD9X0unM1Pec1ZjEmctBULGlesSOrMr9eP4rU1miCgL0BjSVYgOulVuyH
 CxRmEjr4iBFnxO0er4olzAwigHnSbbkSlwyLGeUAiF4SK5lDoopcMDHxu/sfrlkQXSlErXTTMLk
 mYILtAkfNfZh8eQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

Call install_poisoned_memory_table() while boot services are still up,
so the table exists before the kernel that will flip bits in it runs.

x86 does not go through efi_stub_common(), so the generic stub and the
x86 stub each need the call; on x86 it has to come before exit_boot(),
which is the last point a configuration table can be installed.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/libstub/efi-stub.c | 1 +
 drivers/firmware/efi/libstub/x86-stub.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi/libstub/efi-stub.c
index 42d6073bcd062..008635eb5027a 100644
--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -179,6 +179,7 @@ efi_status_t efi_stub_common(efi_handle_t handle,
 			 EFI_RT_SUPPORTED_SET_VIRTUAL_ADDRESS_MAP);
 
 	install_memreserve_table();
+	install_poisoned_memory_table();
 
 	status = efi_boot_kernel(handle, image, image_addr, cmdline_ptr);
 
diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index cef32e2c82d8f..f90de11bc8855 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -1023,6 +1023,8 @@ void __noreturn efi_stub_entry(efi_handle_t handle,
 
 	setup_unaccepted_memory();
 
+	install_poisoned_memory_table();
+
 	status = exit_boot(boot_params, handle);
 	if (status != EFI_SUCCESS) {
 		efi_err("exit_boot() failed!\n");

-- 
2.53.0-Meta

