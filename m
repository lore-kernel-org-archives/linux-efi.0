From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v11 3/5] x86/boot: Add get_acpi_rsdp() to parse RSDP in
 cmdlien from kexec
Date: Mon, 12 Nov 2018 17:50:51 +0800
Message-ID: <20181112095051.GA7453@localhost.localdomain>
References: <20181112094645.4879-1-fanc.fnst@cn.fujitsu.com>
 <20181112094645.4879-4-fanc.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181112094645.4879-4-fanc.fnst@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, msys.mizuma@gmail.com
Cc: indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

Hi Boris,

I try to include lib/kstrtox.c in arch/x86/boot/string.c and
define the kstrtoull() function in arch/x86/boot/string.h.
But the definition problem is hard to solve, so I include
it in arch/x86/boot/string.c directely.
Then use BOOT_STRING tag to cover other functions and only
kstrtoull() is exposed.
I am not sure whether this is OK.

Thanks,
Chao Fan

On Mon, Nov 12, 2018 at 05:46:43PM +0800, Chao Fan wrote:
>Imitate setup_acpi_rsdp() for the early_param of 'acpi_rsdp'.
>KEXEC writes the RSDP pointer to cmdline for EFI booting.
>So if 'acpi_rsdp' found in cmdline, use it directely.
>
>Since function kstrtoull() is needed, include it in
>arch/x86/boot/string.h. To solve the definition conflict
>problem, set BOOT_STRING tag to expose only kstrtoull() and
>functions used by it. Other functions in lib/kstrtox.c will
>be covered.
>
>Signed-off-by: Chao Fan <fanc.fnst@cn.fujitsu.com>
>---
> arch/x86/boot/compressed/acpitb.c | 26 ++++++++++++++++++++++++++
> arch/x86/boot/string.h            |  4 ++++
> lib/kstrtox.c                     |  4 ++++
> 3 files changed, 34 insertions(+)
>
>diff --git a/arch/x86/boot/compressed/acpitb.c b/arch/x86/boot/compressed/acpitb.c
>index 50fa65cf824d..5cfb4efa5a19 100644
>--- a/arch/x86/boot/compressed/acpitb.c
>+++ b/arch/x86/boot/compressed/acpitb.c
>@@ -8,6 +8,12 @@
> #include <linux/numa.h>
> #include <linux/acpi.h>
> 
>+#define STATIC
>+#include <linux/decompress/mm.h>
>+
>+#define BOOT_STRING
>+#include "../string.h"
>+
> /* Search EFI table for RSDP table. */
> static void efi_get_rsdp_addr(acpi_physical_address *rsdp_addr)
> {
>@@ -200,3 +206,23 @@ static void bios_get_rsdp_addr(acpi_physical_address *rsdp_addr)
> 		*rsdp_addr = (acpi_physical_address)address;
> 	}
> }
>+
>+static void get_acpi_rsdp(acpi_physical_address *rsdp_addr)
>+{
>+#ifdef CONFIG_KEXEC
>+	unsigned long long res;
>+	int len = 0;
>+	char *val;
>+
>+	val = malloc(19);
>+	len = cmdline_find_option("acpi_rsdp", val, 19);
>+
>+	if (len == -1)
>+		return;
>+
>+	if (len > 0) {
>+		val[len] = 0;
>+		*rsdp_addr = (acpi_physical_address)kstrtoull(val, 16, &res);
>+	}
>+#endif
>+}
>diff --git a/arch/x86/boot/string.h b/arch/x86/boot/string.h
>index 3d78e27077f4..0ff3edb888e4 100644
>--- a/arch/x86/boot/string.h
>+++ b/arch/x86/boot/string.h
>@@ -30,3 +30,7 @@ extern unsigned long long simple_strtoull(const char *cp, char **endp,
> 					  unsigned int base);
> 
> #endif /* BOOT_STRING_H */
>+
>+#ifdef BOOT_STRING
>+#include "../../../lib/kstrtox.c"
>+#endif
>diff --git a/lib/kstrtox.c b/lib/kstrtox.c
>index 1006bf70bf74..3804db9eed56 100644
>--- a/lib/kstrtox.c
>+++ b/lib/kstrtox.c
>@@ -126,6 +126,8 @@ int kstrtoull(const char *s, unsigned int base, unsigned long long *res)
> }
> EXPORT_SYMBOL(kstrtoull);
> 
>+#ifndef BOOT_STRING
>+
> /**
>  * kstrtoll - convert a string to a long long
>  * @s: The start of the string. The string must be null-terminated, and may also
>@@ -408,3 +410,5 @@ kstrto_from_user(kstrtou16_from_user,	kstrtou16,	u16);
> kstrto_from_user(kstrtos16_from_user,	kstrtos16,	s16);
> kstrto_from_user(kstrtou8_from_user,	kstrtou8,	u8);
> kstrto_from_user(kstrtos8_from_user,	kstrtos8,	s8);
>+
>+#endif
>-- 
>2.19.1
>
