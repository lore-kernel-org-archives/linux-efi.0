From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 3/5] x86/efi: Disable runtime services on kexec kernel if booted with efi=old_map
Date: Fri, 26 May 2017 12:36:49 +0100
Message-ID: <20170526113652.21339-4-matt@codeblueprint.co.uk>
References: <20170526113652.21339-1-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170526113652.21339-1-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lee Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Booting kexec kernel with "efi=old_map" in kernel command line hits
kernel panic as shown below.

 BUG: unable to handle kernel paging request at ffff88007fe78070
 IP: virt_efi_set_variable.part.7+0x63/0x1b0
 PGD 7ea28067
 PUD 7ea2b067
 PMD 7ea2d067
 PTE 0
 [...]
 Call Trace:
  virt_efi_set_variable+0x5d/0x70
  efi_delete_dummy_variable+0x7a/0x80
  efi_enter_virtual_mode+0x3f6/0x4a7
  start_kernel+0x375/0x400
  x86_64_start_reservations+0x2a/0x2c
  x86_64_start_kernel+0x168/0x176
  start_cpu+0x14/0x14

[ efi=old_map was never intended to work with kexec. The problem with
  using efi=old_map is that the virtual addresses are assigned from the
  memory region used by other kernel mappings; vmalloc() space.
  Potentially there could be collisions when booting kexec if something
  else is mapped at the virtual address we allocated for runtime service
  regions in the initial boot - Matt Fleming ]

Since kexec was never intended to work with efi=old_map, disable
runtime services in kexec if booted with efi=old_map, so that we don't
panic.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Tested-by: Lee Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
Acked-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/x86/platform/efi/efi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 7e76a4d8304b..43b96f5f78ba 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -828,9 +828,11 @@ static void __init kexec_enter_virtual_mode(void)
 
 	/*
 	 * We don't do virtual mode, since we don't do runtime services, on
-	 * non-native EFI
+	 * non-native EFI. With efi=old_map, we don't do runtime services in
+	 * kexec kernel because in the initial boot something else might
+	 * have been mapped at these virtual addresses.
 	 */
-	if (!efi_is_native()) {
+	if (!efi_is_native() || efi_enabled(EFI_OLD_MEMMAP)) {
 		efi_memmap_unmap();
 		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 		return;
-- 
2.12.2
