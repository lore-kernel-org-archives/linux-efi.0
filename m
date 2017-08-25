From: Florent Revest <florent.revest@arm.com>
Subject: [RFC 03/11] KVM: Allow VM lifecycle management without userspace
Date: Fri, 25 Aug 2017 09:31:33 +0100
Message-ID: <1503649901-5834-4-git-send-email-florent.revest@arm.com>
References: <1503649901-5834-1-git-send-email-florent.revest@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1503649901-5834-1-git-send-email-florent.revest@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org
Cc: mark.rutland@arm.com, linux-efi@vger.kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk, catalin.marinas@arm.com, ard.biesheuvel@linaro.org, will.deacon@arm.com, linux-kernel@vger.kernel.org, leif.lindholm@arm.com, marc.zyngier@arm.com, revestflo@gmail.com, pbonzini@redhat.com, Florent Revest <florent.revest@arm.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: linux-efi@vger.kernel.org

The current codebase of KVM makes many assumptions regarding the origin of
the virtual machine being executed or configured. Indeed, the KVM API
implementation has been written with userspace usage in mind and lots of
userspace-specific code is used (namely preempt_notifiers, eventfd, mmu
notifiers, current->mm...)

The aim of this patch is to make the KVM API (create_vm, create_vcpu etc)
usable from a kernel context. A simple trick is used to distinguish
userspace VMs (coming from QEMU or LKVM...) from internal VMs. (coming
from other subsystems, for example for sandboxing purpose):
  - When a VM is created from an ioctl, kvm->mm is set to current->mm
  - When a VM is created from the kernel, kvm->mm must be set to NULL

This ensures that no userspace program can create internal VMs and allows
to easily check whether a given VM is attached to a process or is internal.

This patch simply encloses the userspace-specific pieces of code of
kvm_main in conditions checking if kvm->mm is present and modifies the
prototype of kvm_create_vm to enable NULL mm.

Signed-off-by: Florent Revest <florent.revest@arm.com>
---
 virt/kvm/kvm_main.c | 64 ++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 41 insertions(+), 23 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 15252d7..2e7af1a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -154,7 +154,8 @@ int vcpu_load(struct kvm_vcpu *vcpu)
        if (mutex_lock_killable(&vcpu->mutex))
                return -EINTR;
        cpu = get_cpu();
-       preempt_notifier_register(&vcpu->preempt_notifier);
+       if (vcpu->kvm->mm)
+               preempt_notifier_register(&vcpu->preempt_notifier);
        kvm_arch_vcpu_load(vcpu, cpu);
        put_cpu();
        return 0;
@@ -165,7 +166,8 @@ void vcpu_put(struct kvm_vcpu *vcpu)
 {
        preempt_disable();
        kvm_arch_vcpu_put(vcpu);
-       preempt_notifier_unregister(&vcpu->preempt_notifier);
+       if (vcpu->kvm->mm)
+               preempt_notifier_unregister(&vcpu->preempt_notifier);
        preempt_enable();
        mutex_unlock(&vcpu->mutex);
 }
@@ -640,7 +642,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
        return 0;
 }

-static struct kvm *kvm_create_vm(unsigned long type)
+static struct kvm *kvm_create_vm(unsigned long type, struct mm_struct *mm)
 {
        int r, i;
        struct kvm *kvm = kvm_arch_alloc_vm();
@@ -649,9 +651,11 @@ static struct kvm *kvm_create_vm(unsigned long type)
                return ERR_PTR(-ENOMEM);

        spin_lock_init(&kvm->mmu_lock);
-       mmgrab(current->mm);
-       kvm->mm = current->mm;
-       kvm_eventfd_init(kvm);
+       kvm->mm = mm;
+       if (mm) {
+               mmgrab(current->mm);
+               kvm_eventfd_init(kvm);
+       }
        mutex_init(&kvm->lock);
        mutex_init(&kvm->irq_lock);
        mutex_init(&kvm->slots_lock);
@@ -697,15 +701,18 @@ static struct kvm *kvm_create_vm(unsigned long type)
                        goto out_err;
        }

