From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: kexec regression since 4.9 caused by efi
Date: Fri, 17 Mar 2017 13:25:33 +0000
Message-ID: <CAKv+Gu-tGaM=fCitv1h7qcM7V9qk9yTjM6-zrvsQq2ZscuqbxQ@mail.gmail.com>
References: <20170308201616.GC8598@vader>
 <20170309063806.GB17257@dhcp-128-65.nay.redhat.com>
 <20170309095408.GA17883@vader>
 <20170313073748.GA6332@dhcp-128-65.nay.redhat.com>
 <20170316124132.GF6261@codeblueprint.co.uk>
 <20170317020951.GA3942@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <20170317020951.GA3942-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 17 March 2017 at 02:09, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 03/16/17 at 12:41pm, Matt Fleming wrote:
>> On Mon, 13 Mar, at 03:37:48PM, Dave Young wrote:
>> >
>> > Omar, could you try below patch? Looking at the efi_mem_desc_lookup, it is not
>> > correct to be used in efi_arch_mem_reserve, if it passed your test, I
>> > can rewrite patch log with more background and send it out:
>> >
>> >         for_each_efi_memory_desc(md) {
>> >             [snip]
>> >                 if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
>> >                     md->type != EFI_BOOT_SERVICES_DATA &&
>> >                     md->type != EFI_RUNTIME_SERVICES_DATA) {
>> >                         continue;
>> >                 }
>> >
>> > In above code, it meant to get a md of EFI_MEMORY_RUNTIME of either boot
>> > data or runtime data, this is wrong for efi_mem_reserve, because we are
>> > reserving boot data which has no EFI_MEMORY_RUNTIME attribute at the
>> > running time. Just is happened to work and we did not capture the error.
>>
>> Wouldn't something like this be simpler?
>>
>> ---
>>
>> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
>> index 30031d5293c4..cdfe8c628959 100644
>> --- a/arch/x86/platform/efi/quirks.c
>> +++ b/arch/x86/platform/efi/quirks.c
>> @@ -201,6 +201,10 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
>>               return;
>>       }
>>
>> +     /* No need to reserve regions that will never be freed. */
>> +     if (md.attribute & EFI_MEMORY_RUNTIME)
>> +             return;
>> +
>
> Matt, I think it should be fine although I think the md type checking in
> efi_mem_desc_lookup() is causing confusion and not easy to understand..
>
> How about move the if chunk early like below because it seems no need
> to sanity check the addr + size any more if the md is still RUNTIME?
>
> --- linux-x86.orig/arch/x86/platform/efi/quirks.c
> +++ linux-x86/arch/x86/platform/efi/quirks.c
> @@ -196,6 +196,10 @@ void __init efi_arch_mem_reserve(phys_ad
>                 return;
>         }
>
> +       /* No need to reserve regions that will never be freed. */
> +       if (md.attribute & EFI_MEMORY_RUNTIME)
> +               return;
> +
>         if (addr + size > md.phys_addr + (md.num_pages << EFI_PAGE_SHIFT)) {
>                 pr_err("Region spans EFI memory descriptors, %pa\n", &addr);
>                 return;
>

This way, we suppress the error it the region spans multiple
descriptors, and only the first one has the runtime attribute. So the
two patches are not equivalent. I don't have a strong preference
either way, though.
