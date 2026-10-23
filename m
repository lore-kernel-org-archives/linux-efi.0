Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792738258;
	b=a4WmorRrxp9NYYmmk2BpWz/cHEMqCMyR3d4TRfRWeZAf3zttv5cvXhHO0UjhD/Z4BfDY
	 aD80WHGwpu8NoBePN4n5vad/kyU40e4n1sXkO7bS7lwtOHiYw5fhNoe8Gz5KCmQay0vfT
	 cW9oKwuqjjr9pgMHrCBvboHxAHD392JYZ0JTiUNAZUPTaZOTUIZSMFRcE2/nQj4mwXvx9
	 KEVmcJYcyAlg7AeSNxeUgbnRvi5ulpGqFP10w6gg4LQtFvCwsh8exlnMQUO6HPOvIDEdI
	 tpmWgB44GREHY/iOFYPYBBO+rAPsbkNDGI1YOuzu9aP3koYK2B8lvmyien7bVINQ7Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792738258;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=F6+noPVYF4kQP6smbqYTSV7WwZHDrBWE8Us7MYDz21A=;
	b=farNplfdwow9CT5eWQlypajQvFoU2Be9LRWqmGu8UNEtvwI1WD5VXElhWBynTM0WdZhg
	 McVMcs4EGaXCu2Apfd8MLbaznjv/KrZ4qeXK0OeUX6CRbe4x9t3EoebmekERrrJOw6WP5
	 SRQBfhSc4dnDrzwIIr8aZR6juraXAUe11b/wYT/q9uaB8AsWmbME8V4zvMf/hmvKXxX2S
	 5C565j/A36Q9znoXSCkAxvMev76crlR7nDrLuBuA5M17yE2XhsLM+4JQfkBt90OzAxXE1
	 0GO+ZVBQ7NrWwR3UpcOwBWPO9dCkynsvMTKg09s6UcObb7XdfTVOdpbmrMLVl3eWong==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=WiJAYFar;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAA0606A32C
	for <linux-efi@vger.kernel.org>; Fri, 23 Oct 2026 06:50:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8DAA0606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=WiJAYFar
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792738256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F6+noPVYF4kQP6smbqYTSV7WwZHDrBWE8Us7MYDz21A=;
	b=WiJAYFar5GLqm9jBfte1wVBOF0+8IuRTzYWgbucplaQuwiTc28SwjYD3DC6M3D70cFGrT8
	z2mAjxn3+cDE9BLfZl/o6C2WBIvSaVC9DCPKgkYcVdTVPHeQsYjOtJJCTRXK4emGxXVw1V
	CyBMzM3RQo4z+iuB+UBXSCtuRcHYgtA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-587-1BrFnSVrOACgn3OQUjDx2Q-1; Fri,
 23 Oct 2026 02:50:51 -0400
X-MC-Unique: 1BrFnSVrOACgn3OQUjDx2Q-1
X-Mimecast-MFC-AGG-ID: 1BrFnSVrOACgn3OQUjDx2Q_1792738248
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BCC341955F71;
	Fri, 23 Oct 2026 06:50:47 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.42])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7EFCD1956095;
	Fri, 23 Oct 2026 06:50:27 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Luis Augenstein <luis.augenstein@tngtech.com>,
	Maximilian Huber <maximilian.huber@tngtech.com>,
	Anup Patel <anup@brainfault.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Andy Lutomirski <luto@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: soc@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Mark Rutland <mark.rutland@arm.com>,
	WANG Xuerui <kernel@xen0n.name>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Atish Patra <atish.patra@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	linux-efi@vger.kernel.org,
	netdev@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v5 13/13] treewide: Stop defining __ASSEMBLY__ for assembler files
Date: Fri, 23 Oct 2026 08:48:50 +0200
Message-ID: <20261023064908.66707-14-thuth@redhat.com>
In-Reply-To: <20261023064908.66707-1-thuth@redhat.com>
References: <20261023064908.66707-1-thuth@redhat.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

