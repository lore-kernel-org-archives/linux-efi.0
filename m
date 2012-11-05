From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH] x86/EFI: additional checks in efi_bgrt_init()
Date: Mon, 5 Nov 2012 10:37:52 -0800
Message-ID: <20121105183751.GA9031@jtriplet-mobl1>
References: <5097E8C102000078000A661B@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5097E8C102000078000A661B-ce6RLXgGx+vWGUEhTRrCg1aTQe2KTcn/@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Cc: mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 05, 2012 at 03:26:41PM +0000, Jan Beulich wrote:
> Header length should be validated for all ACPI tables before accessing
> any non-header field.
> 
> The valid flags should also be check, as with it clear there's no point
> in trying to go through the rest of the code (and there's no guarantee
> that the other table contents are valid/consistent in that case).
> 
> Signed-off-by: Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>

The length check seems reasonable.  However, Matthew Garrett (already
CCed) previously suggested to me that this code should not check the
"valid" bit, and should instead present the information to userspace if
otherwise valid (such as having image_address != 0).  Matthew?

Out of curiosity, did you encounter a system that requires this patch?

- Josh Triplett
