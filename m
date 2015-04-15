From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v4 1/2] firmware_loader: introduce new API -
 request_firmware_direct_full_path()
Date: Wed, 15 Apr 2015 12:09:05 +0100
Message-ID: <20150415110905.GC4804@codeblueprint.co.uk>
References: <1429004697-28320-1-git-send-email-hock.leong.kweh@intel.com>
 <1429004697-28320-2-git-send-email-hock.leong.kweh@intel.com>
 <20150414140806.GD5989@kroah.com>
 <CALCETrW_aXJ1iiXCa6aTE3r3J3EF_Njn5bb9=At_3ajCzPFSPg@mail.gmail.com>
 <20150414161833.GE14069@pd.tnic>
 <20150415101455.GB4804@codeblueprint.co.uk>
 <20150415101805.GC2282@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150415101805.GC2282-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Ong Boon Leong <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 15 Apr, at 12:18:05PM, Borislav Petkov wrote:
> On Wed, Apr 15, 2015 at 11:14:55AM +0100, Matt Fleming wrote:
> > Well, I haven't come across a scenario where you need a brand new
> > interface for getting it *out* of the kernel again.
> 
> Well, how are we going to read crash data on next boot then? EFI var or
> what? Are we going to have a generic interface like
> 
> /sys/.../capsule/...
> 
> or how are we imagining this to look like?
 
You can read it out in userspace using the existing pstorefs code. The
last thing we need to do is introduce more userspace APIs ;-)

It's possible (and desirable) to separate the input interface from
output.

I've written patches in the past where the EFI kernel subsystem
discovers capsules with a specific GUID reserved for crash data, and
then hands that data to the pstore subsystem. Things are then exposed
via pstorefs. The capsule code would just be another backend to pstore,
similar to how the EFI variable code works today.

I am in no way advocating for yet another crash API.

-- 
Matt Fleming, Intel Open Source Technology Center
