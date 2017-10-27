From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 03/27] Enforce module signatures if the kernel is locked
 down
Date: Fri, 27 Oct 2017 14:48:15 -0400
Message-ID: <1509130095.3716.13.camel@linux.vnet.ibm.com>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
         <150842465546.7923.6762214527898273559.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <150842465546.7923.6762214527898273559.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>, linux-security-module@vger.kernel.org
Cc: gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

On Thu, 2017-10-19 at 15:50 +0100, David Howells wrote:
> If the kernel is locked down, require that all modules have valid
> signatures that we can verify.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  kernel/module.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index de66ec825992..3d9a3270c179 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2781,7 +2781,8 @@ static int module_sig_check(struct load_info *info, int flags)
>  	}
> 
>  	/* Not having a signature is only an error if we're strict. */
> -	if (err == -ENOKEY && !sig_enforce)
> +	if (err == -ENOKEY && !sig_enforce &&
> +	    !kernel_is_locked_down("Loading of unsigned modules"))
 
This kernel_is_locked_down() check is being called for both the
original and new module_load syscalls.  We need to be able
differentiate them.  This is fine for the original syscall, but for
the new syscall we would need an additional IMA check -
!is_ima_appraise_enabled().

Mimi
 
>  		err = 0;
> 
>  	return err;

