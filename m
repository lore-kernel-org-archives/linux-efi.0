From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Sat, 03 Nov 2012 12:03:56 +0000
Message-ID: <1351944236.2417.7.camel@dabdike.int.hansenpartnership.com>
References: <20121101202701.GB20817@xo-6d-61-c0.localdomain>
	 <5092E361.7080901@genband.com> <20121102163302.GA6080@elf.ucw.cz>
	 <1351875164.2439.42.camel@dabdike.int.hansenpartnership.com>
	 <20121102165456.GB9997@srcf.ucam.org>
	 <1351878511.2439.44.camel@dabdike.int.hansenpartnership.com>
	 <20121102175416.GA11816@srcf.ucam.org>
	 <1351879058.2439.46.camel@dabdike.int.hansenpartnership.com>
	 <20121102180458.GA12052@srcf.ucam.org>
	 <1351899503.2439.49.camel@dabdike.int.hansenpartnership.com>
	 <20121103002244.GC18691@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20121103002244.GC18691@srcf.ucam.org>
Sender: linux-security-module-owner@vger.kernel.org
To: Matthew Garrett <mjg@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>, Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Sat, 2012-11-03 at 00:22 +0000, Matthew Garrett wrote:
> On Fri, Nov 02, 2012 at 11:38:23PM +0000, James Bottomley wrote:
> > On Fri, 2012-11-02 at 18:04 +0000, Matthew Garrett wrote:
> > > A user runs a binary that elevates itself to admin. Absent any flaws in 
> > > Windows (cough), that should be all it can do in a Secure Boot world. 
> > > But if you can drop a small trusted Linux system in there and use that 
> > > to boot a compromised Windows kernel, it can make itself persistent.
> > 
> > We seem to be talking past each other.  Assume you managed to install a
> > Linux boot system on the windows machine.  If the linux boot requires
> > present user on first boot (either because the key of the bootloader
> > isn't in db or because the MOK database isn't initialised), you still
> > don't have a compromise because the loader won't start automatically.
> 
> Why would an attacker use one of those Linux systems? There's going to 
> be plenty available that don't have that restriction.

It's called best practices.  If someone else releases something that
doesn't conform to them, then it's their signing key in jeopardy, not
yours.  You surely must see that the goal of securing "everything"
against "anything" isn't achievable because if someone releases a
bootloader not conforming to the best practices, why would they have
bothered to include your secure boot lockdowns in their kernel.  In
other words, you lost ab initio, so it's pointless to cite this type of
thing as a rationale for a kernel lockdown patch.

James



