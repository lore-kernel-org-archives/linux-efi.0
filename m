From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH v2] x86/efi-bgrt: Switch all pr_err() to pr_notice() for
 invalid BGRT
Date: Tue, 3 May 2016 13:16:39 -0700
Message-ID: <20160503201639.GA29271@x>
References: <1462297624-3003-1-git-send-email-jwboyer@fedoraproject.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462297624-3003-1-git-send-email-jwboyer@fedoraproject.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, May 03, 2016 at 01:47:04PM -0400, Josh Boyer wrote:
> The promise of pretty boot splashes from firmware via BGRT was at
> best only that; a promise.  The kernel diligently checks to make
> sure the BGRT data firmware gives it is valid, and dutifully warns
> the user when it isn't.  However, it does so via the pr_err log
> level which seems unnecessary.  The user cannot do anything about
> this and there really isn't an error on the part of Linux to
> correct.
> 
> This lowers the log level by using pr_notice instead.  Users will
> no longer have their boot process uglified by the kernel reminding
> us that firmware can and often is broken when the 'quiet' kernel
> parameter is specified.  Ironic, considering BGRT is supposed to
> make boot pretty to begin with.
> 
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>

Whitespace nit below that I missed on my initial review.  I don't think
it's worth holding up the patch queue for.

> --- a/arch/x86/platform/efi/efi-bgrt.c
> +++ b/arch/x86/platform/efi/efi-bgrt.c
> @@ -43,40 +43,40 @@ void __init efi_bgrt_init(void)
>  		return;
>  
>  	if (bgrt_tab->header.length < sizeof(*bgrt_tab)) {
> -		pr_err("Ignoring BGRT: invalid length %u (expected %zu)\n",
> +		pr_notice("Ignoring BGRT: invalid length %u (expected %zu)\n",
>  		       bgrt_tab->header.length, sizeof(*bgrt_tab));

On this and other lines with continuations, the continuation line was
indented to match the 'pr_err('; changing that to 'pr_notice(' makes
that continuation indentation no longer make sense.  Perhaps it should
change to a single tab, rather than attempting to line up with the start
of the first argument?

- Josh Triplett
