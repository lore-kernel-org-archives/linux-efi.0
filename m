From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [GIT PULL] hash addresses printed with %p
Date: Thu, 30 Nov 2017 16:32:35 +0000
Message-ID: <20171130163235.GA27849@kroah.com>
References: <20171129045927.GA6217@eros>
 <CA+55aFzVy-SE9w1puPjgE1BxGje8oR3Ks9BDU7GXmvBYJfkCxw@mail.gmail.com>
 <20171129210848.GF6217@eros>
 <CA+55aFwjhjGZC9U68mo4hnnJXLWYxG3UYoz-=SwNfO-3N-Untg@mail.gmail.com>
 <CA+55aFwPXV0sXb+edcQc4epz0pWustZgJsoq95=a3OEDxynq7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFwPXV0sXb+edcQc4epz0pWustZgJsoq95=a3OEDxynq7g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Tobin C. Harding" <me-xzjC0nNlxno@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 29, 2017 at 01:36:25PM -0800, Linus Torvalds wrote:
> On Wed, Nov 29, 2017 at 1:14 PM, Linus Torvalds
> <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> >
> > Not because %pK itself changed, but because the semantics of %p did.
> > The baseline moved, and the "safe" version did not.
> 
> Btw, that baseline for me is now that I can do
> 
>   ./scripts/leaking_addresses.pl | wc -l
>   18
> 
> and of those 18 hits, six are false positives (looks like bitmaps in
> the uevent keys).
> 
> The remaining 12 are from the EFI runtime map files
> (/sys/firmware/efi/runtime-map/*). They should presumably not be
> world-readable, but sadly the kset_create_and_add() helper seems to do
> that by default.
> 
> I think the sysfs code makes it insanely too easy to make things
> world-readable. You try to be careful, and mark things read-only etc,
> but __ATTR_RO() jkust means S_IRUGO, which means world-readable.
> 
> There seems to be no convenient model for kobjects having better
> permissions. Greg?

They can just use __ATTR() which lets you set the exact mode settings
that are wanted.

Something like the patch below, which breaks the build as the
map_attributes are "odd", but you get the idea.  The EFI developers can
fix this up properly :)

Note, this only accounts for 5 attributes, what is the whole list?

thanks,

greg k-h

diff --git a/drivers/firmware/efi/runtime-map.c b/drivers/firmware/efi/runtime-map.c
index 8e64b77aeac9..09444964c8d7 100644
--- a/drivers/firmware/efi/runtime-map.c
+++ b/drivers/firmware/efi/runtime-map.c
@@ -63,11 +63,11 @@ static ssize_t map_attr_show(struct kobject *kobj, struct attribute *attr,
 	return map_attr->show(entry, buf);
 }
 
-static struct map_attribute map_type_attr = __ATTR_RO(type);
-static struct map_attribute map_phys_addr_attr   = __ATTR_RO(phys_addr);
-static struct map_attribute map_virt_addr_attr  = __ATTR_RO(virt_addr);
-static struct map_attribute map_num_pages_attr  = __ATTR_RO(num_pages);
-static struct map_attribute map_attribute_attr  = __ATTR_RO(attribute);
+static struct map_attribute map_type_attr = __ATTR(type, 0400, type_show, NULL);
+static struct map_attribute map_phys_addr_attr  = __ATTR(phys_addr, 0400, phys_addr_show, NULL);
+static struct map_attribute map_virt_addr_attr  = __ATTR(virt_addr, 0400, virt_addr_show, NULL);
+static struct map_attribute map_num_pages_attr  = __ATTR(num_pages, 0400, num_pages_show, NULL);
+static struct map_attribute map_attribute_attr  = __ATTR(attribute, 0400, attribute_show, NULL);
 
 /*
  * These are default attributes that are added for every memmap entry.
