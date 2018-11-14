From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v11 3/5] x86/boot: Add get_acpi_rsdp() to parse RSDP in
 cmdlien from kexec
Date: Wed, 14 Nov 2018 14:12:16 +0800
Message-ID: <20181114061215.GC2875@localhost.localdomain>
References: <20181112094645.4879-1-fanc.fnst@cn.fujitsu.com>
 <20181112094645.4879-4-fanc.fnst@cn.fujitsu.com>
 <20181112174343.mvjri2okwboew2nw@gabell>
 <20181113021218.GD7453@localhost.localdomain>
 <20181113161111.6jwm36fpxk5xjtn5@gabell>
 <20181113175413.GL10502@zn.tnic>
 <20181113200615.7dypqvhimxzlloek@gabell>
 <20181113215156.GP10502@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181113215156.GP10502@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Masayoshi Mizuma <msys.mizuma@gmail.com>, linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

Hi Boris, Masa, and Baoquan,

On Tue, Nov 13, 2018 at 10:51:56PM +0100, Borislav Petkov wrote:
>On Tue, Nov 13, 2018 at 03:06:16PM -0500, Masayoshi Mizuma wrote:
>> I just felt the BOOT_STRING thing in lib/kstrtox.c confuses...
>> I'm OK for now if it's applied your below comment.
>
>Well, actually, upon a second look, I don't think that including a .c
>file into a header is ok:
>
>diff --git a/arch/x86/boot/string.h b/arch/x86/boot/string.h
>index 3d78e27077f4..0ff3edb888e4 100644
>--- a/arch/x86/boot/string.h
>+++ b/arch/x86/boot/string.h
>@@ -30,3 +30,7 @@ extern unsigned long long simple_strtoull(const char *cp, char **endp,
>                                          unsigned int base);
>
> #endif /* BOOT_STRING_H */
>+
>+#ifdef BOOT_STRING
>+#include "../../../lib/kstrtox.c"
>+#endif
>
>Chao, why isn't this part of arch/x86/boot/compressed/misc.c ?
>

Fine, I have put it to misc.c:

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 8dd1d5ccae58..714b05b65a33 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -426,3 +426,7 @@ void fortify_panic(const char *name)
 {
        error("detected buffer overflow");
 }
+
+#ifdef BOOT_STRING
+#include "../../../../lib/kstrtox.c"
+#endif

And define it in misc.h:

diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 4a3645fda0ed..98e28c4281ee 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -131,3 +131,5 @@ int num_immovable_mem;
 void get_immovable_mem(void);
 #endif
 #endif
+#define BOOT_STRING
+extern int kstrtoull(const char *s, unsigned int base, unsigned long long *res);

But isdigit() would be redefine, so:

diff --git a/include/linux/ctype.h b/include/linux/ctype.h
index 363b004426db..aba01c385232 100644
--- a/include/linux/ctype.h
+++ b/include/linux/ctype.h
@@ -23,10 +23,12 @@ extern const unsigned char _ctype[];
 #define isalnum(c)     ((__ismask(c)&(_U|_L|_D)) != 0)
 #define isalpha(c)     ((__ismask(c)&(_U|_L)) != 0)
 #define iscntrl(c)     ((__ismask(c)&(_C)) != 0)
+#ifndef BOOT_STRING
 static inline int isdigit(int c)
 {
        return '0' <= c && c <= '9';
 }
+#endif
 #define isgraph(c)     ((__ismask(c)&(_P|_U|_L|_D)) != 0)
 #define islower(c)     ((__ismask(c)&(_L)) != 0)
 #define isprint(c)     ((__ismask(c)&(_P|_U|_L|_D|_SP)) != 0)

Now I can make it.
I wonder whether this is OK to cover isdigit() with 'BOOT_STRING' tag.

Thanks,
Chao Fan

>-- 
>Regards/Gruss,
>    Boris.
>
>Good mailing practices for 400: avoid top-posting and trim the reply.
>
>
