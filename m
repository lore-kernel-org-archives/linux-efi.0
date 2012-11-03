From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Sat, 03 Nov 2012 22:56:40 +0000
Message-ID: <1351983400.2417.21.camel@dabdike.int.hansenpartnership.com>
References: <20121102163302.GA6080@elf.ucw.cz>
	 <1351875164.2439.42.camel@dabdike.int.hansenpartnership.com>
	 <20121102165456.GB9997@srcf.ucam.org>
	 <1351878511.2439.44.camel@dabdike.int.hansenpartnership.com>
	 <20121102175416.GA11816@srcf.ucam.org>
	 <1351879058.2439.46.camel@dabdike.int.hansenpartnership.com>
	 <20121102180458.GA12052@srcf.ucam.org>
	 <1351899503.2439.49.camel@dabdike.int.hansenpartnership.com>
	 <20121103002244.GC18691@srcf.ucam.org>
	 <1351944236.2417.7.camel@dabdike.int.hansenpartnership.com>
	 <20121103134630.GA28166@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121103134630.GA28166-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, 2012-11-03 at 13:46 +0000, Matthew Garrett wrote:
> On Sat, Nov 03, 2012 at 12:03:56PM +0000, James Bottomley wrote:
> > On Sat, 2012-11-03 at 00:22 +0000, Matthew Garrett wrote:
> > > Why would an attacker use one of those Linux systems? There's going to 
> > > be plenty available that don't have that restriction.
> > 
> > It's called best practices.  If someone else releases something that
> > doesn't conform to them, then it's their signing key in jeopardy, not
> > yours.  You surely must see that the goal of securing "everything"
> > against "anything" isn't achievable because if someone releases a
> > bootloader not conforming to the best practices, why would they have
> > bothered to include your secure boot lockdowns in their kernel.  In
> > other words, you lost ab initio, so it's pointless to cite this type of
> > thing as a rationale for a kernel lockdown patch.
> 
> I... what? Our signed bootloader will boot our signed kernel without any 
> physically present end-user involvement. We therefore need to make it 
> as difficult as practically possible for an attacker to use our signed 
> bootloader and our signed kernel as an attack vector against other 
> operating systems, which includes worrying about hibernate and kexec. If 
> people want to support this use case then patches to deal with that need 
> to be present in the upstream kernel.

Right, but what I'm telling you is that by deciding to allow automatic
first boot, you're causing the windows attack vector problem.  You could
easily do a present user test only on first boot which would eliminate
it.  Instead, we get all of this.

By analogy, it's like an architect trying to design a house to be secure
without a front door lock.  If you just secure the front door, you don't
necessarily need all the internal security.  There is certainly a market
for houses with good internal security, but not everyone wants the
hassle, so trying to make every house that way is counterproductive.
It's also not so useful to the people who want specialist internal
security because they're willing to use much more specialised systems
than you have to deploy generally.

In short, if you'd just separate the problem into

     1. What do we have to do to prevent Linux being used to attack
        windows and thus getting our key revoked from,
     2. What specialised systems can we put in place to enhance linux
        security with secure boot for those who want it

It becomes a lot simpler than trying to do a one size fits all solution.

James
