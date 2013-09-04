From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re:
Date: Wed, 4 Sep 2013 08:53:35 -0700
Message-ID: <CAGXu5jLCTU1MG4fYDzpT=TAP9DRAUuRuhZNB+edJsOzN4iXbDw@mail.gmail.com>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378252218-18798-1-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Sep 3, 2013 at 4:50 PM, Matthew Garrett
<matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org> wrote:
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
> V3 addresses some review feedback and also locks down uswsusp.

Looks good to me. Consider the entire series:

Acked-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

-Kees

-- 
Kees Cook
Chrome OS Security
