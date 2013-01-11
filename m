From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 17/20] efivarfs: Replace magic number with
 sizeof(attributes)
Date: Fri, 11 Jan 2013 13:30:26 +0000
Message-ID: <1357911026.8203.315.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
	 <1351237923-10313-18-git-send-email-matt@console-pimps.org>
	 <50DAC252.5030308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50DAC252.5030308-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 2012-12-26 at 17:24 +0800, Lingzhu Xiang wrote:
> On 10/26/2012 03:52 PM, Matt Fleming wrote:
> > From: Matt Fleming<matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > Seeing "+ 4" littered throughout the functions gets a bit
> > confusing. Use "sizeof(attributes)" which clearly explains what
> > quantity we're adding.
> >
> > Acked-by: Jeremy Kerr<jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> > Signed-off-by: Matt Fleming<matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Looks like one +4 got left behind, in efivarfs_fill_super
> 
> 		i_size_write(inode, size+4);

Yep, so it does. I'll cook something up, thanks.

-- 
Matt Fleming, Intel Open Source Technology Center
