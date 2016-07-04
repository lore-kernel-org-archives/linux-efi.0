From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: MemoryOverwriteRequestControl
Date: Mon, 4 Jul 2016 23:26:09 +0100
Message-ID: <20160704222609.GB5160@srcf.ucam.org>
References: <CACxGe6s7rgTBUf7jtN6J3i3w-HvAm2rFnjjwCtWRS6oHx3ZB5A@mail.gmail.com>
 <1467667917.2288.23.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1467667917.2288.23.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jul 04, 2016 at 02:31:57PM -0700, James Bottomley wrote:

> Currently, the kernel does nothing with this, but you'd more expect
> something in userspace to do something with it, probably a component of
> the TSS.

The OS loader is expected to set MOR to 1, so given the boot stub 
there's need for kernel support. A "correct" implementation would also 
involve the kernel clearing all its secrets before reboot and then 
setting it back to 0, so I don't think we can just punt responsibility 
to userspace.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
