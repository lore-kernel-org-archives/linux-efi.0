From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Thu, 01 Nov 2012 09:08:25 +0000
Message-ID: <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	 <2548314.3caaFsMVg6@linux-lqwf.site> <50919EED.3020601@genband.com>
	 <36538307.gzWq1oO7Kg@linux-lqwf.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <36538307.gzWq1oO7Kg@linux-lqwf.site>
Sender: linux-security-module-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: Chris Friesen <chris.friesen@genband.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, 2012-10-31 at 23:19 +0100, Oliver Neukum wrote:
> On Wednesday 31 October 2012 15:58:05 Chris Friesen wrote:
> > On 10/31/2012 02:14 PM, Oliver Neukum wrote:
> 
> > > That would do it on my system.
> > > Maybe in theory you could solve this by the kernel invalidating images
> > > it hasn't written itself and forbidding to change the resume partition from the
> > > kernel command line, but that would break user space hibernation.
> > 
> > If the resuming kernel refuses to resume from images it didn't create 
> > itself, why do you need to forbid changing the resume partition from the 
> > kernel command line?
> 
> You don't. Signed images solve the problem.

I really don't think they do.  The proposed attack vector is to try to
prevent a local root exploit from running arbitrary in-kernel code,
because that would compromise the secure boot part of the kernel.

I really think that's mythical: a local privilege elevation attack
usually exploits some bug (classically a buffer overflow) which executes
arbitrary code in kernel context.  In that case, the same attack vector
can be used to compromise any in-kernel protection mechanism including
turning off the secure boot capability and reading the in-kernel private
signing key.

There have been one or two privilege elevation attacks that didn't
involve in-kernel code (usually by compromising a suid binary or other
cross domain scripting attack) that would only compromise local root and
thus be confined to the secure boot prison but they are, historically, a
minority.

The point I'm making is that given that the majority of exploits will
already be able to execute arbitrary code in-kernel, there's not much
point trying to consider features like this as attacker prevention.  We
should really be focusing on discussing why we'd want to prevent a
legitimate local root from writing to the suspend partition in a secure
boot environment.

James