-       r = kvm_init_mmu_notifier(kvm);
-       if (r)
-               goto out_err;
+       if (mm) {
+               r = kvm_init_mmu_notifier(kvm);
+               if (r)
+                       goto out_err;
+       }

        spin_lock(&kvm_lock);
        list_add(&kvm->vm_list, &vm_list);
        spin_unlock(&kvm_lock);

-       preempt_notifier_inc();
+       if (mm)
+               preempt_notifier_inc();

        return kvm;

@@ -721,7 +728,8 @@ static struct kvm *kvm_create_vm(unsigned long type)
        for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
                kvm_free_memslots(kvm, __kvm_memslots(kvm, i));
        kvm_arch_free_vm(kvm);
-       mmdrop(current->mm);
+       if (mm)
+               mmdrop(mm);
        return ERR_PTR(r);
 }

@@ -772,9 +780,11 @@ static void kvm_destroy_vm(struct kvm *kvm)
        cleanup_srcu_struct(&kvm->irq_srcu);
        cleanup_srcu_struct(&kvm->srcu);
        kvm_arch_free_vm(kvm);
-       preempt_notifier_dec();
+       if (mm)
+               preempt_notifier_dec();
        hardware_disable_all();
-       mmdrop(mm);
+       if (mm)
+               mmdrop(mm);
 }

 void kvm_get_kvm(struct kvm *kvm)
@@ -1269,6 +1279,9 @@ unsigned long kvm_host_page_size(struct kvm *kvm, gfn_t gfn)
        if (kvm_is_error_hva(addr))
                return PAGE_SIZE;

+       if (!kvm->mm)
+               return PAGE_SIZE;
+
        down_read(&current->mm->mmap_sem);
        vma = find_vma(current->mm, addr);
        if (!vma)
@@ -2486,9 +2499,11 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
        if (r)
                goto vcpu_destroy;

-       r = kvm_create_vcpu_debugfs(vcpu);
-       if (r)
-               goto vcpu_destroy;
+       if (kvm->mm) {
+               r = kvm_create_vcpu_debugfs(vcpu);
+               if (r)
+                       goto vcpu_destroy;
+       }

        mutex_lock(&kvm->lock);
        if (kvm_get_vcpu_by_id(kvm, id)) {
@@ -2499,11 +2514,13 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
        BUG_ON(kvm->vcpus[atomic_read(&kvm->online_vcpus)]);

        /* Now it's all set up, let userspace reach it */
-       kvm_get_kvm(kvm);
-       r = create_vcpu_fd(vcpu);
-       if (r < 0) {
-               kvm_put_kvm(kvm);
-               goto unlock_vcpu_destroy;
+       if (kvm->mm) {
+               kvm_get_kvm(kvm);
+               r = create_vcpu_fd(vcpu);
+               if (r < 0) {
+                       kvm_put_kvm(kvm);
+                       goto unlock_vcpu_destroy;
+               }
        }

        kvm->vcpus[atomic_read(&kvm->online_vcpus)] = vcpu;
@@ -2521,7 +2538,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)

 unlock_vcpu_destroy:
        mutex_unlock(&kvm->lock);
-       debugfs_remove_recursive(vcpu->debugfs_dentry);
+       if (kvm->mm)
+               debugfs_remove_recursive(vcpu->debugfs_dentry);
 vcpu_destroy:
        kvm_arch_vcpu_destroy(vcpu);
 vcpu_decrement:
@@ -3191,7 +3209,7 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
        struct kvm *kvm;
        struct file *file;

-       kvm = kvm_create_vm(type);
+       kvm = kvm_create_vm(type, current->mm);
        if (IS_ERR(kvm))
                return PTR_ERR(kvm);
 #ifdef CONFIG_KVM_MMIO
--
1.9.1

IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
