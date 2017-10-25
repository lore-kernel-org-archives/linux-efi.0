From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 12/27] x86/msr: Restrict MSR access when the kernel is
 locked down
Date: Wed, 25 Oct 2017 22:03:29 +0800
Message-ID: <20171025140329.GI8550@linux-l9pv.suse>
References: <20171020190939.569cedd2@alans-desktop>
 <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
 <150842472452.7923.2592278090192179002.stgit@warthog.procyon.org.uk>
 <21023.1508770184@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <21023.1508770184@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

Hi David, 

On Mon, Oct 23, 2017 at 03:49:44PM +0100, David Howells wrote:
> Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:
> 
> > There are a load of standard tools that use this so I think you are going
> > to need a whitelist. Can you at least log *which* MSR in the failing case
> > so a whitelist can be built over time ?
> 
> Will the attached change work for you?
> 

It's good to me.

Joey Lee

> ---
> diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
> index a05a97863286..f18cadbc31ce 100644
> --- a/arch/x86/kernel/msr.c
> +++ b/arch/x86/kernel/msr.c
> @@ -84,8 +84,10 @@ static ssize_t msr_write(struct file *file, const char __user *buf,
>  	int err = 0;
>  	ssize_t bytes = 0;
>  
> -	if (kernel_is_locked_down("Direct MSR access"))
> +	if (kernel_is_locked_down("Direct MSR access")) {
> +		pr_info("Direct access to MSR %x\n", reg);
>  		return -EPERM;
> +	}
>  
>  	if (count % 8)
>  		return -EINVAL;	/* Invalid chunk size */
> @@ -135,6 +137,7 @@ static long msr_ioctl(struct file *file, unsigned int ioc, unsigned long arg)
>  			break;
>  		}
>  		if (kernel_is_locked_down("Direct MSR access")) {
> +			pr_info("Direct access to MSR %x\n", reg[1]); /* Display %ecx */
>  			err = -EPERM;
>  			break;
>  		}
