From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC PATCH v2 11/20] mm: Access BOOT related data in the clear
Date: Thu, 15 Sep 2016 11:52:05 -0500
Message-ID: <d25531f2-cc17-aa65-c6b9-f72e97b69b00@amd.com>
References: <20160822223529.29880.50884.stgit@tlendack-t1.amdoffice.net>
	<20160822223738.29880.6909.stgit@tlendack-t1.amdoffice.net>
	<CALCETrUk2kRSzKfwhio6KV3iuYaSV2uxybd-e95kK3vY=yTSfg@mail.gmail.com>
	<e30ddb53-df6c-28ee-54fe-f3e52e515acb@amd.com>
	<20160915095709.GB16797@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20160915095709.GB16797-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
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
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kvm list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kasan-dev <kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 09/15/2016 04:57 AM, Matt Fleming wrote:
> On Wed, 14 Sep, at 09:20:44AM, Tom Lendacky wrote:
>> On 09/12/2016 11:55 AM, Andy Lutomirski wrote:
>>> On Aug 22, 2016 6:53 PM, "Tom Lendacky" <thomas.lendacky-5C7GfCeVMHo@public.gmane.org> wrote:
>>>>
>>>> BOOT data (such as EFI related data) is not encyrpted when the system is
>>>> booted and needs to be accessed as non-encrypted.  Add support to the
>>>> early_memremap API to identify the type of data being accessed so that
>>>> the proper encryption attribute can be applied.  Currently, two types
>>>> of data are defined, KERNEL_DATA and BOOT_DATA.
>>>
>>> What happens when you memremap boot services data outside of early
>>> boot?  Matt just added code that does this.
>>>
>>> IMO this API is not so great.  It scatters a specialized consideration
>>> all over the place.  Could early_memremap not look up the PA to figure
>>> out what to do?
>>
>> Yes, I could see if the PA falls outside of the kernel usable area and,
>> if so, remove the memory encryption attribute from the mapping (for both
>> early_memremap and memremap).
>>
>> Let me look into that, I would prefer something along that line over
>> this change.
> 
> So, the last time we talked about using the address to figure out
> whether to encrypt/decrypt you said,
> 
>  "I looked into this and this would be a large change also to parse
>   tables and build lists."
> 
> Has something changed that makes this approach easier?

The original idea of parsing the tables and building a list was
a large change.  This approach would be simpler by just checking if
the PA is outside the kernel usable area, and if so, removing the
encryption bit.

> 
> And again, you need to be careful with the EFI kexec code paths, since
> you've got a mixture of boot and kernel data being passed. In
> particular the EFI memory map is allocated by the firmware on first
> boot (BOOT_DATA) but by the kernel on kexec (KERNEL_DATA).
> 
> That's one of the reasons I suggested requiring the caller to decide
> on BOOT_DATA vs KERNEL_DATA - when you start looking at kexec the
> distinction isn't easily made.

Yeah, for kexec I think I'll need to make sure that everything looks
like it came from the BIOS/UEFI/bootloader.  If all of the kexec
pieces are allocated with un-encrypted memory, then the boot path
should remain the same.  That's the piece I need to investigate
further.

Thanks,
Tom

> 
