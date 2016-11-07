From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 0/2] Honey, I shrunk the EFI stub
Date: Mon, 7 Nov 2016 12:17:00 +0100
Message-ID: <cover.1478510356.git.lukas@wunner.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Demonstrate the code reduction attainable by efi_call_proto()
which was proffered in a patch I've posted a few minutes ago.

For this to work, all three protocol variants (_32_t and _64_t for x86
and _t for ARM) need to be declared as typedefs.  The declaration and
naming of protocols in include/linux/efi.h currently isn't consistent,
some are declared as typedefs and some aren't, some use a "_t" suffix
and some don't.  These inconsistencies need to be straightened out
when converting to efi_call_proto().  It should be noted that checkpatch
complains about newly introduced typedefs.  It would be possible to
retool efi_call_proto() to work without typedef declarations as long
as it's done consistently.

In __file_size32() all protocol calls are currently cast to unsigned long,
which is 64 bit when compiled on x86_64.  Matt has said that the register
needs to be loaded with a 32 bit address, so it looks to me like this is
currently broken for mixed-mode.  Patch [1/2] should fix this.  E.g.:

	efi_file_handle_32_t *h, *fh = __fh;
[...]
	status = efi_early->call((unsigned long)h->get_info, h, &info_guid,
				 &info_sz, NULL);

Another oddity is that info_sz is declared u32 in __file_size32(),
yet the spec says that the third argument to EFI_FILE_PROTOCOL.GetInfo()
is of type UINTN, which I assume is 64 bit regardless of mixed-mode,
or am I missing something?  Patch [1/2] uses an unsigned long instead.

Thanks,

Lukas


Lukas Wunner (2):
  efi: Deduplicate efi_file_size() / _read() / _close()
  x86/efi: Deduplicate efi_char16_printk()

 arch/x86/boot/compressed/eboot.c               | 174 +------------------------
 drivers/firmware/efi/libstub/arm-stub.c        |  69 ----------
 drivers/firmware/efi/libstub/efi-stub-helper.c |  63 +++++++++
 drivers/firmware/efi/libstub/efistub.h         |   8 --
 include/linux/efi.h                            |   8 +-
 5 files changed, 69 insertions(+), 253 deletions(-)

-- 
2.10.1
