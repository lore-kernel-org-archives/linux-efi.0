From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [GIT PULL] hash addresses printed with %p
Date: Tue, 5 Dec 2017 09:52:19 +0100
Message-ID: <20171205085219.GA16055@kroah.com>
References: <20171204092928.GA4421@dhcp-128-65.nay.redhat.com>
 <20171204093430.GA6463@kroah.com>
 <CAKv+Gu8iOF1BCpZEVRwT=_6FbXsK0ve7fiWKA5R0D5x2P5MavA@mail.gmail.com>
 <20171204095936.GA10547@kroah.com>
 <CAKv+Gu9_BC=rHPRWBJXtg=Sn2TmPL21wYCS50a_ff_eav3nSOA@mail.gmail.com>
 <d455baafa3d44669a774c7d555c01416@AcuMS.aculab.com>
 <20171204140012.GA8744@kroah.com>
 <20171205051434.GA6086@dhcp-128-65.nay.redhat.com>
 <20171205080957.GA18268@kroah.com>
 <20171205084537.GA5974@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171205084537.GA5974@dhcp-128-65.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: David Laight <David.Laight@ACULAB.COM>, 'Ard Biesheuvel' <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, Linus Torvalds <torvalds@linux-foundation.org>, "Tobin C. Harding" <me@tobin.cc>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Dec 05, 2017 at 04:45:37PM +0800, Dave Young wrote:
> On 12/05/17 at 09:09am, Greg Kroah-Hartman wrote:
> > On Tue, Dec 05, 2017 at 01:14:34PM +0800, Dave Young wrote:
> > > On 12/04/17 at 03:00pm, Greg Kroah-Hartman wrote:
> > > > On Mon, Dec 04, 2017 at 12:51:13PM +0000, David Laight wrote:
> > > > > From: Ard Biesheuvel
> > > > > > Sent: 04 December 2017 10:03
> > > > > ...
> > > > > > and uses __ATTR_RO() to emit initializers for it. __ATTR() initializes
> > > > > > the .store member as well, which does not exists, and so it cannot be
> > > > > > used directly.
> > > > > > 
> > > > > > So we should either add a .store member that is always NULL, or we
> > > > > > should add our own
> > > > > > 
> > > > > > #define __ATTR_0400(_name) { \
> > > > > > .attr = { .name = __stringify(_name), .mode = 0400 }, \
> > > > > > .show = _name##_show, \
> > > > > > }
> > > > > 
> > > > > What about an __ATTR_RO_MODE(name, mode) that doesn't set the .store member.
> > > > > Even if the mode allowed write, writes wouldn't happen.
> > > > 
> > > > Ah, that might work, could you convert the other users of __ATTR() in
> > > > the efi code to use it as well?
> > > 
> > > $ grep __ATTR * -RI
> > > efi.c:			__ATTR(systab, 0400, systab_show, NULL);
> > > efi.c:static struct kobj_attribute efi_attr_fw_vendor = __ATTR_RO(fw_vendor);
> > > efi.c:static struct kobj_attribute efi_attr_runtime = __ATTR_RO(runtime);
> > > efi.c:static struct kobj_attribute efi_attr_config_table = __ATTR_RO(config_table);
> > > efi.c:	__ATTR_RO(fw_platform_size);
> > > esrt.c:static struct esre_attribute esre_fw_class = __ATTR(fw_class, 0400,
> > > esrt.c:static struct esre_attribute esre_##name = __ATTR(name, 0400, \
> > > esrt.c:static struct kobj_attribute esrt_##name = __ATTR(name, 0400, \
> > > runtime-map.c:static struct map_attribute map_type_attr = __ATTR_RO(type);
> > > runtime-map.c:static struct map_attribute map_phys_addr_attr   = __ATTR_RO(phys_addr);
> > > runtime-map.c:static struct map_attribute map_virt_addr_attr  = __ATTR_RO(virt_addr);
> > > runtime-map.c:static struct map_attribute map_num_pages_attr  = __ATTR_RO(num_pages);
> > > runtime-map.c:static struct map_attribute map_attribute_attr  = __ATTR_RO(attribute);
> > > 
> > > Above is all the __ATTR users for drivers/firmware/efi/*, it makes sense
> > > to update all __ATTR_RO to __ATTR_RO_MODE, so efi.c, runtime-map.c, and
> > > drivers/firmware/dmi-sysfs.c can be updated.  But esrt.c __ATTR seems
> > > not necessary.
> > > 
> > > And if so __ATTR_RO_MODE(name, mode) still needs go to sysfs.h.
> > > 
> > > I can do it but need confirm, Is this what you prefer?
> > 
> > Yes, how about the patch below, it builds for me, haven't done anything
> > other than that to test it :)
> 
> Thanks! Let me do a kexec test and a boot test for esrt.
> 
> > 
> > Also, what's with the multi-line sysfs file systab?  That's really not
> > allowed, can you please remove it?  Also the first check for !kobj and
> > !buf is funny, that can never happen.
> 
> I thought to do that, but later worried about it will break things:
> http://lists.infradead.org/pipermail/kexec/2013-December/010759.html

Heh, I guess I complained about this in the past :)

So what userspace tool uses it?

Are these values all exported through sysfs already?  If not, do that
first.

> I also thought to add code comment to avoid future expanding of this
> file. Maybe we can do this now.

Please do, but it should be a separate patch.

thanks,

greg k-h
