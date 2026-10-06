Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2483D5645;
	Tue,  6 Oct 2026 20:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791319346; cv=none; b=hoq5XcTasDFhtPF6Zp75NAD9nno07XHdU/9MG3toa8cwiAFQMappdPgOUdZQTvrkAm9dynqTRVi3tuIw/OMEUSZ/Gx0KU9DtYSEE14lUhTNVsPd7jgwryRzDEX7FO4p/lnK3y8HiGG/mU+epmuMCdWPHbmPyeJpPsaStE5cQUHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791319346; c=relaxed/simple;
	bh=WFpdf4n+77QgourCDpWIcEBk2OgKMZKX3U0kB6OtEn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7FiXSvzgIL1J4CZ93B4cNNCqLPBpx7nGV1/tF4pcjSJ2pXJtWiUzdGf94KWyLMmWjXflQ7zLoPfle9Z8/iUfwDsKvx2MxhCHF+u5kw3JUJN8MXaciuRIiQMmm1WdczVjzGTmhIr+/q3CSPB4JFR543CML0K3epTbWJP11OFKxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+N5m2xS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+N5m2xS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A86C1F0089E;
	Tue,  6 Oct 2026 20:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791319345;
	bh=pDH61hg2/e2bhJ+lbUL/OXjbHM69BvK0AUcNZlUWMlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a+N5m2xSffV3lTCAY13XISPi2l/XDJVpNp8OO2CE1ePbUZ4pyYYZdrUYeYDlFRBBG
	 Mzc9Ha6HoM0Tf1Cq6BxjSG7bT7Zedk2+eFMNffvoAnyuCaWiC/8FI18oU45LXz0lid
	 gyobkZnga5Vi+HT2XI1zOh6B8Xoe4sfEidlOrsFyebUV+SlS2Ta8DDhfZujlIZC/SJ
	 zpPrAkvhI7PO892brvZ8gf5v660BhyjjLy+d6YIb16psrP5OwI0wCHu13MI799SKdL
	 ao49SmGmGkabhylZ2AEGuM7AdMCWc/UnEWGw11csT+eWsi16xsIkJxS//jqR03yJRW
	 qWRO4mJr7EIgw==
From: Kees Cook <kees@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH v1 3/3] efi/libstub: Disable kernel stack erasing in the common flags
Date: Tue,  6 Oct 2026 13:42:23 -0700
Message-ID: <20261006204224.1536491-3-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006204210.i.137-kees@kernel.org>
References: <20261006204210.i.137-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2234; i=kees@kernel.org; h=from:subject; bh=WFpdf4n+77QgourCDpWIcEBk2OgKMZKX3U0kB6OtEn0=; b=owGbwMvMwCVmps19z/KJym7G02pJDFlHY/VXcTxxjbC+Men2iZKy1r989tm6/ml/tjinNuWlV aYd3Levo5SFQYyLQVZMkSXIzj3OxeNte7j7XEWYOaxMIEMYuDgFYCJTUhj+h29Xu7LfdYaQlK7d ev9KSy67uis9yWoNiaXOkWdvzvvNy8jw42wJ4zp2Jj43Th2DMy+M1z3PW6iZm+Bx9oBD94JF/YI sAA==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Every architecture that builds the stub now adds $(DISABLE_KSTACK_ERASE)
to its own flags, so add it once to the flags they share instead.

Assisted-by: LLM
Signed-off-by: Kees Cook <kees@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 1f588591f458..d6fe69c3af87 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -19,22 +19,18 @@ cflags-$(CONFIG_X86)		:= $(filter-out -mcmodel=kernel \
 				     $(PADDING_CFLAGS), $(cflags-y))
 cflags-$(CONFIG_X86_32)		+= -march=i386
 cflags-$(CONFIG_X86_64)		+= -mcmodel=small
-cflags-$(CONFIG_X86)		+= -fPIC $(DISABLE_KSTACK_ERASE)
+cflags-$(CONFIG_X86)		+= -fPIC
 # Nothing enables IBT while the stub runs, so ENDBR would only take space.
 cflags-$(CONFIG_X86)		+= $(call cc-option,-fcf-protection=none)
 
-# arm64 uses the full KBUILD_CFLAGS so it's necessary to explicitly
-# disable the stackleak plugin
-cflags-$(CONFIG_ARM64)		+= -fpie $(DISABLE_KSTACK_ERASE) \
-				   -fno-unwind-tables -fno-asynchronous-unwind-tables
+cflags-$(CONFIG_ARM64)		+= -fpie -fno-unwind-tables \
+				   -fno-asynchronous-unwind-tables
 cflags-$(CONFIG_ARM)		+= -DEFI_HAVE_STRLEN -DEFI_HAVE_STRNLEN \
 				   -DEFI_HAVE_MEMCHR -DEFI_HAVE_STRRCHR \
 				   -DEFI_HAVE_STRCMP -fno-builtin -fpic \
-				   $(call cc-option,-mno-single-pic-base) \
-				   $(DISABLE_KSTACK_ERASE)
-cflags-$(CONFIG_RISCV)		+= -fpic -DNO_ALTERNATIVE -mno-relax \
-				   $(DISABLE_KSTACK_ERASE)
-cflags-$(CONFIG_LOONGARCH)	+= -fpie $(DISABLE_KSTACK_ERASE)
+				   $(call cc-option,-mno-single-pic-base)
+cflags-$(CONFIG_RISCV)		+= -fpic -DNO_ALTERNATIVE -mno-relax
+cflags-$(CONFIG_LOONGARCH)	+= -fpie
 
 cflags-$(CONFIG_EFI_PARAMS_FROM_FDT)	+= -I$(srctree)/scripts/dtc/libfdt
 
@@ -44,6 +40,7 @@ KBUILD_CFLAGS			:= $(subst $(CC_FLAGS_FTRACE),,$(cflags-y)) \
 				   -D__NO_FORTIFY \
 				   -ffreestanding \
 				   -fno-stack-protector \
+				   $(DISABLE_KSTACK_ERASE) \
 				   $(call cc-option,-fno-addrsig) \
 				   -D__DISABLE_EXPORTS
 
-- 
2.55.0

