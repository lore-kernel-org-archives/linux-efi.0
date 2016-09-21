From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] MAINTAINERS: add myself as EFI maintainer
Date: Wed, 21 Sep 2016 16:35:13 +0100
Message-ID: <1474472114-12973-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, linux@arm.linux.org.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

At the request of Matt, I am taking up co-maintainership of the EFI
subsystem. So add my name to the EFI section in MAINTAINERS, and
change the SCM tree reference to point to the new shared Git repo.

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 007d05acbb5f..224518556a84 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4557,8 +4557,9 @@ F:	sound/usb/misc/ua101.c
 
 EXTENSIBLE FIRMWARE INTERFACE (EFI)
 M:	Matt Fleming <matt@codeblueprint.co.uk>
+M:	Ard Biesheuvel <ard.biesheuvel@linaro.org>
 L:	linux-efi@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git
 S:	Maintained
 F:	Documentation/efi-stub.txt
 F:	arch/ia64/kernel/efi.c
-- 
2.7.4
