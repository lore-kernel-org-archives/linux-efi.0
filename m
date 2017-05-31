From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH v5 29/32] x86/mm: Add support to encrypt the kernel
	in-place
Date: Wed, 31 May 2017 08:12:56 -0500
Message-ID: <17394b27-d693-4ff9-9dbd-11b5237fcf6a@amd.com>
References: <20170418211612.10190.82788.stgit@tlendack-t1.amdoffice.net>
	<20170418212149.10190.70894.stgit@tlendack-t1.amdoffice.net>
	<20170518124626.hqyqqbjpy7hmlpqc@pd.tnic>
	<7e2ae014-525c-76f2-9fce-2124596db2d2@amd.com>
	<20170526162522.p7prrqqalx2ivfxl@pd.tnic>
	<33c075b1-71f6-b5d0-b1fa-d742d0659d38@amd.com>
	<20170531095148.pba6ju6im4qxbwfg@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170531095148.pba6ju6im4qxbwfg-fF5Pk5pvG8Y@public.gmane.org>
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
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter
	Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, "Michael S.
	Tsirkin" <mst>
List-Id: linux-efi@vger.kernel.org

On 5/31/2017 4:51 AM, Borislav Petkov wrote:
> On Tue, May 30, 2017 at 11:39:07AM -0500, Tom Lendacky wrote:
>> Yes, it's from objtool:
>>
>> arch/x86/mm/mem_encrypt_boot.o: warning: objtool: .text+0xd2: return
>> instruction outside of a callable function
> 
> Oh, well, let's make it a global symbol then. Who knows, we might have
> to live-patch it someday :-)

Can do.

Thanks,
Tom

> 
> ---
> diff --git a/arch/x86/mm/mem_encrypt_boot.S b/arch/x86/mm/mem_encrypt_boot.S
> index fb58f9f953e3..7720b0050840 100644
> --- a/arch/x86/mm/mem_encrypt_boot.S
> +++ b/arch/x86/mm/mem_encrypt_boot.S
> @@ -47,9 +47,9 @@ ENTRY(sme_encrypt_execute)
>   	movq	%rdx, %r12		/* Kernel length */
>   
>   	/* Copy encryption routine into the workarea */
> -	movq	%rax, %rdi		/* Workarea encryption routine */
> -	leaq	.Lenc_start(%rip), %rsi	/* Encryption routine */
> -	movq	$(.Lenc_stop - .Lenc_start), %rcx	/* Encryption routine length */
> +	movq	%rax, %rdi				/* Workarea encryption routine */
> +	leaq	__enc_copy(%rip), %rsi			/* Encryption routine */
> +	movq	$(.L__enc_copy_end - __enc_copy), %rcx	/* Encryption routine length */
>   	rep	movsb
>   
>   	/* Setup registers for call */
> @@ -70,8 +70,7 @@ ENTRY(sme_encrypt_execute)
>   	ret
>   ENDPROC(sme_encrypt_execute)
>   
> -.Lenc_start:
> -ENTRY(sme_enc_routine)
> +ENTRY(__enc_copy)
>   /*
>    * Routine used to encrypt kernel.
>    *   This routine must be run outside of the kernel proper since
> @@ -147,5 +146,5 @@ ENTRY(sme_enc_routine)
>   	wrmsr
>   
>   	ret
> -ENDPROC(sme_enc_routine)
> -.Lenc_stop:
> +.L__enc_copy_end:
> +ENDPROC(__enc_copy)
> 
