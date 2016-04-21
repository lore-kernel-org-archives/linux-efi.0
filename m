From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] lib: Always NUL terminate ucs2_as_utf8
Date: Thu, 21 Apr 2016 13:18:27 +0100
Message-ID: <20160421121827.GE2829@codeblueprint.co.uk>
References: <1461141427-16361-1-git-send-email-chris@chris-wilson.co.uk>
 <5717834C.6070802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5717834C.6070802-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Jason Andryuk <jandryuk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

( Good Lord, I hate doing string manipulation in C )

On Wed, 20 Apr, at 03:25:32PM, Laszlo Ersek wrote:
> 
> So, "len" does not include the room for the terminating NUL-byte here.
> When "len" is passed to ucs2_as_utf8(), with the proposed patch applied,
> a NUL byte will be produced in "name", but it will be at the price of a
> genuine character from the input variable name.

Right, and this is a problem because we're trying to keep the names
consistent between efivarfs and the EFI variable data. Force
NUL-terminating the string is wrong, because if you have no room for
the NUL the caller should check for that. Sadly none do.

On the flip-side, passing around non-NUL terminated strings is just
begging for these kinds of issues to come up.

The fact is that the callers of ucs2_as_utf8() are passing it the
wrong 'len' argument. We want a NUL-terminated utf8 string and we're
passing a NUL-terminated ucs2 string. We should tell ucs2_as_utf8() it
has enough room to copy the NUL.

Wouldn't this work (minus the return value checking)?

---

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 0ac594c0a234..13a837c70e90 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -235,13 +235,12 @@ efivar_validate(efi_guid_t vendor, efi_char16_t *var_name, u8 *data,
 	unsigned long utf8_size;
 	u8 *utf8_name;
 
-	utf8_size = ucs2_utf8size(var_name);
-	utf8_name = kmalloc(utf8_size + 1, GFP_KERNEL);
+	utf8_size = ucs2_utf8size(var_name) + 1;
+	utf8_name = kmalloc(utf8_size, GFP_KERNEL);
 	if (!utf8_name)
 		return false;
 
 	ucs2_as_utf8(utf8_name, var_name, utf8_size);
-	utf8_name[utf8_size] = '\0';
 
 	for (i = 0; variable_validate[i].name[0] != '\0'; i++) {
 		const char *name = variable_validate[i].name;
@@ -250,7 +249,7 @@ efivar_validate(efi_guid_t vendor, efi_char16_t *var_name, u8 *data,
 		if (efi_guidcmp(vendor, variable_validate[i].vendor))
 			continue;
 
-		if (variable_matches(utf8_name, utf8_size+1, name, &match)) {
+		if (variable_matches(utf8_name, utf8_size, name, &match)) {
 			if (variable_validate[i].validate == NULL)
 				break;
 			kfree(utf8_name);
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index dd029d13ea61..be5a02721b41 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -136,7 +136,7 @@ static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
 	if (!name)
 		goto fail;
 
-	ucs2_as_utf8(name, entry->var.VariableName, len);
+	ucs2_as_utf8(name, entry->var.VariableName, len + 1);
 
 	if (efivar_variable_is_removable(entry->var.VendorGuid, name, len))
 		is_removable = true;
