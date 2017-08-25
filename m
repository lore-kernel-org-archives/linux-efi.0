From: Florent Revest <florent.revest@arm.com>
Subject: [RFC 08/11] KVM, arm, arm64: Initialize KVM's core earlier
Date: Fri, 25 Aug 2017 09:31:38 +0100
Message-ID: <1503649901-5834-9-git-send-email-florent.revest@arm.com>
References: <1503649901-5834-1-git-send-email-florent.revest@arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503649901-5834-1-git-send-email-florent.revest@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, christoffer.dall@linaro.org, catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, marc.zyngier@arm.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, leif.lindholm@arm.com, revestflo@gmail.com, Florent Revest <florent.revest@arm.com>
List-Id: linux-efi@vger.kernel.org

In order to use internal VMs early in the boot process, the arm_init
function, in charge of initializing KVM, is split in two parts:
 - A subsys_initcall target initializing KVM's core only
 - A module_init target initializing KVM's userspace facing files

An implicit dependency of VM execution on arm and arm64, the
initialization of KVM system registers, is also rescheduled to be
effective as soon as KVM's core is initialized.

Signed-off-by: Florent Revest <florent.revest@arm.com>
---
 arch/arm/include/asm/kvm_coproc.h    |  3 +++
 arch/arm/include/asm/kvm_host.h      |  1 +
 arch/arm/kvm/coproc.c                |  6 ++++++
 arch/arm/kvm/coproc_a15.c            |  3 +--
 arch/arm/kvm/coproc_a7.c             |  3 +--
 arch/arm64/include/asm/kvm_host.h    |  1 +
 arch/arm64/kvm/sys_regs_generic_v8.c |  8 ++++++--
 virt/kvm/arm/arm.c                   | 13 +++++++++++--
 8 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/arch/arm/include/asm/kvm_coproc.h b/arch/arm/include/asm/kvm_c=
oproc.h
index e74ab0f..1502723 100644
--- a/arch/arm/include/asm/kvm_coproc.h
+++ b/arch/arm/include/asm/kvm_coproc.h
@@ -45,4 +45,7 @@ struct kvm_coproc_target_table {
 int kvm_arm_coproc_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg=
 *);
 int kvm_arm_coproc_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg=
 *);
 unsigned long kvm_arm_num_coproc_regs(struct kvm_vcpu *vcpu);
+
+int coproc_a15_init(void);
+int coproc_a7_init(void);
 #endif /* __ARM_KVM_COPROC_H__ */
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_hos=
t.h
index 127e2dd..fb94666 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -287,6 +287,7 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu=
 *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}

+void kvm_arm_init_sys_reg(void);
 static inline void kvm_arm_init_debug(void) {}
 static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 6d1d2e2..28bc397 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -1369,3 +1369,9 @@ void kvm_reset_coprocs(struct kvm_vcpu *vcpu)
                if (vcpu_cp15(vcpu, num) =3D=3D 0x42424242)
                        panic("Didn't reset vcpu_cp15(vcpu, %zi)", num);
 }
+
+void kvm_arm_init_sys_reg(void)
+{
+       coproc_a7_init();
+       coproc_a15_init();
+}
diff --git a/arch/arm/kvm/coproc_a15.c b/arch/arm/kvm/coproc_a15.c
index a713675..83102a3 100644
--- a/arch/arm/kvm/coproc_a15.c
+++ b/arch/arm/kvm/coproc_a15.c
@@ -43,9 +43,8 @@
        .num =3D ARRAY_SIZE(a15_regs),
 };

-static int __init coproc_a15_init(void)
+int coproc_a15_init(void)
 {
        kvm_register_target_coproc_table(&a15_target_table);
        return 0;
 }
-late_initcall(coproc_a15_init);
diff --git a/arch/arm/kvm/coproc_a7.c b/arch/arm/kvm/coproc_a7.c
index b19e46d..b365ac0 100644
--- a/arch/arm/kvm/coproc_a7.c
+++ b/arch/arm/kvm/coproc_a7.c
@@ -46,9 +46,8 @@
        .num =3D ARRAY_SIZE(a7_regs),
 };

-static int __init coproc_a7_init(void)
+int coproc_a7_init(void)
 {
        kvm_register_target_coproc_table(&a7_target_table);
        return 0;
 }
-late_initcall(coproc_a7_init);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index 07b7460..e360bb3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -374,6 +374,7 @@ static inline void kvm_arch_vcpu_block_finish(struct kv=
m_vcpu *vcpu) {}

 int kvm_arm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init);

+void kvm_arm_init_sys_reg(void);
 void kvm_arm_init_debug(void);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs=
_generic_v8.c
index 969ade1..0fe755d 100644
--- a/arch/arm64/kvm/sys_regs_generic_v8.c
+++ b/arch/arm64/kvm/sys_regs_generic_v8.c
@@ -72,7 +72,7 @@ static void reset_actlr(struct kvm_vcpu *vcpu, const stru=
ct sys_reg_desc *r)
        },
 };

-static int __init sys_reg_genericv8_init(void)
+static int sys_reg_genericv8_init(void)
 {
        unsigned int i;

@@ -95,4 +95,8 @@ static int __init sys_reg_genericv8_init(void)

        return 0;
 }
-late_initcall(sys_reg_genericv8_init);
+
+void kvm_arm_init_sys_reg(void)
+{
+       sys_reg_genericv8_init();
+}
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index aa29a5d..7d0aa4f 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1451,6 +1451,8 @@ int kvm_arch_init(void *opaque)
        int err;
        int ret, cpu;

+       kvm_arm_init_sys_reg();
+
        if (!is_hyp_mode_available()) {
                kvm_err("HYP mode not available\n");
                return -ENODEV;
@@ -1496,8 +1498,15 @@ void kvm_arch_exit(void)

 static int arm_init(void)
 {
-       int rc =3D kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
+       int rc =3D kvm_init(NULL, sizeof(struct kvm_vcpu), 0, NULL);
        return rc;
 }

-module_init(arm_init);
+subsys_initcall(arm_init);
+
+static int arm_module_init(void)
+{
+       return kvm_set_module(THIS_MODULE);
+}
+
+module_init(arm_module_init);
--
1.9.1

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
