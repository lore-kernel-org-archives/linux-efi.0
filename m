From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: Do not allow MSR or Embedded Controller writes from userspace
 in secure boot case
Date: Thu, 8 Nov 2012 14:41:25 +0000
Message-ID: <20121108144125.GC24094@srcf.ucam.org>
References: <1352323699-52400-1-git-send-email-trenn@suse.de>
 <20121107215403.GA7277@srcf.ucam.org>
 <509AE5DA.1030508@zytor.com>
 <201211081538.34091.trenn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201211081538.34091.trenn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Renninger <trenn-l3A5Bk7waGM@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jlee-IBi9RG/b67k@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 08, 2012 at 03:38:33PM +0100, Thomas Renninger wrote:

> BTW: Who decides what is allowed and what is not?

Tree maintainers.

> I guess it should be the spec. I haven't read the details, but
> when even Matthew is not sure, it sounds as if this is phrased
> rather imprecise. And as Windows is afaik the central key authority
> they can enforce their interpretation of the spec for Linux as well?

The spec is purely mechanism, not policy. Policy is up to the OS 
vendors.

> I like to have this boot parameter to also work the
> other way around:
> secureboot_enable=no
> and let all secure boot things fall off, only set a
> TAINT_INSECURE_BOOT_EVEN_BIOS_REQUESTED_SECURE_BOOT
> 
> Can SUSE sign this kernel without fearing to get the key revoked
> from Windows?

If anyone used that kernel to attack Windows, the signature would get 
revoked.

> Can this exist in the mainline kernel?

Sure, but vendors might want to patch it out, depending on how paranoid 
they are.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
