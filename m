From: Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v9 1/8] x86/boot: Introduce cmdline_find_option_arg()to
 detect if option=arg in cmdline
Date: Thu, 18 Oct 2018 12:01:20 +0800
Message-ID: <20181018040120.GB1885@192.168.1.4>
References: <20181017102012.872-1-fanc.fnst@cn.fujitsu.com>
 <20181017102012.872-2-fanc.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181017102012.872-2-fanc.fnst@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chao Fan <fanc.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, msys.mizuma@gmail.com, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On 10/17/18 at 06:20pm, Chao Fan wrote:
> +bool cmdline_find_option_arg(const char *option, const char *arg, int argsize)
> +{
> +	char *buffer = malloc(argsize+1);
> +	bool find = false;
> +	int ret;
> +
> +	ret = cmdline_find_option(option, buffer, argsize+1);
> +	if (ret == argsize && !strncmp(buffer, arg, argsize))
> +		find = true;

Wondering if we really need a wrapper like this. 

> +
> +	free(buffer);
> +	return find;
> +}
>  
>  #endif
> diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
> index a1d5918765f3..008fdc47a29c 100644
> --- a/arch/x86/boot/compressed/misc.h
> +++ b/arch/x86/boot/compressed/misc.h
> @@ -67,6 +67,7 @@ static inline void debug_puthex(const char *s)
>  /* cmdline.c */
>  int cmdline_find_option(const char *option, char *buffer, int bufsize);
>  int cmdline_find_option_bool(const char *option);
> +bool cmdline_find_option_arg(const char *option, const char *arg, int argsize);
>  #endif
>  
>  
> -- 
> 2.17.2
> 
> 
> 
