From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Fri, 02 Nov 2012 15:03:02 -0700
Message-ID: <87liejacix.fsf@xmission.com>
References: <CACLa4pu0yoB6CQX=3nuAT2vz4=oTNfM9fjMUvFXKJovYu+y4fw@mail.gmail.com>
	<1351803800.2391.96.camel@dabdike.int.hansenpartnership.com>
	<20121101210634.GA19723@srcf.ucam.org>
	<20121101213127.5967327f@pyramind.ukuu.org.uk>
	<20121101212843.GA20309@srcf.ucam.org>
	<20121101213751.377ebaa8@pyramind.ukuu.org.uk>
	<20121101213452.GA20564@srcf.ucam.org>
	<20121101215817.79e50ec2@pyramind.ukuu.org.uk>
	<20121101215752.GA21154@srcf.ucam.org> <87625ogzje.fsf@xmission.com>
	<20121102140057.GA4668@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121102140057.GA4668@srcf.ucam.org> (Matthew Garrett's message
	of "Fri, 2 Nov 2012 14:00:57 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>, Chris Friesen <chris.friesen@genband.com>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Matthew Garrett <mjg59@srcf.ucam.org> writes:

> On Fri, Nov 02, 2012 at 01:49:25AM -0700, Eric W. Biederman wrote:
>
>> When the goal is to secure Linux I don't see how any of this helps.
>> Windows 8 compromises are already available so if we turn most of these
>> arguments around I am certain clever attackers can go through windows to
>> run compromised kernel on a linux system, at least as easily as the
>> reverse.
>
> And if any of them are used to attack Linux, we'd expect those versions 
> of Windows to be blacklisted.

I fail to see the logic here.  It is ok to trust Microsofts signing key
because after I have been p0wned they will blacklist the version of
windows that has was used to compromise my system?

A key revokation will help me when my system is p0wned how?

I don't want my system p0wned in the first place and I don't want to run
windows.  Why should I trust Microsoft's signing key?

Eric
