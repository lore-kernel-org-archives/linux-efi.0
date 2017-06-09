From: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 10/34] x86, x86/mm, x86/xen, olpc: Use __va() against
 just the physical address in cr3
Date: Fri, 9 Jun 2017 11:46:32 -0700
Message-ID: <CALCETrVyHbgJxk6hTRuM0CCpWTvFSX0MxuUQjKOf=7hYCt-yEg@mail.gmail.com>
References: <20170607191309.28645.15241.stgit@tlendack-t1.amdoffice.net>
 <20170607191453.28645.92256.stgit@tlendack-t1.amdoffice.net>
 <CALCETrVVhMf=zkiDNn_-hKDZLGXKFiwxuWkPmD5RJgHa5VUMiQ@mail.gmail.com> <85355c4c-2cc1-daac-d8fe-ac6965b34606@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <85355c4c-2cc1-daac-d8fe-ac6965b34606-5C7GfCeVMHo@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kvm list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kasan-dev <kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Konr
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 8, 2017 at 3:38 PM, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org> wrote:
> On 6/8/2017 1:05 AM, Andy Lutomirski wrote:
>>
>> On Wed, Jun 7, 2017 at 12:14 PM, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>> wrote:
>>>
>>> The cr3 register entry can contain the SME encryption bit that indicates
>>> the PGD is encrypted.  The encryption bit should not be used when
>>> creating
>>> a virtual address for the PGD table.
>>>
>>> Create a new function, read_cr3_pa(), that will extract the physical
>>> address from the cr3 register. This function is then used where a virtual
>>> address of the PGD needs to be created/used from the cr3 register.
>>
>>
>> This is going to conflict with:
>>
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/commit/?h=x86/pcid&id=555c81e5d01a62b629ec426a2f50d27e2127c1df
>>
>> We're both encountering the fact that CR3 munges the page table PA
>> with some other stuff, and some readers want to see the actual CR3
>> value and other readers just want the PA.  The thing I prefer about my
>> patch is that I get rid of read_cr3() entirely, forcing the patch to
>> update every single reader, making review and conflict resolution much
>> safer.
>>
>> I'd be willing to send a patch tomorrow that just does the split into
>> __read_cr3() and read_cr3_pa() (I like your name better) and then we
>> can both base on top of it.  Would that make sense?
>
>
> That makes sense to me.

Draft patch:

https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/commit/?h=x86/read_cr3&id=9adebbc1071f066421a27b4f6e040190f1049624

>
>>
>> Also:
>>
>>> +static inline unsigned long read_cr3_pa(void)
>>> +{
>>> +       return (read_cr3() & PHYSICAL_PAGE_MASK);
>>> +}
>>
>>
>> Is there any guarantee that the magic encryption bit is masked out in
>> PHYSICAL_PAGE_MASK?  The docs make it sound like it could be any bit.
>> (But if it's one of the low 12 bits, that would be quite confusing.)
>
>
> Right now it's bit 47 and we're steering away from any of the currently
> reserved bits so we should be safe.

Should the SME init code check that it's a usable bit (i.e. outside
our physical address mask and not one of the bottom twelve bits)?  If
some future CPU daftly picks, say, bit 12, we'll regret it if we
enable SME.

--Andy
