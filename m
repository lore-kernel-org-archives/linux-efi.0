From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC PATCH v1 10/18] x86/efi: Access EFI related tables in the
	clear
Date: Thu, 16 Jun 2016 09:38:31 -0500
Message-ID: <5762B9E7.80903@amd.com>
References: <20160426225553.13567.19459.stgit@tlendack-t1.amdoffice.net>
	<20160426225740.13567.85438.stgit@tlendack-t1.amdoffice.net>
	<20160608111844.GV2658@codeblueprint.co.uk> <5759B67A.4000800@amd.com>
	<20160613135110.GC2658@codeblueprint.co.uk> <57615561.4090502@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <57615561.4090502-5C7GfCeVMHo@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 06/15/2016 08:17 AM, Tom Lendacky wrote:
> On 06/13/2016 08:51 AM, Matt Fleming wrote:
>> On Thu, 09 Jun, at 01:33:30PM, Tom Lendacky wrote:
>>>

[...]

>>
>>> I'll look further into this, but I saw that this area of virtual memory
>>> was mapped un-encrypted and after freeing the boot services the
>>> mappings were somehow reused as un-encrypted for DMA which assumes
>>> (unless using swiotlb) encrypted. This resulted in DMA data being
>>> transferred in as encrypted and then accessed un-encrypted.
>>
>> That the mappings were re-used isn't a surprise.
>>
>> efi_free_boot_services() lifts the reservation that was put in place
>> during efi_reserve_boot_services() and releases the pages to the
>> kernel's memory allocators.
>>
>> What is surprising is that they were marked unencrypted at all.
>> There's nothing special about these pages as far as the __va() region
>> is concerned.
> 
> Right, let me keep looking into this to see if I can pin down what
> was (or is) happening.

Ok, I think this was happening before the commit to build our own
EFI page table structures:

commit 67a9108ed ("x86/efi: Build our own page table structures")

Before this commit the boot services ended up mapped into the kernel
page table entries as un-encrypted during efi_map_regions() and I needed
to change those entries back to encrypted. With your change above,
this appears to no longer be needed.

Thanks,
Tom

> 
> Thanks,
> Tom
> 
>>
