From: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [REGRESSION] EFI mixed mode patch triggers boot failure
Date: Mon, 24 Oct 2016 12:54:11 -0700
Message-ID: <e34311e8-fe39-3b65-bd6d-8f1594e56336@redhat.com>
References: <dc0bc031-f20e-9ad0-57f4-cfa1e04f8f05@redhat.com>
 <7af87cde-ce79-d6e8-0797-54069a77f42b@redhat.com>
 <20161020120357.GB19876@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161020120357.GB19876-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Justin Forbes <jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 10/20/2016 05:03 AM, Matt Fleming wrote:
> On Wed, 19 Oct, at 02:13:00PM, Laura Abbott wrote:
>> On 10/19/2016 01:04 PM, Laura Abbott wrote:
>>> Hi,
>>>
>>> Fedora received a bug report https://bugzilla.redhat.com/show_bug.cgi?id=1384238
>>> of a bootup failure with stable 4.7.6. efi=noruntime fixed the bootup problem.
>>> 1297667083d5442aafe3e337b9413bf02b114edb was linked as the cause
>>> of the problem.
>>>
>>>
>>> x86/efi: Only map RAM into EFI page tables if in mixed-mode
>>>
>>> Waiman reported that booting with CONFIG_EFI_MIXED enabled on his
>>> multi-terabyte HP machine results in boot crashes, because the EFI
>>> region mapping functions loop forever while trying to map those
>>> regions describing RAM.
>>>
>>> While this patch doesn't fix the underlying hang, there's really no
>>> reason to map EFI_CONVENTIONAL_MEMORY regions into the EFI page tables
>>> when mixed-mode is not in use at runtime.
>>>
>>> Reported-by: Waiman Long <waiman.long-ZPxbGqLxI0U@public.gmane.org>
>>> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>> Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
>>> Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>>> CC: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
>>> Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
>>> Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
>>> Cc: Scott J Norton <scott.norton-ZPxbGqLxI0U@public.gmane.org>
>>> Cc: Douglas Hatch <doug.hatch-ZPxbGqLxI0U@public.gmane.org>
>>> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.6+
>>> Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
>>>
>>> I made a request in the bugzilla for the reporter to
>>> give a bootlog with efi=debug which I'm still waiting on.
>>>
>>> Any ideas?
>>>
>>> Thanks,
>>> Laura
>>
>> dmesg with efi=debug from the reporter is attached
>
>> [    0.000000] DMI: Hewlett-Packard Compaq CQ58 Notebook PC/188B, BIOS F.36 06/07/2013
>
> Hmm.. this is a fairly old machine, what kernel versions has the
> reporter successfully run on it? The code that was nop'd out in the
> above commit for the native case only came into existence in v4.6.
>
> The fact that booting with efi=old_map does *not* seem to result in a
> booting kernel is very suspicious. Could you ask them to double-check?
>
> Maybe try this patch too on v4.7.6.

Was out for a few days, reporter says the below patch does not work.
There was some confusion with secure boot so I've asked them to re-test
with efi=old_map and secure boot off.

Thanks,
Laura

>
> ---
>
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index 964c7022d31d..b07183c6b470 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -244,9 +244,12 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
>  	 * text and allocate a new stack because we can't rely on the
>  	 * stack pointer being < 4GB.
>  	 */
> -	if (!IS_ENABLED(CONFIG_EFI_MIXED) || efi_is_native())
> +	if (!IS_ENABLED(CONFIG_EFI_MIXED))
>  		return 0;
>
> +	if (efi_is_native())
> +		goto map_text;
> +
>  	/*
>  	 * Map all of RAM so that we can access arguments in the 1:1
>  	 * mapping when making EFI runtime calls.
> @@ -273,6 +276,7 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
>  	efi_scratch.phys_stack = virt_to_phys(page_address(page));
>  	efi_scratch.phys_stack += PAGE_SIZE; /* stack grows down */
>
> +map_text:
>  	npages = (_etext - _text) >> PAGE_SHIFT;
>  	text = __pa(_text);
>  	pfn = text >> PAGE_SHIFT;
>
