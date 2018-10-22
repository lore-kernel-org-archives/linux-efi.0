From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: [PATCH v10 2/7] x86/boot: Copy kstrtoull() to compressed period
Date: Mon, 22 Oct 2018 17:37:15 +0800
Message-ID: <20181022093720.21426-3-fanc.fnst@cn.fujitsu.com>
References: <20181022093720.21426-1-fanc.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181022093720.21426-1-fanc.fnst@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, msys.mizuma@gmail.com
Cc: indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com, fanc.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

kstrtoull() lives in 'uncompressed' period, used to
convert a string to an unsigned long long.
Copy to 'compressed' so that we can use it to
convert the memory address from sting to unsigned
long long in 'compressed' period.

Signed-off-by: Chao Fan <fanc.fnst@cn.fujitsu.com>
---
 arch/x86/boot/compressed/misc.c | 88 +++++++++++++++++++++++++++++++++
 arch/x86/boot/compressed/misc.h |  4 ++
 2 files changed, 92 insertions(+)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 8dd1d5ccae58..5b9b24949337 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -426,3 +426,91 @@ void fortify_panic(const char *name)
 {
 	error("detected buffer overflow");
 }
+
+#define KSTRTOX_OVERFLOW        (1U << 31)
+
+static inline char _tolower(const char c)
+{
+	return c | 0x20;
+}
+
+unsigned int
+_parse_integer(const char *s, unsigned int base, unsigned long long *p)
+{
+	unsigned long long res;
+	unsigned int rv;
+
+	res = 0;
+	rv = 0;
+	while (1) {
+		unsigned int c = *s;
+		unsigned int lc = c | 0x20; /* don't tolower() this line */
+		unsigned int val;
+
+		if ('0' <= c && c <= '9')
+			val = c - '0';
+		else if ('a' <= lc && lc <= 'f')
+			val = lc - 'a' + 10;
+		else
+			break;
+
+		if (val >= base)
+			break;
+		/*
+		 * Check for overflow only if we are within range of
+		 * it in the max base we support (16)
+		 */
+		if (unlikely(res & (~0ull << 60))) {
+			if (res > div_u64(ULLONG_MAX - val, base))
+				rv |= KSTRTOX_OVERFLOW;
+		}
+		res = res * base + val;
+		rv++;
+		s++;
+	}
+	*p = res;
+	return rv;
+}
+
+const char *_parse_integer_fixup_radix(const char *s, unsigned int *base)
+{
+	if (*base == 0) {
+		if (s[0] == '0') {
+			if (_tolower(s[1]) == 'x' && isxdigit(s[2]))
+				*base = 16;
+			else
+				*base = 8;
+		} else
+			*base = 10;
+	}
+	if (*base == 16 && s[0] == '0' && _tolower(s[1]) == 'x')
+		s += 2;
+	return s;
+}
+
+static int _kstrtoull(const char *s, unsigned int base, unsigned long long *res)
+{
+	unsigned long long _res;
+	unsigned int rv;
+
+	s = _parse_integer_fixup_radix(s, &base);
+	rv = _parse_integer(s, base, &_res);
+	if (rv & KSTRTOX_OVERFLOW)
+		return -ERANGE;
+	if (rv == 0)
+		return -EINVAL;
+	s += rv;
+	if (*s == '\n')
+		s++;
+	if (*s)
+		return -EINVAL;
+	*res = _res;
+	return 0;
+}
+
+int kstrtoull(const char *s, unsigned int base, unsigned long long *res)
+{
+	if (s[0] == '+')
+		s++;
+	return _kstrtoull(s, base, res);
+}
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 008fdc47a29c..40378408d980 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -63,6 +63,10 @@ static inline void debug_puthex(const char *s)
 
 #endif
 
+#if (defined CONFIG_RANDOMIZE_BASE) && (defined CONFIG_RANDOMIZE_BASE)
+int kstrtoull(const char *s, unsigned int base, unsigned long long *res);
+#endif
+
 #if CONFIG_EARLY_PRINTK || CONFIG_RANDOMIZE_BASE
 /* cmdline.c */
 int cmdline_find_option(const char *option, char *buffer, int bufsize);
-- 
2.17.2
