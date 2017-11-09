From: David Howells <dhowells@redhat.com>
Subject: [PATCH 26/30] Lock down ftrace
Date: Thu,  9 Nov 2017 17:33:56 +0000
Message-ID: <151024883613.28329.14808632296386937974.stgit@warthog.procyon.org.uk>
References: <151024863544.28329.2436580122759221600.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <151024863544.28329.2436580122759221600.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-security-module@vger.kernel.org
Cc: gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, dhowells@redhat.com, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

Disallow the use of ftrace when the kernel is locked down.  This patch
turns off ftrace_enabled late in the kernel boot so that the selftest can
still be potentially be run.

The sysctl that controls ftrace_enables is also disallowed when the kernel
is locked down.  If the lockdown is lifted, then the sysctl can be used to
reenable ftrace - if ftrace was compiled with CONFIG_DYNAMIC_FTRACE, that
is; if it wasn't then it won't be possible to reenable it.

This prevents crypto data theft by analysis of execution patterns, and, if
in future ftrace also logs the register contents at the time, will prevent
data theft by that mechanism also.

Reported-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/trace/ftrace.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6abfafd7f173..9c7135963d80 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -6508,6 +6508,9 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 {
 	int ret = -ENODEV;
 
+	if (kernel_is_locked_down("Use of ftrace"))
+		return -EPERM;
+
 	mutex_lock(&ftrace_lock);
 
 	if (unlikely(ftrace_disabled))
@@ -6896,3 +6899,22 @@ void ftrace_graph_exit_task(struct task_struct *t)
 	kfree(ret_stack);
 }
 #endif
+
+#ifdef CONFIG_LOCK_DOWN_KERNEL
+static int __init ftrace_lock_down(void)
+{
+	mutex_lock(&ftrace_lock);
+
+	if (!ftrace_disabled && ftrace_enabled &&
+	    kernel_is_locked_down("Use of ftrace")) {
+		ftrace_enabled = false;
+		last_ftrace_enabled = false;
+		ftrace_trace_function = ftrace_stub;
+		ftrace_shutdown_sysctl();
+	}
+
+	mutex_unlock(&ftrace_lock);
+	return 0;
+}
+late_initcall(ftrace_lock_down);
+#endif
