From: Mauro Carvalho Chehab <mchehab-JsYNTwtnfakRB7SZvlqPiA@public.gmane.org>
Subject: [PATCH v2 18/31] efi-stub.txt: standardize document format
Date: Sat, 17 Jun 2017 12:25:37 -0300
Message-ID: <66bd3bc59477944b65a010904ff7f812d3f48d7c.1497713142.git.mchehab@s-opensource.com>
References: <f0f77a106d183325dce9eecd3c11214154050e11.1497713142.git.mchehab@s-opensource.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f0f77a106d183325dce9eecd3c11214154050e11.1497713142.git.mchehab-JsYNTwtnfakRB7SZvlqPiA@public.gmane.org>
In-Reply-To: <f0f77a106d183325dce9eecd3c11214154050e11.1497713142.git.mchehab-JsYNTwtnfakRB7SZvlqPiA@public.gmane.org>
References: <f0f77a106d183325dce9eecd3c11214154050e11.1497713142.git.mchehab-JsYNTwtnfakRB7SZvlqPiA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Doc Mailing List <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-JsYNTwtnfakRB7SZvlqPiA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Each text file under Documentation follows a different
format. Some doesn't even have titles!

Change its representation to follow the adopted standard,
using ReST markups for it to be parseable by Sphinx:

- use proper markups for titles;
- identify literal blocks.

Signed-off-by: Mauro Carvalho Chehab <mchehab-JsYNTwtnfakRB7SZvlqPiA@public.gmane.org>
---
 Documentation/efi-stub.txt | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/Documentation/efi-stub.txt b/Documentation/efi-stub.txt
index e15746988261..41df801f9a50 100644
--- a/Documentation/efi-stub.txt
+++ b/Documentation/efi-stub.txt
@@ -1,5 +1,6 @@
-			  The EFI Boot Stub
-		     ---------------------------
+=================
+The EFI Boot Stub
+=================
 
 On the x86 and ARM platforms, a kernel zImage/bzImage can masquerade
 as a PE/COFF image, thereby convincing EFI firmware loaders to load
@@ -25,7 +26,8 @@ a certain sense it *IS* the boot loader.
 The EFI boot stub is enabled with the CONFIG_EFI_STUB kernel option.
 
 
-**** How to install bzImage.efi
+How to install bzImage.efi
+--------------------------
 
 The bzImage located in arch/x86/boot/bzImage must be copied to the EFI
 System Partition (ESP) and renamed with the extension ".efi". Without
@@ -37,14 +39,16 @@ may not need to be renamed. Similarly for arm64, arch/arm64/boot/Image
 should be copied but not necessarily renamed.
 
 
-**** Passing kernel parameters from the EFI shell
+Passing kernel parameters from the EFI shell
+--------------------------------------------
 
-Arguments to the kernel can be passed after bzImage.efi, e.g.
+Arguments to the kernel can be passed after bzImage.efi, e.g.::
 
 	fs0:> bzImage.efi console=ttyS0 root=/dev/sda4
 
 
-**** The "initrd=" option
+The "initrd=" option
+--------------------
 
 Like most boot loaders, the EFI stub allows the user to specify
 multiple initrd files using the "initrd=" option. This is the only EFI
@@ -54,9 +58,9 @@ kernel when it boots.
 The path to the initrd file must be an absolute path from the
 beginning of the ESP, relative path names do not work. Also, the path
 is an EFI-style path and directory elements must be separated with
-backslashes (\). For example, given the following directory layout,
+backslashes (\). For example, given the following directory layout::
 
-fs0:>
+  fs0:>
 	Kernels\
 			bzImage.efi
 			initrd-large.img
@@ -66,7 +70,7 @@ fs0:>
 			initrd-medium.img
 
 to boot with the initrd-large.img file if the current working
-directory is fs0:\Kernels, the following command must be used,
+directory is fs0:\Kernels, the following command must be used::
 
 	fs0:\Kernels> bzImage.efi initrd=\Kernels\initrd-large.img
 
@@ -76,7 +80,8 @@ which understands relative paths, whereas the rest of the command line
 is passed to bzImage.efi.
 
 
-**** The "dtb=" option
+The "dtb=" option
+-----------------
 
 For the ARM and arm64 architectures, we also need to be able to provide a
 device tree to the kernel. This is done with the "dtb=" command line option,
-- 
2.9.4