All spots have been changed to __ASSEMBLER__ (i.e. the macro that
gets defined by the compiler), so we don't have to manually define
__ASSEMBLY__ anymore.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 Makefile                                             | 2 +-
 arch/alpha/boot/compressed/Makefile                  | 2 +-
 arch/arm64/kernel/vdso32/Makefile                    | 1 -
 arch/loongarch/vdso/Makefile                         | 2 +-
 arch/mips/boot/compressed/Makefile                   | 2 +-
 arch/mips/vdso/Makefile                              | 2 +-
 arch/powerpc/boot/Makefile                           | 2 +-
 arch/powerpc/platforms/cell/spufs/Makefile           | 2 +-
 arch/s390/Makefile                                   | 2 +-
 arch/x86/boot/Makefile                               | 2 +-
 arch/x86/boot/compressed/Makefile                    | 2 +-
 arch/x86/realmode/rm/Makefile                        | 2 +-
 arch/xtensa/kernel/Makefile                          | 2 +-
 drivers/firmware/efi/libstub/Makefile                | 2 +-
 drivers/net/wan/Makefile                             | 2 +-
 scripts/Makefile.build                               | 2 +-
 scripts/gfp-translate                                | 2 +-
 scripts/headers_install.sh                           | 1 -
 scripts/sbom/tests/cmd_graph/test_savedcmd_parser.py | 2 +-
 tools/testing/selftests/kvm/lib/riscv/handlers.S     | 4 ----
 tools/testing/selftests/vDSO/vgetrandom-chacha.S     | 2 --
 21 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/Makefile b/Makefile
index 0319cd716d73b..98bffdd9cf2d6 100644
--- a/Makefile
+++ b/Makefile
@@ -606,7 +606,7 @@ LINUXINCLUDE    := \
 		-I$(objtree)/include \
 		$(USERINCLUDE)
 
-KBUILD_AFLAGS   := -D__ASSEMBLY__ -fno-PIE
+KBUILD_AFLAGS   := -fno-PIE
 
 KBUILD_CFLAGS :=
 KBUILD_CFLAGS += -fshort-wchar
diff --git a/arch/alpha/boot/compressed/Makefile b/arch/alpha/boot/compressed/Makefile
index eb930f01b4be4..16119a13e53a3 100644
--- a/arch/alpha/boot/compressed/Makefile
+++ b/arch/alpha/boot/compressed/Makefile
@@ -22,7 +22,7 @@ KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
 KBUILD_CFLAGS += -pipe -mcpu=ev4 -mno-fp-regs -ffixed-8
 KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING -D__DISABLE_EXPORTS
 KBUILD_CFLAGS += $(CC_FLAGS_DIALECT)
-KBUILD_AFLAGS := -D__ASSEMBLY__ $(KBUILD_CFLAGS)
+KBUILD_AFLAGS := $(KBUILD_CFLAGS)
 
 # The stub has no sanitizer or coverage runtime. arch/alpha/lib/lib.a is
 # built with the kernel's instrumentation and -mcpu=, so build private
diff --git a/arch/arm64/kernel/vdso32/Makefile b/arch/arm64/kernel/vdso32/Makefile
index 00efdc5d23543..0ba0b4bb3e013 100644
--- a/arch/arm64/kernel/vdso32/Makefile
+++ b/arch/arm64/kernel/vdso32/Makefile
@@ -77,7 +77,6 @@ VDSO_CFLAGS += -marm
 endif
 
 VDSO_AFLAGS := $(VDSO_CAFLAGS)
-VDSO_AFLAGS += -D__ASSEMBLY__
 
 # From arm vDSO Makefile
 VDSO_LDFLAGS += -Bsymbolic --no-undefined -soname=linux-vdso.so.1
