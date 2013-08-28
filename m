From: Lenny Szubowicz <lszubowi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/10] Add additional security checks when module loading
 is restricted
Date: Wed, 28 Aug 2013 18:58:12 -0400 (EDT)
Message-ID: <761791749.8594444.1377730692707.JavaMail.root@redhat.com>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com> <1241952070.8587861.1377729463830.JavaMail.root@redhat.com> <1377729714.27493.2.camel@x230>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1377729714.27493.2.camel@x230>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-efi@vger.kernel.org



----- Original Message -----
> From: "Matthew Garrett" <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> To: "Lenny Szubowicz" <lszubowi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
> Sent: Wednesday, August 28, 2013 6:41:55 PM
> Subject: Re: [PATCH 0/10] Add additional security checks when module loading is restricted
> 
> On Wed, 2013-08-28 at 18:37 -0400, Lenny Szubowicz wrote:
> 
> > Did you purposely exclude similar checks for hibernate that were covered
> > by earlier versions of your patch set?
> 
> Yes, I think it's worth tying it in with the encrypted hibernation
> support. The local attack is significantly harder in the hibernation
> case - in the face of unknown hardware it basically involves a
> pre-generated memory image corresponding to your system or the ability
> to force a reboot into an untrusted environment. I think it's probably
> more workable to just add a configuration option for forcing encrypted
> hibernation when secure boot is in use.
> 
> --
> Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>

I'm root. So I can write anything I want to the swap file that looks
like a valid hibernate image but is code of my choosing. I can read
anything I need from /dev/mem or /dev/kmem to help me do that.
I can then immediately initiate a reboot.

                               -Lenny.
