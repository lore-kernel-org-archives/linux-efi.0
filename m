From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH v7 08/36] x86/mm: Add support to enable SME in early boot
	processing
Date: Wed, 21 Jun 2017 10:14:35 -0500
Message-ID: <8d3c215f-cdad-5554-6e9c-5598e1081850@amd.com>
References: <20170616184947.18967.84890.stgit@tlendack-t1.amdoffice.net>
	<20170616185115.18967.79622.stgit@tlendack-t1.amdoffice.net>
	<alpine.DEB.2.20.1706202259290.2157@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1706202259290.2157@nanos>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, kexe
List-Id: linux-efi@vger.kernel.org

On 6/21/2017 2:16 AM, Thomas Gleixner wrote:
> On Fri, 16 Jun 2017, Tom Lendacky wrote:
>> diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
>> index a105796..988b336 100644
>> --- a/arch/x86/include/asm/mem_encrypt.h
>> +++ b/arch/x86/include/asm/mem_encrypt.h
>> @@ -15,16 +15,24 @@
>>   
>>   #ifndef __ASSEMBLY__
>>   
>> +#include <linux/init.h>
>> +
>>   #ifdef CONFIG_AMD_MEM_ENCRYPT
>>   
>>   extern unsigned long sme_me_mask;
>>   
>> +void __init sme_enable(void);
>> +
>>   #else	/* !CONFIG_AMD_MEM_ENCRYPT */
>>   
>>   #define sme_me_mask	0UL
>>   
>> +static inline void __init sme_enable(void) { }
>> +
>>   #endif	/* CONFIG_AMD_MEM_ENCRYPT */
>>   
>> +unsigned long sme_get_me_mask(void);
> 
> Why is this an unconditional function? Isn't the mask simply 0 when the MEM
> ENCRYPT support is disabled?

I made it unconditional because of the call from head_64.S. I can't make
use of the C level static inline function and since the mask is not a
variable if CONFIG_AMD_MEM_ENCRYPT is not configured (#defined to 0) I
can't reference the variable directly.

I could create a #define in head_64.S that changes this to load rax with
the variable if CONFIG_AMD_MEM_ENCRYPT is configured or a zero if it's
not or add a #ifdef at that point in the code directly. Thoughts on
that?

> 
>> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
>> index 6225550..ef12729 100644
>> --- a/arch/x86/kernel/head_64.S
>> +++ b/arch/x86/kernel/head_64.S
>> @@ -78,7 +78,29 @@ startup_64:
>>   	call	__startup_64
>>   	popq	%rsi
>>   
>> -	movq	$(early_top_pgt - __START_KERNEL_map), %rax
>> +	/*
>> +	 * Encrypt the kernel if SME is active.
>> +	 * The real_mode_data address is in %rsi and that register can be
>> +	 * clobbered by the called function so be sure to save it.
>> +	 */
>> +	push	%rsi
>> +	call	sme_encrypt_kernel
>> +	pop	%rsi
> 
> That does not make any sense. Neither the call to sme_encrypt_kernel() nor
> the following call to sme_get_me_mask().
> 
> __startup_64() is already C code, so why can't you simply call that from
> __startup_64() in C and return the mask from there?

I was trying to keep it explicit as to what was happening, but I can
move those calls into __startup_64(). I'll still need the call to
sme_get_me_mask() in the secondary_startup_64 path, though (depending on
your thoughts to the above response).

> 
>> @@ -98,7 +120,20 @@ ENTRY(secondary_startup_64)
>>   	/* Sanitize CPU configuration */
>>   	call verify_cpu
>>   
>> -	movq	$(init_top_pgt - __START_KERNEL_map), %rax
>> +	/*
>> +	 * Get the SME encryption mask.
>> +	 *  The encryption mask will be returned in %rax so we do an ADD
>> +	 *  below to be sure that the encryption mask is part of the
>> +	 *  value that will stored in %cr3.
>> +	 *
>> +	 * The real_mode_data address is in %rsi and that register can be
>> +	 * clobbered by the called function so be sure to save it.
>> +	 */
>> +	push	%rsi
>> +	call	sme_get_me_mask
>> +	pop	%rsi
> 
> Do we really need a call here? The mask is established at this point, so
> it's either 0 when the encryption stuff is not compiled in or it can be
> retrieved from a variable which is accessible at this point.
> 

Same as above, this can be updated based on the decided approach.

Thanks,
Tom

>> +
>> +	addq	$(init_top_pgt - __START_KERNEL_map), %rax
>>   1:
>>   
>>   	/* Enable PAE mode, PGE and LA57 */
> 
> Thanks,
> 
> 	tglx
> 
