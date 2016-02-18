From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/5] efi: Use ucs2_as_utf8 in efivarfs instead of open coding a bad version
Date: Thu, 18 Feb 2016 01:36:52 -0800
Message-ID: <ADD6DD23-E809-4F38-A6FE-A61DB2CD4659@zytor.com>
References: <1455276432-9931-1-git-send-email-matt@codeblueprint.co.uk> <1455276432-9931-3-git-send-email-matt@codeblueprint.co.uk> <12473B1F-5227-4E83-BAF9-06B69CF74D77@zytor.com> <CAPeXnHuoQgrz1-_zkBKcskNE24jK2L5DSyWjbBoU+ceVzGZe0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPeXnHuoQgrz1-_zkBKcskNE24jK2L5DSyWjbBoU+ceVzGZe0Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On February 17, 2016 10:09:29 PM PST, Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org> wrote:
>If we're worried about UTF-16, the appropriate thing for us to do is
>error on seeing a surrogate pair.
>
>On Wed, Feb 17, 2016 at 9:34 PM, H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:
>> On February 12, 2016 3:27:09 AM PST, Matt Fleming
><matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
>>>From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>
>>>Translate EFI's UCS-2 variable names to UTF-8 instead of just
>assuming
>>>all variable names fit in ASCII.
>>>
>>>Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>Acked-by: Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>
>>>Tested-by: "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
>>>Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
>>>---
>>> drivers/firmware/efi/efivars.c | 30 +++++++++++-------------------
>>> fs/efivarfs/super.c            |  7 +++----
>>> 2 files changed, 14 insertions(+), 23 deletions(-)
>>>
>>>diff --git a/drivers/firmware/efi/efivars.c
>>>b/drivers/firmware/efi/efivars.c
>>>index 756eca8c4cf8..f4ff8abc5f3e 100644
>>>--- a/drivers/firmware/efi/efivars.c
>>>+++ b/drivers/firmware/efi/efivars.c
>>>@@ -540,38 +540,30 @@ static ssize_t efivar_delete(struct file *filp,
>>>struct kobject *kobj,
>>> static int
>>> efivar_create_sysfs_entry(struct efivar_entry *new_var)
>>> {
>>>-      int i, short_name_size;
>>>+      int short_name_size;
>>>       char *short_name;
>>>-      unsigned long variable_name_size;
>>>-      efi_char16_t *variable_name;
>>>+      unsigned long utf8_name_size;
>>>+      efi_char16_t *variable_name = new_var->var.VariableName;
>>>       int ret;
>>>
>>>-      variable_name = new_var->var.VariableName;
>>>-      variable_name_size = ucs2_strlen(variable_name) *
>>>sizeof(efi_char16_t);
>>>-
>>>       /*
>>>-       * Length of the variable bytes in ASCII, plus the '-'
>separator,
>>>+       * Length of the variable bytes in UTF8, plus the '-'
>separator,
>>>        * plus the GUID, plus trailing NUL
>>>        */
>>>-      short_name_size = variable_name_size / sizeof(efi_char16_t)
>>>-                              + 1 + EFI_VARIABLE_GUID_LEN + 1;
>>>-
>>>-      short_name = kzalloc(short_name_size, GFP_KERNEL);
>>>+      utf8_name_size = ucs2_utf8size(variable_name);
>>>+      short_name_size = utf8_name_size + 1 + EFI_VARIABLE_GUID_LEN +
>1;
>>>
>>>+      short_name = kmalloc(short_name_size, GFP_KERNEL);
>>>       if (!short_name)
>>>               return -ENOMEM;
>>>
>>>-      /* Convert Unicode to normal chars (assume top bits are 0),
>>>-         ala UTF-8 */
>>>-      for (i=0; i < (int)(variable_name_size /
>sizeof(efi_char16_t)); i++)
>>>{
>>>-              short_name[i] = variable_name[i] & 0xFF;
>>>-      }
>>>+      ucs2_as_utf8(short_name, variable_name, short_name_size);
>>>+
>>>       /* This is ugly, but necessary to separate one vendor's
>>>          private variables from another's.         */
>>>-
>>>-      *(short_name + strlen(short_name)) = '-';
>>>+      short_name[utf8_name_size] = '-';
>>>       efi_guid_to_str(&new_var->var.VendorGuid,
>>>-                       short_name + strlen(short_name));
>>>+                       short_name + utf8_name_size + 1);
>>>
>>>       new_var->kobj.kset = efivars_kset;
>>>
>>>diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
>>>index b8a564f29107..8651ac28ec0d 100644
>>>--- a/fs/efivarfs/super.c
>>>+++ b/fs/efivarfs/super.c
>>>@@ -118,7 +118,7 @@ static int efivarfs_callback(efi_char16_t
>*name16,
>>>efi_guid_t vendor,
>>>       struct dentry *dentry, *root = sb->s_root;
>>>       unsigned long size = 0;
>>>       char *name;
>>>-      int len, i;
>>>+      int len;
>>>       int err = -ENOMEM;
>>>
>>>       entry = kzalloc(sizeof(*entry), GFP_KERNEL);
>>>@@ -128,15 +128,14 @@ static int efivarfs_callback(efi_char16_t
>>>*name16, efi_guid_t vendor,
>>>       memcpy(entry->var.VariableName, name16, name_size);
>>>       memcpy(&(entry->var.VendorGuid), &vendor, sizeof(efi_guid_t));
>>>
>>>-      len = ucs2_strlen(entry->var.VariableName);
>>>+      len = ucs2_utf8size(entry->var.VariableName);
>>>
>>>       /* name, plus '-', plus GUID, plus NUL*/
>>>       name = kmalloc(len + 1 + EFI_VARIABLE_GUID_LEN + 1,
>GFP_KERNEL);
>>>       if (!name)
>>>               goto fail;
>>>
>>>-      for (i = 0; i < len; i++)
>>>-              name[i] = entry->var.VariableName[i] & 0xFF;
>>>+      ucs2_as_utf8(name, entry->var.VariableName, len);
>>>
>>>       name[len] = '-';
>>>
>>
>> However, I think we should treat this "ucs2" as utf16, because sooner
>or later someone will enter utf16 characters.
>> --
>> Sent from my Android device with K-9 Mail. Please excuse brevity and
>formatting.

Error how?  Now you're making something in EFI memory inaccessible for no good reason.  Most likely utf16 works just fine except when being displayed on the EFI console.
-- 
Sent from my Android device with K-9 Mail. Please excuse brevity and formatting.
