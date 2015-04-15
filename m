From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v4 1/2] firmware_loader: introduce new API -
 request_firmware_direct_full_path()
Date: Wed, 15 Apr 2015 11:14:55 +0100
Message-ID: <20150415101455.GB4804@codeblueprint.co.uk>
References: <1429004697-28320-1-git-send-email-hock.leong.kweh@intel.com>
 <1429004697-28320-2-git-send-email-hock.leong.kweh@intel.com>
 <20150414140806.GD5989@kroah.com>
 <CALCETrW_aXJ1iiXCa6aTE3r3J3EF_Njn5bb9=At_3ajCzPFSPg@mail.gmail.com>
 <20150414161833.GE14069@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150414161833.GE14069-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Ong Boon Leong <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 14 Apr, at 06:18:33PM, Borislav Petkov wrote:
> On Tue, Apr 14, 2015 at 11:56:26AM -0400, Andy Lutomirski wrote:
> > This is why I think that the right approach would be to avoid using
> > firmware_class entirely for this.  IMO a simple_char device would be
> > the way to go (hint hint...) but other simple approaches are certainly
> > possible.
> 
> Btw, didn't mfleming want to try using capsules for other funky stuff
> like early logging and pstore-like logging in panic time so that we can
> read out crash data on the next boot?
 
Yeah, exactly. Being able to pass random data blobs to the capsule
internals allows the kernel to support cool things we haven't conceived
of yet, and where we want to use the capsule's in-memory persistence
across reboot to pass data to the next kernel.

The panic code paths is just one example.

> Which would mean that capsules would need a completely different
> interface, something new for shuffling lotsa binary data in and out of
> the kernel and in and out of the UEFI...
> 
> Which would make the firmware_class thing completely inappropriate for
> that.

Well, I haven't come across a scenario where you need a brand new
interface for getting it *out* of the kernel again. And I'm happy enough
with these patches for passing data in.

-- 
Matt Fleming, Intel Open Source Technology Center
