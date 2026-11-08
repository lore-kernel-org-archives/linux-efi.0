Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.97.179.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794098165;
	b=CyiMjvHSSIOK/t4RpsXcxQ1IDNJwp7/pIa5H5ZD/JrfpFT9tqnQ7UXCHe1pu9/q2lkIW
	 B7YVWKlb1ORlUJG3M+EpV4Vm2xfU6QsD1hpbO/n4Xal0nVeN1FjdvvLL9XTZzB1QxR5z7
	 QDlW+bQ5O9YE9+A3C2TTLEQkU36UvWDGqa00XczslEneJtd1YR8C0Z6jpLHTe6onNWecM
	 KlhMzohUL7COvKNZdIzamzT+GskO74gi7x4VzZ/youHcJtTOgt7xbHN9ZwvBx/gEriJ5S
	 JxdHxxnE4si+LqYywDQ0iQSf4TVbmW6Mbv4zFy8itOPsRCQCpek+l7mh5OFu+Ipsa7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794098165;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=zSc6L8IoojH4knZYDfgKDnW9vaF74JJ3hJF7RIafahc=;
	b=FVPby3qrTZ6y9NGLuILbIe2GTO/IFD4dQtPhNAiz9fqi+FcfFXYarHR+RHie14Aqj8sM
	 T++71jJvBHUNCzmcicCNQMlZPuReEj+FiIM/en0uZtNCB+ViYV+lVAOanEE39lXC9xfep
	 VqytF9lR1Eps8IDV67KJKSzTYK04XB7SPBSTIR0mdroNw8mPj3v4icX8kyxMhmiZy3TB2
	 i1fGvk2oHsq6GBJdPw2Mbz9Bg+NOlcAoZWrv78Vdk7taYrygo3xYguGFEqQZfaDZNjv2L
	 TBUqc7sk1IVBrWDeUy6d4r6xeOrwivO1DEfPBiUSTSoAPJNxNZgk3t/DrFJ/V2bCcIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=igalia.com;
	spf=pass smtp.mailfrom=igalia.com;
	dkim=pass header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=jc1Cm5WM;
	arc=none smtp.remote-ip=213.97.179.56
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602BA606A326
	for <linux-efi@vger.kernel.org>; Sun,  8 Nov 2026 00:36:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 602BA606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=jc1Cm5WM
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:From:Reply-To; bh=zSc6L8IoojH4knZYDfgKDnW9vaF74JJ3hJF7RIafahc=;
	t=1794098162; x=2109458162; b=jc1Cm5WM8TOB2wZbCAaIk+8SpEqqzcNTn3FUEtMDqRR1GwT
	GtIPs52X4wtXbqHqFT7gOhcBqxnB6hsZqYYpxi3+FG9wkY0CYuBHZTz0u/IDU/PKaqe9S2QUuLEZn
	JB1BHd6jeAWfcp3HhVDtIgRW4hvk89zHSlzO3/kipoluHIrzuTzT+FZkW1kPSmNdSdedZ0ODvPlTw
	7wAjO+R0rAU2hI+GWzRY782y8LiAJPB5164jPn1htmQssHgnznkN5qTlS7qiQctuc0a6BiX021c9K
	/MG0XX48gAEpiUx73/CnI6Iamy3kxQYK+yfTXb9HYsoKBZX0L6sDhbn/80oiqodw==;