diff --git a/arch/loongarch/vdso/Makefile b/arch/loongarch/vdso/Makefile
index 0b84892d084b6..c2b73fd3781c0 100644
--- a/arch/loongarch/vdso/Makefile
+++ b/arch/loongarch/vdso/Makefile
@@ -32,7 +32,7 @@ cflags-vdso := $(ccflags-vdso) \
 	$(call cc-option, -fasynchronous-unwind-tables) \
 	$(call cc-option, -fno-stack-protector)
 aflags-vdso := $(ccflags-vdso) \
-	-D__ASSEMBLY__ -Wa,-gdwarf-2
+	-Wa,-gdwarf-2
 
 ifneq ($(c-gettimeofday-y),)
   CFLAGS_vgettimeofday.o += -include $(c-gettimeofday-y)
diff --git a/arch/mips/boot/compressed/Makefile b/arch/mips/boot/compressed/Makefile
index 2684540758a8d..3e3803b2db48f 100644
--- a/arch/mips/boot/compressed/Makefile
+++ b/arch/mips/boot/compressed/Makefile
@@ -30,7 +30,7 @@ endif
 KBUILD_CFLAGS := $(KBUILD_CFLAGS) -D__KERNEL__ -D__DISABLE_EXPORTS \
 	-DBOOT_HEAP_SIZE=$(BOOT_HEAP_SIZE) -D"VMLINUX_LOAD_ADDRESS_ULL=$(VMLINUX_LOAD_ADDRESS)ull"
 
-KBUILD_AFLAGS := $(KBUILD_AFLAGS) -D__ASSEMBLY__ \
+KBUILD_AFLAGS := $(KBUILD_AFLAGS) \
 	-DBOOT_HEAP_SIZE=$(BOOT_HEAP_SIZE) \
 	-DKERNEL_ENTRY=$(VMLINUX_ENTRY_ADDRESS)
 
diff --git a/arch/mips/vdso/Makefile b/arch/mips/vdso/Makefile
index 00d3ba2c482ac..4d04987e995de 100644
--- a/arch/mips/vdso/Makefile
+++ b/arch/mips/vdso/Makefile
@@ -33,7 +33,7 @@ cflags-vdso := $(ccflags-vdso) \
 	-fno-stack-protector -fno-jump-tables -DDISABLE_BRANCH_PROFILING \
 	$(call cc-option, -fno-asynchronous-unwind-tables)
 aflags-vdso := $(ccflags-vdso) \
-	-D__ASSEMBLY__ -Wa,-gdwarf-2
+	-Wa,-gdwarf-2
 
 ifneq ($(c-gettimeofday-y),)
 obj-vdso-y += vgettimeofday.o
diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index 7ee0fa2d3371e..5dca91ec9f4aa 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -80,7 +80,7 @@ BOOTCFLAGS	:= $(BOOTTARGETFLAGS) \
 		   $(call cc-option,-mno-spe) $(call cc-option,-mspe=no) \
 		   -fomit-frame-pointer -fno-builtin -fPIC
 
-BOOTAFLAGS	:= $(BOOTTARGETFLAGS) -D__ASSEMBLY__
+BOOTAFLAGS	:= $(BOOTTARGETFLAGS)
 
 BOOTARFLAGS	:= -crD
 
diff --git a/arch/powerpc/platforms/cell/spufs/Makefile b/arch/powerpc/platforms/cell/spufs/Makefile
index 60319d4ff25a6..959617c4ee89c 100644
--- a/arch/powerpc/platforms/cell/spufs/Makefile
+++ b/arch/powerpc/platforms/cell/spufs/Makefile
@@ -15,7 +15,7 @@ SPU_AS		:= $(SPU_CROSS)gcc
 SPU_LD		:= $(SPU_CROSS)ld
 SPU_OBJCOPY	:= $(SPU_CROSS)objcopy
 SPU_CFLAGS	:= -O2 -Wall -I$(srctree)/include -D__KERNEL__
