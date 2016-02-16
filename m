From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 1/2] efi: Add pstore variables to the deletion whitelist
Date: Tue, 16 Feb 2016 12:59:19 +0000
Message-ID: <1455627560-10576-2-git-send-email-matt@codeblueprint.co.uk>
References: <1455627560-10576-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455627560-10576-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>, "Lee, Chun-Yi" <jlee@suse.com>, Laszlo Ersek <lersek@redhat.com>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

Laszlo explains why this is a good idea,

 'This is because the pstore filesystem can be backed by UEFI variables,
  and (for example) a crash might dump the last kilobytes of the dmesg
  into a number of pstore entries, each entry backed by a separate UEFI
  variable in the above GUID namespace, and with a variable name
  according to the above pattern.

  Please see "drivers/firmware/efi/efi-pstore.c".

  While this patch series will not prevent the user from deleting those
  UEFI variables via the pstore filesystem (i.e., deleting a pstore fs
  entry will continue to delete the backing UEFI variable), I think it
  would be nice to preserve the possibility for the sysadmin to delete
  Linux-created UEFI variables that carry portions of the crash log,
  *without* having to mount the pstore filesystem.'

There's also no chance of causing machines to become bricked by
deleting these variables, which is the whole purpose of excluding
things from the whitelist.

Use the LINUX_EFI_CRASH_GUID guid and a wildcard '*' for the match so
that we don't have to update the string in the future if new variable
name formats are created for crash dump variables.

Reported-by: Laszlo Ersek <lersek@redhat.com>
Acked-by: Peter Jones <pjones@redhat.com>
Tested-by: Peter Jones <pjones@redhat.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Lee, Chun-Yi" <jlee@suse.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/vars.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 50f10bad2604..7f2ea21c730d 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -198,6 +198,7 @@ static const struct variable_validate variable_validate[] = {
 	{ EFI_GLOBAL_VARIABLE_GUID, "OsIndications", NULL },
 	{ EFI_GLOBAL_VARIABLE_GUID, "PlatformLang", validate_ascii_string },
 	{ EFI_GLOBAL_VARIABLE_GUID, "Timeout", validate_uint16 },
+	{ LINUX_EFI_CRASH_GUID, "*", NULL },
 	{ NULL_GUID, "", NULL },
 };
 
-- 
2.6.2
