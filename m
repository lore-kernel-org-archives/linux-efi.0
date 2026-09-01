Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29F5A48423C;
	Tue,  1 Sep 2026 16:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788281853; cv=none; b=kPcSCXk0YJAdb6+yzFA/Kmm8Kn7vFoPuMQnIrG2+JmExwfXyLsCRmUpPTEqW08IAMyZ/2Ffk947La3ILiXfDkkFZ09msRd+y64XsgKEVsz7qtqBsxv81/QaRwI1jLyEIxeTaAqsoBOmhDtUh/uXPZwNimtByUoHqS5Lf9uFhYC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788281853; c=relaxed/simple;
	bh=UC7muPYjZo5J/xb153yhcYG5E3DgOZ0no9RdPqpZqWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGuKviewYsvgNQX2vCU5a477B9NU3AqCgM7ZVxLBvtvTQmcU/KpNy6G28sTXOI9ndwaVFliA8PD9ZwuDzJsYTdLaSYMKLVVnQXDG7tZ81IZ5k4xUlKiPNvcGZST5F8n+OvnDHf6rrKKURRfoD1k+FhlTbOVGzJhay9pSVm3uInE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=jDDXZ2IT; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="jDDXZ2IT"
Received: by linux.microsoft.com (Postfix, from userid 1130)
	id D85B220B712D; Tue,  1 Sep 2026 09:56:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D85B220B712D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1788281814;
	bh=NvO9e9mumccyws0coxVvMyj99Z4bKsTR9JTNrI1NFvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDDXZ2ITtpv5GYabGjv77s2J+7jYX73uPwezcaV7C8n6uEPdA9GC75QX2k+VZ2sXN
	 c1izd+301KjNhG3IE0qHtaBnxSts2Xg8ROPnZ3RP4F1/qKRSejLsdIaNPPGcLhZKTP
	 XypXtOuRBisuZ1imEByU0P7ZDCUqdhK9G/ZzQtsc=
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
Subject: [RFC PATCH 04/12] firmware: efi: libstub: x86-stub: Enable VSM awareness in efi os indications variable
Date: Tue,  1 Sep 2026 09:55:18 -0700
Message-ID: <20260901165647.3160413-5-tgopinath@linux.microsoft.com>
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

Set bit 0 of the Hyper-V private OsLoaderIndications EFI variable
during exit_boot() so the bootloader/firmware knows the OS intends
to enable VTL1. Without this, VTL1 cannot be brought up from the
Linux kernel.

The support bit is first checked in OsLoaderIndicationsSupported,
and the variable is only written when the VSM bit is not already
set.

Signed-off-by: Thara Gopinath <tgopinath@linux.microsoft.com>
---
 drivers/firmware/efi/libstub/x86-stub.c | 57 +++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index cef32e2c82d8f..ab3cd4fe36599 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -21,6 +21,17 @@
 #include "efistub.h"
 #include "x86-stub.h"
 
+#ifdef CONFIG_HYPERV_VSM
+#define HYPERV_PRIVATE_EFI_NAMESPACE_GUID \
+	EFI_GUID(0x610b9e98, 0xc6f6, 0x47f8, 0x8b, 0x47, 0x2d, 0x2d, 0xa0, 0xd5, 0x2a, 0x91)
+
+static const efi_char16_t efi_HvPrivOsloaderIndications_name[] = L"OsLoaderIndications";
+static const efi_char16_t efi_HvPrivOsloaderIndicationsSupported_name[] =
+	L"OsLoaderIndicationsSupported";
+#define HV_OSLOADER_INDICATION_VSM  BIT(0)
+
+#endif
+
 extern char _bss[], _ebss[];
 
 const efi_system_table_t *efi_system_table;
@@ -754,6 +765,47 @@ static efi_status_t exit_boot_func(struct efi_boot_memmap *map,
 	return EFI_SUCCESS;
 }
 
+#ifdef CONFIG_HYPERV_VSM
+static void efi_set_hv_os_indications(void)
+{
+	efi_guid_t guid = HYPERV_PRIVATE_EFI_NAMESPACE_GUID;
+	efi_status_t status;
+	unsigned long size;
+	u32 attr, val;
+
+	size = sizeof(val);
+	status = get_efi_var(efi_HvPrivOsloaderIndicationsSupported_name,
+			     &guid, &attr, &size, &val);
+	if (status != EFI_SUCCESS) {
+		efi_err("Could not read Hyper-V OsloaderIndicationsSupported\n");
+		return;
+	}
+
+	if (!(val & HV_OSLOADER_INDICATION_VSM)) {
+		efi_info("Hyper-V does not support VSM in OsloaderIndicationsSupported\n");
+		return;
+	}
+
+	size = sizeof(val);
+	status = get_efi_var(efi_HvPrivOsloaderIndications_name, &guid, &attr, &size, &val);
+	if (status != EFI_SUCCESS) {
+		efi_err("Could not read Hyper-V OsLoaderIndications\n");
+		return;
+	}
+
+	if (val & HV_OSLOADER_INDICATION_VSM) {
+		efi_info("VSM is already supported in OsLoaderIndications.");
+		return;
+	}
+
+	val |= HV_OSLOADER_INDICATION_VSM;
+	size = sizeof(val);
+	status = set_efi_var(efi_HvPrivOsloaderIndications_name, &guid, attr, size, &val);
+	if (status != EFI_SUCCESS)
+		efi_err("Could not set Hyper-V OsLoaderIndications to indicate VSM support\n");
+}
+#endif
+
 static efi_status_t exit_boot(struct boot_params *boot_params, void *handle)
 {
 	struct setup_data *e820ext = NULL;
@@ -768,6 +820,11 @@ static efi_status_t exit_boot(struct boot_params *boot_params, void *handle)
 	if (status != EFI_SUCCESS)
 		return status;
 
+#ifdef CONFIG_HYPERV_VSM
+	/* Indicate to bootloader that we will be enabling VTL1 before exiting boot services */
+	efi_set_hv_os_indications();
+#endif
+
 	/* Might as well exit boot services now */
 	status = efi_exit_boot_services(handle, &priv, exit_boot_func);
 	if (status != EFI_SUCCESS)
-- 
2.34.1

