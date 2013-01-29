From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [patch] x86, efi: precedence error in setup_efi_pci()
Date: Tue, 29 Jan 2013 11:30:45 +0000
Message-ID: <1359459045.8282.79.camel@mfleming-mobl1.ger.corp.intel.com>
References: <20121207061649.GA18220@elgon.mountain>
	  <loom.20130129T111316-368@post.gmane.org>
	 <1359457448.8282.77.camel@mfleming-mobl1.ger.corp.intel.com>
	 <5107AF9F.8020800@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5107AF9F.8020800-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Vitaly Budovski <vbudovski+news-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2013-01-29 at 03:16 -0800, H. Peter Anvin wrote:
> On 01/29/2013 03:04 AM, Matt Fleming wrote:
> > (Cc'ing some folks so this doesn't get lost completely)
> >
> 
> I thought this got pushed to Linus already?  Did I get confused and 
> forget or something?

You didn't forget anything - it was pushed to Linus. I was quoting
Vitaly's bug report because there were no Cc's on his email,

> Hi,
> 
> This patch breaks the detection of ATI VBIOS for me on a MacBook Pro 8,2.
> 
> 
> Regards,
> 
> Vitaly

-- 
Matt Fleming, Intel Open Source Technology Center
