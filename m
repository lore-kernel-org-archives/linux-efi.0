From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] hash addresses printed with %p
Date: Tue, 5 Dec 2017 09:25:07 +0000
Message-ID: <CAKv+Gu9=4Rrgb3UgmP37LpTjd_xzZ2aVqA2KMAkek9Wxr8fSTA@mail.gmail.com>
References: <20171204092928.GA4421@dhcp-128-65.nay.redhat.com>
 <20171204093430.GA6463@kroah.com> <CAKv+Gu8iOF1BCpZEVRwT=_6FbXsK0ve7fiWKA5R0D5x2P5MavA@mail.gmail.com>
 <20171204095936.GA10547@kroah.com> <CAKv+Gu9_BC=rHPRWBJXtg=Sn2TmPL21wYCS50a_ff_eav3nSOA@mail.gmail.com>
 <d455baafa3d44669a774c7d555c01416@AcuMS.aculab.com> <20171204140012.GA8744@kroah.com>
 <20171205051434.GA6086@dhcp-128-65.nay.redhat.com> <20171205080957.GA18268@kroah.com>
 <20171205084537.GA5974@dhcp-128-65.nay.redhat.com> <20171205085219.GA16055@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171205085219.GA16055-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Laight <David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Tobin C. Harding" <me-xzjC0nNlxno@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 5 December 2017 at 08:52, Greg Kroah-Hartman
<gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> On Tue, Dec 05, 2017 at 04:45:37PM +0800, Dave Young wrote:
>> On 12/05/17 at 09:09am, Greg Kroah-Hartman wrote:
>> > On Tue, Dec 05, 2017 at 01:14:34PM +0800, Dave Young wrote:
>> > > On 12/04/17 at 03:00pm, Greg Kroah-Hartman wrote:
>> > > > On Mon, Dec 04, 2017 at 12:51:13PM +0000, David Laight wrote:
>> > > > > From: Ard Biesheuvel
>> > > > > > Sent: 04 December 2017 10:03
>> > > > > ...
>> > > > > > and uses __ATTR_RO() to emit initializers for it. __ATTR() initializes
>> > > > > > the .store member as well, which does not exists, and so it cannot be
>> > > > > > used directly.
>> > > > > >
>> > > > > > So we should either add a .store member that is always NULL, or we
>> > > > > > should add our own
>> > > > > >
>> > > > > > #define __ATTR_0400(_name) { \
>> > > > > > .attr = { .name = __stringify(_name), .mode = 0400 }, \
>> > > > > > .show = _name##_show, \
>> > > > > > }
>> > > > >
>> > > > > What about an __ATTR_RO_MODE(name, mode) that doesn't set the .store member.
>> > > > > Even if the mode allowed write, writes wouldn't happen.
>> > > >
>> > > > Ah, that might work, could you convert the other users of __ATTR() in
>> > > > the efi code to use it as well?
>> > >
>> > > $ grep __ATTR * -RI
>> > > efi.c:                    __ATTR(systab, 0400, systab_show, NULL);
>> > > efi.c:static struct kobj_attribute efi_attr_fw_vendor = __ATTR_RO(fw_vendor);
>> > > efi.c:static struct kobj_attribute efi_attr_runtime = __ATTR_RO(runtime);
>> > > efi.c:static struct kobj_attribute efi_attr_config_table = __ATTR_RO(config_table);
>> > > efi.c:    __ATTR_RO(fw_platform_size);
>> > > esrt.c:static struct esre_attribute esre_fw_class = __ATTR(fw_class, 0400,
>> > > esrt.c:static struct esre_attribute esre_##name = __ATTR(name, 0400, \
>> > > esrt.c:static struct kobj_attribute esrt_##name = __ATTR(name, 0400, \
>> > > runtime-map.c:static struct map_attribute map_type_attr = __ATTR_RO(type);
>> > > runtime-map.c:static struct map_attribute map_phys_addr_attr   = __ATTR_RO(phys_addr);
>> > > runtime-map.c:static struct map_attribute map_virt_addr_attr  = __ATTR_RO(virt_addr);
>> > > runtime-map.c:static struct map_attribute map_num_pages_attr  = __ATTR_RO(num_pages);
>> > > runtime-map.c:static struct map_attribute map_attribute_attr  = __ATTR_RO(attribute);
>> > >
>> > > Above is all the __ATTR users for drivers/firmware/efi/*, it makes sense
>> > > to update all __ATTR_RO to __ATTR_RO_MODE, so efi.c, runtime-map.c, and
>> > > drivers/firmware/dmi-sysfs.c can be updated.  But esrt.c __ATTR seems
>> > > not necessary.
>> > >
>> > > And if so __ATTR_RO_MODE(name, mode) still needs go to sysfs.h.
>> > >
>> > > I can do it but need confirm, Is this what you prefer?
>> >
>> > Yes, how about the patch below, it builds for me, haven't done anything
>> > other than that to test it :)
>>
>> Thanks! Let me do a kexec test and a boot test for esrt.
>>
>> >
>> > Also, what's with the multi-line sysfs file systab?  That's really not
>> > allowed, can you please remove it?  Also the first check for !kobj and
>> > !buf is funny, that can never happen.
>>
>> I thought to do that, but later worried about it will break things:
>> http://lists.infradead.org/pipermail/kexec/2013-December/010759.html
>
> Heh, I guess I complained about this in the past :)
>
> So what userspace tool uses it?
>

On x86, it is mostly tools that read DMI tables via /dev/mem, and use
/sys/firmware/efi/systab to locate them. dmidecode, lscpu, etc

That does mean we could investigate which entries are actually used,
and at least start removing the ones we don't need.

> Are these values all exported through sysfs already?  If not, do that
> first.
>
>> I also thought to add code comment to avoid future expanding of this
>> file. Maybe we can do this now.
>
> Please do, but it should be a separate patch.
>
> thanks,
>
> greg k-h
