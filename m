From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2] x86, boot: Allow 64bit EFI kernel to be loaded above
 4G
Date: Wed, 25 Feb 2015 11:31:32 +0100
Message-ID: <20150225103132.GB554@gmail.com>
References: <1424663028-13066-1-git-send-email-yinghai@kernel.org>
 <20150224215501.GB9758@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150224215501.GB9758@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt.fleming@intel.com>, Kees Cook <keescook@chromium.org>, Junjie Mao <eternal.n08@gmail.com>, linux-doc@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt@codeblueprint.co.uk> wrote:

> On Sun, 22 Feb, at 07:43:48PM, Yinghai Lu wrote:
> > Index: linux-2.6/arch/x86/boot/header.S
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/boot/header.S
> > +++ linux-2.6/arch/x86/boot/header.S
> > @@ -301,7 +301,7 @@ _start:
> >  	# Part 2 of the header, from the old setup.S
> >  
> >  		.ascii	"HdrS"		# header signature
> > -		.word	0x020d		# header version number (>= 0x0105)
> > +		.word	0x020e		# header version number (>= 0x0105)
> >  					# or else old loadlin-1.5 will fail)
> >  		.globl realmode_swtch
> >  realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
> > @@ -449,6 +449,7 @@ pref_address:		.quad LOAD_PHYSICAL_ADDR
> >  #endif
> >  init_size:		.long INIT_SIZE		# kernel initialization size
> >  handover_offset:	.long 0			# Filled in by build.c
> > +ext_code32_start:	.long 0			# werid one!
>   
> How about a comment like, "# Upper 32-bits of code32_start" ?

Also, in the Linux kernel we should not go about inventing 
new English words like 'werid', right?

Thanks,

	Ingo
