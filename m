From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: (unknown)
Date: Tue,  3 Sep 2013 19:50:07 -0400
Message-ID: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Subject: 
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

We have two in-kernel mechanisms for restricting module loading - disabling
it entirely, or limiting it to the loading of modules signed with a trusted
key. These can both be configured in such a way that even root is unable to
relax the restrictions.

However, right now, there's several other straightforward ways for root to
modify running kernel code. At the most basic level these allow root to
reset the configuration such that modules can be loaded again, rendering
the existing restrictions useless.

This patchset adds additional restrictions to various kernel entry points
that would otherwise make it straightforward for root to disable enforcement
of module loading restrictions. It also provides a patch that allows the
kernel to be configured such that module signing will be automatically
enabled when the system is booting via UEFI Secure Boot, allowing a stronger
guarantee of kernel integrity.

V3 addresses some review feedback and also locks down uswsusp.
