From: Florent Revest <florent.revest@arm.com>
Subject: [RFC 02/11] KVM: arm64: Return an Unknown ID on unhandled HVC
Date: Fri, 25 Aug 2017 09:31:32 +0100
Message-ID: <1503649901-5834-3-git-send-email-florent.revest@arm.com>
References: <1503649901-5834-1-git-send-email-florent.revest@arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1503649901-5834-1-git-send-email-florent.revest@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, christoffer.dall@linaro.org, catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, marc.zyngier@arm.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, leif.lindholm@arm.com, revestflo@gmail.com, Florent Revest <florent.revest@arm.com>
List-Id: linux-efi@vger.kernel.org

So far, when the KVM hypervisor received an hvc from a guest, it only
routed the hypercall to the PSCI calls handler. If the function ID of the
hypercall wouldn't be supported by the PSCI code, a PSCI_RET_NOT_SUPPORTED
error code would be returned in x0.

This patch introduces a kvm_psci_is_call() check which is verified before
entering the PSCI calls handling code. The HVC is now only routed to the
PSCI code if its function ID is in the ranges of PSCI functions defined by
SMCCC (0x84000000-0x8400001f and 0xc4000000-0xc400001f).

If the function ID is not in those ranges, an Unknown Function Identifier
is returned in x0. This implements the behavior defined by SMCCC and paves
the way for other hvc handlers.

Signed-off-by: Florent Revest <florent.revest@arm.com>
---
 arch/arm/include/asm/kvm_psci.h   |  1 +
 arch/arm64/include/asm/kvm_psci.h |  1 +
 arch/arm64/kvm/handle_exit.c      | 24 ++++++++++++++++++------
 include/uapi/linux/psci.h         |  2 ++
 virt/kvm/arm/psci.c               | 21 +++++++++++++++++++++
 5 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/kvm_psci.h b/arch/arm/include/asm/kvm_psc=
i.h
index 6bda945..8dcd642 100644
--- a/arch/arm/include/asm/kvm_psci.h
+++ b/arch/arm/include/asm/kvm_psci.h
@@ -22,6 +22,7 @@
 #define KVM_ARM_PSCI_0_2       2

 int kvm_psci_version(struct kvm_vcpu *vcpu);
+bool kvm_psci_is_call(struct kvm_vcpu *vcpu);
 int kvm_psci_call(struct kvm_vcpu *vcpu);

 #endif /* __ARM_KVM_PSCI_H__ */
diff --git a/arch/arm64/include/asm/kvm_psci.h b/arch/arm64/include/asm/kvm=
_psci.h
index bc39e55..1a28809 100644
--- a/arch/arm64/include/asm/kvm_psci.h
+++ b/arch/arm64/include/asm/kvm_psci.h
@@ -22,6 +22,7 @@
 #define KVM_ARM_PSCI_0_2       2

 int kvm_psci_version(struct kvm_vcpu *vcpu);
+bool kvm_psci_is_call(struct kvm_vcpu *vcpu);
 int kvm_psci_call(struct kvm_vcpu *vcpu);

 #endif /* __ARM64_KVM_PSCI_H__ */
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 17d8a16..bc7ade5 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -21,6 +21,7 @@

 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
+#include <linux/smccc_fn.h>

 #include <asm/esr.h>
 #include <asm/kvm_asm.h>
@@ -34,19 +35,30 @@

 typedef int (*exit_handle_fn)(struct kvm_vcpu *, struct kvm_run *);

+/*
+ * handle_hvc - handle a guest hypercall
+ *
+ * @vcpu:      the vcpu pointer
+ * @run:       access to the kvm_run structure for results
+ *
+ * Route a given hypercall to its right HVC handler thanks to its function=
 ID.
+ * If no corresponding handler is found, write an Unknown ID in x0 (cf. SM=
CCC).
+ *
+ * This function returns: > 0 (success), 0 (success but exit to user
+ * space), and < 0 (errors)
+ */
 static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
-       int ret;
+       int ret =3D 1;

        trace_kvm_hvc_arm64(*vcpu_pc(vcpu), vcpu_get_reg(vcpu, 0),
                            kvm_vcpu_hvc_get_imm(vcpu));
        vcpu->stat.hvc_exit_stat++;

-       ret =3D kvm_psci_call(vcpu);
-       if (ret < 0) {
-               kvm_inject_undefined(vcpu);
-               return 1;
-       }
+       if (kvm_psci_is_call(vcpu))
+               ret =3D kvm_psci_call(vcpu);
+       else
+               vcpu_set_reg(vcpu, 0, SMCCC_STD_RET_UNKNOWN_ID);

        return ret;
 }
diff --git a/include/uapi/linux/psci.h b/include/uapi/linux/psci.h
index 3d7a0fc..79704fe 100644
--- a/include/uapi/linux/psci.h
+++ b/include/uapi/linux/psci.h
@@ -24,10 +24,12 @@
 /* PSCI v0.2 interface */
 #define PSCI_0_2_FN_BASE                       0x84000000
 #define PSCI_0_2_FN(n)                         (PSCI_0_2_FN_BASE + (n))
+#define PSCI_0_2_FN_END                                PSCI_0_2_FN(0x1F)
 #define PSCI_0_2_64BIT                         0x40000000
 #define PSCI_0_2_FN64_BASE                     \
                                        (PSCI_0_2_FN_BASE + PSCI_0_2_64BIT)
 #define PSCI_0_2_FN64(n)                       (PSCI_0_2_FN64_BASE + (n))
+#define PSCI_0_2_FN64_END                      PSCI_0_2_FN64(0x1F)

 #define PSCI_0_2_FN_PSCI_VERSION               PSCI_0_2_FN(0)
 #define PSCI_0_2_FN_CPU_SUSPEND                        PSCI_0_2_FN(1)
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index f1e363b..9602894 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -332,3 +332,24 @@ int kvm_psci_call(struct kvm_vcpu *vcpu)
                return -EINVAL;
        };
 }
+
+/**
+ * kvm_psci_is_call - checks if a HVC function ID is in a PSCI range
+ * @vcpu: Pointer to the VCPU struct
+ *
+ * When a hypercall is received from a guest. The SMCCC defines a function=
 ID
+ * as a value to be put in x0 to identify the destination of the call. The=
 same
+ * document defines ranges of function IDs to be used by PSCI. This functi=
on
+ * checks whether a given vcpu is requesting a PSCI related handler.
+ *
+ * This function returns:
+ *  - true if this HVC should be handled by kvm_psci_call
+ *  - false if it shouldn't
+ */
+inline bool kvm_psci_is_call(struct kvm_vcpu *vcpu)
+{
+       unsigned long fn =3D vcpu_get_reg(vcpu, 0) & ~((u32) 0);
+
+       return ((fn >=3D PSCI_0_2_FN_BASE   && fn <=3D PSCI_0_2_FN_END) ||
+               (fn >=3D PSCI_0_2_FN64_BASE && fn <=3D PSCI_0_2_FN64_END));
+}
--
1.9.1

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
