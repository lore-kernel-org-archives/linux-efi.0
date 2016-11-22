From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/6] efi: Add SHIM and image security database GUID
 definitions
Date: Tue, 22 Nov 2016 00:31:53 +0000
Message-ID: <147977471372.6360.8483573183028087732.stgit@warthog.procyon.org.uk>
References: <20161117123731.GA11573@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161117123731.GA11573@wunner.de>
Sender: linux-kernel-owner@vger.kernel.org
To: lukas@wunner.de
Cc: linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, Josh Boyer <jwboyer@fedoraproject.org>, keyrings@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Add the definitions for shim and image security database, both of which
are used widely in various Linux distros.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---

 include/linux/efi.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index a07a476178cd..24db4e5ec817 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -610,6 +610,9 @@ void efi_native_runtime_setup(void);
 #define EFI_CONSOLE_OUT_DEVICE_GUID		EFI_GUID(0xd3b36f2c, 0xd551, 0x11d4,  0x9a, 0x46, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
 #define APPLE_PROPERTIES_PROTOCOL_GUID		EFI_GUID(0x91bd12fe, 0xf6c3, 0x44fb,  0xa5, 0xb7, 0x51, 0x22, 0xab, 0x30, 0x3a, 0xe0)
 
+#define EFI_IMAGE_SECURITY_DATABASE_GUID	EFI_GUID(0xd719b2cb, 0x3d3a, 0x4596, 0xa3, 0xbc, 0xda, 0xd0, 0x0e, 0x67, 0x65, 0x6f)
+#define EFI_SHIM_LOCK_GUID			EFI_GUID(0x605dab50, 0xe046, 0x4300, 0xab, 0xb6, 0x3d, 0xd8, 0x10, 0xdd, 0x8b, 0x23)
+
 /*
  * This GUID is used to pass to the kernel proper the struct screen_info
  * structure that was populated by the stub based on the GOP protocol instance
