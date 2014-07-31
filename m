From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efi-bgrt: Add error handling; inform the user when
 ignoring the BGRT
Date: Thu, 31 Jul 2014 11:31:10 +0100
Message-ID: <20140731103110.GC15082@console-pimps.org>
References: <20140730192331.GA23730@jtriplet-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140730192331.GA23730@jtriplet-mobl1>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Srihari Vijayaraghavan <linux.bug.reporting-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 30 Jul, at 12:23:32PM, Josh Triplett wrote:
> Gracefully handle failures to allocate memory for the image, which might
> be arbitrarily large.
> 
> efi_bgrt_init can fail in various ways as well, usually because the
> BIOS-provided BGRT structure does not match expectations.  Add
> appropriate error messages rather than failing silently.
> 
> Reported-by: Srihari Vijayaraghavan

This could really do with an email address appending.

> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=81321
> Signed-off-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi-bgrt.c | 36 ++++++++++++++++++++++++++++++------
>  1 file changed, 30 insertions(+), 6 deletions(-)

[...]

> @@ -61,14 +81,18 @@ void __init efi_bgrt_init(void)
>  		early_iounmap(image, sizeof(bmp_header));
>  	bgrt_image_size = bmp_header.size;
>  
> -	bgrt_image = kmalloc(bgrt_image_size, GFP_KERNEL);
> -	if (!bgrt_image)
> +	bgrt_image = kmalloc(bgrt_image_size, GFP_KERNEL | __GFP_NOWARN);
> +	if (!bgrt_image) {
> +		pr_err("Ignoring BGRT: failed to allocate memory for image (wanted %zu bytes)\n",
> +		       bgrt_image_size);
>  		return;

I'm not sure that using __GFP_NOWARN is the right thing to do here. If
for some reason we can't handle the BGRT image we should include checks
in the BGRT code, rather than relying on the page-allocation machinery
to save us.

Let's just use an explicit limit on the size of the BGRT image we're
willing to handle.

Either way, this hunk shouldn't be mixed in with the improved error
logging changes, it needs to be a separate patch.

-- 
Matt Fleming, Intel Open Source Technology Center
