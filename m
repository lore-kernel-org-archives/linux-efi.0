From: Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH v9 07/38] x86/mm: Remove phys_to_virt() usage in ioremap()
Date: Tue, 11 Jul 2017 08:00:32 -0400
Message-ID: <CAMzpN2gZHis6_Y_B+DQmuY_ojBqoGBTCd2go+sM53pPaScTq+g@mail.gmail.com>
References: <20170707133804.29711.1616.stgit@tlendack-t1.amdoffice.net>
 <20170707133925.29711.39301.stgit@tlendack-t1.amdoffice.net>
 <CAMzpN2h=AAF6OVfeGJnf5va2Msmd_BPU5BrVENvs0zGQtRMdzQ@mail.gmail.com>
 <ca43df91-163e-82ce-1d40-c17cfc90e957@amd.com> <CAMzpN2gq0TZbgy-3PUixwvL+6ECX5bOdE0XZsLtGFXA+-Embeg@mail.gmail.com>
 <CAK8P3a3oBgE8ggAjVX6mtWKWwBmw3gYzgTqF3fh9KsQyEgL31g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <CAK8P3a3oBgE8ggAjVX6mtWKWwBmw3gYzgTqF3fh9KsQyEgL31g@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, linux-arch <linux-arch@vger.kernel.org>, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>, kexec@lists.infradead.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kasan-dev <kasan-dev@googlegroups.com>, xen-devel@lists.xen.org, Linux-MM <linux-mm@kvack.org>, "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>, Brijesh Singh <brijesh.singh@amd.com>, Toshimitsu Kani <toshi.kani@hpe.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, Alexander Potapenko <glider@google.com>, "H. Peter Anvin" <hpa@zytor.com>, Larry Woodman <lwoodman@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Joerg Roedel <joro@8bytes.org>, "Michael S. Tsirkin" <mst@redhat.com>, Ingo Molnar <mingo@redhat.com>, Andrey
List-Id: linux-efi@vger.kernel.org

On Tue, Jul 11, 2017 at 4:35 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tue, Jul 11, 2017 at 6:58 AM, Brian Gerst <brgerst@gmail.com> wrote:
>> On Mon, Jul 10, 2017 at 3:50 PM, Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>> On 7/8/2017 7:57 AM, Brian Gerst wrote:
>>>> On Fri, Jul 7, 2017 at 9:39 AM, Tom Lendacky <thomas.lendacky@amd.com>
>>>
>>> I originally had a check for SME here in a previous version of the
>>> patch.  Thomas Gleixner recommended removing the check so that the code
>>> path was always exercised regardless of the state of SME in order to
>>> better detect issues:
>>>
>>> http://marc.info/?l=linux-kernel&m=149803067811436&w=2
>>
>> Looking a bit closer, this shortcut doesn't set the caching
>> attributes.  So it's probably best to get rid of it anyways.  Also
>> note, there is a corresponding check in iounmap().

Perhaps the iounmap() check should be kept for now for safety, since
some drivers (vga16fb for example) call iounmap() blindly even if the
mapping wasn't returned from ioremap().  Maybe add a warning when an
ISA address is passed to iounmap().

> Could that cause regressions if a driver relies on (write-through)
> cacheable access to the VGA frame buffer RAM or an read-only
> cached access to an option ROM but now gets uncached access?

Yes there could be some surprises in drivers use the normal ioremap()
call which is uncached but were expecting the default write-through
mapping.

> I also tried to find out whether we can stop mapping the ISA MMIO
> area into the linear mapping, but at least the VGA code uses
> VGA_MAP_MEM() to get access to the same pointers. I'm pretty
> sure this got copied incorrectly into most other architectures, but
> it is definitely still used on x86 with vga16fb/vgacon/mdacon.

Changing VGA_MAP_MEM() to use ioremap_wt() would take care of that.
Although, looking at the mdacon/vgacon, they don't have support for
unmapping the frame buffer if they are built modular.

--
Brian Gerst

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
