From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Wed, 31 Oct 2012 23:19:31 +0100
Message-ID: <36538307.gzWq1oO7Kg@linux-lqwf.site>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com> <2548314.3caaFsMVg6@linux-lqwf.site> <50919EED.3020601@genband.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <50919EED.3020601@genband.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Chris Friesen <chris.friesen@genband.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wednesday 31 October 2012 15:58:05 Chris Friesen wrote:
> On 10/31/2012 02:14 PM, Oliver Neukum wrote:

> > That would do it on my system.
> > Maybe in theory you could solve this by the kernel invalidating images
> > it hasn't written itself and forbidding to change the resume partition from the
> > kernel command line, but that would break user space hibernation.
> 
> If the resuming kernel refuses to resume from images it didn't create 
> itself, why do you need to forbid changing the resume partition from the 
> kernel command line?

You don't. Signed images solve the problem.

I was responding to Alan's assertation that the problem could be solved
without signing the images. It turns out tht any such scheme would have
unacceptable limitations.

The key problem is actually safely storing the public key needed to verify
the signature. This problem is also solvable. It just needs help from the
UEFI infrastructure.

	Regards
		Oliver

