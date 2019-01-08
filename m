From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.20 041/117] efi/libstub: Disable some warnings for x86{,_64}
Date: Tue,  8 Jan 2019 14:25:09 -0500
Message-ID: <20190108192628.121270-41-sashal@kernel.org>
References: <20190108192628.121270-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190108192628.121270-1-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nathan Chancellor <natechancellor@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andy Lutomirski <luto@kernel.org>, Arend van Spriel <arend.vanspriel@broadcom.com>, Bhupesh Sharma <bhsharma@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>, Eric Snowberg <eric.snowberg@oracle.com>, Hans de Goede <hdegoede@redhat.com>, Joe Perches <joe@perches.com>, Jon Hunter <jonathanh@nvidia.com>, Julien Thierry <julien.thierry@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>, Marc Zyngier <marc.zyngier@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Zijlstra <peterz@infradead.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Thomas Gleixner <tglx@linutronix.de>, YiFei Zhu <zhuyifei1999@gma>
List-Id: linux-efi@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 3db5e0ba8b8f4aee631d7ee04b7a11c56cfdc213 ]

When building the kernel with Clang, some disabled warnings appear
because this Makefile overrides KBUILD_CFLAGS for x86{,_64}. Add them to
this list so that the build is clean again.

-Wpointer-sign was disabled for the whole kernel before the beginning of Git history.

-Waddress-of-packed-member was disabled for the whole kernel and for
the early boot code in these commits:

  bfb38988c51e ("kbuild: clang: Disable 'address-of-packed-member' warning")
  20c6c1890455 ("x86/boot: Disable the address-of-packed-member compiler warning").

-Wgnu was disabled for the whole kernel and for the early boot code in
these commits:

  61163efae020 ("kbuild: LLVMLinux: Add Kbuild support for building kernel with Clang")
  6c3b56b19730 ("x86/boot: Disable Clang warnings about GNU extensions").

 [ mingo: Made the changelog more readable. ]

Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Eric Snowberg <eric.snowberg@oracle.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jon Hunter <jonathanh@nvidia.com>
Cc: Julien Thierry <julien.thierry@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: YiFei Zhu <zhuyifei1999@gmail.com>
Cc: linux-efi@vger.kernel.org
Link: http://lkml.kernel.org/r/20181129171230.18699-8-ard.biesheuvel@linaro.org
Link: https://github.com/ClangBuiltLinux/linux/issues/112
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index c51627660dbb..d9845099635e 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -9,7 +9,10 @@ cflags-$(CONFIG_X86_32)		:= -march=i386
 cflags-$(CONFIG_X86_64)		:= -mcmodel=small
 cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ -O2 \
 				   -fPIC -fno-strict-aliasing -mno-red-zone \
-				   -mno-mmx -mno-sse -fshort-wchar
+				   -mno-mmx -mno-sse -fshort-wchar \
+				   -Wno-pointer-sign \
+				   $(call cc-disable-warning, address-of-packed-member) \
+				   $(call cc-disable-warning, gnu)
 
 # arm64 uses the full KBUILD_CFLAGS so it's necessary to explicitly
 # disable the stackleak plugin
-- 
2.19.1
