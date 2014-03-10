From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [patch] x86/efi: use GFP_ATOMIC under spin_lock
Date: Mon, 10 Mar 2014 16:10:06 +0000
Message-ID: <20140310161006.GA30582@console-pimps.org>
References: <20140309161946.GA10262@console-pimps.org>
 <20140309163141.GA18824@srcf.ucam.org>
 <20140309185028.GB10262@console-pimps.org>
 <531D7786020000780012230D@nat28.tlf.novell.com>
 <20140310073753.GA4658@gmail.com>
 <531D7BA80200007800122349@nat28.tlf.novell.com>
 <20140310075306.GB4939@gmail.com>
 <531D84670200007800122375@nat28.tlf.novell.com>
 <20140310104328.GG10262@console-pimps.org>
 <531DAA7602000078001224EF@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <531DAA7602000078001224EF-ce6RLXgGx+vWGUEhTRrCg1aTQe2KTcn/@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Nathan Zimmer <nzimmer-sJ/iWh9BUns@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 10 Mar, at 11:05:10AM, Jan Beulich wrote:
> 
> Not sure why you call them useless. If wired up properly, they
> would be useful on systems where they work.
 
They're useless in the sense that they have no users in the kernel
currently.

> Which kernel functions? Perhaps just a misunderstanding - I
> gave that example with the actual hypervisor in mind, not the
> kernel side code sitting on top. The kernel, after all, can't
> directly call EFI runtime code when running on top of Xen.

OK, that's my bad, I misunderstood what you were saying.

-- 
Matt Fleming, Intel Open Source Technology Center
