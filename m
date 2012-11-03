From: Matthew Garrett <mjg@redhat.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Sat, 3 Nov 2012 00:23:39 +0000
Message-ID: <20121103002339.GD18691@srcf.ucam.org>
References: <20121101212843.GA20309@srcf.ucam.org>
 <20121101213751.377ebaa8@pyramind.ukuu.org.uk>
 <20121101213452.GA20564@srcf.ucam.org>
 <20121101215817.79e50ec2@pyramind.ukuu.org.uk>
 <20121101215752.GA21154@srcf.ucam.org>
 <87625ogzje.fsf@xmission.com>
 <20121102140057.GA4668@srcf.ucam.org>
 <87liejacix.fsf@xmission.com>
 <509446FB.5000504@genband.com>
 <20121102234607.26cc2cbb@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121102234607.26cc2cbb@pyramind.ukuu.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Chris Friesen <chris.friesen@genband.com>, "Eric W. Biederman" <ebiederm@xmission.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Fri, Nov 02, 2012 at 11:46:07PM +0000, Alan Cox wrote:
> On Fri, 02 Nov 2012 16:19:39 -0600
> Chris Friesen <chris.friesen@genband.com> wrote:
> > On 11/02/2012 04:03 PM, Eric W. Biederman wrote:
> > > Matthew Garrett<mjg59@srcf.ucam.org>  writes:
> > >> And if any of them are used to attack Linux, we'd expect those versions
> > >> of Windows to be blacklisted.
> 
> This is the first laugh. So they revoke the key. For that to be useful
> they must propogate that into all the boxes in warehouses and all the new
> boxes. If they do that then all the existing store stock of Windows 8 DVD
> and CD media needs replacing.

Revocation is done via Windows Update. If they refuse to do that, well, 
lawyers, right?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
