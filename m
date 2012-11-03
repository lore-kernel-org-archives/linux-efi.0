From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Sat, 3 Nov 2012 16:37:27 +0000
Message-ID: <20121103163726.GA30689@srcf.ucam.org>
References: <20121101213452.GA20564@srcf.ucam.org>
 <20121101215817.79e50ec2@pyramind.ukuu.org.uk>
 <20121101215752.GA21154@srcf.ucam.org>
 <87625ogzje.fsf@xmission.com>
 <20121102140057.GA4668@srcf.ucam.org>
 <87liejacix.fsf@xmission.com>
 <20121103002033.GA18691@srcf.ucam.org>
 <87sj8rwm0p.fsf@xmission.com>
 <20121103014332.GA20065@srcf.ucam.org>
 <20121103163152.1405e2cb@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121103163152.1405e2cb@pyramind.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>, Chris Friesen <chris.friesen@genband.com>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Sat, Nov 03, 2012 at 04:31:52PM +0000, Alan Cox wrote:
> > You're guaranteed to be able 
> > to do this on any Windows 8 certified hardware.
> 
> Thats not my understanding of the situation.

"17. Mandatory. On non-ARM systems, the platform MUST implement the 
ability for a physically present user to select between two Secure Boot 
modes in firmware setup: "Custom" and "Standard". Custom Mode allows for 
more flexibility as specified in the following: 

a. It shall be possible for a physically present user to use the Custom 
Mode firmware setup option to modify the contents of the Secure Boot 
signature databases and the PK. This may be implemented by simply 
providing the option to clear all Secure Boot databases (PK, KEK, db, 
dbx), which puts the system into setup mode."

-- 
Matthew Garrett | mjg59@srcf.ucam.org
