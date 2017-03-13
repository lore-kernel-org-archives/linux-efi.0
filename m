From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH v5 2/3] x86: Remap GDT tables in the Fixmap
 section
Date: Mon, 13 Mar 2017 14:32:10 -0400
Message-ID: <f2230734-a13f-6c0d-8a01-15fd4408e799@oracle.com>
References: <20170306220348.79702-1-thgarnie@google.com>
 <20170306220348.79702-2-thgarnie@google.com>
 <CALCETrVXHc-EAhBtdhL9FXSW1G2VbohRY4UJuOtpRG1K0Q-Ogg@mail.gmail.com>
 <17ffcc5b-1c9a-51b6-272a-5eaecf1bc0c4@citrix.com>
 <CALCETrWv-u7OdjWDY+5eF7p-ngPun-yYf0QegMzYc6MGVQd-4w@mail.gmail.com>
 <CAJcbSZExVWA0jvAoxLLc+58Ag9cHchifrHP=fFfzU_onHo2PyA@mail.gmail.com>
 <5cf31779-45c5-d37f-86bc-d5afb3fb7ab6@oracle.com>
 <51c23e92-d1f0-427f-e069-c92fc4ed6226@oracle.com>
 <CAJcbSZEnUBfLHjf+bHqY0JQhQXD9urX45BXrQjx=1=A5gPpp_w@mail.gmail.com>
 <36579cc4-05e7-a448-767c-b9ad940362fc@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <36579cc4-05e7-a448-767c-b9ad940362fc@oracle.com>
Sender: owner-linux-mm@kvack.org
To: Thomas Garnier <thgarnie@google.com>
Cc: Michal Hocko <mhocko@suse.com>, Stanislaw Gruszka <sgruszka@redhat.com>, kvm list <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Frederic Weisbecker <fweisbec@gmail.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Chris Wilson <chris@chris-wilson.co.uk>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Dave Hansen <dave.hansen@intel.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Alexander Potapenko <glider@google.com>, Pavel Machek <pavel@ucw.cz>, "H . Peter Anvin" <hpa@zytor.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jiri Olsa <jolsa@redhat.com>, zijun_hu <zijun_hu@htc.com>, Prarit
List-Id: linux-efi@vger.kernel.org

On 03/09/2017 06:17 PM, Boris Ostrovsky wrote:
> On 03/09/2017 05:31 PM, Thomas Garnier wrote:
>> On Thu, Mar 9, 2017 at 2:13 PM, Boris Ostrovsky
>> <boris.ostrovsky@oracle.com> wrote:
>>>>> I don't have any experience with Xen so it would be great if virtme can test it.
>>>> I am pretty sure I tested this series at some point but I'll test it again.
>>>>
>>>
>>> Fails 32-bit build:
>>>
>>>
>>> /home/build/linux-boris/arch/x86/kvm/vmx.c: In function ‘segment_base’:
>>> /home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: ‘host_gdt’
>>> undeclared (first use in this function)
>>> /home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: (Each undeclared
>>> identifier is reported only once
>>> /home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: for each
>>> function it appears in.)
>>> /home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: type defaults to
>>> ‘int’ in declaration of ‘type name’
>>> /home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: type defaults to
>>> ‘int’ in declaration of ‘type name’
>>> /home/build/linux-boris/arch/x86/kvm/vmx.c:2054: warning: initialization
>>> from incompatible pointer type
>>> /home/build/linux-boris/arch/x86/kvm/vmx.c:2054: warning: unused
>>> variable ‘gdt’
>>>
>>>
>>> -boris
>> It seems that I forgot to remove line 2054 on the rebase. My 32-bit
>> build comes clean but I assume it is not good enough compare to the
>> full version I build for 64-bit KVM testing.
>>
>> Remove just this line and it should build fine, I will fix this on the
>> next iteration.
>>
>> Thanks for testing,
>>
> 
> 
> So this, in fact, does break Xen in that the hypercall to set GDT fails.
> 
> I will have lo look at this tomorrow but I definitely at least built
> with v3 of this series. And I don't see why I wouldn't have tested it
> once I built it.


There are a couple of problems for Xen PV guests that need to be addressed:
1. Xen's set_fixmap op needs non-default handling for
FIX_GDT_REMAP_BEGIN range
2. GDT remapping for PV guests needs to be RO for both 64 and 32-bit guests.

I don't know how you prefer to deal with (2), patch below is one
suggestion. With it all my boot tests (Xen and bare-metal) passed.

One problem with applying it directly is that kernel becomes
not-bisectable (Xen-wise) between patches 2 and 3 so perhaps you might
pull some of the changes from patch 3 to patch 2.


-boris


diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 9b7fda6..ec05f9c 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -39,6 +39,7 @@ extern struct desc_ptr idt_descr;
 extern gate_desc idt_table[];
 extern const struct desc_ptr debug_idt_descr;
 extern gate_desc debug_idt_table[];
+extern pgprot_t pg_fixmap_gdt_flags;

 struct gdt_page {
        struct desc_struct gdt[GDT_ENTRIES];
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index bff2f8b..2682355 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -450,16 +450,16 @@ void load_percpu_segment(int cpu)

 /* On 64-bit the GDT remapping is read-only */
 #ifdef CONFIG_X86_64
-#define PAGE_FIXMAP_GDT PAGE_KERNEL_RO
+pgprot_t pg_fixmap_gdt_flags = PAGE_KERNEL_RO;
 #else
-#define PAGE_FIXMAP_GDT PAGE_KERNEL
+pgprot_t pg_fixmap_gdt_flags = PAGE_KERNEL;
 #endif

 /* Setup the fixmap mapping only once per-processor */
 static inline void setup_fixmap_gdt(int cpu)
 {
        __set_fixmap(get_cpu_gdt_ro_index(cpu),
-                    __pa(get_cpu_gdt_rw(cpu)), PAGE_FIXMAP_GDT);
+                    __pa(get_cpu_gdt_rw(cpu)), pg_fixmap_gdt_flags);
 }

 /* Load the original GDT from the per-cpu structure */
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f46d47b..8871bcd 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2051,7 +2051,7 @@ static bool update_transition_efer(struct vcpu_vmx
*vmx, int efer_offset)
  */
 static unsigned long segment_base(u16 selector)
 {
-       struct desc_ptr *gdt = this_cpu_ptr(&host_gdt);
+       //struct desc_ptr *gdt = this_cpu_ptr(&host_gdt);
        struct desc_struct *table;
        unsigned long v;

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 4951fcf..2dc5f97 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1545,6 +1545,9 @@ asmlinkage __visible void __init
xen_start_kernel(void)
         */
        xen_initial_gdt = &per_cpu(gdt_page, 0);

+       /* GDT can only be remapped RO. */
+       pg_fixmap_gdt_flags = PAGE_KERNEL_RO;
+
        xen_smp_init();

 #ifdef CONFIG_ACPI_NUMA
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 37cb5aa..ebbfe00 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2326,6 +2326,7 @@ static void xen_set_fixmap(unsigned idx,
phys_addr_t phys, pgprot_t prot)
 #endif
        case FIX_TEXT_POKE0:
        case FIX_TEXT_POKE1:
+       case FIX_GDT_REMAP_BEGIN ... FIX_GDT_REMAP_END:
                /* All local page mappings */
                pte = pfn_pte(phys, prot);
                break;


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
