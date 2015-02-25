From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] x86, boot: Allow 64bit EFI kernel to be loaded above
 4G
Date: Wed, 25 Feb 2015 12:57:44 +0000
Message-ID: <20150225125744.GE9758@codeblueprint.co.uk>
References: <1424663028-13066-1-git-send-email-yinghai@kernel.org>
 <20150224215501.GB9758@codeblueprint.co.uk>
 <CAE9FiQW8qRw76Q9R0YqmXVPC_scNNYc440_XoDVrLNRc+OxOhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQW8qRw76Q9R0YqmXVPC_scNNYc440_XoDVrLNRc+OxOhQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Junjie Mao <eternal.n08-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 24 Feb, at 04:31:27PM, Yinghai Lu wrote:
> On Tue, Feb 24, 2015 at 1:55 PM, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> > On Sun, 22 Feb, at 07:43:48PM, Yinghai Lu wrote:
> >> +Field name:  ext_code32_start
> >> +Type:                modify (optional, reloc)
> >> +Offset/size: 0x268/4
> >> +Protocol:    2.14+
> >> +
> >> +  This field is the upper 32bits of load address when EFI 64bit kernel
> >> +  is loaded above 4G. And it is used with code32_start to compare to
> >> +  pref_address to decide if kernel need to be relocated further.
> >
> > I think we can delete the second sentence.
> >
> > But these are minimal changes and I'm happy to fix them up when applying
> > this patch if that's OK?
> 
> Sure. Please go ahead.

Applied, thanks Yinghai.

-- 
Matt Fleming, Intel Open Source Technology Center
