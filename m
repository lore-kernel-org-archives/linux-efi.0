From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: Patch "efi: Build EFI stub with EFI-appropriate options" has
 been added to the 3.6-stable tree
Date: Mon, 08 Apr 2013 10:32:05 +0100
Message-ID: <51628E95.1090707@console-pimps.org>
References: <13511021101759@kroah.org> <CAA7rmPF4oZjvwQ5LU1pJAydWhbwmCmzgUudUvQ5_YPpS_Rnjvg@mail.gmail.com> <1364614121.3557.11.camel@deadeye.wl.decadent.org.uk> <CAA7rmPFxzoOgcrYRetyx3hY-Y_cj0jzuY=sGAj-v2X59vCrrDg@mail.gmail.com> <515C043B.4070401@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <515C043B.4070401-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Vacek <neelx.g-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 03/04/13 11:28, Matt Fleming wrote:
> I applied this by hand. Your patch appears to be whitespace damaged. Also, I
> expanded the commit message and turned it into,
> 
>   efi: fix typo in Makefile
> 
>   commit 9dead5bbb825 ("efi: Build EFI stub with EFI-appropriate options")
>   contains a typo which means that the efi_stub_$(BITS).o code is still not
>   compiled with -fshort-wchar and -mno-red-zone.
> 
>   Fix it with s/KBUILD_CLFAGS/KBUILD_CFLAGS/

I ended up dropping this patch because the following has been applied to -tip,

commit 918708245e92941df16a634dc201b407d12bcd91
Author: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Date:   Wed Apr 3 15:47:33 2013 +0100

    x86: Fix rebuild with EFI_STUB enabled
    
    eboot.o and efi_stub_$(BITS).o didn't get added to "targets", and hence
    their .cmd files don't get included by the build machinery, leading to
    the files always getting rebuilt.
    
    Rather than adding the two files individually, take the opportunity and
    add $(VMLINUX_OBJS) to "targets" instead, thus allowing the assignment
    at the top of the file to be shrunk quite a bit.
    
    At the same time, remove a pointless flags override line - the variable
    assigned to was misspelled anyway, and the options added are
    meaningless for assembly sources.
    
    [ hpa: the patch is not minimal, but I am taking it for -urgent anyway
      since the excess impact of the patch seems to be small enough. ]
    
    Signed-off-by: Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>
    Link: http://lkml.kernel.org/r/515C5D2502000078000CA6AD-ce6RLXgGx+vWGUEhTRrCg1aTQe2KTcn/@public.gmane.org
    Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: H. Peter Anvin <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 8a84501..5ef205c 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -4,7 +4,7 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
-targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.xz vmlinux.bin.lzo head_$(BITS).o misc.o string.o cmdline.o early_serial_console.o piggy.o
+targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.xz vmlinux.bin.lzo
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
@@ -29,7 +29,6 @@ VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 	$(obj)/piggy.o
 
 $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
-$(obj)/efi_stub_$(BITS).o: KBUILD_CLFAGS += -fshort-wchar -mno-red-zone
 
 ifeq ($(CONFIG_EFI_STUB), y)
 	VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o
@@ -43,7 +42,7 @@ OBJCOPYFLAGS_vmlinux.bin :=  -R .comment -S
 $(obj)/vmlinux.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
 
-targets += vmlinux.bin.all vmlinux.relocs
+targets += $(patsubst $(obj)/%,%,$(VMLINUX_OBJS)) vmlinux.bin.all vmlinux.relocs
 
 CMD_RELOCS = arch/x86/tools/relocs
 quiet_cmd_relocs = RELOCS  $@

-- 
Matt Fleming, Intel Open Source Technology Center
