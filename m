From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/6] efi: Disable secure boot if shim is in insecure mode
 [ver #2]
Date: Wed, 23 Nov 2016 00:23:04 +0000
Message-ID: <147986058486.13790.8455439853105793460.stgit@warthog.procyon.org.uk>
References: <147986054870.13790.8640536414645705863.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <147986054870.13790.8640536414645705863.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
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

 drivers/firmware/efi/libstub/secureboot.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
index 466fe24f5866..ca643eba5a4b 100644
--- a/drivers/firmware/efi/libstub/secureboot.c
+++ b/drivers/firmware/efi/libstub/secureboot.c
@@ -23,6 +23,12 @@ static const efi_char16_t const efi_SetupMode_name[] = {
 	'S', 'e', 't', 'u', 'p', 'M', 'o', 'd', 'e', 0
 };
 
+/* SHIM variables */
+static const efi_guid_t shim_guid = EFI_SHIM_LOCK_GUID;
+static efi_char16_t const shim_MokSBState_name[] = {
+	'M', 'o', 'k', 'S', 'B', 'S', 't', 'a', 't', 'e', 0
+};
+
 #define get_efi_var(name, vendor, ...) \
 	efi_call_runtime(get_variable, \
 			 (efi_char16_t *)(name), (efi_guid_t *)(vendor), \
@@ -33,7 +39,8 @@ static const efi_char16_t const efi_SetupMode_name[] = {
  */
 int efi_get_secureboot(efi_system_table_t *sys_table_arg)
 {
-	u8 val;
+	u32 attr;
+	u8 val, moksbstate;
 	unsigned long size = sizeof(val);
 	efi_status_t status;
 
@@ -55,6 +62,21 @@ int efi_get_secureboot(efi_system_table_t *sys_table_arg)
 	if (val == 1)
 		return 0;
 
+	/* See if a user has put shim into insecure mode.  If so, and if the
+	 * variable doesn't have the runtime attribute set, we might as well
+	 * honor that.
+	 */
+	size = sizeof(moksbstate);
+	status = get_efi_var(shim_MokSBState_name, &shim_guid,
+			     &attr, &size, &moksbstate);
+
+	/* If it fails, we don't care why.  Default to secure */
+	if (status != EFI_SUCCESS)
+		return 1;
+
+	if (!(attr & EFI_VARIABLE_RUNTIME_ACCESS) && moksbstate == 1)
+		return 0;
+
 	return 1;
 
 out_efi_err:

