From: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 10/10] Add option to automatically enforce module
 signatures when in Secure Boot mode
Date: Fri, 30 Aug 2013 19:41:33 -0400
Message-ID: <20130830234133.GR20828@hansolo.jdub.homelinux.org>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
 <1376933171-9854-11-git-send-email-matthew.garrett@nebula.com>
 <20130829183713.GT20828@hansolo.jdub.homelinux.org>
 <522104A6.5000700@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <522104A6.5000700-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Aug 30, 2013 at 01:46:30PM -0700, H. Peter Anvin wrote:
> On 08/29/2013 11:37 AM, Josh Boyer wrote:
> >>  	setup_efi_pci(boot_params);
> >> diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
> >> index c15ddaf..d35da96 100644
> >> --- a/arch/x86/include/uapi/asm/bootparam.h
> >> +++ b/arch/x86/include/uapi/asm/bootparam.h
> >> @@ -131,7 +131,8 @@ struct boot_params {
> >>  	__u8  eddbuf_entries;				/* 0x1e9 */
> >>  	__u8  edd_mbr_sig_buf_entries;			/* 0x1ea */
> >>  	__u8  kbd_status;				/* 0x1eb */
> >> -	__u8  _pad5[3];					/* 0x1ec */
> >> +	__u8  secure_boot;				/* 0x1ec */
> >> +	__u8  _pad5[2];					/* 0x1ec */
> >>  	/*
> >>  	 * The sentinel is set to a nonzero value (0xff) in header.S.
> >>  	 *
> > 
> > You need to include the following chunk of code with this, otherwise the
> > secure_boot variable gets cleared.
> > 
> 
> Not really.
> 
> There are three cases:
> 
> 1. Boot stub only.  Here we do the right thing with the bootparams.
> 2. Boot loader bypasses the boot stub completely.  Here we MUST NOT do
>    what you suggest above.
> 3. Boot stub with a boot_params structure passed in.  Here we should
>    run sanitize_boot_params() (an inline for a reason) in the boot
>    stub, before we set the secure_boot field.  Once that is done, we
>    again don't need that modification.

OK.  If 3 works, then great.  All I know is that Fedora has been
carrying the above hunk for months and it was missing in this patch set.
So when I went to test it, the patches didn't do anything because the
secure_boot field was getting cleared.

I'm more than happy to try option 3, and I'll poke at it next week
unless someone beats me to it.

josh
