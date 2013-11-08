From: Yasuaki Ishimatsu <isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH] x86, efi: change name of efi_no_storage_paranoia parameter
 to efi_storage_paranoia
Date: Fri, 8 Nov 2013 16:33:09 +0900
Message-ID: <527C93B5.7010407@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, jlee-IBi9RG/b67k@public.gmane.org
List-Id: linux-efi@vger.kernel.org

By following works, my system very often fails set_variable() to set new
variable to efi variable storage and shows "efivars: set_variable() failed:
status=-28" message.

- commit 31ff2f20d9003e74991d135f56e503fe776c127c
    efi: Distinguish between "remaining space" and actually used space
- commit 8c58bf3eec3b8fc8162fe557e9361891c20758f2
    x86,efi: Implement efi_no_storage_paranoia parameter
- commit f8b8404337de4e2466e2e1139ea68b1f8295974f
    Modify UEFI anti-bricking code

When booting my system, remaining space of efi variable storage is about
5KB. So there is no room that sets a new variable to the storage.

According to above works, efi_no_storage_paranoia parameter was prepared
for sane UEFI which can do gc and fulfills spec. But why need a system
with a sane UEFI set the parameter? It is wrong. A system with a broken
UEFI should set the parameter.

This patch changes name of the parameter to efi_storage_paranoia and uses
all efi variable storage with no parameter.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
CC: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
CC: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
CC: Lee, Chun-Y <jlee-IBi9RG/b67k@public.gmane.org>
CC: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Documentation/kernel-parameters.txt | 10 +++++-----
 arch/x86/platform/efi/efi.c         |  8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index fcbb736..2157c8e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -888,11 +888,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	edd=		[EDD]
 			Format: {"off" | "on" | "skip[mbr]"}

-	efi_no_storage_paranoia [EFI; X86]
-			Using this parameter you can use more than 50% of
-			your efi variable storage. Use this parameter only if
-			you are really sure that your UEFI does sane gc and
-			fulfills the spec otherwise your board may brick.
+	efi_storage_paranoia [EFI; X86]
+			Using this parameter you cannot use your efi variable
+			storage when the remaining space of the storage becomes
+			less than 5KB. Use this parameter if your UEFI does
+			not sane gc and fulfills the spec.

 	eisa_irq_edge=	[PARISC,HW]
 			See header of drivers/parisc/eisa.c.
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index c7e22ab..010a0eb 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -107,14 +107,14 @@ static int __init setup_add_efi_memmap(char *arg)
 }
 early_param("add_efi_memmap", setup_add_efi_memmap);

-static bool efi_no_storage_paranoia;
+static bool efi_storage_paranoia;

 static int __init setup_storage_paranoia(char *arg)
 {
-	efi_no_storage_paranoia = true;
+	efi_storage_paranoia = true;
 	return 0;
 }
-early_param("efi_no_storage_paranoia", setup_storage_paranoia);
+early_param("efi_storage_paranoia", setup_storage_paranoia);


 static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
@@ -1066,7 +1066,7 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 	 * 5KB. This figure was provided by Samsung, so should be safe.
 	 */
 	if ((remaining_size - size < EFI_MIN_RESERVE) &&
-		!efi_no_storage_paranoia) {
+		efi_storage_paranoia) {

 		/*
 		 * Triggering garbage collection may require that the firmware
