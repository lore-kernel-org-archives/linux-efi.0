From: gengdongjiu <gengdj.1984@gmail.com>
Subject: Re: [PATCH V11 10/10] arm/arm64: KVM: add guest SEA support
Date: Mon, 27 Feb 2017 19:31:21 +0800
Message-ID: <CAMj-D2AcBNozWXgKq2L_hb7G84i-10m=sGXx3j5ysrJ-nC=p0w@mail.gmail.com>
References: <1487712121-16688-1-git-send-email-tbaicar@codeaurora.org>
 <1487712121-16688-11-git-send-email-tbaicar@codeaurora.org>
 <58B00E12.5020602@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <58B00E12.5020602@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Morse <james.morse@arm.com>
Cc: mark.rutland@arm.com, linux-efi@vger.kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk, catalin.marinas@arm.com, Tyler Baicar <tbaicar@codeaurora.org>, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, tn@semihalf.com, zjzhang@codeaurora.org, linux@armlinux.org.uk, gengdongjiu@huawei.com, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, Suzuki.Poulose@arm.com, Marc Zyngier <marc.zyngier@arm.com>, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.g
List-Id: linux-efi@vger.kernel.org

@@ -1444,8 +1445,21 @@ int kvm_handle_guest_abort(struct kvm_vcpu
*vcpu, struct kvm_run *run)

        /* Check the stage-2 fault is trans. fault or write fault */
        fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
-       if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
-           fault_status != FSC_ACCESS) {
+
+       /* The host kernel will handle the synchronous external abort. There
+        * is no need to pass the error into the guest.
+        */
+       if (fault_status == FSC_EXTABT) {
+               if(handle_guest_sea((unsigned long)fault_ipa,
+                                   kvm_vcpu_get_hsr(vcpu))) {
+                       kvm_err("Failed to handle guest SEA, FSC:
EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
+                               kvm_vcpu_trap_get_class(vcpu),
+                               (unsigned long)kvm_vcpu_trap_get_fault(vcpu),
+                               (unsigned long)kvm_vcpu_get_hsr(vcpu));
+                       return -EFAULT;
+               }
+       } else if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
+                  fault_status != FSC_ACCESS) {
                kvm_err("Unsupported FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
                        kvm_vcpu_trap_get_class(vcpu),
                        (unsigned long)kvm_vcpu_trap_get_fault(vcpu),



if the error is SEA and we want to inject the sea to guest OK, after
finish the handle, whether we need to directly return? instead of
continuation? as shown below:

       if (fault_status == FSC_EXTABT) {
               if(handle_guest_sea((unsigned long)fault_ipa,
                                   kvm_vcpu_get_hsr(vcpu))) {
                       kvm_err("Failed to handle guest SEA, FSC:
EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
                               kvm_vcpu_trap_get_class(vcpu),
                               (unsigned long)kvm_vcpu_trap_get_fault(vcpu),
                               (unsigned long)kvm_vcpu_get_hsr(vcpu));
                       return -EFAULT;
          } else
                       return 1;






2017-02-24 18:42 GMT+08:00 James Morse <james.morse@arm.com>:
> Hi Tyler,
>
> On 21/02/17 21:22, Tyler Baicar wrote:
>> Currently external aborts are unsupported by the guest abort
>> handling. Add handling for SEAs so that the host kernel reports
>> SEAs which occur in the guest kernel.
>
>> diff --git a/arch/arm/include/asm/kvm_arm.h b/arch/arm/include/asm/kvm_arm.h
>> index e22089f..33a77509 100644
>> --- a/arch/arm/include/asm/kvm_arm.h
>> +++ b/arch/arm/include/asm/kvm_arm.h
>> @@ -187,6 +187,7 @@
>>  #define FSC_FAULT    (0x04)
>>  #define FSC_ACCESS   (0x08)
>>  #define FSC_PERM     (0x0c)
>> +#define FSC_EXTABT   (0x10)
>
> arm64 has ESR_ELx_FSC_EXTABT which is used in inject_abt64(), but for matching
> an external abort coming from hardware the range is wider.
>
> Looking at the ARM-ARMs 'ISS encoding for an exception from an Instruction
> Abort' in 'D7.2.27 ESR_ELx, Exception Syndrome Register (ELx)' (page D7-1954 of
> version 'k'...iss10775), the ten flavours of you Synchronous abort you hooked
> with do_sea() in patch 4 occupy 0x10 to 0x1f...
>
>
>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>> index a5265ed..04f1dd50 100644
>> --- a/arch/arm/kvm/mmu.c
>> +++ b/arch/arm/kvm/mmu.c
>> @@ -29,6 +29,7 @@
>>  #include <asm/kvm_asm.h>
>>  #include <asm/kvm_emulate.h>
>>  #include <asm/virt.h>
>> +#include <asm/system_misc.h>
>>
>>  #include "trace.h"
>>
>> @@ -1444,8 +1445,21 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>
>>       /* Check the stage-2 fault is trans. fault or write fault */
>>       fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
>
> ... kvm_vcpu_trap_get_fault_type() on both arm and arm64 masks the HSR/ESR_EL2
> with 0x3c ...
>
>
>> -     if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
>> -         fault_status != FSC_ACCESS) {
>> +
>> +     /* The host kernel will handle the synchronous external abort. There
>> +      * is no need to pass the error into the guest.
>> +      */
>> +     if (fault_status == FSC_EXTABT) {
>
> ... but here we only check for 'Synchronous external abort, not on a translation
> table walk'. Are the other types relevant?
>
> If so we need some helper as this range is sparse and 'all other values are
> reserved'. The aarch32 HSR format is slightly different. (G6-4411 ISS encoding
> from an exception from a Data Abort).
>
> If not, can we change patch 4 to check this type too so we don't call out to
> APEI for a fault type we know isn't relevant.
>
>
>> +             if(handle_guest_sea((unsigned long)fault_ipa,
>> +                                 kvm_vcpu_get_hsr(vcpu))) {
>> +                     kvm_err("Failed to handle guest SEA, FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
>> +                             kvm_vcpu_trap_get_class(vcpu),
>> +                             (unsigned long)kvm_vcpu_trap_get_fault(vcpu),
>> +                             (unsigned long)kvm_vcpu_get_hsr(vcpu));
>> +                     return -EFAULT;
>> +             }
>> +     } else if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
>> +                fault_status != FSC_ACCESS) {
>>               kvm_err("Unsupported FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
>>                       kvm_vcpu_trap_get_class(vcpu),
>>                       (unsigned long)kvm_vcpu_trap_get_fault(vcpu),
>
>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>> index b2d57fc..403277b 100644
>> --- a/arch/arm64/mm/fault.c
>> +++ b/arch/arm64/mm/fault.c
>> @@ -602,6 +602,24 @@ static const char *fault_name(unsigned int esr)
>>  }
>>
>>  /*
>> + * Handle Synchronous External Aborts that occur in a guest kernel.
>> + */
>> +int handle_guest_sea(unsigned long addr, unsigned int esr)
>> +{
>
>> +     if(IS_ENABLED(HAVE_ACPI_APEI_SEA)) {
>> +             nmi_enter();
>> +             ghes_notify_sea();
>> +             nmi_exit();
>
> This nmi stuff was needed for synchronous aborts that may have interrupted
> APEI's interrupts-masked code. We want to avoid trying to take the same set of
> locks, hence taking the in_nmi() path through APEI. Here we know we interrupted
> a guest, so there is no risk that we have interrupted APEI on the host.
> ghes_notify_sea() can safely take the normal path.
>
>
> Thanks,
>
> James
