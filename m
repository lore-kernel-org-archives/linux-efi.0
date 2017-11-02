From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 03/27] Enforce module signatures if the kernel is locked
 down
Date: Thu, 02 Nov 2017 15:13:51 -0400
Message-ID: <1509650031.3507.20.camel@linux.vnet.ibm.com>
References: <1509130095.3716.13.camel@linux.vnet.ibm.com>
         <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
         <150842465546.7923.6762214527898273559.stgit@warthog.procyon.org.uk>
         <20240.1509643356@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20240.1509643356@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

On Thu, 2017-11-02 at 17:22 +0000, David Howells wrote:

>  #ifdef CONFIG_MODULE_SIG
> -static int module_sig_check(struct load_info *info, int flags)
> +static int module_sig_check(struct load_info *info, int flags,
> +			    bool can_do_ima_check)
>  {
>  	int err = -ENOKEY;
>  	const unsigned long markerlen = sizeof(MODULE_SIG_STRING) - 1;
> @@ -2781,13 +2783,16 @@ static int module_sig_check(struct load_info *info, int flags)
>  	}
>  
>  	/* Not having a signature is only an error if we're strict. */
> -	if (err == -ENOKEY && !sig_enforce)
> +	if (err == -ENOKEY && !sig_enforce &&
> +	    (!can_do_ima_check || !is_ima_appraise_enabled()) &&
> +	    !kernel_is_locked_down("Loading of unsigned modules"))

By this point, IMA-appraisal has already verified the kernel module
signature back in kernel_read_file_from_fd(), if it was required.
 Having a key with which to verify the appended signature or requiring
an appended signature, should not be required as well.

Mimi
