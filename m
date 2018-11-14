From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v11 3/5] x86/boot: Add get_acpi_rsdp() to parse RSDP in
 cmdlien from kexec
Date: Wed, 14 Nov 2018 19:30:17 +0100
Message-ID: <20181114183016.GI13926@zn.tnic>
References: <20181112094645.4879-1-fanc.fnst@cn.fujitsu.com>
 <20181112094645.4879-4-fanc.fnst@cn.fujitsu.com>
 <20181112174343.mvjri2okwboew2nw@gabell>
 <20181113021218.GD7453@localhost.localdomain>
 <20181113161111.6jwm36fpxk5xjtn5@gabell>
 <20181113175413.GL10502@zn.tnic>
 <20181113200615.7dypqvhimxzlloek@gabell>
 <20181113215156.GP10502@zn.tnic>
 <20181114061215.GC2875@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181114061215.GC2875@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Chao Fan <fanc.fnst@cn.fujitsu.com>
Cc: Masayoshi Mizuma <msys.mizuma@gmail.com>, linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 14, 2018 at 02:12:16PM +0800, Chao Fan wrote:
> But isdigit() would be redefine, so:
> 
> diff --git a/include/linux/ctype.h b/include/linux/ctype.h
> index 363b004426db..aba01c385232 100644
> --- a/include/linux/ctype.h
> +++ b/include/linux/ctype.h
> @@ -23,10 +23,12 @@ extern const unsigned char _ctype[];
>  #define isalnum(c)     ((__ismask(c)&(_U|_L|_D)) != 0)
>  #define isalpha(c)     ((__ismask(c)&(_U|_L)) != 0)
>  #define iscntrl(c)     ((__ismask(c)&(_C)) != 0)
> +#ifndef BOOT_STRING
>  static inline int isdigit(int c)
>  {
>         return '0' <= c && c <= '9';
>  }
> +#endif
>  #define isgraph(c)     ((__ismask(c)&(_P|_U|_L|_D)) != 0)
>  #define islower(c)     ((__ismask(c)&(_L)) != 0)
>  #define isprint(c)     ((__ismask(c)&(_P|_U|_L|_D|_SP)) != 0)
> 
> Now I can make it.
> I wonder whether this is OK to cover isdigit() with 'BOOT_STRING' tag.

See the beginning of arch/x86/boot/compressed/kaslr.c for a possible way
to disable boot/ctype.h

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
