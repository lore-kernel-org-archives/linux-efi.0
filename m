From: Thomas Renninger <trenn-l3A5Bk7waGM@public.gmane.org>
Subject: [RFC] [PATCH] X86 MSR read whitelist
Date: Thu, 8 Nov 2012 15:19:23 +0100
Message-ID: <201211081519.23364.trenn@suse.de>
References: <1352323699-52400-1-git-send-email-trenn@suse.de> <20121107232722.67589868@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121107232722.67589868-38n7/U1jhRXW96NNrWNlrekiAK3p4hvP@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jlee-IBi9RG/b67k@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thursday, November 08, 2012 12:27:22 AM Alan Cox wrote:
> On Wed,  7 Nov 2012 22:28:17 +0100
> Thomas Renninger <trenn-l3A5Bk7waGM@public.gmane.org> wrote:
> 
> > Hi,
> > 
> > I have seen some patches in this area and I wonder whether MSR and EC
> > write accesses from userspace got closed already.
> 
> You need to cover read accesses as well I suspect to be completely
> paranoid safe.
I feared that this could be asked for...
While I am not aware of any userspace tools urgently needing MSR
write access, there are several userspace tools reading MSRs.

What exactly could go wrong with which MSR read?
I suggest to go for:
  - deny writing MSRs from userspace
  - allow reading MSRs from userspace
(via msr driver) for now.
In case there is urgent need for a whitelist, an implementation
example (some defines do not exist yet) is pasted in the end for
discussion (or picking up). Be careful, not well tested.

I just picked some MSRs I found in turbostat and cpupower.
Len: It would be great if you could contribute to cpupower.
It can do exactly the same than turbostat (but for all archs)
and the fixups you send for turbostat are very easy to integrate
into cpupower as well.

> I would also look at MTRRs because mis-setting MTRRs
> allows you to get firmware to do interesting things in certain
> situations because the commands being issued to stuff like the GPU may
> get corrupted.
I am not aware of a mtrr interface to userspace.

   Thomas


X86 msr: Secure boot restrict MSR reads by whitelisting safe ones

Signed-off-by: Thomas Renninger <trenn-l3A5Bk7waGM@public.gmane.org>
---
 arch/x86/kernel/msr.c           |    9 ++++-
 arch/x86/kernel/msr_whitelist.h |   75 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 3de9128..c7a6bb2 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -42,6 +42,8 @@
 #include <asm/processor.h>
 #include <asm/msr.h>
 
+#include "msr_whitelist.h"
+
 static struct class *msr_class;
 
 static loff_t msr_seek(struct file *file, loff_t offset, int orig)
@@ -76,8 +78,11 @@ static ssize_t msr_read(struct file *file, char __user *buf,
 	int err = 0;
 	ssize_t bytes = 0;
 
-	if (count % 8)
-		return -EINVAL;	/* Invalid chunk size */
+	if (count % 8 || reg == 0)
+		return -EINVAL;	/* Invalid chunk size or zero MSR */
+
+	if (!msr_is_allowed(reg, cpu))
+		return -EPERM;
 
 	for (; count; count -= 8) {
 		err = rdmsr_safe_on_cpu(cpu, reg, &data[0], &data[1]);
diff --git a/arch/x86/kernel/msr_whitelist.h b/arch/x86/kernel/msr_whitelist.h
new file mode 100644
index 0000000..940e05a
--- /dev/null
+++ b/arch/x86/kernel/msr_whitelist.h
@@ -0,0 +1,75 @@
+#ifndef X86_SECURE_MSR_WHITELIST_H
+#define X86_SECURE_MSR_WHITELIST_H
+
+#ifdef X86_SECURE_BOOT /* Does this exist? */
+
+#include <linux/capability.h>
+
+static u32 msr_generic_wl[] =
+	{
+		0x10, /* MSR_TSC */
+		0xe8, /* MSR_APERF */
+		0xe7, /* MSR_MPERF */
+		0x10, /* MSR_TSC */
+		0x34, /* MSR_SMI_COUNT */
+		0
+	};
+
+static u32 msr_amd_wl[] =
+	{
+		0xc0010063, /* MSR_AMD_PSTATE_STATUS */
+		0xc0010064, /* MSR_AMD_PSTATE */
+		0xc0010061, /* MSR_AMD_PSTATE_LIMIT */
+		0xc0010015, /* MSR_AMD_HWCR */
+		0
+	};
+
+static u32 msr_intel_wl[] =
+	{
+		0x198, /* MSR_IA32_PERF_STATUS */
+		0x1a0, /* MSR_IA32_MISC_ENABLES */
+		0x1b0, /* MSR_IA32_ENERGY_PERF_BIAS */
+		0xce,  /* MSR_NEHALEM_PLATFORM_INFO */
+		0x1ad, /* MSR_NEHALEM_TURBO_RATIO_LIMIT */
+		0x3f8, /* MSR_PKG_C3_RESIDENCY */
+		0x3f9, /* MSR_PKG_C6_RESIDENCY */
+		0x3fc, /* MSR_CORE_C3_RESIDENCY */
+		0x3fd, /* MSR_CORE_C6_RESIDENCY */
+		0
+	};
+
+static bool msr_is_allowed(u32 reg, int cpu)
+{
+	u32 *q;
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+
+	if (!capable(CAP_COMPROMISE_KERNEL))
+		return 1;
+
+	for (q = msr_generic_wl;*q != 0; q++) {
+		if (*q == reg)
+			return 1;
+	}
+	if (c->x86_vendor == X86_VENDOR_INTEL) {
+		for (q = msr_intel_wl;*q != 0; q++) {
+			if (*q == reg)
+				return 1;
+		}
+	} else if (c->x86_vendor == X86_VENDOR_AMD) {
+		for (q = msr_amd_wl;*q != 0; q++) {
+			if (*q == reg)
+				return 1;
+		}
+	}
+	return 0;
+}
+
+#else /* X86_SECURE_BOOT */
+
+static bool msr_is_allowed(u32 reg)
+{
+	return 1;
+}
+
+#endif /* X86_SECURE_BOOT */
+#endif /* X86_SECURE_MSR_WHITELIST_H */
