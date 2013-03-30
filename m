From: Daniel Vacek <neelx.g@gmail.com>
Subject: Re: Patch "efi: Build EFI stub with EFI-appropriate options" has been
 added to the 3.6-stable tree
Date: Sat, 30 Mar 2013 11:04:08 +0100
Message-ID: <CAA7rmPFxzoOgcrYRetyx3hY-Y_cj0jzuY=sGAj-v2X59vCrrDg@mail.gmail.com>
References: <13511021101759@kroah.org>
	<CAA7rmPF4oZjvwQ5LU1pJAydWhbwmCmzgUudUvQ5_YPpS_Rnjvg@mail.gmail.com>
	<1364614121.3557.11.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1364614121.3557.11.camel@deadeye.wl.decadent.org.uk>
Sender: stable-owner@vger.kernel.org
To: Matthew Garrett <mjg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: matt.fleming@intel.com, linux-efi@vger.kernel.org, ben@decadent.org.uk, linux-kernel@vger.kernel.org, x86@kernel.org, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Sat, Mar 30, 2013 at 4:28 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
> Daniel, this is an obvious fix but I noticed it still hasn't been
> applied.  Please can you re-send with the proper Signed-off-by line?

Resending patch. It got lost somewhere. Thanks for pushing Ben.

>From 53864fe932aa87be62f1c70944c386cff9bb9130 Mon Sep 17 00:00:00 2001
From: Daniel Vacek <neelx.g@gmail.com>
Date: Thu, 18 Oct 2012 22:06:26 +0200
Subject: [PATCH] efi: fix typo in Makefile

Fix a little typo.

Signed-off-by: Daniel Vacek <neelx.g@gmail.com>
Acked-by: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/boot/compressed/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/Makefile
b/arch/x86/boot/compressed/Makefile
index 8a84501..059a17f 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -29,7 +29,7 @@ VMLINUX_OBJS = $(obj)/vmlinux.lds
$(obj)/head_$(BITS).o $(obj)/misc.o \
 	$(obj)/piggy.o

 $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
-$(obj)/efi_stub_$(BITS).o: KBUILD_CLFAGS += -fshort-wchar -mno-red-zone
+$(obj)/efi_stub_$(BITS).o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone

 ifeq ($(CONFIG_EFI_STUB), y)
 	VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o
-- 
1.7.10.4
