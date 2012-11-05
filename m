From: "Jan Beulich" <JBeulich-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH] x86/EFI: additional checks in efi_bgrt_init()
Date: Mon, 05 Nov 2012 15:26:41 +0000
Message-ID: <5097E8C102000078000A661B@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: mingo-X9Un+BFzKDI@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Header length should be validated for all ACPI tables before accessing
any non-header field.

The valid flags should also be check, as with it clear there's no point
in trying to go through the rest of the code (and there's no guarantee
that the other table contents are valid/consistent in that case).

Signed-off-by: Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>

---
 arch/x86/platform/efi/efi-bgrt.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- 3.7-rc4/arch/x86/platform/efi/efi-bgrt.c
+++ 3.7-rc4-x86-EFI-BGRT-checks/arch/x86/platform/efi/efi-bgrt.c
@@ -39,7 +39,9 @@ void efi_bgrt_init(void)
 	if (ACPI_FAILURE(status))
 		return;
 
-	if (bgrt_tab->version != 1)
+	if (bgrt_tab->header.length < sizeof(*bgrt_tab))
+		return;
+	if (bgrt_tab->version != 1 || !(bgrt_tab->status & 1))
 		return;
 	if (bgrt_tab->image_type != 0 || !bgrt_tab->image_address)
 		return;
