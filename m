From: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 2/5] x86, fpu: Extend the use of static_cpu_has_safe
Date: Thu, 27 Mar 2014 15:10:40 -0700
Message-ID: <1395958243-14458-3-git-send-email-ricardo.neri-calderon@linux.intel.com>
References: <1395958243-14458-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395958243-14458-1-git-send-email-ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

It may be necessary to save and restore the FPU context during EFI runtime
system services calls. However, this may happen during boot and before
alternatives have run. Thus, we need to use static_cpu_has_safe instead.

The rationale behind the use of static_cpu_has_safe is the same as in
commit 5f8c4218148822fde6ee ("x86, fpu: Use static_cpu_has_safe
before alternatives") by Borislav Petkov.

Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 arch/x86/include/asm/fpu-internal.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index cea1c76..115e368 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -87,22 +87,22 @@ static inline int is_x32_frame(void)
 
 static __always_inline __pure bool use_eager_fpu(void)
 {
-	return static_cpu_has(X86_FEATURE_EAGER_FPU);
+	return static_cpu_has_safe(X86_FEATURE_EAGER_FPU);
 }
 
 static __always_inline __pure bool use_xsaveopt(void)
 {
-	return static_cpu_has(X86_FEATURE_XSAVEOPT);
+	return static_cpu_has_safe(X86_FEATURE_XSAVEOPT);
 }
 
 static __always_inline __pure bool use_xsave(void)
 {
-	return static_cpu_has(X86_FEATURE_XSAVE);
+	return static_cpu_has_safe(X86_FEATURE_XSAVE);
 }
 
 static __always_inline __pure bool use_fxsr(void)
 {
-        return static_cpu_has(X86_FEATURE_FXSR);
+	return static_cpu_has_safe(X86_FEATURE_FXSR);
 }
 
 static inline void fx_finit(struct i387_fxsave_struct *fx)
@@ -293,7 +293,7 @@ static inline int restore_fpu_checking(struct task_struct *tsk)
 	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
 	   is pending.  Clear the x87 state here by setting it to fixed
 	   values. "m" is a random variable that should be in L1 */
-	if (unlikely(static_cpu_has(X86_FEATURE_FXSAVE_LEAK))) {
+	if (unlikely(static_cpu_has_safe(X86_FEATURE_FXSAVE_LEAK))) {
 		asm volatile(
 			"fnclex\n\t"
 			"emms\n\t"
-- 
1.8.1.2
