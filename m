From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4.11 00/28] 4.11.1-stable review
Date: Thu, 25 May 2017 13:06:31 -0700
Message-ID: <CAKv+Gu-tbAowobZeWvtrdpkKQqH2+sYvOWyAjV5BU4VctRFk9Q@mail.gmail.com>
References: <20170511141221.109842231@linuxfoundation.org> <465c70c9-1dbc-7c57-c6aa-b6df740663ed@osg.samsung.com>
 <efa3b911-93f6-29b4-a9ca-e0d9b480a4ef@osg.samsung.com> <20170515143601.GF2935@codeblueprint.co.uk>
 <e95d7992-6343-1a36-46e7-630b8874bdfa@osg.samsung.com> <20170525113908.GC3546@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170525113908.GC3546-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, patches-ssFOTAMYnuFg9hUCZPvPmw@public.gmane.org, ben.hutchings-4yDnlxn2s6sWdaTGBSpHTA@public.gmane.org, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 25 May 2017 at 04:39, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Mon, 15 May, at 11:28:16AM, Shuah Khan wrote:
>> Hi Matt,
>>
>> On 05/15/2017 08:36 AM, Matt Fleming wrote:
>> > On Fri, 12 May, at 10:01:41AM, Shuah Khan wrote:
>> >>
>> >> Greg/Matt,
>> >>
>> >> I started seeing this maybe since 4.11, so it isn't really a 4.11.1
>> >> issue, however sounds like this shouldn't be an error message, since
>> >> it is showing up on an older platform.
>> >>
>> >> efi: EFI_MEMMAP is not enabled.
>> >> efi: Failed to lookup EFI memory descriptor for 0x00000000d9e0f018
>> >>
>> >>
>> >> From 816e76129ed5fadd28e526c43397c79775194b5c Mon Sep 17 00:00:00 2001
>> >> From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
>> >> Date: Mon, 29 Feb 2016 21:22:52 +0000
>> >> Subject: [PATCH] efi: Allow drivers to reserve boot services forever
>> >>
>> >> This change was introduced in Commit: 816e76129ed5fadd28e526c43397c79775194b5c
>> >>
>> >> Matt!
>> >>
>> >> Shouldn't this be a debug message?? Is this a really an error??
>> >
>> > Yes, it's most likely an error. We shouldn't be trying to reserve
>> > EFI regions if we can't find them in the memory map.
>> >
>> > Can you provide the full dmesg, please?
>> >
>>
>> Please see attached dmesg and dmidecode output. Please let me know if you need
>> any other information.
>
> Did you use git bisect to find the above commit that introduced this
> error message? Because while the error message itself was merged in
> the above commit there were no users until commit 8e80632fb23f
> ("efi/esrt: Use efi_mem_reserve() and avoid a kmalloc()").
>
> Can you apply the attached patch, boot your machine with the efi=debug
> command line option and capture the dmesg output? It doesn't look like
> your machine is booting using EFI.
>
> ---
>
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index 30031d5293c4..7f942df48f42 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -193,6 +193,7 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
>
>         if (efi_mem_desc_lookup(addr, &md)) {
>                 pr_err("Failed to lookup EFI memory descriptor for %pa\n", &addr);
> +               WARN_ON(1);
>                 return;
>         }
>

Could this be related to the BGRT patch we have in efi/next?
