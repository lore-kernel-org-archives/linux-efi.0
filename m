From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH] efi/libstub: refactor cmd_stubcopy
Date: Tue, 12 Feb 2019 12:44:55 +0900
Message-ID: <1549943095-10956-1-git-send-email-yamada.masahiro@socionext.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-efi@vger.kernel.org, Kees Cook <keescook@chromium.org>, Alistair Strachan <astrachan@google.com>, Laura Abbott <labbott@redhat.com>, Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@kernel.org>, Nathan Chancellor <natechancellor@gmail.com>
List-Id: linux-efi@vger.kernel.org

It took me a while to understand what is going on in the nested
if-blocks.

Simplify it by removing unneeded code.

  - if_changed automatically adds 'set -e', so any failure in the
    series of commands makes it immediately fail as a whole.
    So, the outer if block is entirely redundant.

  - Since commit 9c2af1c7377a ("kbuild: add .DELETE_ON_ERROR special
    target"), GNU Make automatically deletes the target on any failure
    in its recipe. The explicit 'rm -f $@' is redundant.

  - surrounding commands with ( ) will spawn a subshell to execute them
    in it, but it is rarely useful to do so.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 drivers/firmware/efi/libstub/Makefile | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index d984509..7788e8a 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -86,12 +86,13 @@ $(obj)/%.stub.o: $(obj)/%.o FORCE
 # this time, use objcopy and leave all sections in place.
 #
 quiet_cmd_stubcopy = STUBCPY $@
-      cmd_stubcopy = if $(STRIP) --strip-debug $(STUBCOPY_RM-y) -o $@ $<; \
-		     then if $(OBJDUMP) -r $@ | grep $(STUBCOPY_RELOC-y); \
-		     then (echo >&2 "$@: absolute symbol references not allowed in the EFI stub"; \
-			   rm -f $@; /bin/false); 			  \
-		     else $(OBJCOPY) $(STUBCOPY_FLAGS-y) $< $@; fi	  \
-		     else /bin/false; fi
+      cmd_stubcopy =							\
+	$(STRIP) --strip-debug $(STUBCOPY_RM-y) -o $@ $<;		\
+	if $(OBJDUMP) -r $@ | grep $(STUBCOPY_RELOC-y); then		\
+		echo "$@: absolute symbol references not allowed in the EFI stub" >&2; \
+		/bin/false;						\
+	fi;								\
+	$(OBJCOPY) $(STUBCOPY_FLAGS-y) $< $@
 
 #
 # ARM discards the .data section because it disallows r/w data in the
-- 
2.7.4
