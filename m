From: Chris Friesen <chris.friesen@genband.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Thu, 01 Nov 2012 15:02:25 -0600
Message-ID: <5092E361.7080901@genband.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com> <2548314.3caaFsMVg6@linux-lqwf.site> <50919EED.3020601@genband.com> <36538307.gzWq1oO7Kg@linux-lqwf.site> <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com> <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz> <1351762703.2391.31.camel@dabdike.int.hansenpartnership.com> <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz> <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com> <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com> <20121101202701.GB20817@xo-6d-61-c0.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121101202701.GB20817@xo-6d-61-c0.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Eric Paris <eparis@parisplace.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 11/01/2012 02:27 PM, Pavel Machek wrote:

> Could someone write down exact requirements for Linux kernel to be signed by Microsoft?
> Because thats apparently what you want, and I don't think crippling kexec/suspend is
> enough.

As I understand it, the kernel won't be signed by Microsoft.

Rather, the bootloader will be signed by Microsoft and the vendors will 
be the ones that refuse to sign a kernel unless it is reasonably assured 
that it won't be used as an attack vector.

If you want fully-open behaviour it's still possible, you just need to 
turn off secure boot.

With secure boot enabled, then the kernel should refuse to let an 
unsigned kexec load new images, and kexec itself should refuse to load 
unsigned images.  Also the kernel would need to sign its 
"suspend-to-disk" images and refuse to resume unsigned images.

Presumably the signing key for the "suspend-to-disk" images would need 
to be stored somewhere that is not accessable even by root.  It's not 
clear to me how we would do this, but maybe it's possible with hardware 
support.

Chris
