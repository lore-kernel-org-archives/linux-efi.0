From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v2 01/20] efi: Add support for a UEFI variable filesystem
Date: Sun, 04 Nov 2012 20:47:06 +0000
Message-ID: <1352062026.14888.199.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
	 <1351237923-10313-2-git-send-email-matt@console-pimps.org>
	 <1351846416.14888.155.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20121103002249.63eb4142@pyramind.ukuu.org.uk>
	 <20121103002132.GB18691@srcf.ucam.org>
	 <1352060878.14888.193.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20121104203437.GA23130@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121104203437.GA23130-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 2012-11-04 at 20:34 +0000, Matthew Garrett wrote:
> On Sun, Nov 04, 2012 at 08:27:58PM +0000, Matt Fleming wrote:
> 
> > +#ifdef CONFIG_X86
> > +	ops.query_variable_info = efi.query_variable_info;
> > +#endif
> 
> Why limit to x86? Otherwise, looks broadly good - I can try to test 
> tomorrow.

Because from what I can see, not only does ia64 not fill out the
query_variable_info() pointer in struct efi, struct efi is in the data
segment, and so, contains an uninitialised pointer.

Now, the proper approach would be to either implement
query_variable_info() or initialise the pointer to NULL. I don't have
any ia64 hardware for the former, but would be happy to carry a patch
for the latter if everyone else is happy with that.

-- 
Matt Fleming, Intel Open Source Technology Center
