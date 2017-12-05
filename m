From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [GIT PULL] hash addresses printed with %p
Date: Tue, 5 Dec 2017 17:24:10 +0800
Message-ID: <20171205092410.GA16190@dhcp-128-65.nay.redhat.com>
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
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171205084537.GA5974-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>, 'Ard Biesheuvel' <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Tobin C. Harding" <me-xzjC0nNlxno@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12/05/17 at 04:45pm, Dave Young wrote:
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

It works for me. esrt part only did a boot test and cat/ls.

> 
> > 
> > Also, what's with the multi-line sysfs file systab?  That's really not
> > allowed, can you please remove it?  Also the first check for !kobj and
> > !buf is funny, that can never happen.
> 
> I thought to do that, but later worried about it will break things:
> http://lists.infradead.org/pipermail/kexec/2013-December/010759.html
> 
> I also thought to add code comment to avoid future expanding of this
> file. Maybe we can do this now.
> 
> > 
> > Please turn all of those different values into different sysfs files.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > 
> > diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> > index f70febf680c3..c3eefa126e3b 100644
> > --- a/drivers/firmware/efi/efi.c
> > +++ b/drivers/firmware/efi/efi.c
> > @@ -143,8 +143,7 @@ static ssize_t systab_show(struct kobject *kobj,
> >  	return str - buf;
> >  }
> >  
> > -static struct kobj_attribute efi_attr_systab =
> > -			__ATTR(systab, 0400, systab_show, NULL);
> > +static struct kobj_attribute efi_attr_systab = __ATTR_RO_MODE(systab, 0400);
> >  
> >  #define EFI_FIELD(var) efi.var
> >  
> > diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
> > index bd7ed3c1148a..7aae2483fcb9 100644
> > --- a/drivers/firmware/efi/esrt.c
> > +++ b/drivers/firmware/efi/esrt.c
> > @@ -106,7 +106,7 @@ static const struct sysfs_ops esre_attr_ops = {
> >  };
> >  
> >  /* Generic ESRT Entry ("ESRE") support. */
> > -static ssize_t esre_fw_class_show(struct esre_entry *entry, char *buf)
> > +static ssize_t fw_class_show(struct esre_entry *entry, char *buf)
> >  {
> >  	char *str = buf;
> >  
> > @@ -117,18 +117,16 @@ static ssize_t esre_fw_class_show(struct esre_entry *entry, char *buf)
> >  	return str - buf;
> >  }
> >  
> > -static struct esre_attribute esre_fw_class = __ATTR(fw_class, 0400,
> > -	esre_fw_class_show, NULL);
> > +static struct esre_attribute esre_fw_class = __ATTR_RO_MODE(fw_class, 0400);
> >  
> >  #define esre_attr_decl(name, size, fmt) \
> > -static ssize_t esre_##name##_show(struct esre_entry *entry, char *buf) \
> > +static ssize_t name##_show(struct esre_entry *entry, char *buf) \
> >  { \
> >  	return sprintf(buf, fmt "\n", \
> >  		       le##size##_to_cpu(entry->esre.esre1->name)); \
> >  } \
> >  \
> > -static struct esre_attribute esre_##name = __ATTR(name, 0400, \
> > -	esre_##name##_show, NULL)
> > +static struct esre_attribute esre_##name = __ATTR_RO_MODE(name, 0400)
> >  
> >  esre_attr_decl(fw_type, 32, "%u");
> >  esre_attr_decl(fw_version, 32, "%u");
> > @@ -193,14 +191,13 @@ static int esre_create_sysfs_entry(void *esre, int entry_num)
> >  
> >  /* support for displaying ESRT fields at the top level */
> >  #define esrt_attr_decl(name, size, fmt) \
> > -static ssize_t esrt_##name##_show(struct kobject *kobj, \
> > +static ssize_t name##_show(struct kobject *kobj, \
> >  				  struct kobj_attribute *attr, char *buf)\
> >  { \
> >  	return sprintf(buf, fmt "\n", le##size##_to_cpu(esrt->name)); \
> >  } \
> >  \
> > -static struct kobj_attribute esrt_##name = __ATTR(name, 0400, \
> > -	esrt_##name##_show, NULL)
> > +static struct kobj_attribute esrt_##name = __ATTR_RO_MODE(name, 0400)
> >  
> >  esrt_attr_decl(fw_resource_count, 32, "%u");
> >  esrt_attr_decl(fw_resource_count_max, 32, "%u");
> > diff --git a/drivers/firmware/efi/runtime-map.c b/drivers/firmware/efi/runtime-map.c
> > index 8e64b77aeac9..f377609ff141 100644
> > --- a/drivers/firmware/efi/runtime-map.c
> > +++ b/drivers/firmware/efi/runtime-map.c
> > @@ -63,11 +63,11 @@ static ssize_t map_attr_show(struct kobject *kobj, struct attribute *attr,
> >  	return map_attr->show(entry, buf);
> >  }
> >  
> > -static struct map_attribute map_type_attr = __ATTR_RO(type);
> > -static struct map_attribute map_phys_addr_attr   = __ATTR_RO(phys_addr);
> > -static struct map_attribute map_virt_addr_attr  = __ATTR_RO(virt_addr);
> > -static struct map_attribute map_num_pages_attr  = __ATTR_RO(num_pages);
> > -static struct map_attribute map_attribute_attr  = __ATTR_RO(attribute);
> > +static struct map_attribute map_type_attr = __ATTR_RO_MODE(type, 0400);
> > +static struct map_attribute map_phys_addr_attr = __ATTR_RO_MODE(phys_addr, 0400);
> > +static struct map_attribute map_virt_addr_attr = __ATTR_RO_MODE(virt_addr, 0400);
> > +static struct map_attribute map_num_pages_attr = __ATTR_RO_MODE(num_pages, 0400);
> > +static struct map_attribute map_attribute_attr = __ATTR_RO_MODE(attribute, 0400);
> >  
> >  /*
> >   * These are default attributes that are added for every memmap entry.
> > diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
> > index e32dfe098e82..a886133ae15c 100644
> > --- a/include/linux/sysfs.h
> > +++ b/include/linux/sysfs.h
> > @@ -117,6 +117,11 @@ struct attribute_group {
> >  	.show	= _name##_show,						\
> >  }
> >  
> > +#define __ATTR_RO_MODE(_name, _mode) {					\
> > +	.attr	= { .name = __stringify(_name), .mode = _mode },	\
> > +	.show	= _name##_show,						\
> > +}
> > +
> >  #define __ATTR_WO(_name) {						\
> >  	.attr	= { .name = __stringify(_name), .mode = S_IWUSR },	\
> >  	.store	= _name##_store,					\
> 
> Thanks
> Dave
