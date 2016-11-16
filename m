From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/16] efi: Disable secure boot if shim is in insecure mode
Date: Wed, 16 Nov 2016 21:47:38 +0000
Message-ID: <147933285855.19316.13896885410459473517.stgit@warthog.procyon.org.uk>
References: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: keyrings@vger.kernel.org
Cc: matthew.garrett@nebula.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, Josh Boyer <jwboyer@fedoraproject.org>
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

 arch/x86/boot/compressed/eboot.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 17b376596c96..2729a3844673 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -540,8 +540,9 @@ static void setup_efi_pci(struct boot_params *params)
 
 static int get_secure_boot(void)
 {
-	u8 sb, setup;
+	u8 sb, setup, moksbstate;
 	unsigned long datasize = sizeof(sb);
+	u32 attr;
 	efi_guid_t var_guid = EFI_GLOBAL_VARIABLE_GUID;
 	efi_status_t status;
 
@@ -565,6 +566,23 @@ static int get_secure_boot(void)
 	if (setup == 1)
 		return 0;
 
+	/* See if a user has put shim into insecure_mode.  If so, and the variable
+	 * doesn't have the runtime attribute set, we might as well honor that.
+	 */
+	var_guid = EFI_SHIM_LOCK_GUID;
+	status = efi_early->call((unsigned long)sys_table->runtime->get_variable,
+				L"MokSBState", &var_guid, &attr, &datasize,
+				&moksbstate);
+
+	/* If it fails, we don't care why.  Default to secure */
+	if (status != EFI_SUCCESS)
+		return 1;
+
+	if (!(attr & EFI_VARIABLE_RUNTIME_ACCESS)) {
+		if (moksbstate == 1)
+			return 0;
+	}
+
 	return 1;
 }
 

