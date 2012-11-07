From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [PATCH] x86/EFI: additional checks in efi_bgrt_init()
Date: Wed, 7 Nov 2012 14:52:04 +0000
Message-ID: <20121107145204.GA30662@srcf.ucam.org>
References: <5097E8C102000078000A661B@nat28.tlf.novell.com>
 <20121105183751.GA9031@jtriplet-mobl1>
 <20121105184346.GA13508@srcf.ucam.org>
 <20121105190047.GA9295@jtriplet-mobl1>
 <509A82E402000078000A6FC8@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <509A82E402000078000A6FC8-ce6RLXgGx+vWGUEhTRrCg1aTQe2KTcn/@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, mingo-X9Un+BFzKDI@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 07, 2012 at 02:48:52PM +0000, Jan Beulich wrote:

> On my system, the table points to EfiReservedMemoryType
> and appears to have valid data despite the valid flag being
> clear. But before encoding the invalidation into Xen in a form
> other than clearing the valid bit, I'd really like to get
> confirmation that e.g. clearing the image address is indeed a
> "proper" thing to do. If no-one among you can "officially" tell
> what the intentions here are, would you know who can?

If you don't want to provide it at all, just don't provide a BGRT. 
Microsoft wrote that bit of the ACPI spec, so you'd probably need to ask 
them what their intentions were.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
