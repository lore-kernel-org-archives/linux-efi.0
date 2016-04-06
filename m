From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: [PATCH V2 4/9] arm64: exception: handle Synchronous External Abort
Date: Wed,  6 Apr 2016 09:12:53 -0600
Message-ID: <1459955578-24602-5-git-send-email-tbaicar@codeaurora.org>
References: <1459955578-24602-1-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1459955578-24602-1-git-send-email-tbaicar@codeaurora.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: fu.wei@linaro.org, timur@codeaurora.org, harba@codeaurora.org, rruigrok@codeaurora.org, ahs3@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org
Cc: Naveen Kaje <nkaje@codeaurora.org>, Tyler Baicar <tbaicar@codeaurora.org>, "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
List-Id: linux-efi@vger.kernel.org

SEA exceptions are often caused by an uncorrected hardware
error, and are handled when data abort and instruction abort
exception classes have specific values for their Fault Status
Code.
When SEA occurs, before killing the process, go through
the handlers registered in the notification list.
Update fault_info[] with specific SEA faults so that the
new SEA handler is used.

Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
Signed-off-by: Naveen Kaje <nkaje@codeaurora.org>
---
 arch/arm64/include/asm/system_misc.h | 13 ++++++++
 arch/arm64/mm/fault.c                | 58 +++++++++++++++++++++++++++++-------
 2 files changed, 61 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/system_misc.h b/arch/arm64/include/asm/system_misc.h
index 57f110b..90daf4a 100644
--- a/arch/arm64/include/asm/system_misc.h
+++ b/arch/arm64/include/asm/system_misc.h
@@ -64,4 +64,17 @@ extern void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
 
 #endif	/* __ASSEMBLY__ */
 
+/*
+ * The functions below are used to register and unregister callbacks
+ * that are to be invoked when a Synchronous External Abort (SEA)
+ * occurs. An SEA is raised by certain fault status codes that have
+ * either data or instruction abort as the exception class, and
+ * callbacks may be registered to parse or handle such hardware errors.
+ *
+ * Registered callbacks are run in an interrupt/atomic context. They
+ * are not allowed to block or sleep.
+ */
+int sea_register_handler_chain(struct notifier_block *nb);
+void sea_unregister_handler_chain(struct notifier_block *nb);
+
 #endif	/* __ASM_SYSTEM_MISC_H */
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 95df28b..04a25e8 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -39,6 +39,22 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 
+/*
+ * GHES SEA handler code may register a notifier call here to
+ * handle HW error record passed from platform.
+ */
+static ATOMIC_NOTIFIER_HEAD(sea_handler_chain);
+
+int sea_register_handler_chain(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&sea_handler_chain, nb);
+}
+
+void sea_unregister_handler_chain(struct notifier_block *nb)
+{
+	atomic_notifier_chain_unregister(&sea_handler_chain, nb);
+}
+
 static const char *fault_name(unsigned int esr);
 
 /*
@@ -395,6 +411,28 @@ static int do_bad(unsigned long addr, unsigned int esr, struct pt_regs *regs)
 	return 1;
 }
 
+/*
+ * This abort handler deals with Synchronous External Abort.
+ * It calls notifiers, and then returns "fault".
+ */
+static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
+{
+	struct siginfo info;
+
+	atomic_notifier_call_chain(&sea_handler_chain, 0, NULL);
+
+	pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
+		 fault_name(esr), esr, addr);
+
+	info.si_signo = SIGBUS;
+	info.si_errno = 0;
+	info.si_code  = 0;
+	info.si_addr  = (void __user *)addr;
+	arm64_notify_die("", regs, &info, esr);
+
+	return 0;
+}
+
 static struct fault_info {
 	int	(*fn)(unsigned long addr, unsigned int esr, struct pt_regs *regs);
 	int	sig;
@@ -417,22 +455,22 @@ static struct fault_info {
 	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 1 permission fault"	},
 	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 2 permission fault"	},
 	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 3 permission fault"	},
-	{ do_bad,		SIGBUS,  0,		"synchronous external abort"	},
+	{ do_sea,		SIGBUS,  0,		"synchronous external abort"	},
 	{ do_bad,		SIGBUS,  0,		"unknown 17"			},
 	{ do_bad,		SIGBUS,  0,		"unknown 18"			},
 	{ do_bad,		SIGBUS,  0,		"unknown 19"			},
-	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
-	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
-	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
-	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
-	{ do_bad,		SIGBUS,  0,		"synchronous parity error"	},
+	{ do_sea,		SIGBUS,  0,		"level 0 SEA (trans tbl walk)"	},
+	{ do_sea,		SIGBUS,  0,		"level 1 SEA (trans tbl walk)"	},
+	{ do_sea,		SIGBUS,  0,		"level 2 SEA (trans tbl walk)"	},
+	{ do_sea,		SIGBUS,  0,		"level 3 SEA (trans tbl walk)"	},
+	{ do_sea,		SIGBUS,  0,		"synchronous parity or ECC err" },
 	{ do_bad,		SIGBUS,  0,		"unknown 25"			},
 	{ do_bad,		SIGBUS,  0,		"unknown 26"			},
 	{ do_bad,		SIGBUS,  0,		"unknown 27"			},
-	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk)" },
-	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk)" },
-	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk)" },
-	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk)" },
+	{ do_sea,		SIGBUS,  0,		"level 0 synch parity error"	},
+	{ do_sea,		SIGBUS,  0,		"level 1 synch parity error"	},
+	{ do_sea,		SIGBUS,  0,		"level 2 synch parity error"	},
+	{ do_sea,		SIGBUS,  0,		"level 3 synch parity error"	},
 	{ do_bad,		SIGBUS,  0,		"unknown 32"			},
 	{ do_alignment_fault,	SIGBUS,  BUS_ADRALN,	"alignment fault"		},
 	{ do_bad,		SIGBUS,  0,		"unknown 34"			},
-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
