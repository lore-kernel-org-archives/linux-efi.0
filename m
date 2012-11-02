From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Fri, 2 Nov 2012 23:46:07 +0000
Message-ID: <20121102234607.26cc2cbb@pyramind.ukuu.org.uk>
References: <CACLa4pu0yoB6CQX=3nuAT2vz4=oTNfM9fjMUvFXKJovYu+y4fw@mail.gmail.com>
	<1351803800.2391.96.camel@dabdike.int.hansenpartnership.com>
	<20121101210634.GA19723@srcf.ucam.org>
	<20121101213127.5967327f@pyramind.ukuu.org.uk>
	<20121101212843.GA20309@srcf.ucam.org>
	<20121101213751.377ebaa8@pyramind.ukuu.org.uk>
	<20121101213452.GA20564@srcf.ucam.org>
	<20121101215817.79e50ec2@pyramind.ukuu.org.uk>
	<20121101215752.GA21154@srcf.ucam.org>
	<87625ogzje.fsf@xmission.com>
	<20121102140057.GA4668@srcf.ucam.org>
	<87liejacix.fsf@xmission.com>
	<509446FB.5000504@genband.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <509446FB.5000504@genband.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Chris Friesen <chris.friesen@genband.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Matthew Garrett <mjg59@srcf.ucam.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Fri, 02 Nov 2012 16:19:39 -0600
Chris Friesen <chris.friesen@genband.com> wrote:

> On 11/02/2012 04:03 PM, Eric W. Biederman wrote:
> > Matthew Garrett<mjg59@srcf.ucam.org>  writes:
> >
> >> On Fri, Nov 02, 2012 at 01:49:25AM -0700, Eric W. Biederman wrote:
> >>
> >>> When the goal is to secure Linux I don't see how any of this helps.
> >>> Windows 8 compromises are already available so if we turn most of these
> >>> arguments around I am certain clever attackers can go through windows to
> >>> run compromised kernel on a linux system, at least as easily as the
> >>> reverse.
> >>
> >> And if any of them are used to attack Linux, we'd expect those versions
> >> of Windows to be blacklisted.

This is the first laugh. So they revoke the key. For that to be useful
they must propogate that into all the boxes in warehouses and all the new
boxes. If they do that then all the existing store stock of Windows 8 DVD
and CD media needs replacing.

> > I don't want my system p0wned in the first place and I don't want to run
> > windows.  Why should I trust Microsoft's signing key?
> 
> In any case, you don't need to trust Microsoft's signing key...at least 
> on x86 hardware you can install your own.  But if you want consumer 
> hardware to be able to boot linux out-of-the-box without messing with 
> BIOS settings then we need a bootloader that has been signed by Microsoft.

Or a machine that has other keys in it, isn't sold locked down or doesn't
have lunatic boot firmware.

Alan
