From: Florent Revest <florent.revest@arm.com>
Subject: [RFC 11/11] KVM, arm64: Don't trap internal VMs SMC calls
Date: Fri, 25 Aug 2017 09:31:41 +0100
Message-ID: <1503649901-5834-12-git-send-email-florent.revest@arm.com>
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

Internal virtual machines can be used to sandbox code such as EFI Runtime
Services. However, some implementations of those Runtime Services rely on
handlers placed in the Secure World (e.g: SoftIron Overdrive 1000) and need
access to SMC calls.

This patch modifies the Hypervisor Configuration Register to avoid trapping
SMC calls of internal virtual machines. Normal userspace VMs are not
affected by this patch.

Note: Letting Runtime Services VMs access EL3 without control can
potentially be a security threat on its own. An alternative would be to
forward SMC calls selectively from inside handle_smc. However, this would
require some level of knowledge of the SMC calls arguments and EFI
Runtime Services implementations.

Signed-off-by: Florent Revest <florent.revest@arm.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/=
kvm_emulate.h
index fe39e68..4b46cd0 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -49,6 +49,9 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
                vcpu->arch.hcr_el2 |=3D HCR_E2H;
        if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
                vcpu->arch.hcr_el2 &=3D ~HCR_RW;
+
+       if (!vcpu->kvm->mm)
+               vcpu->arch.hcr_el2 &=3D ~HCR_TSC;
 }

 static inline unsigned long vcpu_get_hcr(struct kvm_vcpu *vcpu)
--
1.9.1

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
