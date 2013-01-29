From: Vitaly Budovski <vbudovski+news-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch] x86, efi: precedence error in =?utf-8?b?c2V0dXBfZWZpX3BjaSgp?=
Date: Tue, 29 Jan 2013 10:20:06 +0000 (UTC)
Message-ID: <loom.20130129T111316-368@post.gmane.org>
References: <20121207061649.GA18220@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Dan Carpenter <dan.carpenter@...> writes:

> 
> Negate has higher precedence than bitwise AND so the condition is always
> false.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@...>
> index b1942e2..18e329c 100644
> -		if (!attributes & EFI_PCI_IO_ATTRIBUTE_EMBEDDED_ROM)
> +		if (!(attributes & EFI_PCI_IO_ATTRIBUTE_EMBEDDED_ROM))
 

Hi,

This patch breaks the detection of ATI VBIOS for me on a MacBook Pro 8,2.


Regards,

Vitaly
