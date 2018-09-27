From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 05/11] efi/efi_test: add exporting ResetSystem runtime service
Date: Thu, 27 Sep 2018 10:50:32 +0200
Message-ID: <20180927085039.8391-6-ard.biesheuvel@linaro.org>
References: <20180927085039.8391-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927085039.8391-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Aaron Ma <aaron.ma@canonical.com>, Alistair Strachan <astrachan@google.com>, Ben Hutchings <ben@decadent.org.uk>, Bhupesh Sharma <bhsharma@redhat.com>, Hans de Goede <hdegoede@redhat.com>, Ivan Hu <ivan.hu@canonical.com>, Jeremy Linton <jeremy.linton@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Robinson <pbrobinson@redhat.com>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Stefan Agner <stefan@agner.ch>
List-Id: linux-efi@vger.kernel.org

From: Ivan Hu <ivan.hu@canonical.com>

Add exporting the UEFI runtime service ResetSystem for upper application or test
tools to use.

Signed-off-by: Ivan Hu <ivan.hu@canonical.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/test/efi_test.c | 27 +++++++++++++++++++++++++++
 drivers/firmware/efi/test/efi_test.h | 10 ++++++++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/firmware/efi/test/efi_test.c b/drivers/firmware/efi/test/efi_test.c
index 41c48a1e8baa..769640940c9f 100644
--- a/drivers/firmware/efi/test/efi_test.c
+++ b/drivers/firmware/efi/test/efi_test.c
@@ -542,6 +542,30 @@ static long efi_runtime_get_nexthighmonocount(unsigned long arg)
 	return 0;
 }
 
+static long efi_runtime_reset_system(unsigned long arg)
+{
+	struct efi_resetsystem __user *resetsystem_user;
+	struct efi_resetsystem resetsystem;
+	void *data = NULL;
+
+	resetsystem_user = (struct efi_resetsystem __user *)arg;
+	if (copy_from_user(&resetsystem, resetsystem_user,
+						sizeof(resetsystem)))
+		return -EFAULT;
+	if (resetsystem.data_size != 0) {
+		data = memdup_user((void *)resetsystem.data,
+						resetsystem.data_size);
+		if (IS_ERR(data))
+			return PTR_ERR(data);
+	}
+
+	efi.reset_system(resetsystem.reset_type, resetsystem.status,
+				resetsystem.data_size, (efi_char16_t *)data);
+
+	kfree(data);
+	return 0;
+}
+
 static long efi_runtime_query_variableinfo(unsigned long arg)
 {
 	struct efi_queryvariableinfo __user *queryvariableinfo_user;
@@ -682,6 +706,9 @@ static long efi_test_ioctl(struct file *file, unsigned int cmd,
 
 	case EFI_RUNTIME_QUERY_CAPSULECAPABILITIES:
 		return efi_runtime_query_capsulecaps(arg);
+
+	case EFI_RUNTIME_RESET_SYSTEM:
+		return efi_runtime_reset_system(arg);
 	}
 
 	return -ENOTTY;
diff --git a/drivers/firmware/efi/test/efi_test.h b/drivers/firmware/efi/test/efi_test.h
index 9812c6a02b40..5f4818bf112f 100644
--- a/drivers/firmware/efi/test/efi_test.h
+++ b/drivers/firmware/efi/test/efi_test.h
@@ -81,6 +81,13 @@ struct efi_querycapsulecapabilities {
 	efi_status_t		*status;
 } __packed;
 
+struct efi_resetsystem {
+	int			reset_type;
+	efi_status_t		status;
+	unsigned long		data_size;
+	efi_char16_t		*data;
+} __packed;
+
 #define EFI_RUNTIME_GET_VARIABLE \
 	_IOWR('p', 0x01, struct efi_getvariable)
 #define EFI_RUNTIME_SET_VARIABLE \
@@ -108,4 +115,7 @@ struct efi_querycapsulecapabilities {
 #define EFI_RUNTIME_QUERY_CAPSULECAPABILITIES \
 	_IOR('p', 0x0A, struct efi_querycapsulecapabilities)
 
+#define EFI_RUNTIME_RESET_SYSTEM \
+	_IOW('p', 0x0B, struct efi_resetsystem)
+
 #endif /* _DRIVERS_FIRMWARE_EFI_TEST_H_ */
-- 
2.18.0