-SPU_AFLAGS	:= -c -D__ASSEMBLY__ -I$(srctree)/include -D__KERNEL__
+SPU_AFLAGS	:= -c -I$(srctree)/include -D__KERNEL__
 SPU_LDFLAGS	:= -N -Ttext=0x0
 
 $(obj)/switch.o: $(obj)/spu_save_dump.h $(obj)/spu_restore_dump.h
diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index 8b712cd85fcd3..83ecc702f7146 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -17,7 +17,7 @@ KBUILD_CFLAGS	+= -fPIC
 LDFLAGS_vmlinux	:= $(call ld-option,-no-pie)
 extra_tools	:= relocs
 aflags_dwarf	:= -Wa,-gdwarf-2
-KBUILD_AFLAGS_DECOMPRESSOR := $(CLANG_FLAGS) -m64 -D__ASSEMBLY__
+KBUILD_AFLAGS_DECOMPRESSOR := $(CLANG_FLAGS) -m64
 ifndef CONFIG_AS_IS_LLVM
 KBUILD_AFLAGS_DECOMPRESSOR += $(if $(CONFIG_DEBUG_INFO),$(aflags_dwarf))
 endif
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 4a9bce32586d3..69d75072888d1 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -52,7 +52,7 @@ targets += cpustr.h
 # ---------------------------------------------------------------------------
 
 KBUILD_CFLAGS	:= $(REALMODE_CFLAGS) -D_SETUP
-KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
+KBUILD_AFLAGS	:= $(KBUILD_CFLAGS)
 KBUILD_CFLAGS	+= -fno-asynchronous-unwind-tables
 KBUILD_CFLAGS	+= $(CONFIG_CC_IMPLICIT_FALLTHROUGH)
 
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 680ad803cba7d..e73ef522496e1 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -49,7 +49,7 @@ KBUILD_CFLAGS += -include $(srctree)/include/linux/hidden.h
 # that the compiler finds it even with out-of-tree builds (make O=/some/path).
 CFLAGS_sev-handle-vc.o += -I$(objtree)/arch/x86/lib/
 
-KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
+KBUILD_AFLAGS  := $(KBUILD_CFLAGS)
 
 KBUILD_LDFLAGS := -m elf_$(UTS_MACHINE)
 KBUILD_LDFLAGS += $(call ld-option,--no-ld-generated-unwind-info)
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index a0fb39abc5c86..20bbe1af05acd 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -65,5 +65,5 @@ $(obj)/realmode.relocs: $(obj)/realmode.elf FORCE
 
 KBUILD_CFLAGS	:= $(REALMODE_CFLAGS) -D_SETUP -D_WAKEUP \
 		   -I$(srctree)/arch/x86/boot
-KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
+KBUILD_AFLAGS	:= $(KBUILD_CFLAGS)
 KBUILD_CFLAGS	+= -fno-asynchronous-unwind-tables
diff --git a/arch/xtensa/kernel/Makefile b/arch/xtensa/kernel/Makefile
index d3ef0407401f6..ece4ae6dea97d 100644
--- a/arch/xtensa/kernel/Makefile
+++ b/arch/xtensa/kernel/Makefile
@@ -39,7 +39,7 @@ sed-y = -e ':a; s/\*(\([^)]*\)\.text\.unlikely/*(\1.literal.unlikely .{text}.unl
 	-e 's/\.{text}/.text/g'
 
 quiet_cmd__cpp_lds_S = LDS     $@
-cmd__cpp_lds_S = $(CPP) $(cpp_flags) -P -C -Uxtensa -D__ASSEMBLY__ \
+cmd__cpp_lds_S = $(CPP) $(cpp_flags) -P -C -Uxtensa \
 		 -DLINKER_SCRIPT $< | sed $(sed-y) >$@
 
 $(obj)/vmlinux.lds: $(src)/vmlinux.lds.S FORCE
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 415f63105b481..d4edc3c0c4556 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -61,7 +61,7 @@ KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_LTO), $(KBUILD_CFLAGS))
 # `-fdata-sections` flag from KBUILD_CFLAGS_KERNEL
 KBUILD_CFLAGS_KERNEL := $(filter-out -fdata-sections, $(KBUILD_CFLAGS_KERNEL))
 
