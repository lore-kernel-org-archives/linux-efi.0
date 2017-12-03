From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [GIT PULL] hash addresses printed with %p
Date: Sun, 3 Dec 2017 09:15:41 +0800
Message-ID: <20171203011541.GB2378@dhcp-128-65.nay.redhat.com>
References: <CA+55aFzVy-SE9w1puPjgE1BxGje8oR3Ks9BDU7GXmvBYJfkCxw@mail.gmail.com>
 <20171129210848.GF6217@eros>
 <CA+55aFwjhjGZC9U68mo4hnnJXLWYxG3UYoz-=SwNfO-3N-Untg@mail.gmail.com>
 <CA+55aFwPXV0sXb+edcQc4epz0pWustZgJsoq95=a3OEDxynq7g@mail.gmail.com>
 <20171130163235.GA27849@kroah.com>
 <20171130171036.GB31817@kroah.com>
 <CAKv+Gu_KF+BzFGaqYo1ZZAj9j+HkUogAksDFAkBDELU7m1XcPw@mail.gmail.com>
 <20171201094846.GE9353@kroah.com>
 <CAKv+Gu-YyuE-Hs4MVPWfS8Exx0S6qo5sgV2VdO0MP5wEXSrM1Q@mail.gmail.com>
 <20171202222244.GA3799@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171202222244.GA3799-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Tobin C. Harding" <me-xzjC0nNlxno@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12/02/17 at 10:22pm, Matt Fleming wrote:
> (Cc'ing Dave since this is used for kexec on EFI)
> 
> On Fri, 01 Dec, at 09:54:43AM, Ard Biesheuvel wrote:
> > On 1 December 2017 at 09:48, Greg Kroah-Hartman
> > <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> > > On Thu, Nov 30, 2017 at 05:18:42PM +0000, Ard Biesheuvel wrote:
> > >> On 30 November 2017 at 17:10, Greg Kroah-Hartman
> > >> <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> > >> > On Thu, Nov 30, 2017 at 04:32:35PM +0000, Greg Kroah-Hartman wrote:
> > >> >> On Wed, Nov 29, 2017 at 01:36:25PM -0800, Linus Torvalds wrote:
> > >> >> > On Wed, Nov 29, 2017 at 1:14 PM, Linus Torvalds
> > >> >> > <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> > >> >> > >
> > >> >> > > Not because %pK itself changed, but because the semantics of %p did.
> > >> >> > > The baseline moved, and the "safe" version did not.
> > >> >> >
> > >> >> > Btw, that baseline for me is now that I can do
> > >> >> >
> > >> >> >   ./scripts/leaking_addresses.pl | wc -l
> > >> >> >   18
> > >> >> >
> > >> >> > and of those 18 hits, six are false positives (looks like bitmaps in
> > >> >> > the uevent keys).
> > >> >> >
> > >> >> > The remaining 12 are from the EFI runtime map files
> > >> >> > (/sys/firmware/efi/runtime-map/*). They should presumably not be
> > >> >> > world-readable, but sadly the kset_create_and_add() helper seems to do
> > >> >> > that by default.
> > >> >> >
> > >> >> > I think the sysfs code makes it insanely too easy to make things
> > >> >> > world-readable. You try to be careful, and mark things read-only etc,
> > >> >> > but __ATTR_RO() jkust means S_IRUGO, which means world-readable.
> > >> >> >
> > >> >> > There seems to be no convenient model for kobjects having better
> > >> >> > permissions. Greg?
> > >> >>
> > >> >> They can just use __ATTR() which lets you set the exact mode settings
> > >> >> that are wanted.
> > >> >>
> > >> >> Something like the patch below, which breaks the build as the
> > >> >> map_attributes are "odd", but you get the idea.  The EFI developers can
> > >> >> fix this up properly :)
> > >> >>
> > >> >> Note, this only accounts for 5 attributes, what is the whole list?
> > >> >
> > >> > Ah, it's the virt_addr file 12 times, I just ran it on my laptop:
> > >> >
> > >> > /sys/firmware/efi/runtime-map/7/virt_addr: 0xfffffffeea6ea000
> > >> > /sys/firmware/efi/runtime-map/5/virt_addr: 0xfffffffeee88b000
> > >> > /sys/firmware/efi/runtime-map/3/virt_addr: 0xfffffffefea00000
> > >> > /sys/firmware/efi/runtime-map/11/virt_addr: 0xfffffffed9c00000
> > >> > /sys/firmware/efi/runtime-map/1/virt_addr: 0xfffffffefee00000
> > >> > /sys/firmware/efi/runtime-map/8/virt_addr: 0xfffffffedba4e000
> > >> > /sys/firmware/efi/runtime-map/6/virt_addr: 0xfffffffeee2de000
> > >> > /sys/firmware/efi/runtime-map/4/virt_addr: 0xfffffffeeea00000
> > >> > /sys/firmware/efi/runtime-map/2/virt_addr: 0xfffffffefec00000
> > >> > /sys/firmware/efi/runtime-map/10/virt_addr: 0xfffffffed9c60000
> > >> > /sys/firmware/efi/runtime-map/0/virt_addr: 0xfffffffeff000000
> > >> > /sys/firmware/efi/runtime-map/9/virt_addr: 0xfffffffedb9c9000
> > >> >
> > >> > So changing it to use __ATTR() should fix this remaning leakage up.
> > >> > That is if we even really need to export these values at all.  What does
> > >> > userspace do with them?  Shouldn't they just be in debugfs instead?
> > >> >
> > >>
> > >> These are the virtual mappings UEFI firmware regions, which must
> > >> remain in the same place across kexec reboots. So kexec tooling
> > >> consumes this information and passes it on to the incoming kernel in
> > >> some way.
> > >>
> > >> Note that these are not kernel addresses, so while I agree they should
> > >> not be world readable, they won't give you any clue as to where the
> > >> kernel itself is mapped.
> > >>
> > >> So the recommendation is to switch to __ATTR( ... 0400 ... ) instead?
> > >> If so, I'll code up a patch.
> > >
> > > If these pointers are not "real", I recommend just leaving them as-is.
> > 
> > That's not what I said :-)
> > 
> > These are real pointers, and stuff will actually be mapped there
> > (although I am not intimately familiar with the way x86 does this, but
> > on ARM [which does not have these sysfs nodes in the first place],
> > these mappings are only live during the time a UEFI runtime service
> > call is in progress, and IIRC, work was underway to do the same for
> > x86). So while these values don't correlate with the placement of
> > kernel data structures, they could still be useful for an attacker to
> > figure out where exploitable firmware memory regions are located,
> > especially given that some of these may be mapped RWX.
> 
> These are mappings of the EFI firmware's runtime regions, dynamically
> allocated by the kernel starting at EFI_VA_START. Because we only get
> one chance to tell the firmware where we placed its regions (via
> SetVirtualAddressMap()) we have to guarantee that any subsequent kexec
> reboots use the same addresses.
> 
> So that's why they're exported to userspace through sysfs.
> 
> Like Ard said, these mappings are not mapped into the regular process
> address space. Instead, they're only used while making EFI runtime
> calls.
> 
> But this is still an information leak. And I think _ATTR(..0400) is
> the right way to fix it. Dave, could you double-check my logic and
> write a patch?

Matt, thanks for ccing me, I will look into it.

Thanks
Dave
