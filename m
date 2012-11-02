From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Fri, 2 Nov 2012 10:55:32 -0400
Message-ID: <20121102145532.GE3300@redhat.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Eric Paris <eparis@parisplace.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>, Chris Friesen <chris.friesen@genband.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 01, 2012 at 10:29:17AM -0400, Eric Paris wrote:
> On Thu, Nov 1, 2012 at 5:59 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> 
> > But that doesn't really help me: untrusted root is an oxymoron.
> 
> Imagine you run windows and you've never heard of Linux.  You like
> that only windows kernels can boot on your box and not those mean
> nasty hacked up malware kernels.  Now some attacker manages to take
> over your box because you clicked on that executable for young models
> in skimpy bathing suits.  That executable rewrote your bootloader to
> launch a very small carefully crafted Linux environment.  This

Rewrote bootloader on disk so that it gets executed next time? It
will not run as signature will not match.

Thanks
Vivek
