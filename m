From: Florent Revest <florent.revest@arm.com>
Subject: [RFC 06/11] KVM, arm64: Expose a VCPU initialization function
Date: Fri, 25 Aug 2017 09:31:36 +0100
Message-ID: <1503649901-5834-7-git-send-email-florent.revest@arm.com>
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

KVM's core now offers internal virtual machine capabilities, however on ARM
the KVM_ARM_VCPU_INIT ioctl also has to be used to initialize a virtual CPU

This patch exposes a kvm_arm_vcpu_init() function to the rest of the kernel
on arm64 so that it can be used for arm64 internal VM initialization.

This function actually used to be named kvm_arch_vcpu_ioctl_vcpu_init() but
the "ioctl" part of the name wasn't consistent with the rest of the KVM arm
ioctl handlers. Moreover, it wasn't relevant to the usage of internal VMs.
Therefore it has been decided to rename the function to make it less
misleading.

Signed-off-by: Florent Revest <florent.revest@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 ++
 virt/kvm/arm/arm.c                | 5 ++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index 65aab35..07b7460 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -372,6 +372,8 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu=
 *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}

+int kvm_arm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init);
+
 void kvm_arm_init_debug(void);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index a39a1e1..aa29a5d 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -888,8 +888,7 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 }


-static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
-                                        struct kvm_vcpu_init *init)
+int kvm_arm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 {
        int ret;

@@ -973,7 +972,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
                if (copy_from_user(&init, argp, sizeof(init)))
                        return -EFAULT;

-               return kvm_arch_vcpu_ioctl_vcpu_init(vcpu, &init);
+               return kvm_arm_vcpu_init(vcpu, &init);
        }
        case KVM_SET_ONE_REG:
        case KVM_GET_ONE_REG: {
--
1.9.1

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
