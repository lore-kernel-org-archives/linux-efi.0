From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efivarfs: fix abnormal GUID in variable name by using
 strcpy to replace null with dash
Date: Wed, 06 Mar 2013 11:21:27 +0000
Message-ID: <1362568887.15011.27.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1362108018-13117-1-git-send-email-jlee@suse.com>
	  <1362151068.2842.440.camel@mfleming-mobl1.ger.corp.intel.com>
	  <1362155493.2842.446.camel@mfleming-mobl1.ger.corp.intel.com>
	  <1362181299.23932.168.camel@linux-s257.site>
	 <1362555258.23932.573.camel@linux-s257.site> <51370A51.1050505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51370A51.1050505-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: joeyli <jlee-IBi9RG/b67k@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Schroeder <mls-IBi9RG/b67k@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Frederic Crozat <fcrozat-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 2013-03-06 at 17:20 +0800, Lingzhu Xiang wrote:
> On 03/06/2013 03:34 PM, joeyli wrote:
> > +static unsigned long variable_name_length(efi_char16_t *variable_name)
> > +{
> > +	unsigned long len;
> > +	efi_char16_t c;
> > +
> > +	len = 2;
> > +	do {
> > +		c = variable_name[len / sizeof(c) - 1];
> > +		if (c)
> > +			len += sizeof(c);
> > +	} while (c);
> > +
> > +	return len;
> > +}
> > +
> 
> It looks like this function can be replaced with utf16_strsize.

Nearly. For this particular case we also need to count the terminating
NULL.

-- 
Matt Fleming, Intel Open Source Technology Center
