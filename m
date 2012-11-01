From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Thu, 1 Nov 2012 15:11:35 +0000
Message-ID: <20121101151135.6211b2fb@pyramind.ukuu.org.uk>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	<2548314.3caaFsMVg6@linux-lqwf.site>
	<50919EED.3020601@genband.com>
	<36538307.gzWq1oO7Kg@linux-lqwf.site>
	<1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
	<alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
	<1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
	<alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
	<1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
	<CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
	<1351780935.2391.58.camel@dabdike.int.hansenpartnership.com>
	<CACLa4pvh3v3Mhq8oe3dzRL8ytBgmitPkCGUSfVCR5WdQopjRMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACLa4pvh3v3Mhq8oe3dzRL8ytBgmitPkCGUSfVCR5WdQopjRMQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Paris <eparis@parisplace.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>, Chris Friesen <chris.friesen@genband.com>, Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

> would get keys revoked.  If your key is revoke Linux can't boot on a
> large amount of new hardware without BIOS twiddling.

See "live free or die". If you want to live in a world where you can't
even fart before checking if the man from Microsoft will revoke your key
you might as well go home now.

> The point of secureboot is even if the admin did something which
> allowed his kernel to be compromised, it won't persist.  Sure,
> secureboot moves the attack up the stack to userspace, but at least we
> can do something about the kernel.

Nice theory.

At the end of the day I don't care if you want to produce this stuff and
sell it to people. Fine, the interface proposed is clean enough that it
doesn't pee on other work, but don't expect the rest of the world to
follow mindlessly into your slave pit driven by your fear.

Alan
