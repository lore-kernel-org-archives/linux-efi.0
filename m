From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Fri, 02 Nov 2012 17:47:02 -0700
Message-ID: <87sj8rwm0p.fsf@xmission.com>
References: <20121101210634.GA19723@srcf.ucam.org>
	<20121101213127.5967327f@pyramind.ukuu.org.uk>
	<20121101212843.GA20309@srcf.ucam.org>
	<20121101213751.377ebaa8@pyramind.ukuu.org.uk>
	<20121101213452.GA20564@srcf.ucam.org>
	<20121101215817.79e50ec2@pyramind.ukuu.org.uk>
	<20121101215752.GA21154@srcf.ucam.org> <87625ogzje.fsf@xmission.com>
	<20121102140057.GA4668@srcf.ucam.org> <87liejacix.fsf@xmission.com>
	<20121103002033.GA18691@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20121103002033.GA18691@srcf.ucam.org> (Matthew Garrett's message
	of "Sat, 3 Nov 2012 00:20:34 +0000")
Sender: linux-security-module-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>, Chris Friesen <chris.friesen@genband.com>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Matthew Garrett <mjg59@srcf.ucam.org> writes:

> On Fri, Nov 02, 2012 at 03:03:02PM -0700, Eric W. Biederman wrote:
>
>> I don't want my system p0wned in the first place and I don't want to run
>> windows.  Why should I trust Microsoft's signing key?
>
> There's no reason to. Systems that don't trust Microsoft's signing key 
> have no reason to be concerned about Microsoft revocation. 
> Unfortunately, that's not the only set of people we have to worry
> about.

No reason to?  How can I configure an off the shelf system originally
sold with windows 8 installed to boot in UEFI secure boot mode using
shim without trusting Microsoft's key?

Eric
