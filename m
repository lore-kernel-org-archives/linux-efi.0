From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] x86, boot: Allow 64bit EFI kernel to be loaded above
 4G
Date: Wed, 25 Feb 2015 12:57:27 +0000
Message-ID: <20150225125727.GD9758@codeblueprint.co.uk>
References: <1424663028-13066-1-git-send-email-yinghai@kernel.org>
 <20150224215501.GB9758@codeblueprint.co.uk>
 <20150225103132.GB554@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150225103132.GB554-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Junjie Mao <eternal.n08-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 25 Feb, at 11:31:32AM, Ingo Molnar wrote:
> 
> * Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> 
> > On Sun, 22 Feb, at 07:43:48PM, Yinghai Lu wrote:
> > > Index: linux-2.6/arch/x86/boot/header.S
> > > ===================================================================
> > > --- linux-2.6.orig/arch/x86/boot/header.S
> > > +++ linux-2.6/arch/x86/boot/header.S
> > > @@ -301,7 +301,7 @@ _start:
> > >  	# Part 2 of the header, from the old setup.S
> > >  
> > >  		.ascii	"HdrS"		# header signature
> > > -		.word	0x020d		# header version number (>= 0x0105)
> > > +		.word	0x020e		# header version number (>= 0x0105)
> > >  					# or else old loadlin-1.5 will fail)
> > >  		.globl realmode_swtch
> > >  realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
> > > @@ -449,6 +449,7 @@ pref_address:		.quad LOAD_PHYSICAL_ADDR
> > >  #endif
> > >  init_size:		.long INIT_SIZE		# kernel initialization size
> > >  handover_offset:	.long 0			# Filled in by build.c
> > > +ext_code32_start:	.long 0			# werid one!
> >   
> > How about a comment like, "# Upper 32-bits of code32_start" ?
> 
> Also, in the Linux kernel we should not go about inventing 
> new English words like 'werid', right?

Yeah, my intention is to replace "werid one" with the comment I
suggested above.

-- 
Matt Fleming, Intel Open Source Technology Center
