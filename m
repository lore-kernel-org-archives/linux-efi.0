From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 2/4] doc: efi-stub.txt: Fix arm64 paths
Date: Mon, 14 Dec 2015 18:26:51 +0000
Message-ID: <1450117613-15438-3-git-send-email-matt@codeblueprint.co.uk>
References: <1450117613-15438-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1450117613-15438-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Alan Ott <alan@softiron.co.uk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Roy Franz <roy.franz@linaro.org>, Jonathan Corbet <corbet@lwn.net>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Leif Lindholm <leif.lindholm@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

From: Alan Ott <alan@softiron.co.uk>

Update documented paths for arm64 files to match current tree.

Signed-off-by: Alan Ott <alan@softiron.co.uk>
Cc: Roy Franz <roy.franz@linaro.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 Documentation/efi-stub.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/efi-stub.txt b/Documentation/efi-stub.txt
index 7747024d3bb7..e15746988261 100644
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
2.6.2
