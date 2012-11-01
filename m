From: Matthew Garrett <mjg@redhat.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Thu, 1 Nov 2012 16:26:51 +0000
Message-ID: <20121101162651.GD13132@srcf.ucam.org>
References: <36538307.gzWq1oO7Kg@linux-lqwf.site>
 <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
 <1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
 <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
 <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
 <1351780935.2391.58.camel@dabdike.int.hansenpartnership.com>
 <20121101144912.GA10269@srcf.ucam.org>
 <1351782390.2391.69.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1351782390.2391.69.camel@dabdike.int.hansenpartnership.com>
Sender: linux-security-module-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>, Chris Friesen <chris.friesen@genband.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 01, 2012 at 03:06:30PM +0000, James Bottomley wrote:

> But surely that's fanciful ... you've already compromised windows to get
> access to the ESP.  If you've done it once, you can do it again until
> the exploit is patched.  There are likely many easier ways of ensuring
> persistence than trying to install a full linux kernel with a
> compromised resume system.

There's a pretty strong distinction between "Machine is exploited until 
exploit is patched" and "Machine is exploited until drive is replaced".

-- 
Matthew Garrett | mjg59@srcf.ucam.org
