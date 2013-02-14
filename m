From: Satoru Takeuchi <takeuchi_satoru-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH] efi: Clear EFI_RUNTIME_SERVICES rather than EFI_BOOT by "noefi"
 boot parameter
Date: Thu, 14 Feb 2013 09:12:52 +0900
Message-ID: <511C2C04.2070108@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, linux EFI ml <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-stable ml <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux x86 ml <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Corentin Chary <corentincj-EjuBZuxMvz2sTnJN9+BGXg@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Steve Langasek <steve.langasek-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Konrad Rzeszutek Wilk <konrad-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Satoru Takeuchi <takeuchi_satoru-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

There was a serious problem in samsung-laptop that its platform driver is
designed to run under BIOS and running under EFI can cause the machine to
become bricked or can cause Machine Check Exceptions.

    Discussion about this problem:
    https://bugs.launchpad.net/ubuntu-cdimage/+bug/1040557
    https://bugzilla.kernel.org/show_bug.cgi?id=47121

    The patches to fix this problem:
    efi: Make 'efi_enabled' a function to query EFI facilities
    83e68189745ad931c2afd45d8ee3303929233e7f

    samsung-laptop: Disable on EFI hardware
    e0094244e41c4d0c7ad69920681972fc45d8ce34

Unfortunately this problem comes back again if users specify "noefi" option.
This parameter clears EFI_BOOT and that driver continues to run even if running
under EFI. Refer to the document, this parameter should clear
EFI_RUNTIME_SERVICES instead.

Documentation/kernel-parameters.txt:
===============================================================================
...
	noefi		[X86] Disable EFI runtime services support.
...
===============================================================================

Documentation/x86/x86_64/uefi.txt:
===============================================================================
...
- If some or all EFI runtime services don't work, you can try following
  kernel command line parameters to turn off some or all EFI runtime
  services.
	noefi		turn off all EFI runtime services
...
===============================================================================

Signed-off-by: Satoru Takeuchi <takeuchi_satoru-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: David Airlie <airlied-cv59FeDIM0c@public.gmane.org>
Cc: Corentin Chary <corentincj-EjuBZuxMvz2sTnJN9+BGXg@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Steve Langasek <steve.langasek-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Konrad Rzeszutek Wilk <konrad-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Rafael J. Wysocki <rjw-KKrjLPT3xs0@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: H. Peter Anvin <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 arch/x86/platform/efi/efi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 77cf009..928bf83 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -87,7 +87,7 @@ EXPORT_SYMBOL(efi_enabled);
 
 static int __init setup_noefi(char *arg)
 {
-	clear_bit(EFI_BOOT, &x86_efi_facility);
+	clear_bit(EFI_RUNTIME_SERVICES, &x86_efi_facility);
 	return 0;
 }
 early_param("noefi", setup_noefi);
-- 1.7.10.4 
