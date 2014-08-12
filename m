From: David Michael <fedora.dm0-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Default initrd path with the EFI stub
Date: Tue, 12 Aug 2014 19:49:28 -0400
Message-ID: <87oavpp8tz.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

---
Hi,

I'd like to specify a default initrd path for the EFI stub at compile
time.  Is there a way to do this?

I got it to successfully load an initrd by setting the parameter in
CONFIG_CMDLINE with this proof-of-concept patch on 3.16.  (This patch is
against the efi tree's next branch.)  If the EFI stub doesn't currently
support this functionality, I'd appreciate it if something like this
could be applied.

Thanks.

David

 drivers/firmware/efi/libstub/efi-stub-helper.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index a920fec..eac30dc 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -675,6 +675,10 @@ char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
 
 	options_bytes++;	/* NUL termination */
 
+#ifdef CONFIG_CMDLINE
+	options_bytes += sizeof(CONFIG_CMDLINE);
+#endif
+
 	status = efi_low_alloc(sys_table_arg, options_bytes, 0, &cmdline_addr);
 	if (status != EFI_SUCCESS)
 		return NULL;
@@ -682,6 +686,11 @@ char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
 	s1 = (u8 *)cmdline_addr;
 	s2 = (const u16 *)options;
 
+#ifdef CONFIG_CMDLINE
+	memcpy((void *)s1, CONFIG_CMDLINE " ", sizeof(CONFIG_CMDLINE));
+	s1 += sizeof(CONFIG_CMDLINE);
+#endif
+
 	s1 = efi_utf16_to_utf8(s1, s2, options_chars);
 	*s1 = '\0';
 
-- 
1.9.3
