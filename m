From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/6] efi: Disable secure boot if shim is in insecure mode
Date: Tue, 22 Nov 2016 00:32:08 +0000
Message-ID: <147977472850.6360.6174897435078432354.stgit@warthog.procyon.org.uk>
References: <20161117123731.GA11573@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161117123731.GA11573@wunner.de>
Sender: linux-kernel-owner@vger.kernel.org
To: lukas@wunner.de
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, Josh Boyer <jwboyer@fedoraproject.org>, keyrings@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Josh Boyer <jwboyer@fedoraproject.org>

A user can manually tell the shim boot loader to disable validation of
images it loads.  When a user does this, it creates a UEFI variable called
MokSBState that does not have the runtime attribute set.  Given that the
user explicitly disabled validation, we can honor that and not enable
secure boot mode if that variable is set.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/firmware/efi/libstub/secureboot.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
index e44d8c9ee150..d928398a3a52 100644
--- a/drivers/firmware/efi/libstub/secureboot.c
+++ b/drivers/firmware/efi/libstub/secureboot.c
@@ -23,10 +23,14 @@ int efi_get_secureboot(void)
 		'S', 'e', 'c', 'u', 'r', 'e', 'B', 'o', 'o', 't', 0 };
 	static const efi_char16_t const sm_var_name[] = {
 		'S', 'e', 't', 'u', 'p', 'M', 'o', 'd', 'e', 0 };
+	static efi_char16_t const MokSBState_var_name[] = {
+		'M', 'o', 'k', 'S', 'B', 'S', 't', 'a', 't', 'e', 0 };
 
 	static const efi_guid_t var_guid = EFI_GLOBAL_VARIABLE_GUID;
+	static const efi_guid_t shim_guid = EFI_SHIM_LOCK_GUID;
 
-	u8 val;
+	u32 attr;
+	u8 val, moksbstate;
 	unsigned long size = sizeof(val);
 	efi_status_t status;
 
@@ -50,6 +54,22 @@ int efi_get_secureboot(void)
 	if (val == 1)
 		return 0;
 
+	/* See if a user has put shim into insecure mode.  If so, and if the
+	 * variable doesn't have the runtime attribute set, we might as well
+	 * honor that.
+	 */
+	size = sizeof(moksbstate);
+	status = f_getvar((efi_char16_t *)MokSBState_var_name, &shim_guid,
+			  &attr, &size, &moksbstate);
+
+	/* If it fails, we don't care why.  Default to secure */
+	if (status != EFI_SUCCESS)
+		return 1;
+
+	if (!(attr & EFI_VARIABLE_RUNTIME_ACCESS) &&
+	    moksbstate == 1)
+		return 0;
+
 	return 1;
 
 out_efi_err:
