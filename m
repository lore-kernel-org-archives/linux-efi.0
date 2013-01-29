From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [patch] x86, efi: precedence error in setup_efi_pci()
Date: Tue, 29 Jan 2013 11:04:08 +0000
Message-ID: <1359457448.8282.77.camel@mfleming-mobl1.ger.corp.intel.com>
References: <20121207061649.GA18220@elgon.mountain>
	 <loom.20130129T111316-368@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20130129T111316-368-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vitaly Budovski <vbudovski+news-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(Cc'ing some folks so this doesn't get lost completely)

On Tue, 2013-01-29 at 10:20 +0000, Vitaly Budovski wrote:
> Dan Carpenter <dan.carpenter@...> writes:
> 
> > 
> > Negate has higher precedence than bitwise AND so the condition is always
> > false.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@...>
> > index b1942e2..18e329c 100644
> > -		if (!attributes & EFI_PCI_IO_ATTRIBUTE_EMBEDDED_ROM)
> > +		if (!(attributes & EFI_PCI_IO_ATTRIBUTE_EMBEDDED_ROM))
>  
> 
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
