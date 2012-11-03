From: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 01/20] efi: Add support for a UEFI variable
 filesystem
Date: Sat, 3 Nov 2012 00:21:32 +0000
Message-ID: <20121103002132.GB18691@srcf.ucam.org>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
 <1351237923-10313-2-git-send-email-matt@console-pimps.org>
 <1351846416.14888.155.camel@mfleming-mobl1.ger.corp.intel.com>
 <20121103002249.63eb4142@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121103002249.63eb4142-38n7/U1jhRXW96NNrWNlrekiAK3p4hvP@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Nov 03, 2012 at 12:22:49AM +0000, Alan Cox wrote:

> This still attempts to allocate arbitary user provided values of memory.
> This is still broken. Even in the extreme case of 'root only, right thing
> to do' then this is broken as you don't pass __GFP_NOWARN. However if you
> can have very large strings remember that big values handled this way are
> actually effectively implemented as
> 
> 	"maybe set the value or randomly return -ENOMEM possibly until a
> 	reboot"
> 
> so if your real upper limit is huge then this isn't good. If on the other
> hand its things like 32K or so then you just want NOWARN.

Yeah. It's fair that this should be limited to whatever 
QueryVariableInfo() returns on systems that have that, and say 64K on 
older systems.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
