From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 05/27] kexec: Disable at runtime if the kernel is locked
 down
Date: Fri, 20 Oct 2017 14:38:37 +0800
Message-ID: <20171020063837.GN3285@linux-l9pv.suse>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
 <150842466996.7923.17995994984545441369.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <150842466996.7923.17995994984545441369.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 19, 2017 at 03:51:09PM +0100, David Howells wrote:
> From: Matthew Garrett <matthew.garrett@nebula.com>
> 
> kexec permits the loading and execution of arbitrary code in ring 0, which
> is something that lock-down is meant to prevent. It makes sense to disable
> kexec in this situation.
> 
> This does not affect kexec_file_load() which can check for a signature on the
> image to be booted.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Dave Young <dyoung@redhat.com>

I have reviewed and tested this patch. Please feel free to add:

Reviewed-by: "Lee, Chun-Yi" <jlee@suse.com>

Thanks a lot!
Joey Lee

> cc: kexec@lists.infradead.org
> ---
> 
>  kernel/kexec.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index e62ec4dc6620..7dadfed9b676 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -202,6 +202,13 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
>  		return -EPERM;
>  
>  	/*
> +	 * kexec can be used to circumvent module loading restrictions, so
> +	 * prevent loading in that case
> +	 */
> +	if (kernel_is_locked_down("kexec of unsigned images"))
> +		return -EPERM;
> +
> +	/*
>  	 * Verify we have a legal set of flags
>  	 * This leaves us room for future extensions.
>  	 */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
