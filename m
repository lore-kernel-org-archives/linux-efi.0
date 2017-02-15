From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: [PATCH V9 04/10] arm64: exception: handle Synchronous External Abort
Date: Wed, 15 Feb 2017 10:44:46 -0700
Message-ID: <1487180692-16732-5-git-send-email-tbaicar@codeaurora.org>
References: <1487180692-16732-1-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1487180692-16732-1-git-send-email-tbaicar@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org, Suzuki.Poulose@arm.com, punit.agrawal@arm.com, astone@redhat.com, harba@codeaur
Cc: Tyler Baicar <tbaicar@codeaurora.org>
List-Id: linux-efi@vger.kernel.org

SEA exceptions are often caused by an uncorrected hardware
error, and are handled when data abort and instruction abort
exception classes have specific values for their Fault Status
Code.
When SEA occurs, before killing the process, report the error
in the kernel logs.
Update fault_info[] with specific SEA faults so that the
new SEA handler is used.

Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
Signed-off-by: Naveen Kaje <nkaje@codeaurora.org>
Reviewed-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/esr.h |  1 +
 arch/arm64/mm/fault.c        | 43 +++++++++++++++++++++++++++++++++----------
 2 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index d14c478..f20c64a 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -83,6 +83,7 @@
 #define ESR_ELx_WNR		(UL(1) << 6)
 
 /* Shared ISS field definitions for Data/Instruction aborts */
+#define ESR_ELx_FnV		(UL(1) << 10)
 #define ESR_ELx_EA		(UL(1) << 9)
 #define ESR_ELx_S1PTW		(UL(1) << 7)
 
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 156169c..d178dc0 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -487,6 +487,29 @@ static int do_bad(unsigned long addr, unsigned int esr, struct pt_regs *regs)
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
+	pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
+		 fault_name(esr), esr, addr);
+
+	info.si_signo = SIGBUS;
+	info.si_errno = 0;
+	info.si_code  = 0;
+	if (esr & ESR_ELx_FnV)
+		info.si_addr = 0;
+	else
+		info.si_addr  = (void __user *)addr;
+	arm64_notify_die("", regs, &info, esr);
+
+	return 0;
+}
+
 static const struct fault_info {
 	int	(*fn)(unsigned long addr, unsigned int esr, struct pt_regs *regs);
 	int	sig;
@@ -509,22 +532,22 @@ static int do_bad(unsigned long addr, unsigned int esr, struct pt_regs *regs)
 	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 1 permission fault"	},
 	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 2 permission fault"	},
 	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 3 permission fault"	},
-	{ do_bad,		SIGBUS,  0,		"synchronous external abort"	},
+	{ do_sea,		SIGBUS,  0,		"synchronous external abort"	},
 	{ do_bad,		SIGBUS,  0,		"unknown 17"			},
 	{ do_bad,		SIGBUS,  0,		"unknown 18"			},
 	{ do_bad,		SIGBUS,  0,		"unknown 19"			},
-	{ do_bad,		SIGBUS,  0,		"synchronous external abort (translation table walk)" },
-	{ do_bad,		SIGBUS,  0,		"synchronous external abort (translation table walk)" },
-	{ do_bad,		SIGBUS,  0,		"synchronous external abort (translation table walk)" },
-	{ do_bad,		SIGBUS,  0,		"synchronous external abort (translation table walk)" },
-	{ do_bad,		SIGBUS,  0,		"synchronous parity error"	},
+	{ do_sea,		SIGBUS,  0,		"level 0 (translation table walk)"	},
+	{ do_sea,		SIGBUS,  0,		"level 1 (translation table walk)"	},
+	{ do_sea,		SIGBUS,  0,		"level 2 (translation table walk)"	},
+	{ do_sea,		SIGBUS,  0,		"level 3 (translation table walk)"	},
+	{ do_sea,		SIGBUS,  0,		"synchronous parity or ECC error" },
 	{ do_bad,		SIGBUS,  0,		"unknown 25"			},
 	{ do_bad,		SIGBUS,  0,		"unknown 26"			},
 	{ do_bad,		SIGBUS,  0,		"unknown 27"			},
-	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk)" },
-	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk)" },
-	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk)" },
-	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk)" },
+	{ do_sea,		SIGBUS,  0,		"level 0 synchronous parity error (translation table walk)"	},
+	{ do_sea,		SIGBUS,  0,		"level 1 synchronous parity error (translation table walk)"	},
+	{ do_sea,		SIGBUS,  0,		"level 2 synchronous parity error (translation table walk)"	},
+	{ do_sea,		SIGBUS,  0,		"level 3 synchronous parity error (translation table walk)"	},
 	{ do_bad,		SIGBUS,  0,		"unknown 32"			},
 	{ do_alignment_fault,	SIGBUS,  BUS_ADRALN,	"alignment fault"		},
 	{ do_bad,		SIGBUS,  0,		"unknown 34"			},
-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
