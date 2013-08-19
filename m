From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/10] Add additional security checks when module loading is restricted
Date: Mon, 19 Aug 2013 13:26:01 -0400
Message-ID: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
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
