From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] efi/esrt: cleanup bad memory map log messages
Date: Wed, 8 Feb 2017 09:22:02 -0500
Message-ID: <20170208142201.bjwafwxykj3i2icu@redhat.com>
References: <20170207190823.10223-1-drake@endlessm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170207190823.10223-1-drake-6IF/jdPJHihWk0Htik3J/w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Drake <drake-6IF/jdPJHihWk0Htik3J/w@public.gmane.org>
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-6IF/jdPJHihWk0Htik3J/w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Feb 07, 2017 at 01:08:23PM -0600, Daniel Drake wrote:
> The Intel Compute Stick STCK1A8LFC and Weibu F3C platforms both
> log 2 error messages during boot:
> 
>    efi: requested map not found.
>    esrt: ESRT header is not in the memory map.
> 
> Searching the web, this seems to affect many other platforms too.
> Since these messages are logged as errors, they appear on-screen during
> the boot process even when using the "quiet" boot parameter used by
> distros.
> 
> Demote the ESRT error to a warning so that it does not appear on-screen,
> and delete the error logging from efi_mem_desc_lookup; both callsites
> of that function log more specific messages upon failure.
> 
> Out of curiosity I looked closer at the Weibu F3C. There is no entry in
> the UEFI-provided memory map which corresponds to the ESRT pointer, but
> hacking the code to map it anyway, the ESRT does appear to be valid with
> 2 entries.

The machine you've got does seem to be presenting a valid (if poorly
considered) table, but I don't quite think this is the right approach.
The first hunk of your patch is fine, but the test on the result of
efi_mem_desc_lookup() is more or less our check for "might reading this
table reboot the system or worse".  You're demoting it to a warning
while still /treating/ it as an error, so at least it remains safe,
but the when we get to that point, they've (plausibly) given us data
that could cause horrible behavior, and that is a thing worth logging an
error about.

It would be better to /check/ if it straddles multiple contiguous
segments which both have reasonable access modes and print an error if
there are gaps.  I'm still in favor of printing a warning to the log if
it straddles them and there /aren't/ gaps, because we're *going* to see
other weird bugs from any code base that decides it's stitching config
tables together from separate allocations.  It's not a fundamentally
reasonable thing to do, and as a lens it shows us some code with a
really worrisome internal structure.

> 
> Signed-off-by: Daniel Drake <drake-6IF/jdPJHihWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/firmware/efi/efi.c  | 1 -
>  drivers/firmware/efi/esrt.c | 2 +-
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 9291480..8c3ebcb 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -389,7 +389,6 @@ int __init efi_mem_desc_lookup(u64 phys_addr, efi_memory_desc_t *out_md)
>  			return 0;
>  		}
>  	}
> -	pr_err_once("requested map not found.\n");
>  	return -ENOENT;
>  }
>  
> diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
> index 1491407..d81560f 100644
> --- a/drivers/firmware/efi/esrt.c
> +++ b/drivers/firmware/efi/esrt.c
> @@ -254,7 +254,7 @@ void __init efi_esrt_init(void)
>  
>  	rc = efi_mem_desc_lookup(efi.esrt, &md);
>  	if (rc < 0) {
> -		pr_err("ESRT header is not in the memory map.\n");
> +		pr_warn("ESRT header is not in the memory map.\n");
>  		return;
>  	}
>  
> -- 
> 2.9.3
> 

-- 
        Peter