-KBUILD_AFLAGS			:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
+KBUILD_AFLAGS			:= $(KBUILD_CFLAGS)
 
 lib-y				:= efi-stub-helper.o gop.o secureboot.o tpm.o \
 				   file.o mem.o random.o randomalloc.o pci.o \
diff --git a/drivers/net/wan/Makefile b/drivers/net/wan/Makefile
index 00e9b7ee1e012..4233143534465 100644
--- a/drivers/net/wan/Makefile
+++ b/drivers/net/wan/Makefile
@@ -57,7 +57,7 @@ $(obj)/wanxlfw.bin: $(obj)/wanxlfw.o FORCE
 	$(call if_changed,m68kld_bin_o)
 
 quiet_cmd_m68kas_o_S = M68KAS  $@
-      cmd_m68kas_o_S = $(M68KCC) -D__ASSEMBLY__ -Wp,-MD,$(depfile) -I$(srctree)/include/uapi -c -o $@ $<
+      cmd_m68kas_o_S = $(M68KCC) -Wp,-MD,$(depfile) -I$(srctree)/include/uapi -c -o $@ $<
 
 $(obj)/wanxlfw.o: $(src)/wanxlfw.S FORCE
 	$(call if_changed_dep,m68kas_o_S)
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 6127feb970c65..0b7c1e273f0cb 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -465,7 +465,7 @@ targets += $(lib-y) $(always-y)
 # ---------------------------------------------------------------------------
 quiet_cmd_cpp_lds_S = LDS     $@
       cmd_cpp_lds_S = $(CPP) $(cpp_flags) -P -U$(ARCH) \
-	                     -D__ASSEMBLY__ -DLINKER_SCRIPT -o $@ $<
+	                     -DLINKER_SCRIPT -o $@ $<
 
 $(obj)/%.lds: $(src)/%.lds.S FORCE
 	$(call if_changed_dep,cpp_lds_S)
diff --git a/scripts/gfp-translate b/scripts/gfp-translate
index 8385ae0d5af93..f6353795fdca3 100755
--- a/scripts/gfp-translate
+++ b/scripts/gfp-translate
@@ -73,7 +73,7 @@ echo Parsing: $GFPMASK
 #include <stdio.h>
 
 // Try to fool compiler.h into not including extra stuff
-#define __ASSEMBLY__	1
+#define __ASSEMBLER__	1
 
 #include <generated/autoconf.h>
 #include <linux/gfp_types.h>
