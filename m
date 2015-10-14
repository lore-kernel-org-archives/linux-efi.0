From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH] x86: setup: extend low identity map to cover whole kernel range
Date: Wed, 14 Oct 2015 09:22:03 -0700
Message-ID: <CALCETrX=4NcbfnaQ7wf27v+xn8dY_=acJwX4EjWZVTTWZeJ_yg@mail.gmail.com>
References: <1444822245-6784-1-git-send-email-pbonzini@redhat.com> <20151014135211.GB2782@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151014135211.GB2782-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 14, 2015 at 6:52 AM, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> (Pulling in luto for low-level x86 fu)
>
> On Wed, 14 Oct, at 01:30:45PM, Paolo Bonzini wrote:
>> On 32-bit systems, the initial_page_table is reused by
>> efi_call_phys_prolog as an identity map to call
>> SetVirtualAddressMap.  efi_call_phys_prolog takes care of
>> converting the current CPU's GDT to a physical address too.
>>
>> For PAE kernels the identity mapping is achieved by aliasing the
>> first PDPE for the kernel memory mapping into the first PDPE
>> of initial_page_table.  This makes the EFI stub's trick "just work".
>>
>> However, for non-PAE kernels there is no guarantee that the identity
>> mapping in the initial_page_table extends as far as the GDT; in this
>> case, accesses to the GDT will cause a page fault (which quickly becomes
>> a triple fault).  Fix this by copying the kernel mappings from
>> swapper_pg_dir to initial_page_table twice, both at PAGE_OFFSET and at
>> identity mapping.
>
> Oops, good catch guys. This is clearly a bug, but...
>
>> For some reason, this is only reproducible with QEMU's dynamic translation
>> mode, and not for example with KVM.  However, even under KVM one can clearly
>> see that the page table is bogus:

I haven't looked at the code, but it wouldn't surprise me if this is
some kind of TLB issue.  With the hardware TLB (which is in use on
KVM), it seems quite likely that the GDT is pretty much always in the
TLB and, if nothing flushes global mappings, then it'll probably stick
around.

--Andy
