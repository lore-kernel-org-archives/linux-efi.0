From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v11 3/5] x86/boot: Add get_acpi_rsdp() to parse RSDP in
 cmdlien from kexec
Date: Tue, 13 Nov 2018 22:51:56 +0100
Message-ID: <20181113215156.GP10502@zn.tnic>
References: <20181112094645.4879-1-fanc.fnst@cn.fujitsu.com>
 <20181112094645.4879-4-fanc.fnst@cn.fujitsu.com>
 <20181112174343.mvjri2okwboew2nw@gabell>
 <20181113021218.GD7453@localhost.localdomain>
 <20181113161111.6jwm36fpxk5xjtn5@gabell>
 <20181113175413.GL10502@zn.tnic>
 <20181113200615.7dypqvhimxzlloek@gabell>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181113200615.7dypqvhimxzlloek@gabell>
Sender: linux-kernel-owner@vger.kernel.org
To: Masayoshi Mizuma <msys.mizuma@gmail.com>, Chao Fan <fanc.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 13, 2018 at 03:06:16PM -0500, Masayoshi Mizuma wrote:
> I just felt the BOOT_STRING thing in lib/kstrtox.c confuses...
> I'm OK for now if it's applied your below comment.

Well, actually, upon a second look, I don't think that including a .c
file into a header is ok:

diff --git a/arch/x86/boot/string.h b/arch/x86/boot/string.h
index 3d78e27077f4..0ff3edb888e4 100644
--- a/arch/x86/boot/string.h
+++ b/arch/x86/boot/string.h
@@ -30,3 +30,7 @@ extern unsigned long long simple_strtoull(const char *cp, char **endp,
                                          unsigned int base);

 #endif /* BOOT_STRING_H */
+
+#ifdef BOOT_STRING
+#include "../../../lib/kstrtox.c"
+#endif

Chao, why isn't this part of arch/x86/boot/compressed/misc.c ?

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