diff --git a/scripts/headers_install.sh b/scripts/headers_install.sh
index 2f1d1767ca267..9c15e748761c4 100755
--- a/scripts/headers_install.sh
+++ b/scripts/headers_install.sh
@@ -36,7 +36,6 @@ sed -E -e '
 	s/(^|[^a-zA-Z0-9])__packed([^a-zA-Z0-9_]|$)/\1__attribute__((packed))\2/g
 	s/(^|[[:space:](])(inline|asm|volatile)([[:space:](]|$)/\1__\2__\3/g
 	s@#(ifndef|define|endif[[:space:]]*/[*])[[:space:]]*_UAPI@#\1 @
-	s/__ASSEMBLY__/__ASSEMBLER__/g
 ' $INFILE > $TMPFILE || exit 1
 
 scripts/unifdef -U__KERNEL__ -D__EXPORTED_HEADERS__ $TMPFILE > $OUTFILE
diff --git a/scripts/sbom/tests/cmd_graph/test_savedcmd_parser.py b/scripts/sbom/tests/cmd_graph/test_savedcmd_parser.py
index 93787a1cd1566..8d9ae35764040 100644
--- a/scripts/sbom/tests/cmd_graph/test_savedcmd_parser.py
+++ b/scripts/sbom/tests/cmd_graph/test_savedcmd_parser.py
@@ -152,7 +152,7 @@ class TestSavedCmdParser(unittest.TestCase):
         self._assert_parsing(cmd, expected)
 
     def test_clang(self):
-        cmd = """clang -Wp,-MMD,arch/x86/entry/.entry_64_compat.o.d -nostdinc -I../arch/x86/include -I./arch/x86/include/generated -I../include -I./include -I../arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I../include/uapi -I./include/generated/uapi -include ../include/linux/compiler-version.h -include ../include/linux/kconfig.h -D__KERNEL__ --target=x86_64-linux-gnu -fintegrated-as -Werror=unknown-warning-option -Werror=ignored-optimization-argument -Werror=option-ignored -Werror=unused-command-line-argument -fmacro-prefix-map=../= -Werror -D__ASSEMBLY__ -fno-PIE -m64 -I../arch/x86/entry -Iarch/x86/entry    -DKBUILD_MODFILE='"arch/x86/entry/entry_64_compat"' -DKBUILD_MODNAME='"entry_64_compat"' -D__KBUILD_MODNAME=kmod_entry_64_compat -c -o arch/x86/entry/entry_64_compat.o ../arch/x86/entry/entry_64_compat.S"""
+        cmd = """clang -Wp,-MMD,arch/x86/entry/.entry_64_compat.o.d -nostdinc -I../arch/x86/include -I./arch/x86/include/generated -I../include -I./include -I../arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I../include/uapi -I./include/generated/uapi -include ../include/linux/compiler-version.h -include ../include/linux/kconfig.h -D__KERNEL__ --target=x86_64-linux-gnu -fintegrated-as -Werror=unknown-warning-option -Werror=ignored-optimization-argument -Werror=option-ignored -Werror=unused-command-line-argument -fmacro-prefix-map=../= -Werror -fno-PIE -m64 -I../arch/x86/entry -Iarch/x86/entry    -DKBUILD_MODFILE='"arch/x86/entry/entry_64_compat"' -DKBUILD_MODNAME='"entry_64_compat"' -D__KBUILD_MODNAME=kmod_entry_64_compat -c -o arch/x86/entry/entry_64_compat.o ../arch/x86/entry/entry_64_compat.S"""
         expected = "../arch/x86/entry/entry_64_compat.S"
         self._assert_parsing(cmd, expected)
 
diff --git a/tools/testing/selftests/kvm/lib/riscv/handlers.S b/tools/testing/selftests/kvm/lib/riscv/handlers.S
index b787b982e922a..c8cc2d695f483 100644
--- a/tools/testing/selftests/kvm/lib/riscv/handlers.S
+++ b/tools/testing/selftests/kvm/lib/riscv/handlers.S
@@ -3,10 +3,6 @@
  * Copyright (c) 2023 Intel Corporation
  */
 
-#ifndef __ASSEMBLY__
-#define __ASSEMBLY__
-#endif
-
 #include <asm/csr.h>
 
 .macro save_context
diff --git a/tools/testing/selftests/vDSO/vgetrandom-chacha.S b/tools/testing/selftests/vDSO/vgetrandom-chacha.S
index 16f985b089d45..42839c5cf5ec4 100644
--- a/tools/testing/selftests/vDSO/vgetrandom-chacha.S
+++ b/tools/testing/selftests/vDSO/vgetrandom-chacha.S
@@ -3,8 +3,6 @@
  * Copyright (C) 2024 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  */
 
-#define __ASSEMBLY__
-
 #if defined(__aarch64__)
 #include "../../../../arch/arm64/kernel/vdso/vgetrandom-chacha.S"
 #elif defined(__loongarch__)
-- 
2.56.0

