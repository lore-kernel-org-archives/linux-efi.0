From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH v6 10/34] x86, x86/mm, x86/xen, olpc: Use
	__va() against just the physical address in cr3
Date: Fri, 9 Jun 2017 13:36:35 -0500
Message-ID: <9725c503-2e33-2365-87f5-f017e1cbe9b6@amd.com>
References: <20170607191309.28645.15241.stgit@tlendack-t1.amdoffice.net>
	<20170607191453.28645.92256.stgit@tlendack-t1.amdoffice.net>
	<b15e8924-4069-b5fa-adb2-86c164b1dd36@oracle.com>
	<4a7376fb-abfc-8edd-42b7-38de461ac65e@amd.com>
	<67fe69ac-a213-8de3-db28-0e54bba95127@oracle.com>
	<fcb196c8-f1eb-a38c-336c-7bd3929b029e@amd.com>
	<12c7e511-996d-cf60-3a3b-0be7b41bd85b@oracle.com>
	<d37917b1-8e49-e8a8-b9ac-59491331640f@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <d37917b1-8e49-e8a8-b9ac-59491331640f-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
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
To: Andrew Cooper <andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, xen-devel <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 6/8/2017 5:01 PM, Andrew Cooper wrote:
> On 08/06/2017 22:17, Boris Ostrovsky wrote:
>> On 06/08/2017 05:02 PM, Tom Lendacky wrote:
>>> On 6/8/2017 3:51 PM, Boris Ostrovsky wrote:
>>>>>> What may be needed is making sure X86_FEATURE_SME is not set for PV
>>>>>> guests.
>>>>> And that may be something that Xen will need to control through either
>>>>> CPUID or MSR support for the PV guests.
>>>>
>>>> Only on newer versions of Xen. On earlier versions (2-3 years old) leaf
>>>> 0x80000007 is passed to the guest unchanged. And so is MSR_K8_SYSCFG.
>>> The SME feature is in leaf 0x8000001f, is that leaf passed to the guest
>>> unchanged?
>> Oh, I misread the patch where X86_FEATURE_SME is defined. Then all
>> versions, including the current one, pass it unchanged.
>>
>> All that's needed is setup_clear_cpu_cap(X86_FEATURE_SME) in
>> xen_init_capabilities().
> 
> AMD processors still don't support CPUID Faulting (or at least, I
> couldn't find any reference to it in the latest docs), so we cannot
> actually hide SME from a guest which goes looking at native CPUID.
> Furthermore, I'm not aware of any CPUID masking support covering that leaf.
> 
> However, if Linux is using the paravirtual cpuid hook, things are
> slightly better.
> 
> On Xen 4.9 and later, no guests will see the feature.  On earlier
> versions of Xen (before I fixed the logic), plain domUs will not see the
> feature, while dom0 will.
> 
> For safely, I'd recommend unilaterally clobbering the feature as Boris
> suggested.  There is no way SME will be supportable on a per-PV guest

That may be too late. Early boot support in head_64.S will make calls to
check for the feature (through CPUID and MSR), set the sme_me_mask and
encrypt the kernel in place. Is there another way to approach this?

> basis, although (as far as I am aware) Xen as a whole would be able to
> encompass itself and all of its PV guests inside one single SME instance.

Yes, that is correct.

Thanks,
Tom

> 
> ~Andrew
> 
