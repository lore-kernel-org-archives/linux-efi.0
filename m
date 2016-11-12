From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 2/9] MAINTAINERS: Add ARM and arm64 EFI specific files to EFI subsystem
Date: Sat, 12 Nov 2016 21:32:30 +0000
Message-ID: <20161112213237.8804-3-matt@codeblueprint.co.uk>
References: <20161112213237.8804-1-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161112213237.8804-1-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, "M: Matthew Garrett" <matthew.garrett@nebula.com>, Russell King <rmk+kernel@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Since I will be co-maintaining the EFI subsystem, it makes sense to
mention the ARM and arm64 EFI bits in the EFI section in MAINTAINERS
so that Matt, the list and I get cc'ed on proposed changes.

Acked-by: Will Deacon <will.deacon@arm.com>
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 MAINTAINERS | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6847ba844ef9..1f38999d8ce7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4625,12 +4625,14 @@ L:	linux-efi@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git
 S:	Maintained
 F:	Documentation/efi-stub.txt
-F:	arch/ia64/kernel/efi.c
+F:	arch/*/kernel/efi.c
 F:	arch/x86/boot/compressed/eboot.[ch]
-F:	arch/x86/include/asm/efi.h
+F:	arch/*/include/asm/efi.h
 F:	arch/x86/platform/efi/
 F:	drivers/firmware/efi/
 F:	include/linux/efi*.h
+F:	arch/arm/boot/compressed/efi-header.S
+F:	arch/arm64/kernel/efi-entry.S
 
 EFI VARIABLE FILESYSTEM
 M:	Matthew Garrett <matthew.garrett@nebula.com>
-- 
2.10.0
