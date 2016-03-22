From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [RFC PATCH v1 18/18] x86: Add support to turn on Secure Memory
	Encryption
Date: Tue, 22 Mar 2016 14:13:09 +0100
Message-ID: <20160322131309.GD16528@xo-6d-61-c0.localdomain>
References: <20160426225553.13567.19459.stgit@tlendack-t1.amdoffice.net>
	<20160426225904.13567.538.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160426225904.13567.538.stgit-qCXWGYdRb2BnqfbPTmsdiZQ+2ll4COg0XqFh9Ls21Oc@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi!

> This patch adds the support to check for and enable SME when available
> on the processor and when the mem_encrypt=on command line option is set.
> This consists of setting the encryption mask, calculating the number of
> physical bits of addressing lost and encrypting the kernel "in place."
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
> ---
>  Documentation/kernel-parameters.txt |    3 
>  arch/x86/kernel/asm-offsets.c       |    2 
>  arch/x86/kernel/mem_encrypt.S       |  306 +++++++++++++++++++++++++++++++++++
>  3 files changed, 311 insertions(+)
> 
> diff --git a/arch/x86/kernel/mem_encrypt.S b/arch/x86/kernel/mem_encrypt.S
> index f2e0536..4d3326d 100644
> --- a/arch/x86/kernel/mem_encrypt.S
> +++ b/arch/x86/kernel/mem_encrypt.S
> @@ -12,13 +12,236 @@
>  
>  #include <linux/linkage.h>
>  
> +#include <asm/processor-flags.h>
> +#include <asm/pgtable.h>
> +#include <asm/page.h>
> +#include <asm/msr.h>
> +#include <asm/asm-offsets.h>
> +
>  	.text
>  	.code64
>  ENTRY(sme_enable)
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +	/* Check for AMD processor */
> +	xorl	%eax, %eax
> +	cpuid
> +	cmpl    $0x68747541, %ebx	# AuthenticAMD
> +	jne     .Lno_mem_encrypt
> +	cmpl    $0x69746e65, %edx
> +	jne     .Lno_mem_encrypt
> +	cmpl    $0x444d4163, %ecx
> +	jne     .Lno_mem_encrypt
> +
> +	/* Check for memory encryption leaf */
> +	movl	$0x80000000, %eax
> +	cpuid
> +	cmpl	$0x8000001f, %eax
> +	jb	.Lno_mem_encrypt
> +
> +	/*
> +	 * Check for memory encryption feature:
> +	 *   CPUID Fn8000_001F[EAX] - Bit 0
> +	 */
> +	movl	$0x8000001f, %eax
> +	cpuid
> +	bt	$0, %eax
> +	jnc	.Lno_mem_encrypt
> +
> +	/* Check for the mem_encrypt=on command line option */
> +	push	%rsi			/* Save RSI (real_mode_data) */
> +	movl	BP_ext_cmd_line_ptr(%rsi), %ecx
> +	shlq	$32, %rcx
> +	movl	BP_cmd_line_ptr(%rsi), %edi
> +	addq	%rcx, %rdi
> +	leaq	mem_encrypt_enable_option(%rip), %rsi
> +	call	cmdline_find_option_bool
> +	pop	%rsi			/* Restore RSI (real_mode_data) */
> +	testl	%eax, %eax
> +	jz	.Lno_mem_encrypt

Can you move parts to C here, so that it is more readable?

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
