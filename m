From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] x86: setup: extend low identity map to cover whole kernel range
Date: Thu, 15 Oct 2015 05:18:56 -0700
Message-ID: <AADA20F3-1661-4014-90DC-C2BB68230392@zytor.com>
References: <1444822245-6784-1-git-send-email-pbonzini@redhat.com> <20151014135211.GB2782@codeblueprint.co.uk> <CALCETrX=4NcbfnaQ7wf27v+xn8dY_=acJwX4EjWZVTTWZeJ_yg@mail.gmail.com> <20151014210050.GE2782@codeblueprint.co.uk> <CALCETrU=YL8yWpp29xO0N7TEVogX1j5Fyk5M_FpJTa9ZOS21Zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrU=YL8yWpp29xO0N7TEVogX1j5Fyk5M_FpJTa9ZOS21Zw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On October 14, 2015 2:39:58 PM PDT, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>On Wed, Oct 14, 2015 at 2:00 PM, Matt Fleming
><matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
>> On Wed, 14 Oct, at 09:22:03AM, Andy Lutomirski wrote:
>>> On Wed, Oct 14, 2015 at 6:52 AM, Matt Fleming
><matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
>>> > (Pulling in luto for low-level x86 fu)
>>> >
>>> > On Wed, 14 Oct, at 01:30:45PM, Paolo Bonzini wrote:
>>> >> On 32-bit systems, the initial_page_table is reused by
>>> >> efi_call_phys_prolog as an identity map to call
>>> >> SetVirtualAddressMap.  efi_call_phys_prolog takes care of
>>> >> converting the current CPU's GDT to a physical address too.
>>> >>
>>> >> For PAE kernels the identity mapping is achieved by aliasing the
>>> >> first PDPE for the kernel memory mapping into the first PDPE
>>> >> of initial_page_table.  This makes the EFI stub's trick "just
>work".
>>> >>
>>> >> However, for non-PAE kernels there is no guarantee that the
>identity
>>> >> mapping in the initial_page_table extends as far as the GDT; in
>this
>>> >> case, accesses to the GDT will cause a page fault (which quickly
>becomes
>>> >> a triple fault).  Fix this by copying the kernel mappings from
>>> >> swapper_pg_dir to initial_page_table twice, both at PAGE_OFFSET
>and at
>>> >> identity mapping.
>>> >
>>> > Oops, good catch guys. This is clearly a bug, but...
>>> >
>>> >> For some reason, this is only reproducible with QEMU's dynamic
>translation
>>> >> mode, and not for example with KVM.  However, even under KVM one
>can clearly
>>> >> see that the page table is bogus:
>>>
>>> I haven't looked at the code, but it wouldn't surprise me if this is
>>> some kind of TLB issue.  With the hardware TLB (which is in use on
>>> KVM), it seems quite likely that the GDT is pretty much always in
>the
>>> TLB and, if nothing flushes global mappings, then it'll probably
>stick
>>> around.
>>
>> From some quick experiments it appears that you can skate past this
>> issue if you don't receive any interrupts while the bogus GDT pointer
>> is loaded, or if you avoid reloading the segment registers in
>general.
>> Which is interesting because I assumed that writing to GDTR took
>> immediate effect.
>
>Trivia for your amusement:
>
>AFAICT it's entirely permissible for the GDTR and/or LDT descriptor to
>point to unmapped memory.  Any attempt to use them (segment loads,
>interrupts, IRET, etc) will try to access that memory as if the access
>came from CPL 0 and, if the access fails, will generate a valid page
>fault with CR2 pointing into the GDT or LDT.
>
>Xen is nuts^Wclever and actually uses this.
>
>Of course, if your #PF vector references a GDT or LDT descriptor and
>trying to load that descriptor results in a page fault, you get a
>double fault.
>
>I learned this while trying to puzzle out why v1 of my LDT
>synchronization patch caused random faults on Xen.
>
>--Andy

There is no "if"... you can't get to an interrupt vector without going through the GDT or LDT.  That being said, the GDT or LDT can be partially mapped.
-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
