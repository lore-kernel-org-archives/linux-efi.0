From: Lenny Szubowicz <lszubowi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/10] Add additional security checks when module loading
 is restricted
Date: Wed, 28 Aug 2013 18:37:43 -0400 (EDT)
Message-ID: <1241952070.8587861.1377729463830.JavaMail.root@redhat.com>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376933171-9854-1-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-efi@vger.kernel.org



----- Original Message -----
> From: "Matthew Garrett" <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
> Sent: Monday, August 19, 2013 1:26:01 PM
> Subject: [PATCH 0/10] Add additional security checks when module loading is restricted
> 
> We have two in-kernel mechanisms for restricting module loading - disabling
> it entirely, or limiting it to the loading of modules signed with a trusted
> key. These can both be configured in such a way that even root is unable to
> relax the restrictions.
> 
> However, right now, there's several other straightforward ways for root to
> modify running kernel code. At the most basic level these allow root to
> reset the configuration such that modules can be loaded again, rendering
> the existing restrictions useless.
> 
> This patchset adds additional restrictions to various kernel entry points
> that would otherwise make it straightforward for root to disable enforcement
> of module loading restrictions. It also provides a patch that allows the
> kernel to be configured such that module signing will be automatically
> enabled when the system is booting via UEFI Secure Boot, allowing a stronger
> guarantee of kernel integrity.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Did you purposely exclude similar checks for hibernate that were covered
by earlier versions of your patch set?

I think you should include it and any patch set that attempts to add support
for doing hibernate securely would make appropriate changes.

                              -Lenny.
