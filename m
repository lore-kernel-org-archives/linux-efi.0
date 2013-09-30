From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Date: Mon, 30 Sep 2013 23:06:46 +0200
Message-ID: <20130930210646.GF19411@pd.tnic>
References: <e39e1065bddc2afee2cb6eed957e3ba8.squirrel@www.skyhub.de>
 <52422A6A.8080305@zytor.com>
 <20130926031242.GA4487@dhcp-16-126.nay.redhat.com>
 <20130930201730.GD16383@pd.tnic>
 <20130930203505.GA6116@redhat.com>
 <20130930204154.GE19411@pd.tnic>
 <20130930204642.GB6116@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130930204642.GB6116-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, James Bottomley <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Sep 30, 2013 at 04:46:42PM -0400, Vivek Goyal wrote:
> On Mon, Sep 30, 2013 at 10:41:54PM +0200, Borislav Petkov wrote:
> 
> [..]
> > hpa, so, for the struct efi_mapping thing to work, I will have to grep
> > dmesg of the first kernel to get an output like the one below, filter
> > the runtime regions so that I can build the struct efi_mapping array of
> > mem regions which I pass on to the second, kexec kernel with setup_data.
> 
> Any data you need to pass to second kernel will have to be exported to
> user space either using /sys or /proc so that kexec-tools can parse it.

And I cannot parse dmesg? Because I have all the info there already.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
