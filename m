From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] x86/efi-bgrt: Switch all pr_err() to pr_notice() for
 invalid BGRT
Date: Tue, 3 May 2016 20:02:13 +0100
Message-ID: <20160503190213.GC2839@codeblueprint.co.uk>
References: <1462297624-3003-1-git-send-email-jwboyer@fedoraproject.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1462297624-3003-1-git-send-email-jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 03 May, at 01:47:04PM, Josh Boyer wrote:
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
> Signed-off-by: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
> ---
> 
> v2: Switch to using pr_notice instead of pr_debug
> 
>  arch/x86/platform/efi/efi-bgrt.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>

Applied. Thanks everyone!
