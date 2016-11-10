From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: [RFC PATCH v3 03/20] x86: Add the Secure Memory Encryption cpu feature
Date: Wed, 9 Nov 2016 18:34:59 -0600
Message-ID: <20161110003459.3280.25796.stgit@tlendack-t1.amdoffice.net>
References: <20161110003426.3280.2999.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20161110003426.3280.2999.stgit-qCXWGYdRb2BnqfbPTmsdiZQ+2ll4COg0XqFh9Ls21Oc@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Radim =?utf-8?b?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Update the cpu features to include identifying and reporting on the
Secure Memory Encryption feature.

Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
---
 arch/x86/include/asm/cpufeatures.h |    1 +
 arch/x86/kernel/cpu/scattered.c    |    1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index b212b86..f083ea1 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -187,6 +187,7 @@
  * Reuse free bits when adding new feature flags!
  */
 
+#define X86_FEATURE_SME		( 7*32+ 0) /* AMD Secure Memory Encryption */
 #define X86_FEATURE_CPB		( 7*32+ 2) /* AMD Core Performance Boost */
 #define X86_FEATURE_EPB		( 7*32+ 3) /* IA32_ENERGY_PERF_BIAS support */
 
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 8cb57df..d86d9a5 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -37,6 +37,7 @@ void init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 		{ X86_FEATURE_HW_PSTATE,	CR_EDX, 7, 0x80000007, 0 },
 		{ X86_FEATURE_CPB,		CR_EDX, 9, 0x80000007, 0 },
 		{ X86_FEATURE_PROC_FEEDBACK,	CR_EDX,11, 0x80000007, 0 },
+		{ X86_FEATURE_SME,		CR_EAX, 0, 0x8000001f, 0 },
 		{ 0, 0, 0, 0, 0 }
 	};
 
