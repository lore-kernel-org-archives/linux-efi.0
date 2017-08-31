From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [RFC Part1 PATCH v3 17/17] X86/KVM: Clear encryption attribute
 when SEV is active
Date: Thu, 31 Aug 2017 17:06:23 +0200
Message-ID: <20170831150623.cljoy6rm72pn24wg@pd.tnic>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-18-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170724190757.11278-18-brijesh.singh-5C7GfCeVMHo@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Piotr Luc <piotr.luc-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Reza Arbab <arbab-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric
List-Id: linux-efi@vger.kernel.org

On Mon, Jul 24, 2017 at 02:07:57PM -0500, Brijesh Singh wrote:
> The guest physical memory area holding the struct pvclock_wall_clock and
> struct pvclock_vcpu_time_info are shared with the hypervisor. Hypervisor
> periodically updates the contents of the memory. When SEV is active, we
> must clear the encryption attributes from the shared memory pages so that
> both hypervisor and guest can access the data.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
> ---
>  arch/x86/entry/vdso/vma.c  |  5 ++--
>  arch/x86/kernel/kvmclock.c | 64 +++++++++++++++++++++++++++++++++++++++-------
>  2 files changed, 58 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
> index 726355c..ff50251 100644
> --- a/arch/x86/entry/vdso/vma.c
> +++ b/arch/x86/entry/vdso/vma.c
> @@ -114,10 +114,11 @@ static int vvar_fault(const struct vm_special_mapping *sm,
>  		struct pvclock_vsyscall_time_info *pvti =
>  			pvclock_pvti_cpu0_va();
>  		if (pvti && vclock_was_used(VCLOCK_PVCLOCK)) {
> -			ret = vm_insert_pfn(
> +			ret = vm_insert_pfn_prot(
>  				vma,
>  				vmf->address,
> -				__pa(pvti) >> PAGE_SHIFT);
> +				__pa(pvti) >> PAGE_SHIFT,
> +				pgprot_decrypted(vma->vm_page_prot));
>  		}
>  	} else if (sym_offset == image->sym_hvclock_page) {
>  		struct ms_hyperv_tsc_page *tsc_pg = hv_get_tsc_page();

Yuck, that vvar_fault() function is one unreadable mess.

> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index d889676..f3a8101 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -27,6 +27,7 @@
>  #include <linux/sched.h>
>  #include <linux/sched/clock.h>
>  
> +#include <asm/mem_encrypt.h>
>  #include <asm/x86_init.h>
>  #include <asm/reboot.h>
>  #include <asm/kvmclock.h>
> @@ -45,7 +46,7 @@ early_param("no-kvmclock", parse_no_kvmclock);
>  
>  /* The hypervisor will put information about time periodically here */
>  static struct pvclock_vsyscall_time_info *hv_clock;
> -static struct pvclock_wall_clock wall_clock;
> +static struct pvclock_wall_clock *wall_clock;
>  
>  struct pvclock_vsyscall_time_info *pvclock_pvti_cpu0_va(void)
>  {
> @@ -64,15 +65,18 @@ static void kvm_get_wallclock(struct timespec *now)
>  	int low, high;
>  	int cpu;
>  
> -	low = (int)__pa_symbol(&wall_clock);
> -	high = ((u64)__pa_symbol(&wall_clock) >> 32);
> +	if (!wall_clock)
> +		return;

Hmm, so if you return here, @now will remain unchanged so how is the
caller to know that ->get_wallclock() failed?

Maybe a WARN_ON_ONCE() at least...?

Dunno, what's the policy in kvm if the kvmclock init fails?

Paolo? Radim?

Because it does say:

        printk(KERN_INFO "kvm-clock: Using msrs %x and %x",
                msr_kvm_system_time, msr_kvm_wall_clock);

too early. We can error out later and users will still think it is using
kvmclock ...

Hmmm.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
