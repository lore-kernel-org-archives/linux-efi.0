From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Thu, 1 Nov 2012 21:06:34 +0000
Message-ID: <20121101210634.GA19723@srcf.ucam.org>
References: <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
 <1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
 <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
 <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
 <1351780935.2391.58.camel@dabdike.int.hansenpartnership.com>
 <CACLa4pvh3v3Mhq8oe3dzRL8ytBgmitPkCGUSfVCR5WdQopjRMQ@mail.gmail.com>
 <1351783096.2391.77.camel@dabdike.int.hansenpartnership.com>
 <CACLa4pu0yoB6CQX=3nuAT2vz4=oTNfM9fjMUvFXKJovYu+y4fw@mail.gmail.com>
 <1351803800.2391.96.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1351803800.2391.96.camel@dabdike.int.hansenpartnership.com>
Sender: linux-security-module-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>, Chris Friesen <chris.friesen@genband.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 01, 2012 at 09:03:20PM +0000, James Bottomley wrote:
> On Thu, 2012-11-01 at 13:50 -0400, Eric Paris wrote:
> > What do we have to do to prevent Linux being used to attack Linux
> > which may lead to secure boot being useless.
> 
> That's not really remotely related, is it?  Microsoft doesn't really
> care about Linux on Linux attacks, so preventing or allowing them isn't
> going to get a distro key revoked.

Linux vendors may care about Linux on Linux attacks. It's all fun and 
games until Oracle get Microsoft to revoke Red Hat's signature.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
