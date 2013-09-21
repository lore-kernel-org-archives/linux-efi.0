From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 09/17] Move unicode to ASCII conversion to shared function.
Date: Sat, 21 Sep 2013 14:31:37 -0700
Message-ID: <CAFECyb-HQp2Tbcdcg3U1TSHR7_gDjLiJMrBuiQNdbmin1=_H-g@mail.gmail.com>
References: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
	<1379391093-27948-10-git-send-email-roy.franz@linaro.org>
	<20130919034406.GA26385@angband.pl>
	<CAFECyb-tTaCEqUHUh23MaJf-P42ZpodFKeNG=kE+vmmi-gyKrw@mail.gmail.com>
	<20130920092713.GD4785@console-pimps.org>
	<523C62FC.8010907@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <523C62FC.8010907-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Adam Borowski <kilobyte-b9QjgO8OEXPVItvQsEIGlw@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Sep 20, 2013 at 8:00 AM, H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:
> On 09/20/2013 04:27 AM, Matt Fleming wrote:
>> On Wed, 18 Sep, at 09:48:44PM, Roy Franz wrote:
>>> Would it be acceptable to fix the naming/comments, and convert values
>>> above 126 to '?'
>>> in the current patchset, and address a more thorough fix in another patch set?
>>> The ARM and ARM64 EFI stub patchsets that are mostly complete depend
>>> on this one,
>>> so getting this merged soon would be helpful.
>>
>> Just fixing the function name and comments is enough for this patch
>> series. Anything else should be separate.
>>
>
> I just whipped up a patch to do proper UTF-16 to UTF-8 conversion.
> Completely untested, of course.
>
>         -hpa
>

Thanks for putting this together.  I fixed up a few minor issues,
and it works.  Updated version below.  I'll submit this as a separate patch
as part of the EFI stub common code series.

Roy


commit 827285bac3daa79cd562bf79b5e9e88a61d357be
Author: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Date:   Fri Sep 20 12:46:16 2013 -0700

    Do proper conversion from UTF-16 to UTF-8

    Improve the conversion of the UTF-16 EFI command line
    to UTF-8 for passing to the kernel.

    Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 5e708c0..4723dc89 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -486,8 +486,7 @@ struct boot_params *make_boot_params(void *handle,
efi_system_table_t *_table)
  hdr->type_of_loader = 0x21;

  /* Convert unicode cmdline to ascii */
- cmdline_ptr = efi_convert_cmdline_to_ascii(sys_table, image,
-   &options_size);
+ cmdline_ptr = efi_convert_cmdline(sys_table, image, &options_size);
  if (!cmdline_ptr)
  goto fail;
  hdr->cmd_line_ptr = (unsigned long)cmdline_ptr;
diff --git a/drivers/firmware/efi/efi-stub-helper.c
b/drivers/firmware/efi/efi-stub-helper.c
index 335d17d..8a3ab4b 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -548,61 +548,112 @@ static efi_status_t
efi_relocate_kernel(efi_system_table_t *sys_table_arg,

  return status;
 }
-/* Convert the unicode UEFI command line to ASCII to pass to kernel.
+
+/*
+ * Get the number of UTF-8 bytes corresponding to an UTF-16 character.
+ * This overestimates for surrogates, but that is okay.
+ */
+static int efi_utf8_bytes(u16 c)
+{
+ return 1 + (c >= 0x80) + (c >= 0x800);
+}
+
+/*
+ * Convert an UTF-16 string, not necessarily null terminated, to UTF-8.
+ */
+static u8 *efi_utf16_to_utf8(u8 *dst, const u16 *src, int n)
+{
+ unsigned int c;
+
+ while (n--) {
+ c = *src++;
+ if (n && c >= 0xd800 && c <= 0xdbff &&
+    *src >= 0xdc00 && *src <= 0xdfff) {
+ c = 0x10000 + ((c & 0x3ff) << 10) + (*src & 0x3ff);
+ src++;
+ n--;
+ }
+ if (c >= 0xd800 && c <= 0xdfff)
+ c = 0xfffd; /* Unmatched surrogate */
+ if (c < 0x80) {
+ *dst++ = c;
+ continue;
+ }
+ if (c < 0x800) {
+ *dst++ = 0xc0 + (c >> 6);
+ goto t1;
+ }
+ if (c < 0x10000) {
+ *dst++ = 0xe0 + (c >> 12);
+ goto t2;
+ }
+ *dst++ = 0xf0 + (c >> 18);
+ *dst++ = 0x80 + ((c >> 12) & 0x3f);
+ t2:
+ *dst++ = 0x80 + ((c >> 6) & 0x3f);
+ t1:
+ *dst++ = 0x80 + (c & 0x3f);
+ }
+
+ return dst;
+}
+
+/*
+ * Convert the unicode UEFI command line to ASCII to pass to kernel.
  * Size of memory allocated return in *cmd_line_len.
  * Returns NULL on error.
  */
-static char *efi_convert_cmdline_to_ascii(efi_system_table_t *sys_table_arg,
-      efi_loaded_image_t *image,
-      int *cmd_line_len)
+static char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
+ efi_loaded_image_t *image,
+ int *cmd_line_len)
 {
- u16 *s2;
+ const u16 *s2;
  u8 *s1 = NULL;
  unsigned long cmdline_addr = 0;
  int load_options_size = image->load_options_size / 2; /* ASCII */
- void *options = image->load_options;
- int options_size = 0;
+ const u16 *options = image->load_options;
+ int options_bytes = 0; /* UTF-8 bytes */
+ int options_chars = 0; /* UTF-16 chars */
  efi_status_t status;
  int i;
  u16 zero = 0;

  if (options) {
  s2 = options;
- while (*s2 && *s2 != '\n' && options_size < load_options_size) {
+ while (*s2 && *s2 != '\n' && options_bytes < load_options_size) {
+ options_bytes += efi_utf8_bytes(*s2);
  s2++;
- options_size++;
  }
+ options_chars = s2 - options;
  }

- if (options_size == 0) {
- /* No command line options, so return empty string*/
- options_size = 1;
+ if (!options_chars) {
+ /* No command line options, so return empty string */
  options = &zero;
  }

- options_size++;  /* NUL termination */
+ options_bytes++; /* NUL termination */
+
 #ifdef CONFIG_ARM
  /* For ARM, allocate at a high address to avoid reserved
  * regions at low addresses that we don't know the specfics of
  * at the time we are processing the command line.
  */
- status = efi_high_alloc(sys_table_arg, options_size, 0,
+ status = efi_high_alloc(sys_table_arg, options_bytes, 0,
     &cmdline_addr, 0xfffff000);
 #else
- status = efi_low_alloc(sys_table_arg, options_size, 0,
+ status = efi_low_alloc(sys_table_arg, options_bytes, 0,
     &cmdline_addr);
 #endif
  if (status != EFI_SUCCESS)
  return NULL;

  s1 = (u8 *)cmdline_addr;
- s2 = (u16 *)options;
-
- for (i = 0; i < options_size - 1; i++)
- *s1++ = *s2++;
+ s2 = (const u16 *)options;

+ s1 = efi_utf16_to_utf8(s1, s2, options_chars);
  *s1 = '\0';

- *cmd_line_len = options_size;
+ *cmd_line_len = options_bytes;
  return (char *)cmdline_addr;
 }
