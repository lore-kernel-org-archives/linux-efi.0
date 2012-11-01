From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Thu, 1 Nov 2012 15:06:54 +0000
Message-ID: <20121101150654.19efe0b5@pyramind.ukuu.org.uk>
References: <2548314.3caaFsMVg6@linux-lqwf.site>
	<50919EED.3020601@genband.com>
	<36538307.gzWq1oO7Kg@linux-lqwf.site>
	<1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
	<alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
	<1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
	<alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
	<1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
	<CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
	<1351780935.2391.58.camel@dabdike.int.hansenpartnership.com>
	<20121101144912.GA10269@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20121101144912.GA10269@srcf.ucam.org>
Sender: linux-security-module-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>, Chris Friesen <chris.friesen@genband.com>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

> The entire point of this feature is that it's no longer possible to turn 
> a privileged user exploit into a full system exploit. Gaining admin 
> access on Windows 8 doesn't permit you to install a persistent backdoor, 

Really, that would be a first. Do you have a detailed knowledge of
windows 8 actual security ?

> unless there's some way to circumvent that. Which there is, if you can 
> drop a small Linux distribution onto the ESP and use a signed, trusted 
> bootloader to boot a signed, trusted kernel that then resumes from an 
> unsigned, untrusted hibernate image. So we have to ensure that that's 
> impossible.

Well if you want to make Linux entirely robust Red Hat could start
helping with some of the 6000 odd coverity matches some of which will
most certainly turn out to be real flaws.

Alan
