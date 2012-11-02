From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Fri, 2 Nov 2012 14:00:57 +0000
Message-ID: <20121102140057.GA4668@srcf.ucam.org>
References: <CACLa4pu0yoB6CQX=3nuAT2vz4=oTNfM9fjMUvFXKJovYu+y4fw@mail.gmail.com>
 <1351803800.2391.96.camel@dabdike.int.hansenpartnership.com>
 <20121101210634.GA19723@srcf.ucam.org>
 <20121101213127.5967327f@pyramind.ukuu.org.uk>
 <20121101212843.GA20309@srcf.ucam.org>
 <20121101213751.377ebaa8@pyramind.ukuu.org.uk>
 <20121101213452.GA20564@srcf.ucam.org>
 <20121101215817.79e50ec2@pyramind.ukuu.org.uk>
 <20121101215752.GA21154@srcf.ucam.org>
 <87625ogzje.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87625ogzje.fsf@xmission.com>
Sender: linux-security-module-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>, Chris Friesen <chris.friesen@genband.com>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Fri, Nov 02, 2012 at 01:49:25AM -0700, Eric W. Biederman wrote:

> When the goal is to secure Linux I don't see how any of this helps.
> Windows 8 compromises are already available so if we turn most of these
> arguments around I am certain clever attackers can go through windows to
> run compromised kernel on a linux system, at least as easily as the
> reverse.

And if any of them are used to attack Linux, we'd expect those versions 
of Windows to be blacklisted.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