Received: from [189.110.51.50] (helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xPqsz-005pyo-4T; Sun, 08 Nov 2026 01:35:53 +0100
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To: linux-efi@vger.kernel.org
Cc: ardb@kernel.org,
	ilias.apalodimas@linaro.org,
	jeremy.compostella@intel.com,
	matthew.k.gumbel@intel.com,
	kernel-dev@igalia.com,
	kernel@gpiccoli.net,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>
Subject: [PATCH] efi: efibc: Optionally report panic as a reboot reason
Date: Sat,  7 Nov 2026 21:34:57 -0300
Message-ID: <20261108003549.745697-1-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.50.1
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The small efibc driver can be used to determine the cause of a reboot,
in addition to controlling bootloader behavior. Currently, this driver
reports "shutdown" or "reboot" as possible reasons for a system restart.

Add support for panic reporting, gated by a module parameter. If users
set the parameter, a panic notifier is registered and tries to save
"panic" as the reboot reason, if the kernel is configured to reboot on
panic. Note that it is a best-effort approach, relying on the nonblocking
version of the EFI variable setter.

Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---


Hi folks, this is a 2nd attempt to make the kernel notify UEFI about
a panic. The first proposal was a new (small) driver, sent here:
https://lore.kernel.org/r/20220729194532.228403-1-gpiccoli@igalia.com/

The idea is to have a simple mechanism, independent of efi-pstore (since
users could be using other pstore backends, or do not wish to collect
logs for privacy), to let UEFI know a panic happened. Using efibc seems
to be a reasonable and simple approach.

The option is gated by a parameter; this could be removed in case it's
considered unnecessary. I think a parameter is less invasive than just
changing the default.

Feedback / reviews are greatly appreciated.
Thanks in advance,

Guilherme


 drivers/firmware/efi/efibc.c | 46 ++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/efibc.c b/drivers/firmware/efi/efibc.c
index 345a10aa7086..b4014500513f 100644
--- a/drivers/firmware/efi/efibc.c
+++ b/drivers/firmware/efi/efibc.c
@@ -11,9 +11,14 @@
 #include <linux/reboot.h>
 #include <linux/slab.h>
 #include <linux/ucs2_string.h>
+#include <linux/panic_notifier.h>
 
 #define MAX_DATA_LEN	512
 
+static bool report_panic;
+module_param(report_panic, bool, 0444);
+MODULE_PARM_DESC(report_panic, "Report kernel panic as a reboot reason too (default N)");
+
 static int efibc_set_variable(efi_char16_t *name, efi_char16_t *value,
 			      unsigned long len)
 {
@@ -65,6 +70,30 @@ static struct notifier_block efibc_reboot_notifier = {
 	.notifier_call = efibc_reboot_notifier_call,
 };
 
+static int efibc_panic_notifier_call(struct notifier_block *notifier,
+				     unsigned long event, void *data)
+{
+	efi_char16_t *reason = L"panic";
+
+	/* Skip if we aren't rebooting on panic. */
+	if (!panic_timeout)
+		return NOTIFY_DONE;
+
+	efi.set_variable_nonblocking(L"LoaderEntryRebootReason",
+				&LINUX_EFI_LOADER_ENTRY_GUID,
+				EFI_VARIABLE_NON_VOLATILE
+				| EFI_VARIABLE_BOOTSERVICE_ACCESS
+				| EFI_VARIABLE_RUNTIME_ACCESS,
+				ucs2_strlen(reason) * sizeof(efi_char16_t),
+				reason);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block efibc_panic_nb = {
+	.notifier_call	= efibc_panic_notifier_call,
+	.priority	= INT_MIN,
+};
+
 static int __init efibc_init(void)
 {
 	int ret;
@@ -73,16 +102,29 @@ static int __init efibc_init(void)
 		return -ENODEV;
 
 	ret = register_reboot_notifier(&efibc_reboot_notifier);
-	if (ret)
+	if (ret) {
 		pr_err("unable to register reboot notifier\n");
+		return ret;
+	}
 
-	return ret;
+	if (report_panic && efi.set_variable_nonblocking) {
+		ret = atomic_notifier_chain_register(&panic_notifier_list,
+							&efibc_panic_nb);
+		if (ret)
+			pr_err("unable to register panic notifier\n");
+	}
+
+	return 0;
 }
 module_init(efibc_init);
 
 static void __exit efibc_exit(void)
 {
 	unregister_reboot_notifier(&efibc_reboot_notifier);
+
+	if (report_panic && efi.set_variable_nonblocking)
+		atomic_notifier_chain_unregister(&panic_notifier_list,
+							&efibc_panic_nb);
 }
 module_exit(efibc_exit);
 
-- 
2.50.1

