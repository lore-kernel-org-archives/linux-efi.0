From: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 01/20] efi: Add support for a UEFI variable
 filesystem
Date: Sun, 4 Nov 2012 20:55:28 +0000
Message-ID: <20121104205528.GA23326@srcf.ucam.org>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
 <1351237923-10313-2-git-send-email-matt@console-pimps.org>
 <1351846416.14888.155.camel@mfleming-mobl1.ger.corp.intel.com>
 <20121103002249.63eb4142@pyramind.ukuu.org.uk>
 <20121103002132.GB18691@srcf.ucam.org>
 <1352060878.14888.193.camel@mfleming-mobl1.ger.corp.intel.com>
 <20121104203437.GA23130@srcf.ucam.org>
 <1352062026.14888.199.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1352062026.14888.199.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, Nov 04, 2012 at 08:47:06PM +0000, Matt Fleming wrote:

> Because from what I can see, not only does ia64 not fill out the
> query_variable_info() pointer in struct efi, struct efi is in the data
> segment, and so, contains an uninitialised pointer.

Oh, right. Another argument for some unified EFI code. Sigh. My only 
concern in that case is that someone's going to fix this at some point 
and then be confused as to why it doesn't work on ARM.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
