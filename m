From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH v6 10/34] x86, x86/mm, x86/xen, olpc: Use __va() against
	just the physical address in cr3
Date: Fri, 9 Jun 2017 16:20:35 -0500
Message-ID: <601d5972-72b0-6556-0054-7275cb763816@amd.com>
References: <20170607191309.28645.15241.stgit@tlendack-t1.amdoffice.net>
	<20170607191453.28645.92256.stgit@tlendack-t1.amdoffice.net>
	<CALCETrVVhMf=zkiDNn_-hKDZLGXKFiwxuWkPmD5RJgHa5VUMiQ@mail.gmail.com>
	<85355c4c-2cc1-daac-d8fe-ac6965b34606@amd.com>
	<CALCETrVyHbgJxk6hTRuM0CCpWTvFSX0MxuUQjKOf=7hYCt-yEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CALCETrVyHbgJxk6hTRuM0CCpWTvFSX0MxuUQjKOf=7hYCt-yEg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kvm list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kasan-dev <kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov@goo>
List-Id: linux-efi@vger.kernel.org

On 6/9/2017 1:46 PM, Andy Lutomirski wrote:
> On Thu, Jun 8, 2017 at 3:38 PM, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org> wrote:
>> On 6/8/2017 1:05 AM, Andy Lutomirski wrote:
>>>
>>> On Wed, Jun 7, 2017 at 12:14 PM, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>>> wrote:
>>>>
>>>> The cr3 register entry can contain the SME encryption bit that indicates
>>>> the PGD is encrypted.  The encryption bit should not be used when
>>>> creating
>>>> a virtual address for the PGD table.
>>>>
>>>> Create a new function, read_cr3_pa(), that will extract the physical
>>>> address from the cr3 register. This function is then used where a virtual
>>>> address of the PGD needs to be created/used from the cr3 register.
>>>
>>>
>>> This is going to conflict with:
>>>
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/commit/?h=x86/pcid&id=555c81e5d01a62b629ec426a2f50d27e2127c1df
>>>
>>> We're both encountering the fact that CR3 munges the page table PA
>>> with some other stuff, and some readers want to see the actual CR3
>>> value and other readers just want the PA.  The thing I prefer about my
>>> patch is that I get rid of read_cr3() entirely, forcing the patch to
>>> update every single reader, making review and conflict resolution much
>>> safer.
>>>
>>> I'd be willing to send a patch tomorrow that just does the split into
>>> __read_cr3() and read_cr3_pa() (I like your name better) and then we
>>> can both base on top of it.  Would that make sense?
>>
>>
>> That makes sense to me.
> 
> Draft patch:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/commit/?h=x86/read_cr3&id=9adebbc1071f066421a27b4f6e040190f1049624

Looks good to me. I'll look at how to best mask off the encryption bit
in CR3_ADDR_MASK for SME support.  I should be able to just do an
__sme_clr() against it.

> 
>>
>>>
>>> Also:
>>>
>>>> +static inline unsigned long read_cr3_pa(void)
>>>> +{
>>>> +       return (read_cr3() & PHYSICAL_PAGE_MASK);
>>>> +}
>>>
>>>
>>> Is there any guarantee that the magic encryption bit is masked out in
>>> PHYSICAL_PAGE_MASK?  The docs make it sound like it could be any bit.
>>> (But if it's one of the low 12 bits, that would be quite confusing.)
>>
>>
>> Right now it's bit 47 and we're steering away from any of the currently
>> reserved bits so we should be safe.
> 
> Should the SME init code check that it's a usable bit (i.e. outside
> our physical address mask and not one of the bottom twelve bits)?  If
> some future CPU daftly picks, say, bit 12, we'll regret it if we
> enable SME.

I think I can safely say that it will never be any of the lower 12 bits,
but let me talk to some of the hardware folks and see about the other
end of the range.

Thanks,
Tom

> 
> --Andy
> 
