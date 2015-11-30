From: Alan Ott <alan@softiron.co.uk>
Subject: [PATCH v2] doc: efi-stub.txt: Fix arm64 paths
Date: Mon, 30 Nov 2015 09:36:54 -0500
Message-ID: <1448894214-23616-1-git-send-email-alan@softiron.co.uk>
References: <20151130113237.GC2441@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151130113237.GC2441@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>, Jonathan Corbet <corbet@lwn.net>
Cc: Roy Franz <roy.franz@linaro.org>, linux-efi@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Ott <alan@softiron.co.uk>
List-Id: linux-efi@vger.kernel.org

Update documented paths for arm64 files to match current tree.

Signed-off-by: Alan Ott <alan@softiron.co.uk>
---
 Documentation/efi-stub.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/efi-stub.txt b/Documentation/efi-stub.txt
index 7747024..e157469 100644
--- a/Documentation/efi-stub.txt
+++ b/Documentation/efi-stub.txt
@@ -10,12 +10,12 @@ arch/x86/boot/header.S and arch/x86/boot/compressed/eboot.c,
 respectively. For ARM the EFI stub is implemented in
 arch/arm/boot/compressed/efi-header.S and
 arch/arm/boot/compressed/efi-stub.c. EFI stub code that is shared
-between architectures is in drivers/firmware/efi/efi-stub-helper.c.
+between architectures is in drivers/firmware/efi/libstub.
 
 For arm64, there is no compressed kernel support, so the Image itself
 masquerades as a PE/COFF image and the EFI stub is linked into the
 kernel. The arm64 EFI stub lives in arch/arm64/kernel/efi-entry.S
-and arch/arm64/kernel/efi-stub.c.
+and drivers/firmware/efi/libstub/arm64-stub.c.
 
 By using the EFI boot stub it's possible to boot a Linux kernel
 without the use of a conventional EFI boot loader, such as grub or
-- 
2.5.0
